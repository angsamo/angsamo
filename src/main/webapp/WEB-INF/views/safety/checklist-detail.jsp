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
        .item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; padding: 0 20px 20px; }
        .item-card { background: #f8fafc; border: 1px solid var(--border); border-left: 4px solid var(--border); border-radius: 8px; overflow: hidden; }
        .item-card.pass { border-left-color: #2e9e5b; }
        .item-card.fail { border-left-color: #d64545; }
        .item-card img { width: 100%; height: 180px; object-fit: cover; display: block; background: #eef2f7; }
        .item-card .no-media { display: flex; align-items: center; justify-content: center; height: 180px; color: var(--muted); background: #eef2f7; }
        .item-card .item-body { padding: 14px; }
        .item-card .item-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
        .item-card .item-no { font-size: 12px; font-weight: 700; color: var(--muted); }
        .item-card .overall-badge { font-size: 12px; font-weight: 800; padding: 3px 10px; border-radius: 999px; }
        .item-card .overall-badge.pass { color: #1d7a3e; background: #e5f6ea; }
        .item-card .overall-badge.fail { color: #9f1d1d; background: #fde8e8; }
        .item-card .badge-row { display: flex; flex-wrap: wrap; gap: 4px; margin-bottom: 10px; }
        .item-card .memo-box { padding: 8px 10px; background: #fff; border: 1px solid var(--border); border-radius: 6px; font-size: 12px; color: var(--text); margin-bottom: 8px; }
        .item-card .memo-box.empty { color: var(--muted); font-style: italic; }
        .item-card .time { color: var(--muted); font-size: 11px; }
        .detail-header { display: flex; align-items: center; justify-content: space-between; padding: 18px 20px 0; }
        .summary-row { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; padding: 18px 20px 4px; }
        .summary-stat { padding: 14px 16px; background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; }
        .summary-stat p { margin: 0 0 4px; color: var(--muted); font-size: 12px; font-weight: 700; }
        .summary-stat strong { font-size: 22px; }
        .summary-stat.fail strong { color: #d64545; }
        .summary-stat.pass strong { color: #2e9e5b; }
        @media (max-width: 700px) { .summary-row { grid-template-columns: 1fr; } }
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

            <c:if test="${not empty items}">
                <c:set var="failCount" value="${0}" />
                <c:forEach var="item" items="${items}">
                    <c:if test="${!item.pass}"><c:set var="failCount" value="${failCount + 1}" /></c:if>
                </c:forEach>

                <div class="summary-row">
                    <div class="summary-stat"><p>총 확인 건수</p><strong>${items.size()}건</strong></div>
                    <div class="summary-stat pass"><p>적합</p><strong>${items.size() - failCount}건</strong></div>
                    <div class="summary-stat fail"><p>부적합</p><strong>${failCount}건</strong></div>
                </div>
            </c:if>

            <div class="item-grid">
                <c:forEach var="item" items="${items}" varStatus="loop">
                    <div class="item-card ${item.pass ? 'pass' : 'fail'}">
                        <c:choose>
                            <c:when test="${not empty item.mediaPath}">
                                <img src="${pageContext.request.contextPath}/safety/uploads/${item.mediaPath}" alt="확인 사진">
                            </c:when>
                            <c:otherwise>
                                <div class="no-media"><span class="material-symbols-outlined">image_not_supported</span></div>
                            </c:otherwise>
                        </c:choose>
                        <div class="item-body">
                            <div class="item-top">
                                <span class="item-no">확인 #${loop.index + 1}</span>
                                <span class="overall-badge ${item.pass ? 'pass' : 'fail'}">${item.pass ? '적합' : '부적합'}</span>
                            </div>
                            <div class="badge-row">
                                <span class="state-badge ${item.helmetWorn ? 'enabled' : 'disabled'}">안전모 ${item.helmetWorn ? '착용' : '미착용'}</span>
                                <span class="state-badge ${item.chinStrapFastened ? 'enabled' : 'disabled'}">턱끈 ${item.chinStrapFastened ? '체결' : '미체결'}</span>
                                <span class="state-badge ${item.damaged ? 'disabled' : 'enabled'}">${item.damaged ? '파손' : '정상'}</span>
                                <span class="state-badge ${item.expired ? 'disabled' : 'enabled'}">${item.expired ? '기한초과' : '기한정상'}</span>
                                <span class="state-badge">${item.detectionSource == 'AI' ? 'AI 판정' : '수동 판정'}</span>
                            </div>
                            <div class="memo-box ${empty item.memo ? 'empty' : ''}"><c:out value="${empty item.memo ? '비고 없음' : item.memo}"/></div>
                            <p class="time">${item.checkedAt}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
