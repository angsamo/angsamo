<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개발 현황 | 앙사모 ERP</title>
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
        .type-badge { padding:4px 8px; color:#14653f; background:#ddf4e7; border-radius:999px; font-size:11px; font-weight:700; }
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
                <p class="eyebrow">DEVELOPMENT</p>
                <h1>개발 현황</h1>
                <p>품목과 BOM 등록 현황을 한눈에 확인합니다.</p>
            </div>
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/development/items/new">품목 등록</a>
                <a href="${pageContext.request.contextPath}/development/boms/new">BOM 등록</a>
            </div>
        </section>

        <section class="dashboard-grid">
            <div class="metric-card"><p>전체 사용 품목</p><strong><c:out value="${summary.totalItemCount}" /></strong></div>
            <div class="metric-card"><p>완제품</p><strong><c:out value="${summary.productCount}" /></strong></div>
            <div class="metric-card"><p>자재</p><strong><c:out value="${summary.materialCount}" /></strong></div>
            <div class="metric-card"><p>BOM 구성 항목</p><strong><c:out value="${summary.bomCount}" /></strong></div>
            <div class="metric-card warning"><p>BOM 미등록 완제품</p><strong><c:out value="${summary.productWithoutBomCount}" /></strong></div>
        </section>

        <div class="dashboard-panels">
            <section class="panel">
                <div class="panel-header"><div><p class="eyebrow">RECENT ITEMS</p><h2>최근 등록 품목</h2></div><a class="code-link" href="${pageContext.request.contextPath}/development/items">전체 보기</a></div>
                <table class="data-table">
                    <thead><tr><th>품목코드</th><th>품목명</th><th>유형</th><th>등록일</th></tr></thead>
                    <tbody>
                    <c:forEach items="${recentItems}" var="item">
                        <tr>
                            <td><a class="code-link" href="${pageContext.request.contextPath}/development/items/${item.itemId}"><c:out value="${item.itemCode}" /></a></td>
                            <td><c:out value="${item.itemName}" /></td>
                            <td><span class="type-badge"><c:out value="${item.itemType == 'PRODUCT' ? '완제품' : '자재'}" /></span></td>
                            <td><c:out value="${item.createdAt.toLocalDate()}" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentItems}"><tr><td colspan="4" class="empty-cell">등록된 품목이 없습니다.</td></tr></c:if>
                    </tbody>
                </table>
            </section>

            <section class="panel">
                <div class="panel-header"><div><p class="eyebrow">RECENT BOM</p><h2>최근 등록 BOM</h2></div><a class="code-link" href="${pageContext.request.contextPath}/development/boms">전체 보기</a></div>
                <table class="data-table">
                    <thead><tr><th>완제품</th><th>구성 자재</th><th>필요 수량</th></tr></thead>
                    <tbody>
                    <c:forEach items="${recentBoms}" var="bom">
                        <tr>
                            <td><c:out value="${bom.parentItemCode}" /><br><small><c:out value="${bom.parentItemName}" /></small></td>
                            <td><a class="code-link" href="${pageContext.request.contextPath}/development/boms/${bom.bomId}"><c:out value="${bom.componentItemCode}" /></a><br><small><c:out value="${bom.componentItemName}" /></small></td>
                            <td><fmt:formatNumber value="${bom.requiredQty}" minFractionDigits="0" maxFractionDigits="3" groupingUsed="false" /> <c:out value="${bom.componentUnit}" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentBoms}"><tr><td colspan="3" class="empty-cell">등록된 BOM이 없습니다.</td></tr></c:if>
                    </tbody>
                </table>
            </section>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
