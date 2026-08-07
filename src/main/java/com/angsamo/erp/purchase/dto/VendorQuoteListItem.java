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
public class VendorQuoteListItem {

    private Long quoteId;
    private Long procurementId;
    private String procurementStatus;
    private Long selectedVendorId;
    private Long itemId;
    private String itemCode;
    private String itemName;
    private String unit;
    private BigDecimal requestQty;
    private Long vendorId;
    private String vendorCode;
    private String vendorName;
    private String status;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private LocalDate deliveryDate;
    private LocalDate requiredDate;
    private LocalDate quoteDeadline;
    private String terms;
    private LocalDateTime submittedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
