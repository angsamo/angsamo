package com.angsamo.erp.purchase.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.ProcurementListItem;
import com.angsamo.erp.purchase.dto.ShortageMaterialRequestItem;
import com.angsamo.erp.purchase.dto.VendorDetail;
import com.angsamo.erp.purchase.dto.VendorForm;
import com.angsamo.erp.purchase.dto.VendorListItem;
import com.angsamo.erp.purchase.dto.VendorQuoteListItem;
import com.angsamo.erp.purchase.dto.VendorAccountItem;

@Mapper
public interface PurchaseMapper {

    List<VendorListItem> findAllVendors();

    List<VendorListItem> findActiveVendors();

    VendorDetail findVendorById(@Param("vendorId") Long vendorId);
    
    List<VendorAccountItem> findVendorAccounts(
            @Param("vendorId") Long vendorId);

    int countVendorCode(
            @Param("vendorCode") String vendorCode,
            @Param("excludeVendorId") Long excludeVendorId);

    int insertVendor(VendorForm form);

    int updateVendor(
            @Param("vendorId") Long vendorId,
            @Param("form") VendorForm form);

    int deactivateVendor(@Param("vendorId") Long vendorId);

    List<ShortageMaterialRequestItem> findShortageMaterialRequests();

    ShortageMaterialRequestItem findShortageForUpdate(
            @Param("requestId") Long requestId);

    int countActiveProcurementByRequest(
            @Param("materialRequestId") Long materialRequestId);

    int insertProcurement(
            @Param("materialRequestId") Long materialRequestId,
            @Param("departmentId") Long departmentId,
            @Param("quoteDeadline") LocalDate quoteDeadline,
            @Param("createdBy") Long createdBy);

    List<ProcurementListItem> findProcurements();

    ProcurementDetail findProcurementById(
            @Param("procurementId") Long procurementId);

    int updateProcurement(
            @Param("procurementId") Long procurementId,
            @Param("quoteDeadline") LocalDate quoteDeadline,
            @Param("terms") String terms,
            @Param("departmentId") Long departmentId,
            @Param("admin") boolean admin);

    int cancelProcurement(
            @Param("procurementId") Long procurementId,
            @Param("departmentId") Long departmentId,
            @Param("admin") boolean admin);

    int insertVendorQuote(
            @Param("procurementId") Long procurementId,
            @Param("vendorId") Long vendorId);

    int updateProcurementToQuoting(
            @Param("procurementId") Long procurementId,
            @Param("departmentId") Long departmentId,
            @Param("admin") boolean admin);

    List<VendorQuoteListItem> findVendorQuotes();

    Long findDepartmentIdByCode(@Param("departmentCode") String departmentCode);
}