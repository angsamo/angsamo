package com.angsamo.erp.board.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.server.ResponseStatusException;

import com.angsamo.erp.admin.service.AdminDepartmentService;
import com.angsamo.erp.board.dto.BoardForm;
import com.angsamo.erp.board.dto.BoardPostForm;
import com.angsamo.erp.board.service.BoardPostService;
import com.angsamo.erp.board.service.BoardService;
import com.angsamo.erp.common.session.LoginUser;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminBoardController {
	private final BoardService boardService;
	private final BoardPostService boardPostService;
	private final AdminDepartmentService adminDepartmentService;

	public AdminBoardController(BoardService boardService, BoardPostService boardPostService,
			AdminDepartmentService adminDepartmentService) {
		this.boardService = boardService;
		this.boardPostService = boardPostService;
		this.adminDepartmentService = adminDepartmentService;
	}

	@GetMapping("/admin/boards")
	public String boards(@RequestParam(required = false) String status, Model model) {
		var all = boardService.getBoards();
		long activeCount = all.stream().filter(b -> Boolean.TRUE.equals(b.getActive())).count();
		long inactiveCount = all.size() - activeCount;
		var filtered = all.stream()
				.filter(b -> "active".equals(status) ? Boolean.TRUE.equals(b.getActive())
						: "suspended".equals(status) ? !Boolean.TRUE.equals(b.getActive()) : true)
				.toList();
		model.addAttribute("boards", filtered);
		model.addAttribute("grandTotal", all.size());
		model.addAttribute("activeCount", activeCount);
		model.addAttribute("inactiveCount", inactiveCount);
		model.addAttribute("status", status);
		model.addAttribute("departments", adminDepartmentService.getDepartments());
		return "admin/board-management";
	}

	@GetMapping("/admin/boards/{boardId}")
	public String boardDetail(@PathVariable Long boardId, Model model) {
		var board = boardService.getBoard(boardId);
		if (board == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
		model.addAttribute("board", board);
		model.addAttribute("posts", boardPostService.getPosts(boardId));
		return "admin/board-detail";
	}

	@PostMapping("/admin/boards")
	public String createBoard(BoardForm form, RedirectAttributes redirect) {
		try {
			boardService.create(form);
			redirect.addFlashAttribute("success", "게시판을 등록했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/admin/boards";
	}

	@PostMapping("/admin/boards/{boardId}")
	public String updateBoard(@PathVariable Long boardId, BoardForm form, RedirectAttributes redirect) {
		try {
			boardService.update(boardId, form);
			redirect.addFlashAttribute("success", "게시판 정보를 수정했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/admin/boards";
	}

	@PostMapping("/admin/boards/{boardId}/deactivate")
	public String deactivateBoard(@PathVariable Long boardId, RedirectAttributes redirect) {
		boardService.deactivate(boardId);
		redirect.addFlashAttribute("success", "게시판을 사용 중지했습니다.");
		return "redirect:/admin/boards";
	}

	@PostMapping("/admin/boards/{boardId}/posts")
	public String createPost(@PathVariable Long boardId, BoardPostForm form, HttpSession session,
			RedirectAttributes redirect) {
		form.setBoardId(boardId);
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		try {
			boardPostService.create(form, loginUser.getUserId());
			redirect.addFlashAttribute("success", "게시글을 등록했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/admin/boards/" + boardId;
	}

	@GetMapping("/admin/posts")
	public String posts(@RequestParam(required = false) Integer page, @RequestParam(required = false) String status,
			Model model) {
		var result = boardPostService.getPosts(page, status);
		long activeCount = boardPostService.countActivePosts();
		long inactiveCount = boardPostService.countInactivePosts();
		model.addAttribute("posts", result.getItems());
		model.addAttribute("page", result.getPage());
		model.addAttribute("totalPages", result.getTotalPages());
		model.addAttribute("activeCount", activeCount);
		model.addAttribute("inactiveCount", inactiveCount);
		model.addAttribute("grandTotal", activeCount + inactiveCount);
		model.addAttribute("status", status);
		model.addAttribute("baseUrl", "/admin/posts" + (status != null ? "?status=" + status : ""));
		return "admin/post-management";
	}

	@GetMapping("/admin/posts/{postId}")
	public String postDetail(@PathVariable Long postId, Model model) {
		var post = boardPostService.getPost(postId);
		if (post == null) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
		model.addAttribute("post", post);
		return "admin/post-detail";
	}

	@PostMapping("/admin/posts/{postId}")
	public String updatePost(@PathVariable Long postId, BoardPostForm form, HttpSession session,
			RedirectAttributes redirect) {
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		try {
			boardPostService.update(postId, form, loginUser);
			redirect.addFlashAttribute("success", "게시글을 수정했습니다.");
		} catch (IllegalArgumentException e) {
			redirect.addFlashAttribute("error", e.getMessage());
		}
		return "redirect:/admin/posts/" + postId;
	}

	@PostMapping("/admin/posts/{postId}/deactivate")
	public String deactivatePost(@PathVariable Long postId, HttpSession session, RedirectAttributes redirect) {
		LoginUser loginUser = (LoginUser) session.getAttribute(LoginUser.SESSION_KEY);
		boardPostService.deactivate(postId, loginUser);
		redirect.addFlashAttribute("success", "게시글을 사용 중지했습니다.");
		return "redirect:/admin/posts";
	}
}
