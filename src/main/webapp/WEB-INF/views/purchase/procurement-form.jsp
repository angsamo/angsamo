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
            <p class="flash error"><c:out value="${error}"/></p>
        </c:if>

        <section class="panel">
            <form method="post"
                  action="${pageContext.request.contextPath}/purchase/procurements">

                <input type="hidden"
                       name="materialRequestId"
                       value="${procurementForm.materialRequestId}">

                <p>
                    자재요청 번호:
                    <strong>${procurementForm.materialRequestId}</strong>
                </p>

                <label>
                    견적 제출 마감일
                    <input type="date"
                           name="quoteDeadline"
                           required>
                </label>

                <button class="action-button" type="submit">
                    조달업무 생성
                </button>

                <a href="${pageContext.request.contextPath}/purchase/shortages">
                    취소
                </a>
            </form>
        </section>
    </main>
</div>
</body>
</html>