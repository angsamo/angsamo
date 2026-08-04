<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>품목 수정</title>

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
        .form-field select,
        .form-field textarea {
            width: 100%;
            padding: 0 12px;
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 5px;
            outline: none;
            transition: 150ms ease;
        }

        .form-field input,
        .form-field select {
            height: 42px;
        }

        .form-field textarea {
            min-height: 120px;
            padding-top: 11px;
            padding-bottom: 11px;
            resize: vertical;
            font: inherit;
        }

        .form-field input:hover,
        .form-field select:hover,
        .form-field textarea:hover {
            border-color: #aab6c5;
        }

        .form-field input:focus,
        .form-field select:focus,
        .form-field textarea:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(18, 103, 214, 0.12);
        }

        .form-field input[readonly] {
            color: #526174;
            background: #eef2f7;
            border-color: #d5dce6;
            cursor: not-allowed;
        }

        .field-help {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
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
                <p class="eyebrow">DEVELOPMENT</p>
                <h1>품목 수정</h1>
                <p>등록된 품목의 기준정보를 변경합니다.</p>
            </div>
        </section>

        <c:if test="${not empty errorMessage}">
            <div class="notice error-notice">
                <span class="material-symbols-outlined">error</span>
                <p>${errorMessage}</p>
            </div>
        </c:if>

        <section class="panel form-panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">EDIT ITEM</p>
                    <h2>${item.itemName}</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/development/items/${item.itemId}/edit"
                  method="post">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">lock</span>
                        <p>
                            품목코드는 업무 식별 코드이므로 수정할 수 없습니다.
                        </p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field">
                            <label for="itemId">품목 식별번호</label>

                            <input type="text"
                                   id="itemId"
                                   value="${item.itemId}"
                                   readonly>
                        </div>

                        <div class="form-field">
                            <label for="itemCode">품목코드</label>

                            <input type="text"
                                   id="itemCode"
                                   value="<c:out value='${item.itemCode}' />"
                                   readonly>

                            <p class="field-help">
                                등록 후 변경할 수 없습니다.
                            </p>
                        </div>

                        <div class="form-field">
                            <label for="itemName">
                                품목명
                                <span class="required">*</span>
                            </label>

                            <input type="text"
                                   id="itemName"
                                   name="itemName"
                                   value="<c:out value='${item.itemName}' />"
                                   maxlength="100"
                                   required>
                        </div>

                        <div class="form-field">
                            <label for="itemType">
                                품목 유형
                                <span class="required">*</span>
                            </label>

                            <select id="itemType"
                                    name="itemType"
                                    required>

                                <option value="PRODUCT"
                                    <c:if test="${item.itemType == 'PRODUCT'}">
                                        selected
                                    </c:if>>
                                    완제품
                                </option>

                                <option value="MATERIAL"
                                    <c:if test="${item.itemType == 'MATERIAL'}">
                                        selected
                                    </c:if>>
                                    자재
                                </option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label for="unit">
                                단위
                                <span class="required">*</span>
                            </label>

                            <input type="text"
                                   id="unit"
                                   name="unit"
                                   value="<c:out value='${item.unit}' />"
                                   maxlength="20"
                                   placeholder="예: EA"
                                   required>
                        </div>

                        <div class="form-field">
                            <label for="spec">규격</label>

                            <input type="text"
                                   id="spec"
                                   name="spec"
                                   value="<c:out value='${item.spec}' />"
                                   maxlength="200">
                        </div>

                        <div class="form-field">
                            <label for="standardPrice">기준 단가</label>

                            <input type="number"
                                   id="standardPrice"
                                   name="standardPrice"
                                   value="${item.standardPrice}"
                                   min="0"
                                   step="0.01">
                        </div>

                        <div class="form-field">
                            <label for="active">
                                사용 여부
                                <span class="required">*</span>
                            </label>

                            <select id="active"
                                    name="active"
                                    required>

                                <option value="1"
                                    <c:if test="${item.active == 1}">
                                        selected
                                    </c:if>>
                                    사용
                                </option>

                                <option value="0"
                                    <c:if test="${item.active == 0}">
                                        selected
                                    </c:if>>
                                    미사용
                                </option>
                            </select>
                        </div>

                        <div class="form-field full-width">
                            <label for="description">추가 설명</label>

                            <textarea id="description"
                                      name="description"
                                      maxlength="500"
                                      placeholder="재질, 도면, 제작 사양 등 추가 정보를 입력하세요"><c:out value="${item.description}" /></textarea>
                        </div>

                    </div>

                    <div class="form-actions">

                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/development/items/${item.itemId}">

                            <span class="material-symbols-outlined">close</span>
                            취소
                        </a>

                        <button class="primary-button"
                                type="submit">

                            <span class="material-symbols-outlined">save</span>
                            변경사항 저장
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