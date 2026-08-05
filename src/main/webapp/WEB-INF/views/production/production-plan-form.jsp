<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>생산계획 등록</title>

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

        .status-box {
            display: flex;
            min-height: 42px;
            align-items: center;
            padding: 0 12px;
            color: #155cb2;
            background: #e2efff;
            border: 1px solid #b8d1f6;
            border-radius: 5px;
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
		        <p class="eyebrow">PRODUCTION</p>
		        <h1>생산계획 등록</h1>
		        <p>생산할 완제품과 생산 수량, 작업 일정을 등록합니다.</p>
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
                    <p class="eyebrow">NEW PRODUCTION PLAN</p>
                    <h2>생산계획 기본정보 입력</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/production/plans"
                  method="post">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">info</span>

                        <p>
                            생산계획에는 사용 중인 완제품만 선택할 수 있으며,
                            시작일은 완료 예정일보다 늦을 수 없습니다.
                        </p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field full-width">
                            <label for="itemId">
                                생산 완제품
                                <span class="required">*</span>
                            </label>

                            <select id="itemId"
                                    name="itemId"
                                    required>

                                <option value="">생산할 완제품을 선택하세요</option>

                                <c:forEach var="product"
                                           items="${productItems}">

                                    <option value="${product.itemId}"
                                        <c:if test="${productionPlan.itemId == product.itemId}">
                                            selected
                                        </c:if>>

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
                            <label for="productionQty">
                                생산 수량
                                <span class="required">*</span>
                            </label>

                            <input type="number"
                                   id="productionQty"
                                   name="productionQty"
                                   value="${productionPlan.productionQty}"
                                   min="0.001"
                                   step="0.001"
                                   placeholder="예: 100"
                                   required>

                            <p class="field-help">
                                생산할 완제품의 총수량을 입력하세요.
                            </p>
                        </div>

                        <div class="form-field">
                            <label for="startDate">
                                생산 시작일
                                <span class="required">*</span>
                            </label>

                            <input type="date"
                                   id="startDate"
                                   name="startDate"
                                   value="${productionPlan.startDate}"
                                   required>
                        </div>

                        <div class="form-field">
                            <label for="dueDate">
                                완료 예정일
                                <span class="required">*</span>
                            </label>

                            <input type="date"
                                   id="dueDate"
                                   name="dueDate"
                                   value="${productionPlan.dueDate}"
                                   required>
                        </div>

                        <div class="form-field full-width">
                            <label>초기 상태</label>

                            <div class="status-box">
                                계획
                            </div>

                            <p class="field-help">
                                새로운 생산계획은 PLANNED 상태로 자동 등록됩니다.
                            </p>
                        </div>

                    </div>

					<div class="form-actions">

					    <a class="secondary-button"
					       href="${pageContext.request.contextPath}/production/plans">

					        <span class="material-symbols-outlined">close</span>
					        취소
					    </a>

					    <button class="primary-button"
					            type="submit">

					        <span class="material-symbols-outlined">save</span>
					        생산계획 등록
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