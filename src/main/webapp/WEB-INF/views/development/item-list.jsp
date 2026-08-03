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

        .empty-state {
            padding: 44px 20px;
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
                    생산과 BOM에서 사용하는 품목 정보를
                    조회하고 관리합니다.
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
                                    <th>규격</th>
                                    <th>재질</th>
                                    <th>제작 사양</th>
                                    <th>도면 참조</th>
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
                                            <c:out value="${item.spec}"
                                                   default="-" />
                                        </td>

                                        <td>
                                            <c:out value="${item.material}"
                                                   default="-" />
                                        </td>

                                        <td>
                                            <c:out value="${item.makeSpec}"
                                                   default="-" />
                                        </td>

                                        <td>
                                            <c:out value="${item.drawingRef}"
                                                   default="-" />
                                        </td>

                                        <td>
                                            <a class="table-link"
                                               href="${pageContext.request.contextPath}/development/items/${item.itemCode}">
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