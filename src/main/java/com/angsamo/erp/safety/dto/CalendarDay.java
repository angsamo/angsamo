package com.angsamo.erp.safety.dto;

// 날씨 달력의 한 칸. blank=true면 해당 월이 시작되기 전 빈 칸(요일 맞춤용)이다.
public class CalendarDay {

    private final boolean blank;
    private final String date;
    private final int dayNumber;
    private final Double temperature;
    private final Double precipitation;
    private final String riskLevel;
    private final String riskCssClass;
    private final boolean today;
    private final Double maxTemperature;
    private final Double minTemperature;
    private final Double snowfall;
    private final String alertSummary;
    private final String memo;

    public static CalendarDay blank() {
        return new CalendarDay(true, null, 0, null, null, null, "", false, null, null, null, null, null);
    }

    public CalendarDay(boolean blank, String date, int dayNumber, Double temperature, Double precipitation,
            String riskLevel, String riskCssClass, boolean today, Double maxTemperature, Double minTemperature,
            Double snowfall, String alertSummary, String memo) {
        this.blank = blank;
        this.date = date;
        this.dayNumber = dayNumber;
        this.temperature = temperature;
        this.precipitation = precipitation;
        this.riskLevel = riskLevel;
        this.riskCssClass = riskCssClass;
        this.today = today;
        this.maxTemperature = maxTemperature;
        this.minTemperature = minTemperature;
        this.snowfall = snowfall;
        this.alertSummary = alertSummary;
        this.memo = memo;
    }

    public boolean isBlank() { return blank; }
    public String getDate() { return date; }
    public int getDayNumber() { return dayNumber; }
    public Double getTemperature() { return temperature; }
    public Double getPrecipitation() { return precipitation; }
    public String getRiskLevel() { return riskLevel; }
    public String getRiskCssClass() { return riskCssClass; }
    public boolean isToday() { return today; }
    public boolean isHasData() { return temperature != null; }
    public Double getMaxTemperature() { return maxTemperature; }
    public Double getMinTemperature() { return minTemperature; }
    public Double getSnowfall() { return snowfall; }
    public String getAlertSummary() { return alertSummary; }
    public String getMemo() { return memo; }
}
