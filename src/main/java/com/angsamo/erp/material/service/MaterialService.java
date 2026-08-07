package com.angsamo.erp.material.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.material.dto.MaterialInventoryItem;
import com.angsamo.erp.material.dto.StockMovementItem;
import com.angsamo.erp.material.mapper.MaterialMapper;

@Service
public class MaterialService {
    private static final List<String> RETURN_STATUSES = List.of("RETURN_REQUESTED", "RESUPPLYING", "RETURN_COMPLETED");
    private final MaterialMapper mapper;

    public MaterialService(MaterialMapper mapper) { this.mapper = mapper; }

    @Transactional(readOnly = true) public List<Map<String, Object>> purchaseOrders() { return mapper.findPurchaseOrders(); }
    @Transactional(readOnly = true) public List<Map<String, Object>> pendingShipments() { return mapper.findPendingShipments(); }
    @Transactional(readOnly = true) public List<Map<String, Object>> receivings() { return mapper.findReceivings(); }
    @Transactional(readOnly = true) public List<Map<String, Object>> returns() { return mapper.findReturns(); }
    @Transactional(readOnly = true) public List<MaterialInventoryItem> inventory() { return mapper.findInventory(null, null); }
    @Transactional(readOnly = true) public List<MaterialInventoryItem> inventory(String keyword, BigDecimal maxQty) {
        if (maxQty != null && maxQty.signum() < 0) throw new IllegalArgumentException("부족 기준 수량은 0 이상이어야 합니다.");
        return mapper.findInventory(normalize(keyword), maxQty);
    }
    @Transactional(readOnly = true) public List<Map<String, Object>> activeMaterials() { return mapper.findActiveMaterials(); }
    @Transactional(readOnly = true) public List<StockMovementItem> recentStockMovements() { return mapper.findRecentStockMovements(null); }
    @Transactional(readOnly = true) public List<StockMovementItem> recentStockMovements(String movementType) {
        String normalized = normalize(movementType);
        if (normalized != null) {
            normalized = normalized.toUpperCase();
            if (!List.of("IN", "OUT", "RETURN", "ADJUST").contains(normalized)) throw new IllegalArgumentException("올바르지 않은 입출고 유형입니다.");
        }
        return mapper.findRecentStockMovements(normalized);
    }
    @Transactional(readOnly = true) public List<Map<String, Object>> issues(String fromDate, String toDate, String itemCode, String status) { return mapper.findIssues(fromDate, toDate, itemCode, status); }
    @Transactional(readOnly = true) public List<Map<String, Object>> inventoryValueReport(String fromDate, String toDate, String itemCode) { return mapper.findInventoryValueReport(fromDate, toDate, itemCode); }
    @Transactional(readOnly = true) public List<Map<String, Object>> statements() { return mapper.findStatements(); }
    @Transactional(readOnly = true) public List<Map<String, Object>> orderReport(String fromDate, String toDate, String status, String keyword) { return mapper.findOrderReport(fromDate, toDate, status, keyword); }
    @Transactional(readOnly = true) public List<Map<String, Object>> closeReadyOrders() { return mapper.findCloseReadyOrders(); }
    @Transactional(readOnly = true) public Map<String, Object> statementPrint(long id) { return required(mapper.findStatementPrint(id), "거래명세서를 찾을 수 없습니다."); }

    @Transactional
    public void inspectResult(long procurementId, int receivedQty, String inspectionResult, String reason,
            boolean orderConfirmed, boolean itemChecked, boolean qualityChecked, long userId) {
        if (!"ACCEPTED".equals(inspectionResult) && !"RETURNED".equals(inspectionResult)) {
            throw new IllegalArgumentException("검사 결과는 정상 입고 또는 반품만 선택할 수 있습니다.");
        }
        inspect(procurementId, "ACCEPTED".equals(inspectionResult) ? receivedQty : 0,
                "RETURNED".equals(inspectionResult) ? receivedQty : 0, reason,
                orderConfirmed, itemChecked, qualityChecked, userId);
    }

