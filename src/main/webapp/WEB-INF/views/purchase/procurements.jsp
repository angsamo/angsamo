<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>조달업무 목록 | 앙사모 ERP</title>
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
                    <h1>조달업무 목록</h1>
                    <p>자재요청을 기반으로 생성된 조달업무의 진행 상태를 조회합니다.</p>
                </div>
            </section>
			
			<c:if test="${not empty success}">
							    <p class="flash success">
							        <c:out value="${success}"/>
							    </p>
							</c:if>

							<c:if test="${not empty error}">
							    <p class="flash error">
							        <c:out value="${error}"/>
							    </p>
							</c:if>

            <section class="panel table-panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">PROCUREMENT LIST</p>
                        <h2>전체 조달업무</h2>
                    </div>
                    <span class="list-count">총 ${procurements.size()}건</span>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>조달번호</th>
                                <th>요청번호</th>
                                <th>생산계획번호</th>
                                <th>담당부서</th>
                                <th>품목코드</th>
                                <th>품목명</th>
                                <th>요청수량</th>
                                <th>필요일</th>
                                <th>견적마감일</th>
                                <th>선정업체</th>
                                <th>발주수량</th>
                                <th>단가</th>
                                <th>입고수량</th>
                                <th>진행상태</th>
                                <th>등록자</th>
                                <th>등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="procurement" items="${procurements}">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/purchase/procurements/${procurement.procurementId}">
                                            <c:out value="${procurement.procurementId}" />
                                        </a>
                                    </td>
                                    <td><c:out value="${procurement.materialRequestId}" default="-" /></td>
                                    <td><c:out value="${procurement.productionPlanId}" default="-" /></td>
                                    <td><c:out value="${procurement.departmentName}" /></td>
                                    <td><c:out value="${procurement.itemCode}" /></td>
                                    <td><c:out value="${procurement.itemName}" /></td>
                                    <td>
                                        <c:out value="${procurement.requestQty}" />
                                        <c:out value="${procurement.unit}" />
                                    </td>
                                    <td><c:out value="${procurement.requiredDate}" /></td>
                                    <td><c:out value="${procurement.quoteDeadline}" default="-" /></td>
                                    <td><c:out value="${procurement.selectedVendorName}" default="미선정" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty procurement.orderQty}">
                                                <c:out value="${procurement.orderQty}" />
                                                <c:out value="${procurement.unit}" />
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${procurement.unitPrice}" default="-" /></td>
                                    <td>
                                        <c:out value="${procurement.receivedQty}" />
                                        <c:out value="${procurement.unit}" />
                                    </td>
                                    <td><span class="state-badge enabled"><c:out value="${procurement.status}" /></span></td>
                                    <td><c:out value="${procurement.createdByName}" /></td>
                                    <td><c:out value="${procurement.createdAt}" /></td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty procurements}">
                                <tr>
                                    <td class="empty-cell" colspan="16">
                                        등록된 조달업무가 없습니다.
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
