package com.angsamo.erp.development.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.development.domain.Bom;
import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.service.DevelopmentAccessPolicy;
import com.angsamo.erp.development.service.BomService;
import com.angsamo.erp.development.service.ItemService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/development/boms")
public class BomController {

    private final BomService bomService;
    private final ItemService itemService;
    private final DevelopmentAccessPolicy accessPolicy;

    public BomController(
            BomService bomService,
            ItemService itemService,
            DevelopmentAccessPolicy accessPolicy
    ) {
        this.bomService = bomService;
        this.itemService = itemService;
        this.accessPolicy = accessPolicy;
    }

    // 전체 BOM 목록
    @GetMapping
    public String list(
            @RequestParam(required = false) String keyword,
            Model model) {
        model.addAttribute("boms", bomService.search(keyword));
        model.addAttribute("keyword", keyword);

        return "development/bom-list";
    }

    // 특정 완제품의 BOM 구성 자재 목록
    @GetMapping("/parent/{parentItemId}")
    public String listByParentItem(
            @PathVariable Long parentItemId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Item parentItem = itemService.findByItemId(parentItemId);

        if (parentItem == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "해당 완제품을 찾을 수 없습니다."
            );

            return "redirect:/development/boms";
        }

        model.addAttribute("parentItem", parentItem);
        model.addAttribute(
                "boms",
                bomService.findByParentItemId(parentItemId)
        );

        return "development/bom-list";
    }

    // BOM 등록 화면
    @GetMapping("/new")
    public String createForm(Model model, HttpSession session) {
        requireManager(session);
        addItemOptions(model);

        if (!model.containsAttribute("bom")) {
            model.addAttribute("bom", new Bom());
        }

        return "development/bom-form";
    }

    // BOM 등록 처리
    @PostMapping
    public String create(
            @ModelAttribute Bom bom,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        try {
            Long bomId = bomService.insert(bom);

            redirectAttributes.addFlashAttribute(
                    "message",
                    "BOM 구성 자재가 등록되었습니다."
            );

            return "redirect:/development/boms/" + bomId;

        } catch (IllegalArgumentException | IllegalStateException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("bom", bom);

            addItemOptions(model);

            return "development/bom-form";
        }
    }

    // BOM 상세 조회
    @GetMapping("/{bomId}")
    public String detail(
            @PathVariable Long bomId,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        Bom bom = bomService.findByBomId(bomId);

        if (bom == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "해당 BOM을 찾을 수 없습니다."
            );

            return "redirect:/development/boms";
        }

        model.addAttribute("bom", bom);

        return "development/bom-detail";
    }

    // BOM 수정 화면
    @GetMapping("/{bomId}/edit")
    public String editForm(
            @PathVariable Long bomId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Bom bom = bomService.findByBomId(bomId);

        if (bom == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "수정할 BOM을 찾을 수 없습니다."
            );

            return "redirect:/development/boms";
        }

        model.addAttribute("bom", bom);

        return "development/bom-edit";
    }

    // BOM 필요 수량 수정
    @PostMapping("/{bomId}/edit")
    public String update(
            @PathVariable Long bomId,
            @ModelAttribute Bom bom,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        try {
            bom.setBomId(bomId);

            bomService.update(bom);

            redirectAttributes.addFlashAttribute(
                    "message",
                    "BOM 필요 수량이 수정되었습니다."
            );

            return "redirect:/development/boms/" + bomId;

        } catch (IllegalArgumentException | IllegalStateException e) {
            Bom existingBom = bomService.findByBomId(bomId);

            if (existingBom != null) {
                bom.setBomId(bomId);
                bom.setParentItemId(existingBom.getParentItemId());
                bom.setComponentItemId(existingBom.getComponentItemId());
                bom.setParentItemCode(existingBom.getParentItemCode());
                bom.setParentItemName(existingBom.getParentItemName());
                bom.setComponentItemCode(existingBom.getComponentItemCode());
                bom.setComponentItemName(existingBom.getComponentItemName());
                bom.setComponentUnit(existingBom.getComponentUnit());
            }

            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("bom", bom);

            return "development/bom-edit";
        }
    }

    // BOM 구성 자재 삭제
    @PostMapping("/{bomId}/delete")
    public String delete(
            @PathVariable Long bomId,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        boolean deleted = bomService.delete(bomId);

        if (deleted) {
            redirectAttributes.addFlashAttribute(
                    "message",
                    "BOM 구성 자재가 삭제되었습니다."
            );
        } else {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "삭제할 BOM을 찾을 수 없습니다."
            );
        }

        return "redirect:/development/boms";
    }

    private void addItemOptions(Model model) {
        List<Item> items = itemService.findAll();

        List<Item> productItems = items.stream()
                .filter(item -> "PRODUCT".equals(item.getItemType()))
                .toList();

        List<Item> materialItems = items.stream()
                .filter(item -> "MATERIAL".equals(item.getItemType()))
                .toList();

        model.addAttribute("productItems", productItems);
        model.addAttribute("materialItems", materialItems);
    }

    private void requireManager(HttpSession session) {
        accessPolicy.requireManager(
                (LoginUser) session.getAttribute(LoginUser.SESSION_KEY)
        );
    }
}
