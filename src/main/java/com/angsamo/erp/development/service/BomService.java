package com.angsamo.erp.development.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.angsamo.erp.development.domain.Bom;
import com.angsamo.erp.development.mapper.BomMapper;

@Service
public class BomService {

    private final BomMapper bomMapper;

    public BomService(BomMapper bomMapper) {
        this.bomMapper = bomMapper;
    }

    // 전체 BOM 목록 조회
    public List<Bom> findAll() {
        return bomMapper.findAll();
    }

    // 특정 완제품의 BOM 구성 자재 조회
    public List<Bom> findByParentItemId(Long parentItemId) {
        return bomMapper.findByParentItemId(parentItemId);
    }
}