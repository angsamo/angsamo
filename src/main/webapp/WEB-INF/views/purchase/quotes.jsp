<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>업체별 견적 목록 | 앙사모 ERP</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div class="app-shell">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <main class="workspace">
            <section class="page-heading">
                <div>
                    <p class="eyebrow">PURCHASE</p>
                    <h1>업체별 견적 목록</h1>
                    <p>조달업무별 협력업체 견적 요청과 제출 결과를 조회합니다.</p>
                </div>
            </section>

            <section class="panel table-panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">VENDOR QUOTE</p>
                        <h2>전체 견적</h2>
                    </div>
                    <span class="list-count">총 ${quotes.size()}건</span>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>견적번호</th>
                                <th>조달번호</th>
                                <th>품목코드</th>
                                <th>품목명</th>
                                <th>요청수량</th>
                                <th>업체코드</th>
                                <th>업체명</th>
                                <th>견적상태</th>
                                <th>단가</th>
                                <th>납품 가능일</th>
                                <th>거래조건</th>
                                <th>제출일시</th>
                                <th>등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="quote" items="${quotes}">
                                <tr>
                                    <td><c:out value="${quote.quoteId}" /></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/purchase/procurements/${quote.procurementId}">
                                            <c:out value="${quote.procurementId}" />
                                        </a>
                                    </td>
                                    <td><c:out value="${quote.itemCode}" /></td>
                                    <td><c:out value="${quote.itemName}" /></td>
                                    <td>
                                        <c:out value="${quote.requestQty}" />
                                        <c:out value="${quote.unit}" />
                                    </td>
                                    <td><c:out value="${quote.vendorCode}" /></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/purchase/vendors/${quote.vendorId}">
                                            <c:out value="${quote.vendorName}" />
                                        </a>
                                    </td>
                                    <td><span class="state-badge enabled"><c:out value="${quote.status}" /></span></td>
                                    <td><c:out value="${quote.unitPrice}" default="미제출" /></td>
                                    <td><c:out value="${quote.deliveryDate}" default="미제출" /></td>
                                    <td><c:out value="${quote.terms}" default="-" /></td>
                                    <td><c:out value="${quote.submittedAt}" default="미제출" /></td>
                                    <td><c:out value="${quote.createdAt}" /></td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty quotes}">
                                <tr>
                                    <td class="empty-cell" colspan="13">
                                        등록된 업체 견적이 없습니다.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
