package com.angsamo.erp.vendor.controller;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.vendor.service.VendorService;

import jakarta.servlet.http.HttpSession;

/** 협력회사 전용 페이지와 상태 변경 요청을 제공한다. */
@Controller
@RequestMapping({"/vendor", "/supplier"})
public class VendorController {
    private final VendorService vendorService;

    public VendorController(VendorService vendorService) {
        this.vendorService = vendorService;
    }

    @GetMapping
    public String dashboard(HttpSession session, Model model) {
        model.addAttribute("summary", vendorService.dashboard(readScope(session)));
        return "vendor/dashboard";
    }

    @GetMapping("/quotes")
    public String quotes(@RequestParam(required = false) String status,
            HttpSession session, Model model) {
        String quoteStatus = status == null || status.isBlank() ? "REQUESTED" : status;
        model.addAttribute("quotes", vendorService.quotes(readScope(session), quoteStatus));
        model.addAttribute("status", quoteStatus);
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/quotes";
    }

    @GetMapping("/contracts")
    public String contracts(HttpSession session, Model model) {
        model.addAttribute(
                "contracts",
                vendorService.orders(readScope(session), "CONTRACTED"));
        return "vendor/contracts";
    }

    @PostMapping("/quotes/{quoteId}")
    public String submitQuote(@PathVariable long quoteId,
            @RequestParam BigDecimal unitPrice, @RequestParam LocalDate deliveryDate,
            @RequestParam String terms, HttpSession session, RedirectAttributes redirect) {
        return execute(redirect, "/vendor/quotes",
                () -> vendorService.submitQuote(quoteId, requiredVendorId(session), unitPrice, deliveryDate, terms),
                "견적을 제출했습니다.");
    }

    /** 잡리스트 SP01의 POST /supplier/quotes 주소도 동일한 견적 제출 기능으로 지원한다. */
    @PostMapping("/quotes")
    public String submitQuoteFromList(@RequestParam long quoteId,
            @RequestParam BigDecimal unitPrice, @RequestParam LocalDate deliveryDate,
            @RequestParam String terms, HttpSession session, RedirectAttributes redirect) {
        return submitQuote(quoteId, unitPrice, deliveryDate, terms, session, redirect);
    }

    @GetMapping("/orders")
    public String orders(HttpSession session, Model model) {
        model.addAttribute("orders", vendorService.orders(readScope(session), "ORDERED"));
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/orders";
    }

    /** 발주 확인 이후의 제작 진행 및 출하 현황을 발주 관리 화면과 분리한다. */
    @GetMapping("/shipments")
    public String shipments(@RequestParam(required = false) String status,
            HttpSession session, Model model) {
        String shipmentStatus = normalizeShipmentStatus(status);
        model.addAttribute("orders", vendorService.orders(readScope(session), shipmentStatus));
        model.addAttribute("status", shipmentStatus);
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/shipments";
    }

    /** 잡리스트 SP02의 POST /supplier/orders 발주 확인을 제작 시작 상태로 연결한다. */
    @PostMapping("/orders")
    public String confirmOrder(@RequestParam long procurementId, HttpSession session,
            RedirectAttributes redirect) {
        return start(procurementId, session, redirect);
    }

    @PostMapping("/orders/{procurementId}/start")
    public String start(@PathVariable long procurementId, HttpSession session,
            RedirectAttributes redirect) {
        return execute(redirect, "/vendor/orders",
                () -> vendorService.startProduction(procurementId, requiredVendorId(session)),
                "제작을 시작했습니다.");
    }

    @PostMapping("/orders/{procurementId}/ship")
    public String ship(@PathVariable long procurementId,
            @RequestParam BigDecimal shipmentQty, @RequestParam LocalDate shipmentDate,
            @RequestParam LocalDate expectedArrivalDate, HttpSession session,
            RedirectAttributes redirect) {
        return execute(redirect, "/vendor/shipments",
                () -> vendorService.shipOrder(procurementId, requiredVendorId(session), shipmentQty,
                        shipmentDate, expectedArrivalDate),
                "출하 처리를 완료했습니다.");
    }

    @GetMapping("/orders/{procurementId}/shipment")
    public String shipmentForm(@PathVariable long procurementId, HttpSession session, Model model) {
        model.addAttribute("order", vendorService.order(procurementId, readScope(session)));
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/shipment";
    }

    /** 잡리스트 SP03의 출하 등록 URL을 현재 procurement 상태 변경으로 처리한다. */
    @PostMapping("/orders/{procurementId}/shipment")
    public String saveShipment(@PathVariable long procurementId,
            @RequestParam BigDecimal shipmentQty, @RequestParam LocalDate shipmentDate,
            @RequestParam LocalDate expectedArrivalDate, HttpSession session,
            RedirectAttributes redirect) {
        return ship(procurementId, shipmentQty, shipmentDate, expectedArrivalDate, session, redirect);
    }

