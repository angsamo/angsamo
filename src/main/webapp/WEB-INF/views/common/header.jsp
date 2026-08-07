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
		<div class="notification-wrap">
			<button class="icon-button notification-button" id="notificationButton" type="button" aria-label="알림">
				<span class="material-symbols-outlined">notifications</span>
				<c:if test="${notificationCount > 0}"><i></i></c:if>
			</button>
			<div class="notification-panel" id="notificationPanel">
				<p class="notification-panel-title">최근 24시간 내 할 일</p>
				<c:choose>
					<c:when test="${empty notifications}"><p class="notification-empty">새로운 알림이 없습니다.</p></c:when>
					<c:otherwise>
						<c:forEach var="n" items="${notifications}">
							<a class="notification-item" href="${pageContext.request.contextPath}${n.link}">
								<span><c:out value="${n.message}"/></span>
								<time><c:out value="${n.occurredAtLabel}"/></time>
							</a>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<a class="icon-button" href="${pageContext.request.contextPath}/mypage" aria-label="설정">
			<span class="material-symbols-outlined">settings</span>
		</a>
		<div class="profile">
			<div>
				<strong><c:out value="${sessionScope.loginUser.userName}" default="로그인 사용자" /></strong>
				<p><c:out value="${sessionScope.loginUser.departmentCode}" default="${sessionScope.loginUser.role}" /></p>
			</div>
			<span class="avatar material-symbols-outlined">person</span>
		</div>
	</div>
</header>
