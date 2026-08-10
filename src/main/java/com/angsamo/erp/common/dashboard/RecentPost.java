package com.angsamo.erp.common.dashboard;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RecentPost {
	private Long boardId;
	private Long postId;
	private String boardName;
	private String title;
	private LocalDateTime createdAt;
	private String createdAtLabel;
}
