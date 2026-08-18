<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>생산 현황 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <style>
        .dashboard-grid { display:grid; grid-template-columns:repeat(5,minmax(0,1fr)); gap:14px; margin-bottom:18px; }
        .metric-card { padding:20px; background:var(--white); border:1px solid var(--border); border-radius:8px; }
        .metric-card p { margin:0 0 12px; color:var(--muted); font-size:12px; font-weight:700; }
        .metric-card strong { font-size:30px; font-variant-numeric:tabular-nums; }
        .metric-card.warning strong { color:#b42318; }
        .dashboard-panels { display:grid; grid-template-columns:1fr 1fr; gap:18px; }
        .quick-actions { display:flex; gap:10px; }
        .quick-actions a { padding:9px 13px; color:#fff; background:var(--blue); border-radius:6px; font-size:12px; font-weight:700; }
        .data-table { width:100%; border-collapse:collapse; }
        .data-table th,.data-table td { padding:13px 15px; border-bottom:1px solid var(--border); text-align:left; }
        .data-table th { color:var(--muted); background:#f8fafc; font-size:12px; }
        .code-link { color:var(--blue); font-weight:700; }
        .type-badge { padding:4px 8px; border-radius:999px; font-size:11px; font-weight:700; }
        .type-badge.planned { color:#155cb2; background:#e2efff; }
        .type-badge.in-progress { color:#8a5600; background:#fff0d2; }
        .type-badge.completed { color:#14653f; background:#ddf4e7; }
        .type-badge.cancelled { color:#9f1d1d; background:#fff0f0; }
        .type-badge.requested { color:#155cb2; background:#e2efff; }
        .type-badge.shortage { color:#9f1d1d; background:#fff0f0; }
        .type-badge.approved { color:#8a5600; background:#fff0d2; }
        .type-badge.issued { color:#14653f; background:#ddf4e7; }
        .type-badge.rejected { color:#526174; background:#eef2f7; }
        .empty-cell { padding:35px !important; color:var(--muted); text-align:center !important; }
        @media (max-width:1200px) { .dashboard-grid { grid-template-columns:repeat(2,1fr); } }
        @media (max-width:900px) { .dashboard-panels { grid-template-columns:1fr; } }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <main class="workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">PRODUCTION</p>
                <h1>생산 현황</h1>
                <p>생산계획과 자재요청 진행 상황을 한눈에 확인합니다.</p>
            </div>
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/production/plans/new">생산계획 등록</a>
                <a href="${pageContext.request.contextPath}/production/material-requests">자재요청 조회</a>
            </div>
        </section>

        <section class="dashboard-grid">
            <div class="metric-card"><p>전체 생산계획</p><strong><c:out value="${summary.totalPlanCount}" /></strong></div>
            <div class="metric-card"><p>계획</p><strong><c:out value="${summary.plannedCount}" /></strong></div>
            <div class="metric-card"><p>진행 중</p><strong><c:out value="${summary.inProgressCount}" /></strong></div>
            <div class="metric-card"><p>완료</p><strong><c:out value="${summary.completedCount}" /></strong></div>
            <div class="metric-card warning"><p>자재 부족 요청</p><strong><c:out value="${summary.shortageRequestCount}" /></strong></div>
        </section>

        <div class="dashboard-panels">
            <section class="panel">
                <div class="panel-header"><div><p class="eyebrow">RECENT PLANS</p><h2>최근 생산계획</h2></div><a class="code-link" href="${pageContext.request.contextPath}/production/plans">전체 보기</a></div>
                <table class="data-table">
                    <thead><tr><th>품목</th><th>수량</th><th>상태</th><th>등록일</th></tr></thead>
                    <tbody>
                    <c:forEach items="${recentPlans}" var="plan">
                        <tr>
                            <td>
                                <a class="code-link" href="${pageContext.request.contextPath}/production/plans/${plan.productionPlanId}"><c:out value="${plan.itemCode}" /></a>
                                <br><small><c:out value="${plan.itemName}" /></small>
                            </td>
                            <td><fmt:formatNumber value="${plan.productionQty}" minFractionDigits="0" maxFractionDigits="3" groupingUsed="false" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${plan.status == 'PLANNED'}"><span class="type-badge planned">계획</span></c:when>
                                    <c:when test="${plan.status == 'IN_PROGRESS'}"><span class="type-badge in-progress">진행 중</span></c:when>
                                    <c:when test="${plan.status == 'COMPLETED'}"><span class="type-badge completed">완료</span></c:when>
                                    <c:otherwise><span class="type-badge cancelled">취소</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${plan.createdAt.toLocalDate()}" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentPlans}"><tr><td colspan="4" class="empty-cell">등록된 생산계획이 없습니다.</td></tr></c:if>
                    </tbody>
                </table>
            </section>

            <section class="panel">
                <div class="panel-header"><div><p class="eyebrow">RECENT REQUESTS</p><h2>최근 자재요청</h2></div><a class="code-link" href="${pageContext.request.contextPath}/production/material-requests">전체 보기</a></div>
                <table class="data-table">
                    <thead><tr><th>자재</th><th>요청 수량</th><th>상태</th></tr></thead>
                    <tbody>
                    <c:forEach items="${recentRequests}" var="req">
                        <tr>
                            <td>
                                <a class="code-link" href="${pageContext.request.contextPath}/production/material-requests/${req.requestId}"><c:out value="${req.itemCode}" /></a>
                                <br><small><c:out value="${req.itemName}" /></small>
                            </td>
                            <td><fmt:formatNumber value="${req.requestQty}" minFractionDigits="0" maxFractionDigits="3" groupingUsed="false" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${req.status == 'REQUESTED'}"><span class="type-badge requested">요청</span></c:when>
                                    <c:when test="${req.status == 'SHORTAGE'}"><span class="type-badge shortage">재고 부족</span></c:when>
                                    <c:when test="${req.status == 'APPROVED'}"><span class="type-badge approved">승인</span></c:when>
                                    <c:when test="${req.status == 'ISSUED'}"><span class="type-badge issued">불출 완료</span></c:when>
                                    <c:otherwise><span class="type-badge rejected">반려</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentRequests}"><tr><td colspan="3" class="empty-cell">등록된 자재요청이 없습니다.</td></tr></c:if>
                    </tbody>
                </table>
            </section>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
