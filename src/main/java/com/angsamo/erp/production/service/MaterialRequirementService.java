package com.angsamo.erp.production.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;

import com.angsamo.erp.production.domain.MaterialRequirement;
import com.angsamo.erp.production.mapper.MaterialRequirementMapper;

@Service
public class MaterialRequirementService {

    private final MaterialRequirementMapper mapper;
    private final MaterialRequirementCalculator calculator;

    public MaterialRequirementService(
            MaterialRequirementMapper mapper,
            MaterialRequirementCalculator calculator
    ) {
        this.mapper = mapper;
        this.calculator = calculator;
    }

    public List<MaterialRequirement> findAll() {
        List<MaterialRequirement> requirements = mapper.findAll();

        for (MaterialRequirement requirement : requirements) {
            BigDecimal requiredQty = calculateRequiredQty(
                    requirement.getProductionQty(),
                    requirement.getBomRequiredQty()
            );

            requirement.setRequiredQty(requiredQty);
            requirement.setShortageQty(calculateShortageQty(
                    requiredQty,
                    requirement.getAvailableQty()
            ));
        }

        return requirements;
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
