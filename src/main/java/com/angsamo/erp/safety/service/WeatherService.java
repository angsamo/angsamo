package com.angsamo.erp.safety.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import com.angsamo.erp.safety.dto.ForecastPoint;
import com.angsamo.erp.safety.dto.WeatherAlert;
import com.angsamo.erp.safety.dto.WeatherStatus;
import com.angsamo.erp.safety.mapper.WeatherAlertMapper;

@Service
public class WeatherService {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final DateTimeFormatter HOUR_FORMAT = DateTimeFormatter.ofPattern("HH00");

    private final RestClient restClient = RestClient.create();
    private final WeatherAlertMapper weatherAlertMapper;

    @Value("${kma.api-key}")
    private String apiKey;

    @Value("${kma.nx}")
    private String nx;

    @Value("${kma.ny}")
    private String ny;

    @Value("${kma.stn}")
    private String stn;

    @Value("${kma.warning-region:}")
    private String warningRegion;

    @Value("${kma.warning-region-name:서울특별시}")
    private String warningRegionName;

    @Value("${weather.latitude:37.5665}")
    private double latitude;

    @Value("${weather.longitude:126.9780}")
    private double longitude;

    public WeatherService(WeatherAlertMapper weatherAlertMapper) {
        this.weatherAlertMapper = weatherAlertMapper;
    }

    @Transactional
    public WeatherStatus getStatus() {
        if (apiKey != null && !apiKey.isBlank()) {
            WeatherStatus kmaStatus = readKmaStatus();
            if (kmaStatus != null) return kmaStatus;
        }

        return readOpenMeteoStatus();
    }

    /** 인증키가 설정된 경우 기상청 API허브의 관측·예보를 우선 사용한다. */
    private WeatherStatus readKmaStatus() {
        Map<String, String> observed = readObservation();
        if (observed.isEmpty()) return null;

        List<WeatherAlert> alerts = readAlerts();
        for (WeatherAlert alert : alerts) {
            weatherAlertMapper.insertIfAbsent(alert.getType(), alert.getLevel(),
                    alert.getRegionName() + " " + alert.getMessage());
        }
        String temperature = observed.getOrDefault("T1H", "-");
        String precipitation = observed.getOrDefault("RN1", "-");
        return new WeatherStatus(
                temperature,
                precipitation,
                readAsosTemperature(),
                alerts,
                readHourlyForecast(),
                readDailyForecast(),
                calculateRiskLevel(temperature, precipitation, alerts),
                "기상청 API허브",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                "기상청 실시간 관측 및 예보 데이터입니다.");
    }

    /**
     * 기상청 키가 없거나 일시적으로 호출되지 않을 때 화면이 비지 않도록 공개 실시간 날씨 API를 사용한다.
     * DB에는 아무 데이터도 생성하지 않으며 서울 좌표는 설정값으로 교체할 수 있다.
     */
    @SuppressWarnings("unchecked")
    private WeatherStatus readOpenMeteoStatus() {
        try {
            String uri = "https://api.open-meteo.com/v1/forecast?latitude=" + latitude
                    + "&longitude=" + longitude
                    + "&current=temperature_2m,precipitation"
                    + "&hourly=temperature_2m&daily=temperature_2m_max"
                    + "&forecast_hours=12&forecast_days=5&timezone=Asia%2FSeoul";
            Map<String, Object> response = restClient.get().uri(uri).retrieve().body(Map.class);
            Map<String, Object> current = (Map<String, Object>) response.get("current");
            Map<String, Object> hourly = (Map<String, Object>) response.get("hourly");
            Map<String, Object> daily = (Map<String, Object>) response.get("daily");
            if (current == null) throw new IllegalStateException("현재 날씨 응답이 없습니다.");

            String temperature = value(current.get("temperature_2m"));
            String precipitation = value(current.get("precipitation"));
            List<ForecastPoint> hourlyPoints = forecastPoints(hourly, "time", "temperature_2m", true);
            List<ForecastPoint> dailyPoints = forecastPoints(daily, "time", "temperature_2m_max", false);
            String observedAt = String.valueOf(current.getOrDefault("time", "-")).replace('T', ' ');
            String message = apiKey == null || apiKey.isBlank()
                    ? "기상청 인증키가 설정되지 않아 공개 실시간 날씨 데이터로 표시합니다."
                    : "기상청 API 연결 실패로 공개 실시간 날씨 데이터로 대체했습니다.";

            return new WeatherStatus(temperature, precipitation, temperature, List.of(),
                    hourlyPoints, dailyPoints, calculateRiskLevel(temperature, precipitation, List.of()),
                    "Open-Meteo 실시간", observedAt, message);
        } catch (Exception e) {
            return new WeatherStatus("-", "-", "-", List.of(), List.of(), List.of(), "확인 필요",
                    "연결 실패", "-", "실시간 날씨 서버에 연결할 수 없습니다. 잠시 후 다시 시도해 주세요.");
        }
    }

