package com.angsamo.erp.development.domain;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Bom {

    private Long bomId;

    private String parentItemCode;

    private String componentItemCode;

    private BigDecimal requiredQty;

    private String unit;

    private Integer active;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    // JOIN용
    private String parentItemName;

    private String componentItemName;

    public Long getBomId() {
        return bomId;
    }

    public void setBomId(Long bomId) {
        this.bomId = bomId;
    }

    public String getParentItemCode() {
        return parentItemCode;
    }

    public void setParentItemCode(String parentItemCode) {
        this.parentItemCode = parentItemCode;
    }

    public String getComponentItemCode() {
        return componentItemCode;
    }

    public void setComponentItemCode(String componentItemCode) {
        this.componentItemCode = componentItemCode;
    }

    public BigDecimal getRequiredQty() {
        return requiredQty;
    }

    public void setRequiredQty(BigDecimal requiredQty) {
        this.requiredQty = requiredQty;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Integer getActive() {
        return active;
    }

    public void setActive(Integer active) {
        this.active = active;
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

    public String getParentItemName() {
        return parentItemName;
    }

    public void setParentItemName(String parentItemName) {
        this.parentItemName = parentItemName;
    }

    public String getComponentItemName() {
        return componentItemName;
    }

    public void setComponentItemName(String componentItemName) {
        this.componentItemName = componentItemName;
    }

}