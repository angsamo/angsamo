package com.angsamo.erp.vendor.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.vendor.dto.VendorDashboardSummary;
import com.angsamo.erp.vendor.dto.VendorOrderItem;
import com.angsamo.erp.vendor.dto.VendorQuoteItem;
import com.angsamo.erp.vendor.mapper.VendorMapper;

/** 협력회사 견적과 제작·출하 상태 변경 규칙을 처리한다. */
@Service
public class VendorService {
    private final VendorMapper vendorMapper;

    public VendorService(VendorMapper vendorMapper) {
        this.vendorMapper = vendorMapper;
    }

    @Transactional(readOnly = true)
    public VendorDashboardSummary dashboard(Long vendorId) {
        return vendorMapper.findDashboardSummary(vendorId);
    }

    @Transactional(readOnly = true)
    public List<VendorQuoteItem> quotes(Long vendorId, String status) {
        return vendorMapper.findQuotes(vendorId, normalizeFilter(status));
    }

    @Transactional(readOnly = true)
    public List<VendorOrderItem> orders(Long vendorId, String status) {
        return vendorMapper.findOrders(vendorId, normalizeFilter(status));
    }

    @Transactional(readOnly = true)
    public List<VendorOrderItem> inspections(Long vendorId) {
        return vendorMapper.findInspections(vendorId);
    }

    @Transactional(readOnly = true)
    public List<VendorOrderItem> returns(Long vendorId) {
        return vendorMapper.findReturns(vendorId);
    }

    @Transactional(readOnly = true)
    public List<VendorOrderItem> statements(Long vendorId) {
        return vendorMapper.findStatements(vendorId);
    }

    @Transactional(readOnly = true)
    public VendorOrderItem order(long procurementId, Long vendorId) {
        VendorOrderItem order = vendorMapper.findOrder(procurementId, vendorId);
        if (order == null) throw new IllegalArgumentException("내 회사 발주 정보를 찾을 수 없습니다.");
        return order;
    }

    @Transactional
    public void submitQuote(long quoteId, long vendorId, BigDecimal unitPrice,
            LocalDate deliveryDate, String terms) {
        if (unitPrice == null || unitPrice.signum() <= 0) {
            throw new IllegalArgumentException("견적 단가는 0보다 커야 합니다.");
        }
        if (deliveryDate == null || deliveryDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("납품 가능일은 오늘 이후 날짜여야 합니다.");
        }
        if (terms == null || terms.isBlank()) {
            throw new IllegalArgumentException("거래 조건을 입력해 주세요.");
        }
        if (terms.length() > 500) {
            throw new IllegalArgumentException("거래 조건은 500자 이내로 입력해 주세요.");
        }
        if (vendorMapper.submitQuote(quoteId, vendorId, unitPrice, deliveryDate, terms.trim()) != 1) {
            throw new IllegalStateException("제출 가능한 견적이 아니거나 견적 마감일이 지났습니다.");
        }
    }

    @Transactional
    public void startProduction(long procurementId, long vendorId) {
        if (vendorMapper.startProduction(procurementId, vendorId) != 1) {
            throw new IllegalStateException("발주 완료 상태인 내 회사 조달 건만 제작을 시작할 수 있습니다.");
        }
    }

    @Transactional
    public void shipOrder(long procurementId, long vendorId) {
        if (vendorMapper.shipOrder(procurementId, vendorId) != 1) {
            throw new IllegalStateException("제작 중인 내 회사 조달 건만 출하할 수 있습니다.");
        }
    }

    @Transactional
    public void reshipReturn(long procurementId, long vendorId) {
        if (vendorMapper.reshipReturn(procurementId, vendorId) != 1) {
            throw new IllegalStateException("보완 대상인 내 회사 반품 건만 재출하할 수 있습니다.");
        }
    }

    private String normalizeFilter(String status) {
        return status == null || status.isBlank() ? null : status.trim().toUpperCase();
    }
}
