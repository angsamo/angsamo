package com.angsamo.erp.safety.domain;

import java.time.LocalDate;

// 날씨 달력용 일별 스냅샷. 하루에 여러 번 갱신될 수 있어 그날의 "마지막 조회" 값을 저장한다.
public class WeatherDailyLog {

    private LocalDate logDate;
    private Double temperature;
    private Double precipitation;
    private String riskLevel;
    private Double maxTemperature;
    private Double minTemperature;
    private Double snowfall;
    private String alertSummary;
    private String memo;

    public LocalDate getLogDate() { return logDate; }
    public void setLogDate(LocalDate logDate) { this.logDate = logDate; }
    public Double getTemperature() { return temperature; }
    public void setTemperature(Double temperature) { this.temperature = temperature; }
    public Double getPrecipitation() { return precipitation; }
    public void setPrecipitation(Double precipitation) { this.precipitation = precipitation; }
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
    public Double getMaxTemperature() { return maxTemperature; }
    public void setMaxTemperature(Double maxTemperature) { this.maxTemperature = maxTemperature; }
    public Double getMinTemperature() { return minTemperature; }
    public void setMinTemperature(Double minTemperature) { this.minTemperature = minTemperature; }
    public Double getSnowfall() { return snowfall; }
    public void setSnowfall(Double snowfall) { this.snowfall = snowfall; }
    public String getAlertSummary() { return alertSummary; }
    public void setAlertSummary(String alertSummary) { this.alertSummary = alertSummary; }
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }

    public String getRiskCssClass() {
        if (riskLevel == null) return "";
        return switch (riskLevel) {
            case "위험" -> "danger";
            case "주의" -> "caution";
            case "안전" -> "safe";
            default -> "";
        };
    }
}
