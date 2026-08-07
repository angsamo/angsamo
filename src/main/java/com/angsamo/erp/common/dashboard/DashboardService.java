package com.angsamo.erp.common.dashboard;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.development.domain.DevelopmentDashboardSummary;
import com.angsamo.erp.development.service.DevelopmentDashboardService;

@Service
public class DashboardService {
	/** 상태 라벨/색상/파이프라인 순번. stepIndex가 0이면 예외(취소·반려 등) 상태로 취급한다. */
	private record StatusMeta(String label, String colorClass, int stepIndex) {
	}

	private static final Map<String, StatusMeta> PRODUCTION_PLAN_META = Map.of(
			"PLANNED", new StatusMeta("계획중", "gray", 1),
			"IN_PROGRESS", new StatusMeta("진행중", "blue", 2),
			"COMPLETED", new StatusMeta("완료", "green", 3),
			"CANCELLED", new StatusMeta("취소", "red", 0));

	private static final Map<String, StatusMeta> MATERIAL_REQUEST_META = Map.of(
			"REQUESTED", new StatusMeta("요청", "gray", 1),
			"APPROVED", new StatusMeta("승인", "blue", 2),
			"ISSUED", new StatusMeta("불출완료", "green", 3),
			"SHORTAGE", new StatusMeta("부족", "amber", 0),
			"REJECTED", new StatusMeta("반려", "red", 0));

	private static final Map<String, StatusMeta> PROCUREMENT_META = Map.ofEntries(
			Map.entry("REQUESTED", new StatusMeta("요청", "gray", 1)),
			Map.entry("QUOTING", new StatusMeta("견적중", "blue", 2)),
			Map.entry("VENDOR_SELECTED", new StatusMeta("업체선정", "blue", 3)),
			Map.entry("ORDERED", new StatusMeta("발주완료", "violet", 4)),
			Map.entry("IN_PROGRESS", new StatusMeta("제작중", "violet", 5)),
			Map.entry("SHIPPED", new StatusMeta("출하", "violet", 6)),
			Map.entry("RECEIVED", new StatusMeta("입고완료", "green", 7)),
			Map.entry("RETURNED", new StatusMeta("반품", "amber", 0)),
			Map.entry("CANCELLED", new StatusMeta("취소", "red", 0)));

	private static final Map<String, String> MOVEMENT_TYPE_LABELS = Map.of(
			"IN", "입고",
			"OUT", "출고",
			"RETURN", "반품",
			"ADJUST", "조정");

	private static final DateTimeFormatter DATE_LABEL_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	private final DashboardMapper dashboardMapper;
	private final DevelopmentDashboardService developmentDashboardService;

	public DashboardService(DashboardMapper dashboardMapper,
			DevelopmentDashboardService developmentDashboardService) {
		this.dashboardMapper = dashboardMapper;
		this.developmentDashboardService = developmentDashboardService;
	}

