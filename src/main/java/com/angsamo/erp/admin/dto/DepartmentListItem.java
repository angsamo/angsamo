package com.angsamo.erp.admin.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DepartmentListItem {
	private Long departmentId;
	private String departmentCode;
	private String departmentName;
	private Boolean active;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
}
