package com.angsamo.erp.production.service;

import java.math.BigDecimal;

import org.springframework.stereotype.Component;

@Component
public class MaterialRequirementCalculator {

    /**
     * 총 필요 수량 = 생산 수량 × BOM 필요 수량
     */
    public BigDecimal calculateRequiredQty(
            BigDecimal productionQty,
            BigDecimal bomRequiredQty
    ) {
        validateNonNegative(productionQty, "생산 수량");
        validateNonNegative(bomRequiredQty, "BOM 필요 수량");

        return productionQty.multiply(bomRequiredQty);
    }

    /**
     * 부족 수량 = 총 필요 수량 - 사용 가능 재고
     * 계산 결과가 음수이면 0으로 처리한다.
     */
    public BigDecimal calculateShortageQty(
            BigDecimal requiredQty,
            BigDecimal availableQty
    ) {
        validateNonNegative(requiredQty, "총 필요 수량");

        BigDecimal safeAvailableQty =
                availableQty == null
                        ? BigDecimal.ZERO
                        : availableQty;

        validateNonNegative(safeAvailableQty, "사용 가능 재고");

        BigDecimal shortageQty =
                requiredQty.subtract(safeAvailableQty);

        return shortageQty.max(BigDecimal.ZERO);
    }

    /**
     * 재고에서 바로 불출 요청할 수 있는 수량
     * = 총 필요 수량과 사용 가능 재고 중 작은 값
     */
    public BigDecimal calculateIssuableQty(
            BigDecimal requiredQty,
            BigDecimal availableQty
    ) {
        validateNonNegative(requiredQty, "총 필요 수량");

        BigDecimal safeAvailableQty =
                availableQty == null
                        ? BigDecimal.ZERO
                        : availableQty;

        validateNonNegative(safeAvailableQty, "사용 가능 재고");

        return requiredQty.min(safeAvailableQty);
    }

    private void validateNonNegative(
            BigDecimal value,
            String fieldName
    ) {
        if (value == null) {
            throw new IllegalArgumentException(
                    fieldName + "이(가) 없습니다."
            );
        }

        if (value.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(
                    fieldName + "은(는) 0보다 작을 수 없습니다."
            );
        }
    }
}