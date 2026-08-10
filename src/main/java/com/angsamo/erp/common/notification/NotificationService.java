package com.angsamo.erp.common.notification;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.common.session.LoginUser;

@Service
public class NotificationService {
	private static final int WINDOW_HOURS = 24;
	private static final int MAX_ITEMS = 10;
	private static final DateTimeFormatter TIME_LABEL_FORMAT = DateTimeFormatter.ofPattern("MM-dd HH:mm");

	private final NotificationMapper notificationMapper;

	public NotificationService(NotificationMapper notificationMapper) {
		this.notificationMapper = notificationMapper;
	}

	@Transactional(readOnly = true)
	public List<NotificationItem> getNotifications(LoginUser loginUser) {
		List<NotificationItem> items = new ArrayList<>();
		String role = loginUser.getRole();
		String departmentCode = loginUser.getDepartmentCode();
		boolean isAdmin = "ADMIN".equals(role);

		if (isAdmin || "MATERIAL".equals(departmentCode)) {
			add(items, notificationMapper.findRequestedMaterialRequests(WINDOW_HOURS),
					"자재요청 승인 대기", "/material/issues");
			add(items, notificationMapper.findShippedProcurements(WINDOW_HOURS),
					"입고검사 대기", "/material/receivings");
		}

		if (isAdmin || "PURCHASE".equals(departmentCode)) {
			add(items, notificationMapper.findShortageMaterialRequests(WINDOW_HOURS),
					"부족 자재 조달 필요", "/purchase/shortages");
			add(items, notificationMapper.findSubmittedQuotes(WINDOW_HOURS),
					"협력업체 견적 제출됨", "/purchase/quotes");
		}

		if (isAdmin || "PRODUCTION".equals(departmentCode)) {
			add(items, notificationMapper.findIssuedMaterialRequests(loginUser.getDepartmentId(), WINDOW_HOURS),
					"자재 불출 완료", "/production/material-requests");
		}

		if ("VENDOR".equals(role) && loginUser.getVendorId() != null) {
			add(items, notificationMapper.findVendorQuoteRequests(loginUser.getVendorId(), WINDOW_HOURS),
					"신규 견적 요청", "/vendor/quotes");
			add(items, notificationMapper.findVendorOrders(loginUser.getVendorId(), WINDOW_HOURS),
					"발주 확정, 제작 시작 필요", "/vendor/orders");
		}

		return items.stream()
				.sorted(Comparator.comparing(NotificationItem::getOccurredAt).reversed())
				.limit(MAX_ITEMS)
				.toList();
	}

	private void add(List<NotificationItem> items, List<NotificationRow> rows, String label, String link) {
		for (NotificationRow row : rows) {
			NotificationItem item = new NotificationItem();
			item.setMessage(label + " · " + row.getItemName());
			item.setLink(link);
			item.setOccurredAt(row.getOccurredAt());
			item.setOccurredAtLabel(row.getOccurredAt() == null ? null : row.getOccurredAt().format(TIME_LABEL_FORMAT));
			items.add(item);
		}
	}
}
