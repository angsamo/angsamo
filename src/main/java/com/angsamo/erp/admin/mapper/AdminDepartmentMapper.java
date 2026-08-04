package com.angsamo.erp.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.angsamo.erp.admin.dto.DepartmentListItem;

@Mapper
public interface AdminDepartmentMapper {
	List<DepartmentListItem> findAll();
}
