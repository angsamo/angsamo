package com.angsamo.erp.safety.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.angsamo.erp.safety.domain.SafetyCheckItem;
import com.angsamo.erp.safety.domain.SafetyChecklist;
import com.angsamo.erp.safety.dto.HelmetDetectionResult;
import com.angsamo.erp.safety.dto.SafetyChecklistSummary;
import com.angsamo.erp.safety.mapper.SafetyChecklistMapper;

@Service
public class SafetyChecklistService {

    private final SafetyChecklistMapper mapper;
    private final HelmetDetectionService detectionService;

    @Value("${safety.upload-dir}")
    private String uploadDir;

    public SafetyChecklistService(SafetyChecklistMapper mapper, HelmetDetectionService detectionService) {
        this.mapper = mapper;
        this.detectionService = detectionService;
    }

    @Transactional(readOnly = true)
    public List<SafetyChecklist> getChecklists() {
        return mapper.findAll();
    }

    @Transactional(readOnly = true)
    public SafetyChecklistSummary getDashboardSummary() {
        return mapper.getDashboardSummary();
    }

    @Transactional(readOnly = true)
    public SafetyChecklist getChecklist(Long checklistId) {
        SafetyChecklist checklist = mapper.findById(checklistId);
        if (checklist == null) {
            throw new IllegalArgumentException("체크리스트를 찾을 수 없습니다.");
        }
        return checklist;
    }

    @Transactional(readOnly = true)
    public List<SafetyCheckItem> getItems(Long checklistId) {
        return mapper.findItemsByChecklistId(checklistId);
    }

    @Transactional(readOnly = true)
    public SafetyChecklist getActiveChecklist() {
        return mapper.findActive();
    }

    @Transactional(readOnly = true)
    public List<SafetyCheckItem> getRecentViolations(int limit) {
        return mapper.findRecentViolationItems(limit);
    }

    @Transactional
    public Long createChecklist(Long departmentId, Long checkedBy, LocalDate checkDate, String location) {
        if (mapper.findActive() != null) {
            throw new IllegalStateException("이미 진행 중인 점검이 있습니다. 먼저 완료 처리해 주세요.");
        }
        SafetyChecklist checklist = new SafetyChecklist();
        checklist.setDepartmentId(departmentId);
        checklist.setCheckedBy(checkedBy);
        checklist.setCheckDate(checkDate == null ? LocalDate.now() : checkDate);
        checklist.setLocation(location);
        mapper.insertChecklist(checklist);
        return checklist.getChecklistId();
    }

    @Transactional
    public void addItem(Long checklistId, MultipartFile media, boolean helmetWorn, boolean chinStrapFastened,
            boolean damaged, boolean expired, String memo) {
        SafetyChecklist checklist = getChecklist(checklistId);
        if (!"IN_PROGRESS".equals(checklist.getStatus())) {
            throw new IllegalStateException("진행 중인 체크리스트에만 항목을 추가할 수 있습니다.");
        }
        if (media == null || media.isEmpty()) {
            throw new IllegalArgumentException("사진/영상을 첨부해야 확인 항목을 추가할 수 있습니다.");
        }

        HelmetDetectionResult detection = detectionService.detect(media);

        SafetyCheckItem item = new SafetyCheckItem();
        item.setChecklistId(checklistId);
        item.setMediaPath(saveMedia(media));
        if (detection.isSuccess()) {
            item.setHelmetWorn(detection.getHelmetWorn());
            item.setDetectionSource("AI");
        } else {
            item.setHelmetWorn(helmetWorn);
            item.setDetectionSource("MANUAL");
        }
        item.setDetectionBoxes(toJson(detection.getPredictions()));
        item.setChinStrapFastened(chinStrapFastened);
        item.setDamaged(damaged);
        item.setExpired(expired);
        item.setMemo(memo);
        mapper.insertItem(item);
    }

    @Transactional
    public void deleteItem(Long itemId) {
        if (mapper.deleteItem(itemId) != 1) {
            throw new IllegalArgumentException("확인 항목을 찾을 수 없습니다.");
        }
    }

    // 탐지 박스 목록(class/confidence/x/y/width/height)을 단순 JSON 배열 문자열로 직렬화한다.
    private String toJson(List<Map<String, Object>> predictions) {
        if (predictions == null || predictions.isEmpty()) {
            return "[]";
        }
        return "[" + predictions.stream().map(this::toJsonObject).collect(Collectors.joining(",")) + "]";
    }

    private String toJsonObject(Map<String, Object> box) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"class\":\"").append(String.valueOf(box.get("class")).replace("\"", "'")).append("\",");
        sb.append("\"confidence\":").append(box.getOrDefault("confidence", 0)).append(",");
        sb.append("\"x\":").append(box.getOrDefault("x", 0)).append(",");
        sb.append("\"y\":").append(box.getOrDefault("y", 0)).append(",");
        sb.append("\"width\":").append(box.getOrDefault("width", 0)).append(",");
        sb.append("\"height\":").append(box.getOrDefault("height", 0));
        sb.append("}");
        return sb.toString();
    }

    @Transactional
    public void completeChecklist(Long checklistId) {
        if (mapper.updateStatus(checklistId, "COMPLETED") != 1) {
            throw new IllegalArgumentException("체크리스트를 찾을 수 없습니다.");
        }
    }

    private String saveMedia(MultipartFile media) {
        if (media == null || media.isEmpty()) {
            return null;
        }
        try {
            Path dir = Path.of(uploadDir);
            Files.createDirectories(dir);
            String original = media.getOriginalFilename() == null ? "" : media.getOriginalFilename();
            String ext = original.contains(".") ? original.substring(original.lastIndexOf('.')) : "";
            String fileName = UUID.randomUUID() + ext;
            Path target = dir.resolve(fileName);
            try (InputStream in = media.getInputStream()) {
                Files.copy(in, target);
            }
            return fileName;
        } catch (IOException e) {
            throw new IllegalStateException("파일 저장에 실패했습니다.", e);
        }
    }
}
