package com.angsamo.erp.common.auth;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {
	private final AuthService authService;

	public AuthController(AuthService authService) {
		this.authService = authService;
	}

	@GetMapping("/login")
	public String loginForm(HttpSession session) {
		return session.getAttribute(LoginUser.SESSION_KEY) == null ? "login" : "redirect:/";
	}

	@PostMapping("/login")
	public String login(@RequestParam String loginId, @RequestParam String password,
			HttpServletRequest request, Model model) {
		if (loginId.isBlank() || password.isBlank()) {
			return fail(model, loginId, "아이디와 비밀번호를 입력해 주세요.");
		}
		LoginUser loginUser = authService.authenticate(loginId.trim(), password);
		if (loginUser == null) {
			return fail(model, loginId, "아이디 또는 비밀번호가 올바르지 않습니다.");
		}
		HttpSession session = request.getSession();
		request.changeSessionId();
		session.setAttribute(LoginUser.SESSION_KEY, loginUser);
		return "redirect:/";
	}

	@PostMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}

	private String fail(Model model, String loginId, String message) {
		model.addAttribute("loginId", loginId);
		model.addAttribute("error", message);
		return "login";
	}
}
