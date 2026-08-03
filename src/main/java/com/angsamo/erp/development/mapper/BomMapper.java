package com.angsamo.erp.development.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.development.domain.Bom;

@Mapper
public interface BomMapper {

    List<Bom> findAll();

    Bom findByBomId(@Param("bomId") Long bomId);

    void insert(Bom bom);

    void update(Bom bom);

    int deleteByBomId(@Param("bomId") Long bomId);

}