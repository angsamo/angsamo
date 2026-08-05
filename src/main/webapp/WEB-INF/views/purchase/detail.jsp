<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>협력업체 상세 | 앙사모 ERP</title>
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
                    <h1>협력업체 상세</h1>
                    <p>선택한 협력업체의 등록 정보를 조회합니다.</p>
                </div>
                <a class="primary-button"
                   href="${pageContext.request.contextPath}/purchase/vendors">
                    목록으로
                </a>
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
                        <p class="eyebrow">VENDOR DETAIL</p>
                        <h2><c:out value="${vendor.vendorName}" /></h2>
                    </div>
                    <span class="state-badge ${vendor.active ? 'enabled' : 'disabled'}">
                        ${vendor.active ? '거래 중' : '거래 중지'}
                    </span>
                </div>

                <div class="table-scroll">
                    <table class="data-table">
                        <tbody>
                            <tr>
                                <th>업체 번호</th>
                                <td><c:out value="${vendor.vendorId}" /></td>
                                <th>업체 코드</th>
                                <td><c:out value="${vendor.vendorCode}" /></td>
                            </tr>
                            <tr>
                                <th>업체명</th>
                                <td><c:out value="${vendor.vendorName}" /></td>
                                <th>담당자</th>
                                <td><c:out value="${vendor.contactName}" default="-" /></td>
                            </tr>
                            <tr>
                                <th>연락처</th>
                                <td><c:out value="${vendor.phone}" default="-" /></td>
                                <th>이메일</th>
                                <td><c:out value="${vendor.email}" default="-" /></td>
                            </tr>
                            <tr>
                                <th>주소</th>
                                <td colspan="3"><c:out value="${vendor.address}" default="-" /></td>
                            </tr>
                            <tr>
                                <th>등록일</th>
                                <td><c:out value="${vendor.createdAt}" /></td>
                                <th>수정일</th>
                                <td><c:out value="${vendor.updatedAt}" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
			
			<section class="panel table-panel">
			    <div class="panel-header">
			        <div>
			            <p class="eyebrow">VENDOR ACCOUNT</p>
			            <h2>연결된 로그인 계정</h2>
			        </div>

			        <span class="state-badge ${empty vendorAccounts ? 'disabled' : 'enabled'}">
			            ${empty vendorAccounts ? '계정 미연결' : '계정 연결'}
			        </span>
			    </div>

			    <div class="table-scroll">
			        <table class="data-table">
			            <thead>
			                <tr>
			                    <th>사용자 번호</th>
			                    <th>로그인 아이디</th>
			                    <th>사용자명</th>
			                    <th>권한</th>
			                    <th>계정 상태</th>
			                    <th>등록일</th>
			                </tr>
			            </thead>

			            <tbody>
			                <c:forEach var="account" items="${vendorAccounts}">
			                    <tr>
			                        <td>
			                            <c:out value="${account.userId}"/>
			                        </td>

			                        <td>
			                            <c:out value="${account.loginId}"/>
			                        </td>

			                        <td>
			                            <c:out value="${account.userName}"/>
			                        </td>

			                        <td>
			                            <c:out value="${account.role}"/>
			                        </td>

			                        <td>
			                            <span class="state-badge ${account.active ? 'enabled' : 'disabled'}">
			                                ${account.active ? '사용 중' : '사용 중지'}
			                            </span>
			                        </td>

			                        <td>
			                            <c:out value="${account.createdAt}"/>
			                        </td>
			                    </tr>
			                </c:forEach>

			                <c:if test="${empty vendorAccounts}">
			                    <tr>
			                        <td class="empty-cell" colspan="6">
			                            이 협력업체에 연결된 로그인 계정이 없습니다.
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
