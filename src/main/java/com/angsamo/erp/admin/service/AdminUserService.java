package com.angsamo.erp.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.admin.dto.UserListItem;
import com.angsamo.erp.admin.dto.UserForm;
import com.angsamo.erp.admin.mapper.AdminUserMapper;
import com.angsamo.erp.common.paging.PageRequest;
import com.angsamo.erp.common.paging.PageResult;

@Service
public class AdminUserService {
	public static final int PAGE_SIZE = 20;

	private final AdminUserMapper adminUserMapper;
	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	public AdminUserService(AdminUserMapper adminUserMapper) {
		this.adminUserMapper = adminUserMapper;
	}

	@Transactional(readOnly = true)
	public List<UserListItem> getUsers() {
		return adminUserMapper.findAll();
	}

	@Transactional(readOnly = true)
	public PageResult<UserListItem> getUsers(Integer page, String status) {
		Boolean active = toActiveFilter(status);
		PageRequest pageRequest = new PageRequest(page, PAGE_SIZE);
		List<UserListItem> items = adminUserMapper.findPage(pageRequest.getOffset(), pageRequest.getSize(), active);
		long totalCount = adminUserMapper.count(active);
		return new PageResult<>(items, pageRequest.getPage(), pageRequest.getSize(), totalCount);
	}

	private Boolean toActiveFilter(String status) {
		if ("active".equals(status)) return true;
		if ("suspended".equals(status)) return false;
		return null;
	}

	@Transactional(readOnly = true)
	public long countActive() {
		return adminUserMapper.countByActive(true);
	}

	@Transactional(readOnly = true)
	public long countInactive() {
		return adminUserMapper.countByActive(false);
	}

	@Transactional(readOnly = true)
	public UserListItem getUser(Long userId) { return adminUserMapper.findById(userId); }

	@Transactional
	public void create(UserForm form) {
		validate(form, true);
		if (adminUserMapper.countByLoginId(form.getLoginId().trim()) > 0) {
			throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
		}
		form.setLoginId(form.getLoginId().trim());
		form.setUserName(form.getUserName().trim());
		form.setPassword(passwordEncoder.encode(form.getPassword()));
		adminUserMapper.insert(form);
	}

	@Transactional
	public void update(Long userId, UserForm form) {
		validate(form, false);
		form.setUserName(form.getUserName().trim());
		String password = hasText(form.getPassword()) ? passwordEncoder.encode(form.getPassword()) : null;
		adminUserMapper.update(userId, form, password);
	}

	@Transactional
	public void deactivate(Long userId, Long loginUserId) {
		if (userId.equals(loginUserId)) {
			throw new IllegalArgumentException("현재 로그인한 계정은 비활성화할 수 없습니다.");
		}
		adminUserMapper.deactivate(userId);
	}

	@Transactional
	public void moveDepartment(Long userId, Long targetDepartmentId) {
		UserListItem user = adminUserMapper.findById(userId);
		if (user == null) throw new IllegalArgumentException("사용자를 찾을 수 없습니다.");
		if ("VENDOR".equals(user.getRole())) {
			throw new IllegalArgumentException("협력회사 계정은 부서로 이동할 수 없습니다.");
		}
		if (targetDepartmentId == null) throw new IllegalArgumentException("이동할 부서를 선택하세요.");
		adminUserMapper.updateDepartment(userId, targetDepartmentId);
	}

	private void validate(UserForm form, boolean creating) {
		if (form.getDepartmentId() != null && form.getVendorId() != null) {
			throw new IllegalArgumentException("\uBD80\uC11C\uC640 \uD611\uB825\uD68C\uC0AC\uB294 \uB458 \uC911 \uD558\uB098\uB9CC \uC120\uD0DD\uD558\uC138\uC694.");
		}
		if (creating && !hasText(form.getLoginId())) throw new IllegalArgumentException("아이디를 입력하세요.");
		if (creating && !hasText(form.getPassword())) throw new IllegalArgumentException("비밀번호를 입력하세요.");
		if (!hasText(form.getUserName())) throw new IllegalArgumentException("이름을 입력하세요.");
		if ("VENDOR".equals(form.getRole()) && form.getVendorId() == null) {
			throw new IllegalArgumentException("\uD611\uB825\uD68C\uC0AC \uACC4\uC815\uC740 \uD68C\uC0AC\uB97C \uC120\uD0DD\uD574\uC57C \uD569\uB2C8\uB2E4.");
		}
		if (!"ADMIN".equals(form.getRole()) && !"MEMBER".equals(form.getRole()) && !"VENDOR".equals(form.getRole())) {
			throw new IllegalArgumentException("올바른 권한을 선택하세요.");
		}
	}

	private boolean hasText(String value) {
		return value != null && !value.isBlank();
	}
}
