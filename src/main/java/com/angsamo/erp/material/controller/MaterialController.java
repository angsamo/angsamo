package com.angsamo.erp.material.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.material.service.MaterialService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/material")
public class MaterialController {
	private final MaterialService service;
	public MaterialController(MaterialService service) { this.service = service; }

	@GetMapping public String dashboard(Model model) { model.addAttribute("orders", service.purchaseOrders()); return "material/dashboard"; }
	@GetMapping("/receivings")
	public String receivings(@RequestParam(required=false) String fromDate,
			@RequestParam(required=false) String toDate, @RequestParam(required=false) String status,
			@RequestParam(required=false) String keyword, Model model) {
		model.addAttribute("pending", service.pendingShipments());
		model.addAttribute("receivings", service.receivings());
		model.addAttribute("orderReport", service.orderReport(fromDate, toDate, status, keyword));
		model.addAttribute("closeReadyOrders", service.closeReadyOrders());
		model.addAttribute("fromDate", fromDate); model.addAttribute("toDate", toDate);
		model.addAttribute("status", status); model.addAttribute("keyword", keyword);
		return "material/receivings";
	}
	@GetMapping("/returns") public String returns(Model model) { model.addAttribute("returns", service.returns()); return "material/returns"; }
	@GetMapping("/inventory") public String inventory(Model model) { model.addAttribute("inventory", service.inventory()); return "material/inventory"; }
	@GetMapping("/issues")
	public String issues(@RequestParam(required=false) String fromDate, @RequestParam(required=false) String toDate,
			@RequestParam(required=false) String itemCode, @RequestParam(required=false) String status, Model model) {
		model.addAttribute("issues", service.issues(fromDate, toDate, itemCode, status));
		model.addAttribute("valueReport", service.inventoryValueReport(fromDate, toDate, itemCode));
		model.addAttribute("fromDate", fromDate); model.addAttribute("toDate", toDate);
		model.addAttribute("itemCode", itemCode); model.addAttribute("status", status);
		return "material/issues";
	}
	@PostMapping("/issues/process") public String processIssue(@RequestParam long issueId, @RequestParam int qty,
			HttpSession session, RedirectAttributes redirect) {
		return execute(redirect, "/material/issues", () -> service.processIssue(issueId, qty, userId(session)), "자재 출고와 재고 산출이 완료되었습니다.");
	}
	@GetMapping("/statements") public String statements(Model model) { model.addAttribute("receivings", service.receivings()); model.addAttribute("statements", service.statements()); return "material/statements"; }
	@GetMapping("/statements/print") public String printStatement(@RequestParam long statementId, Model model) { model.addAttribute("statement", service.statementPrint(statementId)); return "material/statement-print"; }

	@PostMapping("/receivings")
	public String inspect(@RequestParam long shipmentId, @RequestParam int acceptedQty, @RequestParam int rejectedQty,
			@RequestParam(required=false) String reason,
			@RequestParam(defaultValue="false") boolean orderConfirmed,
			@RequestParam(defaultValue="false") boolean itemChecked,
			@RequestParam(defaultValue="false") boolean qualityChecked,
			HttpSession session, RedirectAttributes redirect) {
		return execute(redirect, "/material/receivings",
				() -> service.inspect(shipmentId, acceptedQty, rejectedQty, reason,
						orderConfirmed, itemChecked, qualityChecked, userId(session)),
				"입고 검수와 입고 마감 처리가 완료되었습니다.");
	}
	@PostMapping("/returns/status") public String returnStatus(@RequestParam long returnId, @RequestParam String status, RedirectAttributes redirect) {
		return execute(redirect, "/material/returns", () -> service.changeReturnStatus(returnId, status), "반품 상태가 변경되었습니다.");
	}
	@PostMapping("/statements") public String issueStatement(@RequestParam long receivingId, RedirectAttributes redirect) {
		return execute(redirect, "/material/statements", () -> service.issueStatement(receivingId), "거래명세서가 발행되었습니다.");
	}
	@PostMapping("/statements/notify") public String notifyStatement(@RequestParam long statementId, RedirectAttributes redirect) {
		return execute(redirect, "/material/statements", () -> service.notifyStatement(statementId), "협력회사 통보가 완료되었습니다.");
	}
	@PostMapping("/orders/close") public String closeOrder(@RequestParam long poId, RedirectAttributes redirect) {
		return execute(redirect, "/material", () -> service.closeOrder(poId), "구매 발주가 마감되었습니다.");
	}
	@PostMapping("/receivings/orders/close") public String closeOrderFromReceiving(@RequestParam long poId, RedirectAttributes redirect) {
		return execute(redirect, "/material/receivings", () -> service.closeOrder(poId), "구매부서 확인 및 발주 마감이 완료되었습니다.");
	}

	private long userId(HttpSession session) { Object id = session.getAttribute("loginUserId"); return id instanceof Number n ? n.longValue() : 1L; }
	private String execute(RedirectAttributes redirect, String path, Runnable action, String message) {
		try { action.run(); redirect.addFlashAttribute("success", message); }
		catch (RuntimeException e) { redirect.addFlashAttribute("error", e.getMessage()); }
		return "redirect:" + path;
	}
}
