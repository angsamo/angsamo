<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>협력업체 등록·수정</title>
	
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

	<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
	      rel="stylesheet">
	
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>

<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>

    <main class="workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">PURCHASE</p>
                <h1>${empty vendorId ? '협력업체 등록' : '협력업체 수정'}</h1>
            </div>
        </section>

        <c:if test="${not empty error}">
            <p class="flash error"><c:out value="${error}"/></p>
        </c:if>
		
		<spring:hasBindErrors name="vendorForm">
		    <div class="flash error">
		        <c:forEach var="validationError"
		                   items="${errors.allErrors}">
		            <p>
		                <c:out value="${validationError.defaultMessage}"/>
		            </p>
		        </c:forEach>
		    </div>
		</spring:hasBindErrors>

        <section class="panel">
            <form method="post"
                  action="${pageContext.request.contextPath}/purchase/vendors${empty vendorId ? '' : '/'.concat(vendorId)}">

                <label>
                    업체코드
                    <input name="vendorCode"
                           maxlength="30"
                           required
                           value="<c:out value='${vendorForm.vendorCode}'/>">
                </label>

                <label>
                    업체명
                    <input name="vendorName"
                           maxlength="100"
                           required
                           value="<c:out value='${vendorForm.vendorName}'/>">
                </label>

                <label>
                    담당자
                    <input name="contactName"
                           maxlength="100"
                           value="<c:out value='${vendorForm.contactName}'/>">
                </label>

                <label>
                    연락처
                    <input name="phone"
                           maxlength="30"
                           value="<c:out value='${vendorForm.phone}'/>">
                </label>

                <label>
                    이메일
                    <input type="email"
                           name="email"
                           maxlength="150"
                           value="<c:out value='${vendorForm.email}'/>">
                </label>

                <label>
                    주소
                    <input name="address"
                           maxlength="300"
                           value="<c:out value='${vendorForm.address}'/>">
                </label>

                <c:if test="${not empty vendorId}">
                    <label>
                        거래 상태
                        <select name="active">
                            <option value="true"
                                ${vendorForm.active ? 'selected' : ''}>
                                거래 중
                            </option>
                            <option value="false"
                                ${!vendorForm.active ? 'selected' : ''}>
                                거래 중지
                            </option>
                        </select>
                    </label>
                </c:if>

                <button class="action-button" type="submit">저장</button>

                <a href="${pageContext.request.contextPath}/purchase/vendors">
                    취소
                </a>
            </form>
        </section>
    </main>
</div>
</body>
</html>