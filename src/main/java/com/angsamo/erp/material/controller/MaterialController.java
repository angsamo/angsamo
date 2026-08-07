package com.angsamo.erp.material.controller;

import java.math.BigDecimal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.angsamo.erp.material.service.MaterialService;
import com.angsamo.erp.common.session.LoginUser;
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
	@GetMapping("/inventory")
	public String inventory(@RequestParam(required=false) String keyword,
			@RequestParam(required=false) BigDecimal maxQty,
			@RequestParam(required=false) String movementType, Model model) {
		model.addAttribute("inventory", service.inventory(keyword, maxQty));
		model.addAttribute("materials", service.activeMaterials());
		model.addAttribute("movements", service.recentStockMovements(movementType));
		model.addAttribute("keyword", keyword);
		model.addAttribute("maxQty", maxQty);
		model.addAttribute("movementType", movementType);
		return "material/inventory";
	}
	@GetMapping("/issues")
	public String issues(@RequestParam(required=false) String fromDate, @RequestParam(required=false) String toDate,
			@RequestParam(required=false) String itemCode, @RequestParam(required=false) String status, Model model) {
		model.addAttribute("issues", service.issues(fromDate, toDate, itemCode, status));
		model.addAttribute("valueReport", service.inventoryValueReport(fromDate, toDate, itemCode));
		model.addAttribute("fromDate", fromDate); model.addAttribute("toDate", toDate);
		model.addAttribute("itemCode", itemCode); model.addAttribute("status", status);
		return "material/issues";
	}
	@PostMapping("/issues/approve") public String approveIssue(@RequestParam long issueId,
			HttpSession session, RedirectAttributes redirect) {
		return execute(redirect, "/material/issues", () -> service.approveIssue(issueId, userId(session)), "자재 요청의 재고 확인과 승인 처리가 완료되었습니다.");
	}
	@PostMapping("/issues/reject") public String rejectIssue(@RequestParam long issueId,
			HttpSession session, RedirectAttributes redirect) {
		return execute(redirect, "/material/issues", () -> service.rejectIssue(issueId, userId(session)), "자재 요청을 반려했습니다.");
	}
	@PostMapping("/issues/process") public String processIssue(@RequestParam long issueId, @RequestParam BigDecimal qty,
			HttpSession session, RedirectAttributes redirect) {
		return execute(redirect, "/material/issues", () -> service.processIssue(issueId, qty, userId(session)), "자재 출고와 재고 산출이 완료되었습니다.");
	}
	@PostMapping("/inventory/adjust") public String adjustInventory(@RequestParam long departmentId,
			@RequestParam long itemId, @RequestParam BigDecimal adjustmentQty, @RequestParam String memo,
			HttpSession session, RedirectAttributes redirect) {
		return execute(redirect, "/material/inventory",
				() -> service.adjustInventory(departmentId, itemId, adjustmentQty, memo, userId(session)),
				"재고 조정과 변동 이력 저장이 완료되었습니다.");
	}
	@GetMapping("/statements") public String statements(Model model) { model.addAttribute("receivings", service.receivings()); model.addAttribute("statements", service.statements()); return "material/statements"; }
	@GetMapping("/statements/print") public String printStatement(@RequestParam long statementId, Model model) { model.addAttribute("statement", service.statementPrint(statementId)); return "material/statement-print"; }

	@PostMapping("/receivings")
	public String inspect(@RequestParam long shipmentId, @RequestParam int receivedQty,
			@RequestParam String inspectionResult,
			@RequestParam(required=false) String reason,
			@RequestParam(defaultValue="false") boolean orderConfirmed,
			@RequestParam(defaultValue="false") boolean itemChecked,
			@RequestParam(defaultValue="false") boolean qualityChecked,
			HttpSession session, RedirectAttributes redirect) {
		return execute(redirect, "/material/receivings",
				() -> service.inspectResult(shipmentId, receivedQty, inspectionResult, reason,
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

	private long userId(HttpSession session) {
		LoginUser user = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		if (user == null || user.getUserId() == null) throw new IllegalStateException("로그인이 필요합니다.");
		return user.getUserId();
	}
	@PostMapping("/returns")
	public String registerReturn(@RequestParam long returnId, @RequestParam int returnQty,
			@RequestParam String reason, RedirectAttributes redirect) {
		return execute(redirect, "/material/returns",
				() -> service.registerReturn(returnId, returnQty, reason), "반품 요청을 등록했습니다.");
	}
	@PostMapping("/returns/{returnId}/receive")
	public String receiveReturn(@PathVariable long returnId, HttpSession session,
			RedirectAttributes redirect) {
		return execute(redirect, "/material/returns",
				() -> service.receiveReturn(returnId, userId(session)), "재입고 검수와 재고 반영을 완료했습니다.");
	}
	private String execute(RedirectAttributes redirect, String path, Runnable action, String message) {
		try { action.run(); redirect.addFlashAttribute("success", message); }
		catch (RuntimeException e) { redirect.addFlashAttribute("error", e.getMessage()); }
		return "redirect:" + path;
	}
}
