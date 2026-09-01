package com.angsamo.erp.safety.dto;

import java.util.List;
import java.util.Map;

public class HelmetDetectionResult {

    private final boolean success;
    private final Boolean helmetWorn;
    private final List<Map<String, Object>> predictions;

    public HelmetDetectionResult(boolean success, Boolean helmetWorn) {
        this(success, helmetWorn, List.of());
    }

    public HelmetDetectionResult(boolean success, Boolean helmetWorn, List<Map<String, Object>> predictions) {
        this.success = success;
        this.helmetWorn = helmetWorn;
        this.predictions = predictions == null ? List.of() : predictions;
    }

    public boolean isSuccess() { return success; }
    public Boolean getHelmetWorn() { return helmetWorn; }
    public List<Map<String, Object>> getPredictions() { return predictions; }
}
