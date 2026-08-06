package com.angsamo.erp.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardForm {
	private String boardCode;
	private String boardName;
	private Long departmentId;
	private Boolean active;
}
