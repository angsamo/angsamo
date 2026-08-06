package com.angsamo.erp.common.web;

import org.springframework.boot.webmvc.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CustomErrorController implements ErrorController {

	@RequestMapping("/error")
	public String handleError(HttpServletRequest request, Model model) {
		Object statusAttribute = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
		int status = statusAttribute == null ? 500 : Integer.parseInt(statusAttribute.toString());
		model.addAttribute("status", status);

		if (status == 403) return "error/403";
		if (status == 404) return "error/404";
		return "error/error";
	}
}
