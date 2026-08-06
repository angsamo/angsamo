package com.angsamo.erp.material;

import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.angsamo.erp.material.dto.MaterialInventoryItem;
import com.angsamo.erp.material.dto.StockMovementItem;
import com.angsamo.erp.material.mapper.MaterialMapper;
import com.angsamo.erp.material.service.MaterialService;

/** 1주차 재고와 입출고 이력이 전용 Mapper 조회 결과를 그대로 제공하는지 검증한다. */
@ExtendWith(MockitoExtension.class)
class MaterialInventoryServiceTests {
    @Mock private MaterialMapper mapper;
    private MaterialService service;

    @BeforeEach
    void setUp() {
        service = new MaterialService(mapper);
    }

    @Test
    void inventoryUsesInventoryTableQuery() {
        List<MaterialInventoryItem> expected = List.of(new MaterialInventoryItem());
        when(mapper.findInventory(null, null)).thenReturn(expected);

        assertSame(expected, service.inventory());
        verify(mapper).findInventory(null, null);
    }

    @Test
    void recentMovementsUseStockMovementQuery() {
        List<StockMovementItem> expected = List.of(new StockMovementItem());
        when(mapper.findRecentStockMovements(null)).thenReturn(expected);

        assertSame(expected, service.recentStockMovements());
        verify(mapper).findRecentStockMovements(null);
    }

    @Test
    void inventorySearchAndMovementTypeArePassedToMapper() {
        when(mapper.findInventory("볼트", new java.math.BigDecimal("10"))).thenReturn(List.of());
        when(mapper.findRecentStockMovements("OUT")).thenReturn(List.of());
        service.inventory(" 볼트 ", new java.math.BigDecimal("10"));
        service.recentStockMovements("out");
        verify(mapper).findInventory("볼트", new java.math.BigDecimal("10"));
        verify(mapper).findRecentStockMovements("OUT");
    }
}
