package com.angsamo.erp.purchase.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.purchase.dto.ProcurementCreateForm;
import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.ProcurementListItem;
import com.angsamo.erp.purchase.dto.QuoteRequestForm;
import com.angsamo.erp.purchase.dto.ShortageMaterialRequestItem;
import com.angsamo.erp.purchase.dto.VendorDetail;
import com.angsamo.erp.purchase.dto.VendorForm;
import com.angsamo.erp.purchase.dto.VendorListItem;
import com.angsamo.erp.purchase.dto.VendorQuoteListItem;
import com.angsamo.erp.purchase.mapper.PurchaseMapper;
import com.angsamo.erp.purchase.dto.VendorAccountItem;

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
    public List<VendorListItem> getActiveVendors() {
        return purchaseMapper.findActiveVendors();
    }

    @Transactional(readOnly = true)
    public VendorDetail getVendor(Long vendorId) {
        return purchaseMapper.findVendorById(vendorId);
    }
    
    @Transactional(readOnly = true)
    public List<VendorAccountItem> getVendorAccounts(Long vendorId) {
        return purchaseMapper.findVendorAccounts(vendorId);
    }

    @Transactional
    public void createVendor(VendorForm form) {
        normalizeVendor(form);
        validateVendorCode(form.getVendorCode(), null);

        if (purchaseMapper.insertVendor(form) != 1) {
            throw new IllegalStateException("협력업체 등록에 실패했습니다.");
        }
    }

    @Transactional
    public void updateVendor(Long vendorId, VendorForm form) {
        VendorDetail vendor = purchaseMapper.findVendorById(vendorId);

        if (vendor == null) {
            throw new IllegalArgumentException("협력업체를 찾을 수 없습니다.");
        }

        normalizeVendor(form);
        validateVendorCode(form.getVendorCode(), vendorId);

        if (purchaseMapper.updateVendor(vendorId, form) != 1) {
            throw new IllegalStateException("협력업체 수정에 실패했습니다.");
        }
    }

    @Transactional
    public void deactivateVendor(Long vendorId) {
        if (purchaseMapper.deactivateVendor(vendorId) != 1) {
            throw new IllegalStateException("이미 거래 중지됐거나 존재하지 않는 업체입니다.");
        }
    }

    private void normalizeVendor(VendorForm form) {
        form.setVendorCode(form.getVendorCode().trim().toUpperCase());
        form.setVendorName(form.getVendorName().trim());

        if (form.getContactName() != null) {
            form.setContactName(form.getContactName().trim());
        }
        if (form.getPhone() != null) {
            form.setPhone(form.getPhone().trim());
        }
        if (form.getEmail() != null) {
            form.setEmail(form.getEmail().trim());
        }
        if (form.getAddress() != null) {
            form.setAddress(form.getAddress().trim());
        }
        if (form.getActive() == null) {
            form.setActive(true);
        }
    }

    private void validateVendorCode(String vendorCode, Long excludeVendorId) {
        if (purchaseMapper.countVendorCode(vendorCode, excludeVendorId) > 0) {
            throw new IllegalArgumentException("이미 사용 중인 업체코드입니다.");
        }
    }

    @Transactional(readOnly = true)
    public List<ShortageMaterialRequestItem> getShortageMaterialRequests() {
        return purchaseMapper.findShortageMaterialRequests();
    }

    @Transactional
    public void createProcurement(
            ProcurementCreateForm form,
            Long userId,
            Long sessionDepartmentId,
            boolean admin) {

        if (userId == null) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }

        Long purchaseDepartmentId = admin
                ? purchaseMapper.findDepartmentIdByCode("PURCHASE")
                : sessionDepartmentId;

        if (purchaseDepartmentId == null) {
            throw new IllegalStateException("구매부서 정보를 확인할 수 없습니다.");
        }

        ShortageMaterialRequestItem shortage =
                purchaseMapper.findShortageForUpdate(form.getMaterialRequestId());

        if (shortage == null) {
            throw new IllegalArgumentException("부족 상태의 자재요청이 아닙니다.");
        }

        if (form.getQuoteDeadline().isAfter(shortage.getRequiredDate())) {
            throw new IllegalArgumentException(
                    "견적 마감일은 자재 필요일보다 늦을 수 없습니다.");
        }

        if (purchaseMapper.countActiveProcurementByRequest(
                form.getMaterialRequestId()) > 0) {
            throw new IllegalStateException(
                    "이미 조달업무가 생성된 자재요청입니다.");
        }

        int inserted = purchaseMapper.insertProcurement(
                form.getMaterialRequestId(),
                purchaseDepartmentId,
                form.getQuoteDeadline(),
                userId);

        if (inserted != 1) {
            throw new IllegalStateException("조달업무 생성에 실패했습니다.");
        }
    }

    @Transactional(readOnly = true)
    public List<ProcurementListItem> getProcurements() {
        return purchaseMapper.findProcurements();
    }

    @Transactional(readOnly = true)
    public ProcurementDetail getProcurement(Long procurementId) {
        return purchaseMapper.findProcurementById(procurementId);
    }

    @Transactional
    public void updateProcurement(
            Long procurementId,
            LocalDate quoteDeadline,
            String terms,
            Long departmentId,
            boolean admin) {

        ProcurementDetail procurement =
                purchaseMapper.findProcurementById(procurementId);

        if (procurement == null) {
            throw new IllegalArgumentException("조달업무를 찾을 수 없습니다.");
        }

        if (quoteDeadline == null) {
            throw new IllegalArgumentException("견적 마감일을 입력하세요.");
        }

        if (quoteDeadline.isAfter(procurement.getRequiredDate())) {
            throw new IllegalArgumentException(
                    "견적 마감일은 자재 필요일보다 늦을 수 없습니다.");
        }

        int updated = purchaseMapper.updateProcurement(
                procurementId,
                quoteDeadline,
                terms,
                departmentId,
                admin);

        if (updated != 1) {
            throw new IllegalStateException(
                    "REQUESTED 상태의 담당 부서 조달업무만 수정할 수 있습니다.");
        }
    }

    @Transactional
    public void cancelProcurement(
            Long procurementId,
            Long departmentId,
            boolean admin) {

        int updated = purchaseMapper.cancelProcurement(
                procurementId,
                departmentId,
                admin);

        if (updated != 1) {
            throw new IllegalStateException(
                    "취소할 수 없거나 권한이 없는 조달업무입니다.");
        }
    }

    @Transactional
    public void requestQuotes(
            Long procurementId,
            QuoteRequestForm form,
            Long departmentId,
            boolean admin) {

        ProcurementDetail procurement =
                purchaseMapper.findProcurementById(procurementId);

        if (procurement == null) {
            throw new IllegalArgumentException("조달업무를 찾을 수 없습니다.");
        }

        if (!"REQUESTED".equals(procurement.getStatus())) {
            throw new IllegalStateException(
                    "REQUESTED 상태에서만 견적을 요청할 수 있습니다.");
        }

        List<Long> vendorIds = form.getVendorIds()
                .stream()
                .distinct()
                .toList();

        if (vendorIds.isEmpty()) {
            throw new IllegalArgumentException("협력업체를 선택하세요.");
        }

        for (Long vendorId : vendorIds) {
            if (purchaseMapper.insertVendorQuote(procurementId, vendorId) != 1) {
                throw new IllegalStateException(
                        "거래 중지 업체이거나 이미 견적을 요청한 업체입니다.");
            }
        }

        int updated = purchaseMapper.updateProcurementToQuoting(
                procurementId,
                departmentId,
                admin);

        if (updated != 1) {
            throw new IllegalStateException(
                    "조달 상태를 QUOTING으로 변경하지 못했습니다.");
        }
    }

    @Transactional(readOnly = true)
    public List<VendorQuoteListItem> getVendorQuotes() {
        return purchaseMapper.findVendorQuotes();
    }
}