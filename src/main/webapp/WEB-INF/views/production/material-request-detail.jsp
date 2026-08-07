<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>자재요청 상세</title>

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

        .cancel-button {
            color: #fff;
            background: #d9363e;
            border: 1px solid #d9363e;
        }

        .cancel-button:hover {
            background: #b9262d;
            border-color: #b9262d;
        }

        .detail-actions form {
            margin: 0;
        }

        .readonly-note {
            margin-top: 18px;
            padding: 14px 16px;
            color: var(--muted);
            background: #f8fafc;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 12px;
        }

        .readonly-note p {
            margin: 0;
        }

        @media (max-width: 760px) {
            .detail-table th {
                width: 130px;
            }

            .detail-actions {
                flex-direction: column-reverse;
            }

            .detail-actions > *,
            .detail-actions form,
            .detail-actions button {
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
                <h1>자재요청 상세</h1>
                <p>생산계획에서 생성된 자재요청 정보를 확인합니다.</p>
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
                    <p class="eyebrow">MATERIAL REQUEST DETAIL</p>
                    <h2>
                        자재요청 #${materialRequest.requestId}
                    </h2>
                </div>
            </div>

            <div class="detail-body">

                <table class="detail-table">

                    <tr>
                        <th>요청번호</th>
                        <td>${materialRequest.requestId}</td>
                    </tr>

                    <tr>
                        <th>생산계획 번호</th>
                        <td>
                            <a class="item-code"
                               href="${pageContext.request.contextPath}/production/plans/${materialRequest.productionPlanId}">
                                ${materialRequest.productionPlanId}
                            </a>
                        </td>
                    </tr>

                    <tr>
                        <th>요청 부서</th>
                        <td>
                            <c:choose>
                                <c:when test="${empty materialRequest.departmentName}">
                                    -
                                </c:when>

                                <c:otherwise>
                                    <c:out value="${materialRequest.departmentName}" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>요청 자재</th>
                        <td>
                            <div class="item-code">
                                <c:out value="${materialRequest.itemCode}" />
                            </div>

                            <div class="item-name">
                                <c:out value="${materialRequest.itemName}" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <th>요청 수량</th>
                        <td>
                            <span class="quantity">
                                <fmt:formatNumber
                                    value="${materialRequest.requestQty}"
                                    type="number"
                                    minFractionDigits="0"
                                    maxFractionDigits="3"
                                    groupingUsed="false" />
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>처리 수량</th>
                        <td>
                            <span class="quantity">
                                <fmt:formatNumber
                                    value="${materialRequest.issuedQty}"
                                    type="number"
                                    minFractionDigits="0"
                                    maxFractionDigits="3"
                                    groupingUsed="false" />
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>필요일</th>
                        <td>${materialRequest.requiredDate}</td>
                    </tr>

                    <tr>
                        <th>상태</th>
                        <td>
                            <c:choose>
                                <c:when test="${materialRequest.status == 'REQUESTED'}">
                                    <span class="status-badge requested">
                                        요청
                                    </span>
                                </c:when>

                                <c:when test="${materialRequest.status == 'PARTIAL'}">
                                    <span class="status-badge partial">
                                        부분 처리
                                    </span>
                                </c:when>

                                <c:when test="${materialRequest.status == 'ISSUED'}">
                                    <span class="status-badge issued">
                                        처리 완료
                                    </span>
                                </c:when>

                                <c:when test="${materialRequest.status == 'REJECTED'}">
                                    <span class="status-badge rejected">
                                        반려
                                    </span>
                                </c:when>

                                <c:when test="${materialRequest.status == 'CANCELED'}">
                                    <span class="status-badge rejected">
                                        취소
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="status-badge unknown">
                                        <c:out value="${materialRequest.status}" />
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>요청자</th>
                        <td>
                            <c:choose>
                                <c:when test="${empty materialRequest.requestedByName}">
                                    -
                                </c:when>

                                <c:otherwise>
                                    <c:out value="${materialRequest.requestedByName}" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>처리자</th>
                        <td>
                            <c:choose>
                                <c:when test="${empty materialRequest.processedByName}">
                                    -
                                </c:when>

                                <c:otherwise>
                                    <c:out value="${materialRequest.processedByName}" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>불출 일시</th>
                        <td>
                            <c:choose>
                                <c:when test="${empty materialRequest.issuedAt}">
                                    -
                                </c:when>

                                <c:otherwise>
                                    ${materialRequest.issuedAt}
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <th>등록일</th>
                        <td>${materialRequest.createdAt}</td>
                    </tr>

                    <tr>
                        <th>수정일</th>
                        <td>${materialRequest.updatedAt}</td>
                    </tr>

                </table>

                <div class="readonly-note">
                    <p>
                        생산부서는 요청 상태가 REQUESTED인 경우에만
                        요청 수량과 필요일을 수정하거나 요청을 취소할 수 있습니다.
                        처리 수량, 처리자, 불출 일시와 처리 상태는 자재부서가 관리합니다.
                    </p>
                </div>

                <div class="detail-actions">

                    <a class="action-button list-button"
                       href="${pageContext.request.contextPath}/production/material-requests">

                        <span class="material-symbols-outlined">arrow_back</span>
                        목록
                    </a>

                    <c:if test="${materialRequest.status == 'REQUESTED'
                                  and (sessionScope.loginUser.role == 'ADMIN'
                                       or sessionScope.loginUser.departmentCode == 'PRODUCTION')}">

                        <a class="action-button edit-button"
                           href="${pageContext.request.contextPath}/production/material-requests/${materialRequest.requestId}/edit">

                            <span class="material-symbols-outlined">edit</span>
                            수정
                        </a>

                        <form action="${pageContext.request.contextPath}/production/material-requests/${materialRequest.requestId}/cancel"
                              method="post"
                              onsubmit="return confirm('이 자재요청을 취소하시겠습니까?');">

                            <button class="action-button cancel-button"
                                    type="submit">

                                <span class="material-symbols-outlined">cancel</span>
                                요청 취소
                            </button>

                        </form>

                    </c:if>

                </div>

            </div>

        </section>

    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

</body>
</html>
