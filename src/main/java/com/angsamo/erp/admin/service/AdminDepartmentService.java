package com.angsamo.erp.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.admin.dto.DepartmentListItem;
import com.angsamo.erp.admin.mapper.AdminDepartmentMapper;

@Service
public class AdminDepartmentService {
	private final AdminDepartmentMapper adminDepartmentMapper;

	public AdminDepartmentService(AdminDepartmentMapper adminDepartmentMapper) {
		this.adminDepartmentMapper = adminDepartmentMapper;
	}

	@Transactional(readOnly = true)
	public List<DepartmentListItem> getDepartments() {
		return adminDepartmentMapper.findAll();
	}
}
