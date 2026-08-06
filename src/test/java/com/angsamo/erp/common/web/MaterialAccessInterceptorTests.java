package com.angsamo.erp.common.web;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@ExtendWith(MockitoExtension.class)
class MaterialAccessInterceptorTests {
    @Mock HttpServletRequest request;
    @Mock HttpServletResponse response;
    @Mock HttpSession session;
    MaterialAccessInterceptor interceptor;

    @BeforeEach void setUp() { interceptor = new MaterialAccessInterceptor(); }

    @Test void materialDepartmentAndAdminCanAccess() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute(LoginUser.SESSION_KEY))
                .thenReturn(new LoginUser(1L, "material", "자재", "MEMBER", 2L, "MATERIAL", null));
        assertTrue(interceptor.preHandle(request, response, new Object()));

        when(session.getAttribute(LoginUser.SESSION_KEY))
                .thenReturn(new LoginUser(2L, "admin", "관리자", "ADMIN", null, null, null));
        assertTrue(interceptor.preHandle(request, response, new Object()));
    }

    @Test void otherDepartmentIsForbidden() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute(LoginUser.SESSION_KEY))
                .thenReturn(new LoginUser(3L, "production", "생산", "MEMBER", 3L, "PRODUCTION", null));
        assertFalse(interceptor.preHandle(request, response, new Object()));
        verify(response).sendError(403);
    }
}
