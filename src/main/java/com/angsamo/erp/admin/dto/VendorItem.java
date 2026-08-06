package com.angsamo.erp.admin.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VendorItem {
	private Long vendorId;
	private String vendorCode;
	private String vendorName;
	private Boolean active;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
}
