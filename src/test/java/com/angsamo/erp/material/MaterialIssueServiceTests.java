package com.angsamo.erp.material;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Map;

import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.material.service.MaterialService;

@SpringBootTest
@Transactional
class MaterialIssueServiceTests {
	@Autowired MaterialService service;

	@Test
	void issueProcessingDecreasesInventoryInsideRollbackTransaction() {
		Map<String, Object> request = service.issues(null, null, null, null).stream()
				.filter(row -> !"COMPLETED".equals(row.get("status")))
				.filter(row -> ((Number) row.get("availableQty")).intValue() > 0)
				.findFirst().orElse(null);
		Assumptions.assumeTrue(request != null, "검증 가능한 출고 요청이 없습니다.");
		int before = ((Number) request.get("availableQty")).intValue();
		service.processIssue(((Number) request.get("issueId")).longValue(), 1, 1L);
		Map<String, Object> after = service.inventory().stream()
				.filter(row -> request.get("itemCode").equals(row.get("itemCode"))).findFirst().orElseThrow();
		assertEquals(before - 1, ((Number) after.get("availableQty")).intValue());
	}
}
