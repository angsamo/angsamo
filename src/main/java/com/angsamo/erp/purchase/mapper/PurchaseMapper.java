package com.angsamo.erp.purchase.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.ProcurementListItem;
import com.angsamo.erp.purchase.dto.ShortageMaterialRequestItem;
import com.angsamo.erp.purchase.dto.VendorDetail;
import com.angsamo.erp.purchase.dto.VendorListItem;
import com.angsamo.erp.purchase.dto.VendorQuoteListItem;

@Mapper
public interface PurchaseMapper {

    List<VendorListItem> findAllVendors();

    VendorDetail findVendorById(@Param("vendorId") Long vendorId);

    List<ShortageMaterialRequestItem> findShortageMaterialRequests();

    List<ProcurementListItem> findProcurements();

    ProcurementDetail findProcurementById(@Param("procurementId") Long procurementId);

    List<VendorQuoteListItem> findVendorQuotes();
}
