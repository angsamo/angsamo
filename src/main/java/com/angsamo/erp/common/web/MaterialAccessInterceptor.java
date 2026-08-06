package com.angsamo.erp.common.web;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** 자재 업무 URL을 관리자와 자재부서 사용자에게만 허용한다. */
@Component
public class MaterialAccessInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        LoginUser user = session == null ? null : (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!"ADMIN".equals(user.getRole()) && !"MATERIAL".equals(user.getDepartmentCode())) {
            response.sendError(HttpStatus.FORBIDDEN.value());
            return false;
        }
        return true;
    }
}
