package com.angsamo.erp.production.domain;

public class ProductionDashboardSummary {

    private int totalPlanCount;
    private int plannedCount;
    private int inProgressCount;
    private int completedCount;
    private int shortageRequestCount;

    public int getTotalPlanCount() { return totalPlanCount; }
    public void setTotalPlanCount(int totalPlanCount) { this.totalPlanCount = totalPlanCount; }
    public int getPlannedCount() { return plannedCount; }
    public void setPlannedCount(int plannedCount) { this.plannedCount = plannedCount; }
    public int getInProgressCount() { return inProgressCount; }
    public void setInProgressCount(int inProgressCount) { this.inProgressCount = inProgressCount; }
    public int getCompletedCount() { return completedCount; }
    public void setCompletedCount(int completedCount) { this.completedCount = completedCount; }
    public int getShortageRequestCount() { return shortageRequestCount; }
    public void setShortageRequestCount(int shortageRequestCount) { this.shortageRequestCount = shortageRequestCount; }
}
