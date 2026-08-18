package com.angsamo.erp.safety.dto;

public class HelmetDetectionResult {

    private final boolean success;
    private final Boolean helmetWorn;

    public HelmetDetectionResult(boolean success, Boolean helmetWorn) {
        this.success = success;
        this.helmetWorn = helmetWorn;
    }

    public boolean isSuccess() { return success; }
    public Boolean getHelmetWorn() { return helmetWorn; }
}
