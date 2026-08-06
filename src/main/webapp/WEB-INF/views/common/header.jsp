<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="topbar">
	<div class="topbar-left">
		<button class="icon-button menu-button" id="menuButton" type="button" aria-label="메뉴 열기">
			<span class="material-symbols-outlined">menu</span>
		</button>
		<div>
			<p class="breadcrumb"><c:out value="${breadcrumb}" default="관리자 / 대시보드"/></p>
			<strong><c:out value="${pageTitle}" default="통합 업무 관리"/></strong>
		</div>
	</div>
	<div class="topbar-actions">
		<button class="icon-button notification-button" type="button" aria-label="알림">
			<span class="material-symbols-outlined">notifications</span>
			<i></i>
		</button>
		<button class="icon-button" type="button" aria-label="설정">
			<span class="material-symbols-outlined">settings</span>
		</button>
		<div class="profile">
			<div>
				<strong><c:out value="${sessionScope.loginUser.userName}" default="로그인 사용자" /></strong>
				<p><c:out value="${sessionScope.loginUser.departmentCode}" default="${sessionScope.loginUser.role}" /></p>
			</div>
			<span class="avatar material-symbols-outlined">person</span>
		</div>
	</div>
</header>
