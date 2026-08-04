package com.angsamo.erp.material.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MaterialMapper {
	List<Map<String, Object>> findPurchaseOrders();
	List<Map<String, Object>> findPendingShipments();
	List<Map<String, Object>> findReceivings();
	List<Map<String, Object>> findReturns();
	List<Map<String, Object>> findInventory();
	List<Map<String, Object>> findIssues(@Param("fromDate") String fromDate, @Param("toDate") String toDate,
			@Param("itemCode") String itemCode, @Param("status") String status);
	List<Map<String, Object>> findInventoryValueReport(@Param("fromDate") String fromDate,
			@Param("toDate") String toDate, @Param("itemCode") String itemCode);
	List<Map<String, Object>> findStatements();
	List<Map<String, Object>> findOrderReport(@Param("fromDate") String fromDate, @Param("toDate") String toDate,
			@Param("status") String status, @Param("keyword") String keyword);
	List<Map<String, Object>> findCloseReadyOrders();
	Map<String, Object> findStatementPrint(long statementId);
	Map<String, Object> lockShipment(long shipmentId);
	Map<String, Object> lockReceiving(long receivingId);
	Map<String, Object> lockInventory(String itemCode);
	Map<String, Object> lockIssue(long issueId);
	int insertReceiving(@Param("shipmentId") long shipmentId, @Param("poId") long poId,
			@Param("result") String result, @Param("receivedQty") int receivedQty,
			@Param("acceptedQty") int acceptedQty, @Param("rejectedQty") int rejectedQty,
			@Param("reason") String reason, @Param("userId") long userId);
	long lastInsertId();
	int insertReturn(@Param("receivingId") long receivingId, @Param("vendorId") String vendorId,
			@Param("itemCode") String itemCode, @Param("qty") int qty,
			@Param("reason") String reason, @Param("userId") long userId);
	int upsertInventory(@Param("itemCode") String itemCode, @Param("qty") int qty, @Param("unitPrice") Object unitPrice);
	int insertInventoryHistory(@Param("itemCode") String itemCode, @Param("qty") int qty,
			@Param("beforeQty") int beforeQty, @Param("afterQty") int afterQty,
			@Param("referenceId") long referenceId, @Param("userId") long userId);
	int updateIssue(@Param("issueId") long issueId, @Param("qty") int qty,
			@Param("status") String status, @Param("userId") long userId);
	int decreaseInventory(@Param("itemCode") String itemCode, @Param("qty") int qty,
			@Param("unitPrice") Object unitPrice);
	int insertIssueInventoryHistory(@Param("itemCode") String itemCode, @Param("qty") int qty,
			@Param("beforeQty") int beforeQty, @Param("afterQty") int afterQty,
			@Param("referenceId") long referenceId, @Param("userId") long userId);
	int updateProductionRequest(@Param("requestId") long requestId, @Param("status") String status);
	int updatePoProgress(long poId);
	int completeProcurementPlan(long poId);
	int updateReturnStatus(@Param("returnId") long returnId, @Param("status") String status);
	int closePurchaseOrder(long poId);
	Map<String, Object> findStatementCandidate(long receivingId);
	int insertStatementPrep(long contractId);
	int insertStatement(@Param("receivingId") long receivingId, @Param("prepId") long prepId,
			@Param("vendorId") String vendorId, @Param("qty") int qty, @Param("price") Object price);
	int notifyStatement(long statementId);
}
