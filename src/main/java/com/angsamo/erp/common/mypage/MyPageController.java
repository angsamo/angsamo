package com.angsamo.erp.common.mypage;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.admin.service.AdminUserService;
import com.angsamo.erp.board.service.BoardPostService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

@Controller
public class MyPageController {
	private final MyPageService myPageService;
	private final AdminUserService adminUserService;
	private final BoardPostService boardPostService;

	public MyPageController(MyPageService myPageService, AdminUserService adminUserService,
			BoardPostService boardPostService) {
		this.myPageService = myPageService;
		this.adminUserService = adminUserService;
		this.boardPostService = boardPostService;
	}

	@GetMapping("/mypage")
	public String myPage(HttpSession session, Model model) {
		LoginUser loginUser = requireLogin(session);
		model.addAttribute("profile", adminUserService.getUser(loginUser.getUserId()));
		model.addAttribute("myPosts", boardPostService.getPostsByAuthor(loginUser.getUserId()));
		return "mypage";
	}

	@PostMapping("/mypage/password")
	public String changePassword(HttpSession session, @RequestParam String currentPassword,
			@RequestParam String newPassword, @RequestParam String confirmPassword, RedirectAttributes redirect) {
		LoginUser loginUser = requireLogin(session);
		try {
			myPageService.changePassword(loginUser.getUserId(), currentPassword, newPassword, confirmPassword);
			redirect.addFlashAttribute("success", "비밀번호를 변경했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/mypage";
	}

	private LoginUser requireLogin(HttpSession session) {
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		if (loginUser == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
		return loginUser;
	}
}
