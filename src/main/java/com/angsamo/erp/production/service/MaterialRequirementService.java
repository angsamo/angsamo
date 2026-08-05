package com.angsamo.erp.production.service;

import java.math.BigDecimal;

import org.springframework.stereotype.Service;

@Service
public class MaterialRequirementService {

    private final MaterialRequirementCalculator calculator;

    public MaterialRequirementService(
            MaterialRequirementCalculator calculator
    ) {
        this.calculator = calculator;
    }

    // 총 필요 수량
    public BigDecimal calculateRequiredQty(
            BigDecimal productionQty,
            BigDecimal bomRequiredQty
    ) {

        return calculator.calculateRequiredQty(
                productionQty,
                bomRequiredQty
        );
    }

    // 부족 수량
    public BigDecimal calculateShortageQty(
            BigDecimal requiredQty,
            BigDecimal availableQty
    ) {

        return calculator.calculateShortageQty(
                requiredQty,
                availableQty
        );
    }

    // 실제 불출 가능한 수량
    public BigDecimal calculateIssuableQty(
            BigDecimal requiredQty,
            BigDecimal availableQty
    ) {

        return calculator.calculateIssuableQty(
                requiredQty,
                availableQty
        );
    }

}