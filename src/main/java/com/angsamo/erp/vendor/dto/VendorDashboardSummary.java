package com.angsamo.erp.vendor.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** 협력회사 대시보드의 업무 건수를 전달한다. */
@Getter
@Setter
@NoArgsConstructor
public class VendorDashboardSummary {
    private long requestedQuoteCount;
    private long submittedQuoteCount;
    private long orderedCount;
    private long inProgressCount;
    private long shippedCount;
    private long returnCount;
}
