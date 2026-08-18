package com.angsamo.erp.safety.domain;

import java.time.LocalDateTime;

public class SafetyCheckItem {

    private Long itemId;
    private Long checklistId;
    private String mediaPath;
    private Boolean helmetWorn;
    private String detectionSource;
    private String memo;
    private LocalDateTime checkedAt;
    private String departmentName;
    private String location;
    private java.time.LocalDate checkDate;

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
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }
    public LocalDateTime getCheckedAt() { return checkedAt; }
    public void setCheckedAt(LocalDateTime checkedAt) { this.checkedAt = checkedAt; }
}
