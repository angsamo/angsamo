<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>조달업무 생성</title>
	
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
	      rel="stylesheet">
	
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/purchase.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>

<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <main class="workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">PURCHASE</p>
                <h1>조달업무 생성</h1>
            </div>
        </section>

        <c:if test="${not empty error}">
            <p class="purchase-flash error"><c:out value="${error}"/></p>
        </c:if>

        <section class="panel purchase-create-panel">
            <div class="purchase-request-summary">
                <div><span>자재요청</span><strong>MR-${shortage.requestId}</strong></div>
                <div><span>생산계획</span><strong>PP-${shortage.productionPlanId}</strong></div>
                <div><span>요청부서</span><strong><c:out value="${shortage.departmentName}"/></strong></div>
                <div><span>품목</span><strong><c:out value="${shortage.itemCode}"/> · <c:out value="${shortage.itemName}"/></strong></div>
                <div><span>현재고</span><strong>${shortage.currentQty} ${shortage.unit}</strong></div>
                <div><span>조달 필요수량</span><strong class="purchase-shortage-qty">${shortage.shortageQty} ${shortage.unit}</strong></div>
                <div><span>자재 필요일</span><strong>${shortage.requiredDate}</strong></div>
                <div><span>요청자</span><strong><c:out value="${shortage.requestedByName}"/></strong></div>
            </div>

            <form class="purchase-create-form" method="post"
                  action="${pageContext.request.contextPath}/purchase/procurements">

                <input type="hidden"
                       name="materialRequestId"
                       value="${procurementForm.materialRequestId}">

                <label>
                    <span>견적 제출 마감일</span>
                    <input type="date"
                           name="quoteDeadline"
                           value="${procurementForm.quoteDeadline}"
                           min="${today}"
                           max="${shortage.requiredDate}"
                           required>
                    <small>오늘부터 자재 필요일 사이로 지정하세요.</small>
                </label>

                <div class="purchase-form-actions">
                <button class="purchase-action-button" type="submit">
                    조달업무 생성
                </button>

                <a class="purchase-action-button secondary" href="${pageContext.request.contextPath}/purchase/shortages">
                    취소
                </a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