	@Transactional(readOnly = true)
	public DashboardSummary getSummary() {
		DashboardSummary summary = new DashboardSummary();

		DevelopmentDashboardSummary development = developmentDashboardService.getSummary();
		summary.setDevelopment(development);
		summary.setDevelopmentItemTypeSegments(developmentItemTypeSegments(development));
		summary.setDevelopmentBomSegments(developmentBomSegments(development));
		summary.setRecentItems(developmentDashboardService.getRecentItems());

		summary.setTotalUsers(dashboardMapper.countUsers());
		summary.setActiveUsers(dashboardMapper.countUsersByActive(true));
		summary.setInactiveUsers(dashboardMapper.countUsersByActive(false));
		summary.setUsersByDepartment(dashboardMapper.findUsersByDepartment());

		List<StatusCount> productionPlanCounts = dashboardMapper.findProductionPlanCountsByStatus();
		summary.setProductionPlanByStatus(productionPlanCounts);
		summary.setProductionPlanSegments(toSegments(productionPlanCounts, PRODUCTION_PLAN_META));
		List<RecentProductionPlan> recentProductionPlans = dashboardMapper.findRecentProductionPlans();
		recentProductionPlans.forEach(p -> {
			p.setStatusLabel(labelOf(PRODUCTION_PLAN_META, p.getStatus()));
			p.setProductionQtyLabel(wholeNumber(p.getProductionQty()));
		});
		summary.setRecentProductionPlans(recentProductionPlans);

		List<StatusCount> materialRequestCounts = dashboardMapper.findMaterialRequestCountsByStatus();
		summary.setMaterialRequestByStatus(materialRequestCounts);
		summary.setMaterialRequestSegments(toSegments(materialRequestCounts, MATERIAL_REQUEST_META));

		List<RecentStockMovement> recentStockMovements = dashboardMapper.findRecentStockMovements();
		recentStockMovements.forEach(m -> {
			m.setMovementTypeLabel(MOVEMENT_TYPE_LABELS.getOrDefault(m.getMovementType(), m.getMovementType()));
			m.setQuantityLabel(wholeNumber(m.getQuantity()));
			m.setCreatedAtLabel(m.getCreatedAt() == null ? null : m.getCreatedAt().format(DATE_LABEL_FORMAT));
		});
		summary.setRecentStockMovements(recentStockMovements);

		List<StatusCount> procurementCounts = dashboardMapper.findProcurementCountsByStatus();
		summary.setProcurementByStatus(procurementCounts);
		summary.setProcurementSegments(toSegments(procurementCounts, PROCUREMENT_META));
		List<RecentProcurement> recentProcurements = dashboardMapper.findRecentProcurements();
		recentProcurements.forEach(p -> {
			p.setStatusLabel(labelOf(PROCUREMENT_META, p.getStatus()));
			p.setRequestQtyLabel(wholeNumber(p.getRequestQty()));
		});
		summary.setRecentProcurements(recentProcurements);

		summary.setPendingQuoteCount(dashboardMapper.countPendingQuotes());
		List<RecentPost> recentPosts = dashboardMapper.findRecentPosts();
		recentPosts.forEach(p -> p.setCreatedAtLabel(p.getCreatedAt() == null ? null : p.getCreatedAt().format(DATE_LABEL_FORMAT)));
		summary.setRecentPosts(recentPosts);
		return summary;
	}

	private String wholeNumber(BigDecimal value) {
		return value == null ? null : value.setScale(0, RoundingMode.HALF_UP).toPlainString();
	}

	private String labelOf(Map<String, StatusMeta> meta, String status) {
		StatusMeta info = meta.get(status);
		return info == null ? status : info.label();
	}

	private List<StatusSegment> toSegments(List<StatusCount> raw, Map<String, StatusMeta> meta) {
		long total = raw.stream().mapToLong(StatusCount::getCount).sum();
		return raw.stream().map(s -> {
			StatusSegment segment = new StatusSegment();
			segment.setStatus(s.getStatus());
			StatusMeta info = meta.getOrDefault(s.getStatus(), new StatusMeta(s.getStatus(), "gray", 0));
			segment.setLabel(info.label());
			segment.setColorClass(info.colorClass());
			segment.setStepIndex(info.stepIndex());
			segment.setExceptionStatus(info.stepIndex() == 0);
			segment.setCount(s.getCount());
			segment.setPercent(total == 0 ? 0 : Math.round(s.getCount() * 1000.0 / total) / 10.0);
			return segment;
		}).toList();
	}

	private List<StatusSegment> developmentItemTypeSegments(DevelopmentDashboardSummary development) {
		long total = development.getTotalItemCount();
		return List.of(
				segment("완제품", "blue", development.getProductCount(), total),
				segment("자재", "violet", development.getMaterialCount(), total));
	}

	private List<StatusSegment> developmentBomSegments(DevelopmentDashboardSummary development) {
		long total = development.getProductCount();
		long withoutBom = development.getProductWithoutBomCount();
		long withBom = Math.max(0, total - withoutBom);
		return List.of(
				segment("BOM 등록", "green", withBom, total),
				segment("BOM 미등록", "red", withoutBom, total));
	}

	private StatusSegment segment(String label, String colorClass, long count, long total) {
		StatusSegment segment = new StatusSegment();
		segment.setLabel(label);
		segment.setColorClass(colorClass);
		segment.setCount(count);
		segment.setPercent(total == 0 ? 0 : Math.round(count * 1000.0 / total) / 10.0);
		return segment;
	}
}
