package com.angsamo.erp.development.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.angsamo.erp.development.service.DevelopmentDashboardService;

@Controller
@RequestMapping("/development")
public class DevelopmentDashboardController {

    private final DevelopmentDashboardService service;

    public DevelopmentDashboardController(DevelopmentDashboardService service) {
        this.service = service;
    }

    @GetMapping
    public String dashboard(Model model) {
        model.addAttribute("summary", service.getSummary());
        model.addAttribute("recentItems", service.getRecentItems());
        model.addAttribute("recentBoms", service.getRecentBoms());
        return "development/dashboard";
    }
}
