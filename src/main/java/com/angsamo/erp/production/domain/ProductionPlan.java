package com.angsamo.erp.production.domain;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class ProductionPlan {

    private Long productionPlanId;
    private Long departmentId;
    private Long itemId;

    private BigDecimal productionQty;

    private LocalDate startDate;
    private LocalDate dueDate;

    private String status;

    private Long createdBy;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ===== JOIN 조회용 =====
    // 실제 DB 컬럼이 아니라 화면 표시용 필드
    private String departmentName;
    private String itemCode;
    private String itemName;
    private String createdByName;

    public ProductionPlan() {
    }

    public Long getProductionPlanId() {
        return productionPlanId;
    }

    public void setProductionPlanId(Long productionPlanId) {
        this.productionPlanId = productionPlanId;
    }

    public Long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }

    public Long getItemId() {
        return itemId;
    }

    public void setItemId(Long itemId) {
        this.itemId = itemId;
    }

    public BigDecimal getProductionQty() {
        return productionQty;
    }

    public void setProductionQty(BigDecimal productionQty) {
        this.productionQty = productionQty;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    @Override
    public String toString() {
        return "ProductionPlan{" +
                "productionPlanId=" + productionPlanId +
                ", departmentId=" + departmentId +
                ", itemId=" + itemId +
                ", productionQty=" + productionQty +
                ", startDate=" + startDate +
                ", dueDate=" + dueDate +
                ", status='" + status + '\'' +
                ", createdBy=" + createdBy +
                '}';
    }
}