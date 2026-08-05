package com.angsamo.erp.development.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;

import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.mapper.ItemMapper;

@Service
public class ItemService {

    private final ItemMapper itemMapper;

    public ItemService(ItemMapper itemMapper) {
        this.itemMapper = itemMapper;
    }

    // 전체 품목 조회
    public List<Item> findAll() {
        return itemMapper.findAll();
    }

    // 품목 식별번호로 상세 조회
    public Item findByItemId(Long itemId) {
        return itemMapper.findByItemId(itemId);
    }

    // 품목 등록
    public Long insert(Item item) {
        normalizeAndValidate(item);

        Item existingItem = itemMapper.findByItemCode(item.getItemCode());

        if (existingItem != null) {
            throw new IllegalArgumentException(
                    "이미 사용 중인 품목코드입니다."
            );
        }

        int insertedCount = itemMapper.insert(item);

        if (insertedCount == 0) {
            throw new IllegalStateException(
                    "품목을 등록하지 못했습니다."
            );
        }

        return item.getItemId();
    }

    // 품목 수정
    public void update(Item item) {
        if (item.getItemId() == null) {
            throw new IllegalArgumentException(
                    "수정할 품목 식별번호가 없습니다."
            );
        }

        Item existingItem = itemMapper.findByItemId(item.getItemId());

        if (existingItem == null) {
            throw new IllegalArgumentException(
                    "수정할 품목을 찾을 수 없습니다."
            );
        }

        // 품목코드는 등록 후 변경하지 않음
        item.setItemCode(existingItem.getItemCode());

        normalizeAndValidate(item);

        int updatedCount = itemMapper.update(item);

        if (updatedCount == 0) {
            throw new IllegalStateException(
                    "품목 정보를 수정하지 못했습니다."
            );
        }
    }

    // 품목 삭제
    public boolean deactivate(Long itemId) {

        Item existingItem = itemMapper.findByItemId(itemId);

        if (existingItem == null) {
            return false;
        }

        if (existingItem.getActive() != null
                && existingItem.getActive() == 0) {

            throw new IllegalStateException(
                    "이미 미사용 처리된 품목입니다."
            );
        }

        return itemMapper.deactivateByItemId(itemId) > 0;
    }

    // 기본값 처리 및 유효성 검사
    private void normalizeAndValidate(Item item) {
        if (item == null) {
            throw new IllegalArgumentException(
                    "품목 정보가 없습니다."
            );
        }

        if (item.getItemCode() == null
                || item.getItemCode().isBlank()) {

            throw new IllegalArgumentException(
                    "품목코드는 필수입니다."
            );
        }

        if (item.getItemName() == null
                || item.getItemName().isBlank()) {

            throw new IllegalArgumentException(
                    "품목명은 필수입니다."
            );
        }

        if (item.getItemType() == null
                || item.getItemType().isBlank()) {

            throw new IllegalArgumentException(
                    "품목 유형은 필수입니다."
            );
        }

        String itemType = item.getItemType().trim().toUpperCase();

        if (!itemType.equals("PRODUCT")
                && !itemType.equals("MATERIAL")) {

            throw new IllegalArgumentException(
                    "품목 유형은 PRODUCT 또는 MATERIAL만 가능합니다."
            );
        }

        item.setItemCode(item.getItemCode().trim());
        item.setItemName(item.getItemName().trim());
        item.setItemType(itemType);

        if (item.getUnit() == null
                || item.getUnit().isBlank()) {

            item.setUnit("EA");
        } else {
            item.setUnit(item.getUnit().trim().toUpperCase());
        }

        if (item.getActive() == null) {
            item.setActive(1);
        }

        if (item.getActive() != 0
                && item.getActive() != 1) {

            throw new IllegalArgumentException(
                    "사용 여부는 1 또는 0이어야 합니다."
            );
        }

        BigDecimal standardPrice = item.getStandardPrice();

        if (standardPrice != null
                && standardPrice.compareTo(BigDecimal.ZERO) < 0) {

            throw new IllegalArgumentException(
                    "기준 단가는 0 이상이어야 합니다."
            );
        }
    }
}