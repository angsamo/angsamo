<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>자재요청 관리</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
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

        .plan-link {
            color: var(--blue);
            font-weight: 700;
        }

        .plan-link:hover {
            text-decoration: underline;
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

        .status-badge.requested {
            color: #155cb2;
            background: #e2efff;
        }

        .status-badge.partial {
            color: #8a5600;
            background: #fff0d2;
        }

        .status-badge.issued {
            color: #14653f;
            background: #ddf4e7;
        }

        .status-badge.rejected {
            color: #9f1d1d;
            background: #fff0f0;
        }

        .status-badge.unknown {
            color: #526174;
            background: #eef2f7;
        }

        .action-button {
            display: inline-flex;
            height: 32px;
            align-items: center;
            justify-content: center;
            gap: 5px;
            padding: 0 10px;
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 5px;
            font-size: 12px;
            font-weight: 700;
        }

        .action-button:hover {
            color: var(--blue);
            background: #f8fbff;
            border-color: var(--blue);
        }

        .action-button .material-symbols-outlined {
            font-size: 17px;
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

                <c:choose>
                    <c:when test="${not empty productionPlanId}">
                        <h1>생산계획별 자재요청</h1>
                        <p>
                            생산계획 #${productionPlanId}에서 생성된 자재요청을 조회합니다.
                        </p>
                    </c:when>

                    <c:otherwise>
                        <h1>자재요청 관리</h1>
                        <p>
                            생산계획에 필요한 자재 요청과 불출 처리 상태를 조회합니다.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <c:if test="${not empty message}">
            <div class="notice message-notice">
                <span class="material-symbols-outlined">
                    check_circle
                </span>

                <p>
                    <c:out value="${message}" />
                </p>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="notice error-notice">
                <span class="material-symbols-outlined">
                    error
                </span>

                <p>
                    <c:out value="${errorMessage}" />
                </p>
            </div>
        </c:if>

        <section class="panel table-panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">MATERIAL REQUEST LIST</p>

                    <c:choose>
                        <c:when test="${not empty productionPlanId}">
                            <h2>생산계획별 자재요청</h2>
                        </c:when>

                        <c:otherwise>
                            <h2>전체 자재요청</h2>
                        </c:otherwise>
                    </c:choose>
                </div>

                <span class="list-count">
                    총
                    <strong>
                        <c:out value="${empty materialRequests ? 0 : materialRequests.size()}" />
                    </strong>
                    건
                </span>
            </div>

            <c:choose>

                <c:when test="${empty materialRequests}">
                    <div class="empty-state">
                        <span class="material-symbols-outlined">
                            inventory
                        </span>

                        <p>등록된 자재요청이 없습니다.</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="table-scroll">

                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>요청번호</th>
                                    <th>생산계획번호</th>
                                    <th>요청 부서</th>
                                    <th>요청 품목</th>
                                    <th>요청 수량</th>
                                    <th>불출 수량</th>
                                    <th>필요일</th>
                                    <th>상태</th>
                                    <th>요청자</th>
                                    <th>처리자</th>
                                    <th>불출일시</th>
                                    <th>등록일</th>
                                    <th>관리</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="request"
                                           items="${materialRequests}">

                                    <tr>
                                        <td>${request.requestId}</td>

                                        <td>
                                            <a class="plan-link"
                                               href="${pageContext.request.contextPath}/production/plans/${request.productionPlanId}">
                                                ${request.productionPlanId}
                                            </a>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty request.departmentName}">
                                                    -
                                                </c:when>

                                                <c:otherwise>
                                                    <c:out value="${request.departmentName}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <div class="item-code">
                                                <c:out value="${request.itemCode}" />
                                            </div>

                                            <div class="item-name">
                                                <c:out value="${request.itemName}" />
                                            </div>
                                        </td>

                                        <td class="quantity">
                                            <fmt:formatNumber
                                                value="${request.requestQty}"
                                                type="number"
                                                minFractionDigits="0"
                                                maxFractionDigits="3"
                                                groupingUsed="false" />
                                        </td>

                                        <td class="quantity">
                                            <fmt:formatNumber
                                                value="${request.issuedQty}"
                                                type="number"
                                                minFractionDigits="0"
                                                maxFractionDigits="3"
                                                groupingUsed="false" />
                                        </td>

                                        <td>${request.requiredDate}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${request.status == 'REQUESTED'}">
                                                    <span class="status-badge requested">
                                                        요청
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'PARTIAL'}">
                                                    <span class="status-badge partial">
                                                        부분 불출
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'ISSUED'}">
                                                    <span class="status-badge issued">
                                                        불출 완료
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'REJECTED'}">
                                                    <span class="status-badge rejected">
                                                        반려
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'CANCELED'}">
                                                    <span class="status-badge rejected">
                                                        취소
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="status-badge unknown">
                                                        <c:out value="${request.status}" />
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty request.requestedByName}">
                                                    -
                                                </c:when>

                                                <c:otherwise>
                                                    <c:out value="${request.requestedByName}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty request.processedByName}">
                                                    미처리
                                                </c:when>

                                                <c:otherwise>
                                                    <c:out value="${request.processedByName}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty request.issuedAt}">
                                                    -
                                                </c:when>

                                                <c:otherwise>
                                                    ${request.issuedAt}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>${request.createdAt}</td>

                                        <td>
                                            <a class="action-button"
                                               href="${pageContext.request.contextPath}/production/material-requests/${request.requestId}">

                                                <span class="material-symbols-outlined">
                                                    visibility
                                                </span>

                                                상세
                                            </a>
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
