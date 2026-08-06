<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
    <title>구매 진척 관리 | 앙사모 ERP</title>
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
    <section class="page-heading"><div><p class="eyebrow">PURCHASE PROGRESS</p><h1>구매 진척 관리</h1><p>협력회사의 발주 확인, 제작 및 출하 상태와 최근 검수 결과를 조회합니다.</p></div></section>
    <section class="panel table-panel"><div class="panel-header"><div><p class="eyebrow">ORDER STATUS</p><h2>발주별 진행 현황</h2></div><span class="list-count">${progressList.size()}건</span></div>
    <div class="table-scroll"><table class="data-table purchase-wide-table">
        <thead><tr><th>발주</th><th>품목</th><th>협력회사</th><th>발주수량</th><th>요구 납기</th><th>현재 상태</th><th>제작 진척</th><th>납기 진도</th><th>진도율</th><th>발주/출하/입고</th><th>검수결과</th><th>상세</th></tr></thead>
        <tbody>
        <c:forEach items="${progressList}" var="row"><tr>
            <td>PO-${row.procurementId}</td>
            <td><strong><c:out value="${row.itemName}" /></strong><br><small><c:out value="${row.itemCode}" /></small></td>
            <td><c:out value="${row.vendorName}" /></td>
            <td><fmt:formatNumber value="${row.orderQty}" /> <c:out value="${row.unit}" /></td>
            <td>${row.requiredDate}</td>
            <td><span class="state-badge enabled"><c:out value="${row.status}" /></span></td>
            <td><c:out value="${row.makeProgress}" default="미등록" /></td>
            <td><c:out value="${row.deliveryProgress}" default="미등록" /></td>
            <td><c:choose><c:when test="${not empty row.deliveryProgressRate}">${row.deliveryProgressRate}%</c:when><c:otherwise>-</c:otherwise></c:choose></td>
            <td><small class="purchase-date-stack"><span>발주</span>${row.orderedAt}<br><span>출하</span><c:out value="${row.shippedAt}" default="-"/><br><span>입고</span><c:out value="${row.receivedAt}" default="-"/></small></td>
            <td><c:out value="${row.inspectionResult}" default="검수 대기" /></td>
            <td><a class="purchase-action-button" href="${pageContext.request.contextPath}/purchase/procurements/${row.procurementId}">확인</a></td>
        </tr></c:forEach>
        <c:if test="${empty progressList}"><tr><td colspan="12" class="empty-cell">진행 중인 구매 발주가 없습니다.</td></tr></c:if>
        </tbody>
    </table></div></section>
</main></div><script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body></html>
