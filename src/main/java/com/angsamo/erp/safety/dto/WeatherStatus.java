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

    public WeatherStatus(String temperature, String precipitation, String asosTemperature, List<WeatherAlert> alerts,
            List<ForecastPoint> hourlyForecast, List<ForecastPoint> dailyForecast, String riskLevel) {
        this.temperature = temperature;
        this.precipitation = precipitation;
        this.asosTemperature = asosTemperature;
        this.alerts = alerts;
        this.hourlyForecast = hourlyForecast;
        this.dailyForecast = dailyForecast;
        this.riskLevel = riskLevel;
    }

    public String getTemperature() { return temperature; }
    public String getPrecipitation() { return precipitation; }
    public String getAsosTemperature() { return asosTemperature; }
    public List<WeatherAlert> getAlerts() { return alerts; }
    public List<ForecastPoint> getHourlyForecast() { return hourlyForecast; }
    public List<ForecastPoint> getDailyForecast() { return dailyForecast; }
    public String getRiskLevel() { return riskLevel; }
}
