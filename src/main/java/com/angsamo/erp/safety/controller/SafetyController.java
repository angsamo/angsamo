package com.angsamo.erp.safety.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.angsamo.erp.safety.service.SafetyChecklistService;
import com.angsamo.erp.safety.service.WeatherService;

// 접근 제어는 AdminInterceptor(/safety/**)가 담당한다.
@Controller
public class SafetyController {

    private final WeatherService weatherService;
    private final SafetyChecklistService checklistService;

    public SafetyController(WeatherService weatherService, SafetyChecklistService checklistService) {
        this.weatherService = weatherService;
        this.checklistService = checklistService;
    }

    @GetMapping("/safety")
    public String dashboard(Model model) {
        model.addAttribute("weather", weatherService.getStatus());
        model.addAttribute("recentViolations", checklistService.getRecentViolations(5));
        return "safety/dashboard";
    }

    @GetMapping("/safety/weather")
    public String weather(Model model) {
        model.addAttribute("weather", weatherService.getStatus());
        return "safety/weather";
    }
}
