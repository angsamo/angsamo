package com.angsamo.erp.common.web;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 로그인하지 않은 사용자의 업무 화면 접근을 막고, 개발/생산/자재/구매 부서 소속이 아닌 사용자가
 * 다른 부서 업무를 등록·수정하지 못하도록 막는다. 조회(GET)는 부서 간 연동 조회를 위해 로그인
 * 여부만 검사하고, 등록·수정 요청(POST 등)만 부서 일치 여부까지 검사한다.
 * 협력회사 화면(/vendor, /supplier)은 로그인한 VENDOR 본인 것만 보이도록 컨트롤러에서 별도로
 * 범위를 좁히므로, 여기서는 VENDOR 또는 ADMIN 역할인지만 확인한다.
 */
@Component
public class DepartmentAccessInterceptor implements HandlerInterceptor {
	private static final Map<String, String> DEPARTMENT_BY_PREFIX = Map.of(
			"/development", "DEV",
			"/production", "PRODUCTION",
			"/material", "MATERIAL",
			"/purchase", "PURCHASE");
	private static final List<String> VENDOR_PREFIXES = List.of("/vendor", "/supplier");

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession(false);
		LoginUser loginUser = session == null ? null : (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		if (loginUser == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return false;
		}
		if ("ADMIN".equals(loginUser.getRole())) {
			return true;
		}

		if (isVendorPath(request)) {
			if (!"VENDOR".equals(loginUser.getRole())) {
				response.sendError(HttpStatus.FORBIDDEN.value());
				return false;
			}
			return true;
		}

		if (HttpMethod.GET.matches(request.getMethod())) {
			return true;
		}

		String requiredDepartment = requiredDepartment(request);
		if (requiredDepartment == null) {
			return true;
		}
		if (!requiredDepartment.equals(loginUser.getDepartmentCode())) {
			response.sendError(HttpStatus.FORBIDDEN.value());
			return false;
		}
		return true;
	}

	private String requiredDepartment(HttpServletRequest request) {
		String path = request.getServletPath();
		for (Map.Entry<String, String> entry : DEPARTMENT_BY_PREFIX.entrySet()) {
			if (path.startsWith(entry.getKey())) {
				return entry.getValue();
			}
		}
		return null;
	}

	private boolean isVendorPath(HttpServletRequest request) {
		String path = request.getServletPath();
		return VENDOR_PREFIXES.stream().anyMatch(path::startsWith);
	}
}
