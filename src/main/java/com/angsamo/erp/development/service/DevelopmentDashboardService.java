package com.angsamo.erp.development.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.development.domain.Bom;
import com.angsamo.erp.development.domain.DevelopmentDashboardSummary;
import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.mapper.DevelopmentDashboardMapper;

@Service
@Transactional(readOnly = true)
public class DevelopmentDashboardService {

    private final DevelopmentDashboardMapper mapper;

    public DevelopmentDashboardService(DevelopmentDashboardMapper mapper) {
        this.mapper = mapper;
    }

    public DevelopmentDashboardSummary getSummary() { return mapper.findSummary(); }
    public List<Item> getRecentItems() { return mapper.findRecentItems(); }
    public List<Bom> getRecentBoms() { return mapper.findRecentBoms(); }
}
