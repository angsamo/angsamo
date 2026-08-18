package com.angsamo.erp.production.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.angsamo.erp.production.domain.MaterialRequest;
import com.angsamo.erp.production.domain.ProductionDashboardSummary;
import com.angsamo.erp.production.domain.ProductionPlan;

@Mapper
public interface ProductionDashboardMapper {

    ProductionDashboardSummary findSummary();

    List<ProductionPlan> findRecentPlans();

    List<MaterialRequest> findRecentMaterialRequests();
}
