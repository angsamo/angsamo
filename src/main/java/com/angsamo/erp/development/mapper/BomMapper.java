package com.angsamo.erp.development.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.development.domain.Bom;

@Mapper
public interface BomMapper {

    // 전체 BOM 목록 조회
    List<Bom> findAll();

    // 완제품별 BOM 구성 자재 조회
    List<Bom> findByParentItemId(
            @Param("parentItemId") Long parentItemId
    );
}