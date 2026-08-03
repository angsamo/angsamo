package com.angsamo.erp.development.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.service.ItemService;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/development/items")
public class ItemController {

    private final ItemService itemService;

    public ItemController(ItemService itemService) {
        this.itemService = itemService;
    }

    // 품목 목록
    @GetMapping
    public String list(Model model) {
        model.addAttribute("items", itemService.findAll());

        return "development/item-list";
    }
    
    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("item", new Item());
        return "development/item-form";
    }
    
    // 품목 상세
    @GetMapping("/{itemCode}")
    public String detail(
            @PathVariable String itemCode,
            Model model
    ) {
        Item item = itemService.findByItemCode(itemCode);

        model.addAttribute("item", item);

        return "development/item-detail";
    }
    
    // 품목 등록 처리
    @PostMapping
    public String create(@ModelAttribute Item item) {
        itemService.insert(item);
        return "redirect:/development/items";
    }
    
    @GetMapping("/{itemCode}/edit")
    public String editForm(
            @PathVariable String itemCode,
            Model model
    ) {
        Item item = itemService.findByItemCode(itemCode);
        model.addAttribute("item", item);

        return "development/item-edit";
    }
    
    @PostMapping("/{itemCode}/edit")
    public String update(
            @PathVariable String itemCode,
            @ModelAttribute Item item
    ) {
        item.setItemCode(itemCode);
        itemService.update(item);

        return "redirect:/development/items/" + itemCode;
    }
    
    @PostMapping("/{itemCode}/delete")
    public String delete(
            @PathVariable String itemCode,
            RedirectAttributes redirectAttributes
    ) {
        try {
            boolean deleted = itemService.delete(itemCode);

            if (deleted) {
                redirectAttributes.addFlashAttribute(
                        "message",
                        "품목이 삭제되었습니다."
                );
            } else {
                redirectAttributes.addFlashAttribute(
                        "errorMessage",
                        "삭제할 품목을 찾을 수 없습니다."
                );
            }

            return "redirect:/development/items";

        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            return "redirect:/development/items/" + itemCode;
        }
    }
}