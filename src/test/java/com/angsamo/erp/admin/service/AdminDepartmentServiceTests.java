package com.angsamo.erp.admin.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.Test;

import com.angsamo.erp.admin.dto.DepartmentForm;
import com.angsamo.erp.admin.mapper.AdminDepartmentMapper;

class AdminDepartmentServiceTests {
	@Test
	void normalizesDepartmentCodeBeforeInsert() {
		AdminDepartmentMapper mapper = mock(AdminDepartmentMapper.class);
		AdminDepartmentService service = new AdminDepartmentService(mapper);
		DepartmentForm form = new DepartmentForm();
		form.setDepartmentCode(" quality_control ");
		form.setDepartmentName(" \uD488\uC9C8\uAD00\uB9AC\uBD80 ");

		service.create(form);

		assertEquals("QUALITY_CONTROL", form.getDepartmentCode());
		verify(mapper).insert(form);
	}
}
