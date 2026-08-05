package com.angsamo.erp.production.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.production.domain.ProductionPlan;

@Mapper
public interface ProductionPlanMapper {

    // 생산계획 전체 목록 조회
    List<ProductionPlan> findAll();

    // 생산계획 상세 조회
    ProductionPlan findById(
            @Param("productionPlanId") Long productionPlanId
    );

    // 생산계획 등록
    int insert(ProductionPlan productionPlan);

    // 생산 수량과 예정일 수정
    int update(ProductionPlan productionPlan);

    // 생산계획 상태 변경
    int updateStatus(
            @Param("productionPlanId") Long productionPlanId,
            @Param("status") String status
    );
}