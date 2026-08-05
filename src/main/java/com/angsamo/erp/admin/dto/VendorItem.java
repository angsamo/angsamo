package com.angsamo.erp.admin.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VendorItem {
	private String vendorId;
	private String vendorName;
	private LocalDateTime createdAt;
}
