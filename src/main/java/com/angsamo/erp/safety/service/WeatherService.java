package com.angsamo.erp.safety.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
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

    public WeatherService(WeatherAlertMapper weatherAlertMapper) {
        this.weatherAlertMapper = weatherAlertMapper;
    }

    @Transactional
    public WeatherStatus getStatus() {
        if (apiKey == null || apiKey.isBlank()) {
            return new WeatherStatus("-", "-", "-", List.of(), List.of(), List.of(), "안전");
        }
        Map<String, String> observed = readObservation();
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
                calculateRiskLevel(temperature, precipitation, alerts));
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
                    .uri("https://apihub.kma.go.kr/api/typ01/url/wrn_now_data.php?fe=f&tm=&disp=1&authKey=" + apiKey)
                    .retrieve()
                    .body(String.class);

            List<WeatherAlert> alerts = new ArrayList<>();
            if (response == null) return alerts;
            for (String line : response.split("\n")) {
                if (line.isBlank() || line.startsWith("#")) continue;
                String[] cols = line.split(",");
                if (cols.length < 6) continue;
                String regionKo = cols[1].trim();
                String warn = cols[4].trim();
                String level = cols[5].trim();
                alerts.add(new WeatherAlert(warn, level, regionKo));
            }
            return alerts;
        } catch (Exception e) {
            return List.of();
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
                if (!"TMP".equals(item.get("category"))) continue;
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
