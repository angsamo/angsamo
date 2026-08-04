<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>자재요청 조회</title>

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
            min-width: 86px;
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

        .status-badge.approved {
            color: #6141b6;
            background: #eee9ff;
        }

        .status-badge.issued {
            color: #14653f;
            background: #ddf4e7;
        }

        .status-badge.shortage {
            color: #8a5600;
            background: #fff0d2;
        }

        .status-badge.rejected {
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
                <h1>자재요청 조회</h1>
                <p>
                    생산계획에 필요한 자재 요청과 불출 처리 상태를 조회합니다.
                </p>
            </div>
        </section>

        <section class="panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">MATERIAL REQUEST LIST</p>
                    <h2>전체 자재요청</h2>
                </div>
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
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="request"
                                           items="${materialRequests}">

                                    <tr>
                                        <td>${request.requestId}</td>

                                        <td>${request.productionPlanId}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty request.departmentName}">
                                                    -
                                                </c:when>

                                                <c:otherwise>
                                                    ${request.departmentName}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <div class="item-code">
                                                ${request.itemCode}
                                            </div>

                                            <div class="item-name">
                                                ${request.itemName}
                                            </div>
                                        </td>

                                        <td class="quantity">
                                            ${request.requestQty}
                                        </td>

                                        <td class="quantity">
                                            ${request.issuedQty}
                                        </td>

                                        <td>${request.requiredDate}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${request.status == 'REQUESTED'}">
                                                    <span class="status-badge requested">
                                                        요청
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'APPROVED'}">
                                                    <span class="status-badge approved">
                                                        승인
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'ISSUED'}">
                                                    <span class="status-badge issued">
                                                        불출 완료
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'SHORTAGE'}">
                                                    <span class="status-badge shortage">
                                                        재고 부족
                                                    </span>
                                                </c:when>

                                                <c:when test="${request.status == 'REJECTED'}">
                                                    <span class="status-badge rejected">
                                                        반려
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="status-badge unknown">
                                                        ${request.status}
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
                                                    ${request.requestedByName}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty request.processedByName}">
                                                    미처리
                                                </c:when>

                                                <c:otherwise>
                                                    ${request.processedByName}
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