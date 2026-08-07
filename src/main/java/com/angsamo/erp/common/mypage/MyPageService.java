package com.angsamo.erp.common.mypage;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MyPageService {
	private final MyPageMapper myPageMapper;
	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	public MyPageService(MyPageMapper myPageMapper) {
		this.myPageMapper = myPageMapper;
	}

	@Transactional
	public void changePassword(Long userId, String currentPassword, String newPassword, String confirmPassword) {
		if (currentPassword == null || currentPassword.isBlank()) {
			throw new IllegalArgumentException("현재 비밀번호를 입력하세요.");
		}
		if (newPassword == null || newPassword.isBlank()) {
			throw new IllegalArgumentException("새 비밀번호를 입력하세요.");
		}
		if (!newPassword.equals(confirmPassword)) {
			throw new IllegalArgumentException("새 비밀번호가 서로 일치하지 않습니다.");
		}
		String currentHash = myPageMapper.findPasswordHash(userId);
		if (currentHash == null || !passwordEncoder.matches(currentPassword, currentHash)) {
			throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
		}
		myPageMapper.updatePassword(userId, passwordEncoder.encode(newPassword));
	}
}
