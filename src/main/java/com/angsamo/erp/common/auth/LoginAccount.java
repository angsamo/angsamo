package com.angsamo.erp.common.auth;

public class LoginAccount {
	private Long userId;
	private String loginId;
	private String password;
	private String userName;
	private String role;
	private Long departmentId;
	private String departmentCode;
	private Long vendorId;

	public Long getUserId() { return userId; }
	public void setUserId(Long userId) { this.userId = userId; }
	public String getLoginId() { return loginId; }
	public void setLoginId(String loginId) { this.loginId = loginId; }
	public String getPassword() { return password; }
	public void setPassword(String password) { this.password = password; }
	public String getUserName() { return userName; }
	public void setUserName(String userName) { this.userName = userName; }
	public String getRole() { return role; }
	public void setRole(String role) { this.role = role; }
	public Long getDepartmentId() { return departmentId; }
	public void setDepartmentId(Long departmentId) { this.departmentId = departmentId; }
	public String getDepartmentCode() { return departmentCode; }
	public void setDepartmentCode(String departmentCode) { this.departmentCode = departmentCode; }
	public Long getVendorId() { return vendorId; }
	public void setVendorId(Long vendorId) { this.vendorId = vendorId; }
}
