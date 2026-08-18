package com.angsamo.erp.production.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.production.domain.MaterialRequest;
import com.angsamo.erp.production.domain.ProductionDashboardSummary;
import com.angsamo.erp.production.domain.ProductionPlan;
import com.angsamo.erp.production.mapper.ProductionDashboardMapper;

@Service
@Transactional(readOnly = true)
public class ProductionDashboardService {

    private final ProductionDashboardMapper mapper;

    public ProductionDashboardService(ProductionDashboardMapper mapper) {
        this.mapper = mapper;
    }

    public ProductionDashboardSummary getSummary() { return mapper.findSummary(); }
    public List<ProductionPlan> getRecentPlans() { return mapper.findRecentPlans(); }
    public List<MaterialRequest> getRecentMaterialRequests() { return mapper.findRecentMaterialRequests(); }
}
