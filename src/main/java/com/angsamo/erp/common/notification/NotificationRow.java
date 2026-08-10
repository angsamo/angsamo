package com.angsamo.erp.common.notification;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NotificationRow {
	private Long id;
	private String itemName;
	private LocalDateTime occurredAt;
}
