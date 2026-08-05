package com.angsamo.erp.vendor;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.angsamo.erp.vendor.mapper.VendorMapper;
import com.angsamo.erp.vendor.service.VendorService;

/** 협력회사 상태 변경 시 업체와 기존 상태 조건이 실패하면 처리를 중단하는지 검증한다. */
@ExtendWith(MockitoExtension.class)
class VendorServiceTests {
    @Mock
    private VendorMapper vendorMapper;

    private VendorService vendorService;

    @BeforeEach
    void setUp() {
        vendorService = new VendorService(vendorMapper);
    }

    @Test
    void quoteRequiresPositivePrice() {
        assertThrows(IllegalArgumentException.class,
                () -> vendorService.submitQuote(1L, 2L, BigDecimal.ZERO,
                        LocalDate.now().plusDays(1), "검수 후 결제"));
    }

    @Test
    void quoteSubmissionUsesVendorScope() {
        when(vendorMapper.submitQuote(1L, 2L, new BigDecimal("15000"),
                LocalDate.now().plusDays(10), "검수 후 결제")).thenReturn(1);

        vendorService.submitQuote(1L, 2L, new BigDecimal("15000"),
                LocalDate.now().plusDays(10), "검수 후 결제");

        verify(vendorMapper).submitQuote(1L, 2L, new BigDecimal("15000"),
                LocalDate.now().plusDays(10), "검수 후 결제");
    }

    @Test
    void unselectedVendorCannotStartProduction() {
        when(vendorMapper.startProduction(10L, 20L)).thenReturn(0);
        assertThrows(IllegalStateException.class, () -> vendorService.startProduction(10L, 20L));
    }

    @Test
    void onlyInProgressOrderCanShip() {
        when(vendorMapper.shipOrder(10L, 20L)).thenReturn(0);
        assertThrows(IllegalStateException.class, () -> vendorService.shipOrder(10L, 20L));
    }
}
