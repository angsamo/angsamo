<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>BOM 수정</title>

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

        .unit-badge {
            display: inline-flex;
            min-width: 44px;
            align-items: center;
            justify-content: center;
            margin-left: 8px;
            padding: 4px 9px;
            color: #14653f;
            background: #ddf4e7;
            border-radius: 999px;
            font-size: 12px;
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
                <h1>BOM 수정</h1>
                <p>완제품의 구성 자재 필요 수량을 수정합니다.</p>
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
                    <p class="eyebrow">EDIT BOM</p>
                    <h2>BOM 필요 수량 수정</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/development/boms/${bom.bomId}/edit"
                  method="post">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">info</span>
                        <p>
                            완제품과 구성 자재는 변경할 수 없으며,
                            필요 수량만 수정할 수 있습니다.
                        </p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field">
                            <label>BOM 번호</label>

                            <div class="readonly-box">
                                ${bom.bomId}
                            </div>
                        </div>

                        <div class="form-field">
                            <label>단위</label>

                            <div class="readonly-box">
                                <span class="unit-badge">
                                    <c:out value="${bom.componentUnit}" />
                                </span>
                            </div>
                        </div>

                        <div class="form-field full-width">
                            <label>완제품</label>

                            <div class="readonly-box">
                                <div class="item-code">
                                    <c:out value="${bom.parentItemCode}" />
                                </div>

                                <div class="item-name">
                                    <c:out value="${bom.parentItemName}" />
                                </div>
                            </div>
                        </div>

                        <div class="form-field full-width">
                            <label>구성 자재</label>

                            <div class="readonly-box">
                                <div class="item-code">
                                    <c:out value="${bom.componentItemCode}" />
                                </div>

                                <div class="item-name">
                                    <c:out value="${bom.componentItemName}" />
                                </div>
                            </div>
                        </div>

                        <div class="form-field full-width">
                            <label for="requiredQty">
                                필요 수량
                                <span class="required">*</span>
                            </label>

                            <input type="number"
                                   id="requiredQty"
                                   name="requiredQty"
                                   value="<fmt:formatNumber value='${bom.requiredQty}' type='number' minFractionDigits='0' maxFractionDigits='3' groupingUsed='false' />"
                                   min="0.001"
                                   step="0.001"
                                   required>

                            <p class="field-help">
                                0보다 큰 값을 입력하세요.
                            </p>
                        </div>

                    </div>

                    <div class="form-actions">

                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/development/boms/${bom.bomId}">

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