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

import com.angsamo.erp.admin.dto.VendorItem;
import com.angsamo.erp.admin.service.AdminVendorService;
import com.angsamo.erp.admin.service.AdminUserService;

@Controller
public class AdminVendorController {
	private final AdminVendorService service;
	private final AdminUserService userService;
	public AdminVendorController(AdminVendorService service, AdminUserService userService) {
		this.service = service;
		this.userService = userService;
	}

	@GetMapping("/admin/vendors")
	public String vendors(Model model) { model.addAttribute("vendors", service.getVendors()); return "admin/vendor-management"; }

	@GetMapping("/admin/vendors/{vendorId}")
	public String detail(@PathVariable String vendorId, Model model) {
		VendorItem vendor = service.getVendor(vendorId);
		if (vendor == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
		model.addAttribute("vendor", vendor);
		model.addAttribute("users", userService.getUsers().stream()
				.filter(user -> vendorId.equals(user.getVendorId())).toList());
		return "admin/vendor-detail";
	}

	@PostMapping("/admin/vendors")
	public String create(VendorItem vendor, RedirectAttributes redirect) {
		return run(() -> service.create(vendor), "\uD611\uB825\uD68C\uC0AC\uB97C \uB4F1\uB85D\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	@PostMapping("/admin/vendors/{vendorId}")
	public String update(@PathVariable String vendorId, @RequestParam String vendorName, RedirectAttributes redirect) {
		return run(() -> service.update(vendorId, vendorName), "\uD611\uB825\uD68C\uC0AC \uC815\uBCF4\uB97C \uC218\uC815\uD588\uC2B5\uB2C8\uB2E4.", redirect);
	}

	private String run(Runnable action, String success, RedirectAttributes redirect) {
		try { action.run(); redirect.addFlashAttribute("success", success); }
		catch (IllegalArgumentException e) { redirect.addFlashAttribute("error", e.getMessage()); }
		return "redirect:/admin/vendors";
	}
}
