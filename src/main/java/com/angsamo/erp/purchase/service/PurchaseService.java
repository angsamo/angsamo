package com.angsamo.erp.purchase.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.ProcurementListItem;
import com.angsamo.erp.purchase.dto.ShortageMaterialRequestItem;
import com.angsamo.erp.purchase.dto.VendorDetail;
import com.angsamo.erp.purchase.dto.VendorListItem;
import com.angsamo.erp.purchase.dto.VendorQuoteListItem;
import com.angsamo.erp.purchase.mapper.PurchaseMapper;

@Service
public class PurchaseService {

    private final PurchaseMapper purchaseMapper;

    public PurchaseService(PurchaseMapper purchaseMapper) {
        this.purchaseMapper = purchaseMapper;
    }

    @Transactional(readOnly = true)
    public List<VendorListItem> getVendors() {
        return purchaseMapper.findAllVendors();
    }

    @Transactional(readOnly = true)
    public VendorDetail getVendor(Long vendorId) {
        return purchaseMapper.findVendorById(vendorId);
    }

    @Transactional(readOnly = true)
    public List<ShortageMaterialRequestItem> getShortageMaterialRequests() {
        return purchaseMapper.findShortageMaterialRequests();
    }

    @Transactional(readOnly = true)
    public List<ProcurementListItem> getProcurements() {
        return purchaseMapper.findProcurements();
    }

    @Transactional(readOnly = true)
    public ProcurementDetail getProcurement(Long procurementId) {
        return purchaseMapper.findProcurementById(procurementId);
    }

    @Transactional(readOnly = true)
    public List<VendorQuoteListItem> getVendorQuotes() {
        return purchaseMapper.findVendorQuotes();
    }
}
