package com.angsamo.erp.board.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardPost {

	private Long postId;
	private Long boardId;
	private String title;
	private String content;
	private Long authorId;
	private Boolean isNotice;
	private Integer viewCount;
	private Boolean active;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
}
