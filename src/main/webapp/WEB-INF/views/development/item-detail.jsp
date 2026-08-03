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
        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .detail-table th,
        .detail-table td {
            padding: 16px 18px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            vertical-align: middle;
        }

        .detail-table tr:last-child th,
        .detail-table tr:last-child td {
            border-bottom: 0;
        }

        .detail-table th {
            width: 180px;
            color: var(--muted);
            background: #f8fafc;
            font-size: 12px;
            font-weight: 700;
        }

        .detail-table td {
            color: var(--text);
            font-weight: 500;
        }

        .action-bar {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding: 18px;
            border-top: 1px solid var(--border);
        }

        .action-bar form {
            margin: 0;
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
            cursor: pointer;
        }

        .secondary-button:hover {
            color: var(--blue);
            background: #f8fbff;
            border-color: var(--blue);
        }

        .danger-button {
            display: inline-flex;
            height: 40px;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 0 16px;
            color: #fff;
            background: #c62828;
            border: 0;
            border-radius: 5px;
            font-weight: 700;
            cursor: pointer;
        }

        .danger-button:hover {
            background: #a61f1f;
        }

        .empty-state {
            padding: 56px 20px;
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

        @media (max-width: 760px) {
            .detail-table th {
                width: 120px;
            }

            .action-bar {
                flex-direction: column;
            }

            .action-bar a,
            .action-bar form,
            .action-bar button {
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
                <p>등록된 품목의 규격과 제작 정보를 확인합니다.</p>
            </div>
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

        <c:choose>

            <c:when test="${empty item}">
                <section class="panel">

                    <div class="empty-state">
                        <span class="material-symbols-outlined">
                            inventory_2
                        </span>

                        <p>해당 품목을 찾을 수 없습니다.</p>
                    </div>

                    <div class="action-bar">
                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/development/items">

                            <span class="material-symbols-outlined">
                                arrow_back
                            </span>

                            목록으로
                        </a>
                    </div>

                </section>
            </c:when>

            <c:otherwise>
                <section class="panel">

                    <div class="panel-header">
                        <div>
                            <p class="eyebrow">
                                ITEM INFORMATION
                            </p>

                            <h2>${item.itemName}</h2>
                        </div>
                    </div>

                    <table class="detail-table">
                        <tbody>
                            <tr>
                                <th>품목코드</th>
                                <td>${item.itemCode}</td>
                            </tr>

                            <tr>
                                <th>품목명</th>
                                <td>${item.itemName}</td>
                            </tr>

                            <tr>
                                <th>규격</th>
                                <td>
                                    <c:out value="${item.spec}"
                                           default="-" />
                                </td>
                            </tr>

                            <tr>
                                <th>재질</th>
                                <td>
                                    <c:out value="${item.material}"
                                           default="-" />
                                </td>
                            </tr>

                            <tr>
                                <th>제작 사양</th>
                                <td>
                                    <c:out value="${item.makeSpec}"
                                           default="-" />
                                </td>
                            </tr>

                            <tr>
                                <th>도면 참조</th>
                                <td>
                                    <c:out value="${item.drawingRef}"
                                           default="-" />
                                </td>
                            </tr>

                            <tr>
                                <th>등록 일시</th>
                                <td>${item.createdAt}</td>
                            </tr>

                            <tr>
                                <th>수정 일시</th>
                                <td>${item.updatedAt}</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="action-bar">

                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/development/items">

                            <span class="material-symbols-outlined">
                                arrow_back
                            </span>

                            목록으로
                        </a>

                        <a class="primary-button"
                           href="${pageContext.request.contextPath}/development/items/${item.itemCode}/edit">

                            <span class="material-symbols-outlined">
                                edit
                            </span>

                            품목 수정
                        </a>

                        <form action="${pageContext.request.contextPath}/development/items/${item.itemCode}/delete"
                              method="post"
                              onsubmit="return confirm('정말 이 품목을 삭제하시겠습니까?');">

                            <button class="danger-button"
                                    type="submit">

                                <span class="material-symbols-outlined">
                                    delete
                                </span>

                                품목 삭제
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