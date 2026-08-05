<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>조달업무 상세 | 앙사모 ERP</title>
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
                    <h1>조달업무 상세</h1>
                    <p>조달번호 <c:out value="${procurement.procurementId}" />의 진행 정보를 조회합니다.</p>
                </div>
				
                <a class="primary-button"
                   href="${pageContext.request.contextPath}/purchase/procurements">
                    목록으로
                </a>
				
				<c:if test="${procurement.status == 'REQUESTED'}">
				    <a class="action-button"
				       href="${pageContext.request.contextPath}/purchase/procurements/${procurement.procurementId}/edit">
				        수정
				    </a>
				</c:if>
            </section>

            <section class="panel table-panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">PROCUREMENT</p>
                        <h2><c:out value="${procurement.itemName}" /></h2>
                    </div>
                    <span class="state-badge enabled"><c:out value="${procurement.status}" /></span>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <tbody>
                            <tr>
                                <th>조달번호</th>
                                <td><c:out value="${procurement.procurementId}" /></td>
                                <th>담당부서</th>
                                <td><c:out value="${procurement.departmentName}" /></td>
                            </tr>
                            <tr>
                                <th>품목코드</th>
                                <td><c:out value="${procurement.itemCode}" /></td>
                                <th>품목명</th>
                                <td><c:out value="${procurement.itemName}" /></td>
                            </tr>
                            <tr>
                                <th>규격</th>
                                <td><c:out value="${procurement.spec}" default="-" /></td>
                                <th>단위</th>
                                <td><c:out value="${procurement.unit}" /></td>
                            </tr>
                            <tr>
                                <th>요청수량</th>
                                <td>
                                    <c:out value="${procurement.requestQty}" />
                                    <c:out value="${procurement.unit}" />
                                </td>
                                <th>필요일</th>
                                <td><c:out value="${procurement.requiredDate}" /></td>
                            </tr>
                            <tr>
                                <th>견적마감일</th>
                                <td><c:out value="${procurement.quoteDeadline}" default="-" /></td>
                                <th>원본 자재요청번호</th>
                                <td><c:out value="${procurement.materialRequestId}" default="없음" /></td>
                            </tr>
                            <c:if test="${not empty procurement.materialRequestId}">
                                <tr>
                                    <th>자재요청 상태</th>
                                    <td><c:out value="${procurement.materialRequestStatus}" /></td>
                                    <th>자재요청 수량 / 불출수량</th>
                                    <td>
                                        <c:out value="${procurement.materialRequestQty}" /> /
                                        <c:out value="${procurement.materialRequestIssuedQty}" />
                                        <c:out value="${procurement.unit}" />
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
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

				<c:if test="${procurement.status == 'REQUESTED'}">
				    <section class="panel">
				        <div class="panel-header">
				            <div>
				                <p class="eyebrow">QUOTE REQUEST</p>
				                <h2>협력업체 견적 요청</h2>
				            </div>
				        </div>

				        <form method="post"
				              action="${pageContext.request.contextPath}/purchase/procurements/${procurement.procurementId}/quotes">

				            <c:forEach var="vendor" items="${vendors}">
				                <label class="vendor-check">
				                    <input type="checkbox"
				                           name="vendorIds"
				                           value="${vendor.vendorId}">

				                    <span>
				                        <c:out value="${vendor.vendorCode}"/>
				                        -
				                        <c:out value="${vendor.vendorName}"/>
				                    </span>
				                </label>
				            </c:forEach>

				            <c:if test="${empty vendors}">
				                <p>거래 중인 협력업체가 없습니다.</p>
				            </c:if>

				            <c:if test="${not empty vendors}">
				                <button class="action-button" type="submit">
				                    선택 업체에 견적 요청
				                </button>
				            </c:if>
				        </form>
				    </section>

				    <form method="post"
				          action="${pageContext.request.contextPath}/purchase/procurements/${procurement.procurementId}/cancel"
				          onsubmit="return confirm('조달업무를 취소하시겠습니까?');">

				        <button type="submit">조달업무 취소</button>
				    </form>
				</c:if>

           		<section class="panel table-panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">VENDOR &amp; ORDER</p>
                        <h2>선정업체 및 발주</h2>
                    </div>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <tbody>
                            <tr>
                                <th>선정업체 코드</th>
                                <td><c:out value="${procurement.selectedVendorCode}" default="미선정" /></td>
                                <th>선정업체명</th>
                                <td><c:out value="${procurement.selectedVendorName}" default="미선정" /></td>
                            </tr>
                            <tr>
                                <th>업체 담당자</th>
                                <td><c:out value="${procurement.selectedVendorContactName}" default="-" /></td>
                                <th>업체 연락처</th>
                                <td><c:out value="${procurement.selectedVendorPhone}" default="-" /></td>
                            </tr>
                            <tr>
                                <th>업체 이메일</th>
                                <td><c:out value="${procurement.selectedVendorEmail}" default="-" /></td>
                                <th>발주수량</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty procurement.orderQty}">
                                            <c:out value="${procurement.orderQty}" />
                                            <c:out value="${procurement.unit}" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>단가</th>
                                <td><c:out value="${procurement.unitPrice}" default="-" /></td>
                                <th>입고수량</th>
                                <td>
                                    <c:out value="${procurement.receivedQty}" />
                                    <c:out value="${procurement.unit}" />
                                </td>
                            </tr>
                            <tr>
                                <th>발주일시</th>
                                <td><c:out value="${procurement.orderedAt}" default="-" /></td>
                                <th>출하일시</th>
                                <td><c:out value="${procurement.shippedAt}" default="-" /></td>
                            </tr>
                            <tr>
                                <th>입고일시</th>
                                <td><c:out value="${procurement.receivedAt}" default="-" /></td>
                                <th>검수결과</th>
                                <td><c:out value="${procurement.inspectionResult}" default="-" /></td>
                            </tr>
                            <tr>
                                <th>계약조건</th>
                                <td colspan="3"><c:out value="${procurement.terms}" default="-" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="panel table-panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">AUDIT</p>
                        <h2>등록 정보</h2>
                    </div>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <tbody>
                            <tr>
                                <th>등록자</th>
                                <td><c:out value="${procurement.createdByName}" /></td>
                                <th>등록일</th>
                                <td><c:out value="${procurement.createdAt}" /></td>
                            </tr>
                            <tr>
                                <th>수정일</th>
                                <td colspan="3"><c:out value="${procurement.updatedAt}" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
