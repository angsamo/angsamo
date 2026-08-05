package com.angsamo.erp.admin.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserListItem {
	private Long userId;
	private String loginId;
	private String userName;
	private Long departmentId;
	private String departmentCode;
	private String departmentName;
	private String vendorId;
	private String vendorName;
	private String role;
	private Boolean active;
	private LocalDateTime createdAt;
}
