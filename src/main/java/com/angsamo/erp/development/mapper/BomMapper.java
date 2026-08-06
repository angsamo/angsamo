package com.angsamo.erp.development.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.development.domain.Bom;

@Mapper
public interface BomMapper {
	List<Bom> findAll();

	List<Bom> search(@Param("keyword") String keyword);

	Bom findByBomId(@Param("bomId") Long bomId);

	Bom findByParentAndComponent(
	        @Param("parentItemId") Long parentItemId,
	        @Param("componentItemId") Long componentItemId
	);

	List<Bom> findByParentItemId(
	        @Param("parentItemId") Long parentItemId
	);

	int insert(Bom bom);

	int update(Bom bom);

	int delete(@Param("bomId") Long bomId);
}
