package com.angsamo.erp.purchase.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ProcurementDetail {

    private Long procurementId;
    private Long departmentId;
    private String departmentName;

    private Long materialRequestId;
    private String materialRequestStatus;
    private BigDecimal materialRequestQty;
    private BigDecimal materialRequestIssuedQty;
    private LocalDate materialRequestRequiredDate;

    private Long itemId;
    private String itemCode;
    private String itemName;
    private String spec;
    private String unit;

    private BigDecimal requestQty;
    private LocalDate requiredDate;
    private LocalDate quoteDeadline;

    private Long selectedVendorId;
    private String selectedVendorCode;
    private String selectedVendorName;
    private String selectedVendorContactName;
    private String selectedVendorPhone;
    private String selectedVendorEmail;

    private BigDecimal orderQty;
    private BigDecimal unitPrice;
    private BigDecimal receivedQty;
    private String status;
    private LocalDateTime orderedAt;
    private LocalDateTime shippedAt;
    private LocalDateTime receivedAt;
    private String inspectionResult;
    private String terms;

    private Long createdBy;
    private String createdByName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