    @Transactional
    public void inspect(long procurementId, int acceptedQty, int rejectedQty, String reason,
            boolean orderConfirmed, boolean itemChecked, boolean qualityChecked, long userId) {
        if (!orderConfirmed || !itemChecked || !qualityChecked) throw new IllegalArgumentException("발주, 품목, 품질 상태를 모두 확인해 주세요.");
        if (acceptedQty < 0 || rejectedQty < 0 || acceptedQty + rejectedQty <= 0) throw new IllegalArgumentException("검수 수량을 확인해 주세요.");
        Map<String, Object> procurement = required(mapper.lockShipment(procurementId), "조달 정보를 찾을 수 없습니다.");
        if (!"SHIPPED".equals(procurement.get("procurementStatus"))) throw new IllegalStateException("출하 완료된 조달 건만 입고 검사할 수 있습니다.");
        if (((Number) procurement.get("alreadyReceived")).intValue() > 0) throw new IllegalStateException("이미 입고 검수가 완료된 건입니다.");
        int orderQty = ((Number) procurement.get("shipmentQty")).intValue();
        if (acceptedQty + rejectedQty != orderQty) throw new IllegalArgumentException("정상 수량과 불량 수량의 합이 발주 수량과 같아야 합니다.");
        if (acceptedQty > 0 && rejectedQty > 0) throw new IllegalArgumentException("검사 결과는 정상 입고 또는 전체 반품 중 하나로 처리해 주세요.");
        if (rejectedQty > 0 && (reason == null || reason.isBlank())) throw new IllegalArgumentException("불량 수량이 있으면 반품 사유를 입력해 주세요.");
        String result = rejectedQty == 0 ? "ACCEPTED" : "RETURNED";
        if (mapper.completeReceiving(procurementId, result, acceptedQty, rejectedQty, reason) != 1) throw new IllegalStateException("입고 상태가 변경되었습니다.");
        if (acceptedQty > 0) {
            long departmentId = ((Number) procurement.get("departmentId")).longValue();
            long itemId = ((Number) procurement.get("itemId")).longValue();
            mapper.createInventoryIfAbsent(departmentId, itemId);
            if (mapper.adjustInventory(departmentId, itemId, BigDecimal.valueOf(acceptedQty)) != 1) {
                throw new IllegalStateException("입고 재고 반영에 실패했습니다.");
            }
            mapper.insertStockMovement(departmentId, itemId, "IN", BigDecimal.valueOf(acceptedQty),
                    "PROCUREMENT", procurementId, userId, null);
        }
    }

    @Transactional
    public void changeReturnStatus(long returnId, String status) {
        if (!RETURN_STATUSES.contains(status)) throw new IllegalArgumentException("올바르지 않은 반품 상태입니다.");
        if (mapper.updateReturnStatus(returnId, status) != 1) throw new IllegalArgumentException("반품 정보를 찾을 수 없습니다.");
    }

    @Transactional
    public void registerReturn(long returnId, int returnQty, String reason) {
        if (returnQty <= 0) throw new IllegalArgumentException("반품 수량은 0보다 커야 합니다.");
        if (reason == null || reason.isBlank()) throw new IllegalArgumentException("반품 사유를 입력해 주세요.");
        Map<String, Object> row = required(mapper.lockReturn(returnId), "반품 대상 입고 건을 찾을 수 없습니다.");
        if (!"RETURNED".equals(row.get("status"))) {
            throw new IllegalStateException("검수에서 반품 판정된 건만 반품 요청할 수 있습니다.");
        }
        int rejectedQty = ((Number) row.get("returnQty")).intValue();
        if (returnQty != rejectedQty) {
            throw new IllegalArgumentException("반품 수량은 검수 불량 수량과 같아야 합니다.");
        }
        if (mapper.requestReturn(returnId, reason.trim()) != 1) {
            throw new IllegalStateException("반품 상태가 변경되었습니다. 목록을 새로고침해 주세요.");
        }
    }

    @Transactional
    public void receiveReturn(long returnId, long userId) {
        Map<String, Object> row = required(mapper.lockShipment(returnId), "재입고 대상 건을 찾을 수 없습니다.");
        if (!"SHIPPED".equals(row.get("procurementStatus"))
                || !"RETURNED".equals(row.get("inspectionResult"))) {
            throw new IllegalStateException("보완 후 재출하된 반품 건만 재입고할 수 있습니다.");
        }
        int quantity = ((Number) row.get("shipmentQty")).intValue();
        inspect(returnId, quantity, 0, null, true, true, true, userId);
    }

    @Transactional
    public void approveIssue(long issueId, long userId) {
        Map<String, Object> row = required(mapper.lockIssue(issueId), "자재 요청을 찾을 수 없습니다.");
        if (!"REQUESTED".equals(row.get("status")) && !"SHORTAGE".equals(row.get("status"))) throw new IllegalStateException("요청 또는 재고 부족 상태만 승인할 수 있습니다.");
        requireActiveItem(row);
        String status = decimal(row.get("availableQty")).compareTo(decimal(row.get("releaseQty"))) >= 0 ? "APPROVED" : "SHORTAGE";
        if (mapper.changeIssueStatus(issueId, List.of("REQUESTED", "SHORTAGE"), status, userId) != 1) throw new IllegalStateException("다른 사용자가 먼저 요청 상태를 변경했습니다.");
    }

    @Transactional
    public void rejectIssue(long issueId, long userId) {
        if (mapper.changeIssueStatus(issueId, List.of("REQUESTED", "APPROVED", "SHORTAGE"), "REJECTED", userId) != 1) throw new IllegalStateException("반려할 수 없는 요청이거나 이미 처리된 요청입니다.");
    }

