package com.angsamo.erp.development.domain;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Bom {

    private Long bomId;
    private Long parentItemId;
    private Long componentItemId;
    private BigDecimal requiredQty;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /*
     * item 테이블 JOIN 결과 표시용 필드
     * bom 테이블의 실제 컬럼은 아니다.
     */
    private String parentItemCode;
    private String parentItemName;
    private String componentItemCode;
    private String componentItemName;
    private String componentUnit;

    public Bom() {
    }

    public Long getBomId() {
        return bomId;
    }

    public void setBomId(Long bomId) {
        this.bomId = bomId;
    }

    public Long getParentItemId() {
        return parentItemId;
    }

    public void setParentItemId(Long parentItemId) {
        this.parentItemId = parentItemId;
    }

    public Long getComponentItemId() {
        return componentItemId;
    }

    public void setComponentItemId(Long componentItemId) {
        this.componentItemId = componentItemId;
    }

    public BigDecimal getRequiredQty() {
        return requiredQty;
    }

    public void setRequiredQty(BigDecimal requiredQty) {
        this.requiredQty = requiredQty;
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

    public String getParentItemCode() {
        return parentItemCode;
    }

    public void setParentItemCode(String parentItemCode) {
        this.parentItemCode = parentItemCode;
    }

    public String getParentItemName() {
        return parentItemName;
    }

    public void setParentItemName(String parentItemName) {
        this.parentItemName = parentItemName;
    }

    public String getComponentItemCode() {
        return componentItemCode;
    }

    public void setComponentItemCode(String componentItemCode) {
        this.componentItemCode = componentItemCode;
    }

    public String getComponentItemName() {
        return componentItemName;
    }

    public void setComponentItemName(String componentItemName) {
        this.componentItemName = componentItemName;
    }

    public String getComponentUnit() {
        return componentUnit;
    }

    public void setComponentUnit(String componentUnit) {
        this.componentUnit = componentUnit;
    }

    @Override
    public String toString() {
        return "Bom{" +
                "bomId=" + bomId +
                ", parentItemId=" + parentItemId +
                ", componentItemId=" + componentItemId +
                ", requiredQty=" + requiredQty +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", parentItemCode='" + parentItemCode + '\'' +
                ", parentItemName='" + parentItemName + '\'' +
                ", componentItemCode='" + componentItemCode + '\'' +
                ", componentItemName='" + componentItemName + '\'' +
                ", componentUnit='" + componentUnit + '\'' +
                '}';
    }
}