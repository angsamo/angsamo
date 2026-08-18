package com.angsamo.erp.safety.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class SafetyChecklist {

    private Long checklistId;
    private Long departmentId;
    private Long checkedBy;
    private LocalDate checkDate;
    private String location;
    private String status;
    private LocalDateTime createdAt;

    private String departmentName;
    private String checkedByName;
    private int itemCount;
    private int helmetOffCount;

    public Long getChecklistId() { return checklistId; }
    public void setChecklistId(Long checklistId) { this.checklistId = checklistId; }
    public Long getDepartmentId() { return departmentId; }
    public void setDepartmentId(Long departmentId) { this.departmentId = departmentId; }
    public Long getCheckedBy() { return checkedBy; }
    public void setCheckedBy(Long checkedBy) { this.checkedBy = checkedBy; }
    public LocalDate getCheckDate() { return checkDate; }
    public void setCheckDate(LocalDate checkDate) { this.checkDate = checkDate; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    public String getCheckedByName() { return checkedByName; }
    public void setCheckedByName(String checkedByName) { this.checkedByName = checkedByName; }
    public int getItemCount() { return itemCount; }
    public void setItemCount(int itemCount) { this.itemCount = itemCount; }
    public int getHelmetOffCount() { return helmetOffCount; }
    public void setHelmetOffCount(int helmetOffCount) { this.helmetOffCount = helmetOffCount; }
}
