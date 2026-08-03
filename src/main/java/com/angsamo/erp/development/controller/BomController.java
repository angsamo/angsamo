package com.angsamo.erp.development.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.angsamo.erp.development.service.BomService;

@Controller
@RequestMapping("/development/boms")
public class BomController {

    private final BomService bomService;

    public BomController(BomService bomService) {
        this.bomService = bomService;
    }

    @GetMapping
    public String list(Model model) {

        model.addAttribute("boms", bomService.findAll());

        return "development/bom-list";
    }

}