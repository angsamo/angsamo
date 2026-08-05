package com.angsamo.erp.admin.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DepartmentForm {
	private String departmentCode;
	private String departmentName;
	private Boolean active;
}
