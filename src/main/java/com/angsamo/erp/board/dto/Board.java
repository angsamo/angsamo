package com.angsamo.erp.board.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Board {

	private Long boardId;
	private String boardCode;
	private String boardName;
	private String description;
	private Boolean active;
	private Long createdBy;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
}
