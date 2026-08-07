package com.angsamo.erp.material;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Map;

import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.material.dto.MaterialInventoryItem;
import com.angsamo.erp.material.service.MaterialService;

/** 2주차 불출 구현이 inventory.current_qty까지 함께 변경하는지 계속 검증한다. */
@SpringBootTest
@Transactional
class MaterialIssueServiceTests {
    @Autowired MaterialService service;

    @Test
    void issueProcessingDecreasesInventoryInsideRollbackTransaction() {
        Map<String, Object> request = service.issues(null, null, null, null).stream()
                .filter(row -> "REQUESTED".equals(row.get("status")))
                .filter(row -> ((Number) row.get("availableQty")).intValue() > 0)
                .findFirst().orElse(null);
        Assumptions.assumeTrue(request != null, "검증 가능한 출고 요청이 없습니다.");
        int before = ((Number) request.get("availableQty")).intValue();
        int requestedQty = ((Number) request.get("releaseQty")).intValue();
        service.approveIssue(((Number) request.get("issueId")).longValue(), 1L);
        service.processIssue(((Number) request.get("issueId")).longValue(), requestedQty, 1L);
        MaterialInventoryItem after = service.inventory().stream()
                .filter(row -> request.get("itemCode").equals(row.getItemCode()))
                .filter(row -> ((Number) request.get("inventoryDepartmentId")).longValue()
                        == row.getDepartmentId())
                .findFirst().orElseThrow();
        assertEquals(before - requestedQty, after.getCurrentQty().intValue());
    }
}
