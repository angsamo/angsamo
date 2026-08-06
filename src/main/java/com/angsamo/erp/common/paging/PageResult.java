package com.angsamo.erp.common.paging;

import java.util.List;

/** 관리자 목록 화면에서 공통으로 쓰는 페이지 결과. */
public class PageResult<T> {
	private final List<T> items;
	private final int page;
	private final int size;
	private final long totalCount;

	public PageResult(List<T> items, int page, int size, long totalCount) {
		this.items = items;
		this.page = page;
		this.size = size;
		this.totalCount = totalCount;
	}

	public List<T> getItems() {
		return items;
	}

	public int getPage() {
		return page;
	}

	public long getTotalCount() {
		return totalCount;
	}

	public int getTotalPages() {
		return Math.max(1, (int) Math.ceil(totalCount / (double) size));
	}
}
