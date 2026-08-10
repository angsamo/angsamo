package com.angsamo.erp.common;

import com.angsamo.erp.common.dashboard.DashboardService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	private final DashboardService dashboardService;

	public HomeController(DashboardService dashboardService) {
		this.dashboardService = dashboardService;
	}

	@GetMapping("/")
	public String home(Model model, HttpSession session) {
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		if (loginUser == null) {
			return "redirect:/login";
		}

		boolean isAdmin = "ADMIN".equals(loginUser.getRole());
		boolean canViewDevelopment = isAdmin || "DEV".equals(loginUser.getDepartmentCode());
		boolean canViewProduction = isAdmin || "PRODUCTION".equals(loginUser.getDepartmentCode());
		boolean canViewMaterial = isAdmin || "MATERIAL".equals(loginUser.getDepartmentCode());
		boolean canViewPurchase = isAdmin || "PURCHASE".equals(loginUser.getDepartmentCode());

		model.addAttribute("projectName", "앙사모 ERP");
		model.addAttribute("summary", dashboardService.getSummary());
		model.addAttribute("isAdmin", isAdmin);
		model.addAttribute("canViewDevelopment", canViewDevelopment);
		model.addAttribute("canViewProduction", canViewProduction);
		model.addAttribute("canViewMaterial", canViewMaterial);
		model.addAttribute("canViewPurchase", canViewPurchase);
		return "home";
	}
}
