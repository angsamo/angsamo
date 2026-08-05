package com.angsamo.erp.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.admin.dto.UserForm;
import com.angsamo.erp.admin.service.AdminDepartmentService;
import com.angsamo.erp.admin.service.AdminUserService;
import com.angsamo.erp.admin.service.AdminVendorService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminUserController {
	private final AdminUserService adminUserService;
	private final AdminDepartmentService adminDepartmentService;
	private final AdminVendorService adminVendorService;

	public AdminUserController(AdminUserService adminUserService, AdminDepartmentService adminDepartmentService,
			AdminVendorService adminVendorService) {
		this.adminUserService = adminUserService;
		this.adminDepartmentService = adminDepartmentService;
		this.adminVendorService = adminVendorService;
	}

	@GetMapping("/admin/users")
	public String users(Model model) {
		model.addAttribute("users", adminUserService.getUsers());
		model.addAttribute("departments", adminDepartmentService.getDepartments());
		model.addAttribute("vendors", adminVendorService.getVendors());
		return "admin/user-management";
	}

	@GetMapping("/admin/users/{userId}")
	public String detail(@PathVariable Long userId, Model model) {
		var user = adminUserService.getUser(userId);
		if (user == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
		model.addAttribute("user", user);
		model.addAttribute("departments", adminDepartmentService.getDepartments());
		model.addAttribute("vendors", adminVendorService.getVendors());
		return "admin/user-detail";
	}

	@PostMapping("/admin/users")
	public String create(UserForm form, RedirectAttributes redirect) {
		return run(() -> adminUserService.create(form), "\uC0AC\uC6A9\uC790\uB97C \uB4F1\uB85D\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	@PostMapping("/admin/users/{userId}")
	public String update(@PathVariable Long userId, UserForm form, RedirectAttributes redirect) {
		return run(() -> adminUserService.update(userId, form), "\uC0AC\uC6A9\uC790 \uC815\uBCF4\uB97C \uC218\uC815\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	@PostMapping("/admin/users/{userId}/deactivate")
	public String deactivate(@PathVariable Long userId, HttpSession session, RedirectAttributes redirect) {
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		return run(() -> adminUserService.deactivate(userId, loginUser.getUserId()), "\uC0AC\uC6A9\uC790\uB97C \uBE44\uD65C\uC131\uD654\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	private String run(Runnable action, String success, RedirectAttributes redirect) {
		try {
			action.run();
			redirect.addFlashAttribute("success", success);
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/admin/users";
	}
}
