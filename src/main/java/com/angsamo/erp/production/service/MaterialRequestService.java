package com.angsamo.erp.production.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.angsamo.erp.production.domain.MaterialRequest;
import com.angsamo.erp.production.mapper.MaterialRequestMapper;

@Service
public class MaterialRequestService {

    private final MaterialRequestMapper materialRequestMapper;

    public MaterialRequestService(
            MaterialRequestMapper materialRequestMapper
    ) {
        this.materialRequestMapper = materialRequestMapper;
    }

    // 자재요청 전체 목록 조회
    public List<MaterialRequest> findAll() {
        return materialRequestMapper.findAll();
    }
}