    private List<ForecastPoint> forecastPoints(Map<String, Object> block, String timeKey,
            String valueKey, boolean hourly) {
        if (block == null) return List.of();
        Object timesValue = block.get(timeKey);
        Object valuesValue = block.get(valueKey);
        if (!(timesValue instanceof List<?> times) || !(valuesValue instanceof List<?> values)) return List.of();

        List<ForecastPoint> points = new ArrayList<>();
        int size = Math.min(times.size(), values.size());
        for (int index = 0; index < size; index++) {
            String time = String.valueOf(times.get(index));
            String label;
            if (hourly && time.length() >= 13) label = time.substring(11, 13) + "시";
            else if (!hourly && time.length() >= 10) label = time.substring(5, 7) + "/" + time.substring(8, 10);
            else label = time;
            points.add(new ForecastPoint(label, value(values.get(index))));
        }
        return points;
    }

    private String value(Object value) {
        return value == null ? "-" : String.valueOf(value);
    }

    // 규칙 기반 종합 위험도 판정: 폭염/한파/특보 경보 수준을 기준으로 안전/주의/위험 3단계를 산출한다. (ML 모델 도입 전까지의 임시 로직)
    private String calculateRiskLevel(String temperature, String precipitation, List<WeatherAlert> alerts) {
        boolean hasWarning = alerts.stream().anyMatch(a -> a.getLevel() != null && a.getLevel().contains("경보"));
        if (hasWarning) return "위험";

        double temp = parseDouble(temperature);
        double rain = parseDouble(precipitation);
        if (temp >= 33 || temp <= -12 || rain >= 30) return "위험";

        boolean hasAdvisory = !alerts.isEmpty();
        if (hasAdvisory || temp >= 28 || temp <= -5 || rain > 0) return "주의";

        return "안전";
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 0;
        }
    }

    // 초단기실황조회: 기온(T1H), 1시간 강수량(RN1) 등을 category/obsrValue 쌍으로 반환한다.
    @SuppressWarnings("unchecked")
    private Map<String, String> readObservation() {
        LocalDateTime now = LocalDateTime.now();
        String baseDate = now.format(DATE_FORMAT);
        String baseTime = now.minusHours(1).format(HOUR_FORMAT);

        try {
            Map<String, Object> response = restClient.get()
                    .uri("https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getUltraSrtNcst"
                            + "?pageNo=1&numOfRows=100&dataType=JSON&base_date=" + baseDate
                            + "&base_time=" + baseTime + "&nx=" + nx + "&ny=" + ny + "&authKey=" + apiKey)
                    .retrieve()
                    .body(Map.class);

            Map<String, Object> body = (Map<String, Object>) navigate(response, "response", "body");
            List<Map<String, Object>> items = (List<Map<String, Object>>) navigate(body, "items", "item");

            Map<String, String> result = new java.util.HashMap<>();
            if (items != null) {
                for (Map<String, Object> item : items) {
                    result.put(String.valueOf(item.get("category")), String.valueOf(item.get("obsrValue")));
                }
            }
            return result;
        } catch (Exception e) {
            return Map.of();
        }
    }

    // 특보현황조회: 현재 발효 중인 특보(WRN)와 수준(LVL)을 조회한다.
    private List<WeatherAlert> readAlerts() {
        try {
            String response = restClient.get()
                    .uri("https://apihub.kma.go.kr/api/typ01/url/wrn_now_data.php?fe=f&tm=&disp=0&help=0&authKey=" + apiKey)
                    .retrieve()
                    .body(String.class);

            Map<String, WeatherAlert> alerts = new LinkedHashMap<>();
            if (response == null) return List.of();
            for (String line : response.split("\n")) {
                if (line.isBlank() || line.startsWith("#")) continue;
                String[] cols = line.split(",", -1);
                // REG_UP, REG_UP_KO, REG_ID, REG_KO, TM_FC, TM_EF, WRN, LVL, CMD
                if (cols.length < 9) continue;
                String upperRegion = cols[1].trim();
                String regionId = cols[2].trim();
                String regionKo = cols[3].trim();
                String effectiveAt = cols[5].trim();
                String warn = alertType(cols[6].trim());
                String level = alertLevel(cols[7].trim());
                String command = cols[8].trim();
                if ("3".equals(command) || "4".equals(command)
                        || "해제".equals(command) || "대치해제".equals(command)) continue;
                if (!isTargetRegion(regionId, upperRegion, regionKo)) continue;

                WeatherAlert alert = new WeatherAlert(warn, level, regionKo, formatKmaTime(effectiveAt));
                alerts.putIfAbsent(warn + "|" + level + "|" + regionKo, alert);
            }
            return new ArrayList<>(alerts.values());
        } catch (Exception e) {
            return List.of();
        }
    }

    private boolean isTargetRegion(String regionId, String upperRegion, String regionName) {
        boolean idMatches = warningRegion != null && !warningRegion.isBlank()
                && regionId.equalsIgnoreCase(warningRegion.trim());
        boolean nameMatches = warningRegionName != null && !warningRegionName.isBlank()
                && (regionName.contains(warningRegionName.trim()) || upperRegion.contains(warningRegionName.trim()));
        return idMatches || nameMatches;
    }

    private String alertLevel(String code) {
        return switch (code) {
            case "1", "예비특보" -> "예비특보";
            case "2", "주의보" -> "주의보";
            case "3", "경보" -> "경보";
            default -> "특보";
        };
    }

    private String alertType(String value) {
        return switch (value) {
            case "강풍" -> "W";
            case "호우" -> "R";
            case "한파" -> "C";
            case "건조" -> "D";
            case "폭풍해일", "해일" -> "O";
            case "지진해일" -> "N";
            case "풍랑" -> "V";
            case "태풍" -> "T";
            case "대설" -> "S";
            case "황사" -> "Y";
            case "폭염" -> "H";
            case "안개" -> "F";
            case "열대야" -> "K";
            default -> value;
        };
    }

    private String formatKmaTime(String value) {
        if (value == null || value.length() != 12) return value;
        try {
            return LocalDateTime.parse(value, DateTimeFormatter.ofPattern("yyyyMMddHHmm"))
                    .format(DateTimeFormatter.ofPattern("MM월 dd일 HH:mm"));
        } catch (DateTimeParseException e) {
            return value;
        }
    }

    // 초단기예보조회: 앞으로 몇 시간 동안의 시간별 기온(TMP) 예보를 반환한다.
    @SuppressWarnings("unchecked")
    private List<ForecastPoint> readHourlyForecast() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter fcstTimeFormat = DateTimeFormatter.ofPattern("HH30");
        String baseDate = now.format(DATE_FORMAT);
        String baseTime = now.minusHours(1).format(fcstTimeFormat);

        try {
            Map<String, Object> response = restClient.get()
                    .uri("https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getUltraSrtFcst"
                            + "?pageNo=1&numOfRows=1000&dataType=JSON&base_date=" + baseDate
                            + "&base_time=" + baseTime + "&nx=" + nx + "&ny=" + ny + "&authKey=" + apiKey)
                    .retrieve()
                    .body(Map.class);

            Map<String, Object> body = (Map<String, Object>) navigate(response, "response", "body");
            List<Map<String, Object>> items = (List<Map<String, Object>>) navigate(body, "items", "item");
            if (items == null) return List.of();

            List<ForecastPoint> points = new ArrayList<>();
            for (Map<String, Object> item : items) {
                // 초단기예보의 시간별 기온 항목은 T1H이다. TMP는 단기예보 항목이다.
                if (!"T1H".equals(item.get("category"))) continue;
                String timeLabel = String.valueOf(item.get("fcstTime"));
                points.add(new ForecastPoint(timeLabel.substring(0, 2) + "시", String.valueOf(item.get("fcstValue"))));
            }
            return points;
        } catch (Exception e) {
            return List.of();
        }
    }

    // 단기예보조회: 앞으로 며칠간의 일별 최고기온(TMX) 예보를 반환한다.
    @SuppressWarnings("unchecked")
    private List<ForecastPoint> readDailyForecast() {
        LocalDateTime now = LocalDateTime.now();
        String baseDate = now.format(DATE_FORMAT);
        String baseTime = now.getHour() < 5 ? "0200" : "0500";

        try {
            Map<String, Object> response = restClient.get()
                    .uri("https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getVilageFcst"
                            + "?pageNo=1&numOfRows=1000&dataType=JSON&base_date=" + baseDate
                            + "&base_time=" + baseTime + "&nx=" + nx + "&ny=" + ny + "&authKey=" + apiKey)
                    .retrieve()
                    .body(Map.class);

            Map<String, Object> body = (Map<String, Object>) navigate(response, "response", "body");
            List<Map<String, Object>> items = (List<Map<String, Object>>) navigate(body, "items", "item");
            if (items == null) return List.of();

            List<ForecastPoint> points = new ArrayList<>();
            for (Map<String, Object> item : items) {
                if (!"TMX".equals(item.get("category"))) continue;
                String fcstDate = String.valueOf(item.get("fcstDate"));
                points.add(new ForecastPoint(fcstDate.substring(4, 6) + "/" + fcstDate.substring(6, 8),
                        String.valueOf(item.get("fcstValue"))));
            }
            return points;
        } catch (Exception e) {
            return List.of();
        }
    }

    // ASOS 시간자료: 종관기상관측 지점의 실측 기온을 교차 확인용으로 조회한다.
    private String readAsosTemperature() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter asosTimeFormat = DateTimeFormatter.ofPattern("yyyyMMddHH00");
        String tm = now.minusHours(1).format(asosTimeFormat);

        try {
            String response = restClient.get()
                    .uri("https://apihub.kma.go.kr/api/typ01/url/kma_sfctm2.php?tm=" + tm + "&stn=" + stn
                            + "&help=0&authKey=" + apiKey)
                    .retrieve()
                    .body(String.class);
            if (response == null) return "-";

            for (String line : response.split("\n")) {
                if (line.isBlank() || line.startsWith("#")) continue;
                String[] cols = line.trim().split("\\s+");
                if (cols.length < 12) continue;
                return cols[11]; // TA(기온) 컬럼
            }
            return "-";
        } catch (Exception e) {
            return "-";
        }
    }

    private Object navigate(Map<String, Object> map, String... keys) {
        Object current = map;
        for (String key : keys) {
            if (!(current instanceof Map)) return null;
            current = ((Map<?, ?>) current).get(key);
        }
        return current;
    }
}
