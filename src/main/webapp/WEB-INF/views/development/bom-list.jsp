<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>BOM 관리</title>

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

        .table-action-group {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .table-action {
            display: inline-flex;
            height: 32px;
            align-items: center;
            justify-content: center;
            gap: 4px;
            padding: 0 10px;
            border: 1px solid var(--border);
            border-radius: 5px;
            background: var(--white);
            color: var(--text);
            font-size: 12px;
            font-weight: 700;
            transition: 150ms ease;
        }

        .table-action:hover {
            color: var(--blue);
            background: #f8fbff;
            border-color: var(--blue);
        }

        .table-action .material-symbols-outlined {
            font-size: 17px;
        }

        .parent-link {
            color: var(--blue);
            font-weight: 700;
        }

        .parent-link:hover {
            text-decoration: underline;
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
        }

        .secondary-button:hover {
            color: var(--blue);
            background: #f8fbff;
            border-color: var(--blue);
        }

        .empty-box {
            padding: 56px 20px;
            color: var(--muted);
            text-align: center;
        }

        .empty-box .material-symbols-outlined {
            display: block;
            margin-bottom: 10px;
            color: #9aa6b5;
            font-size: 44px;
        }

        .empty-box p {
            margin: 0 0 16px;
        }

        @media (max-width: 760px) {
            .page-heading {
                align-items: flex-start;
                flex-direction: column;
                gap: 12px;
            }

            .page-heading > a {
                width: 100%;
            }

            .table-action-group {
                flex-direction: column;
                align-items: stretch;
            }

            .table-action {
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
                <p class="eyebrow">DEVELOPMENT</p>
                <h1>BOM 관리</h1>

                <c:choose>
                    <c:when test="${not empty parentItem}">
                        <p>선택한 완제품의 구성 자재와 필요 수량을 조회합니다.</p>
                    </c:when>

                    <c:otherwise>
                        <p>완제품별 구성 자재와 필요 수량을 관리합니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <c:when test="${not empty parentItem}">
                    <a class="secondary-button"
                       href="${pageContext.request.contextPath}/development/boms">

                        <span class="material-symbols-outlined">
                            arrow_back
                        </span>

                        전체 BOM
                    </a>
                </c:when>

                <c:otherwise>
                    <a class="primary-button"
                       href="${pageContext.request.contextPath}/development/boms/new">

                        <span class="material-symbols-outlined">
                            add
                        </span>

                        <span>BOM 등록</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </section>

        <c:if test="${not empty message}">
            <div class="notice message-notice">
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

        <c:if test="${not empty parentItem}">
            <div class="summary-box">
                <span class="material-symbols-outlined">
                    inventory_2
                </span>

                <div>
                    <strong>
                        <c:out value="${parentItem.itemName}" />
                        (<c:out value="${parentItem.itemCode}" />)
                    </strong>

                    <p>
                        완제품 식별번호: ${parentItem.itemId}
                    </p>
                </div>
            </div>
        </c:if>

        <section class="panel table-panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">BOM LIST</p>

                    <c:choose>
                        <c:when test="${not empty parentItem}">
                            <h2>완제품별 구성 자재</h2>
                        </c:when>

                        <c:otherwise>
                            <h2>전체 BOM 목록</h2>
                        </c:otherwise>
                    </c:choose>
                </div>

                <span class="list-count">
                    총
                    <strong>
                        <c:out value="${empty boms ? 0 : boms.size()}" />
                    </strong>
                    건
                </span>
            </div>

            <c:choose>
                <c:when test="${empty boms}">
                    <div class="empty-box">
                        <span class="material-symbols-outlined">
                            account_tree
                        </span>

                        <p>등록된 BOM 정보가 없습니다.</p>

                        <a class="primary-button"
                           href="${pageContext.request.contextPath}/development/boms/new"
                           style="display:inline-flex;">

                            <span class="material-symbols-outlined">
                                add
                            </span>

                            <span>첫 BOM 등록</span>
                        </a>
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
                                    <th>등록일</th>
                                    <th>관리</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="bom"
                                           items="${boms}">

                                    <tr>
                                        <td>${bom.bomId}</td>

                                        <td>
                                            <a class="parent-link"
                                               href="${pageContext.request.contextPath}/development/boms/parent/${bom.parentItemId}">

                                                <div class="item-code">
                                                    <c:out value="${bom.parentItemCode}" />
                                                </div>

                                                <div class="item-name">
                                                    <c:out value="${bom.parentItemName}" />
                                                </div>
                                            </a>
                                        </td>

                                        <td>
                                            <div class="item-code">
                                                <c:out value="${bom.componentItemCode}" />
                                            </div>

                                            <div class="item-name">
                                                <c:out value="${bom.componentItemName}" />
                                            </div>
                                        </td>

                                        <td class="quantity">
                                            ${bom.requiredQty}
                                        </td>

                                        <td>
                                            <span class="unit-badge">
                                                <c:out value="${bom.componentUnit}" />
                                            </span>
                                        </td>

                                        <td>${bom.createdAt}</td>

                                        <td>
                                            <div class="table-action-group">

                                                <a class="table-action"
                                                   href="${pageContext.request.contextPath}/development/boms/${bom.bomId}">

                                                    <span class="material-symbols-outlined">
                                                        visibility
                                                    </span>

                                                    상세
                                                </a>

                                                <a class="table-action"
                                                   href="${pageContext.request.contextPath}/development/boms/${bom.bomId}/edit">

                                                    <span class="material-symbols-outlined">
                                                        edit
                                                    </span>

                                                    수정
                                                </a>

                                            </div>
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