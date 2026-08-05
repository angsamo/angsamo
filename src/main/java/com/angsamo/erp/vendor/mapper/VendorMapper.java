package com.angsamo.erp.vendor.mapper;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.vendor.dto.VendorDashboardSummary;
import com.angsamo.erp.vendor.dto.VendorOrderItem;
import com.angsamo.erp.vendor.dto.VendorQuoteItem;

/** 협력회사 담당 범위의 조회와 상태 변경 SQL을 연결한다. */
@Mapper
public interface VendorMapper {
    VendorDashboardSummary findDashboardSummary(@Param("vendorId") Long vendorId);
    List<VendorQuoteItem> findQuotes(@Param("vendorId") Long vendorId, @Param("status") String status);
    List<VendorOrderItem> findOrders(@Param("vendorId") Long vendorId, @Param("status") String status);
    List<VendorOrderItem> findInspections(@Param("vendorId") Long vendorId);
    List<VendorOrderItem> findReturns(@Param("vendorId") Long vendorId);
    List<VendorOrderItem> findStatements(@Param("vendorId") Long vendorId);
    VendorOrderItem findOrder(@Param("procurementId") long procurementId,
            @Param("vendorId") Long vendorId);

    int submitQuote(@Param("quoteId") long quoteId, @Param("vendorId") long vendorId,
            @Param("unitPrice") BigDecimal unitPrice, @Param("deliveryDate") LocalDate deliveryDate,
            @Param("terms") String terms);
    int startProduction(@Param("procurementId") long procurementId, @Param("vendorId") long vendorId);
    int shipOrder(@Param("procurementId") long procurementId, @Param("vendorId") long vendorId);
    int reshipReturn(@Param("procurementId") long procurementId, @Param("vendorId") long vendorId);
}
