package com.angsamo.erp.vendor.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** 선정된 협력회사의 제작·출하·검사·입고 진행 정보를 표현한다. */
@Getter
@Setter
@NoArgsConstructor
public class VendorOrderItem {
    private Long procurementId;
    private Long vendorId;
    private String vendorName;
    private String itemCode;
    private String itemName;
    private String spec;
    private String unit;
    private BigDecimal orderQty;
    private BigDecimal receivedQty;
    private BigDecimal unitPrice;
    private LocalDate requiredDate;
    private String status;
    private String terms;
    private LocalDateTime orderedAt;
    private LocalDateTime shippedAt;
    private LocalDateTime receivedAt;
    private String inspectionResult;
}
