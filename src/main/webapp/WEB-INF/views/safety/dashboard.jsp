<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>안전관리 현황 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <style>
        .safety-panels { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 18px; }
        .safety-panel { padding: 20px; }
        .safety-panel .panel-header { margin-bottom: 14px; }
        .safety-panel-link { color: var(--blue); font-weight: 700; font-size: 12px; }
        @media (max-width: 900px) { .safety-panels { grid-template-columns: 1fr; } }
        .risk-card { display: flex; align-items: center; gap: 20px; padding: 22px 24px; margin-bottom: 18px; }
        .risk-badge { display: flex; align-items: center; justify-content: center; min-width: 88px; height: 88px; border-radius: 50%; font-size: 20px; font-weight: 800; color: #fff; }
        .risk-badge.safe { background: #2e9e5b; }
        .risk-badge.caution { background: #e0a12c; }
        .risk-badge.danger { background: #d64545; }
        .risk-detail p { margin: 2px 0; color: var(--muted); font-size: 13px; }
        .risk-detail h2 { margin: 0 0 4px; }
        .violation-list { list-style: none; margin: 0; padding: 0; }
        .violation-list li { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 10px 0; border-bottom: 1px solid var(--border); font-size: 13px; }
        .violation-list li:last-child { border-bottom: none; }
        .violation-list .v-meta { color: var(--muted); font-size: 12px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <main class="workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">SAFETY</p>
                <h1>안전관리 현황</h1>
                <p>날씨 경보와 현장 안전 점검 상태를 한눈에 확인합니다.</p>
            </div>
        </section>

        <section class="panel risk-card">
            <c:choose>
                <c:when test="${weather.riskLevel == '위험'}">
                    <div class="risk-badge danger">위험</div>
                </c:when>
                <c:when test="${weather.riskLevel == '주의'}">
                    <div class="risk-badge caution">주의</div>
                </c:when>
                <c:otherwise>
                    <div class="risk-badge safe">안전</div>
                </c:otherwise>
            </c:choose>
            <div class="risk-detail">
                <p class="eyebrow">오늘의 위험도 요약</p>
                <h2>현재 기온 ${weather.temperature}℃ · 강수량 ${weather.precipitation}mm</h2>
                <c:choose>
                    <c:when test="${not empty weather.alerts}">
                        <p>발효 중인 특보 <strong>${weather.alerts.size()}건</strong> — 작업 전 반드시 확인하세요.</p>
                    </c:when>
                    <c:otherwise>
                        <p>현재 발효 중인 특보가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <div class="safety-panels">
            <section class="panel safety-panel">
                <div class="panel-header"><div><p class="eyebrow">WEATHER</p><h2>날씨</h2></div><a class="safety-panel-link" href="${pageContext.request.contextPath}/safety/weather">상세보기 →</a></div>
                <div class="stack-bar">
                    <c:choose>
                        <c:when test="${not empty weather.alerts}">
                            <div class="segment seg-red" style="width:100%"></div>
                        </c:when>
                        <c:otherwise>
                            <div class="segment seg-green" style="width:100%"></div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="stack-legend">
                    <c:choose>
                        <c:when test="${not empty weather.alerts}">
                            <span class="legend-item"><span class="dot red"></span>특보 <strong>${weather.alerts.size()}건</strong> 발효 중</span>
                        </c:when>
                        <c:otherwise>
                            <span class="legend-item"><span class="dot green"></span>정상 · 현재 기온 <strong>${weather.temperature}℃</strong></span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <section class="panel safety-panel">
                <div class="panel-header"><div><p class="eyebrow">HELMET</p><h2>최근 미착용 이력</h2></div><a class="safety-panel-link" href="${pageContext.request.contextPath}/safety/checklist">전체 점검 보기 →</a></div>
                <c:choose>
                    <c:when test="${empty recentViolations}">
                        <p style="color:var(--muted); font-size:13px;">최근 안전모 미착용 적발 이력이 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <ul class="violation-list">
                            <c:forEach var="v" items="${recentViolations}">
                                <li>
                                    <span class="state-badge disabled">미착용</span>
                                    <span class="v-meta"><c:out value="${empty v.departmentName ? '전체' : v.departmentName}"/> · <c:out value="${empty v.location ? '-' : v.location}"/></span>
                                    <span class="v-meta">${v.checkedAt}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
