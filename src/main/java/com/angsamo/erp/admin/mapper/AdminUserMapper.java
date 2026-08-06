package com.angsamo.erp.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.admin.dto.UserListItem;
import com.angsamo.erp.admin.dto.UserForm;

@Mapper
public interface AdminUserMapper {
	List<UserListItem> findAll();
	List<UserListItem> findPage(@Param("offset") int offset, @Param("size") int size, @Param("active") Boolean active);
	long count(@Param("active") Boolean active);
	long countByActive(@Param("active") boolean active);
	UserListItem findById(Long userId);
	int countByLoginId(String loginId);
	void insert(UserForm form);
	void update(@Param("userId") Long userId, @Param("form") UserForm form,
			@Param("encodedPassword") String encodedPassword);
	void deactivate(Long userId);
}
