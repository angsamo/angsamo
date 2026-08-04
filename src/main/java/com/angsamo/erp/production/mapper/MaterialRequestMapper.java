package com.angsamo.erp.production.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.angsamo.erp.production.domain.MaterialRequest;

@Mapper
public interface MaterialRequestMapper {

    // 자재요청 전체 목록 조회
    List<MaterialRequest> findAll();
}