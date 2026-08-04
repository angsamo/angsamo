<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>사용자 관리 | 앙사모 ERP</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css?v=20260803-1">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
	<div class="app-shell">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />

		<main class="workspace">
			<section class="page-heading">
				<div>
					<p class="eyebrow">ADMIN</p>
					<h1>사용자 관리</h1>
					<p>등록된 사용자와 소속 부서, 권한 상태를 확인합니다.</p>
				</div>
			</section>

			<section class="panel table-panel">
				<div class="panel-header">
					<div>
						<p class="eyebrow">USER LIST</p>
						<h2>전체 사용자</h2>
					</div>
					<span class="list-count">총 ${users.size()}명</span>
				</div>

				<div class="table-scroll">
					<table class="data-table">
						<thead>
							<tr>
								<th>번호</th>
								<th>로그인 아이디</th>
								<th>사용자명</th>
								<th>소속</th>
								<th>권한</th>
								<th>상태</th>
								<th>등록일</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="user" items="${users}">
								<tr>
									<td>${user.userId}</td>
									<td><c:out value="${user.loginId}" /></td>
									<td><c:out value="${user.userName}" /></td>
									<td>
										<c:choose>
											<c:when test="${not empty user.departmentName}"><c:out value="${user.departmentName}" /></c:when>
											<c:when test="${not empty user.vendorId}">협력업체 <c:out value="${user.vendorId}" /></c:when>
											<c:otherwise>전체</c:otherwise>
										</c:choose>
									</td>
									<td><span class="role-badge"><c:out value="${user.role}" /></span></td>
									<td><span class="state-badge ${user.active ? 'enabled' : 'disabled'}">${user.active ? '사용' : '중지'}</span></td>
									<td><c:out value="${user.createdAt}" /></td>
								</tr>
							</c:forEach>
							<c:if test="${empty users}">
								<tr><td class="empty-cell" colspan="7">등록된 사용자가 없습니다.</td></tr>
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
