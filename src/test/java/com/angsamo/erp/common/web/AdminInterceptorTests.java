package com.angsamo.erp.common.web;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import com.angsamo.erp.common.session.LoginUser;

class AdminInterceptorTests {
	private final AdminInterceptor interceptor = new AdminInterceptor();

	@Test
	void redirectsGuestToLogin() throws Exception {
		MockHttpServletRequest request = new MockHttpServletRequest();
		MockHttpServletResponse response = new MockHttpServletResponse();

		assertFalse(interceptor.preHandle(request, response, new Object()));
		assertEquals("/login", response.getRedirectedUrl());
	}

	@Test
	void rejectsNonAdmin() throws Exception {
		MockHttpServletResponse response = new MockHttpServletResponse();

		assertFalse(interceptor.preHandle(requestWithRole("MEMBER"), response, new Object()));
		assertEquals(403, response.getStatus());
	}

	@Test
	void allowsAdmin() throws Exception {
		assertTrue(interceptor.preHandle(requestWithRole("ADMIN"),
				new MockHttpServletResponse(), new Object()));
	}

	private MockHttpServletRequest requestWithRole(String role) {
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.getSession().setAttribute(LoginUser.SESSION_KEY,
				new LoginUser(1L, "user", "사용자", role, null, null, null));
		return request;
	}
}
