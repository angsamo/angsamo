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
	Map<String, Object> lockIssue(long issueId);
	int completeReceiving(@Param("procurementId") long procurementId, @Param("result") String result,
			@Param("acceptedQty") int acceptedQty, @Param("rejectedQty") int rejectedQty,
			@Param("reason") String reason);
	int insertStockMovement(@Param("departmentId") long departmentId, @Param("itemId") long itemId,
			@Param("movementType") String movementType,
			@Param("qty") int qty, @Param("referenceType") String referenceType,
			@Param("referenceId") long referenceId, @Param("userId") long userId);
	int updateIssue(@Param("issueId") long issueId, @Param("qty") int qty,
			@Param("status") String status, @Param("userId") long userId);
	int updateReturnStatus(@Param("returnId") long returnId, @Param("status") String status);
	int issueStatement(long procurementId);
	int notifyStatement(long statementId);
	int closePurchaseOrder(long poId);
}
