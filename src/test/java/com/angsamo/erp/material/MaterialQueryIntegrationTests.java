package com.angsamo.erp.material;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.material.service.MaterialService;

/** 자재 화면에서 사용하는 주요 조회 SQL이 현재 DB 구조와 호환되는지 검증한다. */
@SpringBootTest
@Transactional(readOnly = true)
class MaterialQueryIntegrationTests {
    @Autowired MaterialService service;

    @Test
    void materialDashboardQueriesRunAgainstCurrentDatabase() {
        assertNotNull(service.pendingShipments());
        assertNotNull(service.receivings());
        assertNotNull(service.inventoryValueReport(null, null, null));
        assertNotNull(service.statements());
    }
}
