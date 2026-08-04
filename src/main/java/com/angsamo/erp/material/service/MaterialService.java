package com.angsamo.erp.material.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.material.mapper.MaterialMapper;

@Service
public class MaterialService {
	private static final List<String> RETURN_STATUSES = List.of("REQUESTED", "RESUPPLYING", "COMPLETED");
	private final MaterialMapper mapper;

	public MaterialService(MaterialMapper mapper) { this.mapper = mapper; }

	@Transactional(readOnly = true) public List<Map<String, Object>> purchaseOrders() { return mapper.findPurchaseOrders(); }
	@Transactional(readOnly = true) public List<Map<String, Object>> pendingShipments() { return mapper.findPendingShipments(); }
	@Transactional(readOnly = true) public List<Map<String, Object>> receivings() { return mapper.findReceivings(); }
	@Transactional(readOnly = true) public List<Map<String, Object>> returns() { return mapper.findReturns(); }
	@Transactional(readOnly = true) public List<Map<String, Object>> inventory() { return mapper.findInventory(); }
	@Transactional(readOnly = true) public List<Map<String, Object>> issues(String fromDate, String toDate, String itemCode, String status) { return mapper.findIssues(fromDate, toDate, itemCode, status); }
	@Transactional(readOnly = true) public List<Map<String, Object>> inventoryValueReport(String fromDate, String toDate, String itemCode) { return mapper.findInventoryValueReport(fromDate, toDate, itemCode); }
	@Transactional(readOnly = true) public List<Map<String, Object>> statements() { return mapper.findStatements(); }
	@Transactional(readOnly = true) public List<Map<String, Object>> orderReport(String fromDate, String toDate, String status, String keyword) { return mapper.findOrderReport(fromDate, toDate, status, keyword); }
	@Transactional(readOnly = true) public List<Map<String, Object>> closeReadyOrders() { return mapper.findCloseReadyOrders(); }
	@Transactional(readOnly = true) public Map<String, Object> statementPrint(long id) { return required(mapper.findStatementPrint(id), "거래명세서를 찾을 수 없습니다."); }

	@Transactional
	public void inspect(long shipmentId, int acceptedQty, int rejectedQty, String reason,
			boolean orderConfirmed, boolean itemChecked, boolean qualityChecked, long userId) {
		if (!orderConfirmed || !itemChecked || !qualityChecked) {
			throw new IllegalArgumentException("발주서, 실물 품목, 품질 상태를 모두 확인해야 검수를 완료할 수 있습니다.");
		}
		if (acceptedQty < 0 || rejectedQty < 0 || acceptedQty + rejectedQty <= 0) throw new IllegalArgumentException("검수 수량을 확인해 주세요.");
		Map<String, Object> shipment = required(mapper.lockShipment(shipmentId), "출하 정보를 찾을 수 없습니다.");
		if (((Number) shipment.get("alreadyReceived")).intValue() > 0) throw new IllegalStateException("이미 입고 검수가 완료된 출하입니다.");
		int shipmentQty = ((Number) shipment.get("shipmentQty")).intValue();
		if (acceptedQty + rejectedQty != shipmentQty) throw new IllegalArgumentException("정상 수량과 불량 수량의 합은 출하 수량과 같아야 합니다.");
		if (rejectedQty > 0 && (reason == null || reason.isBlank())) throw new IllegalArgumentException("불량 수량이 있으면 반품 사유를 입력해 주세요.");
		long poId = ((Number) shipment.get("poId")).longValue();
		String result = rejectedQty > 0 ? "RETURNED" : "ACCEPTED";
		mapper.insertReceiving(shipmentId, poId, result, shipmentQty, acceptedQty, rejectedQty, reason, userId);
		long receivingId = mapper.lastInsertId();
		String itemCode = String.valueOf(shipment.get("itemCode"));
		if (acceptedQty > 0) {
			Map<String, Object> inventory = mapper.lockInventory(itemCode);
			int before = inventory == null ? 0 : ((Number) inventory.get("availableQty")).intValue();
			mapper.upsertInventory(itemCode, acceptedQty, shipment.get("supplyPrice"));
			mapper.insertInventoryHistory(itemCode, acceptedQty, before, before + acceptedQty, receivingId, userId);
		}
		if (rejectedQty > 0) mapper.insertReturn(receivingId, String.valueOf(shipment.get("vendorId")), itemCode, rejectedQty, reason.trim(), userId);
		mapper.updatePoProgress(poId);
		mapper.completeProcurementPlan(poId);
	}

	@Transactional
	public void changeReturnStatus(long returnId, String status) {
		if (!RETURN_STATUSES.contains(status)) throw new IllegalArgumentException("올바르지 않은 반품 상태입니다.");
		if (mapper.updateReturnStatus(returnId, status) != 1) throw new IllegalArgumentException("반품 정보를 찾을 수 없습니다.");
	}

	@Transactional
	public void processIssue(long issueId, int qty, long userId) {
		if (qty <= 0) throw new IllegalArgumentException("출고 수량은 1개 이상이어야 합니다.");
		Map<String, Object> row = required(mapper.lockIssue(issueId), "출고 요청을 찾을 수 없습니다.");
		if ("COMPLETED".equals(row.get("status"))) throw new IllegalStateException("이미 완료된 출고 요청입니다.");
		int requested = ((Number) row.get("releaseQty")).intValue();
		int issued = ((Number) row.get("issueQty")).intValue();
		int available = ((Number) row.get("availableQty")).intValue();
		if (qty > requested - issued) throw new IllegalArgumentException("남은 요청 수량보다 많이 출고할 수 없습니다.");
		if (qty > available) throw new IllegalArgumentException("가용 재고가 부족합니다. 현재고: " + available);
		int totalIssued = issued + qty;
		String status = totalIssued == requested ? "COMPLETED" : "PARTIAL";
		String itemCode = String.valueOf(row.get("itemCode"));
		if (mapper.decreaseInventory(itemCode, qty, row.get("unitPrice")) != 1) throw new IllegalStateException("재고 차감 중 수량이 변경되었습니다. 다시 확인해 주세요.");
		mapper.updateIssue(issueId, qty, status, userId);
		mapper.insertIssueInventoryHistory(itemCode, qty, available, available - qty, issueId, userId);
		if (row.get("requestId") != null) mapper.updateProductionRequest(((Number) row.get("requestId")).longValue(), status);
	}

	@Transactional
	public void issueStatement(long receivingId) {
		Map<String, Object> row = required(mapper.findStatementCandidate(receivingId), "발행 가능한 입고 건이 아닙니다.");
		if (row.get("contractId") == null) throw new IllegalStateException("해당 발주에 연결된 계약이 없어 거래명세서를 발행할 수 없습니다.");
		mapper.insertStatementPrep(((Number) row.get("contractId")).longValue());
		long prepId = mapper.lastInsertId();
		mapper.insertStatement(receivingId, prepId, String.valueOf(row.get("vendorId")),
				((Number) row.get("acceptedQty")).intValue(), row.getOrDefault("supplyPrice", BigDecimal.ZERO));
	}

	@Transactional public void notifyStatement(long id) { if (mapper.notifyStatement(id) != 1) throw new IllegalArgumentException("거래명세서를 찾을 수 없습니다."); }
	@Transactional public void closeOrder(long poId) { if (mapper.closePurchaseOrder(poId) != 1) throw new IllegalStateException("입고와 거래명세서 발행이 완료된 발주만 마감할 수 있습니다."); }

	private Map<String, Object> required(Map<String, Object> value, String message) { if (value == null) throw new IllegalArgumentException(message); return value; }
}
