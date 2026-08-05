package com.angsamo.erp.production.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.production.domain.MaterialRequest;

@Mapper
public interface MaterialRequestMapper {

    // 자재요청 전체 목록 조회
    List<MaterialRequest> findAll();

    // 자재요청 상세 조회
    MaterialRequest findById(
            @Param("requestId") Long requestId
    );

    // 같은 생산계획 + 품목 중복 여부 확인
    int countByProductionPlanIdAndItemId(
            @Param("productionPlanId") Long productionPlanId,
            @Param("itemId") Long itemId
    );

    // 자재요청 등록
    int insert(MaterialRequest materialRequest);

    // REQUESTED 상태 요청 수량·필요일 수정
    int updateRequested(
            MaterialRequest materialRequest
    );

    // REQUESTED 상태 요청 취소
    int cancelRequested(
            @Param("requestId") Long requestId
    );

    // 특정 생산계획의 자재요청 목록 조회
    List<MaterialRequest> findByProductionPlanId(
            @Param("productionPlanId") Long productionPlanId
    );
}