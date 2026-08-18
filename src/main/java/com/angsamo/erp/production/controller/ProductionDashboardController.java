package com.angsamo.erp.production.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.angsamo.erp.production.service.ProductionDashboardService;

@Controller
@RequestMapping("/production")
public class ProductionDashboardController {

    private final ProductionDashboardService service;

    public ProductionDashboardController(ProductionDashboardService service) {
        this.service = service;
    }

    @GetMapping
    public String dashboard(Model model) {
        model.addAttribute("summary", service.getSummary());
        model.addAttribute("recentPlans", service.getRecentPlans());
        model.addAttribute("recentRequests", service.getRecentMaterialRequests());
        return "production/dashboard";
    }
}
