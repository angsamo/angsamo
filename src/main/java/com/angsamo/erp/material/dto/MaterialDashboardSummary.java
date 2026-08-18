package com.angsamo.erp.material.dto;

public class MaterialDashboardSummary {

    private int totalInventoryItemCount;
    private int pendingReceivingCount;
    private int pendingIssueCount;
    private int shortageIssueCount;
    private int returnInProgressCount;

    public int getTotalInventoryItemCount() { return totalInventoryItemCount; }
    public void setTotalInventoryItemCount(int totalInventoryItemCount) { this.totalInventoryItemCount = totalInventoryItemCount; }
    public int getPendingReceivingCount() { return pendingReceivingCount; }
    public void setPendingReceivingCount(int pendingReceivingCount) { this.pendingReceivingCount = pendingReceivingCount; }
    public int getPendingIssueCount() { return pendingIssueCount; }
    public void setPendingIssueCount(int pendingIssueCount) { this.pendingIssueCount = pendingIssueCount; }
    public int getShortageIssueCount() { return shortageIssueCount; }
    public void setShortageIssueCount(int shortageIssueCount) { this.shortageIssueCount = shortageIssueCount; }
    public int getReturnInProgressCount() { return returnInProgressCount; }
    public void setReturnInProgressCount(int returnInProgressCount) { this.returnInProgressCount = returnInProgressCount; }
}
