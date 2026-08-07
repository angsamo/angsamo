package com.angsamo.erp.material;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.angsamo.erp.material.mapper.MaterialMapper;
import com.angsamo.erp.material.service.MaterialService;

@ExtendWith(MockitoExtension.class)
class MaterialWeek2ServiceTests {
    @Mock MaterialMapper mapper;
    MaterialService service;

    @BeforeEach void setUp() { service = new MaterialService(mapper); }

    @Test
    void approvalUsesCurrentInventoryAndMarksRequestApproved() {
        when(mapper.lockIssue(10L)).thenReturn(issue("REQUESTED", "10", "8"));
        when(mapper.changeIssueStatus(10L, List.of("REQUESTED", "SHORTAGE"), "APPROVED", 7L)).thenReturn(1);
        service.approveIssue(10L, 7L);
        verify(mapper).changeIssueStatus(10L, List.of("REQUESTED", "SHORTAGE"), "APPROVED", 7L);
    }

    @Test
    void approvalMarksShortageWhenInventoryIsNotEnough() {
        when(mapper.lockIssue(10L)).thenReturn(issue("REQUESTED", "3", "10"));
        when(mapper.changeIssueStatus(10L, List.of("REQUESTED", "SHORTAGE"), "SHORTAGE", 7L)).thenReturn(1);
        service.approveIssue(10L, 7L);
        verify(mapper).changeIssueStatus(10L, List.of("REQUESTED", "SHORTAGE"), "SHORTAGE", 7L);
    }

    @Test
    void issueDecreasesInventoryThenRecordsMovementThenCompletesRequest() {
        when(mapper.lockIssue(10L)).thenReturn(issue("APPROVED", "10", "10"));
        when(mapper.decreaseInventory(4L, 3L, new BigDecimal("10"))).thenReturn(1);
        when(mapper.updateIssue(10L, new BigDecimal("10"), "ISSUED", 7L)).thenReturn(1);
        service.processIssue(10L, new BigDecimal("10"), 7L);
        InOrder order = inOrder(mapper);
        order.verify(mapper).decreaseInventory(4L, 3L, new BigDecimal("10"));
        order.verify(mapper).insertStockMovement(4L, 3L, "OUT", new BigDecimal("10"), "MATERIAL_REQUEST", 10L, 7L, null);
        order.verify(mapper).updateIssue(10L, new BigDecimal("10"), "ISSUED", 7L);
    }

    @Test
    void adjustmentRejectsNegativeResultAndRequiresMemo() {
        assertThrows(IllegalArgumentException.class, () -> service.adjustInventory(2L, 3L, BigDecimal.ONE, " ", 7L));
        when(mapper.lockInventory(2L, 3L)).thenReturn(inventory());
        when(mapper.adjustInventory(2L, 3L, new BigDecimal("-20"))).thenReturn(0);
        assertThrows(IllegalStateException.class, () -> service.adjustInventory(2L, 3L, new BigDecimal("-20"), "실사 감소", 7L));
    }

    private Map<String, Object> issue(String status, String available, String requested) {
        Map<String, Object> row = new HashMap<>();
        row.put("status", status); row.put("active", true); row.put("availableQty", new BigDecimal(available));
        row.put("releaseQty", new BigDecimal(requested));
        row.put("departmentId", 2L); // 생산 요청 부서
        row.put("inventoryDepartmentId", 4L); // 연결 조달의 입고 재고 부서
        row.put("itemId", 3L);
        return row;
    }

    private Map<String, Object> inventory() {
        Map<String, Object> row = new HashMap<>(); row.put("active", true); return row;
    }
}
