package com.angsamo.erp.safety.controller;

import java.time.LocalDate;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.safety.domain.SafetyChecklist;
import com.angsamo.erp.safety.service.SafetyChecklistService;

import jakarta.servlet.http.HttpSession;

// 접근 제어는 AdminInterceptor(/safety/**)가 담당한다.
@Controller
public class SafetyChecklistController {

    private final SafetyChecklistService service;

    public SafetyChecklistController(SafetyChecklistService service) {
        this.service = service;
    }

    @GetMapping("/safety/checklist")
    public String page(Model model) {
        SafetyChecklist active = service.getActiveChecklist();
        model.addAttribute("active", active);
        if (active != null) {
            model.addAttribute("items", service.getItems(active.getChecklistId()));
        }
        model.addAttribute("checklists", service.getChecklists());
        model.addAttribute("today", LocalDate.now());
        return "safety/checklist-list";
    }

    @GetMapping("/safety/checklist/{checklistId}")
    public String detail(@PathVariable Long checklistId, Model model) {
        model.addAttribute("checklist", service.getChecklist(checklistId));
        model.addAttribute("items", service.getItems(checklistId));
        return "safety/checklist-detail";
    }

    @PostMapping("/safety/checklist")
    public String create(@RequestParam(required = false) LocalDate checkDate,
            @RequestParam(required = false) String location, HttpSession session,
            RedirectAttributes redirect) {
        LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
        try {
            service.createChecklist(loginUser.getDepartmentId(), loginUser.getUserId(), checkDate, location);
            redirect.addFlashAttribute("success", "점검을 시작했습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/checklist";
    }

    @PostMapping("/safety/checklist/{checklistId}/items")
    public String addItem(@PathVariable Long checklistId,
            @RequestParam(required = false) MultipartFile media,
            @RequestParam(defaultValue = "false") boolean helmetWorn,
            @RequestParam(required = false) String memo,
            RedirectAttributes redirect) {
        try {
            service.addItem(checklistId, media, helmetWorn, memo);
            redirect.addFlashAttribute("success", "확인 항목을 등록했습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/checklist";
    }

    @PostMapping("/safety/checklist/{checklistId}/complete")
    public String complete(@PathVariable Long checklistId, RedirectAttributes redirect) {
        try {
            service.completeChecklist(checklistId);
            redirect.addFlashAttribute("success", "점검을 완료 처리했습니다.");
        } catch (IllegalArgumentException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/checklist";
    }
}
