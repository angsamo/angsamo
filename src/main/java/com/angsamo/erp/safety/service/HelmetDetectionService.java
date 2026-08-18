package com.angsamo.erp.safety.service;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

import com.angsamo.erp.safety.dto.HelmetDetectionResult;

// 로보플로우 학습 모델을 서빙하는 파이썬 추론 서버(python-services/helmet-detection)를 호출한다.
@Service
public class HelmetDetectionService {

    private final RestClient restClient = RestClient.create();

    @Value("${helmet.detection-api-url:}")
    private String detectionApiUrl;

    @SuppressWarnings("unchecked")
    public HelmetDetectionResult detect(MultipartFile media) {
        if (detectionApiUrl == null || detectionApiUrl.isBlank() || media == null || media.isEmpty()) {
            return new HelmetDetectionResult(false, null);
        }
        try {
            byte[] bytes = media.getBytes();
            String filename = media.getOriginalFilename() == null ? "image.jpg" : media.getOriginalFilename();
            ByteArrayResource resource = new ByteArrayResource(bytes) {
                @Override
                public String getFilename() {
                    return filename;
                }
            };

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("file", resource);

            Map<String, Object> response = restClient.post()
                    .uri(detectionApiUrl)
                    .contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(body)
                    .retrieve()
                    .body(Map.class);

            if (response == null || !Boolean.TRUE.equals(response.get("success"))) {
                return new HelmetDetectionResult(false, null);
            }
            return new HelmetDetectionResult(true, (Boolean) response.get("helmetWorn"));
        } catch (IOException | RuntimeException e) {
            return new HelmetDetectionResult(false, null);
        }
    }
}
