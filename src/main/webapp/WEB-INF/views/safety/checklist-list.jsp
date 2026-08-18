<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>안전모 점검 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <style>
        .secondary-button { display: inline-flex; height: 38px; align-items: center; padding: 0 14px; color: var(--text); background: var(--white); border: 1px solid var(--border); border-radius: 5px; font-weight: 700; text-decoration: none; }
        .secondary-button:hover { color: var(--blue); border-color: var(--blue); }
        .page-heading { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
        .empty-state { padding: 40px 20px; color: var(--muted); text-align: center; }
        .empty-state .material-symbols-outlined { display: block; margin-bottom: 10px; color: #9aa6b5; font-size: 44px; }
        .start-form { display: grid; grid-template-columns: 1fr 1fr auto; gap: 10px; align-items: end; padding: 20px; }
        .start-form label { display: flex; flex-direction: column; gap: 6px; color: var(--muted); font-size: 12px; font-weight: 700; }
        .start-form input { height: 40px; padding: 0 10px; border: 1px solid var(--border); border-radius: 5px; }
        .item-form { display: grid; grid-template-columns: 1fr 160px 1fr auto; gap: 10px; align-items: end; padding: 18px; margin-bottom: 18px; }
        .item-form label { display: flex; flex-direction: column; gap: 6px; color: var(--muted); font-size: 12px; font-weight: 700; }
        .item-form input[type="file"], .item-form input[type="text"], .item-form select { height: 40px; padding: 0 10px; border: 1px solid var(--border); border-radius: 5px; }
        .item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 14px; padding: 0 20px 20px; }
        .item-card { padding: 12px; background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; }
        .item-card img { width: 100%; height: 120px; object-fit: cover; border-radius: 6px; margin-bottom: 8px; background: #eef2f7; }
        .item-card .no-media { display: flex; align-items: center; justify-content: center; height: 120px; margin-bottom: 8px; color: var(--muted); background: #eef2f7; border-radius: 6px; }
        .item-card .memo { margin: 6px 0 0; color: var(--muted); font-size: 12px; }
        .item-card .time { margin: 4px 0 0; color: var(--muted); font-size: 11px; }
        .active-header { display: flex; align-items: center; justify-content: space-between; padding: 18px 20px 0; }
        @media (max-width: 900px) { .start-form, .item-form { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <main class="workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">SAFETY / HELMET</p>
                <h1>안전모 점검</h1>
                <p>사진·영상을 확인해 안전모 착용 여부를 점검합니다.</p>
            </div>
            <a class="secondary-button" href="${pageContext.request.contextPath}/safety">← 안전관리 전체 현황</a>
        </section>

        <c:if test="${not empty success}"><div class="flash success">${success}</div></c:if>
        <c:if test="${not empty error}"><div class="flash error">${error}</div></c:if>

        <c:choose>
            <c:when test="${empty active}">
                <section class="panel">
                    <div class="panel-header"><div><p class="eyebrow">START</p><h2>새 점검 시작</h2></div></div>
                    <form class="start-form" method="post" action="${pageContext.request.contextPath}/safety/checklist">
                        <label>점검일<input type="date" name="checkDate" value="${today}"></label>
                        <label>점검 장소<input type="text" name="location" maxlength="100" placeholder="예: 생산현장 A구역"></label>
                        <button class="action-button" type="submit">점검 시작</button>
                    </form>
                </section>
            </c:when>
            <c:otherwise>
                <section class="panel">
                    <div class="active-header">
                        <div><p class="eyebrow">IN PROGRESS</p><h2>점검 #${active.checklistId} · ${active.checkDate} <c:out value="${empty active.location ? '' : ' · '.concat(active.location)}"/></h2></div>
                        <form method="post" action="${pageContext.request.contextPath}/safety/checklist/${active.checklistId}/complete" onsubmit="return confirm('점검을 완료 처리하시겠습니까?');">
                            <button class="primary-button" type="submit">점검 완료 처리</button>
                        </form>
                    </div>

                    <form class="item-form" method="post" action="${pageContext.request.contextPath}/safety/checklist/${active.checklistId}/items" enctype="multipart/form-data">
                        <label>사진/영상<input type="file" name="media" accept="image/*,video/*" required></label>
                        <label>착용 여부
                            <select name="helmetWorn">
                                <option value="true">착용</option>
                                <option value="false">미착용</option>
                            </select>
                        </label>
                        <label>비고<input type="text" name="memo" maxlength="300" placeholder="특이사항 입력"></label>
                        <button class="action-button" type="submit">확인 항목 추가</button>
                    </form>

                    <c:if test="${empty items}"><div class="empty-state"><span class="material-symbols-outlined">checklist</span><p>아직 등록된 확인 항목이 없습니다.</p></div></c:if>
                    <div class="item-grid">
                        <c:forEach var="item" items="${items}">
                            <div class="item-card">
                                <c:choose>
                                    <c:when test="${not empty item.mediaPath}">
                                        <img src="${pageContext.request.contextPath}/safety/uploads/${item.mediaPath}" alt="확인 사진">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-media"><span class="material-symbols-outlined">image_not_supported</span></div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="state-badge ${item.helmetWorn ? 'enabled' : 'disabled'}">${item.helmetWorn ? '착용' : '미착용'}</span>
                                <span class="state-badge">${item.detectionSource == 'AI' ? 'AI' : '수동'}</span>
                                <p class="memo"><c:out value="${empty item.memo ? '-' : item.memo}"/></p>
                                <p class="time">${item.checkedAt}</p>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </c:otherwise>
        </c:choose>

        <section class="panel table-panel">
            <div class="panel-header">
                <div><p class="eyebrow">HISTORY</p><h2>지난 점검 이력</h2></div>
                <span class="list-count">총 <strong>${checklists.size()}</strong>건</span>
            </div>
            <c:choose>
                <c:when test="${empty checklists}">
                    <div class="empty-state"><span class="material-symbols-outlined">history</span><p>등록된 점검 이력이 없습니다.</p></div>
                </c:when>
                <c:otherwise>
                    <div class="table-scroll">
                        <table class="data-table">
                            <thead><tr><th>점검일</th><th>부서</th><th>장소</th><th>점검자</th><th>확인 건수</th><th>미착용</th><th>상태</th></tr></thead>
                            <tbody>
                                <c:forEach var="row" items="${checklists}">
                                    <tr class="row-link" onclick="location.href='${pageContext.request.contextPath}/safety/checklist/${row.checklistId}'" style="cursor:pointer;">
                                        <td>${row.checkDate}</td>
                                        <td><c:out value="${empty row.departmentName ? '전체' : row.departmentName}"/></td>
                                        <td><c:out value="${empty row.location ? '-' : row.location}"/></td>
                                        <td><c:out value="${row.checkedByName}"/></td>
                                        <td>${row.itemCount}</td>
                                        <td><c:if test="${row.helmetOffCount > 0}"><span class="state-badge disabled">${row.helmetOffCount}건</span></c:if><c:if test="${row.helmetOffCount == 0}">-</c:if></td>
                                        <td><span class="state-badge ${row.status == 'COMPLETED' ? 'enabled' : ''}">${row.status == 'COMPLETED' ? '완료' : '진행 중'}</span></td>
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
