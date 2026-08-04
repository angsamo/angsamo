package com.angsamo.erp.admin.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.admin.service.AdminDepartmentService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminDepartmentController {
	private final AdminDepartmentService adminDepartmentService;

	public AdminDepartmentController(AdminDepartmentService adminDepartmentService) {
		this.adminDepartmentService = adminDepartmentService;
	}

	@GetMapping("/admin/departments")
	public String departments(Model model, HttpSession session) {
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		if (loginUser == null || !"ADMIN".equals(loginUser.getRole())) {
			throw new ResponseStatusException(HttpStatus.FORBIDDEN);
		}

		model.addAttribute("departments", adminDepartmentService.getDepartments());
		return "admin/departments";
	}
}
