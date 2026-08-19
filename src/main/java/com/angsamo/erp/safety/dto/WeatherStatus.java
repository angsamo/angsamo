package com.angsamo.erp.safety.dto;

import java.util.List;

public class WeatherStatus {

    private String temperature;
    private String precipitation;
    private String asosTemperature;
    private List<WeatherAlert> alerts;
    private List<ForecastPoint> hourlyForecast;
    private List<ForecastPoint> dailyForecast;
    private String riskLevel;
    private String dataSource;
    private String observedAt;
    private String statusMessage;

    public WeatherStatus(String temperature, String precipitation, String asosTemperature, List<WeatherAlert> alerts,
            List<ForecastPoint> hourlyForecast, List<ForecastPoint> dailyForecast, String riskLevel,
            String dataSource, String observedAt, String statusMessage) {
        this.temperature = temperature;
        this.precipitation = precipitation;
        this.asosTemperature = asosTemperature;
        this.alerts = alerts;
        this.hourlyForecast = hourlyForecast;
        this.dailyForecast = dailyForecast;
        this.riskLevel = riskLevel;
        this.dataSource = dataSource;
        this.observedAt = observedAt;
        this.statusMessage = statusMessage;
    }

    public String getTemperature() { return temperature; }
    public String getPrecipitation() { return precipitation; }
    public String getAsosTemperature() { return asosTemperature; }
    public List<WeatherAlert> getAlerts() { return alerts; }
    public List<ForecastPoint> getHourlyForecast() { return hourlyForecast; }
    public List<ForecastPoint> getDailyForecast() { return dailyForecast; }
    public String getRiskLevel() { return riskLevel; }
    public String getDataSource() { return dataSource; }
    public String getObservedAt() { return observedAt; }
    public String getStatusMessage() { return statusMessage; }

    public String getRiskMessage() {
        return switch (riskLevel) {
            case "위험" -> "기상 위험이 높습니다. 실외작업 중지 여부를 검토하세요.";
            case "주의" -> "기상 변화에 주의하며 작업 전 안전조치를 확인하세요.";
            case "안전" -> "현재 기상 조건은 작업 가능한 수준입니다.";
            default -> "날씨 연결 상태를 확인한 뒤 작업 여부를 결정하세요.";
        };
    }

    public String getRiskCssClass() {
        return switch (riskLevel) {
            case "위험" -> "danger";
            case "주의" -> "caution";
            default -> "safe";
        };
    }
}
