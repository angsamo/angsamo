package com.angsamo.erp.safety.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.json.JsonParserFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.angsamo.erp.safety.dto.HelmetDetectionResult;

// 로보플로우 학습 모델을 서빙하는 파이썬 추론 서버(python-services/safety-ai)를 호출한다.
// Spring RestClient의 멀티파트 본문 변환이 파이썬 서버에서 계속 "file 필드 누락"으로 실패해서,
// 자바 표준 HttpClient로 직접 전송하도록 우회했다.
@Service
public class HelmetDetectionService {

    private static final Logger log = LoggerFactory.getLogger(HelmetDetectionService.class);

    // 기본 HttpClient는 HTTP/2 업그레이드(h2c)를 시도하는데, uvicorn이 이 업그레이드 요청을 제대로
    // 처리하지 못해 멀티파트 본문이 파이썬 쪽에서 누락되는 문제가 있었다. HTTP/1.1로 고정해서 해결.
    private final HttpClient httpClient = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_1_1)
            .connectTimeout(Duration.ofSeconds(5))
            .build();

    @Value("${helmet.detection-api-url:}")
    private String detectionApiUrl;

    public HelmetDetectionResult detect(MultipartFile media) {
        if (detectionApiUrl == null || detectionApiUrl.isBlank() || media == null || media.isEmpty()) {
            return new HelmetDetectionResult(false, null);
        }
        try {
            byte[] bytes = media.getBytes();
            String filename = media.getOriginalFilename() == null ? "image.jpg" : media.getOriginalFilename();
            String boundary = "----AngsamoBoundary" + System.nanoTime();
            byte[] body = buildMultipartBody(boundary, filename, bytes);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(detectionApiUrl))
                    .timeout(Duration.ofSeconds(15))
                    .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                    .POST(HttpRequest.BodyPublishers.ofByteArray(body))
                    .build();

            HttpResponse<String> httpResponse = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (httpResponse.statusCode() != 200) {
                log.warn("안전모 AI 판정 실패(HTTP {}): {}", httpResponse.statusCode(), httpResponse.body());
                return new HelmetDetectionResult(false, null);
            }

            Map<String, Object> response = JsonParserFactory.getJsonParser().parseMap(httpResponse.body());
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> predictions = (List<Map<String, Object>>) (List<?>) response.getOrDefault("predictions", List.of());
            if (!Boolean.TRUE.equals(response.get("success"))) {
                log.warn("안전모 AI 판정 실패(응답 이상): {}", response);
                return new HelmetDetectionResult(false, null, predictions);
            }
            return new HelmetDetectionResult(true, (Boolean) response.get("helmetWorn"), predictions);
        } catch (IOException | InterruptedException | RuntimeException e) {
            log.warn("안전모 AI 판정 호출 실패: {}", e.toString(), e);
            if (e instanceof InterruptedException) Thread.currentThread().interrupt();
            return new HelmetDetectionResult(false, null);
        }
    }

    // multipart/form-data 본문을 직접 구성한다 (파이썬 서버의 file 파라미터와 정확히 매칭).
    private byte[] buildMultipartBody(String boundary, String filename, byte[] fileBytes) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        out.write(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        out.write(("Content-Disposition: form-data; name=\"file\"; filename=\"" + filename + "\"\r\n")
                .getBytes(StandardCharsets.UTF_8));
        out.write("Content-Type: application/octet-stream\r\n\r\n".getBytes(StandardCharsets.UTF_8));
        out.write(fileBytes);
        out.write(("\r\n--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));
        return out.toByteArray();
    }
}
