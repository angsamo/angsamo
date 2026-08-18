package com.angsamo.erp.safety.dto;

public class WeatherAlert {

    private String type;
    private String level;
    private String regionName;
    private String effectiveAt;

    public WeatherAlert(String type, String level, String regionName) {
        this(type, level, regionName, null);
    }

    public WeatherAlert(String type, String level, String regionName, String effectiveAt) {
        this.type = type;
        this.level = level;
        this.regionName = regionName;
        this.effectiveAt = effectiveAt;
    }

    public String getType() { return type; }
    public String getLevel() { return level; }
    public String getRegionName() { return regionName; }
    public String getEffectiveAt() { return effectiveAt; }

    public String getMessage() {
        String label = switch (type) {
            case "H" -> "폭염";
            case "R" -> "호우";
            case "C" -> "한파";
            case "W" -> "강풍";
            case "D" -> "건조";
            case "O" -> "폭풍해일";
            case "N" -> "지진해일";
            case "V" -> "풍랑";
            case "T" -> "태풍";
            case "S" -> "대설";
            case "Y" -> "황사";
            case "F" -> "안개";
            case "K" -> "열대야";
            default -> type;
        };
        return label + " " + level;
    }

    public String getSeverityClass() {
        return level != null && level.contains("경보") ? "danger" : "caution";
    }

    public String getGuidance() {
        return switch (type) {
            case "H" -> "한낮 야외작업을 줄이고 물·그늘·휴식 시간을 확보하세요.";
            case "R" -> "침수·미끄럼 위험 구역을 통제하고 실외작업을 연기하세요.";
            case "C" -> "방한장비를 착용하고 장시간 야외작업을 피하세요.";
            case "W", "T" -> "고소작업과 크레인 운행을 중지하고 시설물을 고정하세요.";
            case "S" -> "제설 후 이동하고 차량·보행 동선을 분리하세요.";
            case "D" -> "화기 작업을 제한하고 소화장비를 가까이 배치하세요.";
            case "Y", "F" -> "보호구를 착용하고 차량·중장비 운행 속도를 낮추세요.";
            default -> "작업 전 현장 상태를 확인하고 안전관리자 지시에 따라주세요.";
        };
    }
}
