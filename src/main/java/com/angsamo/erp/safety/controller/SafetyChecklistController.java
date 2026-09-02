package com.angsamo.erp.safety.controller;

import java.time.LocalDate;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.safety.domain.SafetyChecklist;
import com.angsamo.erp.safety.dto.HelmetDetectionResult;
import com.angsamo.erp.safety.service.HelmetDetectionService;
import com.angsamo.erp.safety.service.SafetyChecklistService;

import jakarta.servlet.http.HttpSession;

// 접근 제어는 AdminInterceptor(/safety/**)가 담당한다.
@Controller
public class SafetyChecklistController {

    private final SafetyChecklistService service;
    private final HelmetDetectionService detectionService;

    public SafetyChecklistController(SafetyChecklistService service, HelmetDetectionService detectionService) {
        this.service = service;
        this.detectionService = detectionService;
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
            @RequestParam(defaultValue = "false") boolean chinStrapFastened,
            @RequestParam(defaultValue = "false") boolean damaged,
            @RequestParam(defaultValue = "false") boolean expired,
            @RequestParam(required = false) String memo,
            RedirectAttributes redirect) {
        try {
            service.addItem(checklistId, media, helmetWorn, chinStrapFastened, damaged, expired, memo);
            redirect.addFlashAttribute("success", "확인 항목을 등록했습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/safety/checklist";
    }

    // 업로드한 사진을 실제로 등록하기 전, AI 판정 결과와 탐지 박스를 미리 보여주기 위한 미리보기 전용 엔드포인트.
    @PostMapping("/safety/checklist/detect-preview")
    @ResponseBody
    public Map<String, Object> detectPreview(@RequestParam("media") MultipartFile media) {
        HelmetDetectionResult result = detectionService.detect(media);
        return Map.of(
                "success", result.isSuccess(),
                "helmetWorn", result.getHelmetWorn() == null ? false : result.getHelmetWorn(),
                "predictions", result.getPredictions());
    }

    @PostMapping("/safety/checklist/{checklistId}/items/{itemId}/delete")
    public String deleteItem(@PathVariable Long checklistId, @PathVariable Long itemId, RedirectAttributes redirect) {
        try {
            service.deleteItem(itemId);
            redirect.addFlashAttribute("success", "확인 항목을 삭제했습니다.");
        } catch (IllegalArgumentException e) {
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
