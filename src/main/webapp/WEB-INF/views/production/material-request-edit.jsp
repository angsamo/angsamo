<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>자재요청 수정</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .form-panel {
            max-width: 960px;
        }

        .form-body {
            padding: 22px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .form-field {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-field.full-width {
            grid-column: 1 / -1;
        }

        .form-field label {
            color: var(--text);
            font-size: 13px;
            font-weight: 700;
        }

        .required {
            margin-left: 3px;
            color: #d42424;
        }

        .form-field input {
            width: 100%;
            height: 42px;
            padding: 0 12px;
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 5px;
            outline: none;
            transition: 150ms ease;
        }

        .form-field input:hover {
            border-color: #aab6c5;
        }

        .form-field input:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(18, 103, 214, 0.12);
        }

        .readonly-box {
            min-height: 72px;
            padding: 13px 14px;
            background: #f5f8fc;
            border: 1px solid var(--border);
            border-radius: 5px;
        }

        .readonly-value {
            display: flex;
            min-height: 42px;
            align-items: center;
            padding: 0 12px;
            color: var(--text);
            background: #f5f8fc;
            border: 1px solid var(--border);
            border-radius: 5px;
            font-weight: 600;
        }

        .item-code {
            color: var(--blue);
            font-weight: 700;
        }

        .item-name {
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .field-help {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
        }

        .status-badge {
            display: inline-flex;
            min-width: 88px;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            color: #155cb2;
            background: #e2efff;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .secondary-button {
            display: inline-flex;
            height: 40px;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 0 16px;
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 5px;
            font-weight: 700;
            cursor: pointer;
        }

        .secondary-button:hover {
            color: var(--blue);
            background: #f8fbff;
            border-color: var(--blue);
        }

        .error-notice {
            color: #9f1d1d;
            background: #fff0f0;
            border-color: #f1b8b8;
        }

        @media (max-width: 760px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-field.full-width {
                grid-column: auto;
            }

            .form-actions {
                flex-direction: column-reverse;
            }

            .form-actions > * {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

<div class="app-shell">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="workspace">

        <section class="page-heading">
            <div>
                <p class="eyebrow">PRODUCTION</p>
                <h1>자재요청 수정</h1>
                <p>요청 수량과 필요일을 수정합니다.</p>
            </div>
        </section>

        <c:if test="${not empty errorMessage}">
            <div class="notice error-notice">
                <span class="material-symbols-outlined">error</span>
                <p><c:out value="${errorMessage}" /></p>
            </div>
        </c:if>

        <section class="panel form-panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">EDIT MATERIAL REQUEST</p>
                    <h2>자재요청 정보 수정</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/production/material-requests/${materialRequest.requestId}/edit"
                  method="post">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">info</span>
                        <p>
                            요청 상태가 REQUESTED인 경우에만 요청 수량과 필요일을 수정할 수 있습니다.
                            처리 수량과 처리 정보는 자재부서가 관리합니다.
                        </p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field">
                            <label>요청번호</label>

                            <div class="readonly-value">
                                ${materialRequest.requestId}
                            </div>
                        </div>

                        <div class="form-field">
                            <label>생산계획 번호</label>

                            <div class="readonly-value">
                                ${materialRequest.productionPlanId}
                            </div>
                        </div>

                        <div class="form-field full-width">
                            <label>요청 자재</label>

                            <div class="readonly-box">
                                <div class="item-code">
                                    <c:out value="${materialRequest.itemCode}" />
                                </div>

                                <div class="item-name">
                                    <c:out value="${materialRequest.itemName}" />
                                </div>
                            </div>
                        </div>

                        <div class="form-field">
                            <label>요청 부서</label>

                            <div class="readonly-value">
                                <c:choose>
                                    <c:when test="${empty materialRequest.departmentName}">
                                        -
                                    </c:when>

                                    <c:otherwise>
                                        <c:out value="${materialRequest.departmentName}" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="form-field">
                            <label>현재 상태</label>

                            <div class="readonly-value">
                                <span class="status-badge">
                                    요청
                                </span>
                            </div>
                        </div>

                        <div class="form-field full-width">
                            <label for="requestQty">
                                요청 수량
                                <span class="required">*</span>
                            </label>

                            <fmt:formatNumber
                                value="${materialRequest.requestQty}"
                                type="number"
                                minFractionDigits="0"
                                maxFractionDigits="3"
                                groupingUsed="false"
                                var="formattedRequestQty" />

                            <input type="number"
                                   id="requestQty"
                                   name="requestQty"
                                   value="${formattedRequestQty}"
                                   min="0.001"
                                   step="0.001"
                                   placeholder="예: 200"
                                   required>

                            <p class="field-help">
                                요청 수량은 0보다 커야 합니다.
                            </p>
                        </div>

                        <div class="form-field full-width">
                            <label for="requiredDate">
                                필요일
                                <span class="required">*</span>
                            </label>

                            <input type="date"
                                   id="requiredDate"
                                   name="requiredDate"
                                   value="${materialRequest.requiredDate}"
                                   required>

                            <p class="field-help">
                                자재가 필요한 날짜를 입력하세요.
                            </p>
                        </div>

                    </div>

                    <div class="form-actions">

                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/production/material-requests/${materialRequest.requestId}">

                            <span class="material-symbols-outlined">close</span>
                            취소
                        </a>

                        <button class="primary-button"
                                type="submit">

                            <span class="material-symbols-outlined">save</span>
                            수정 저장
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