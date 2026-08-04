package com.angsamo.erp.development.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.angsamo.erp.development.service.BomService;
import com.angsamo.erp.development.service.ItemService;

@Controller
@RequestMapping("/development/boms")
public class BomController {

    private final BomService bomService;
    private final ItemService itemService;

    public BomController(
            BomService bomService,
            ItemService itemService
    ) {
        this.bomService = bomService;
        this.itemService = itemService;
    }

    // 전체 BOM 목록
    @GetMapping
    public String list(Model model) {
        model.addAttribute("boms", bomService.findAll());

        return "development/bom-list";
    }

    // 특정 완제품의 BOM 구성 자재 목록
    @GetMapping("/parent/{parentItemId}")
    public String listByParentItem(
            @PathVariable Long parentItemId,
            Model model
    ) {
        model.addAttribute(
                "parentItem",
                itemService.findByItemId(parentItemId)
        );

        model.addAttribute(
                "boms",
                bomService.findByParentItemId(parentItemId)
        );

        return "development/bom-list";
    }
}