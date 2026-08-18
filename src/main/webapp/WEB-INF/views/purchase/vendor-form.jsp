<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>${empty vendorId ? '협력업체 등록' : '협력업체 수정'} | 앙사모 ERP</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .form-panel { max-width: 960px; }
        .form-body { padding: 22px; }
        .form-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 20px; }
        .form-field { display: flex; flex-direction: column; gap: 8px; }
        .form-field.full-width { grid-column: 1 / -1; }
        .form-field label { color: var(--text); font-size: 13px; font-weight: 700; }
        .required { margin-left: 3px; color: #d42424; }
        .form-field input, .form-field select { width: 100%; height: 42px; padding: 0 12px; color: var(--text); background: var(--white); border: 1px solid var(--border); border-radius: 5px; outline: none; transition: 150ms ease; }
        .form-field input:hover, .form-field select:hover { border-color: #aab6c5; }
        .form-field input:focus, .form-field select:focus { border-color: var(--blue); box-shadow: 0 0 0 3px rgba(18, 103, 214, 0.12); }
        .field-help { margin: 0; color: var(--muted); font-size: 11px; }
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 24px; padding-top: 18px; border-top: 1px solid var(--border); }
        .secondary-button { display: inline-flex; height: 40px; align-items: center; justify-content: center; gap: 7px; padding: 0 16px; color: var(--text); background: var(--white); border: 1px solid var(--border); border-radius: 5px; font-weight: 700; cursor: pointer; }
        .secondary-button:hover { color: var(--blue); border-color: var(--blue); background: #f8fbff; }
        .error-notice { color: #9f1d1d; background: #fff0f0; border-color: #f1b8b8; }
        @media (max-width: 760px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-field.full-width { grid-column: auto; }
            .form-actions { flex-direction: column-reverse; }
            .form-actions > * { width: 100%; }
        }
    </style>
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
                <p>협력업체 기본정보와 거래 상태를 관리합니다.</p>
            </div>
        </section>

        <c:if test="${not empty error}">
            <div class="notice error-notice">
                <span class="material-symbols-outlined">error</span>
                <p><c:out value="${error}"/></p>
            </div>
        </c:if>

        <spring:hasBindErrors name="vendorForm">
            <div class="notice error-notice">
                <span class="material-symbols-outlined">error</span>
                <div>
                    <c:forEach var="validationError" items="${errors.allErrors}">
                        <p><c:out value="${validationError.defaultMessage}"/></p>
                    </c:forEach>
                </div>
            </div>
        </spring:hasBindErrors>

        <section class="panel form-panel">
            <div class="panel-header">
                <div>
                    <p class="eyebrow">${empty vendorId ? 'NEW VENDOR' : 'EDIT VENDOR'}</p>
                    <h2>협력업체 기본정보 입력</h2>
                </div>
            </div>

            <form method="post"
                  action="${pageContext.request.contextPath}/purchase/vendors${empty vendorId ? '' : '/'.concat(vendorId)}">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">info</span>
                        <p>업체코드는 등록 후 변경할 수 없습니다. 필수 항목을 정확히 입력해 주세요.</p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field">
                            <label for="vendorCode">업체코드 <span class="required">*</span></label>
                            <input type="text" id="vendorCode" name="vendorCode"
                                   value="<c:out value='${vendorForm.vendorCode}'/>"
                                   maxlength="30" placeholder="예: VENDOR001" required>
                            <p class="field-help">중복되지 않는 업체코드를 입력하세요.</p>
                        </div>

                        <div class="form-field">
                            <label for="vendorName">업체명 <span class="required">*</span></label>
                            <input type="text" id="vendorName" name="vendorName"
                                   value="<c:out value='${vendorForm.vendorName}'/>"
                                   maxlength="100" placeholder="업체명을 입력하세요" required>
                        </div>

                        <div class="form-field">
                            <label for="contactName">담당자</label>
                            <input type="text" id="contactName" name="contactName"
                                   value="<c:out value='${vendorForm.contactName}'/>"
                                   maxlength="100" placeholder="담당자명을 입력하세요">
                        </div>

                        <div class="form-field">
                            <label for="phone">연락처</label>
                            <input type="text" id="phone" name="phone"
                                   value="<c:out value='${vendorForm.phone}'/>"
                                   maxlength="30" placeholder="예: 010-0000-0000">
                        </div>

                        <div class="form-field">
                            <label for="email">이메일</label>
                            <input type="email" id="email" name="email"
                                   value="<c:out value='${vendorForm.email}'/>"
                                   maxlength="150" placeholder="예: vendor@company.com">
                        </div>

                        <div class="form-field">
                            <label for="address">주소</label>
                            <input type="text" id="address" name="address"
                                   value="<c:out value='${vendorForm.address}'/>"
                                   maxlength="300" placeholder="업체 주소를 입력하세요">
                        </div>

                        <c:if test="${not empty vendorId}">
                            <div class="form-field">
                                <label for="active">거래 상태 <span class="required">*</span></label>
                                <select id="active" name="active" required>
                                    <option value="true" ${vendorForm.active ? 'selected' : ''}>거래 중</option>
                                    <option value="false" ${!vendorForm.active ? 'selected' : ''}>거래 중지</option>
                                </select>
                            </div>
                        </c:if>

                    </div>

                    <div class="form-actions">
                        <a class="secondary-button" href="${pageContext.request.contextPath}/purchase/vendors">취소</a>
                        <button class="primary-button" type="submit">
                            <span class="material-symbols-outlined">save</span>
                            저장
                        </button>
                    </div>

                </div>
            </form>
        </section>
    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
