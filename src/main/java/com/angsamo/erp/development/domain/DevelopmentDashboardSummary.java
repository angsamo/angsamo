package com.angsamo.erp.development.domain;

public class DevelopmentDashboardSummary {

    private int totalItemCount;
    private int productCount;
    private int materialCount;
    private int bomCount;
    private int productWithoutBomCount;

    public int getTotalItemCount() { return totalItemCount; }
    public void setTotalItemCount(int totalItemCount) { this.totalItemCount = totalItemCount; }
    public int getProductCount() { return productCount; }
    public void setProductCount(int productCount) { this.productCount = productCount; }
    public int getMaterialCount() { return materialCount; }
    public void setMaterialCount(int materialCount) { this.materialCount = materialCount; }
    public int getBomCount() { return bomCount; }
    public void setBomCount(int bomCount) { this.bomCount = bomCount; }
    public int getProductWithoutBomCount() { return productWithoutBomCount; }
    public void setProductWithoutBomCount(int productWithoutBomCount) { this.productWithoutBomCount = productWithoutBomCount; }
}
