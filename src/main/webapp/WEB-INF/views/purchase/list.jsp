<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>협력업체 목록 | 앙사모 ERP</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

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
                    <h1>협력업체 목록</h1>
                    <p>구매 업무에 등록된 협력업체 정보를 조회합니다.</p>
                </div>
				
				<a class="action-button"
					   href="${pageContext.request.contextPath}/purchase/vendors/new">
					    협력업체 등록
				</a>
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
            <form class="panel purchase-filter-form" method="get">
                <input class="table-search" type="search" name="keyword" value="<c:out value='${keyword}'/>" placeholder="업체 코드, 업체명, 담당자 검색">
                <select name="active" aria-label="거래 상태">
                    <option value="" ${empty active ? 'selected' : ''}>전체 상태</option>
                    <option value="true" ${active == true ? 'selected' : ''}>거래 중</option>
                    <option value="false" ${active == false ? 'selected' : ''}>거래 중지</option>
                </select>
                <button class="purchase-action-button" type="submit">검색</button>
                <a class="purchase-action-button secondary" href="${pageContext.request.contextPath}/purchase/vendors">초기화</a>
            </form>

            <section class="panel table-panel">
                <div class="panel-header">
                    <div>
                        <p class="eyebrow">VENDOR LIST</p>
                        <h2>전체 협력업체</h2>
                    </div>

                    <span class="list-count">
                        총 ${vendors.size()}개
                    </span>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>업체 코드</th>
                                <th>업체명</th>
                                <th>담당자</th>
                                <th>연락처</th>
                                <th>이메일</th>
                                <th>거래 상태</th>
                                <th>등록일</th>
								<th>관리</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="vendor" items="${vendors}">
                                <tr>
                                    <td>
                                        <c:out value="${vendor.vendorId}" />
                                    </td>

                                    <td>
                                        <c:out value="${vendor.vendorCode}" />
                                    </td>

                                    <td>
                                        <a href="${pageContext.request.contextPath}/purchase/vendors/${vendor.vendorId}">
                                            <c:out value="${vendor.vendorName}" />
                                        </a>
                                    </td>

                                    <td>
                                        <c:out value="${vendor.contactName}" />
                                    </td>

                                    <td>
                                        <c:out value="${vendor.phone}" />
                                    </td>

                                    <td>
                                        <c:out value="${vendor.email}" />
                                    </td>

                                    <td>
                                        <span class="state-badge ${vendor.active ? 'enabled' : 'disabled'}">
                                            ${vendor.active ? '거래 중' : '거래 중지'}
                                        </span>
                                    </td>

									<td>
									    <c:out value="${vendor.createdAt}" />
									</td>

									<td>
									    <a href="${pageContext.request.contextPath}/purchase/vendors/${vendor.vendorId}/edit">
									        수정
									    </a>

									    <c:if test="${vendor.active}">
									        <form method="post"
									              action="${pageContext.request.contextPath}/purchase/vendors/${vendor.vendorId}/deactivate"
									              style="display:inline"
									              onsubmit="return confirm('거래를 중지하시겠습니까?');">

									            <button type="submit">거래 중지</button>
									        </form>
									    </c:if>
									</td>
									</tr>
                            </c:forEach>

                            <c:if test="${empty vendors}">
                                <tr>
                                    <td class="empty-cell" colspan="9">
                                        등록된 협력업체가 없습니다.
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
