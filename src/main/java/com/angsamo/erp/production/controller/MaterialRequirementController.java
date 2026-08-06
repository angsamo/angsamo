package com.angsamo.erp.production.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.angsamo.erp.production.service.MaterialRequirementService;

@Controller
@RequestMapping("/production/material-requirements")
public class MaterialRequirementController {

    private final MaterialRequirementService service;

    public MaterialRequirementController(MaterialRequirementService service) {
        this.service = service;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("requirements", service.findAll());

        return "production/material-requirement-list";
    }

}
