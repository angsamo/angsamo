package com.angsamo.erp.board.controller;

import java.util.Objects;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.board.dto.BoardListItem;
import com.angsamo.erp.board.dto.BoardPostForm;
import com.angsamo.erp.board.service.BoardPostService;
import com.angsamo.erp.board.service.BoardService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

@Controller
public class BoardController {
	private final BoardService boardService;
	private final BoardPostService boardPostService;

	public BoardController(BoardService boardService, BoardPostService boardPostService) {
		this.boardService = boardService;
		this.boardPostService = boardPostService;
	}

	@GetMapping("/boards")
	public String boards(HttpSession session, Model model) {
		LoginUser loginUser = requireLogin(session);
		var boards = "ADMIN".equals(loginUser.getRole())
				? boardService.getBoards().stream().filter(b -> Boolean.TRUE.equals(b.getActive())).toList()
				: boardService.getVisibleBoards(loginUser.getDepartmentId());
		model.addAttribute("boards", boards);
		return "board/board-list";
	}

	@GetMapping("/boards/{boardId}")
	public String posts(@PathVariable Long boardId, @RequestParam(required = false) Integer page,
			HttpSession session, Model model) {
		LoginUser loginUser = requireLogin(session);
		BoardListItem board = requireVisible(boardId, loginUser);
		var result = boardPostService.getActivePosts(boardId, page);
		model.addAttribute("board", board);
		model.addAttribute("posts", result.getItems());
		model.addAttribute("page", result.getPage());
		model.addAttribute("totalPages", result.getTotalPages());
		model.addAttribute("baseUrl", "/boards/" + boardId);
		return "board/post-list";
	}

	@GetMapping("/boards/{boardId}/posts/new")
	public String newPostForm(@PathVariable Long boardId, HttpSession session, Model model) {
		LoginUser loginUser = requireLogin(session);
		BoardListItem board = requireVisible(boardId, loginUser);
		model.addAttribute("board", board);
		return "board/post-form";
	}

	@GetMapping("/boards/{boardId}/posts/{postId}")
	public String postDetail(@PathVariable Long boardId, @PathVariable Long postId, HttpSession session,
			Model model) {
		LoginUser loginUser = requireLogin(session);
		BoardListItem board = requireVisible(boardId, loginUser);
		model.addAttribute("board", board);
		try {
			var post = boardPostService.viewPost(postId);
			model.addAttribute("post", post);
			model.addAttribute("canManage", boardPostService.canManage(postId, loginUser));
		} catch (IllegalArgumentException e) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage());
		}
		return "board/post-detail";
	}

	@PostMapping("/boards/{boardId}/posts")
	public String createPost(@PathVariable Long boardId, BoardPostForm form, HttpSession session,
			RedirectAttributes redirect) {
		LoginUser loginUser = requireLogin(session);
		requireVisible(boardId, loginUser);
		form.setBoardId(boardId);
		try {
			boardPostService.create(form, loginUser.getUserId());
			redirect.addFlashAttribute("success", "게시글을 등록했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/boards/" + boardId;
	}

	@PostMapping("/boards/{boardId}/posts/{postId}")
	public String updatePost(@PathVariable Long boardId, @PathVariable Long postId, BoardPostForm form,
			HttpSession session, RedirectAttributes redirect) {
		LoginUser loginUser = requireLogin(session);
		requireVisible(boardId, loginUser);
		try {
			boardPostService.update(postId, form, loginUser);
			redirect.addFlashAttribute("success", "게시글을 수정했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/boards/" + boardId + "/posts/" + postId;
	}

	@PostMapping("/boards/{boardId}/posts/{postId}/deactivate")
	public String deactivatePost(@PathVariable Long boardId, @PathVariable Long postId, HttpSession session,
			RedirectAttributes redirect) {
		LoginUser loginUser = requireLogin(session);
		requireVisible(boardId, loginUser);
		try {
			boardPostService.deactivate(postId, loginUser);
			redirect.addFlashAttribute("success", "게시글을 사용 중지했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/boards/" + boardId;
	}

	private LoginUser requireLogin(HttpSession session) {
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		if (loginUser == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
		return loginUser;
	}

	private BoardListItem requireVisible(Long boardId, LoginUser loginUser) {
		BoardListItem board = boardService.getBoard(boardId);
		boolean visible = board != null && Boolean.TRUE.equals(board.getActive())
				&& (board.getDepartmentId() == null
						|| Objects.equals(board.getDepartmentId(), loginUser.getDepartmentId())
						|| "ADMIN".equals(loginUser.getRole()));
		if (!visible) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
		return board;
	}
}
