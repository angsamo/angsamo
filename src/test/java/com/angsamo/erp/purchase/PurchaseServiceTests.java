package com.angsamo.erp.purchase;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.angsamo.erp.purchase.dto.ProcurementCreateForm;
import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.QuoteRequestForm;
import com.angsamo.erp.purchase.dto.ShortageMaterialRequestItem;
import com.angsamo.erp.purchase.dto.VendorForm;
import com.angsamo.erp.purchase.mapper.PurchaseMapper;
import com.angsamo.erp.purchase.service.PurchaseService;

@ExtendWith(MockitoExtension.class)
class PurchaseServiceTests {

    @Mock
    private PurchaseMapper purchaseMapper;

    @InjectMocks
    private PurchaseService purchaseService;

    private VendorForm vendorForm;

    @BeforeEach
    void setUp() {
        vendorForm = new VendorForm();
        vendorForm.setVendorCode("VENDOR001");
        vendorForm.setVendorName("테스트 협력업체");
        vendorForm.setContactName("홍길동");
        vendorForm.setPhone("010-1234-5678");
        vendorForm.setEmail("vendor@test.com");
        vendorForm.setAddress("서울시");
        vendorForm.setActive(true);
    }

    @Test
    void duplicateVendorCodeIsRejected() {
        when(purchaseMapper.countVendorCode("VENDOR001", null))
                .thenReturn(1);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> purchaseService.createVendor(vendorForm));

        assertEquals(
                "이미 사용 중인 업체코드입니다.",
                exception.getMessage());

        verify(purchaseMapper, never()).insertVendor(any());
    }

    @Test
    void missingVendorCannotBeUpdated() {
        when(purchaseMapper.findVendorById(999L))
                .thenReturn(null);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> purchaseService.updateVendor(999L, vendorForm));

        assertEquals(
                "협력업체를 찾을 수 없습니다.",
                exception.getMessage());

        verify(purchaseMapper, never())
                .updateVendor(anyLong(), any());
    }

    @Test
    void nonShortageRequestCannotCreateProcurement() {
        ProcurementCreateForm form = new ProcurementCreateForm();
        form.setMaterialRequestId(10L);
        form.setQuoteDeadline(LocalDate.now().plusDays(2));

        when(purchaseMapper.findShortageForUpdate(10L))
                .thenReturn(null);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> purchaseService.createProcurement(
                        form,
                        1L,
                        4L,
                        false));

        assertEquals(
                "부족 상태의 자재요청이 아닙니다.",
                exception.getMessage());

        verify(purchaseMapper, never()).insertProcurement(
                anyLong(), anyLong(), any(), anyLong());
    }

    @Test
    void duplicateProcurementIsRejected() {
        ProcurementCreateForm form = new ProcurementCreateForm();
        form.setMaterialRequestId(10L);
        form.setQuoteDeadline(LocalDate.now().plusDays(2));

        ShortageMaterialRequestItem shortage =
                createShortage(10L, LocalDate.now().plusDays(5));

        when(purchaseMapper.findShortageForUpdate(10L))
                .thenReturn(shortage);
        when(purchaseMapper.countActiveProcurementByRequest(10L))
                .thenReturn(1);

        IllegalStateException exception = assertThrows(
                IllegalStateException.class,
                () -> purchaseService.createProcurement(
                        form,
                        1L,
                        4L,
                        false));

        assertEquals(
                "이미 조달업무가 생성된 자재요청입니다.",
                exception.getMessage());

        verify(purchaseMapper, never()).insertProcurement(
                anyLong(), anyLong(), any(), anyLong());
    }

    @Test
    void quoteDeadlineAfterRequiredDateIsRejected() {
        ProcurementCreateForm form = new ProcurementCreateForm();
        form.setMaterialRequestId(10L);
        form.setQuoteDeadline(LocalDate.now().plusDays(10));

        ShortageMaterialRequestItem shortage =
                createShortage(10L, LocalDate.now().plusDays(5));

        when(purchaseMapper.findShortageForUpdate(10L))
                .thenReturn(shortage);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> purchaseService.createProcurement(
                        form,
                        1L,
                        4L,
                        false));

        assertEquals(
                "견적 마감일은 자재 필요일보다 늦을 수 없습니다.",
                exception.getMessage());

        verify(purchaseMapper, never()).insertProcurement(
                anyLong(), anyLong(), any(), anyLong());
    }

    @Test
    void quotesCannotBeRequestedWhenProcurementIsNotRequested() {
        ProcurementDetail procurement = new ProcurementDetail();
        procurement.setProcurementId(20L);
        procurement.setDepartmentId(4L);
        procurement.setStatus("QUOTING");

        QuoteRequestForm form = new QuoteRequestForm();
        form.setVendorIds(List.of(1L, 2L));

        when(purchaseMapper.findProcurementById(20L))
                .thenReturn(procurement);

        IllegalStateException exception = assertThrows(
                IllegalStateException.class,
                () -> purchaseService.requestQuotes(
                        20L,
                        form,
                        4L,
                        false));

        assertEquals(
                "REQUESTED 상태에서만 견적을 요청할 수 있습니다.",
                exception.getMessage());

        verify(purchaseMapper, never())
                .insertVendorQuote(anyLong(), anyLong());
    }

    @Test
    void duplicateVendorSelectionsCreateOneQuotePerVendor() {
        ProcurementDetail procurement = new ProcurementDetail();
        procurement.setProcurementId(20L);
        procurement.setDepartmentId(4L);
        procurement.setStatus("REQUESTED");

        QuoteRequestForm form = new QuoteRequestForm();
        form.setVendorIds(List.of(1L, 1L, 2L));

        when(purchaseMapper.findProcurementById(20L))
                .thenReturn(procurement);
        when(purchaseMapper.insertVendorQuote(20L, 1L))
                .thenReturn(1);
        when(purchaseMapper.insertVendorQuote(20L, 2L))
                .thenReturn(1);
        when(purchaseMapper.updateProcurementToQuoting(
                20L, 4L, false))
                .thenReturn(1);

        purchaseService.requestQuotes(
                20L,
                form,
                4L,
                false);

        verify(purchaseMapper, times(1))
                .insertVendorQuote(20L, 1L);
        verify(purchaseMapper, times(1))
                .insertVendorQuote(20L, 2L);
        verify(purchaseMapper, times(1))
                .updateProcurementToQuoting(20L, 4L, false);
    }

    private ShortageMaterialRequestItem createShortage(
            Long requestId,
            LocalDate requiredDate) {

        ShortageMaterialRequestItem shortage =
                new ShortageMaterialRequestItem();

        shortage.setRequestId(requestId);
        shortage.setItemId(100L);
        shortage.setRequestQty(new BigDecimal("10.000"));
        shortage.setIssuedQty(new BigDecimal("2.000"));
        shortage.setShortageQty(new BigDecimal("8.000"));
        shortage.setRequiredDate(requiredDate);
        shortage.setStatus("SHORTAGE");

        return shortage;
    }
}