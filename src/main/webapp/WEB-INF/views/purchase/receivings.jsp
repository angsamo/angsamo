<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
    <title>구매 입고 연계 | 앙사모 ERP</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/purchase.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
<div class="app-shell"><jsp:include page="/WEB-INF/views/common/header.jsp" />
<main class="workspace">
    <section class="page-heading"><div><p class="eyebrow">RECEIVING INTEGRATION</p><h1>입고 결과 연계</h1><p>자재부서의 입고 수량과 검수 결과를 확인하고 정상 전량 입고 발주를 마감합니다.</p></div></section>
    <c:if test="${not empty success}"><p class="purchase-flash success"><c:out value="${success}" /></p></c:if>
    <c:if test="${not empty error}"><p class="purchase-flash error"><c:out value="${error}" /></p></c:if>
    <form class="panel purchase-filter-form" method="get">
        <input class="table-search" type="search" name="keyword" value="<c:out value='${keyword}'/>" placeholder="발주번호, 품목, 협력회사 검색">
        <select name="status" aria-label="입고 상태">
            <option value="">전체 상태</option>
            <option value="SHIPPED" ${status == 'SHIPPED' ? 'selected' : ''}>검수 대기</option>
            <option value="RECEIVED" ${status == 'RECEIVED' ? 'selected' : ''}>입고 완료</option>
            <option value="RETURNED" ${status == 'RETURNED' ? 'selected' : ''}>반품</option>
            <option value="CLOSED" ${status == 'CLOSED' ? 'selected' : ''}>마감</option>
        </select>
        <button class="purchase-action-button" type="submit">검색</button>
        <a class="purchase-action-button secondary" href="${pageContext.request.contextPath}/purchase/receivings">초기화</a>
    </form>
    <section class="panel table-panel"><div class="panel-header"><h2>출하·입고 현황</h2><span class="list-count">${receivings.size()}건</span></div>
    <div class="table-scroll"><table class="data-table purchase-wide-table">
        <thead><tr><th>발주</th><th>품목</th><th>협력회사</th><th>발주수량</th><th>입고수량</th><th>현재고</th><th>IN 반영수량</th><th>재고 반영</th><th>검수결과</th><th>출하일시</th><th>입고일시</th><th>IN 기록일시</th><th>상태</th><th>마감</th></tr></thead>
        <tbody><c:forEach items="${receivings}" var="row"><tr>
            <td>PO-${row.procurementId}</td><td><strong><c:out value="${row.itemName}" /></strong><br><small><c:out value="${row.itemCode}" /></small></td>
            <td><c:out value="${row.vendorName}" /></td><td><fmt:formatNumber value="${row.orderQty}" /> ${row.unit}</td>
            <td class="purchase-number"><fmt:formatNumber value="${row.receivedQty}" /> ${row.unit}</td>
            <td class="purchase-number"><fmt:formatNumber value="${row.inventoryQty}" /> ${row.unit}</td>
            <td class="purchase-number"><fmt:formatNumber value="${row.movementQty}" /> ${row.unit}</td>
            <td><span class="state-badge purchase-status ${row.inventoryApplied ? 'received' : 'returned'}">${row.inventoryApplied ? '반영 완료' : '미확인'}</span></td>
            <td><c:out value="${row.inspectionResult}" default="검수 대기" /></td>
            <td><c:out value="${row.shippedAt}" default="-" /></td><td><c:out value="${row.receivedAt}" default="-" /></td><td><c:out value="${row.movementAt}" default="-" /></td>
            <td><span class="state-badge purchase-status ${fn:toLowerCase(row.status)}"><c:out value="${row.status}" /></span></td>
            <td><c:choose><c:when test="${row.readyToClose}"><form method="post" action="${pageContext.request.contextPath}/purchase/procurements/${row.procurementId}/close" onsubmit="return confirm('정상 입고를 확인하고 발주를 마감하시겠습니까?');"><button class="purchase-action-button" type="submit">발주 마감</button></form></c:when><c:when test="${row.status == 'CLOSED'}"><span class="state-badge enabled">마감 완료</span></c:when><c:otherwise>마감 불가</c:otherwise></c:choose></td>
        </tr></c:forEach><c:if test="${empty receivings}"><tr><td colspan="14" class="empty-cell">출하·입고 연계 건이 없습니다.</td></tr></c:if></tbody>
    </table></div></section>
</main></div><script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body></html>
