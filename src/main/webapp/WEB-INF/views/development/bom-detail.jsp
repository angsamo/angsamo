<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>BOM 상세</title>

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

        .item-name {
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .quantity {
            font-size: 16px;
            font-weight: 700;
            font-variant-numeric: tabular-nums;
        }

        .unit-badge {
            display: inline-flex;
            min-width: 44px;
            align-items: center;
            justify-content: center;
            padding: 4px 9px;
            color: #14653f;
            background: #ddf4e7;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
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

        .edit-button:hover {
            background: var(--navy-soft);
        }

        .delete-button {
            color: #fff;
            background: #d9363e;
            border: 1px solid #d9363e;
        }

        .delete-button:hover {
            background: #b9262d;
            border-color: #b9262d;
        }

        .detail-actions form {
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
                <p class="eyebrow">DEVELOPMENT</p>
                <h1>BOM 상세</h1>
                <p>완제품과 구성 자재의 BOM 정보를 확인합니다.</p>
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
                    <p class="eyebrow">BOM DETAIL</p>

                    <h2>
                        <c:out value="${bom.parentItemName}" />
                        BOM
                    </h2>
                </div>
            </div>

            <div class="detail-body">

                <table class="detail-table">

                    <tr>
                        <th>BOM 번호</th>
                        <td>${bom.bomId}</td>
                    </tr>

                    <tr>
                        <th>완제품</th>
                        <td>
                            <div class="item-code">
                                <c:out value="${bom.parentItemCode}" />
                            </div>

                            <div class="item-name">
                                <c:out value="${bom.parentItemName}" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <th>구성 자재</th>
                        <td>
                            <div class="item-code">
                                <c:out value="${bom.componentItemCode}" />
                            </div>

                            <div class="item-name">
                                <c:out value="${bom.componentItemName}" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <th>필요 수량</th>
                        <td>
                            <span class="quantity">
                                <fmt:formatNumber
                                    value="${bom.requiredQty}"
                                    type="number"
                                    minFractionDigits="0"
                                    maxFractionDigits="3" />
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>단위</th>
                        <td>
                            <span class="unit-badge">
                                <c:out value="${bom.componentUnit}" />
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>등록일</th>
                        <td>${bom.createdAt}</td>
                    </tr>

                    <tr>
                        <th>수정일</th>
                        <td>${bom.updatedAt}</td>
                    </tr>

                </table>

                <div class="detail-actions">

                    <a class="action-button list-button"
                       href="${pageContext.request.contextPath}/development/boms">

                        <span class="material-symbols-outlined">arrow_back</span>
                        목록
                    </a>

                    <a class="action-button edit-button"
                       href="${pageContext.request.contextPath}/development/boms/${bom.bomId}/edit">

                        <span class="material-symbols-outlined">edit</span>
                        수정
                    </a>

                    <form action="${pageContext.request.contextPath}/development/boms/${bom.bomId}/delete"
                          method="post"
                          onsubmit="return confirm('이 BOM 구성 자재를 삭제하시겠습니까?');">

                        <button class="action-button delete-button"
                                type="submit">

                            <span class="material-symbols-outlined">delete</span>
                            삭제
                        </button>

                    </form>

                </div>

            </div>

        </section>

    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

</body>
</html>