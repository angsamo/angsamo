package com.angsamo.erp.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.board.dto.BoardPostForm;
import com.angsamo.erp.board.dto.BoardPostListItem;

@Mapper
public interface BoardPostMapper {
	List<BoardPostListItem> findAll();
	List<BoardPostListItem> findPage(@Param("offset") int offset, @Param("size") int size, @Param("active") Boolean active);
	long count(@Param("active") Boolean active);
	List<BoardPostListItem> findByBoardId(Long boardId);
	BoardPostListItem findById(Long postId);
	void insert(@Param("form") BoardPostForm form, @Param("authorId") Long authorId);
	void update(@Param("postId") Long postId, @Param("form") BoardPostForm form);
	void deactivate(Long postId);
	void incrementViewCount(Long postId);
}
