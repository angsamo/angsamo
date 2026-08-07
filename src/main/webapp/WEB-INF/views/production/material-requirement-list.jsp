<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>자재 소요량 조회</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 18px;
        }

        .summary-card {
            min-height: 124px;
            padding: 18px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 8px;
        }

        .summary-card-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .summary-card-label {
            margin: 0;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
        }

        .summary-icon {
            display: grid;
            width: 38px;
            height: 38px;
            place-items: center;
            color: var(--blue);
            background: #e2efff;
            border-radius: 6px;
        }

        .summary-card strong {
            display: block;
            margin-top: 14px;
            font-size: 28px;
            font-variant-numeric: tabular-nums;
        }

        .summary-card span:last-child {
            color: var(--muted);
            font-size: 11px;
        }

        .guide-box {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 18px;
            padding: 15px 17px;
            color: #174b8a;
            background: #eef5ff;
            border: 1px solid #c8dcf8;
            border-radius: 7px;
        }

        .guide-box .material-symbols-outlined {
            margin-top: 1px;
            color: var(--blue);
        }

        .guide-box strong {
            display: block;
            margin-bottom: 4px;
            font-size: 13px;
        }

        .guide-box p {
            margin: 0;
            color: #526174;
            font-size: 12px;
            line-height: 1.6;
        }

        .table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            min-width: 1180px;
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

        .plan-link {
            color: var(--blue);
            font-weight: 700;
        }

        .plan-link:hover {
            text-decoration: underline;
        }

        .item-code {
            color: var(--blue);
            font-weight: 700;
        }

        .item-name {
            margin-top: 3px;
            color: var(--muted);
            font-size: 11px;
        }

        .quantity {
            font-weight: 700;
            font-variant-numeric: tabular-nums;
        }

        .shortage-zero {
            color: #14653f;
        }

        .shortage-positive {
            color: #b42318;
        }

        .unit-badge {
            display: inline-flex;
            min-width: 44px;
            align-items: center;
            justify-content: center;
            padding: 4px 8px;
            color: #14653f;
            background: #ddf4e7;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
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

        .status-badge.available {
            color: #14653f;
            background: #ddf4e7;
        }

        .status-badge.shortage {
            color: #9f1d1d;
            background: #fff0f0;
        }

        .empty-state {
            padding: 60px 20px;
            color: var(--muted);
            text-align: center;
        }

        .empty-state .material-symbols-outlined {
            display: block;
            margin-bottom: 10px;
            color: #9aa6b5;
            font-size: 46px;
        }

        .empty-state strong {
            display: block;
            margin-bottom: 6px;
            color: var(--text);
            font-size: 15px;
        }

        .empty-state p {
            margin: 0;
            font-size: 12px;
            line-height: 1.6;
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

        @media (max-width: 1050px) {
            .summary-grid {
                grid-template-columns: 1fr;
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
                <h1>자재 소요량 조회</h1>
                <p>
                    생산계획과 BOM을 기준으로 총 필요 자재 수량과 부족 수량을 조회합니다.
                </p>
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

        <div class="guide-box">
            <span class="material-symbols-outlined">info</span>

            <div>
                <strong>계산 기준</strong>

                <p>
                    총 필요 수량은 생산 수량 × BOM 필요 수량으로 계산하며,
                    부족 수량은 총 필요 수량 - 사용 가능 재고로 계산합니다.
                    계산 결과가 음수이면 부족 수량은 0으로 처리합니다.
                </p>
            </div>
        </div>

        <div class="summary-grid">

            <div class="summary-card">
                <div class="summary-card-top">
                    <p class="summary-card-label">
                        자재 소요 항목
                    </p>

                    <span class="summary-icon material-symbols-outlined">
                        account_tree
                    </span>
                </div>

                <strong>
                    <c:out value="${empty requirements ? 0 : requirements.size()}" />
                </strong>

                <span>전체 계산 대상</span>
            </div>

            <div class="summary-card">
                <div class="summary-card-top">
                    <p class="summary-card-label">
                        재고 충족 항목
                    </p>

                    <span class="summary-icon material-symbols-outlined">
                        inventory
                    </span>
                </div>

                <strong>
                    <c:set var="availableCount" value="0" />

                    <c:forEach var="requirement"
                               items="${requirements}">

                        <c:if test="${requirement.stockSufficient}">

                            <c:set var="availableCount"
                                   value="${availableCount + 1}" />
                        </c:if>
                    </c:forEach>

                    <c:out value="${availableCount}" />
                </strong>

                <span>구매 불필요</span>
            </div>

            <div class="summary-card">
                <div class="summary-card-top">
                    <p class="summary-card-label">
                        부족 자재 항목
                    </p>

                    <span class="summary-icon material-symbols-outlined">
                        warning
                    </span>
                </div>

                <strong>
                    <c:set var="shortageCount" value="0" />

                    <c:forEach var="requirement"
                               items="${requirements}">

                        <c:if test="${requirement.shortage}">

                            <c:set var="shortageCount"
                                   value="${shortageCount + 1}" />
                        </c:if>
                    </c:forEach>

                    <c:out value="${shortageCount}" />
                </strong>

                <span>구매부서 전달 대상</span>
            </div>

        </div>

        <section class="panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">MATERIAL REQUIREMENT LIST</p>
                    <h2>자재 소요량 및 부족 현황</h2>
                </div>
            </div>

            <c:choose>

                <c:when test="${empty requirements}">
                    <div class="empty-state">

                        <span class="material-symbols-outlined">
                            calculate
                        </span>

                        <strong>
                            계산된 자재 소요량이 없습니다.
                        </strong>

                        <p>
                            현재는 재고 조회 기능과 연결하기 전 단계입니다.<br>
                            생산계획과 재고 연동이 완료되면 자재 소요량이 표시됩니다.
                        </p>

                    </div>
                </c:when>

                <c:otherwise>
                    <div class="table-scroll">

                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>생산계획</th>
                                    <th>자재 품목</th>
                                    <th>단위</th>
                                    <th>생산 수량</th>
                                    <th>BOM 필요 수량</th>
                                    <th>총 필요 수량</th>
                                    <th>사용 가능 재고</th>
                                    <th>불출 가능 수량</th>
                                    <th>부족 수량</th>
                                    <th>필요일</th>
                                    <th>재고 상태</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="requirement"
                                           items="${requirements}">

                                    <tr>
                                        <td>
                                            <a class="plan-link"
                                               href="${pageContext.request.contextPath}/production/plans/${requirement.productionPlanId}">

                                                #${requirement.productionPlanId}
                                            </a>
                                        </td>

                                        <td>
                                            <div class="item-code">
                                                <c:out value="${requirement.itemCode}" />
                                            </div>

                                            <div class="item-name">
                                                <c:out value="${requirement.itemName}" />
                                            </div>
                                        </td>

                                        <td>
                                            <span class="unit-badge">
                                                <c:out value="${requirement.unit}" />
                                            </span>
                                        </td>

                                        <td class="quantity">
                                            <fmt:formatNumber
                                                value="${requirement.productionQty}"
                                                type="number"
                                                minFractionDigits="0"
                                                maxFractionDigits="3"
                                                groupingUsed="false" />
                                        </td>

                                        <td class="quantity">
                                            <fmt:formatNumber
                                                value="${requirement.bomRequiredQty}"
                                                type="number"
                                                minFractionDigits="0"
                                                maxFractionDigits="3"
                                                groupingUsed="false" />
                                        </td>

                                        <td class="quantity">
                                            <fmt:formatNumber
                                                value="${requirement.requiredQty}"
                                                type="number"
                                                minFractionDigits="0"
                                                maxFractionDigits="3"
                                                groupingUsed="false" />
                                        </td>

                                        <td class="quantity">
                                            <fmt:formatNumber
                                                value="${requirement.availableQty}"
                                                type="number"
                                                minFractionDigits="0"
                                                maxFractionDigits="3"
                                                groupingUsed="false" />
                                        </td>

                                        <td class="quantity">
                                            <fmt:formatNumber
                                                value="${requirement.requiredQty - requirement.shortageQty}"
                                                type="number"
                                                minFractionDigits="0"
                                                maxFractionDigits="3"
                                                groupingUsed="false" />
                                        </td>

                                        <td>
                                            <c:choose>
                                            <c:when test="${requirement.stockSufficient}">
                                                    <span class="quantity shortage-zero">
                                                        0
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="quantity shortage-positive">

                                                        <fmt:formatNumber
                                                            value="${requirement.shortageQty}"
                                                            type="number"
                                                            minFractionDigits="0"
                                                            maxFractionDigits="3"
                                                            groupingUsed="false" />

                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            ${requirement.requiredDate}
                                        </td>

                                        <td>
                                            <c:choose>
                                            <c:when test="${requirement.stockSufficient}">
                                                    <span class="status-badge available">
                                                        재고 충족
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="status-badge shortage">
                                                        재고 부족
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
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
