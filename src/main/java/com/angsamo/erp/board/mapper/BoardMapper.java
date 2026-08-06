package com.angsamo.erp.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.board.dto.BoardForm;
import com.angsamo.erp.board.dto.BoardListItem;

@Mapper
public interface BoardMapper {
	List<BoardListItem> findAll();
	List<BoardListItem> findVisible(@Param("departmentId") Long departmentId);
	BoardListItem findById(Long boardId);
	int countByCode(@Param("code") String code, @Param("excludeId") Long excludeId);
	void insert(BoardForm form);
	void update(@Param("boardId") Long boardId, @Param("form") BoardForm form);
	void deactivate(Long boardId);
}
