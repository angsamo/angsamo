package com.angsamo.erp.production.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.angsamo.erp.production.domain.ProductionPlan;

@Mapper
public interface ProductionPlanMapper {

    // 생산계획 전체 목록 조회
    List<ProductionPlan> findAll();
}