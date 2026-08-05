package com.angsamo.erp.purchase.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class VendorAccountItem {

    private Long userId;
    private String loginId;
    private String userName;
    private String role;
    private Boolean active;
    private LocalDateTime createdAt;
}