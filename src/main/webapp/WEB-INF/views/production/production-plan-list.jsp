<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>생산계획 조회</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th,
        .data-table td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
            white-space: nowrap;
        }

        .data-table th {
            color: var(--muted);
            background: #f8fafc;
            font-size: 12px;
            font-weight: 700;
        }

        .data-table tbody tr:hover {
            background: #f8fbff;
        }

        .item-code {
            color: var(--blue);
            font-weight: 700;
        }

        .item-name,
        .sub-text {
            margin-top: 3px;
            color: var(--muted);
            font-size: 11px;
        }

        .quantity {
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

        .empty-state {
            padding: 56px 20px;
            color: var(--muted);
            text-align: center;
        }

        .empty-state .material-symbols-outlined {
            display: block;
            margin-bottom: 10px;
            color: #9aa6b5;
            font-size: 44px;
        }

        .empty-state p {
            margin: 0;
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
                <h1>생산계획 조회</h1>
                <p>
                    생산부서의 품목별 생산계획과 진행 상태를 조회합니다.
                </p>
            </div>
        </section>

        <section class="panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">PRODUCTION PLAN LIST</p>
                    <h2>전체 생산계획</h2>
                </div>
            </div>

            <c:choose>

                <c:when test="${empty productionPlans}">
                    <div class="empty-state">
                        <span class="material-symbols-outlined">
                            calendar_month
                        </span>

                        <p>등록된 생산계획이 없습니다.</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="table-scroll">

                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>계획번호</th>
                                    <th>담당 부서</th>
                                    <th>생산 품목</th>
                                    <th>생산 수량</th>
                                    <th>시작일</th>
                                    <th>완료 예정일</th>
                                    <th>상태</th>
                                    <th>등록자</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="plan"
                                           items="${productionPlans}">

                                    <tr>
                                        <td>${plan.productionPlanId}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty plan.departmentName}">
                                                    -
                                                </c:when>

                                                <c:otherwise>
                                                    ${plan.departmentName}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <div class="item-code">
                                                ${plan.itemCode}
                                            </div>

                                            <div class="item-name">
                                                ${plan.itemName}
                                            </div>
                                        </td>

                                        <td class="quantity">
                                            ${plan.productionQty}
                                        </td>

                                        <td>${plan.startDate}</td>

                                        <td>${plan.dueDate}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${plan.status == 'PLANNED'}">
                                                    <span class="status-badge planned">
                                                        계획
                                                    </span>
                                                </c:when>

                                                <c:when test="${plan.status == 'IN_PROGRESS'}">
                                                    <span class="status-badge in-progress">
                                                        진행 중
                                                    </span>
                                                </c:when>

                                                <c:when test="${plan.status == 'COMPLETED'}">
                                                    <span class="status-badge completed">
                                                        완료
                                                    </span>
                                                </c:when>

                                                <c:when test="${plan.status == 'CANCELLED'}">
                                                    <span class="status-badge cancelled">
                                                        취소
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="status-badge unknown">
                                                        ${plan.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty plan.createdByName}">
                                                    -
                                                </c:when>

                                                <c:otherwise>
                                                    ${plan.createdByName}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>${plan.createdAt}</td>
                                    </tr>

                                </c:forEach>
                            </tbody>
                        </table>

                    </div>
                </c:otherwise>

            </c:choose>

        </section>

    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

</body>
</html>