package com.angsamo.erp.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardPostForm {
	private Long boardId;
	private String title;
	private String content;
}
