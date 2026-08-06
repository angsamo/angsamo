package com.angsamo.erp.purchase.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PurchaseReceivingItem {
    private Long procurementId;
    private String itemCode;
    private String itemName;
    private String unit;
    private String vendorName;
    private BigDecimal orderQty;
    private BigDecimal receivedQty;
    private String inspectionResult;
    private String status;
    private LocalDateTime shippedAt;
    private LocalDateTime receivedAt;
    private Boolean readyToClose;
}
