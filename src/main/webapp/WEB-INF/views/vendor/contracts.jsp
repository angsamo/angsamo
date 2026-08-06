<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>협력회사 계약 관리 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&amp;family=Noto+Sans+KR:wght@400;500;600;700&amp;display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/vendor.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <main class="workspace vendor-workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">VENDOR CONTRACT</p>
                <h1>계약 관리</h1>
                <p>구매부서에서 확정한 내 회사 계약조건을 조회합니다.</p>
            </div>
        </section>
        <section class="vendor-card-grid">
            <c:forEach items="${contracts}" var="contract">
                <article class="panel vendor-card">
                    <header>
                        <div>
                            <p class="vendor-code">계약 CT-${contract.procurementId}</p>
                            <h2><c:out value="${contract.itemName}" /> <small><c:out value="${contract.itemCode}" /></small></h2>
                        </div>
                        <span class="vendor-status status-CONTRACTED">계약 확정</span>
                    </header>
                    <dl class="vendor-facts">
                        <div><dt>계약 수량</dt><dd><fmt:formatNumber value="${contract.orderQty}" /> <c:out value="${contract.unit}" /></dd></div>
                        <div><dt>계약 단가</dt><dd><fmt:formatNumber value="${contract.unitPrice}" pattern="#,#00.##" /></dd></div>
                        <div><dt>요구 납기일</dt><dd>${contract.requiredDate}</dd></div>
                        <div><dt>협력회사</dt><dd><c:out value="${contract.vendorName}" /></dd></div>
                    </dl>
                    <div class="vendor-submitted">
                        <span>확정 거래조건 <strong><c:out value="${contract.terms}" /></strong></span>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty contracts}">
                <div class="panel vendor-empty">
                    <span class="material-symbols-outlined">contract</span>
                    <h2>확정된 계약이 없습니다.</h2>
                    <p>구매부서에서 계약을 확정하면 이곳에 표시됩니다.</p>
                </div>
            </c:if>
        </section>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
