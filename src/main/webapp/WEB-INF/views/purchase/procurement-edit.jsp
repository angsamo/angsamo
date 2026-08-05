<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>조달업무 수정 | 앙사모 ERP</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

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
                    <h1>조달업무 수정</h1>
                    <p>
                        조달번호
                        <c:out value="${procurement.procurementId}"/>
                    </p>
                </div>

                <a class="action-button"
                   href="${pageContext.request.contextPath}/purchase/procurements/${procurement.procurementId}">
                    취소
                </a>
            </section>

            <c:if test="${not empty error}">
                <p class="flash error">
                    <c:out value="${error}"/>
                </p>
            </c:if>

            <section class="panel">
                <form method="post"
                      action="${pageContext.request.contextPath}/purchase/procurements/${procurement.procurementId}/edit">

                    <div>
                        <label>품목코드</label>
                        <input type="text"
                               value="<c:out value='${procurement.itemCode}'/>"
                               readonly>
                    </div>

                    <div>
                        <label>품목명</label>
                        <input type="text"
                               value="<c:out value='${procurement.itemName}'/>"
                               readonly>
                    </div>

                    <div>
                        <label>요청수량</label>
                        <input type="text"
                               value="<c:out value='${procurement.requestQty}'/> <c:out value='${procurement.unit}'/>"
                               readonly>
                    </div>

                    <div>
                        <label>자재 필요일</label>
                        <input type="date"
                               value="${procurement.requiredDate}"
                               readonly>
                    </div>

                    <div>
                        <label for="quoteDeadline">
                            견적 제출 마감일
                        </label>

                        <input id="quoteDeadline"
                               type="date"
                               name="quoteDeadline"
                               value="${procurement.quoteDeadline}"
                               max="${procurement.requiredDate}"
                               required>
                    </div>

                    <div>
                        <label for="terms">
                            전달사항·계약조건
                        </label>

                        <textarea id="terms"
                                  name="terms"
                                  maxlength="1000"
                                  rows="6"><c:out value="${procurement.terms}"/></textarea>
                    </div>

                    <div>
                        <button class="action-button" type="submit">
                            수정 내용 저장
                        </button>

                        <a href="${pageContext.request.contextPath}/purchase/procurements/${procurement.procurementId}">
                            취소
                        </a>
                    </div>
                </form>
            </section>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>