package com.angsamo.erp.board.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardListItem {
	private Long boardId;
	private String boardCode;
	private String boardName;
	private Long departmentId;
	private String departmentName;
	private Boolean active;
	private LocalDateTime createdAt;
}
