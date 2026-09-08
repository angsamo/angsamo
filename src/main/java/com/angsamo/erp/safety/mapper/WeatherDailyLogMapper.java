package com.angsamo.erp.safety.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.safety.domain.WeatherDailyLog;

@Mapper
public interface WeatherDailyLogMapper {

    int upsert(WeatherDailyLog log);

    List<WeatherDailyLog> findByMonth(@Param("start") LocalDate start, @Param("end") LocalDate end);

    int updateMemo(@Param("logDate") LocalDate logDate, @Param("memo") String memo);
}
