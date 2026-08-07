package com.angsamo.erp.production.controller;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.production.domain.MaterialRequest;
import com.angsamo.erp.production.service.MaterialRequestService;

@Controller
@RequestMapping("/production/material-requests")
public class MaterialRequestController {

    private final MaterialRequestService materialRequestService;

    public MaterialRequestController(
            MaterialRequestService materialRequestService
    ) {
        this.materialRequestService = materialRequestService;
    }

    // 자재요청 전체 목록 조회
    @GetMapping
    public String list(Model model) {
        model.addAttribute(
                "materialRequests",
                materialRequestService.findAll()
        );

        return "production/material-request-list";
    }

    // 특정 생산계획의 자재요청 목록 조회
    @GetMapping("/production-plan/{productionPlanId}")
    public String listByProductionPlan(
            @PathVariable Long productionPlanId,
            Model model
    ) {
        model.addAttribute(
                "productionPlanId",
                productionPlanId
        );

        model.addAttribute(
                "materialRequests",
                materialRequestService.findByProductionPlanId(
                        productionPlanId
                )
        );

        return "production/material-request-list";
    }

    // 생산계획의 BOM을 기준으로 자재요청 자동 생성
    @PostMapping("/production-plan/{productionPlanId}/create")
    public String createFromProductionPlan(
            @PathVariable Long productionPlanId,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        LoginUser loginUser = getLoginUser(session);

        try {
            int createdCount =
                    materialRequestService.createFromProductionPlan(
                            productionPlanId,
                            loginUser
                    );

            redirectAttributes.addFlashAttribute(
                    "message",
                    createdCount
                            + "건의 자재요청이 생성되었습니다."
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

    // 자재요청 상세 조회
    @GetMapping("/{requestId}")
    public String detail(
            @PathVariable Long requestId,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        MaterialRequest materialRequest =
                materialRequestService.findById(requestId);

        if (materialRequest == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "해당 자재요청을 찾을 수 없습니다."
            );

            return "redirect:/production/material-requests";
        }

        model.addAttribute(
                "materialRequest",
                materialRequest
        );

        return "production/material-request-detail";
    }

    // 자재요청 수정 화면
    @GetMapping("/{requestId}/edit")
    public String editForm(
            @PathVariable Long requestId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        MaterialRequest materialRequest =
                materialRequestService.findById(requestId);

        if (materialRequest == null) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "수정할 자재요청을 찾을 수 없습니다."
            );

            return "redirect:/production/material-requests";
        }

        if (!canManageMaterialRequest(
                getLoginUser(session),
                materialRequest
        )) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "자재요청을 수정할 권한이 없습니다."
            );

            return "redirect:/production/material-requests/"
                    + requestId;
        }

        model.addAttribute(
                "materialRequest",
                materialRequest
        );

        return "production/material-request-edit";
    }

    // REQUESTED 상태 자재요청 수정
    @PostMapping("/{requestId}/edit")
    public String updateRequested(
            @PathVariable Long requestId,
            @ModelAttribute MaterialRequest materialRequest,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        LoginUser loginUser = getLoginUser(session);

        try {
            materialRequest.setRequestId(requestId);

            materialRequestService.updateRequested(
                    materialRequest,
                    loginUser
            );

            redirectAttributes.addFlashAttribute(
                    "message",
                    "자재요청이 수정되었습니다."
            );

            return "redirect:/production/material-requests/"
                    + requestId;

        } catch (IllegalArgumentException | IllegalStateException e) {
            MaterialRequest existingRequest =
                    materialRequestService.findById(requestId);

            if (existingRequest != null) {
                materialRequest.setRequestId(
                        existingRequest.getRequestId()
                );

                materialRequest.setProductionPlanId(
                        existingRequest.getProductionPlanId()
                );

                materialRequest.setDepartmentId(
                        existingRequest.getDepartmentId()
                );

                materialRequest.setItemId(
                        existingRequest.getItemId()
                );

                materialRequest.setIssuedQty(
                        existingRequest.getIssuedQty()
                );

                materialRequest.setStatus(
                        existingRequest.getStatus()
                );

                materialRequest.setRequestedBy(
                        existingRequest.getRequestedBy()
                );

                materialRequest.setProcessedBy(
                        existingRequest.getProcessedBy()
                );

                materialRequest.setIssuedAt(
                        existingRequest.getIssuedAt()
                );

                materialRequest.setCreatedAt(
                        existingRequest.getCreatedAt()
                );

                materialRequest.setUpdatedAt(
                        existingRequest.getUpdatedAt()
                );

                materialRequest.setDepartmentName(
                        existingRequest.getDepartmentName()
                );

                materialRequest.setItemCode(
                        existingRequest.getItemCode()
                );

                materialRequest.setItemName(
                        existingRequest.getItemName()
                );

                materialRequest.setRequestedByName(
                        existingRequest.getRequestedByName()
                );

                materialRequest.setProcessedByName(
                        existingRequest.getProcessedByName()
                );
            }

            model.addAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            model.addAttribute(
                    "materialRequest",
                    materialRequest
            );

            return "production/material-request-edit";
        }
    }

    // REQUESTED 상태 자재요청 취소
    @PostMapping("/{requestId}/cancel")
    public String cancelRequested(
            @PathVariable Long requestId,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        LoginUser loginUser = getLoginUser(session);

        try {
            materialRequestService.cancelRequested(
                    requestId,
                    loginUser
            );

            redirectAttributes.addFlashAttribute(
                    "message",
                    "자재요청이 취소되었습니다."
            );

        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    e.getMessage()
            );
        }

        return "redirect:/production/material-requests/"
                + requestId;
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

    private boolean canManageMaterialRequest(
            LoginUser loginUser,
            MaterialRequest materialRequest
    ) {
        if (loginUser == null || materialRequest == null) {
            return false;
        }

        if ("ADMIN".equals(loginUser.getRole())) {
            return true;
        }

        return "PRODUCTION".equals(loginUser.getDepartmentCode())
                && loginUser.getDepartmentId() != null
                && loginUser.getDepartmentId().equals(
                        materialRequest.getDepartmentId()
                );
    }
}
