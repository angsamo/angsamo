<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>품목 관리</title>

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
            padding: 13px 16px;
            border-bottom: 1px solid var(--border);
            text-align: left;
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

        .table-link {
            color: var(--blue);
            font-weight: 600;
        }

        .state-badge {
            display: inline-flex;
            min-width: 52px;
            align-items: center;
            justify-content: center;
            padding: 4px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }

        .state-badge.enabled {
            color: #14653f;
            background: #ddf4e7;
        }

        .state-badge.disabled {
            color: #9f1d1d;
            background: #fff0f0;
        }

        .type-badge {
            display: inline-flex;
            min-width: 62px;
            align-items: center;
            justify-content: center;
            padding: 4px 9px;
            color: #155cb2;
            background: #e2efff;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }

        .empty-state {
            padding: 48px 20px;
            color: var(--muted);
            text-align: center;
        }

        .empty-state p {
            margin: 0;
        }

        .empty-state .material-symbols-outlined {
            display: block;
            margin-bottom: 10px;
            color: #9aa6b5;
            font-size: 42px;
        }

        .error-notice {
            color: #9f1d1d;
            background: #fff0f0;
            border-color: #f1b8b8;
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
                <h1>품목 관리</h1>
                <p>
                    완제품과 자재의 품목 기준정보를 조회하고 관리합니다.
                </p>
            </div>

            <a class="primary-button"
               href="${pageContext.request.contextPath}/development/items/new">

                <span class="material-symbols-outlined">
                    add
                </span>

                <span>품목 등록</span>
            </a>
        </section>

        <c:if test="${not empty message}">
            <div class="notice">
                <span class="material-symbols-outlined">
                    check_circle
                </span>

                <p>${message}</p>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="notice error-notice">
                <span class="material-symbols-outlined">
                    error
                </span>

                <p>${errorMessage}</p>
            </div>
        </c:if>

        <form method="get"
              action="${pageContext.request.contextPath}/development/items"
              style="display:flex; gap:10px; margin-bottom:18px; padding:16px; background:#fff; border:1px solid var(--border); border-radius:8px;">
            <input type="search" name="keyword" value="<c:out value='${keyword}' />"
                   placeholder="품목코드 또는 품목명"
                   style="flex:1; padding:10px 12px; border:1px solid var(--border); border-radius:6px;">
            <select name="itemType" style="min-width:150px; padding:10px 12px; border:1px solid var(--border); border-radius:6px;">
                <option value="">전체 유형</option>
                <option value="PRODUCT" ${itemType == 'PRODUCT' ? 'selected' : ''}>완제품</option>
                <option value="MATERIAL" ${itemType == 'MATERIAL' ? 'selected' : ''}>자재</option>
            </select>
            <button class="primary-button" type="submit">검색</button>
            <a class="secondary-button" href="${pageContext.request.contextPath}/development/items">초기화</a>
        </form>

        <section class="panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">ITEM LIST</p>
                    <h2>전체 품목</h2>
                </div>
            </div>

            <c:choose>

                <c:when test="${empty items}">
                    <div class="empty-state">
                        <span class="material-symbols-outlined">
                            inventory_2
                        </span>

                        <p>등록된 품목이 없습니다.</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="table-scroll">

                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>품목코드</th>
                                    <th>품목명</th>
                                    <th>품목 유형</th>
                                    <th>규격</th>
                                    <th>단위</th>
                                    <th>기준 단가</th>
                                    <th>사용 여부</th>
                                    <th>상세</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="item"
                                           items="${items}">

                                    <tr>
                                        <td>${item.itemCode}</td>

                                        <td>${item.itemName}</td>

                                        <td>
                                            <span class="type-badge">
                                                <c:choose>
                                                    <c:when test="${item.itemType == 'PRODUCT'}">
                                                        완제품
                                                    </c:when>

                                                    <c:when test="${item.itemType == 'MATERIAL'}">
                                                        자재
                                                    </c:when>

                                                    <c:otherwise>
                                                        ${item.itemType}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>

                                        <td>
                                            <c:out value="${item.spec}"
                                                   default="-" />
                                        </td>

                                        <td>${item.unit}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty item.standardPrice}">
                                                    -
                                                </c:when>

                                                <c:otherwise>
                                                    ${item.standardPrice}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${item.active == 1}">
                                                    <span class="state-badge enabled">
                                                        사용
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="state-badge disabled">
                                                        미사용
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <a class="table-link"
                                               href="${pageContext.request.contextPath}/development/items/${item.itemId}">
                                                상세보기
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
