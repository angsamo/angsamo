package com.angsamo.erp.production.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.development.domain.Bom;
import com.angsamo.erp.development.mapper.BomMapper;
import com.angsamo.erp.production.domain.MaterialRequest;
import com.angsamo.erp.production.domain.ProductionPlan;
import com.angsamo.erp.production.mapper.MaterialRequestMapper;
import com.angsamo.erp.production.mapper.ProductionPlanMapper;

class MaterialRequestServiceTests {

    private final MaterialRequestMapper materialRequestMapper =
            mock(MaterialRequestMapper.class);
    private final ProductionPlanMapper productionPlanMapper =
            mock(ProductionPlanMapper.class);
    private final BomMapper bomMapper = mock(BomMapper.class);
    private final MaterialRequestService service = new MaterialRequestService(
            materialRequestMapper,
            productionPlanMapper,
            bomMapper
    );

    @Test
    void createsRequestUsingProductionQuantityTimesBomQuantity() {
        ProductionPlan plan = productionPlan();
        Bom bom = bom(20L, "2.5");
        when(productionPlanMapper.findById(10L)).thenReturn(plan);
        when(bomMapper.findByParentItemId(5L)).thenReturn(List.of(bom));
        when(materialRequestMapper.insert(org.mockito.ArgumentMatchers.any()))
                .thenReturn(1);

        int createdCount = service.createFromProductionPlan(
                10L,
                productionUser()
        );

        ArgumentCaptor<MaterialRequest> captor =
                ArgumentCaptor.forClass(MaterialRequest.class);
        verify(materialRequestMapper).insert(captor.capture());
        MaterialRequest request = captor.getValue();

        assertEquals(1, createdCount);
        assertEquals(0, new BigDecimal("25.0").compareTo(request.getRequestQty()));
        assertEquals("REQUESTED", request.getStatus());
        assertEquals(plan.getDueDate(), request.getRequiredDate());
    }

    @Test
    void skipsDuplicateMaterialRequest() {
        when(productionPlanMapper.findById(10L)).thenReturn(productionPlan());
        when(bomMapper.findByParentItemId(5L))
                .thenReturn(List.of(bom(20L, "2.5")));
        when(materialRequestMapper.countByProductionPlanIdAndItemId(10L, 20L))
                .thenReturn(1);

        assertThrows(
                IllegalStateException.class,
                () -> service.createFromProductionPlan(10L, productionUser())
        );
    }

    @Test
    void rejectsAnotherDepartment() {
        when(productionPlanMapper.findById(10L)).thenReturn(productionPlan());

        LoginUser anotherProductionUser = new LoginUser(
                4L,
                "other_production",
                "다른 생산부서 사용자",
                "MEMBER",
                99L,
                "PRODUCTION",
                null
        );

        assertThrows(
                IllegalStateException.class,
                () -> service.createFromProductionPlan(
                        10L,
                        anotherProductionUser
                )
        );
    }

    @Test
    void updatesRequestedMaterialRequest() {
        MaterialRequest existing = materialRequest("REQUESTED");
        when(materialRequestMapper.findById(1L)).thenReturn(existing);
        when(materialRequestMapper.updateRequested(
                org.mockito.ArgumentMatchers.any()
        )).thenReturn(1);

        MaterialRequest changes = new MaterialRequest();
        changes.setRequestId(1L);
        changes.setRequestQty(new BigDecimal("20"));
        changes.setRequiredDate(LocalDate.of(2026, 8, 25));

        service.updateRequested(changes, productionUser());

        verify(materialRequestMapper).updateRequested(changes);
    }

    @Test
    void rejectsEditingIssuedMaterialRequest() {
        when(materialRequestMapper.findById(1L))
                .thenReturn(materialRequest("ISSUED"));

        MaterialRequest changes = new MaterialRequest();
        changes.setRequestId(1L);
        changes.setRequestQty(BigDecimal.TEN);
        changes.setRequiredDate(LocalDate.of(2026, 8, 25));

        assertThrows(
                IllegalStateException.class,
                () -> service.updateRequested(changes, productionUser())
        );
    }

    @Test
    void cancelsRequestedMaterialRequest() {
        when(materialRequestMapper.findById(1L))
                .thenReturn(materialRequest("REQUESTED"));
        when(materialRequestMapper.cancelRequested(1L)).thenReturn(1);

        service.cancelRequested(1L, productionUser());

        verify(materialRequestMapper).cancelRequested(1L);
    }

    private ProductionPlan productionPlan() {
        ProductionPlan plan = new ProductionPlan();
        plan.setProductionPlanId(10L);
        plan.setDepartmentId(2L);
        plan.setItemId(5L);
        plan.setProductionQty(BigDecimal.TEN);
        plan.setDueDate(LocalDate.of(2026, 8, 31));
        return plan;
    }

    private Bom bom(Long componentItemId, String requiredQty) {
        Bom bom = new Bom();
        bom.setComponentItemId(componentItemId);
        bom.setRequiredQty(new BigDecimal(requiredQty));
        return bom;
    }

    private MaterialRequest materialRequest(String status) {
        MaterialRequest request = new MaterialRequest();
        request.setRequestId(1L);
        request.setDepartmentId(2L);
        request.setStatus(status);
        return request;
    }

    private LoginUser productionUser() {
        return new LoginUser(
                3L,
                "production_test",
                "생산부서 테스트",
                "MEMBER",
                2L,
                "PRODUCTION",
                null
        );
    }
}
