package com.angsamo.erp.safety.dto;

import java.util.List;
import java.util.Map;

public class CctvStatus {

    private final boolean running;
    private final String startedAt;
    private final String lastCheckedAt;
    private final Map<String, Object> lastResult;
    private final String error;
    private final List<Map<String, Object>> history;

    public CctvStatus(boolean running, String startedAt, String lastCheckedAt, Map<String, Object> lastResult,
            String error, List<Map<String, Object>> history) {
        this.running = running;
        this.startedAt = startedAt;
        this.lastCheckedAt = lastCheckedAt;
        this.lastResult = lastResult;
        this.error = error;
        this.history = history == null ? List.of() : history;
    }

    public boolean isRunning() { return running; }
    public String getStartedAt() { return startedAt; }
    public String getLastCheckedAt() { return lastCheckedAt; }
    public Map<String, Object> getLastResult() { return lastResult; }
    public String getError() { return error; }
    public List<Map<String, Object>> getHistory() { return history; }
}
