package com.angsamo.erp.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.admin.dto.DepartmentForm;
import com.angsamo.erp.admin.service.AdminDepartmentService;
import com.angsamo.erp.admin.service.AdminUserService;

@Controller
public class AdminDepartmentController {
	private final AdminDepartmentService adminDepartmentService;
	private final AdminUserService adminUserService;

	public AdminDepartmentController(AdminDepartmentService adminDepartmentService, AdminUserService adminUserService) {
		this.adminDepartmentService = adminDepartmentService;
		this.adminUserService = adminUserService;
	}

	@GetMapping("/admin/departments")
	public String departments(@RequestParam(required = false) String status, Model model) {
		var all = adminDepartmentService.getDepartments();
		long activeCount = all.stream().filter(d -> Boolean.TRUE.equals(d.getActive())).count();
		long inactiveCount = all.size() - activeCount;
		var filtered = all.stream()
				.filter(d -> "active".equals(status) ? Boolean.TRUE.equals(d.getActive())
						: "suspended".equals(status) ? !Boolean.TRUE.equals(d.getActive()) : true)
				.toList();
		model.addAttribute("departments", filtered);
		model.addAttribute("grandTotal", all.size());
		model.addAttribute("activeCount", activeCount);
		model.addAttribute("inactiveCount", inactiveCount);
		model.addAttribute("status", status);
		return "admin/department-management";
	}

	@GetMapping("/admin/departments/{departmentId}")
	public String detail(@PathVariable Long departmentId, Model model) {
		var department = adminDepartmentService.getDepartment(departmentId);
		if (department == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
		model.addAttribute("department", department);
		model.addAttribute("users", adminUserService.getUsers().stream()
				.filter(user -> departmentId.equals(user.getDepartmentId())).toList());
		model.addAttribute("departments", adminDepartmentService.getDepartments());
		return "admin/department-detail";
	}

	@PostMapping("/admin/departments/{departmentId}/members/{userId}/move")
	public String moveMember(@PathVariable Long departmentId, @PathVariable Long userId,
			@RequestParam Long targetDepartmentId, RedirectAttributes redirect) {
		try {
			adminUserService.moveDepartment(userId, targetDepartmentId);
			redirect.addFlashAttribute("success", "사용자를 이동했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/admin/departments/" + departmentId;
	}

	@PostMapping("/admin/departments")
	public String create(DepartmentForm form, RedirectAttributes redirect) {
		return run(() -> adminDepartmentService.create(form), "\uBD80\uC11C\uB97C \uB4F1\uB85D\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	@PostMapping("/admin/departments/{departmentId}")
	public String update(@PathVariable Long departmentId, DepartmentForm form, RedirectAttributes redirect) {
		return run(() -> adminDepartmentService.update(departmentId, form), "\uBD80\uC11C \uC815\uBCF4\uB97C \uC218\uC815\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	@PostMapping("/admin/departments/{departmentId}/deactivate")
	public String deactivate(@PathVariable Long departmentId, RedirectAttributes redirect) {
		return run(() -> adminDepartmentService.deactivate(departmentId), "\uBD80\uC11C\uB97C \uBE44\uD65C\uC131\uD654\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	private String run(Runnable action, String message, RedirectAttributes redirect) {
		try {
			action.run();
			redirect.addFlashAttribute("success", message);
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/admin/departments";
	}
}
