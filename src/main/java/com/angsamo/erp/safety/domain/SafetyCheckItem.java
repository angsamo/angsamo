package com.angsamo.erp.safety.domain;

import java.time.LocalDateTime;

public class SafetyCheckItem {

    private Long itemId;
    private Long checklistId;
    private String mediaPath;
    private Boolean helmetWorn;
    private Boolean chinStrapFastened;
    private Boolean damaged;
    private Boolean expired;
    private String detectionSource;
    private String detectionBoxes;
    private String memo;
    private LocalDateTime checkedAt;
    private String departmentName;
    private String location;
    private java.time.LocalDate checkDate;

    public Boolean getChinStrapFastened() { return chinStrapFastened; }
    public void setChinStrapFastened(Boolean chinStrapFastened) { this.chinStrapFastened = chinStrapFastened; }
    public Boolean getDamaged() { return damaged; }
    public void setDamaged(Boolean damaged) { this.damaged = damaged; }
    public Boolean getExpired() { return expired; }
    public void setExpired(Boolean expired) { this.expired = expired; }

    // 4개 항목 중 하나라도 문제 있으면 부적합
    public boolean isPass() {
        return Boolean.TRUE.equals(helmetWorn)
                && Boolean.TRUE.equals(chinStrapFastened)
                && !Boolean.TRUE.equals(damaged)
                && !Boolean.TRUE.equals(expired);
    }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public java.time.LocalDate getCheckDate() { return checkDate; }
    public void setCheckDate(java.time.LocalDate checkDate) { this.checkDate = checkDate; }

    public Long getItemId() { return itemId; }
    public void setItemId(Long itemId) { this.itemId = itemId; }
    public Long getChecklistId() { return checklistId; }
    public void setChecklistId(Long checklistId) { this.checklistId = checklistId; }
    public String getMediaPath() { return mediaPath; }
    public void setMediaPath(String mediaPath) { this.mediaPath = mediaPath; }
    public Boolean getHelmetWorn() { return helmetWorn; }
    public void setHelmetWorn(Boolean helmetWorn) { this.helmetWorn = helmetWorn; }
    public String getDetectionSource() { return detectionSource; }
    public void setDetectionSource(String detectionSource) { this.detectionSource = detectionSource; }
    // AI가 탐지한 박스 좌표들을 JSON 문자열로 저장 (화면에서 사진 위에 그려줄 때 사용)
    public String getDetectionBoxes() { return detectionBoxes; }
    public void setDetectionBoxes(String detectionBoxes) { this.detectionBoxes = detectionBoxes; }
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }
    public LocalDateTime getCheckedAt() { return checkedAt; }
    public void setCheckedAt(LocalDateTime checkedAt) { this.checkedAt = checkedAt; }
}
