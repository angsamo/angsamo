<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>부서 관리 | 앙사모 ERP</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
	<div class="app-shell">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />

		<main class="workspace">
			<section class="page-heading">
				<div>
					<p class="eyebrow">ADMIN</p>
					<h1>부서 관리</h1>
					<p>프로젝트에서 사용하는 부서 코드와 사용 상태를 확인합니다.</p>
				</div>
			</section>

			<section class="panel table-panel">
				<div class="panel-header">
					<div><p class="eyebrow">DEPARTMENT LIST</p><h2>전체 부서</h2></div>
					<span class="list-count">총 ${departments.size()}개</span>
				</div>
				<div class="table-scroll">
					<table class="data-table">
						<thead><tr><th>번호</th><th>부서 코드</th><th>부서명</th><th>상태</th><th>등록일</th></tr></thead>
						<tbody>
							<c:forEach var="department" items="${departments}">
								<tr>
									<td>${department.departmentId}</td>
									<td><c:out value="${department.departmentCode}" /></td>
									<td><c:out value="${department.departmentName}" /></td>
									<td><span class="state-badge ${department.active ? 'enabled' : 'disabled'}">${department.active ? '사용' : '중지'}</span></td>
									<td><c:out value="${department.createdAt}" /></td>
								</tr>
							</c:forEach>
							<c:if test="${empty departments}"><tr><td class="empty-cell" colspan="5">등록된 부서가 없습니다.</td></tr></c:if>
						</tbody>
					</table>
				</div>
			</section>
		</main>
	</div>
	<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
