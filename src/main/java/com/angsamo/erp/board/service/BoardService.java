package com.angsamo.erp.board.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.board.dto.BoardForm;
import com.angsamo.erp.board.dto.BoardListItem;
import com.angsamo.erp.board.mapper.BoardMapper;

@Service
public class BoardService {
	private final BoardMapper boardMapper;

	public BoardService(BoardMapper boardMapper) {
		this.boardMapper = boardMapper;
	}

	@Transactional(readOnly = true)
	public List<BoardListItem> getBoards() {
		return boardMapper.findAll();
	}

	@Transactional(readOnly = true)
	public BoardListItem getBoard(Long boardId) {
		return boardMapper.findById(boardId);
	}

	@Transactional(readOnly = true)
	public List<BoardListItem> getVisibleBoards(Long departmentId) {
		return boardMapper.findVisible(departmentId);
	}

	@Transactional
	public void create(BoardForm form) {
		String code = normalizeCode(form.getBoardCode());
		String name = normalizeName(form.getBoardName());
		if (boardMapper.countByCode(code, null) > 0) {
			throw new IllegalArgumentException("이미 사용 중인 게시판 코드입니다.");
		}
		form.setBoardCode(code);
		form.setBoardName(name);
		boardMapper.insert(form);
	}

	@Transactional
	public void update(Long boardId, BoardForm form) {
		// 게시판 코드와 담당 부서는 생성 시점에 고정되며 이름과 사용 여부만 수정한다.
		form.setBoardName(normalizeName(form.getBoardName()));
		boardMapper.update(boardId, form);
	}

	@Transactional
	public void deactivate(Long boardId) {
		boardMapper.deactivate(boardId);
	}

	private String normalizeCode(String code) {
		String normalized = code == null ? "" : code.trim().toUpperCase();
		if (!normalized.matches("[A-Z][A-Z0-9_]*")) {
			throw new IllegalArgumentException("게시판 코드는 영문 대문자로 시작하고 숫자와 _만 사용할 수 있습니다.");
		}
		return normalized;
	}

	private String normalizeName(String name) {
		String normalized = name == null ? "" : name.trim();
		if (normalized.isBlank()) throw new IllegalArgumentException("게시판명을 입력하세요.");
		return normalized;
	}
}
