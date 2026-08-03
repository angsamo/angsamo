<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">admin_panel_settings</span>
				<span>관리자</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="#">전체 현황</a>
				<a href="${pageContext.request.contextPath}/admin/users">사용자 관리</a>
				<a href="#">부서 관리</a>
				<a href="#">협력회사 관리</a>
			</div>
		</div>

		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">category</span>
				<span>개발부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="#">개발 현황</a>
				<a href="#">품목 관리</a>
				<a href="#">BOM 관리</a>
			</div>
		</div>

		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">factory</span>
				<span>생산부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="#">생산 현황</a>
				<a href="#">생산계획</a>
				<a href="#">자재 소요량</a>
				<a href="#">불출 요청</a>
				<a href="#">재고 조회</a>
			</div>
		</div>

		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">shopping_cart</span>
				<span>구매부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="#">구매 현황</a>
				<a href="#">조달계획</a>
				<a href="#">견적 관리</a>
				<a href="#">구매 발주</a>
				<a href="#">진척 관리</a>
				<a href="#">연계 조회</a>
			</div>
		</div>

		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">inventory_2</span>
				<span>자재부서</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="#">자재 현황</a>
				<a href="#">입고 관리</a>
				<a href="#">반품 관리</a>
				<a href="#">재고 관리</a>
				<a href="#">출고 관리</a>
				<a href="#">거래명세서</a>
			</div>
		</div>

		<div class="nav-group">
			<a class="nav-link" href="#">
				<span class="material-symbols-outlined">handshake</span>
				<span>협력회사</span>
				<span class="nav-arrow material-symbols-outlined">chevron_right</span>
			</a>
			<div class="submenu">
				<a href="#">협력 현황</a>
				<a href="#">견적 관리</a>
				<a href="#">발주 관리</a>
				<a href="#">제작·출하</a>
				<a href="#">보완·반품</a>
				<a href="#">거래명세서</a>
			</div>
		</div>
	</nav>

	<a class="logout" href="#">
		<span class="material-symbols-outlined">logout</span>
		<span>로그아웃</span>
	</a>
</aside>
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
