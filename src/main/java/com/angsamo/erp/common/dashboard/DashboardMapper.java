package com.angsamo.erp.common.dashboard;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DashboardMapper {
	long countUsers();
	long countUsersByActive(boolean active);
	List<DepartmentUserCount> findUsersByDepartment();
	List<StatusCount> findProductionPlanCountsByStatus();
	List<RecentProductionPlan> findRecentProductionPlans();
	List<StatusCount> findMaterialRequestCountsByStatus();
	List<RecentStockMovement> findRecentStockMovements();
	List<StatusCount> findProcurementCountsByStatus();
	List<RecentProcurement> findRecentProcurements();
	long countPendingQuotes();
	List<RecentPost> findRecentPosts();
}
