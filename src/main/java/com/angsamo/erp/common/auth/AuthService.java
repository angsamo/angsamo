package com.angsamo.erp.common.auth;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.common.session.LoginUser;

@Service
public class AuthService {
	private final AuthMapper authMapper;
	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	public AuthService(AuthMapper authMapper) {
		this.authMapper = authMapper;
	}

	@Transactional(readOnly = true)
	public LoginUser authenticate(String loginId, String password) {
		LoginAccount account = authMapper.findActiveByLoginId(loginId);
		if (account == null || !passwordEncoder.matches(password, account.getPassword())) {
			return null;
		}
		return new LoginUser(account.getUserId(), account.getLoginId(), account.getUserName(),
				account.getRole(), account.getDepartmentId(), account.getDepartmentCode(), account.getVendorId());
	}
}
