package com.angsamo.erp.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.admin.dto.VendorItem;
import com.angsamo.erp.admin.mapper.AdminVendorMapper;

@Service
public class AdminVendorService {
	private final AdminVendorMapper mapper;

	public AdminVendorService(AdminVendorMapper mapper) { this.mapper = mapper; }

	@Transactional(readOnly = true)
	public List<VendorItem> getVendors() { return mapper.findAll(); }

	@Transactional(readOnly = true)
	public VendorItem getVendor(String vendorId) { return mapper.findById(vendorId); }

	@Transactional
	public void create(VendorItem vendor) {
		normalize(vendor);
		if (mapper.countById(vendor.getVendorId()) > 0) throw new IllegalArgumentException("\uC774\uBBF8 \uC0AC\uC6A9 \uC911\uC778 \uD611\uB825\uD68C\uC0AC \uCF54\uB4DC\uC785\uB2C8\uB2E4.");
		mapper.insert(vendor);
	}

	@Transactional
	public void update(String vendorId, String vendorName) {
		if (vendorName == null || vendorName.isBlank()) throw new IllegalArgumentException("\uD611\uB825\uD68C\uC0AC\uBA85\uC744 \uC785\uB825\uD558\uC138\uC694.");
		mapper.update(vendorId, vendorName.trim());
	}

	private void normalize(VendorItem vendor) {
		String id = vendor.getVendorId() == null ? "" : vendor.getVendorId().trim().toUpperCase();
		String name = vendor.getVendorName() == null ? "" : vendor.getVendorName().trim();
		if (!id.matches("[A-Z0-9_-]+")) throw new IllegalArgumentException("\uD611\uB825\uD68C\uC0AC \uCF54\uB4DC\uB294 \uC601\uBB38, \uC22B\uC790, _, -\uB9CC \uC0AC\uC6A9\uD558\uC138\uC694.");
		if (name.isBlank()) throw new IllegalArgumentException("\uD611\uB825\uD68C\uC0AC\uBA85\uC744 \uC785\uB825\uD558\uC138\uC694.");
		vendor.setVendorId(id); vendor.setVendorName(name);
	}
}
