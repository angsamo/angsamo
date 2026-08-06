package com.angsamo.erp.development.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.development.domain.Item;

@Mapper
public interface ItemMapper {

    List<Item> findAll();

    List<Item> search(
            @Param("keyword") String keyword,
            @Param("itemType") String itemType);

    Item findByItemId(@Param("itemId") Long itemId);

    Item findByItemCode(@Param("itemCode") String itemCode);

    int insert(Item item);

    int update(Item item);

    int deactivateByItemId(@Param("itemId") Long itemId);
}
