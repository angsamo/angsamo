package com.angsamo.erp.vendor.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** 협력회사 전용 견적 요청 및 제출 정보를 화면에 전달한다. */
@Getter
@Setter
@NoArgsConstructor
public class VendorQuoteItem {
    private Long quoteId;
    private Long procurementId;
    private Long vendorId;
    private String vendorName;
    private String itemCode;
    private String itemName;
    private String spec;
    private String unit;
    private BigDecimal requestQty;
    private LocalDate requiredDate;
    private LocalDate quoteDeadline;
    private String status;
    private BigDecimal unitPrice;
    private LocalDate deliveryDate;
    private String terms;
    private LocalDateTime submittedAt;
}
