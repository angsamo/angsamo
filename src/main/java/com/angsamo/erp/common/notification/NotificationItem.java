package com.angsamo.erp.common.notification;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NotificationItem {
	private String message;
	private String link;
	private LocalDateTime occurredAt;
	private String occurredAtLabel;
}
