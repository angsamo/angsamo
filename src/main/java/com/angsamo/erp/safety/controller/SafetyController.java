package com.angsamo.erp.safety.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.safety.dto.CctvStatus;
import com.angsamo.erp.safety.service.CctvService;
import com.angsamo.erp.safety.service.SafetyChecklistService;
import com.angsamo.erp.safety.service.WeatherService;

// 접근 제어는 AdminInterceptor(/safety/**)가 담당한다.
@Controller
public class SafetyController {

    private final WeatherService weatherService;
    private final SafetyChecklistService checklistService;
    private final CctvService cctvService;

    public SafetyController(WeatherService weatherService, SafetyChecklistService checklistService,
            CctvService cctvService) {
        this.weatherService = weatherService;
        this.checklistService = checklistService;
        this.cctvService = cctvService;
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

    @GetMapping("/safety/cctv")
    public String cctv(Model model) {
        model.addAttribute("streamUrl", cctvService.getStreamUrl());
        return "safety/cctv";
    }

    @PostMapping("/safety/cctv/start")
    public String startCctv(RedirectAttributes redirect) {
        try {
            cctvService.start();
            redirect.addFlashAttribute("success", "CCTV 탐지를 시작했습니다.");
        } catch (IllegalStateException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/cctv";
    }

    @PostMapping("/safety/cctv/stop")
    public String stopCctv(RedirectAttributes redirect) {
        try {
            cctvService.stop();
            redirect.addFlashAttribute("success", "CCTV 탐지를 중지했습니다.");
        } catch (IllegalStateException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/cctv";
    }

    @GetMapping("/safety/cctv/status")
    @ResponseBody
    public CctvStatus cctvStatus() {
        return cctvService.getStatus();
    }
}
