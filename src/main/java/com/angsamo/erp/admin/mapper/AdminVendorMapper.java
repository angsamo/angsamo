package com.angsamo.erp.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.admin.dto.VendorItem;

@Mapper
public interface AdminVendorMapper {
	List<VendorItem> findAll();
	VendorItem findById(Long vendorId);
	int countByCode(String vendorCode);
	void insert(VendorItem vendor);
	void update(@Param("vendorId") Long vendorId, @Param("vendorName") String vendorName);
}
