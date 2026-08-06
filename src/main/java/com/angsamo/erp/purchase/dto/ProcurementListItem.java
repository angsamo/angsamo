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
public class ProcurementListItem {

    private Long procurementId;
    private Long materialRequestId;
    private Long productionPlanId;
    private Long departmentId;
    private String departmentName;
    private Long itemId;
    private String itemCode;
    private String itemName;
    private String unit;
    private BigDecimal requestQty;
    private LocalDate requiredDate;
    private LocalDate quoteDeadline;
    private Long selectedVendorId;
    private String selectedVendorName;
    private BigDecimal orderQty;
    private BigDecimal unitPrice;
    private BigDecimal receivedQty;
    private String status;
    private Long createdBy;
    private String createdByName;
    private LocalDateTime createdAt;
}
