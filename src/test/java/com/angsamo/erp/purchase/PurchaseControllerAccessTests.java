package com.angsamo.erp.purchase;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.purchase.controller.PurchaseController;
import com.angsamo.erp.purchase.service.PurchaseService;

@ExtendWith(MockitoExtension.class)
class PurchaseControllerAccessTests {

    @Mock
    private PurchaseService purchaseService;

    private PurchaseController controller;

    @BeforeEach
    void setUp() {
        controller = new PurchaseController(purchaseService);
    }

    @Test
    void guestCannotAccessPurchaseVendorList() {
        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> controller.vendorList(
                        null, null, new ExtendedModelMap(), new MockHttpSession()));

        assertEquals(401, exception.getStatusCode().value());
    }

    @Test
    void otherDepartmentMemberCannotAccessPurchaseVendorList() {
        MockHttpSession session = session(
                new LoginUser(1L, "production", "생산 담당자", "MEMBER",
                        2L, "PRODUCTION", null));

        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> controller.vendorList(
                        null, null, new ExtendedModelMap(), session));

        assertEquals(403, exception.getStatusCode().value());
    }

    @Test
    void vendorAccountCannotAccessPurchaseVendorList() {
        MockHttpSession session = session(
                new LoginUser(2L, "vendor", "업체 담당자", "VENDOR",
                        null, null, 10L));

        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> controller.vendorList(
                        null, null, new ExtendedModelMap(), session));

        assertEquals(403, exception.getStatusCode().value());
    }

    @Test
    void purchaseMemberCanAccessPurchaseVendorList() {
        MockHttpSession session = session(
                new LoginUser(3L, "purchase", "구매 담당자", "MEMBER",
                        4L, "PURCHASE", null));

        String view = controller.vendorList(
                "업체", true, new ExtendedModelMap(), session);

        assertEquals("purchase/list", view);
        verify(purchaseService).getVendors("업체", true);
    }

    @Test
    void administratorCanAccessPurchaseVendorList() {
        MockHttpSession session = session(
                new LoginUser(4L, "admin", "관리자", "ADMIN",
                        null, null, null));

        String view = controller.vendorList(
                null, null, new ExtendedModelMap(), session);

        assertEquals("purchase/list", view);
        verify(purchaseService).getVendors(null, null);
    }

    private MockHttpSession session(LoginUser user) {
        MockHttpSession session = new MockHttpSession();
        session.setAttribute(LoginUser.SESSION_KEY, user);
        return session;
    }
}
