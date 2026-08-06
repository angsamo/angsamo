package com.angsamo.erp.development.service;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.common.session.LoginUser;

@Component
public class DevelopmentAccessPolicy {

    public void requireManager(LoginUser loginUser) {
        if (loginUser == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        boolean admin = "ADMIN".equals(loginUser.getRole());
        boolean developmentDepartment = "DEV".equals(loginUser.getDepartmentCode());

        if (!admin && !developmentDepartment) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "개발부서 또는 관리자만 품목과 BOM을 관리할 수 있습니다."
            );
        }
    }
}
