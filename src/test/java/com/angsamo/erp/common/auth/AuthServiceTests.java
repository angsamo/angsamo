package com.angsamo.erp.common.auth;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

class AuthServiceTests {
	@Test
	void authenticatesOnlyMatchingPassword() {
		LoginAccount account = new LoginAccount();
		account.setUserId(7L);
		account.setLoginId("admin");
		account.setPassword(new BCryptPasswordEncoder().encode("secret"));
		account.setUserName("관리자");
		account.setRole("ADMIN");
		AuthService service = new AuthService(loginId -> "admin".equals(loginId) ? account : null);

		assertNotNull(service.authenticate("admin", "secret"));
		assertEquals(7L, service.authenticate("admin", "secret").getUserId());
		assertNull(service.authenticate("admin", "wrong"));
		assertNull(service.authenticate("missing", "secret"));
	}
}
