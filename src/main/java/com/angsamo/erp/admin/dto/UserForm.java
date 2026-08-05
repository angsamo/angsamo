package com.angsamo.erp.admin.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserForm {
	private String loginId;
	private String password;
	private String userName;
	private Long departmentId;
	private String vendorId;
	private String role;
	private Boolean active;
}
