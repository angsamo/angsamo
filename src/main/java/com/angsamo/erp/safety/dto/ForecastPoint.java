package com.angsamo.erp.safety.dto;

public class ForecastPoint {

    private String timeLabel;
    private String temperature;

    public ForecastPoint(String timeLabel, String temperature) {
        this.timeLabel = timeLabel;
        this.temperature = temperature;
    }

    public String getTimeLabel() { return timeLabel; }
    public String getTemperature() { return temperature; }
}
