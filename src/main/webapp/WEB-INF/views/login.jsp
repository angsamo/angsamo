<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>로그인 | 앙사모 ERP</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
</head>
<body class="login-page">
	<main class="login-card">
		<span class="brand-mark material-symbols-outlined">domain</span>
		<h1>앙사모 ERP</h1>
		<p>계정으로 로그인해 업무를 시작하세요.</p>
		<c:if test="${not empty error}"><div class="login-error"><c:out value="${error}" /></div></c:if>
		<form method="post" action="${pageContext.request.contextPath}/login">
			<label for="loginId">아이디</label>
			<input id="loginId" name="loginId" value="<c:out value='${loginId}' />" autocomplete="username" required autofocus>
			<label for="password">비밀번호</label>
			<input id="password" name="password" type="password" autocomplete="current-password" required>
			<button class="primary-button" type="submit">로그인</button>
		</form>
	</main>
</body>
</html>
