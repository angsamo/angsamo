package com.angsamo.erp.development.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.service.DevelopmentAccessPolicy;
import com.angsamo.erp.development.service.ItemService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/development/items")
public class ItemController {

    private final ItemService itemService;
    private final DevelopmentAccessPolicy accessPolicy;

    public ItemController(ItemService itemService, DevelopmentAccessPolicy accessPolicy) {
        this.itemService = itemService;
        this.accessPolicy = accessPolicy;
    }

    // 품목 목록
    @GetMapping
    public String list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String itemType,
            Model model) {
        model.addAttribute("items", itemService.search(keyword, itemType));
        model.addAttribute("keyword", keyword);
        model.addAttribute("itemType", itemType);

        return "development/item-list";
    }

    // 품목 등록 화면
    @GetMapping("/new")
    public String createForm(Model model, HttpSession session) {
        requireManager(session);
        Item item = new Item();

        item.setUnit("EA");
        item.setActive(1);

        model.addAttribute("item", item);

        return "development/item-form";
    }

    // 품목 등록 처리
    @PostMapping
    public String create(
            @ModelAttribute Item item,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        try {
            Long itemId = itemService.insert(item);

            redirectAttributes.addFlashAttribute(
                    "message",
                    "품목이 등록되었습니다."
            );

            return "redirect:/development/items/" + itemId;

        } catch (IllegalArgumentException | IllegalStateException e) {
            model.addAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            model.addAttribute("item", item);

            return "development/item-form";
        }
    }

    // 품목 상세
    @GetMapping("/{itemId}")
    public String detail(
            @PathVariable Long itemId,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        Item item = itemService.findByItemId(itemId);

        if (item == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "해당 품목을 찾을 수 없습니다."
            );

            return "redirect:/development/items";
        }

        model.addAttribute("item", item);

        return "development/item-detail";
    }

    // 품목 수정 화면
    @GetMapping("/{itemId}/edit")
    public String editForm(
            @PathVariable Long itemId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        Item item = itemService.findByItemId(itemId);

        if (item == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "수정할 품목을 찾을 수 없습니다."
            );

            return "redirect:/development/items";
        }

        model.addAttribute("item", item);

        return "development/item-edit";
    }

    // 품목 수정 처리
    @PostMapping("/{itemId}/edit")
    public String update(
            @PathVariable Long itemId,
            @ModelAttribute Item item,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        try {
            item.setItemId(itemId);

            itemService.update(item);

            redirectAttributes.addFlashAttribute(
                    "message",
                    "품목 정보가 수정되었습니다."
            );

            return "redirect:/development/items/" + itemId;

        } catch (IllegalArgumentException | IllegalStateException e) {
            Item existingItem = itemService.findByItemId(itemId);

            if (existingItem != null) {
                item.setItemId(itemId);
                item.setItemCode(existingItem.getItemCode());
            }

            model.addAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            model.addAttribute("item", item);

            return "development/item-edit";
        }
    }

    // 품목 미사용 처리
    @PostMapping("/{itemId}/delete")
    public String deactivate(
            @PathVariable Long itemId,
            RedirectAttributes redirectAttributes,
            HttpSession session
    ) {
        requireManager(session);
        try {
            boolean deactivated = itemService.deactivate(itemId);

            if (deactivated) {
                redirectAttributes.addFlashAttribute(
                        "message",
                        "품목이 미사용 처리되었습니다."
                );

                return "redirect:/development/items";
            }

            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "미사용 처리할 품목을 찾을 수 없습니다."
            );

            return "redirect:/development/items";

        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            return "redirect:/development/items";
        }
    }

    private void requireManager(HttpSession session) {
        accessPolicy.requireManager(
                (LoginUser) session.getAttribute(LoginUser.SESSION_KEY)
        );
    }
}
