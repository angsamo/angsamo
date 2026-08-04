package com.angsamo.erp.purchase.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class VendorListItem {

    private Long vendorId;
    private String vendorCode;
    private String vendorName;
    private String contactName;
    private String phone;
    private String email;
    private Boolean active;
    private LocalDateTime createdAt;
}