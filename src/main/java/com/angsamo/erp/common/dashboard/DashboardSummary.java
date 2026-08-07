package com.angsamo.erp.common.dashboard;

import java.util.List;

import com.angsamo.erp.development.domain.DevelopmentDashboardSummary;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DashboardSummary {
	private DevelopmentDashboardSummary development;
	private List<StatusSegment> developmentItemTypeSegments;
	private List<StatusSegment> developmentBomSegments;
	private List<com.angsamo.erp.development.domain.Item> recentItems;
	private long totalUsers;
	private long activeUsers;
	private long inactiveUsers;
	private List<DepartmentUserCount> usersByDepartment;

	private List<StatusCount> productionPlanByStatus;
	private List<StatusSegment> productionPlanSegments;
	private List<RecentProductionPlan> recentProductionPlans;
	private List<StatusCount> materialRequestByStatus;
	private List<StatusSegment> materialRequestSegments;
	private List<RecentStockMovement> recentStockMovements;
	private List<StatusCount> procurementByStatus;
	private List<StatusSegment> procurementSegments;
	private List<RecentProcurement> recentProcurements;
	private long pendingQuoteCount;
	private List<RecentPost> recentPosts;
}
