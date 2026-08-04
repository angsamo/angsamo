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
public class ShortageMaterialRequestItem {

    private Long requestId;
    private Long productionPlanId;
    private Long departmentId;
    private String departmentName;
    private Long itemId;
    private String itemCode;
    private String itemName;
    private String unit;
    private BigDecimal requestQty;
    private BigDecimal issuedQty;
    private BigDecimal shortageQty;
    private LocalDate requiredDate;
    private String status;
    private Long requestedBy;
    private String requestedByName;
    private LocalDateTime createdAt;
}
