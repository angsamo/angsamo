<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/purchase.css">
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

            <c:if test="${not empty success}">
                <p class="purchase-flash success"><c:out value="${success}" /></p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="purchase-flash error"><c:out value="${error}" /></p>
            </c:if>

            <form class="panel purchase-filter-form" method="get">
                <input class="table-search" type="search" name="keyword" value="<c:out value='${keyword}'/>" placeholder="견적·조달번호, 품목, 업체 검색">
                <select name="status" aria-label="견적 상태">
                    <option value="">전체 상태</option>
                    <option value="REQUESTED" ${status == 'REQUESTED' ? 'selected' : ''}>제출 대기</option>
                    <option value="SUBMITTED" ${status == 'SUBMITTED' ? 'selected' : ''}>제출 완료</option>
                    <option value="SELECTED" ${status == 'SELECTED' ? 'selected' : ''}>선정</option>
                    <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>미선정</option>
                </select>
                <button class="purchase-action-button" type="submit">검색</button>
                <a class="purchase-action-button secondary" href="${pageContext.request.contextPath}/purchase/quotes">초기화</a>
            </form>

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
                                <th>예상 총액</th>
                                <th>납품 가능일</th>
                                <th>자재 필요일</th>
                                <th>납기 판정</th>
                                <th>거래조건</th>
                                <th>제출일시</th>
                                <th>등록일</th>
                                <th>업체 선정</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="quote" items="${quotes}">
                                <tr class="${quote.status == 'SELECTED' ? 'purchase-selected-quote' : ''}">
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
                                    <td><span class="state-badge purchase-status ${fn:toLowerCase(quote.status)}"><c:out value="${quote.status}" /></span></td>
                                    <td class="purchase-number"><c:out value="${quote.unitPrice}" default="미제출" /></td>
                                    <td class="purchase-number"><c:out value="${quote.totalPrice}" default="미제출" /></td>
                                    <td><c:out value="${quote.deliveryDate}" default="미제출" /></td>
                                    <td><c:out value="${quote.requiredDate}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty quote.deliveryDate}">-</c:when>
                                            <c:when test="${quote.deliveryDate le quote.requiredDate}"><span class="state-badge purchase-status received">납기 가능</span></c:when>
                                            <c:otherwise><span class="state-badge purchase-status returned">납기 지연</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${quote.terms}" default="-" /></td>
                                    <td><c:out value="${quote.submittedAt}" default="미제출" /></td>
                                    <td><c:out value="${quote.createdAt}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${quote.status == 'SUBMITTED' and quote.procurementStatus == 'QUOTING'}">
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/purchase/procurements/${quote.procurementId}/quotes/${quote.quoteId}/select"
                                                      onsubmit="return confirm('이 협력업체의 견적을 선정하시겠습니까?');">
                                                    <button class="purchase-action-button" type="submit">선정</button>
                                                </form>
                                            </c:when>
                                            <c:when test="${quote.status == 'SELECTED'}">
                                                <span class="state-badge enabled">선정 완료</span>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty quotes}">
                                <tr>
                                    <td class="empty-cell" colspan="17">
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
