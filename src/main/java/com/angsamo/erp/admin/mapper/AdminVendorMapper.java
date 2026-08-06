package com.angsamo.erp.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.admin.dto.VendorItem;

@Mapper
public interface AdminVendorMapper {
	List<VendorItem> findAll();
	List<VendorItem> findPage(@Param("offset") int offset, @Param("size") int size, @Param("active") Boolean active);
	long count(@Param("active") Boolean active);
	VendorItem findById(Long vendorId);
	int countByCode(String vendorCode);
	void insert(VendorItem vendor);
	void update(@Param("vendorId") Long vendorId, @Param("vendorName") String vendorName);
}
