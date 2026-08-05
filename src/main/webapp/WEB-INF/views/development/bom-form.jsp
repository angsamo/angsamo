<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>BOM 등록</title>

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

        .form-field input,
        .form-field select {
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

        .form-field input:hover,
        .form-field select:hover {
            border-color: #aab6c5;
        }

        .form-field input:focus,
        .form-field select:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(18, 103, 214, 0.12);
        }

        .field-help {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
        }

        .empty-message {
            margin: 0;
            color: #b42318;
            font-size: 12px;
            font-weight: 600;
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
            border-color: var(--blue);
            background: #f8fbff;
        }

        .primary-button:disabled {
            color: #8793a2;
            background: #dce2e9;
            cursor: not-allowed;
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
                <p class="eyebrow">DEVELOPMENT</p>
                <h1>BOM 등록</h1>
                <p>완제품에 필요한 구성 자재와 필요 수량을 등록합니다.</p>
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
                    <p class="eyebrow">NEW BOM</p>
                    <h2>BOM 기본정보 입력</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/development/boms"
                  method="post">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">info</span>

                        <p>
                            같은 완제품과 구성 자재 조합은 중복 등록할 수 없습니다.
                            완제품 1개를 생산할 때 필요한 수량을 입력해 주세요.
                        </p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field full-width">
                            <label for="parentItemId">
                                완제품
                                <span class="required">*</span>
                            </label>

                            <select id="parentItemId"
                                    name="parentItemId"
                                    required>

                                <option value="">완제품을 선택하세요</option>

                                <c:forEach var="product"
                                           items="${productItems}">

                                    <option value="${product.itemId}"
                                            ${bom.parentItemId == product.itemId
                                                ? 'selected'
                                                : ''}>

                                        <c:out value="${product.itemCode}" />
                                        -
                                        <c:out value="${product.itemName}" />

                                    </option>

                                </c:forEach>
                            </select>

                            <c:if test="${empty productItems}">
                                <p class="empty-message">
                                    사용 가능한 완제품이 없습니다.
                                    품목 관리에서 완제품을 먼저 등록해 주세요.
                                </p>
                            </c:if>

                            <p class="field-help">
                                사용 중인 PRODUCT 유형 품목만 표시됩니다.
                            </p>
                        </div>

                        <div class="form-field full-width">
                            <label for="componentItemId">
                                구성 자재
                                <span class="required">*</span>
                            </label>

                            <select id="componentItemId"
                                    name="componentItemId"
                                    required>

                                <option value="">구성 자재를 선택하세요</option>

                                <c:forEach var="material"
                                           items="${materialItems}">

                                    <option value="${material.itemId}"
                                            ${bom.componentItemId == material.itemId
                                                ? 'selected'
                                                : ''}>

                                        <c:out value="${material.itemCode}" />
                                        -
                                        <c:out value="${material.itemName}" />
                                        (
                                        <c:out value="${material.unit}" />
                                        )

                                    </option>

                                </c:forEach>
                            </select>

                            <c:if test="${empty materialItems}">
                                <p class="empty-message">
                                    사용 가능한 구성 자재가 없습니다.
                                    품목 관리에서 자재를 먼저 등록해 주세요.
                                </p>
                            </c:if>

                            <p class="field-help">
                                사용 중인 MATERIAL 유형 품목만 표시됩니다.
                            </p>
                        </div>

                        <div class="form-field full-width">
                            <label for="requiredQty">
                                필요 수량
                                <span class="required">*</span>
                            </label>

                            <input type="number"
                                   id="requiredQty"
                                   name="requiredQty"
                                   value="${bom.requiredQty}"
                                   min="0.001"
                                   step="0.001"
                                   placeholder="예: 2.000"
                                   required>

                            <p class="field-help">
                                완제품 1개 생산에 필요한 구성 자재 수량입니다.
                                0보다 큰 값을 입력하세요.
                            </p>
                        </div>

                    </div>

                    <div class="form-actions">

                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/development/boms">

                            <span class="material-symbols-outlined">close</span>
                            취소
                        </a>

                        <c:choose>
                            <c:when test="${empty productItems}">
                                <button class="primary-button"
                                        type="button"
                                        disabled>

                                    <span class="material-symbols-outlined">save</span>
                                    BOM 등록
                                </button>
                            </c:when>

                            <c:when test="${empty materialItems}">
                                <button class="primary-button"
                                        type="button"
                                        disabled>

                                    <span class="material-symbols-outlined">save</span>
                                    BOM 등록
                                </button>
                            </c:when>

                            <c:otherwise>
                                <button class="primary-button"
                                        type="submit">

                                    <span class="material-symbols-outlined">save</span>
                                    BOM 등록
                                </button>
                            </c:otherwise>
                        </c:choose>

                    </div>

                </div>
            </form>

        </section>

    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

</body>
</html>