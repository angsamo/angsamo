<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>BOM 조회</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .summary-box {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 18px;
            padding: 16px 18px;
            background: #eef5ff;
            border: 1px solid #c8dcf8;
            border-radius: 8px;
        }

        .summary-box .material-symbols-outlined {
            color: var(--blue);
            font-size: 28px;
        }

        .summary-box strong {
            display: block;
            margin-bottom: 3px;
            font-size: 15px;
        }

        .summary-box p {
            margin: 0;
            color: var(--muted);
            font-size: 12px;
        }

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

        .item-name {
            margin-top: 3px;
            color: var(--muted);
            font-size: 11px;
        }

        .quantity {
            font-weight: 700;
            font-variant-numeric: tabular-nums;
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

        .action-link {
            color: var(--blue);
            font-weight: 700;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .back-button {
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
        }

        .back-button:hover {
            color: var(--blue);
            border-color: var(--blue);
            background: #f8fbff;
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
                <h1>BOM 조회</h1>

                <c:choose>
                    <c:when test="${not empty parentItem}">
                        <p>
                            선택한 완제품에 필요한 구성 자재를 조회합니다.
                        </p>
                    </c:when>

                    <c:otherwise>
                        <p>
                            전체 완제품과 구성 자재의 BOM 정보를 조회합니다.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty parentItem}">
                <a class="back-button"
                   href="${pageContext.request.contextPath}/development/boms">

                    <span class="material-symbols-outlined">arrow_back</span>
                    전체 BOM
                </a>
            </c:if>
        </section>

        <c:if test="${not empty parentItem}">
            <div class="summary-box">
                <span class="material-symbols-outlined">inventory</span>

                <div>
                    <strong>
                        ${parentItem.itemName}
                        (${parentItem.itemCode})
                    </strong>

                    <p>
                        완제품 식별번호: ${parentItem.itemId}
                    </p>
                </div>
            </div>
        </c:if>

        <section class="panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">BOM LIST</p>

                    <c:choose>
                        <c:when test="${not empty parentItem}">
                            <h2>완제품별 구성 자재</h2>
                        </c:when>

                        <c:otherwise>
                            <h2>전체 BOM</h2>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:choose>

                <c:when test="${empty boms}">
                    <div class="empty-state">
                        <span class="material-symbols-outlined">
                            account_tree
                        </span>

                        <p>등록된 BOM 정보가 없습니다.</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="table-scroll">

                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>BOM 번호</th>
                                    <th>완제품</th>
                                    <th>구성 자재</th>
                                    <th>필요 수량</th>
                                    <th>단위</th>
                                    <th>완제품별 조회</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="bom" items="${boms}">
                                    <tr>
                                        <td>${bom.bomId}</td>

                                        <td>
                                            <div class="item-code">
                                                ${bom.parentItemCode}
                                            </div>

                                            <div class="item-name">
                                                ${bom.parentItemName}
                                            </div>
                                        </td>

                                        <td>
                                            <div class="item-code">
                                                ${bom.componentItemCode}
                                            </div>

                                            <div class="item-name">
                                                ${bom.componentItemName}
                                            </div>
                                        </td>

                                        <td class="quantity">
                                            ${bom.requiredQty}
                                        </td>

                                        <td>
                                            <span class="unit-badge">
                                                ${bom.componentUnit}
                                            </span>
                                        </td>

                                        <td>
                                            <a class="action-link"
                                               href="${pageContext.request.contextPath}/development/boms/parent/${bom.parentItemId}">
                                                구성 자재 보기
                                            </a>
                                        </td>

                                        <td>${bom.createdAt}</td>
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