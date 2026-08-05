package com.angsamo.erp.purchase.controller;

import java.time.LocalDate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.purchase.dto.ProcurementCreateForm;
import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.QuoteRequestForm;
import com.angsamo.erp.purchase.dto.VendorDetail;
import com.angsamo.erp.purchase.dto.VendorForm;
import com.angsamo.erp.purchase.service.PurchaseService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class PurchaseController {

    private final PurchaseService purchaseService;

    public PurchaseController(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }

    @GetMapping("/purchase/vendors")
    public String vendorList(Model model, HttpSession session) {
        requirePurchase(session);
        model.addAttribute("vendors", purchaseService.getVendors());
        return "purchase/list";
    }

    @GetMapping("/purchase/vendors/new")
    public String vendorCreateForm(Model model, HttpSession session) {
        requirePurchase(session);

        if (!model.containsAttribute("vendorForm")) {
            model.addAttribute("vendorForm", new VendorForm());
        }

        return "purchase/vendor-form";
    }

    @PostMapping("/purchase/vendors")
    public String createVendor(
            @Valid VendorForm vendorForm,
            BindingResult bindingResult,
            RedirectAttributes redirect,
            HttpSession session) {

        requirePurchase(session);

        if (bindingResult.hasErrors()) {
            redirect.addFlashAttribute(
                    "org.springframework.validation.BindingResult.vendorForm",
                    bindingResult);
            redirect.addFlashAttribute("vendorForm", vendorForm);
            return "redirect:/purchase/vendors/new";
        }

        try {
            purchaseService.createVendor(vendorForm);
            redirect.addFlashAttribute("success", "협력업체가 등록됐습니다.");
            return "redirect:/purchase/vendors";
        } catch (RuntimeException e) {
            redirect.addFlashAttribute("error", e.getMessage());
            redirect.addFlashAttribute("vendorForm", vendorForm);
            return "redirect:/purchase/vendors/new";
        }
    }

    @GetMapping("/purchase/vendors/{vendorId}")
    public String vendorDetail(
            @PathVariable Long vendorId,
            Model model,
            HttpSession session) {

        requirePurchase(session);

        VendorDetail vendor = purchaseService.getVendor(vendorId);

        if (vendor == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "협력업체를 찾을 수 없습니다.");
        }

        model.addAttribute("vendor", vendor);
        model.addAttribute(
                "vendorAccounts",
                purchaseService.getVendorAccounts(vendorId));

        return "purchase/detail";
    }

    @GetMapping("/purchase/vendors/{vendorId}/edit")
    public String vendorEditForm(
            @PathVariable Long vendorId,
            Model model,
            HttpSession session) {

        requirePurchase(session);

        VendorDetail vendor = purchaseService.getVendor(vendorId);

        if (vendor == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "협력업체를 찾을 수 없습니다.");
        }

        if (!model.containsAttribute("vendorForm")) {
            VendorForm form = new VendorForm();
            form.setVendorCode(vendor.getVendorCode());
            form.setVendorName(vendor.getVendorName());
            form.setContactName(vendor.getContactName());
            form.setPhone(vendor.getPhone());
            form.setEmail(vendor.getEmail());
            form.setAddress(vendor.getAddress());
            form.setActive(vendor.getActive());

            model.addAttribute("vendorForm", form);
        }

        model.addAttribute("vendorId", vendorId);
        return "purchase/vendor-form";
    }

    @PostMapping("/purchase/vendors/{vendorId}")
    public String updateVendor(
            @PathVariable Long vendorId,
            @Valid VendorForm vendorForm,
            BindingResult bindingResult,
            RedirectAttributes redirect,
            HttpSession session) {

        requirePurchase(session);

        if (bindingResult.hasErrors()) {
            redirect.addFlashAttribute(
                    "org.springframework.validation.BindingResult.vendorForm",
                    bindingResult);
            redirect.addFlashAttribute("vendorForm", vendorForm);
            return "redirect:/purchase/vendors/" + vendorId + "/edit";
        }

        try {
            purchaseService.updateVendor(vendorId, vendorForm);
            redirect.addFlashAttribute("success", "협력업체가 수정됐습니다.");
            return "redirect:/purchase/vendors/" + vendorId;
        } catch (RuntimeException e) {
            redirect.addFlashAttribute("error", e.getMessage());
            redirect.addFlashAttribute("vendorForm", vendorForm);
            return "redirect:/purchase/vendors/" + vendorId + "/edit";
        }
    }

    @PostMapping("/purchase/vendors/{vendorId}/deactivate")
    public String deactivateVendor(
            @PathVariable Long vendorId,
            RedirectAttributes redirect,
            HttpSession session) {

        requirePurchase(session);

        try {
            purchaseService.deactivateVendor(vendorId);
            redirect.addFlashAttribute("success", "거래를 중지했습니다.");
        } catch (RuntimeException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/purchase/vendors";
    }

    @GetMapping("/purchase/shortages")
    public String shortageList(Model model, HttpSession session) {
        requirePurchase(session);
        model.addAttribute(
                "shortages", purchaseService.getShortageMaterialRequests());
        return "purchase/shortages";
    }

    @GetMapping("/purchase/shortages/{requestId}/procurement")
    public String procurementCreateForm(
            @PathVariable Long requestId,
            Model model,
            HttpSession session) {

        requirePurchase(session);

        ProcurementCreateForm form = new ProcurementCreateForm();
        form.setMaterialRequestId(requestId);

        model.addAttribute("procurementForm", form);
        return "purchase/procurement-form";
    }

    @PostMapping("/purchase/procurements")
    public String createProcurement(
            @Valid ProcurementCreateForm procurementForm,
            BindingResult bindingResult,
            RedirectAttributes redirect,
            HttpSession session) {

        LoginUser user = requirePurchase(session);

        if (bindingResult.hasErrors()) {
            redirect.addFlashAttribute("error", "입력값을 확인하세요.");
            return "redirect:/purchase/shortages/"
                    + procurementForm.getMaterialRequestId()
                    + "/procurement";
        }

        try {
            purchaseService.createProcurement(
                    procurementForm,
                    user.getUserId(),
                    user.getDepartmentId(),
                    isAdmin(user));

            redirect.addFlashAttribute("success", "조달업무가 생성됐습니다.");
            return "redirect:/purchase/procurements";
        } catch (RuntimeException e) {
            redirect.addFlashAttribute("error", e.getMessage());
            return "redirect:/purchase/shortages";
        }
    }
    
    @GetMapping("/purchase/procurements/{procurementId}/edit")
    public String procurementEditForm(
            @PathVariable Long procurementId,
            Model model,
            HttpSession session) {

        LoginUser user = requirePurchase(session);

        ProcurementDetail procurement =
                purchaseService.getProcurement(procurementId);

        if (procurement == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "조달업무를 찾을 수 없습니다.");
        }

        if (!isAdmin(user)
                && !procurement.getDepartmentId().equals(user.getDepartmentId())) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "다른 부서의 조달업무는 수정할 수 없습니다.");
        }

        if (!"REQUESTED".equals(procurement.getStatus())) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "REQUESTED 상태의 조달업무만 수정할 수 있습니다.");
        }

        model.addAttribute("procurement", procurement);
        return "purchase/procurement-edit";
    }

    @PostMapping("/purchase/procurements/{procurementId}/edit")
    public String updateProcurement(
            @PathVariable Long procurementId,
            @RequestParam LocalDate quoteDeadline,
            @RequestParam(required = false) String terms,
            RedirectAttributes redirect,
            HttpSession session) {

        LoginUser user = requirePurchase(session);

        try {
            purchaseService.updateProcurement(
                    procurementId,
                    quoteDeadline,
                    terms,
                    user.getDepartmentId(),
                    isAdmin(user));

            redirect.addFlashAttribute(
                    "success", "조달업무가 수정됐습니다.");

            return "redirect:/purchase/procurements/" + procurementId;
        } catch (RuntimeException e) {
            redirect.addFlashAttribute("error", e.getMessage());

            return "redirect:/purchase/procurements/"
                    + procurementId
                    + "/edit";
        }
    }
    
    @GetMapping("/purchase/procurements")
    public String procurementList(Model model, HttpSession session) {
        requirePurchase(session);
        model.addAttribute(
                "procurements", purchaseService.getProcurements());
        return "purchase/procurements";
    }

    @GetMapping("/purchase/procurements/{procurementId}")
    public String procurementDetail(
            @PathVariable Long procurementId,
            Model model,
            HttpSession session) {

        requirePurchase(session);

        ProcurementDetail procurement =
                purchaseService.getProcurement(procurementId);

        if (procurement == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, "조달업무를 찾을 수 없습니다.");
        }

        model.addAttribute("procurement", procurement);
        model.addAttribute("vendors", purchaseService.getActiveVendors());
        model.addAttribute("quoteForm", new QuoteRequestForm());

        return "purchase/procurement-detail";
    }

    @PostMapping("/purchase/procurements/{procurementId}/quotes")
    public String requestQuotes(
            @PathVariable Long procurementId,
            @Valid QuoteRequestForm quoteForm,
            BindingResult bindingResult,
            RedirectAttributes redirect,
            HttpSession session) {

        LoginUser user = requirePurchase(session);

        if (bindingResult.hasErrors()) {
            redirect.addFlashAttribute(
                    "error", "협력업체를 한 곳 이상 선택하세요.");
            return "redirect:/purchase/procurements/" + procurementId;
        }

        try {
            purchaseService.requestQuotes(
                    procurementId,
                    quoteForm,
                    user.getDepartmentId(),
                    isAdmin(user));

            redirect.addFlashAttribute("success", "견적 요청을 등록했습니다.");
        } catch (RuntimeException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/purchase/procurements/" + procurementId;
    }

    @PostMapping("/purchase/procurements/{procurementId}/cancel")
    public String cancelProcurement(
            @PathVariable Long procurementId,
            RedirectAttributes redirect,
            HttpSession session) {

        LoginUser user = requirePurchase(session);

        try {
            purchaseService.cancelProcurement(
                    procurementId,
                    user.getDepartmentId(),
                    isAdmin(user));

            redirect.addFlashAttribute("success", "조달업무를 취소했습니다.");
        } catch (RuntimeException e) {
            redirect.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/purchase/procurements";
    }

    @GetMapping("/purchase/quotes")
    public String quoteList(Model model, HttpSession session) {
        requirePurchase(session);
        model.addAttribute("quotes", purchaseService.getVendorQuotes());
        return "purchase/quotes";
    }

    private LoginUser requirePurchase(HttpSession session) {
        LoginUser user =
                (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);

        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        boolean allowed = isAdmin(user)
                || ("MEMBER".equals(user.getRole())
                    && "PURCHASE".equals(user.getDepartmentCode()));

        if (!allowed) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN, "구매 기능 접근 권한이 없습니다.");
        }

        return user;
    }

    private boolean isAdmin(LoginUser user) {
        return "ADMIN".equals(user.getRole());
    }
}