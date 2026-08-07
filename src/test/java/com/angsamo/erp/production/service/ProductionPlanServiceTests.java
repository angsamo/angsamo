package com.angsamo.erp.production.service;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.junit.jupiter.api.Test;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.development.mapper.ItemMapper;
import com.angsamo.erp.production.domain.ProductionPlan;
import com.angsamo.erp.production.domain.MaterialRequest;
import com.angsamo.erp.production.mapper.MaterialRequestMapper;
import com.angsamo.erp.production.mapper.ProductionPlanMapper;

class ProductionPlanServiceTests {

    private final ProductionPlanMapper productionPlanMapper =
            mock(ProductionPlanMapper.class);
    private final MaterialRequestMapper materialRequestMapper =
            mock(MaterialRequestMapper.class);
    private final ProductionPlanService service = new ProductionPlanService(
            productionPlanMapper,
            mock(ItemMapper.class),
            materialRequestMapper
    );

    @Test
    void updatesCancelledStatusUsingDatabaseCode() {
        ProductionPlan plan = productionPlan(10L, 2L);
        when(productionPlanMapper.findById(10L)).thenReturn(plan);
        when(productionPlanMapper.updateStatus(10L, "CANCELLED")).thenReturn(1);

        service.updateStatus(10L, "cancelled", productionUser(2L));

        verify(productionPlanMapper).updateStatus(10L, "CANCELLED");
    }

    @Test
    void rejectsMisspelledCanceledStatus() {
        when(productionPlanMapper.findById(10L))
                .thenReturn(productionPlan(10L, 2L));

        assertThrows(
                IllegalArgumentException.class,
                () -> service.updateStatus(
                        10L,
                        "CANCELED",
                        productionUser(2L)
                )
        );
    }

    @Test
    void rejectsZeroProductionQuantity() {
        ProductionPlan plan = validNewPlan();
        plan.setProductionQty(BigDecimal.ZERO);

        assertThrows(
                IllegalArgumentException.class,
                () -> service.insert(plan, productionUser(2L))
        );
    }

    @Test
    void rejectsStartDateAfterDueDate() {
        ProductionPlan plan = validNewPlan();
        plan.setStartDate(LocalDate.of(2026, 8, 31));
        plan.setDueDate(LocalDate.of(2026, 8, 10));

        assertThrows(
                IllegalArgumentException.class,
                () -> service.insert(plan, productionUser(2L))
        );
    }

    @Test
    void rejectsCompletionWhileMaterialRequestIsPending() {
        when(productionPlanMapper.findById(10L))
                .thenReturn(productionPlan(10L, 2L));
        when(materialRequestMapper.findByProductionPlanId(10L))
                .thenReturn(java.util.List.of(materialRequest("REQUESTED")));

        assertThrows(
                IllegalStateException.class,
                () -> service.updateStatus(
                        10L,
                        "COMPLETED",
                        productionUser(2L)
                )
        );
    }

    @Test
    void completesWhenAllMaterialRequestsAreIssued() {
        when(productionPlanMapper.findById(10L))
                .thenReturn(productionPlan(10L, 2L));
        when(materialRequestMapper.findByProductionPlanId(10L))
                .thenReturn(java.util.List.of(materialRequest("ISSUED")));
        when(productionPlanMapper.updateStatus(10L, "COMPLETED"))
                .thenReturn(1);

        service.updateStatus(10L, "COMPLETED", productionUser(2L));

        verify(productionPlanMapper).updateStatus(10L, "COMPLETED");
    }

    private ProductionPlan productionPlan(Long planId, Long departmentId) {
        ProductionPlan plan = new ProductionPlan();
        plan.setProductionPlanId(planId);
        plan.setDepartmentId(departmentId);
        return plan;
    }

    private ProductionPlan validNewPlan() {
        ProductionPlan plan = new ProductionPlan();
        plan.setItemId(5L);
        plan.setProductionQty(BigDecimal.TEN);
        plan.setStartDate(LocalDate.of(2026, 8, 10));
        plan.setDueDate(LocalDate.of(2026, 8, 31));
        return plan;
    }

    private MaterialRequest materialRequest(String status) {
        MaterialRequest request = new MaterialRequest();
        request.setStatus(status);
        return request;
    }

    private LoginUser productionUser(Long departmentId) {
        return new LoginUser(
                3L,
                "production_test",
                "생산부서 테스트",
                "MEMBER",
                departmentId,
                "PRODUCTION",
                null
        );
    }
}
