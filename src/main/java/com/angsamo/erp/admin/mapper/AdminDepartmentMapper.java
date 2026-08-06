package com.angsamo.erp.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.admin.dto.DepartmentForm;
import com.angsamo.erp.admin.dto.DepartmentListItem;

@Mapper
public interface AdminDepartmentMapper {
	List<DepartmentListItem> findAll();
	DepartmentListItem findById(Long departmentId);
	int countByCode(@Param("code") String code, @Param("excludeId") Long excludeId);
	void insert(DepartmentForm form);
	void update(@Param("departmentId") Long departmentId, @Param("form") DepartmentForm form);
	void deactivate(Long departmentId);
}
