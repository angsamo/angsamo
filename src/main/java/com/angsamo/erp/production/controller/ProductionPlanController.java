package com.angsamo.erp.production.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.angsamo.erp.production.service.ProductionPlanService;

@Controller
@RequestMapping("/production/plans")
public class ProductionPlanController {

    private final ProductionPlanService productionPlanService;

    public ProductionPlanController(
            ProductionPlanService productionPlanService
    ) {
        this.productionPlanService = productionPlanService;
    }

    // 생산계획 전체 목록 조회
    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "productionPlans",
                productionPlanService.findAll()
        );

        return "production/production-plan-list";
    }
}