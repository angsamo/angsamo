package com.angsamo.erp.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.admin.dto.VendorItem;

@Mapper
public interface AdminVendorMapper {
	List<VendorItem> findAll();
	VendorItem findById(String vendorId);
	int countById(String vendorId);
	void insert(VendorItem vendor);
	void update(@Param("vendorId") String vendorId, @Param("vendorName") String vendorName);
}
