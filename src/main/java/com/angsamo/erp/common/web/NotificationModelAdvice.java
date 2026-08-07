package com.angsamo.erp.common.web;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.angsamo.erp.common.notification.NotificationService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

/** 로그인한 사용자에게 부서·역할별 알림 목록을 모든 화면 헤더에서 쓸 수 있도록 공통 주입한다. */
@ControllerAdvice
public class NotificationModelAdvice {
	private final NotificationService notificationService;

	public NotificationModelAdvice(NotificationService notificationService) {
		this.notificationService = notificationService;
	}

	@ModelAttribute
	public void addNotifications(HttpSession session, Model model) {
		LoginUser loginUser = session == null ? null : (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		if (loginUser == null) {
			return;
		}
		var notifications = notificationService.getNotifications(loginUser);
		model.addAttribute("notifications", notifications);
		model.addAttribute("notificationCount", notifications.size());
	}
}
