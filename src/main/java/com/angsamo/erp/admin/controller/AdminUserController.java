package com.angsamo.erp.admin.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.admin.service.AdminUserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminUserController {
	private final AdminUserService adminUserService;

	public AdminUserController(AdminUserService adminUserService) {
		this.adminUserService = adminUserService;
	}

	@GetMapping("/admin/users")
	public String users(Model model, HttpSession session) {
		if (!"ADMIN".equals(session.getAttribute("loginRole"))) {
			throw new ResponseStatusException(HttpStatus.FORBIDDEN);
		}

		model.addAttribute("users", adminUserService.getUsers());
		return "admin/users";
	}
}
