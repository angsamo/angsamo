package com.angsamo.erp.production.domain;

import java.math.BigDecimal;
import java.time.LocalDate;

public class MaterialRequirement {

    private Long productionPlanId;
    private Long itemId;

    private String itemCode;
    private String itemName;
    private String unit;

    // 생산계획 생산 수량
    private BigDecimal productionQty;

    // 완제품 1개당 BOM 필요 수량
    private BigDecimal bomRequiredQty;

    // 총 필요 자재 수량
    private BigDecimal requiredQty;

    // 현재 사용 가능 재고
    private BigDecimal availableQty;

    // 부족 수량
    private BigDecimal shortageQty;

    private LocalDate requiredDate;

    public MaterialRequirement() {
    }

    public Long getProductionPlanId() {
        return productionPlanId;
    }

    public void setProductionPlanId(Long productionPlanId) {
        this.productionPlanId = productionPlanId;
    }

    public Long getItemId() {
        return itemId;
    }

    public void setItemId(Long itemId) {
        this.itemId = itemId;
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

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getProductionQty() {
        return productionQty;
    }

    public void setProductionQty(BigDecimal productionQty) {
        this.productionQty = productionQty;
    }

    public BigDecimal getBomRequiredQty() {
        return bomRequiredQty;
    }

    public void setBomRequiredQty(BigDecimal bomRequiredQty) {
        this.bomRequiredQty = bomRequiredQty;
    }

    public BigDecimal getRequiredQty() {
        return requiredQty;
    }

    public void setRequiredQty(BigDecimal requiredQty) {
        this.requiredQty = requiredQty;
    }

    public BigDecimal getAvailableQty() {
        return availableQty;
    }

    public void setAvailableQty(BigDecimal availableQty) {
        this.availableQty = availableQty;
    }

    public BigDecimal getShortageQty() {
        return shortageQty;
    }

    public void setShortageQty(BigDecimal shortageQty) {
        this.shortageQty = shortageQty;
    }

    public boolean isStockSufficient() {
        return shortageQty != null
                && shortageQty.compareTo(BigDecimal.ZERO) <= 0;
    }

    public boolean isShortage() {
        return shortageQty != null
                && shortageQty.compareTo(BigDecimal.ZERO) > 0;
    }

    public LocalDate getRequiredDate() {
        return requiredDate;
    }

    public void setRequiredDate(LocalDate requiredDate) {
        this.requiredDate = requiredDate;
    }

    @Override
    public String toString() {
        return "MaterialRequirement{" +
                "productionPlanId=" + productionPlanId +
                ", itemId=" + itemId +
                ", itemCode='" + itemCode + '\'' +
                ", productionQty=" + productionQty +
                ", bomRequiredQty=" + bomRequiredQty +
                ", requiredQty=" + requiredQty +
                ", availableQty=" + availableQty +
                ", shortageQty=" + shortageQty +
                ", requiredDate=" + requiredDate +
                '}';
    }
}
