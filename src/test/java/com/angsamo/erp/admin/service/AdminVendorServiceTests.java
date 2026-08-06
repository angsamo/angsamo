package com.angsamo.erp.admin.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.Test;

import com.angsamo.erp.admin.dto.VendorItem;
import com.angsamo.erp.admin.mapper.AdminVendorMapper;

class AdminVendorServiceTests {
	@Test
	void normalizesVendorBeforeInsert() {
		AdminVendorMapper mapper = mock(AdminVendorMapper.class);
		AdminVendorService service = new AdminVendorService(mapper);
		VendorItem vendor = new VendorItem();
		vendor.setVendorCode(" vendor-01 ");
		vendor.setVendorName(" \uD14C\uC2A4\uD2B8 \uD611\uB825\uC0AC ");

		service.create(vendor);

		assertEquals("VENDOR-01", vendor.getVendorCode());
		verify(mapper).insert(vendor);
	}
}
