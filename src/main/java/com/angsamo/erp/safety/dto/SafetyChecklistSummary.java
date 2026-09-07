package com.angsamo.erp.safety.dto;

// 안전관리 대시보드 요약 카드용
public class SafetyChecklistSummary {

    private int monthlyChecklistCount;
    private int todayChecklistCount;
    private int monthlyItemCount;
    private int monthlyFailCount;

    public int getMonthlyChecklistCount() { return monthlyChecklistCount; }
    public void setMonthlyChecklistCount(int monthlyChecklistCount) { this.monthlyChecklistCount = monthlyChecklistCount; }
    public int getTodayChecklistCount() { return todayChecklistCount; }
    public void setTodayChecklistCount(int todayChecklistCount) { this.todayChecklistCount = todayChecklistCount; }
    public int getMonthlyItemCount() { return monthlyItemCount; }
    public void setMonthlyItemCount(int monthlyItemCount) { this.monthlyItemCount = monthlyItemCount; }
    public int getMonthlyFailCount() { return monthlyFailCount; }
    public void setMonthlyFailCount(int monthlyFailCount) { this.monthlyFailCount = monthlyFailCount; }

    public boolean isCheckedToday() { return todayChecklistCount > 0; }

    public int getPassRatePercent() {
        if (monthlyItemCount == 0) return 100;
        return Math.round((monthlyItemCount - monthlyFailCount) * 100f / monthlyItemCount);
    }
}
