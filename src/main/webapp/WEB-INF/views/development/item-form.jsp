<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>품목 등록</title>

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

        .field-help {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
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
                <h1>품목 등록</h1>
                <p>새로운 완제품 또는 자재 품목을 등록합니다.</p>
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
                    <p class="eyebrow">NEW ITEM</p>
                    <h2>품목 기본정보 입력</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/development/items"
                  method="post">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">info</span>
                        <p>
                            품목코드는 등록 후 변경할 수 없습니다.
                            필수 항목을 정확히 입력해 주세요.
                        </p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field">
                            <label for="itemCode">
                                품목코드
                                <span class="required">*</span>
                            </label>

                            <input type="text"
                                   id="itemCode"
                                   name="itemCode"
                                   value="<c:out value='${item.itemCode}' />"
                                   maxlength="30"
                                   placeholder="예: PROD-001"
                                   required>

                            <p class="field-help">
                                중복되지 않는 품목코드를 입력하세요.
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
                                   placeholder="품목명을 입력하세요"
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

                                <option value="">품목 유형 선택</option>

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
                                   value="<c:out value='${empty item.unit ? "EA" : item.unit}' />"
                                   maxlength="20"
                                   placeholder="예: EA"
                                   required>

                            <p class="field-help">
                                예: EA, KG, M
                            </p>
                        </div>

                        <div class="form-field">
                            <label for="spec">규격</label>

                            <input type="text"
                                   id="spec"
                                   name="spec"
                                   value="<c:out value='${item.spec}' />"
                                   maxlength="200"
                                   placeholder="품목 규격을 입력하세요">
                        </div>

                        <div class="form-field">
                            <label for="standardPrice">기준 단가</label>

                            <input type="number"
                                   id="standardPrice"
                                   name="standardPrice"
                                   value="${item.standardPrice}"
                                   min="0"
                                   step="0.01"
                                   placeholder="예: 10000.00">

                            <p class="field-help">
                                입력하지 않아도 등록할 수 있습니다.
                            </p>
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
                                    <c:if test="${empty item.active || item.active == 1}">
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

                            <p class="field-help">
                                최대 500자까지 입력할 수 있습니다.
                            </p>
                        </div>

                    </div>

                    <div class="form-actions">

                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/development/items">
                            취소
                        </a>

                        <button class="primary-button" type="submit">
                            <span class="material-symbols-outlined">save</span>
                            품목 등록
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