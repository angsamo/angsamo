package com.angsamo.erp.common.dashboard;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RecentStockMovement {
	private String itemName;
	private String movementType;
	private String movementTypeLabel;
	private java.math.BigDecimal quantity;
	private String quantityLabel;
	private LocalDateTime createdAt;
	private String createdAtLabel;
}
