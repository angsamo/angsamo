package com.angsamo.erp.development.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.angsamo.erp.development.domain.Bom;
import com.angsamo.erp.development.domain.DevelopmentDashboardSummary;
import com.angsamo.erp.development.domain.Item;

@Mapper
public interface DevelopmentDashboardMapper {

    DevelopmentDashboardSummary findSummary();

    List<Item> findRecentItems();

    List<Bom> findRecentBoms();
}
