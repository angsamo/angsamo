package com.angsamo.erp.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.admin.dto.UserListItem;
import com.angsamo.erp.admin.mapper.AdminUserMapper;

@Service
public class AdminUserService {
	private final AdminUserMapper adminUserMapper;

	public AdminUserService(AdminUserMapper adminUserMapper) {
		this.adminUserMapper = adminUserMapper;
	}

	@Transactional(readOnly = true)
	public List<UserListItem> getUsers() {
		return adminUserMapper.findAll();
	}
}
