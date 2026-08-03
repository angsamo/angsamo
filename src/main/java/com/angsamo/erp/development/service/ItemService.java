package com.angsamo.erp.development.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.dao.DataIntegrityViolationException;
import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.mapper.ItemMapper;

@Service
public class ItemService {

	private final ItemMapper itemMapper;

	public ItemService(ItemMapper itemMapper) {
		this.itemMapper = itemMapper;
	}

	public List<Item> findAll() {
		return itemMapper.findAll();
	}

	public Item findByItemCode(String itemCode) {
		return itemMapper.findByItemCode(itemCode);
	}

	public void insert(Item item) {
		itemMapper.insert(item);
	}
	
	public void update(Item item) {
	    itemMapper.update(item);
	}
	public boolean delete(String itemCode) {
	    try {
	        return itemMapper.deleteByItemCode(itemCode) > 0;
	    } catch (DataIntegrityViolationException e) {
	        throw new IllegalStateException(
	                "다른 업무에서 사용 중인 품목은 삭제할 수 없습니다.",
	                e
	        );
	    }
	}
}