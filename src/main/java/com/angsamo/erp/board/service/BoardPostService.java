package com.angsamo.erp.board.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.board.dto.BoardPostForm;
import com.angsamo.erp.board.dto.BoardPostListItem;
import com.angsamo.erp.board.mapper.BoardMapper;
import com.angsamo.erp.board.mapper.BoardPostMapper;
import com.angsamo.erp.common.paging.PageRequest;
import com.angsamo.erp.common.paging.PageResult;
import com.angsamo.erp.common.session.LoginUser;

@Service
public class BoardPostService {
	public static final int PAGE_SIZE = 20;

	private final BoardPostMapper boardPostMapper;
	private final BoardMapper boardMapper;

	public BoardPostService(BoardPostMapper boardPostMapper, BoardMapper boardMapper) {
		this.boardPostMapper = boardPostMapper;
		this.boardMapper = boardMapper;
	}

	@Transactional(readOnly = true)
	public List<BoardPostListItem> getPosts() {
		return boardPostMapper.findAll();
	}

	@Transactional(readOnly = true)
	public PageResult<BoardPostListItem> getPosts(Integer page, String status) {
		Boolean active = "active".equals(status) ? Boolean.TRUE : "suspended".equals(status) ? Boolean.FALSE : null;
		PageRequest pageRequest = new PageRequest(page, PAGE_SIZE);
		List<BoardPostListItem> items = boardPostMapper.findPage(pageRequest.getOffset(), pageRequest.getSize(), active);
		long totalCount = boardPostMapper.count(active);
		return new PageResult<>(items, pageRequest.getPage(), pageRequest.getSize(), totalCount);
	}

	@Transactional(readOnly = true)
	public long countActivePosts() { return boardPostMapper.count(true); }

	@Transactional(readOnly = true)
	public long countInactivePosts() { return boardPostMapper.count(false); }

	@Transactional(readOnly = true)
	public List<BoardPostListItem> getPosts(Long boardId) {
		return boardPostMapper.findByBoardId(boardId);
	}

	@Transactional(readOnly = true)
	public List<BoardPostListItem> getPostsByAuthor(Long authorId) {
		return boardPostMapper.findByAuthorId(authorId);
	}

	@Transactional(readOnly = true)
	public BoardPostListItem getPost(Long postId) {
		return boardPostMapper.findById(postId);
	}

	@Transactional
	public void create(BoardPostForm form, Long authorId) {
		var board = boardMapper.findById(form.getBoardId());
		if (board == null || !Boolean.TRUE.equals(board.getActive())) {
			throw new IllegalArgumentException("사용 중인 게시판만 선택할 수 있습니다.");
		}
		validate(form);
		boardPostMapper.insert(form, authorId);
	}

	@Transactional
	public void update(Long postId, BoardPostForm form, LoginUser loginUser) {
		requireAuthorOrAdmin(postId, loginUser);
		validate(form);
		boardPostMapper.update(postId, form);
	}

	@Transactional
	public void deactivate(Long postId, LoginUser loginUser) {
		requireAuthorOrAdmin(postId, loginUser);
		boardPostMapper.deactivate(postId);
	}

	@Transactional(readOnly = true)
	public boolean canManage(Long postId, LoginUser loginUser) {
		var post = boardPostMapper.findById(postId);
		return post != null && isAuthorOrAdmin(post, loginUser);
	}

	private void requireAuthorOrAdmin(Long postId, LoginUser loginUser) {
		var post = boardPostMapper.findById(postId);
		if (post == null) {
			throw new IllegalArgumentException("게시글을 찾을 수 없습니다.");
		}
		if (!isAuthorOrAdmin(post, loginUser)) {
			throw new IllegalArgumentException("본인이 작성한 글만 수정하거나 사용 중지할 수 있습니다.");
		}
	}

	private boolean isAuthorOrAdmin(BoardPostListItem post, LoginUser loginUser) {
		boolean isAuthor = post.getAuthorId() != null && post.getAuthorId().equals(loginUser.getUserId());
		return isAuthor || "ADMIN".equals(loginUser.getRole());
	}

	@Transactional(readOnly = true)
	public List<BoardPostListItem> getActivePosts(Long boardId) {
		return boardPostMapper.findByBoardId(boardId).stream()
				.filter(post -> Boolean.TRUE.equals(post.getActive()))
				.toList();
	}

	@Transactional(readOnly = true)
	public PageResult<BoardPostListItem> getActivePosts(Long boardId, Integer page) {
		PageRequest pageRequest = new PageRequest(page, PAGE_SIZE);
		List<BoardPostListItem> items = boardPostMapper.findByBoardIdPage(boardId, pageRequest.getOffset(),
				pageRequest.getSize(), true);
		long totalCount = boardPostMapper.countByBoardId(boardId, true);
		return new PageResult<>(items, pageRequest.getPage(), pageRequest.getSize(), totalCount);
	}

	@Transactional
	public BoardPostListItem viewPost(Long postId) {
		var post = boardPostMapper.findById(postId);
		if (post == null || !Boolean.TRUE.equals(post.getActive())) {
			throw new IllegalArgumentException("게시글을 찾을 수 없습니다.");
		}
		boardPostMapper.incrementViewCount(postId);
		post.setViewCount(post.getViewCount() + 1);
		return post;
	}

	private void validate(BoardPostForm form) {
		if (form.getTitle() == null || form.getTitle().isBlank()) {
			throw new IllegalArgumentException("제목을 입력하세요.");
		}
		if (form.getContent() == null || form.getContent().isBlank()) {
			throw new IllegalArgumentException("내용을 입력하세요.");
		}
		form.setTitle(form.getTitle().trim());
	}
}
