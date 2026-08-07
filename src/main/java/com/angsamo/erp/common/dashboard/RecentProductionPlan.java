package com.angsamo.erp.common.dashboard;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RecentProductionPlan {
	private String itemName;
	private java.math.BigDecimal productionQty;
	private String productionQtyLabel;
	private String status;
	private String statusLabel;
	private LocalDate dueDate;
}
