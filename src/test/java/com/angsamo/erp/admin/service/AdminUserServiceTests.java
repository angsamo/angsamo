package com.angsamo.erp.admin.service;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyNoInteractions;

import org.junit.jupiter.api.Test;

import com.angsamo.erp.admin.mapper.AdminUserMapper;

class AdminUserServiceTests {
	@Test
	void cannotDeactivateCurrentAdmin() {
		AdminUserMapper mapper = mock(AdminUserMapper.class);
		AdminUserService service = new AdminUserService(mapper);

		assertThrows(IllegalArgumentException.class, () -> service.deactivate(1L, 1L));
		verifyNoInteractions(mapper);
	}
}
