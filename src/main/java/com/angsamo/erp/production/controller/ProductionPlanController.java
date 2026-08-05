package com.angsamo.erp.production.controller;

import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.service.ItemService;
import com.angsamo.erp.production.domain.ProductionPlan;
import com.angsamo.erp.production.service.ProductionPlanService;

@Controller
@RequestMapping("/production/plans")
public class ProductionPlanController {

    private final ProductionPlanService productionPlanService;
    private final ItemService itemService;

    public ProductionPlanController(
            ProductionPlanService productionPlanService,
            ItemService itemService
    ) {
        this.productionPlanService = productionPlanService;
        this.itemService = itemService;
    }

    // 생산계획 전체 목록 조회
    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "productionPlans",
                productionPlanService.findAll()
        );

        return "production/production-plan-list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {

        if (!model.containsAttribute("productionPlan")) {
            ProductionPlan productionPlan = new ProductionPlan();
            productionPlan.setStatus("PLANNED");

            model.addAttribute(
                    "productionPlan",
                    productionPlan
            );
        }

        addProductOptions(model);

        return "production/production-plan-form";
    }

    // 생산계획 등록 처리
    @PostMapping
    public String create(
            @ModelAttribute ProductionPlan productionPlan,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        LoginUser loginUser = getLoginUser(session);

        try {
            Long productionPlanId = productionPlanService.insert(
                    productionPlan,
                    loginUser
            );

            redirectAttributes.addFlashAttribute(
                    "message",
                    "생산계획이 등록되었습니다."
            );

            return "redirect:/production/plans/"
                    + productionPlanId;

        } catch (IllegalArgumentException | IllegalStateException e) {
            model.addAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            model.addAttribute(
                    "productionPlan",
                    productionPlan
            );

            addProductOptions(model);

            return "production/production-plan-form";
        }
    }

    // 생산계획 상세 조회
    @GetMapping("/{productionPlanId}")
    public String detail(
            @PathVariable Long productionPlanId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        ProductionPlan productionPlan =
                productionPlanService.findById(productionPlanId);

        if (productionPlan == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "해당 생산계획을 찾을 수 없습니다."
            );

            return "redirect:/production/plans";
        }

        model.addAttribute(
                "productionPlan",
                productionPlan
        );

        return "production/production-plan-detail";
    }

    // 생산계획 수정 화면
    @GetMapping("/{productionPlanId}/edit")
    public String editForm(
            @PathVariable Long productionPlanId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        LoginUser loginUser = getLoginUser(session);

        if (!canManageProductionPlan(loginUser)) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "생산계획을 수정할 권한이 없습니다."
            );

            return "redirect:/production/plans";
        }

        ProductionPlan productionPlan =
                productionPlanService.findById(productionPlanId);

        if (productionPlan == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "수정할 생산계획을 찾을 수 없습니다."
            );

            return "redirect:/production/plans";
        }

        if (!canAccessDepartment(
                productionPlan,
                loginUser
        )) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "다른 부서의 생산계획은 수정할 수 없습니다."
            );

            return "redirect:/production/plans/"
                    + productionPlanId;
        }

        model.addAttribute(
                "productionPlan",
                productionPlan
        );

        return "production/production-plan-edit";
    }

    // 생산계획 수량 및 일정 수정
    @PostMapping("/{productionPlanId}/edit")
    public String update(
            @PathVariable Long productionPlanId,
            @ModelAttribute ProductionPlan productionPlan,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        LoginUser loginUser = getLoginUser(session);

        try {
            productionPlan.setProductionPlanId(
                    productionPlanId
            );

            productionPlanService.update(
                    productionPlan,
                    loginUser
            );

            redirectAttributes.addFlashAttribute(
                    "message",
                    "생산계획이 수정되었습니다."
            );

            return "redirect:/production/plans/"
                    + productionPlanId;

        } catch (IllegalArgumentException | IllegalStateException e) {
            ProductionPlan existingPlan =
                    productionPlanService.findById(
                            productionPlanId
                    );

            if (existingPlan != null) {
                productionPlan.setProductionPlanId(
                        existingPlan.getProductionPlanId()
                );

                productionPlan.setDepartmentId(
                        existingPlan.getDepartmentId()
                );

                productionPlan.setItemId(
                        existingPlan.getItemId()
                );

                productionPlan.setItemCode(
                        existingPlan.getItemCode()
                );

                productionPlan.setItemName(
                        existingPlan.getItemName()
                );

                productionPlan.setDepartmentName(
                        existingPlan.getDepartmentName()
                );

                productionPlan.setCreatedBy(
                        existingPlan.getCreatedBy()
                );

                productionPlan.setCreatedByName(
                        existingPlan.getCreatedByName()
                );

                productionPlan.setStatus(
                        existingPlan.getStatus()
                );

                productionPlan.setCreatedAt(
                        existingPlan.getCreatedAt()
                );

                productionPlan.setUpdatedAt(
                        existingPlan.getUpdatedAt()
                );
            }

            model.addAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            model.addAttribute(
                    "productionPlan",
                    productionPlan
            );

            return "production/production-plan-edit";
        }
    }

    // 생산계획 상태 변경
    @PostMapping("/{productionPlanId}/status")
    public String updateStatus(
            @PathVariable Long productionPlanId,
            @RequestParam String status,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        LoginUser loginUser = getLoginUser(session);

        try {
            productionPlanService.updateStatus(
                    productionPlanId,
                    status,
                    loginUser
            );

            redirectAttributes.addFlashAttribute(
                    "message",
                    "생산계획 상태가 변경되었습니다."
            );

        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    e.getMessage()
            );
        }

        return "redirect:/production/plans/"
                + productionPlanId;
    }

    // 사용 중인 완제품 목록 전달
    private void addProductOptions(Model model) {
        List<Item> productItems = itemService.findAll()
                .stream()
                .filter(item ->
                        "PRODUCT".equals(item.getItemType())
                )
                .toList();

        model.addAttribute(
                "productItems",
                productItems
        );
    }

    // 로그인 사용자 조회
    private LoginUser getLoginUser(HttpSession session) {
        Object loginUser =
                session.getAttribute(LoginUser.SESSION_KEY);

        if (loginUser instanceof LoginUser) {
            return (LoginUser) loginUser;
        }

        return null;
    }

    // 생산계획 등록·수정 권한 확인
    private boolean canManageProductionPlan(
            LoginUser loginUser
    ) {
        if (loginUser == null) {
            return false;
        }

        boolean admin =
                "ADMIN".equals(loginUser.getRole());

        boolean productionDepartment =
                "PRODUCTION".equals(
                        loginUser.getDepartmentCode()
                );

        return admin || productionDepartment;
    }

    // 자기 부서 생산계획인지 확인
    private boolean canAccessDepartment(
            ProductionPlan productionPlan,
            LoginUser loginUser
    ) {
        if (loginUser == null) {
            return false;
        }

        if ("ADMIN".equals(loginUser.getRole())) {
            return true;
        }

        return loginUser.getDepartmentId() != null
                && productionPlan.getDepartmentId() != null
                && loginUser.getDepartmentId().equals(
                        productionPlan.getDepartmentId()
                );
    }
}