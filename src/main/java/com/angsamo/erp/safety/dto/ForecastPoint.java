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

    /** -15~40℃ 범위를 차트 높이 8~100%로 변환한다. */
    public int getChartHeight() {
        try {
            double value = Double.parseDouble(temperature);
            return (int) Math.max(8, Math.min(100, ((value + 15) / 55) * 100));
        } catch (Exception e) {
            return 8;
        }
    }
}
