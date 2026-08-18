package com.angsamo.erp.safety.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WeatherAlertMapper {
    int insertIfAbsent(@Param("alertType") String alertType, @Param("alertLevel") String alertLevel,
            @Param("message") String message);
}
