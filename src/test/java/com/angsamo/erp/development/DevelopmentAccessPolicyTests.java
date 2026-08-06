package com.angsamo.erp.development;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.development.service.DevelopmentAccessPolicy;

class DevelopmentAccessPolicyTests {

    private final DevelopmentAccessPolicy policy = new DevelopmentAccessPolicy();

    @Test
    void developmentMemberCanManage() {
        assertDoesNotThrow(() -> policy.requireManager(user("MEMBER", "DEV")));
    }

    @Test
    void adminCanManage() {
        assertDoesNotThrow(() -> policy.requireManager(user("ADMIN", null)));
    }

    @Test
    void anotherDepartmentCannotManage() {
        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> policy.requireManager(user("MEMBER", "PRODUCTION"))
        );

        assertEquals(HttpStatus.FORBIDDEN, exception.getStatusCode());
    }

    @Test
    void anonymousUserCannotManage() {
        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> policy.requireManager(null)
        );

        assertEquals(HttpStatus.UNAUTHORIZED, exception.getStatusCode());
    }

    private LoginUser user(String role, String departmentCode) {
        return new LoginUser(1L, "test", "테스트", role, 1L, departmentCode, null);
    }
}
