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
public class PurchaseProgressItem {
    private Long procurementId;
    private String itemCode;
    private String itemName;
    private String unit;
    private String vendorName;
    private BigDecimal orderQty;
    private LocalDate requiredDate;
    private String status;
    private LocalDateTime orderedAt;
    private LocalDateTime shippedAt;
    private String makeProgress;
    private String deliveryProgress;
    private BigDecimal deliveryProgressRate;
    private String inspectionResult;
    private LocalDateTime receivedAt;
}
