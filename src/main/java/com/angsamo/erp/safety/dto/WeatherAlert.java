package com.angsamo.erp.safety.dto;

public class WeatherAlert {

    private String type;
    private String level;
    private String regionName;

    public WeatherAlert(String type, String level, String regionName) {
        this.type = type;
        this.level = level;
        this.regionName = regionName;
    }

    public String getType() { return type; }
    public String getLevel() { return level; }
    public String getRegionName() { return regionName; }

    public String getMessage() {
        String label = switch (type) {
            case "H" -> "폭염";
            case "R" -> "호우 (산사태 위험)";
            case "C" -> "한파";
            case "W" -> "강풍";
            case "T" -> "태풍";
            case "S" -> "대설";
            default -> type;
        };
        return label + " " + level;
    }
}
