package com.angsamo.erp.common.paging;

/** 관리자 목록 화면에서 공통으로 쓰는 페이지 요청. 1부터 시작하는 페이지 번호를 오프셋으로 변환한다. */
public class PageRequest {
	private final int page;
	private final int size;

	public PageRequest(Integer requestedPage, int size) {
		this.page = (requestedPage == null || requestedPage < 1) ? 1 : requestedPage;
		this.size = size;
	}

	public int getPage() {
		return page;
	}

	public int getSize() {
		return size;
	}

	public int getOffset() {
		return (page - 1) * size;
	}
}
