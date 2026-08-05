package com.angsamo.erp.production.controller;

import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/production/material-requirements")
public class MaterialRequirementController {

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "requirements",
                new ArrayList<>()
        );

        return "production/material-requirement-list";
    }

}