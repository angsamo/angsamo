package com.angsamo.erp.common;

import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

	@GetMapping("/")
	public String home(Model model, HttpSession session) {
		if (session.getAttribute(LoginUser.SESSION_KEY) == null) {
			session.setAttribute(LoginUser.SESSION_KEY,
					new LoginUser(1L, "admin", "최고 관리자", "ADMIN", null, null, null));
		}

		model.addAttribute("projectName", "앙사모 ERP");
		return "home";
	}
}
