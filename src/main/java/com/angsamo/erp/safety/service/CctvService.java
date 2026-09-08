package com.angsamo.erp.safety.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import com.angsamo.erp.safety.dto.CctvStatus;

// 파이썬 AI 서버(python-services/safety-ai)의 CCTV 실시간 탐지 API를 호출한다.
@Service
public class CctvService {

    private final RestClient restClient;

    public CctvService() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(3000);
        factory.setReadTimeout(5000);
        this.restClient = RestClient.builder().requestFactory(factory).build();
    }

    @Value("${cctv.api-base-url}")
    private String apiBaseUrl;

    @Value("${cctv.rtsp-url:}")
    private String rtspUrl;

    public void start() {
        if (rtspUrl == null || rtspUrl.isBlank()) {
            throw new IllegalStateException("CCTV 스트림 주소가 설정되어 있지 않습니다.");
        }
        try {
            restClient.post()
                    .uri(apiBaseUrl + "/cctv/start?rtsp_url={url}", rtspUrl)
                    .retrieve()
                    .toBodilessEntity();
        } catch (Exception e) {
            throw new IllegalStateException("CCTV 탐지를 시작하지 못했습니다: " + e.getMessage(), e);
        }
    }

    public String getStreamUrl() {
        return apiBaseUrl + "/cctv/stream";
    }

    public String getApiBaseUrl() {
        return apiBaseUrl;
    }

    public void stop() {
        try {
            restClient.post()
                    .uri(apiBaseUrl + "/cctv/stop")
                    .retrieve()
                    .toBodilessEntity();
        } catch (Exception e) {
            throw new IllegalStateException("CCTV 탐지를 중지하지 못했습니다: " + e.getMessage(), e);
        }
    }

    @SuppressWarnings("unchecked")
    public CctvStatus getStatus() {
        try {
            Map<String, Object> response = restClient.get()
                    .uri(apiBaseUrl + "/cctv/status")
                    .retrieve()
                    .body(Map.class);
            if (response == null) {
                return new CctvStatus(false, null, null, null, "서버 응답이 없습니다.", List.of());
            }
            return new CctvStatus(
                    Boolean.TRUE.equals(response.get("running")),
                    (String) response.get("startedAt"),
                    (String) response.get("lastCheckedAt"),
                    (Map<String, Object>) response.get("lastResult"),
                    (String) response.get("error"),
                    (List<Map<String, Object>>) (List<?>) response.getOrDefault("history", List.of()));
        } catch (Exception e) {
            return new CctvStatus(false, null, null, null, "AI 서버에 연결할 수 없습니다.", List.of());
        }
    }
}
