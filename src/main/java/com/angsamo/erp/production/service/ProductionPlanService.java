package com.angsamo.erp.production.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.angsamo.erp.production.domain.ProductionPlan;
import com.angsamo.erp.production.mapper.ProductionPlanMapper;

@Service
public class ProductionPlanService {

    private final ProductionPlanMapper productionPlanMapper;

    public ProductionPlanService(ProductionPlanMapper productionPlanMapper) {
        this.productionPlanMapper = productionPlanMapper;
    }

    // 생산계획 목록 조회
    public List<ProductionPlan> findAll() {
        return productionPlanMapper.findAll();
    }

}