    @Transactional(noRollbackFor = InventoryShortageException.class)
    public void processIssue(long issueId, int qty, long userId) { processIssue(issueId, BigDecimal.valueOf(qty), userId); }

    @Transactional(noRollbackFor = InventoryShortageException.class)
    public void processIssue(long issueId, BigDecimal qty, long userId) {
        if (qty == null || qty.signum() <= 0) throw new IllegalArgumentException("불출 수량은 0보다 커야 합니다.");
        Map<String, Object> row = required(mapper.lockIssue(issueId), "자재 요청을 찾을 수 없습니다.");
        if (!"APPROVED".equals(row.get("status"))) throw new IllegalStateException("승인된 요청만 불출할 수 있습니다.");
        requireActiveItem(row);
        BigDecimal requested = decimal(row.get("releaseQty"));
        if (qty.compareTo(requested) != 0) throw new IllegalArgumentException("승인된 요청 수량 전체를 입력해 주세요.");
        Number inventoryDepartment = (Number) row.get("inventoryDepartmentId");
        if (inventoryDepartment == null) {
            throw new IllegalStateException("입고 완료된 조달 건의 재고 부서를 찾을 수 없습니다.");
        }
        // material_request.department_id는 생산 요청 부서이고 실제 차감 위치는 연결 조달의 부서이다.
        long inventoryDepartmentId = inventoryDepartment.longValue();
        long itemId = ((Number) row.get("itemId")).longValue();
        if (mapper.decreaseInventory(inventoryDepartmentId, itemId, qty) != 1) {
            mapper.changeIssueStatus(issueId, List.of("APPROVED"), "SHORTAGE", userId);
            throw new InventoryShortageException("재고가 부족하여 요청 상태를 재고 부족으로 변경했습니다.");
        }
        mapper.insertStockMovement(inventoryDepartmentId, itemId, "OUT", qty,
                "MATERIAL_REQUEST", issueId, userId, null);
        if (mapper.updateIssue(issueId, qty, "ISSUED", userId) != 1) throw new IllegalStateException("요청이 중복 처리되었습니다.");
    }

    @Transactional
    public void adjustInventory(long departmentId, long itemId, BigDecimal adjustmentQty, String memo, long userId) {
        if (adjustmentQty == null || adjustmentQty.signum() == 0) throw new IllegalArgumentException("조정 수량은 0이 아니어야 합니다.");
        if (memo == null || memo.isBlank()) throw new IllegalArgumentException("재고 조정 사유를 입력해 주세요.");
        mapper.createInventoryIfAbsent(departmentId, itemId);
        Map<String, Object> inventory = required(mapper.lockInventory(departmentId, itemId), "사용 가능한 자재 품목이 아닙니다.");
        requireActiveItem(inventory);
        if (mapper.adjustInventory(departmentId, itemId, adjustmentQty) != 1) throw new IllegalStateException("조정 결과가 음수가 되어 저장할 수 없습니다.");
        mapper.insertStockMovement(departmentId, itemId, adjustmentQty.signum() > 0 ? "IN" : "OUT",
                adjustmentQty.abs(), "INVENTORY_ADJUSTMENT", null, userId, memo.trim());
    }

    @Transactional public void issueStatement(long procurementId) { if (mapper.issueStatement(procurementId) != 1) throw new IllegalStateException("발행 가능한 입고 건이 아닙니다."); }
    @Transactional public void notifyStatement(long id) { if (mapper.notifyStatement(id) != 1) throw new IllegalArgumentException("거래명세서를 찾을 수 없습니다."); }
    @Transactional public void closeOrder(long poId) { if (mapper.closePurchaseOrder(poId) != 1) throw new IllegalStateException("입고 완료된 조달 건만 마감할 수 있습니다."); }

    private void requireActiveItem(Map<String, Object> row) {
        Object active = row.get("active");
        if (!(Boolean.TRUE.equals(active) || Integer.valueOf(1).equals(active) || Byte.valueOf((byte) 1).equals(active))) throw new IllegalStateException("사용 중지된 품목은 처리할 수 없습니다.");
    }

    private Map<String, Object> required(Map<String, Object> value, String message) {
        if (value == null) throw new IllegalArgumentException(message);
        return value;
    }

    private BigDecimal decimal(Object value) {
        if (value == null) return BigDecimal.ZERO;
        return value instanceof BigDecimal number ? number : new BigDecimal(value.toString());
    }

    private String normalize(String value) { return value == null || value.isBlank() ? null : value.trim(); }

    /** 부족 상태 변경은 보존하되 실제 불출 작업은 중단시키기 위한 예외다. */
    public static class InventoryShortageException extends IllegalStateException {
        private static final long serialVersionUID = 1L;
        public InventoryShortageException(String message) { super(message); }
    }
}
