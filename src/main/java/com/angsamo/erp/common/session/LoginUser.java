package com.angsamo.erp.common.session;

public class LoginUser {
	public static final String SESSION_KEY = "loginUser";

	private Long userId;
	private String loginId;
	private String userName;
	private String role;
	private Long departmentId;
	private String departmentCode;
	private String vendorId;

	public LoginUser(Long userId, String loginId, String userName, String role,
			Long departmentId, String departmentCode, String vendorId) {
		this.userId = userId;
		this.loginId = loginId;
		this.userName = userName;
		this.role = role;
		this.departmentId = departmentId;
		this.departmentCode = departmentCode;
		this.vendorId = vendorId;
	}

	public Long getUserId() { return userId; }
	public String getLoginId() { return loginId; }
	public String getUserName() { return userName; }
	public String getRole() { return role; }
	public Long getDepartmentId() { return departmentId; }
	public String getDepartmentCode() { return departmentCode; }
	public String getVendorId() { return vendorId; }
}