    @GetMapping("/inspections")
    public String inspections(HttpSession session, Model model) {
        model.addAttribute("inspections", vendorService.inspections(readScope(session)));
        return "vendor/inspections";
    }

    @GetMapping("/inspections/{procurementId}")
    public String inspectionDetail(@PathVariable long procurementId, HttpSession session, Model model) {
        model.addAttribute("inspection", vendorService.order(procurementId, readScope(session)));
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/inspection-detail";
    }

    @PostMapping("/inspections/{procurementId}")
    public String saveInspectionSupplement(@PathVariable long procurementId,
            @RequestParam String supplement, HttpSession session, RedirectAttributes redirect) {
        return execute(redirect, "/vendor/inspections/" + procurementId,
                () -> vendorService.saveSupplement(procurementId, requiredVendorId(session), supplement),
                "보완 결과를 등록했습니다.");
    }

    @GetMapping("/returns")
    public String returns(HttpSession session, Model model) {
        model.addAttribute("returns", vendorService.returns(readScope(session)));
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/returns";
    }

    @GetMapping("/returns/{procurementId}")
    public String returnDetail(@PathVariable long procurementId, HttpSession session, Model model) {
        model.addAttribute("returnItem", vendorService.order(procurementId, readScope(session)));
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/return-detail";
    }

    @PostMapping("/returns/{procurementId}/supplement")
    public String supplementReturn(@PathVariable long procurementId, @RequestParam String supplement,
            HttpSession session, RedirectAttributes redirect) {
        return execute(redirect, "/vendor/returns/" + procurementId,
                () -> vendorService.saveSupplement(procurementId, requiredVendorId(session), supplement),
                "보완 결과를 저장했습니다. 재출하를 진행해 주세요.");
    }

    @PostMapping("/returns/{procurementId}/reship")
    public String reship(@PathVariable long procurementId, HttpSession session,
            RedirectAttributes redirect) {
        return execute(redirect, "/vendor/returns",
                () -> vendorService.reshipReturn(procurementId, requiredVendorId(session)),
                "보완 완료 및 재출하 처리를 완료했습니다.");
    }

    @GetMapping("/statements")
    public String statements(HttpSession session, Model model) {
        model.addAttribute("statements", vendorService.statements(readScope(session)));
        return "vendor/statements";
    }

    @GetMapping("/orders/{procurementId}/statement")
    public String statementDetail(@PathVariable long procurementId, HttpSession session, Model model) {
        model.addAttribute("statement", vendorService.order(procurementId, readScope(session)));
        model.addAttribute("canProcess", canProcess(session));
        return "vendor/statement";
    }

    @PostMapping("/orders/{procurementId}/statement")
    public String saveStatement(@PathVariable long procurementId, HttpSession session,
            RedirectAttributes redirect) {
        return execute(redirect, "/vendor/orders/" + procurementId + "/statement",
                () -> vendorService.saveStatement(procurementId, requiredVendorId(session)),
                "거래명세서를 등록했습니다.");
    }

    private Long readScope(HttpSession session) {
        LoginUser user = loginUser(session);
        if ("ADMIN".equals(user.getRole())) return null;
        if ("VENDOR".equals(user.getRole()) && user.getVendorId() != null) return user.getVendorId();
        throw new ResponseStatusException(HttpStatus.FORBIDDEN, "협력회사 페이지 접근 권한이 없습니다.");
    }

    private long requiredVendorId(HttpSession session) {
        LoginUser user = loginUser(session);
        if (!"VENDOR".equals(user.getRole()) || user.getVendorId() == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "협력회사 담당자만 처리할 수 있습니다.");
        }
        return user.getVendorId();
    }

    private boolean canProcess(HttpSession session) {
        LoginUser user = loginUser(session);
        return "VENDOR".equals(user.getRole()) && user.getVendorId() != null;
    }

    private String normalizeShipmentStatus(String status) {
        if (status == null || status.isBlank()) return "IN_PROGRESS";
        String normalized = status.trim().toUpperCase();
        return switch (normalized) {
            case "IN_PROGRESS", "SHIPPED", "RECEIVED" -> normalized;
            default -> "IN_PROGRESS";
        };
    }

    private LoginUser loginUser(HttpSession session) {
        Object value = session.getAttribute(LoginUser.SESSION_KEY);
        if (value instanceof LoginUser user) return user;
        throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
    }

    private String execute(RedirectAttributes redirect, String path, Runnable action, String message) {
        try {
            action.run();
            redirect.addFlashAttribute("success", message);
        } catch (RuntimeException exception) {
            redirect.addFlashAttribute("error", exception.getMessage());
        }
        return "redirect:" + path;
    }
}
