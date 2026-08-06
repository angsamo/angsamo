package com.angsamo.erp.development.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;

import com.angsamo.erp.development.domain.Bom;
import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.mapper.BomMapper;
import com.angsamo.erp.development.mapper.ItemMapper;

@Service
public class BomService {

    private final BomMapper bomMapper;
    private final ItemMapper itemMapper;

    public BomService(
            BomMapper bomMapper,
            ItemMapper itemMapper
    ) {
        this.bomMapper = bomMapper;
        this.itemMapper = itemMapper;
    }

    // 전체 BOM 목록 조회
    public List<Bom> findAll() {
        return bomMapper.findAll();
    }

    public List<Bom> search(String keyword) {
        String normalizedKeyword = keyword == null || keyword.isBlank()
                ? null
                : keyword.trim();
        return bomMapper.search(normalizedKeyword);
    }

    // BOM 상세 조회
    public Bom findByBomId(Long bomId) {
        return bomMapper.findByBomId(bomId);
    }

    // BOM 구성 자재 등록
    public Long insert(Bom bom) {
        validateBom(bom);

        Bom existingBom = bomMapper.findByParentAndComponent(
                bom.getParentItemId(),
                bom.getComponentItemId()
        );

        if (existingBom != null) {
            throw new IllegalArgumentException(
                    "이미 등록된 완제품과 구성 자재 조합입니다."
            );
        }

        int insertedCount = bomMapper.insert(bom);

        if (insertedCount == 0) {
            throw new IllegalStateException(
                    "BOM 구성 자재를 등록하지 못했습니다."
            );
        }

        return bom.getBomId();
    }

    // BOM 수정
    public void update(Bom bom) {
        if (bom == null || bom.getBomId() == null) {
            throw new IllegalArgumentException(
                    "수정할 BOM 정보가 없습니다."
            );
        }

        Bom existingBom = bomMapper.findByBomId(bom.getBomId());

        if (existingBom == null) {
            throw new IllegalArgumentException(
                    "수정할 BOM을 찾을 수 없습니다."
            );
        }

        if (bom.getRequiredQty() == null
                || bom.getRequiredQty().compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalArgumentException(
                    "필요 수량은 0보다 커야 합니다."
            );
        }

        int updatedCount = bomMapper.update(bom);

        if (updatedCount == 0) {
            throw new IllegalStateException(
                    "BOM 필요 수량을 수정하지 못했습니다."
            );
        }
    }

    // BOM 구성 자재 삭제
    public boolean delete(Long bomId) {
        Bom existingBom = bomMapper.findByBomId(bomId);

        if (existingBom == null) {
            return false;
        }

        return bomMapper.delete(bomId) > 0;
    }

    // 등록값 검증
    private void validateBom(Bom bom) {
        if (bom == null) {
            throw new IllegalArgumentException(
                    "BOM 정보가 없습니다."
            );
        }

        if (bom.getParentItemId() == null) {
            throw new IllegalArgumentException(
                    "완제품을 선택해 주세요."
            );
        }

        if (bom.getComponentItemId() == null) {
            throw new IllegalArgumentException(
                    "구성 자재를 선택해 주세요."
            );
        }

        if (bom.getParentItemId().equals(bom.getComponentItemId())) {
            throw new IllegalArgumentException(
                    "완제품 자신을 구성 자재로 등록할 수 없습니다."
            );
        }

        if (bom.getRequiredQty() == null
                || bom.getRequiredQty().compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalArgumentException(
                    "필요 수량은 0보다 커야 합니다."
            );
        }

        Item parentItem = itemMapper.findByItemId(
                bom.getParentItemId()
        );

        if (parentItem == null) {
            throw new IllegalArgumentException(
                    "선택한 완제품을 찾을 수 없습니다."
            );
        }

        if (!"PRODUCT".equals(parentItem.getItemType())) {
            throw new IllegalArgumentException(
                    "상위 품목은 완제품만 선택할 수 있습니다."
            );
        }

        Item componentItem = itemMapper.findByItemId(
                bom.getComponentItemId()
        );

        if (componentItem == null) {
            throw new IllegalArgumentException(
                    "선택한 구성 자재를 찾을 수 없습니다."
            );
        }

        if (!"MATERIAL".equals(componentItem.getItemType())) {
            throw new IllegalArgumentException(
                    "구성 품목은 자재만 선택할 수 있습니다."
            );
        }
    }
    
    public List<Bom> findByParentItemId(Long parentItemId) {
        return bomMapper.findByParentItemId(parentItemId);
    }
}
