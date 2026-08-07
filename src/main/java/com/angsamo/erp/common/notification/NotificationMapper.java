package com.angsamo.erp.common.notification;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface NotificationMapper {
	/** MATERIAL: 새로 들어온 REQUESTED 자재요청 (승인/불출 필요) */
	List<NotificationRow> findRequestedMaterialRequests(@Param("hours") int hours);

	/** PURCHASE: 새로 SHORTAGE 처리된 자재요청 (조달 필요) */
	List<NotificationRow> findShortageMaterialRequests(@Param("hours") int hours);

	/** PURCHASE: 협력업체가 새로 제출한 견적 (비교/선정 필요) */
	List<NotificationRow> findSubmittedQuotes(@Param("hours") int hours);

	/** VENDOR: 본인에게 새로 온 견적 요청 (제출 필요) */
	List<NotificationRow> findVendorQuoteRequests(@Param("vendorId") Long vendorId, @Param("hours") int hours);

	/** VENDOR: 본인이 선정되어 발주 확정된 건 (제작 시작 필요) */
	List<NotificationRow> findVendorOrders(@Param("vendorId") Long vendorId, @Param("hours") int hours);

	/** MATERIAL: 협력업체가 출하한 건 (입고검사 필요) */
	List<NotificationRow> findShippedProcurements(@Param("hours") int hours);

	/** PRODUCTION: 본인 부서 자재요청이 불출완료된 건 (생산 진행 가능) */
	List<NotificationRow> findIssuedMaterialRequests(@Param("departmentId") Long departmentId, @Param("hours") int hours);
}
