package com.angsamo.erp.purchase.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.purchase.dto.ProcurementDetail;
import com.angsamo.erp.purchase.dto.VendorDetail;
import com.angsamo.erp.purchase.service.PurchaseService;

@Controller
public class PurchaseController {

    private final PurchaseService purchaseService;

    public PurchaseController(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }

    @GetMapping("/purchase/vendors")
    public String vendorList(Model model) {
        model.addAttribute("vendors", purchaseService.getVendors());

        return "purchase/list";
    }

    @GetMapping("/purchase/vendors/{vendorId}")
    public String vendorDetail(@PathVariable Long vendorId, Model model) {
        VendorDetail vendor = purchaseService.getVendor(vendorId);

        if (vendor == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "협력업체를 찾을 수 없습니다.");
        }

        model.addAttribute("vendor", vendor);
        return "purchase/detail";
    }

    @GetMapping("/purchase/shortages")
    public String shortageMaterialRequestList(Model model) {
        model.addAttribute("shortages", purchaseService.getShortageMaterialRequests());
        return "purchase/shortages";
    }

    @GetMapping("/purchase/procurements")
    public String procurementList(Model model) {
        model.addAttribute("procurements", purchaseService.getProcurements());
        return "purchase/procurements";
    }

    @GetMapping("/purchase/procurements/{procurementId}")
    public String procurementDetail(@PathVariable Long procurementId, Model model) {
        ProcurementDetail procurement = purchaseService.getProcurement(procurementId);

        if (procurement == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "조달업무를 찾을 수 없습니다.");
        }

        model.addAttribute("procurement", procurement);
        return "purchase/procurement-detail";
    }

    @GetMapping("/purchase/quotes")
    public String vendorQuoteList(Model model) {
        model.addAttribute("quotes", purchaseService.getVendorQuotes());
        return "purchase/quotes";
    }
}
