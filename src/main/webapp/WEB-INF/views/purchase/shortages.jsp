<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>부족 자재요청 목록 | 앙사모 ERP</title>
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
                    <h1>부족 자재요청 목록</h1>
                    <p>생산 자재요청의 잔여 수량과 현재 재고를 비교해 부족 수량을 조회합니다.</p>
                </div>
            </section>
			
			<c:if test="${not empty success}">
			    <p class="purchase-flash success">
			        <c:out value="${success}"/>
			    </p>
			</c:if>

			<c:if test="${not empty error}">
			    <p class="purchase-flash error">
			        <c:out value="${error}"/>
			    </p>
			</c:if>

            <section class="panel table-panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">SHORTAGE REQUEST</p>
                        <h2>조달 검토 대상</h2>
                    </div>
                    <span class="list-count">총 ${shortages.size()}건</span>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>요청번호</th>
                                <th>생산계획번호</th>
                                <th>요청부서</th>
                                <th>품목코드</th>
                                <th>품목명</th>
                                <th>요청수량</th>
                                <th>불출수량</th>
                                <th>현재고</th>
                                <th>부족수량</th>
                                <th>필요일</th>
                                <th>요청일</th>
                                <th>요청자</th>
                                <th>상태</th>
								<th>조달업무</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="shortage" items="${shortages}">
                                <tr>
                                    <td><c:out value="${shortage.requestId}" /></td>
                                    <td><c:out value="${shortage.productionPlanId}" /></td>
                                    <td><c:out value="${shortage.departmentName}" /></td>
                                    <td><c:out value="${shortage.itemCode}" /></td>
                                    <td><c:out value="${shortage.itemName}" /></td>
                                    <td class="purchase-number">
                                        <c:out value="${shortage.requestQty}" />
                                        <c:out value="${shortage.unit}" />
                                    </td>
                                    <td class="purchase-number">
                                        <c:out value="${shortage.issuedQty}" />
                                        <c:out value="${shortage.unit}" />
                                    </td>
                                    <td class="purchase-number">
                                        <c:out value="${shortage.currentQty}" />
                                        <c:out value="${shortage.unit}" />
                                    </td>
                                    <td class="purchase-number purchase-shortage-qty">
                                        <c:out value="${shortage.shortageQty}" />
                                        <c:out value="${shortage.unit}" />
                                    </td>
                                    <td><c:out value="${shortage.requiredDate}" /></td>
                                    <td><c:out value="${shortage.createdAt}" /></td>
                                    <td><c:out value="${shortage.requestedByName}" /></td>
                                    <td><span class="state-badge purchase-status returned">재고 부족</span></td>
									<td>
									    <a class="purchase-action-button"
									       href="${pageContext.request.contextPath}/purchase/shortages/${shortage.requestId}/procurement">
									        생성
									    </a>
									</td>
                                </tr>
                            </c:forEach>
							
							<c:if test="${empty shortages}">
							    <tr>
						        <td class="empty-cell" colspan="14">
						            자재부서에서 재고 부족으로 확인된 요청이 없습니다.
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
