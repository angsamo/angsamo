package com.angsamo.erp.common.mypage;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MyPageMapper {
	String findPasswordHash(Long userId);
	void updatePassword(@Param("userId") Long userId, @Param("passwordHash") String passwordHash);
}
