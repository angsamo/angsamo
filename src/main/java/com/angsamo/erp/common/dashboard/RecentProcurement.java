package com.angsamo.erp.common.dashboard;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RecentProcurement {
	private String itemName;
	private java.math.BigDecimal requestQty;
	private String requestQtyLabel;
	private String status;
	private String statusLabel;
	private LocalDate requiredDate;
}
