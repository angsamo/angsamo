package com.angsamo.erp.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.admin.dto.DepartmentListItem;
import com.angsamo.erp.admin.dto.DepartmentForm;
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

	@Transactional(readOnly = true)
	public DepartmentListItem getDepartment(Long departmentId) { return adminDepartmentMapper.findById(departmentId); }

	@Transactional
	public void create(DepartmentForm form) {
		normalizeAndValidate(form);
		checkDuplicate(form.getDepartmentCode(), null);
		adminDepartmentMapper.insert(form);
	}

	@Transactional
	public void update(Long departmentId, DepartmentForm form) {
		normalizeAndValidate(form);
		checkDuplicate(form.getDepartmentCode(), departmentId);
		adminDepartmentMapper.update(departmentId, form);
	}

	@Transactional
	public void deactivate(Long departmentId) {
		adminDepartmentMapper.deactivate(departmentId);
	}

	private void normalizeAndValidate(DepartmentForm form) {
		String code = form.getDepartmentCode() == null ? "" : form.getDepartmentCode().trim().toUpperCase();
		String name = form.getDepartmentName() == null ? "" : form.getDepartmentName().trim();
		if (!code.matches("[A-Z][A-Z0-9_]*")) {
			throw new IllegalArgumentException("\uBD80\uC11C \uCF54\uB4DC\uB294 \uC601\uBB38 \uB300\uBB38\uC790\uB85C \uC2DC\uC791\uD558\uACE0 \uC22B\uC790\uC640 _\uB9CC \uC0AC\uC6A9\uD560 \uC218 \uC788\uC2B5\uB2C8\uB2E4.");
		}
		if (name.isBlank()) throw new IllegalArgumentException("\uBD80\uC11C\uBA85\uC744 \uC785\uB825\uD558\uC138\uC694.");
		form.setDepartmentCode(code);
		form.setDepartmentName(name);
	}

	private void checkDuplicate(String code, Long excludeId) {
		if (adminDepartmentMapper.countByCode(code, excludeId) > 0) {
			throw new IllegalArgumentException("\uC774\uBBF8 \uC0AC\uC6A9 \uC911\uC778 \uBD80\uC11C \uCF54\uB4DC\uC785\uB2C8\uB2E4.");
		}
	}
}
