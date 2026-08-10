<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="대시보드" scope="request"/>
<c:set var="breadcrumb" value="대시보드" scope="request"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:forEach var="s" items="${summary.productionPlanByStatus}"><c:if test="${s.status == 'PLANNED' or s.status == 'IN_PROGRESS'}"><c:set var="productionActive" value="${(empty productionActive ? 0 : productionActive) + s.count}"/></c:if></c:forEach>
<c:forEach var="s" items="${summary.materialRequestByStatus}"><c:if test="${s.status == 'SHORTAGE'}"><c:set var="shortageCount" value="${s.count}"/></c:if></c:forEach>
<c:forEach var="s" items="${summary.procurementByStatus}"><c:if test="${s.status != 'RECEIVED' and s.status != 'CANCELLED' and s.status != 'RETURNED'}"><c:set var="procurementActive" value="${(empty procurementActive ? 0 : procurementActive) + s.count}"/></c:if></c:forEach>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>${projectName}</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${ctx}/resources/css/common.css?v=20260806-1">
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
					<p>전체 부서 현황을 한 화면에서 확인합니다. 소속 부서 항목만 상세로 들어갈 수 있습니다.</p>
				</div>
			</section>

			<section class="summary-grid cols-5" aria-label="업무 요약">
				<article class="summary-card">
					<div class="card-top"><span class="card-label">전체</span><span class="icon-box blue material-symbols-outlined">group</span></div>
					<strong>${summary.totalUsers}</strong>
					<p>전체 사용자 (정지 ${summary.inactiveUsers})</p>
				</article>
				<article class="summary-card">
					<div class="card-top"><span class="card-label">개발부서</span><span class="icon-box blue material-symbols-outlined">category</span></div>
					<strong>${summary.development.productWithoutBomCount}</strong>
					<p>BOM 미등록 완제품</p>
				</article>
				<article class="summary-card">
					<div class="card-top"><span class="card-label">생산부서</span><span class="icon-box green material-symbols-outlined">factory</span></div>
					<strong>${empty productionActive ? 0 : productionActive}</strong>
					<p>진행 중 생산계획</p>
				</article>
				<article class="summary-card">
					<div class="card-top"><span class="card-label">자재부서</span><span class="icon-box amber material-symbols-outlined">inventory_2</span></div>
					<strong>${empty shortageCount ? 0 : shortageCount}</strong>
					<p>부족 처리 대기 자재요청</p>
				</article>
				<article class="summary-card">
					<div class="card-top"><span class="card-label">구매부서</span><span class="icon-box violet material-symbols-outlined">shopping_cart</span></div>
					<strong>${empty procurementActive ? 0 : procurementActive}</strong>
					<p>진행 중 조달업무</p>
				</article>
			</section>

			<section class="content-grid">
				<div style="display:grid; gap:14px;">

					<!-- 개발부서 현황 -->
					<article class="panel">
						<div class="panel-header">
							<div><p class="eyebrow">DEVELOPMENT</p><h2>개발부서 현황</h2></div>
							<c:choose>
								<c:when test="${canViewDevelopment}"><a class="text-button detail-link" href="${ctx}/development/items">상세보기</a></c:when>
								<c:otherwise><span class="list-count">소속 부서만 상세 조회 가능</span></c:otherwise>
							</c:choose>
						</div>
						<div style="padding:16px 18px;">
							<p style="margin:0 0 6px; color:var(--muted); font-size:12px;">품목 구성 (전체 ${summary.development.totalItemCount}건)</p>
							<div class="stack-bar"><c:forEach var="s" items="${summary.developmentItemTypeSegments}"><span class="segment seg-${s.colorClass}" style="width:${s.percent}%" title="${s.label} ${s.count}건"></span></c:forEach></div>
							<div class="stack-legend"><c:forEach var="s" items="${summary.developmentItemTypeSegments}"><span class="legend-item"><i class="dot ${s.colorClass}"></i>${s.label} <strong>${s.count}</strong> <span class="percent">(${s.percent}%)</span></span></c:forEach></div>
						</div>
						<div style="padding:0 18px 16px;">
							<p style="margin:0 0 6px; color:var(--muted); font-size:12px;">완제품 BOM 등록률 (완제품 ${summary.development.productCount}건)</p>
							<div class="stack-bar"><c:forEach var="s" items="${summary.developmentBomSegments}"><span class="segment seg-${s.colorClass}" style="width:${s.percent}%" title="${s.label} ${s.count}건"></span></c:forEach></div>
							<div class="stack-legend"><c:forEach var="s" items="${summary.developmentBomSegments}"><span class="legend-item"><i class="dot ${s.colorClass}"></i>${s.label} <strong>${s.count}</strong> <span class="percent">(${s.percent}%)</span></span></c:forEach></div>
						</div>
						<c:if test="${canViewDevelopment}">
						<div class="table-scroll"><table class="data-table admin-table"><thead><tr><th>품목</th><th>구분</th><th>규격</th><th>단위</th></tr></thead><tbody>
							<c:forEach var="i" items="${summary.recentItems}"><tr><td><c:out value="${i.itemName}"/></td><td>${i.itemType == 'PRODUCT' ? '완제품' : (i.itemType == 'MATERIAL' ? '자재' : i.itemType)}</td><td><c:out value="${i.spec}"/></td><td><c:out value="${i.unit}"/></td></tr></c:forEach>
							<c:if test="${empty summary.recentItems}"><tr><td class="empty-cell" colspan="4">등록된 품목이 없습니다.</td></tr></c:if>
						</tbody></table></div>
						</c:if>
					</article>

					<!-- 생산계획 현황 -->
					<article class="panel">
						<div class="panel-header">
							<div><p class="eyebrow">PRODUCTION</p><h2>생산계획 현황</h2></div>
							<c:choose>
								<c:when test="${canViewProduction}"><a class="text-button detail-link" href="${ctx}/production/plans">상세보기</a></c:when>
								<c:otherwise><span class="list-count">소속 부서만 상세 조회 가능</span></c:otherwise>
							</c:choose>
						</div>
						<c:choose>
							<c:when test="${empty summary.productionPlanByStatus}"><p style="padding:16px 18px; color:var(--muted); font-size:13px;">등록된 생산계획이 없습니다.</p></c:when>
							<c:otherwise>
							<div style="padding:16px 18px;">
								<div class="stack-bar"><c:forEach var="s" items="${summary.productionPlanSegments}"><span class="segment seg-${s.colorClass}" style="width:${s.percent}%" title="${s.label} ${s.count}건"></span></c:forEach></div>
								<div class="stack-legend"><c:forEach var="s" items="${summary.productionPlanSegments}"><span class="legend-item"><i class="dot ${s.colorClass}"></i>${s.label} <strong>${s.count}</strong> <span class="percent">(${s.percent}%)</span><c:if test="${s.stepIndex > 1 and not s.exceptionStatus}"><span class="percent">· 이전 ${s.stepIndex - 1}단계 완료</span></c:if></span></c:forEach></div>
							</div>
							</c:otherwise>
						</c:choose>
						<c:if test="${canViewProduction}">
						<div class="table-scroll"><table class="data-table admin-table"><thead><tr><th>품목</th><th>수량</th><th>상태</th><th>완료예정일</th></tr></thead><tbody>
							<c:forEach var="p" items="${summary.recentProductionPlans}"><tr><td><c:out value="${p.itemName}"/></td><td>${p.productionQtyLabel}</td><td>${p.statusLabel}</td><td><c:out value="${p.dueDate}"/></td></tr></c:forEach>
							<c:if test="${empty summary.recentProductionPlans}"><tr><td class="empty-cell" colspan="4">등록된 생산계획이 없습니다.</td></tr></c:if>
						</tbody></table></div>
						</c:if>
					</article>

					<!-- 자재요청 / 재고 -->
					<article class="panel">
						<div class="panel-header">
							<div><p class="eyebrow">MATERIAL</p><h2>자재요청 현황</h2></div>
							<c:choose>
								<c:when test="${canViewMaterial}"><a class="text-button detail-link" href="${ctx}/material/issues">상세보기</a></c:when>
								<c:otherwise><span class="list-count">소속 부서만 상세 조회 가능</span></c:otherwise>
							</c:choose>
						</div>
						<c:choose>
							<c:when test="${empty summary.materialRequestByStatus}"><p style="padding:16px 18px; color:var(--muted); font-size:13px;">등록된 자재요청이 없습니다.</p></c:when>
							<c:otherwise>
							<div style="padding:16px 18px;">
								<div class="stack-bar"><c:forEach var="s" items="${summary.materialRequestSegments}"><span class="segment seg-${s.colorClass}" style="width:${s.percent}%" title="${s.label} ${s.count}건"></span></c:forEach></div>
								<div class="stack-legend"><c:forEach var="s" items="${summary.materialRequestSegments}"><span class="legend-item"><i class="dot ${s.colorClass}"></i>${s.label} <strong>${s.count}</strong> <span class="percent">(${s.percent}%)</span><c:if test="${s.stepIndex > 1 and not s.exceptionStatus}"><span class="percent">· 이전 ${s.stepIndex - 1}단계 완료</span></c:if></span></c:forEach></div>
							</div>
							</c:otherwise>
						</c:choose>
						<c:if test="${canViewMaterial}">
						<div class="table-scroll"><table class="data-table admin-table"><thead><tr><th>품목</th><th>구분</th><th>수량</th><th>일시</th></tr></thead><tbody>
							<c:forEach var="m" items="${summary.recentStockMovements}"><tr><td><c:out value="${m.itemName}"/></td><td>${m.movementTypeLabel}</td><td>${m.quantityLabel}</td><td><c:out value="${m.createdAtLabel}"/></td></tr></c:forEach>
							<c:if test="${empty summary.recentStockMovements}"><tr><td class="empty-cell" colspan="4">최근 재고변동이 없습니다.</td></tr></c:if>
						</tbody></table></div>
						</c:if>
					</article>

					<!-- 조달업무 / 견적 -->
					<article class="panel">
						<div class="panel-header">
							<div><p class="eyebrow">PURCHASE</p><h2>조달업무 현황</h2></div>
							<c:choose>
								<c:when test="${canViewPurchase}"><a class="text-button detail-link" href="${ctx}/purchase/procurements">상세보기</a></c:when>
								<c:otherwise><span class="list-count">소속 부서만 상세 조회 가능</span></c:otherwise>
							</c:choose>
						</div>
						<c:choose>
							<c:when test="${empty summary.procurementByStatus}"><p style="padding:16px 18px; color:var(--muted); font-size:13px;">등록된 조달업무가 없습니다.</p></c:when>
							<c:otherwise>
							<div style="padding:16px 18px;">
								<div class="stack-bar"><c:forEach var="s" items="${summary.procurementSegments}"><span class="segment seg-${s.colorClass}" style="width:${s.percent}%" title="${s.label} ${s.count}건"></span></c:forEach></div>
								<div class="stack-legend"><c:forEach var="s" items="${summary.procurementSegments}"><span class="legend-item"><i class="dot ${s.colorClass}"></i>${s.label} <strong>${s.count}</strong> <span class="percent">(${s.percent}%)</span><c:if test="${s.stepIndex > 1 and not s.exceptionStatus}"><span class="percent">· 이전 ${s.stepIndex - 1}단계 완료</span></c:if></span></c:forEach></div>
							</div>
							</c:otherwise>
						</c:choose>
						<c:if test="${canViewPurchase}">
						<div class="table-scroll"><table class="data-table admin-table"><thead><tr><th>품목</th><th>수량</th><th>상태</th><th>필요일</th></tr></thead><tbody>
							<c:forEach var="p" items="${summary.recentProcurements}"><tr><td><c:out value="${p.itemName}"/></td><td>${p.requestQtyLabel}</td><td>${p.statusLabel}</td><td><c:out value="${p.requiredDate}"/></td></tr></c:forEach>
							<c:if test="${empty summary.recentProcurements}"><tr><td class="empty-cell" colspan="4">등록된 조달업무가 없습니다.</td></tr></c:if>
						</tbody></table></div>
						</c:if>
						<p style="padding:6px 18px 16px; color:var(--muted); font-size:13px;">제출 대기 중인 협력업체 견적 <strong>${summary.pendingQuoteCount}</strong>건</p>
					</article>
				</div>

				<div style="display:grid; gap:14px;">
					<!-- 부서별 인원 -->
					<article class="panel compact-panel">
						<div class="panel-header">
							<div><p class="eyebrow">ADMIN</p><h2>부서별 인원</h2></div>
							<c:if test="${isAdmin}"><a class="text-button detail-link" href="${ctx}/admin/departments">관리</a></c:if>
						</div>
						<div class="table-scroll"><table class="data-table admin-table"><thead><tr><th>부서</th><th>인원</th></tr></thead><tbody>
							<c:forEach var="d" items="${summary.usersByDepartment}"><tr><td><c:out value="${d.departmentName}"/></td><td>${d.userCount}</td></tr></c:forEach>
						</tbody></table></div>
					</article>

					<!-- 최근 게시글 -->
					<article class="panel compact-panel">
						<div class="panel-header">
							<div><p class="eyebrow">BOARD</p><h2>최근 게시글</h2></div>
							<a class="text-button detail-link" href="${ctx}/boards">게시판</a>
						</div>
						<div class="work-list">
							<c:forEach var="p" items="${summary.recentPosts}">
							<a class="work-row" style="text-decoration:none; color:inherit;" href="${ctx}/boards/${p.boardId}/posts/${p.postId}">
								<span class="work-icon material-symbols-outlined">forum</span>
								<div><strong><c:out value="${p.title}"/></strong><p><c:out value="${p.boardName}"/></p></div>
								<span></span>
								<time><c:out value="${p.createdAtLabel}"/></time>
							</a>
							</c:forEach>
							<c:if test="${empty summary.recentPosts}"><p style="padding:16px 18px; color:var(--muted); font-size:13px;">등록된 게시글이 없습니다.</p></c:if>
						</div>
					</article>
				</div>
			</section>
		</main>
	</div>
	<script src="${ctx}/resources/js/common.js?v=20260731"></script>
</body>
</html>
