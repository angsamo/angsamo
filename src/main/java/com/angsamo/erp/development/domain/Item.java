package com.angsamo.erp.development.domain;

import java.time.LocalDateTime;

public class Item {

    private String itemCode;
    private String itemName;
    private String spec;
    private String material;
    private String makeSpec;
    private String drawingRef;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Item() {
    }
    
    

    public Item(String itemCode, String itemName, String spec, String material, String makeSpec, String drawingRef,
			LocalDateTime createdAt, LocalDateTime updatedAt) {
		super();
		this.itemCode = itemCode;
		this.itemName = itemName;
		this.spec = spec;
		this.material = material;
		this.makeSpec = makeSpec;
		this.drawingRef = drawingRef;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
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

    public String getSpec() {
        return spec;
    }

    public void setSpec(String spec) {
        this.spec = spec;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getMakeSpec() {
        return makeSpec;
    }

    public void setMakeSpec(String makeSpec) {
        this.makeSpec = makeSpec;
    }

    public String getDrawingRef() {
        return drawingRef;
    }

    public void setDrawingRef(String drawingRef) {
        this.drawingRef = drawingRef;
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



	@Override
	public String toString() {
		return "Item [itemCode=" + itemCode + ", itemName=" + itemName + ", spec=" + spec + ", material=" + material
				+ ", makeSpec=" + makeSpec + ", drawingRef=" + drawingRef + ", createdAt=" + createdAt + ", updatedAt="
				+ updatedAt + "]";
	}
    
    
}