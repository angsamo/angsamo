package com.angsamo.erp.production.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.angsamo.erp.production.service.MaterialRequestService;

@Controller
@RequestMapping("/production/material-requests")
public class MaterialRequestController {

    private final MaterialRequestService materialRequestService;

    public MaterialRequestController(
            MaterialRequestService materialRequestService
    ) {
        this.materialRequestService = materialRequestService;
    }

    // 자재요청 전체 목록 조회
    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "materialRequests",
                materialRequestService.findAll()
        );

        return "production/material-request-list";
    }
}