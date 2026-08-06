package com.angsamo.erp.material;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.util.HashMap;
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
class MaterialWeek3ReceivingServiceTests {
    @Mock MaterialMapper mapper;
    MaterialService service;

    @BeforeEach void setUp() { service = new MaterialService(mapper); }

    @Test
    void acceptedShipmentUpdatesProcurementInventoryAndMovementInOrder() {
        when(mapper.lockShipment(11L)).thenReturn(shipment("SHIPPED", 5));
        when(mapper.completeReceiving(11L, "ACCEPTED", 5, 0, null)).thenReturn(1);
        when(mapper.adjustInventory(2L, 3L, new BigDecimal("5"))).thenReturn(1);

        service.inspectResult(11L, 5, "ACCEPTED", null, true, true, true, 7L);

        InOrder order = inOrder(mapper);
        order.verify(mapper).completeReceiving(11L, "ACCEPTED", 5, 0, null);
        order.verify(mapper).createInventoryIfAbsent(2L, 3L);
        order.verify(mapper).adjustInventory(2L, 3L, new BigDecimal("5"));
        order.verify(mapper).insertStockMovement(2L, 3L, "IN", new BigDecimal("5"), "PROCUREMENT", 11L, 7L, null);
    }

    @Test
    void returnedShipmentDoesNotIncreaseInventory() {
        when(mapper.lockShipment(11L)).thenReturn(shipment("SHIPPED", 5));
        when(mapper.completeReceiving(11L, "RETURNED", 0, 5, "파손")).thenReturn(1);

        service.inspectResult(11L, 5, "RETURNED", "파손", true, true, true, 7L);

        verify(mapper, never()).adjustInventory(2L, 3L, new BigDecimal("5"));
        verify(mapper, never()).insertStockMovement(2L, 3L, "IN", new BigDecimal("5"), "PROCUREMENT", 11L, 7L, null);
    }

    @Test
    void onlyShippedProcurementCanBeInspected() {
        when(mapper.lockShipment(11L)).thenReturn(shipment("ORDERED", 5));
        assertThrows(IllegalStateException.class,
                () -> service.inspectResult(11L, 5, "ACCEPTED", null, true, true, true, 7L));
    }

    @Test
    void inspectionResultIsRestrictedToAcceptedOrReturned() {
        assertThrows(IllegalArgumentException.class,
                () -> service.inspectResult(11L, 5, "PARTIAL", null, true, true, true, 7L));
    }

    private Map<String, Object> shipment(String status, int qty) {
        Map<String, Object> row = new HashMap<>();
        row.put("procurementStatus", status); row.put("alreadyReceived", 0);
        row.put("shipmentQty", qty); row.put("departmentId", 2L); row.put("itemId", 3L);
        return row;
    }
}
