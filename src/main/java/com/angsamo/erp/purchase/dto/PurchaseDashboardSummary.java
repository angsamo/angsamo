package com.angsamo.erp.purchase.dto;

public class PurchaseDashboardSummary {

    private int totalProcurementCount;
    private int quotingCount;
    private int orderedCount;
    private int shippedWaitingCount;
    private int shortageWaitingCount;

    public int getTotalProcurementCount() { return totalProcurementCount; }
    public void setTotalProcurementCount(int totalProcurementCount) { this.totalProcurementCount = totalProcurementCount; }
    public int getQuotingCount() { return quotingCount; }
    public void setQuotingCount(int quotingCount) { this.quotingCount = quotingCount; }
    public int getOrderedCount() { return orderedCount; }
    public void setOrderedCount(int orderedCount) { this.orderedCount = orderedCount; }
    public int getShippedWaitingCount() { return shippedWaitingCount; }
    public void setShippedWaitingCount(int shippedWaitingCount) { this.shippedWaitingCount = shippedWaitingCount; }
    public int getShortageWaitingCount() { return shortageWaitingCount; }
    public void setShortageWaitingCount(int shortageWaitingCount) { this.shortageWaitingCount = shortageWaitingCount; }
}
