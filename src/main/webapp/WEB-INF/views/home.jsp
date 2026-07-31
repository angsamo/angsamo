<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>${projectName}</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css?v=20260731-2">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
	<div class="app-shell">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />

		<main class="workspace">
			<section class="page-heading">
				<div>
					<p class="eyebrow">OVERVIEW</p>
					<h1>통합 업무 대시보드</h1>
					<p>부서별 조달·구매 진행 상황을 한 화면에서 확인합니다.</p>
				</div>
				<button class="primary-button" type="button">
					<span class="material-symbols-outlined">add</span>
					새 업무 등록
				</button>
			</section>

			<section class="notice">
				<span class="material-symbols-outlined">info</span>
				<p><strong>관리자 통합 화면</strong>입니다. 실제 로그인 적용 후 소속 부서에 따라 메뉴와 기능이 제한됩니다.</p>
			</section>

			<section class="summary-grid" aria-label="업무 요약">
				<article class="summary-card">
					<div class="card-top">
						<span class="card-label">생산부서</span>
						<span class="icon-box blue material-symbols-outlined">factory</span>
					</div>
					<strong>8</strong>
					<p>진행 중 생산계획</p>
				</article>
				<article class="summary-card">
					<div class="card-top">
						<span class="card-label">구매부서</span>
						<span class="icon-box violet material-symbols-outlined">shopping_cart</span>
					</div>
					<strong>14</strong>
					<p>진행 중 구매 발주</p>
				</article>
				<article class="summary-card">
					<div class="card-top">
						<span class="card-label">자재부서</span>
						<span class="icon-box green material-symbols-outlined">inventory_2</span>
					</div>
					<strong>6</strong>
					<p>오늘 입고 예정</p>
				</article>
				<article class="summary-card">
					<div class="card-top">
						<span class="card-label">협력회사</span>
						<span class="icon-box amber material-symbols-outlined">local_shipping</span>
					</div>
					<strong>3</strong>
					<p>확인 대기 출하 건</p>
				</article>
			</section>

			<section class="content-grid">
				<article class="panel">
					<div class="panel-header">
						<div>
							<p class="eyebrow">WORK QUEUE</p>
							<h2>부서별 처리 대기</h2>
						</div>
						<button class="text-button" type="button">전체보기</button>
					</div>
					<div class="work-list">
						<div class="work-row">
							<span class="work-icon material-symbols-outlined">precision_manufacturing</span>
							<div><strong>생산계획 ERP-260731</strong><p>자재 소요량 확인이 필요합니다.</p></div>
							<span class="status blue">생산</span>
							<time>10:20</time>
						</div>
						<div class="work-row">
							<span class="work-icon material-symbols-outlined">request_quote</span>
							<div><strong>알루미늄 프레임 견적</strong><p>협력회사 3곳의 견적이 도착했습니다.</p></div>
							<span class="status violet">구매</span>
							<time>09:45</time>
						</div>
						<div class="work-row">
							<span class="work-icon material-symbols-outlined">inventory</span>
							<div><strong>PO-2026-071 입고 검수</strong><p>출하 품목 12건이 검수 대기 중입니다.</p></div>
							<span class="status green">자재</span>
							<time>08:30</time>
						</div>
					</div>
				</article>

				<article class="panel compact-panel">
					<div class="panel-header">
						<div>
							<p class="eyebrow">DEADLINE</p>
							<h2>납기 임박</h2>
						</div>
						<span class="material-symbols-outlined">calendar_month</span>
					</div>
					<div class="deadline">
						<strong>D-1</strong>
						<div><p>센서 모듈 120EA</p><span>한빛테크 · PO-2026-068</span></div>
					</div>
					<div class="deadline">
						<strong>D-3</strong>
						<div><p>알루미늄 프레임 40EA</p><span>대성산업 · PO-2026-064</span></div>
					</div>
				</article>
			</section>
		</main>
	</div>
	<script src="${pageContext.request.contextPath}/resources/js/common.js?v=20260731"></script>
</body>
</html>
