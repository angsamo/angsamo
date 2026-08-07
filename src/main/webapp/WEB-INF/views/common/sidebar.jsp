<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar" id="sidebar">
	<div class="brand">
		<span class="brand-mark material-symbols-outlined">domain</span>
		<div>
			<strong>앙사모 ERP</strong>
			<p>조달·구매 관리 시스템</p>
		</div>
	</div>

	<nav class="main-nav" aria-label="주 메뉴">
		<a class="nav-link active" href="${pageContext.request.contextPath}/">
			<span class="material-symbols-outlined">dashboard</span>
			<span>대시보드</span>
		</a>

		<a class="nav-link" href="${pageContext.request.contextPath}/boards">
			<span class="material-symbols-outlined">forum</span>
			<span>게시판</span>
		</a>

		<c:if test="${sessionScope.loginUser.role == 'ADMIN'}">
		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">admin_panel_settings</span>
				<span>관리자</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="${pageContext.request.contextPath}/">전체 현황</a>
				<a href="${pageContext.request.contextPath}/admin/users">사용자 관리</a>
				<a href="${pageContext.request.contextPath}/admin/departments">부서 관리</a>
				<a href="${pageContext.request.contextPath}/admin/vendors">협력회사 관리</a>
				<a href="${pageContext.request.contextPath}/admin/boards">게시판 관리</a>
				<a href="${pageContext.request.contextPath}/admin/posts">게시글 관리</a>
			</div>
		</div>
		</c:if>

		<c:if test="${sessionScope.loginUser.role == 'ADMIN' or sessionScope.loginUser.departmentCode == 'DEV'}">
		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">category</span>
				<span>개발부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="${pageContext.request.contextPath}/development">개발 현황</a>
				<a href="${pageContext.request.contextPath}/development/items">품목 관리</a>
				<a href="${pageContext.request.contextPath}/development/boms">BOM 관리</a>
			</div>
		</div>
		</c:if>

		<c:if test="${sessionScope.loginUser.role == 'ADMIN' or sessionScope.loginUser.departmentCode == 'PRODUCTION'}">
		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">factory</span>
				<span>생산부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="#">생산 현황</a>
				<a href="${pageContext.request.contextPath}/production/plans">생산계획</a>
				<a href="${pageContext.request.contextPath}/production/material-requirements">자재 소요량</a>
				<a href="${pageContext.request.contextPath}/production/material-requests">불출 요청</a>
				<a href="${pageContext.request.contextPath}/material/inventory">재고 조회</a>
			</div>
		</div>
		</c:if>

		<c:if test="${sessionScope.loginUser.role == 'ADMIN' or sessionScope.loginUser.departmentCode == 'PURCHASE'}">
		<div class="nav-group">
			<a class="nav-link" href="${pageContext.request.contextPath}/purchase">
				<span class="material-symbols-outlined">shopping_cart</span>
				<span>구매부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="${pageContext.request.contextPath}/purchase">구매 현황</a>
				<a href="${pageContext.request.contextPath}/purchase/procurements">조달계획</a>
				<a href="${pageContext.request.contextPath}/purchase/quotes">견적 관리</a>
				<a href="${pageContext.request.contextPath}/purchase/contracts">계약 관리</a>
				<a href="${pageContext.request.contextPath}/purchase/orders">구매 발주</a>
				<a href="${pageContext.request.contextPath}/purchase/progress">진척 관리</a>
				<a href="${pageContext.request.contextPath}/purchase/receivings">입고 연계</a>
				<a href="${pageContext.request.contextPath}/purchase/shortages">연계 조회</a>
				<a href="${pageContext.request.contextPath}/purchase/vendors">협력회사 관리</a>
			</div>
		</div>
		</c:if>

		<c:if test="${sessionScope.loginUser.role == 'ADMIN' or sessionScope.loginUser.departmentCode == 'MATERIAL'}">
		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">inventory_2</span>
				<span>자재부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="${pageContext.request.contextPath}/material">자재 현황</a>
				<a href="${pageContext.request.contextPath}/material/receivings">입고 관리</a>
				<a href="${pageContext.request.contextPath}/material/returns">반품 관리</a>
				<a href="${pageContext.request.contextPath}/material/inventory">재고 관리</a>
				<a href="${pageContext.request.contextPath}/material/issues">출고 관리</a>
				<a href="${pageContext.request.contextPath}/material/statements">거래명세서</a>
			</div>
		</div>
		</c:if>

		<c:if test="${sessionScope.loginUser.role == 'ADMIN' or sessionScope.loginUser.role == 'VENDOR'}">
		<div class="nav-group">
			<a class="nav-link" href="${pageContext.request.contextPath}/vendor">
				<span class="material-symbols-outlined">handshake</span>
				<span>협력회사</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="${pageContext.request.contextPath}/vendor">협력 현황</a>
				<a href="${pageContext.request.contextPath}/vendor/quotes">견적 관리</a>
				<a href="${pageContext.request.contextPath}/vendor/contracts">계약 관리</a>
				<a href="${pageContext.request.contextPath}/vendor/orders">발주 관리</a>
				<a href="${pageContext.request.contextPath}/vendor/shipments">제작·출하</a>
				<a href="${pageContext.request.contextPath}/vendor/inspections">검수 관리</a>
				<a href="${pageContext.request.contextPath}/vendor/returns">보완·반품</a>
				<a href="${pageContext.request.contextPath}/vendor/statements">거래명세서</a>
			</div>
		</div>
		</c:if>
	</nav>

	<form action="${pageContext.request.contextPath}/logout" method="post">
		<button class="logout" type="submit">
			<span class="material-symbols-outlined">logout</span>
			<span>로그아웃</span>
		</button>
	</form>
</aside>
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
