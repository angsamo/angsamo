package com.angsamo.erp.production.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.angsamo.erp.production.domain.MaterialRequirement;

@Mapper
public interface MaterialRequirementMapper {

    List<MaterialRequirement> findAll();
}
