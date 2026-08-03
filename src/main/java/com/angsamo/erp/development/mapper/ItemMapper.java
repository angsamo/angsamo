package com.angsamo.erp.development.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.development.domain.Item;

@Mapper
public interface ItemMapper {

    List<Item> findAll();

    Item findByItemCode(@Param("itemCode") String itemCode);
    
    void insert(Item item);
    
    void update(Item item);
    
    int deleteByItemCode(@Param("itemCode") String itemCode);
}