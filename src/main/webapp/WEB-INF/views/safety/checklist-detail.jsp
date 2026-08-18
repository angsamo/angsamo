<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>점검 상세 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <style>
        .secondary-button { display: inline-flex; height: 38px; align-items: center; padding: 0 14px; color: var(--text); background: var(--white); border: 1px solid var(--border); border-radius: 5px; font-weight: 700; text-decoration: none; }
        .secondary-button:hover { color: var(--blue); border-color: var(--blue); }
        .page-heading { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
        .empty-state { padding: 40px 20px; color: var(--muted); text-align: center; }
        .empty-state .material-symbols-outlined { display: block; margin-bottom: 10px; color: #9aa6b5; font-size: 44px; }
        .item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 14px; padding: 0 20px 20px; }
        .item-card { padding: 12px; background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; }
        .item-card img { width: 100%; height: 120px; object-fit: cover; border-radius: 6px; margin-bottom: 8px; background: #eef2f7; }
        .item-card .no-media { display: flex; align-items: center; justify-content: center; height: 120px; margin-bottom: 8px; color: var(--muted); background: #eef2f7; border-radius: 6px; }
        .item-card .memo { margin: 6px 0 0; color: var(--muted); font-size: 12px; }
        .item-card .time { margin: 4px 0 0; color: var(--muted); font-size: 11px; }
        .detail-header { display: flex; align-items: center; justify-content: space-between; padding: 18px 20px 0; }
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
                <h1>점검 상세</h1>
                <p>등록된 확인 항목의 안전모 착용 여부를 확인합니다.</p>
            </div>
            <a class="secondary-button" href="${pageContext.request.contextPath}/safety/checklist">← 안전모 점검 목록</a>
        </section>

        <section class="panel">
            <div class="detail-header">
                <div>
                    <p class="eyebrow">${checklist.status == 'COMPLETED' ? '완료' : '진행 중'}</p>
                    <h2>점검 #${checklist.checklistId} · ${checklist.checkDate} <c:out value="${empty checklist.location ? '' : ' · '.concat(checklist.location)}"/></h2>
                    <p style="color:var(--muted); font-size:13px; margin-top:4px;">부서 <c:out value="${empty checklist.departmentName ? '전체' : checklist.departmentName}"/> · 점검자 <c:out value="${checklist.checkedByName}"/></p>
                </div>
            </div>

            <c:if test="${empty items}"><div class="empty-state"><span class="material-symbols-outlined">checklist</span><p>등록된 확인 항목이 없습니다.</p></div></c:if>
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
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
