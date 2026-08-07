<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>생산계획 상세</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .detail-panel {
            max-width: 960px;
        }

        .detail-body {
            padding: 22px;
        }

        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .detail-table th,
        .detail-table td {
            padding: 15px 16px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
        }

        .detail-table th {
            width: 190px;
            color: var(--text);
            background: #f5f8fc;
            font-size: 13px;
            font-weight: 700;
        }

        .detail-table td {
            color: var(--text);
        }

        .item-code {
            color: var(--blue);
            font-weight: 700;
        }

        .item-name,
        .sub-text {
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .quantity {
            font-size: 16px;
            font-weight: 700;
            font-variant-numeric: tabular-nums;
        }

        .status-badge {
            display: inline-flex;
            min-width: 88px;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }

        .status-badge.planned {
            color: #155cb2;
            background: #e2efff;
        }

        .status-badge.in-progress {
            color: #8a5600;
            background: #fff0d2;
        }

        .status-badge.completed {
            color: #14653f;
            background: #ddf4e7;
        }

        .status-badge.cancelled {
            color: #9f1d1d;
            background: #fff0f0;
        }

        .status-badge.unknown {
            color: #526174;
            background: #eef2f7;
        }

        .message-notice {
            color: #14653f;
            background: #e5f7ed;
            border-color: #b8e2c9;
        }

        .error-notice {
            color: #9f1d1d;
            background: #fff0f0;
            border-color: #f1b8b8;
        }

        .status-panel {
            margin-top: 22px;
            padding: 18px;
            background: #f8fafc;
            border: 1px solid var(--border);
            border-radius: 7px;
        }

        .status-panel h3 {
            margin: 0 0 12px;
            font-size: 14px;
        }

        .status-form {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .status-form select {
            min-width: 180px;
            height: 40px;
            padding: 0 12px;
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 5px;
            outline: none;
        }

        .detail-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 10px;
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .action-button {
            display: inline-flex;
            height: 40px;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 0 16px;
            border-radius: 5px;
            font-weight: 700;
            cursor: pointer;
        }

        .list-button {
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
        }

        .list-button:hover {
            color: var(--blue);
            background: #f8fbff;
            border-color: var(--blue);
        }

        .edit-button {
            color: #fff;
            background: var(--navy);
            border: 1px solid var(--navy);
        }

        @media (max-width: 760px) {
            .detail-table th {
                width: 130px;
            }

            .status-form,
            .detail-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .status-form select,
            .status-form button,
            .detail-actions > * {
                width: 100%;
            }
			.detail-actions form{
			    margin:0;
			}

			.detail-actions button{
			    cursor:pointer;
			}

			.detail-actions button.action-button{
			    color:#fff;
			    background:#0f5cc0;
			    border:1px solid #0f5cc0;
			}

			.detail-actions button.action-button:hover{
			    background:#0c4ca0;
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
                <h1>생산계획 상세</h1>
                <p>생산계획의 품목, 수량, 일정과 진행 상태를 확인합니다.</p>
            </div>
        </section>

        <c:if test="${not empty message}">
            <div class="notice message-notice">
                <span class="material-symbols-outlined">check_circle</span>
                <p><c:out value="${message}" /></p>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="notice error-notice">
                <span class="material-symbols-outlined">error</span>
                <p><c:out value="${errorMessage}" /></p>
            </div>
        </c:if>

        <section class="panel detail-panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">PRODUCTION PLAN DETAIL</p>
                    <h2>
                        생산계획 #${productionPlan.productionPlanId}
                    </h2>
                </div>
            </div>

            <div class="detail-body">

                <table class="detail-table">

                    <tr>
                        <th>계획번호</th>
                        <td>${productionPlan.productionPlanId}</td>
                    </tr>

                    <tr>
                        <th>담당 부서</th>
                        <td>
                            <c:choose>
                                <c:when test="${empty productionPlan.departmentName}">
                                    -
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${productionPlan.departmentName}" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>생산 품목</th>
                        <td>
                            <div class="item-code">
                                <c:out value="${productionPlan.itemCode}" />
                            </div>

                            <div class="item-name">
                                <c:out value="${productionPlan.itemName}" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <th>생산 수량</th>
                        <td>
                            <span class="quantity">
                                <fmt:formatNumber
                                    value="${productionPlan.productionQty}"
                                    type="number"
                                    minFractionDigits="0"
                                    maxFractionDigits="3"
                                    groupingUsed="false" />
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>생산 시작일</th>
                        <td>${productionPlan.startDate}</td>
                    </tr>

                    <tr>
                        <th>완료 예정일</th>
                        <td>${productionPlan.dueDate}</td>
                    </tr>

                    <tr>
                        <th>상태</th>
                        <td>
                            <c:choose>
                                <c:when test="${productionPlan.status == 'PLANNED'}">
                                    <span class="status-badge planned">계획</span>
                                </c:when>

                                <c:when test="${productionPlan.status == 'IN_PROGRESS'}">
                                    <span class="status-badge in-progress">진행 중</span>
                                </c:when>

                                <c:when test="${productionPlan.status == 'COMPLETED'}">
                                    <span class="status-badge completed">완료</span>
                                </c:when>

                                <c:when test="${productionPlan.status == 'CANCELED'}">
                                    <span class="status-badge cancelled">취소</span>
                                </c:when>

                                <c:otherwise>
                                    <span class="status-badge unknown">
                                        <c:out value="${productionPlan.status}" />
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>등록자</th>
                        <td>
                            <c:choose>
                                <c:when test="${empty productionPlan.createdByName}">
                                    -
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${productionPlan.createdByName}" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>등록일</th>
                        <td>${productionPlan.createdAt}</td>
                    </tr>

                    <tr>
                        <th>수정일</th>
                        <td>${productionPlan.updatedAt}</td>
                    </tr>

                </table>

                <c:if test="${sessionScope.loginUser.role == 'ADMIN'
                              or sessionScope.loginUser.departmentCode == 'PRODUCTION'}">
                <div class="status-panel">
                    <h3>생산계획 상태 변경</h3>

                    <form class="status-form"
                          action="${pageContext.request.contextPath}/production/plans/${productionPlan.productionPlanId}/status"
                          method="post">

                        <select name="status" required>
                            <option value="PLANNED"
                                <c:if test="${productionPlan.status == 'PLANNED'}">
                                    selected
                                </c:if>>
                                계획
                            </option>

                            <option value="IN_PROGRESS"
                                <c:if test="${productionPlan.status == 'IN_PROGRESS'}">
                                    selected
                                </c:if>>
                                진행 중
                            </option>

                            <option value="COMPLETED"
                                <c:if test="${productionPlan.status == 'COMPLETED'}">
                                    selected
                                </c:if>>
                                완료
                            </option>

                            <option value="CANCELED"
                                <c:if test="${productionPlan.status == 'CANCELED'}">
                                    selected
                                </c:if>>
                                취소
                            </option>
                        </select>

                        <button class="primary-button" type="submit">
                            <span class="material-symbols-outlined">sync</span>
                            상태 변경
                        </button>

                    </form>
                </div>
                </c:if>

				<div class="detail-actions">

				    <a class="action-button list-button"
				       href="${pageContext.request.contextPath}/production/plans">

				        <span class="material-symbols-outlined">
				            arrow_back
				        </span>

				        목록
				    </a>

				    <c:if test="${sessionScope.loginUser.role == 'ADMIN'
				                  or sessionScope.loginUser.departmentCode == 'PRODUCTION'}">
				    <form action="${pageContext.request.contextPath}/production/material-requests/production-plan/${productionPlan.productionPlanId}/create"
				          method="post"
				          style="display:inline;">

				        <button class="action-button"
				                type="submit"
				                onclick="return confirm('BOM을 기준으로 자재요청을 생성하시겠습니까?');">

				            <span class="material-symbols-outlined">
				                inventory
				            </span>

				            자재요청 생성

				        </button>

				    </form>

				    <a class="action-button edit-button"
				       href="${pageContext.request.contextPath}/production/plans/${productionPlan.productionPlanId}/edit">

				        <span class="material-symbols-outlined">
				            edit
				        </span>

				        수정
				    </a>
				    </c:if>

				</div>

            </div>

        </section>

    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

</body>
</html>
