<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>품목 상세</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .detail-panel {
            max-width: 1000px;
        }

        .panel-body {
            padding: 0;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
        }

        .info-table th,
        .info-table td {
            padding: 16px 18px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
        }

        .info-table th {
            width: 180px;
            color: var(--text);
            background: #f7f9fc;
            font-size: 13px;
            font-weight: 700;
        }

        .info-table td {
            color: var(--text);
            background: var(--white);
            font-size: 13px;
        }

        .info-table tr:last-child th,
        .info-table tr:last-child td {
            border-bottom: 0;
        }

        .description-value {
            line-height: 1.7;
            white-space: pre-wrap;
        }

        .type-badge,
        .status-badge {
            display: inline-flex;
            min-width: 64px;
            align-items: center;
            justify-content: center;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }

        .type-badge {
            color: #155cb2;
            background: #e2efff;
        }

        .status-badge.active {
            color: #14653f;
            background: #ddf4e7;
        }

        .status-badge.inactive {
            color: #9f1d1d;
            background: #fff0f0;
        }

        .action-area {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 10px;
            padding: 18px;
            background: #fbfcfe;
            border-top: 1px solid var(--border);
        }

        .action-area form {
            margin: 0;
        }

        .action-button {
            display: inline-flex;
            height: 40px;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 0 16px;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 700;
            line-height: 1;
            cursor: pointer;
            transition: 150ms ease;
        }

        .action-button .material-symbols-outlined {
            font-size: 19px;
        }

        .list-button {
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
        }

        .list-button:hover {
            color: var(--blue);
            background: #f5f9ff;
            border-color: var(--blue);
        }

        .edit-button {
            color: #fff;
            background: var(--navy);
            border: 1px solid var(--navy);
        }

        .edit-button:hover {
            background: var(--navy-soft);
            border-color: var(--navy-soft);
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

        .message-box {
            margin-bottom: 18px;
        }

        .error-notice {
            color: #9f1d1d;
            background: #fff0f0;
            border-color: #f1b8b8;
        }

        .empty-value {
            color: var(--muted);
        }

        @media (max-width: 760px) {
            .info-table th {
                width: 120px;
            }

            .action-area {
                flex-direction: column;
            }

            .action-area > a,
            .action-area > form,
            .action-area button {
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
                <h1>품목 상세</h1>
                <p>등록된 품목의 기준정보를 확인합니다.</p>
            </div>
        </section>

        <c:if test="${not empty message}">
            <div class="notice message-box">
                <span class="material-symbols-outlined">check_circle</span>
                <p>${message}</p>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="notice error-notice message-box">
                <span class="material-symbols-outlined">error</span>
                <p>${errorMessage}</p>
            </div>
        </c:if>

        <c:choose>

            <c:when test="${empty item}">
                <section class="panel detail-panel">

                    <div class="panel-header">
                        <div>
                            <p class="eyebrow">ITEM DETAIL</p>
                            <h2>품목 조회 결과</h2>
                        </div>
                    </div>

                    <div style="padding: 50px 20px; text-align: center; color: var(--muted);">
                        <span class="material-symbols-outlined"
                              style="display:block; margin-bottom:10px; font-size:42px;">
                            inventory_2
                        </span>

                        해당 품목을 찾을 수 없습니다.
                    </div>

                    <div class="action-area">
                        <a class="action-button list-button"
                           href="${pageContext.request.contextPath}/development/items">

                            <span class="material-symbols-outlined">arrow_back</span>
                            목록으로
                        </a>
                    </div>

                </section>
            </c:when>

            <c:otherwise>
                <section class="panel detail-panel">

                    <div class="panel-header">
                        <div>
                            <p class="eyebrow">ITEM DETAIL</p>
                            <h2>${item.itemName}</h2>
                        </div>
                    </div>

                    <div class="panel-body">

                        <table class="info-table">
                            <tbody>
                                <tr>
                                    <th>품목번호</th>
                                    <td>${item.itemId}</td>
                                </tr>

                                <tr>
                                    <th>품목코드</th>
                                    <td>${item.itemCode}</td>
                                </tr>

                                <tr>
                                    <th>품목명</th>
                                    <td>${item.itemName}</td>
                                </tr>

                                <tr>
                                    <th>품목유형</th>
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
                                </tr>

                                <tr>
                                    <th>규격</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty item.spec}">
                                                <span class="empty-value">-</span>
                                            </c:when>

                                            <c:otherwise>
                                                <c:out value="${item.spec}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>

                                <tr>
                                    <th>단위</th>
                                    <td>${item.unit}</td>
                                </tr>

                                <tr>
                                    <th>기준단가</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty item.standardPrice}">
                                                <span class="empty-value">-</span>
                                            </c:when>

                                            <c:otherwise>
                                                ${item.standardPrice}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>

                                <tr>
                                    <th>설명</th>
                                    <td class="description-value">
                                        <c:choose>
                                            <c:when test="${empty item.description}">
                                                <span class="empty-value">-</span>
                                            </c:when>

                                            <c:otherwise>
                                                <c:out value="${item.description}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>

                                <tr>
                                    <th>사용여부</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.active == 1}">
                                                <span class="status-badge active">
                                                    사용
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="status-badge inactive">
                                                    미사용
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>

                                <tr>
                                    <th>등록일</th>
                                    <td>${item.createdAt}</td>
                                </tr>

                                <tr>
                                    <th>수정일</th>
                                    <td>${item.updatedAt}</td>
                                </tr>
                            </tbody>
                        </table>

                    </div>

                    <div class="action-area">

                        <a class="action-button list-button"
                           href="${pageContext.request.contextPath}/development/items">

                            <span class="material-symbols-outlined">arrow_back</span>
                            목록
                        </a>

                        <a class="action-button edit-button"
                           href="${pageContext.request.contextPath}/development/items/${item.itemId}/edit">

                            <span class="material-symbols-outlined">edit</span>
                            수정
                        </a>

                        <form action="${pageContext.request.contextPath}/development/items/${item.itemId}/delete"
                              method="post"
                              onsubmit="return confirm('정말 이 품목을 삭제하시겠습니까?');">

                            <button class="action-button delete-button"
                                    type="submit">

                                <span class="material-symbols-outlined">delete</span>
                                삭제
                            </button>

                        </form>

                    </div>

                </section>
            </c:otherwise>

        </c:choose>

    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

</body>
</html>