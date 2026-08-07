package com.angsamo.erp.production.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.util.List;

import org.junit.jupiter.api.Test;

import com.angsamo.erp.production.domain.MaterialRequirement;
import com.angsamo.erp.production.mapper.MaterialRequirementMapper;

class MaterialRequirementServiceTests {

    @Test
    void calculatesRequiredAndShortageQuantities() {
        MaterialRequirementMapper mapper = mock(MaterialRequirementMapper.class);
        MaterialRequirement requirement = new MaterialRequirement();
        requirement.setProductionQty(new BigDecimal("10"));
        requirement.setBomRequiredQty(new BigDecimal("2.500"));
        requirement.setAvailableQty(new BigDecimal("8"));
        when(mapper.findAll()).thenReturn(List.of(requirement));

        MaterialRequirementService service = new MaterialRequirementService(
                mapper,
                new MaterialRequirementCalculator()
        );

        MaterialRequirement result = service.findAll().getFirst();

        assertEquals(0, new BigDecimal("25.000").compareTo(result.getRequiredQty()));
        assertEquals(0, new BigDecimal("17.000").compareTo(result.getShortageQty()));
        assertEquals(false, result.isStockSufficient());
        assertEquals(true, result.isShortage());
    }

    @Test
    void marksStockAsSufficientWhenShortageIsZero() {
        MaterialRequirementMapper mapper = mock(MaterialRequirementMapper.class);
        MaterialRequirement requirement = new MaterialRequirement();
        requirement.setProductionQty(BigDecimal.TEN);
        requirement.setBomRequiredQty(new BigDecimal("2.5"));
        requirement.setAvailableQty(new BigDecimal("25"));
        when(mapper.findAll()).thenReturn(List.of(requirement));

        MaterialRequirementService service = new MaterialRequirementService(
                mapper,
                new MaterialRequirementCalculator()
        );

        MaterialRequirement result = service.findAll().getFirst();

        assertEquals(true, result.isStockSufficient());
        assertEquals(false, result.isShortage());
    }
}
