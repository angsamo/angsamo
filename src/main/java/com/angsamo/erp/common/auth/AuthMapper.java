package com.angsamo.erp.common.auth;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AuthMapper {
	LoginAccount findActiveByLoginId(@Param("loginId") String loginId);
}
