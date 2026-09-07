package com.angsamo.erp.safety.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.json.JsonParserFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import com.angsamo.erp.safety.domain.WeatherDailyLog;
import com.angsamo.erp.safety.dto.ForecastPoint;
import com.angsamo.erp.safety.dto.WeatherAlert;
import com.angsamo.erp.safety.dto.WeatherStatus;
import com.angsamo.erp.safety.mapper.WeatherAlertMapper;
import com.angsamo.erp.safety.mapper.WeatherDailyLogMapper;

@Service
public class WeatherService {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final DateTimeFormatter HOUR_FORMAT = DateTimeFormatter.ofPattern("HH00");

    private final RestClient restClient = RestClient.create();
    private final WeatherAlertMapper weatherAlertMapper;
    private final WeatherDailyLogMapper weatherDailyLogMapper;

    // 안전모 AI 서버(HelmetDetectionService)와 동일한 이유로 HTTP/1.1을 강제한다:
    // 기본 HttpClient의 h2c 업그레이드 시도를 uvicorn이 제대로 처리하지 못해 본문이 유실되는 문제가 있었다.
    private final HttpClient httpClient = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_1_1)
            .connectTimeout(Duration.ofSeconds(3))
            .build();

    @Value("${weather.risk-api-url:}")
    private String riskApiUrl;

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

    public WeatherService(WeatherAlertMapper weatherAlertMapper, WeatherDailyLogMapper weatherDailyLogMapper) {
        this.weatherAlertMapper = weatherAlertMapper;
        this.weatherDailyLogMapper = weatherDailyLogMapper;
    }

    public double getLatitude() { return latitude; }
    public double getLongitude() { return longitude; }

    @Transactional
    public WeatherStatus getStatus() {
        WeatherStatus status = (apiKey != null && !apiKey.isBlank()) ? readKmaStatus() : null;
        if (status == null) status = readOpenMeteoStatus();
        return status;
    }

    // 날씨 달력용: 조회할 때마다 오늘 날짜 행을 최신 값으로 덮어쓴다. 연결 실패 등 값이 없을 땐 기록하지 않는다.
    // maxTemperature/minTemperature/snowfall/alerts는 기상청 예보 경로에서만 채워지고, Open-Meteo 대체 경로에서는 null/빈 값으로 남는다.
    private void logDailySnapshot(WeatherStatus status, Double maxTemperature, Double minTemperature,
            Double snowfall, List<WeatherAlert> alerts) {
        double temp = parseDouble(status.getTemperature());
        double precip = parseDouble(status.getPrecipitation());
        if ("-".equals(status.getTemperature()) || status.getRiskLevel() == null
                || "확인 필요".equals(status.getRiskLevel())) {
            return;
        }
        WeatherDailyLog log = new WeatherDailyLog();
        log.setLogDate(java.time.LocalDate.now());
        log.setTemperature(temp);
        log.setPrecipitation(precip);
        log.setRiskLevel(status.getRiskLevel());
        log.setMaxTemperature(maxTemperature);
        log.setMinTemperature(minTemperature);
        log.setSnowfall(snowfall);
        log.setAlertSummary(alerts == null || alerts.isEmpty() ? null
                : alerts.stream().map(WeatherAlert::getMessage).distinct().collect(java.util.stream.Collectors.joining(", ")));
        try {
            weatherDailyLogMapper.upsert(log);
        } catch (Exception ignored) {
            // 달력 기록 실패가 날씨 화면 자체를 막으면 안 되므로 조용히 무시
        }
    }

    // 날씨 달력 화면: 해당 월의 기록된 날짜들을 반환
    @Transactional(readOnly = true)
    public List<WeatherDailyLog> getMonthlyLog(java.time.YearMonth month) {
        return weatherDailyLogMapper.findByMonth(month.atDay(1), month.atEndOfMonth());
    }

    // 대시보드 미니 그래프용: 최근 며칠간의 기록 (월 경계와 무관하게 날짜 범위로 조회)
    @Transactional(readOnly = true)
    public List<WeatherDailyLog> getRecentDailyLog(int days) {
        java.time.LocalDate today = java.time.LocalDate.now();
        return weatherDailyLogMapper.findByMonth(today.minusDays(days - 1L), today);
    }

    // 날짜 클릭 상세보기에서 관리자가 남긴 메모(작업 중지 여부 등)를 저장한다.
    @Transactional
    public void saveDailyMemo(java.time.LocalDate date, String memo) {
        weatherDailyLogMapper.updateMemo(date, memo);
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

        List<Map<String, Object>> vilageItems = fetchVilageFcstItems();
        List<ForecastPoint> dailyForecast = extractDailyForecast(vilageItems);
        double minTemperature = extractMinTemperature(vilageItems, parseDouble(temperature));
        double snowfall = extractSnowfall(vilageItems);
        Double maxTemperature = extractTodayMax(vilageItems);

        String ruleBasedRisk = calculateRiskLevel(temperature, precipitation, alerts);
        String aiRisk = callRiskModel(parseDouble(temperature), minTemperature, parseDouble(precipitation), snowfall);

        WeatherStatus status = new WeatherStatus(
                temperature,
                precipitation,
                readAsosTemperature(),
                alerts,
                readHourlyForecast(),
                dailyForecast,
                aiRisk != null ? aiRisk : ruleBasedRisk,
                "기상청 API허브",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                "기상청 실시간 관측 및 예보 데이터입니다.");

        logDailySnapshot(status, maxTemperature, minTemperature, snowfall, alerts);
        return status;
    }

    // AI 위험도 모델(risk_model.pkl) 호출. 서버가 꺼져있거나 실패하면 null을 반환해 규칙 기반으로 대체한다.
    private String callRiskModel(double temperature, double minTemperature, double precipitation, double snowfall) {
        if (riskApiUrl == null || riskApiUrl.isBlank()) return null;
        try {
            String json = String.format(Locale.US,
                    "{\"temperature\":%.1f,\"min_temperature\":%.1f,\"precipitation\":%.1f,\"snowfall\":%.1f}",
                    temperature, minTemperature, precipitation, snowfall);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(riskApiUrl))
                    .timeout(Duration.ofSeconds(5))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                    .build();
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() != 200) return null;

            Map<String, Object> body = JsonParserFactory.getJsonParser().parseMap(response.body());
            if (!Boolean.TRUE.equals(body.get("success"))) return null;
            return mapRiskLevel(String.valueOf(body.get("riskLevel")));
        } catch (Exception e) {
            return null;
        }
    }

    private String mapRiskLevel(String level) {
        return switch (level) {
            case "DANGER" -> "위험";
            case "CAUTION" -> "주의";
            case "SAFE" -> "안전";
            default -> null;
        };
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
                    + "&forecast_hours=12&forecast_days=5&timezone=Asia/Seoul";
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

            WeatherStatus status = new WeatherStatus(temperature, precipitation, temperature, List.of(),
                    hourlyPoints, dailyPoints, calculateRiskLevel(temperature, precipitation, List.of()),
                    "Open-Meteo 실시간", observedAt, message);
            logDailySnapshot(status, null, null, null, List.of());
            return status;
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

    // 단기예보조회: 최고기온(TMX)·최저기온(TMN)·적설(SNO)이 모두 이 응답 하나에 들어있어 한 번만 호출한다.
    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> fetchVilageFcstItems() {
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
            return items == null ? List.of() : items;
        } catch (Exception e) {
            return List.of();
        }
    }

    // 앞으로 며칠간의 일별 최고기온(TMX) 예보
    private List<ForecastPoint> extractDailyForecast(List<Map<String, Object>> items) {
        List<ForecastPoint> points = new ArrayList<>();
        for (Map<String, Object> item : items) {
            if (!"TMX".equals(item.get("category"))) continue;
            String fcstDate = String.valueOf(item.get("fcstDate"));
            points.add(new ForecastPoint(fcstDate.substring(4, 6) + "/" + fcstDate.substring(6, 8),
                    String.valueOf(item.get("fcstValue"))));
        }
        return points;
    }

    // 오늘의 최저기온(TMN) 예보. 값이 없으면(발표 시간대가 아니면) 현재 관측 기온으로 대체한다.
    private double extractMinTemperature(List<Map<String, Object>> items, double fallback) {
        for (Map<String, Object> item : items) {
            if ("TMN".equals(item.get("category"))) {
                return parseDouble(String.valueOf(item.get("fcstValue")));
            }
        }
        return fallback;
    }

    // 오늘 날짜의 최고기온(TMX) 예보. 여러 날짜의 TMX가 섞여 있으므로 fcstDate가 오늘인 것만 찾는다.
    private Double extractTodayMax(List<Map<String, Object>> items) {
        String today = LocalDateTime.now().format(DATE_FORMAT);
        for (Map<String, Object> item : items) {
            if ("TMX".equals(item.get("category")) && today.equals(String.valueOf(item.get("fcstDate")))) {
                return parseDouble(String.valueOf(item.get("fcstValue")));
            }
        }
        return null;
    }

    // 앞으로 몇 시간 내 적설(SNO) 예보 중 최댓값(cm). "적설없음" 등은 0으로 처리한다.
    private double extractSnowfall(List<Map<String, Object>> items) {
        double max = 0;
        for (Map<String, Object> item : items) {
            if (!"SNO".equals(item.get("category"))) continue;
            String raw = String.valueOf(item.get("fcstValue"));
            if (raw == null || raw.contains("없음")) continue;
            try {
                max = Math.max(max, Double.parseDouble(raw.replaceAll("[^0-9.]", "")));
            } catch (NumberFormatException ignored) {
                // 숫자로 해석 안 되는 값은 무시
            }
        }
        return max;
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
