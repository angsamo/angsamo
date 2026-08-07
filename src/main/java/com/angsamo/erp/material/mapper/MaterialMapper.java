package com.angsamo.erp.material.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.material.dto.MaterialInventoryItem;
import com.angsamo.erp.material.dto.StockMovementItem;

@Mapper
public interface MaterialMapper {
	List<Map<String, Object>> findPurchaseOrders();
	List<Map<String, Object>> findPendingShipments();
	List<Map<String, Object>> findReceivings();
	List<Map<String, Object>> findReturns();
	List<MaterialInventoryItem> findInventory(@Param("keyword") String keyword,
			@Param("maxQty") java.math.BigDecimal maxQty);
	List<Map<String, Object>> findActiveMaterials();
	List<StockMovementItem> findRecentStockMovements(@Param("movementType") String movementType);
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
	Map<String, Object> lockReturn(long returnId);
	Map<String, Object> lockIssue(long issueId);
	Map<String, Object> lockInventory(@Param("departmentId") long departmentId, @Param("itemId") long itemId);
	int createInventoryIfAbsent(@Param("departmentId") long departmentId, @Param("itemId") long itemId);
	int adjustInventory(@Param("departmentId") long departmentId, @Param("itemId") long itemId,
			@Param("adjustmentQty") java.math.BigDecimal adjustmentQty);
	int decreaseInventory(@Param("departmentId") long departmentId, @Param("itemId") long itemId,
			@Param("qty") java.math.BigDecimal qty);
	int changeIssueStatus(@Param("issueId") long issueId, @Param("fromStatuses") List<String> fromStatuses,
			@Param("status") String status, @Param("userId") long userId);
	int completeReceiving(@Param("procurementId") long procurementId, @Param("result") String result,
			@Param("acceptedQty") int acceptedQty, @Param("rejectedQty") int rejectedQty,
			@Param("reason") String reason);
	int insertStockMovement(@Param("departmentId") long departmentId, @Param("itemId") long itemId,
			@Param("movementType") String movementType,
			@Param("qty") java.math.BigDecimal qty, @Param("referenceType") String referenceType,
			@Param("referenceId") Long referenceId, @Param("userId") long userId,
			@Param("memo") String memo);
	int updateIssue(@Param("issueId") long issueId, @Param("qty") java.math.BigDecimal qty,
			@Param("status") String status, @Param("userId") long userId);
	int updateReturnStatus(@Param("returnId") long returnId, @Param("status") String status);
	int requestReturn(@Param("returnId") long returnId, @Param("reason") String reason);
	int issueStatement(long procurementId);
	int notifyStatement(long statementId);
	int closePurchaseOrder(long poId);
}
