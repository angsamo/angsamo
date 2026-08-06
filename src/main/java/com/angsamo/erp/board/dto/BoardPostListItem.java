package com.angsamo.erp.board.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardPostListItem {
	private Long postId;
	private Long boardId;
	private String boardName;
	private String title;
	private String content;
	private Long authorId;
	private String authorName;
	private Integer viewCount;
	private Boolean active;
	private LocalDateTime createdAt;
}
