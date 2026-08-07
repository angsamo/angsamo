package com.angsamo.erp.purchase.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.purchase.dto.ProcurementCreateForm;
import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.PurchaseProgressItem;
import com.angsamo.erp.purchase.dto.PurchaseReceivingItem;
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
        return getVendors(null, null);
    }

    @Transactional(readOnly = true)
    public List<VendorListItem> getVendors(String keyword, Boolean active) {
        return purchaseMapper.findAllVendors(normalizeFilter(keyword), active);
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

    @Transactional(readOnly = true)
    public ShortageMaterialRequestItem getShortageMaterialRequest(Long requestId) {
        if (requestId == null) {
            throw new IllegalArgumentException("자재요청 번호를 확인하세요.");
        }
        return purchaseMapper.findShortageById(requestId);
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
        return getProcurements(null, null);
    }

    @Transactional(readOnly = true)
    public List<ProcurementListItem> getProcurements(String keyword, String status) {
        return purchaseMapper.findProcurements(
                normalizeFilter(keyword), normalizeFilter(status));
    }

    private String normalizeFilter(String value) {
        return value == null || value.isBlank() ? null : value.trim();
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

        if (!admin && !java.util.Objects.equals(
                procurement.getDepartmentId(), departmentId)) {
            throw new SecurityException(
                    "다른 부서의 조달업무에는 견적을 요청할 수 없습니다.");
        }

        if (procurement.getQuoteDeadline() == null
                || procurement.getQuoteDeadline().isBefore(LocalDate.now())) {
            throw new IllegalStateException(
                    "견적 마감일이 지나 견적을 요청할 수 없습니다.");
        }

        if (form == null || form.getVendorIds() == null) {
            throw new IllegalArgumentException(
                    "비교 견적을 위해 협력업체를 두 곳 이상 선택하세요.");
        }

        List<Long> vendorIds = form.getVendorIds()
                .stream()
                .filter(java.util.Objects::nonNull)
                .distinct()
                .toList();

        if (vendorIds.size() < 2) {
            throw new IllegalArgumentException(
                    "비교 견적을 위해 서로 다른 협력업체를 두 곳 이상 선택하세요.");
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
        return getVendorQuotes(null, null);
    }

    @Transactional(readOnly = true)
    public List<VendorQuoteListItem> getVendorQuotes(String keyword, String status) {
        return purchaseMapper.findVendorQuotes(
                normalizeFilter(keyword), normalizeFilter(status));
    }

    @Transactional
    public void selectQuote(
            Long procurementId,
            Long quoteId,
            Long departmentId,
            boolean admin) {

        if (procurementId == null || quoteId == null) {
            throw new IllegalArgumentException("선정할 견적을 확인하세요.");
        }

        int updated = purchaseMapper.selectProcurementQuote(
                procurementId, quoteId, departmentId, admin);

        if (updated != 1) {
            throw new IllegalStateException(
                    "제출 완료된 견적만 선정할 수 있거나 조달업무 수정 권한이 없습니다.");
        }

        if (purchaseMapper.markQuoteSelected(procurementId, quoteId) != 1) {
            throw new IllegalStateException("견적 선정 상태를 변경하지 못했습니다.");
        }

        purchaseMapper.rejectOtherQuotes(procurementId, quoteId);
    }

    @Transactional
    public void confirmContract(
            Long procurementId,
            String terms,
            Long departmentId,
            boolean admin) {

        if (terms == null || terms.isBlank()) {
            throw new IllegalArgumentException("확정할 계약조건을 입력하세요.");
        }

        String normalizedTerms = terms.trim();
        if (normalizedTerms.length() > 1000) {
            throw new IllegalArgumentException("계약조건은 1000자 이내로 입력하세요.");
        }

        int updated = purchaseMapper.confirmContract(
                procurementId, normalizedTerms, departmentId, admin);

        if (updated != 1) {
            throw new IllegalStateException(
                    "업체가 선정된 담당 부서의 조달업무만 계약 확정할 수 있습니다.");
        }
    }

    @Transactional
    public void issuePurchaseOrder(
            Long procurementId,
            BigDecimal orderQty,
            LocalDate requiredDate,
            Long departmentId,
            boolean admin) {

        if (orderQty == null || orderQty.signum() <= 0) {
            throw new IllegalArgumentException("발주 수량은 0보다 커야 합니다.");
        }
        if (requiredDate == null) {
            throw new IllegalArgumentException("요구 납기일을 입력하세요.");
        }

        ProcurementDetail procurement =
                purchaseMapper.findProcurementById(procurementId);
        if (procurement == null) {
            throw new IllegalArgumentException("조달업무를 찾을 수 없습니다.");
        }
        if (!"CONTRACTED".equals(procurement.getStatus())) {
            throw new IllegalStateException("계약 확정된 조달업무만 발주할 수 있습니다.");
        }
        if (procurement.getRequestQty() == null
                || orderQty.compareTo(procurement.getRequestQty()) != 0) {
            throw new IllegalArgumentException(
                    "발주 수량은 조달 필요수량과 같아야 합니다.");
        }
        if (requiredDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("요구 납기일은 오늘 이후여야 합니다.");
        }
        if (procurement.getRequiredDate() != null
                && requiredDate.isAfter(procurement.getRequiredDate())) {
            throw new IllegalArgumentException(
                    "요구 납기일은 자재 필요일보다 늦을 수 없습니다.");
        }

        int updated = purchaseMapper.issuePurchaseOrder(
                procurementId,
                orderQty,
                requiredDate,
                departmentId,
                admin);

        if (updated != 1) {
            throw new IllegalStateException(
                    "계약 확정된 담당 부서의 조달업무만 발주할 수 있습니다.");
        }
    }

    @Transactional(readOnly = true)
    public List<PurchaseProgressItem> getPurchaseProgress() {
        return purchaseMapper.findPurchaseProgress();
    }

    @Transactional(readOnly = true)
    public List<PurchaseReceivingItem> getPurchaseReceivings() {
        return getPurchaseReceivings(null, null);
    }

    @Transactional(readOnly = true)
    public List<PurchaseReceivingItem> getPurchaseReceivings(
            String keyword, String status) {
        return purchaseMapper.findPurchaseReceivings(
                normalizeFilter(keyword), normalizeFilter(status));
    }

    @Transactional
    public void closeReceivedOrder(
            Long procurementId,
            Long departmentId,
            boolean admin) {

        if (purchaseMapper.closeReceivedOrder(
                procurementId, departmentId, admin) != 1) {
            throw new IllegalStateException(
                    "정상 검수된 전량 입고 발주만 마감할 수 있습니다.");
        }
    }

}
