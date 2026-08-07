package com.angsamo.erp.common.dashboard;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DepartmentUserCount {
	private String departmentCode;
	private String departmentName;
	private long userCount;
}
