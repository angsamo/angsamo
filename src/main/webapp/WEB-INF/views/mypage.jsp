<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="마이페이지" scope="request"/>
<c:set var="breadcrumb" value="마이페이지" scope="request"/>
<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>마이페이지 | ERP</title><link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet"><link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css"></head>
<body><jsp:include page="/WEB-INF/views/common/sidebar.jsp"/><div class="app-shell"><jsp:include page="/WEB-INF/views/common/header.jsp"/><main class="workspace"><section class="page-heading"><div><p class="eyebrow">MY PAGE</p><h1>마이페이지</h1><p>내 계정 정보와 비밀번호를 관리합니다.</p></div></section>
<c:if test="${not empty success}"><div class="notice">${success}</div></c:if><c:if test="${not empty error}"><div class="notice error-notice">${error}</div></c:if>

<section class="content-grid">
	<div style="display:grid; gap:14px;">
		<article class="panel admin-form-panel">
			<div class="panel-header"><div><p class="eyebrow">PROFILE</p><h2>내 정보</h2></div></div>
			<div class="detail-form" style="grid-template-columns:repeat(2,minmax(180px,1fr));">
				<label>로그인 아이디<input value="<c:out value='${profile.loginId}'/>" disabled></label>
				<label>이름<input value="<c:out value='${profile.userName}'/>" disabled></label>
				<label>권한<input value="${profile.role == 'ADMIN' ? '관리자' : (profile.role == 'VENDOR' ? '협력회사' : '일반 사용자')}" disabled></label>
				<label>소속<input value="<c:out value='${empty profile.departmentName ? profile.vendorName : profile.departmentName}'/>" disabled></label>
			</div>
		</article>

		<article class="panel admin-form-panel">
			<div class="panel-header"><div><p class="eyebrow">SECURITY</p><h2>비밀번호 변경</h2></div></div>
			<form class="detail-form" method="post" action="${pageContext.request.contextPath}/mypage/password">
				<label>현재 비밀번호<input type="password" name="currentPassword" required></label>
				<label>새 비밀번호<input type="password" name="newPassword" required></label>
				<label>새 비밀번호 확인<input type="password" name="confirmPassword" required></label>
				<button class="primary-button" type="submit">변경</button>
			</form>
		</article>
	</div>

	<div style="display:grid; gap:14px;">
		<article class="panel compact-panel">
			<div class="panel-header"><div><p class="eyebrow">BOARD</p><h2>내가 쓴 글</h2></div><span class="list-count">${myPosts.size()}건</span></div>
			<div class="work-list">
				<c:forEach var="p" items="${myPosts}">
				<a class="work-row" style="text-decoration:none; color:inherit;" href="${pageContext.request.contextPath}/boards/${p.boardId}/posts/${p.postId}">
					<span class="work-icon material-symbols-outlined">forum</span>
					<div><strong><c:out value="${p.title}"/></strong><p><c:out value="${p.boardName}"/></p></div>
					<span class="state-badge ${p.active ? 'enabled' : 'disabled'}">${p.active ? '사용' : '중지'}</span>
					<time><c:out value="${fn:substringBefore(p.createdAt, 'T')}"/></time>
				</a>
				</c:forEach>
				<c:if test="${empty myPosts}"><p style="padding:16px 18px; color:var(--muted); font-size:13px;">작성한 게시글이 없습니다.</p></c:if>
			</div>
		</article>
	</div>
</section>
</main></div><script src="${pageContext.request.contextPath}/resources/js/common.js"></script></body></html>
