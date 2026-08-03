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

    public List<Bom> findAll() {
        return bomMapper.findAll();
    }

    public Bom findByBomId(Long bomId) {
        return bomMapper.findByBomId(bomId);
    }

    public void insert(Bom bom) {
        bomMapper.insert(bom);
    }

    public void update(Bom bom) {
        bomMapper.update(bom);
    }

    public boolean delete(Long bomId) {
        return bomMapper.deleteByBomId(bomId) > 0;
    }
}