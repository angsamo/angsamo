<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>자재 현황 | 앙사모 ERP</title><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css"><link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/material.css">
<style>
    .quick-actions { display:flex; gap:10px; }
    .quick-actions a { padding:9px 13px; color:#fff; background:var(--blue); border-radius:6px; font-size:12px; font-weight:700; }
    .material-dashboard-grid { display:grid; grid-template-columns:repeat(5,minmax(0,1fr)); gap:14px; margin-bottom:18px; }
    .metric-card { padding:20px; background:var(--white); border:1px solid var(--border); border-radius:8px; }
    .metric-card p { margin:0 0 12px; color:var(--muted); font-size:12px; font-weight:700; }
    .metric-card strong { font-size:30px; font-variant-numeric:tabular-nums; }
    .metric-card.warning strong { color:#b42318; }
</style>
</head><body><jsp:include page="/WEB-INF/views/common/sidebar.jsp"/><div class="app-shell"><jsp:include page="/WEB-INF/views/common/header.jsp"/><main class="workspace"><section class="page-heading"><div><p class="eyebrow">MATERIAL</p><h1>자재 현황</h1><p>발주부터 입고, 거래명세서, 발주 마감까지 진행 상태를 확인합니다.</p></div>
<div class="quick-actions"><a href="${pageContext.request.contextPath}/material/receivings">입고 관리</a><a href="${pageContext.request.contextPath}/material/issues">출고 관리</a></div>
</section>
<section class="material-dashboard-grid">
<div class="metric-card"><p>재고 품목</p><strong><c:out value="${summary.totalInventoryItemCount}"/></strong></div>
<div class="metric-card"><p>입고 검수 대기</p><strong><c:out value="${summary.pendingReceivingCount}"/></strong></div>
<div class="metric-card"><p>출고 요청 대기</p><strong><c:out value="${summary.pendingIssueCount}"/></strong></div>
<div class="metric-card warning"><p>재고 부족</p><strong><c:out value="${summary.shortageIssueCount}"/></strong></div>
<div class="metric-card warning"><p>반품 진행 중</p><strong><c:out value="${summary.returnInProgressCount}"/></strong></div>
</section>
<c:if test="${not empty success}"><div class="flash success">${success}</div></c:if><c:if test="${not empty error}"><div class="flash error">${error}</div></c:if><section class="panel table-panel" style="margin-top:16px"><div class="panel-header"><h2>구매 발주 진행 현황</h2><span class="list-count">${orders.size()}건</span></div><div class="table-scroll"><table class="data-table"><thead><tr><th>발주</th><th>품목</th><th>협력회사</th><th>발주/입고</th><th>납기</th><th>상태</th><th>마감</th></tr></thead><tbody><c:forEach items="${orders}" var="row"><tr><td>PO-${row.poId}</td><td>${row.itemName}<br><span class="hint">${row.itemCode}</span></td><td>${row.vendorName}</td><td>${row.orderQty} / ${row.acceptedQty}</td><td>${row.procurementDue}</td><td><my:procurementStatus status="${row.poStatus}" /></td><td><c:choose><c:when test="${row.isClosed == 1}">마감 완료</c:when><c:otherwise><form method="post" action="${pageContext.request.contextPath}/material/orders/close"><input type="hidden" name="poId" value="${row.poId}"><button class="action-button" type="submit">발주 마감</button></form></c:otherwise></c:choose></td></tr></c:forEach><c:if test="${empty orders}"><tr><td colspan="7" class="empty-cell">구매 발주가 없습니다.</td></tr></c:if></tbody></table></div></section></main></div><script src="${pageContext.request.contextPath}/resources/js/common.js"></script></body></html>
