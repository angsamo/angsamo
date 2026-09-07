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
        .todo-warning { display: flex; align-items: center; gap: 12px; padding: 14px 18px; margin-bottom: 18px; color: #8a4a06; background: #fff4e0; border: 1px solid #f0c98a; border-radius: 8px; font-size: 13px; font-weight: 700; }
        .todo-warning .material-symbols-outlined { font-size: 22px; }
        .quick-actions { display: flex; gap: 12px; margin-bottom: 18px; }
        .quick-action-btn { flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px; height: 52px; border-radius: 8px; font-weight: 800; font-size: 14px; text-decoration: none; color: #fff; background: var(--blue); }
        .quick-action-btn:hover { opacity: .9; }
        .quick-action-btn.secondary { background: #2e9e5b; }
        .summary-stat-row { display: flex; gap: 10px; }
        .summary-stat-row div { flex: 1; padding: 12px; background: #f8fafc; border: 1px solid var(--border); border-radius: 6px; text-align: center; }
        .summary-stat-row strong { display: block; font-size: 20px; }
        .summary-stat-row span { font-size: 11px; color: var(--muted); }
        .cctv-live-dot { display: inline-flex; width: 8px; height: 8px; border-radius: 50%; margin-right: 6px; }
        .cctv-live-dot.on { background: #2e9e5b; } .cctv-live-dot.off { background: #9aa6b5; }
        .trend-bars { display: flex; gap: 8px; align-items: flex-end; height: 90px; padding: 10px 4px 0; }
        .trend-bar-col { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; gap: 6px; height: 100%; }
        .trend-bar { width: 70%; min-height: 6px; max-height: 100%; border-radius: 4px 4px 0 0; }
        .trend-bar.safe { background: #2e9e5b; } .trend-bar.caution { background: #e0a12c; } .trend-bar.danger { background: #d64545; } .trend-bar.none { background: #e1e6ec; }
        .trend-bar-col span { font-size: 10px; color: var(--muted); }
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

        <c:if test="${not checklistSummary.checkedToday}">
            <div class="todo-warning"><span class="material-symbols-outlined">warning</span>오늘은 아직 안전모 점검이 시작되지 않았습니다. 담당자는 점검을 진행해 주세요.</div>
        </c:if>

        <div class="quick-actions">
            <a class="quick-action-btn" href="${pageContext.request.contextPath}/safety/checklist"><span class="material-symbols-outlined">checklist</span>안전모 점검 시작하기</a>
            <a class="quick-action-btn secondary" href="${pageContext.request.contextPath}/safety/cctv"><span class="material-symbols-outlined">videocam</span>CCTV 실시간 탐지</a>
        </div>

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
                <div class="panel-header"><div><p class="eyebrow">HELMET</p><h2>최근 부적합 이력</h2></div><a class="safety-panel-link" href="${pageContext.request.contextPath}/safety/checklist">전체 점검 보기 →</a></div>
                <c:choose>
                    <c:when test="${empty recentViolations}">
                        <p style="color:var(--muted); font-size:13px;">최근 부적합 적발 이력이 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <ul class="violation-list">
                            <c:forEach var="v" items="${recentViolations}">
                                <li>
                                    <span class="state-badge disabled">부적합</span>
                                    <span class="v-meta"><c:out value="${empty v.departmentName ? '전체' : v.departmentName}"/> · <c:out value="${empty v.location ? '-' : v.location}"/></span>
                                    <span class="v-meta">${v.checkedAt}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </section>

            <section class="panel safety-panel">
                <div class="panel-header"><div><p class="eyebrow">CHECKLIST</p><h2>체크리스트 현황</h2></div><a class="safety-panel-link" href="${pageContext.request.contextPath}/safety/checklist">전체 점검 보기 →</a></div>
                <div class="summary-stat-row">
                    <div><strong>${checklistSummary.checkedToday ? 'O' : 'X'}</strong><span>오늘 점검 여부</span></div>
                    <div><strong>${checklistSummary.monthlyChecklistCount}건</strong><span>이번 달 점검 건수</span></div>
                    <div><strong>${checklistSummary.passRatePercent}%</strong><span>이번 달 적합률</span></div>
                </div>
            </section>

            <section class="panel safety-panel">
                <div class="panel-header"><div><p class="eyebrow">CCTV</p><h2>실시간 탐지 상태</h2></div><a class="safety-panel-link" href="${pageContext.request.contextPath}/safety/cctv">실시간 화면 보기 →</a></div>
                <p style="font-size:13px; margin: 0 0 10px;">
                    <span class="cctv-live-dot ${cctvStatus.running ? 'on' : 'off'}"></span>
                    <c:choose>
                        <c:when test="${cctvStatus.running}">탐지 진행 중</c:when>
                        <c:otherwise>탐지 중지 상태</c:otherwise>
                    </c:choose>
                </p>
                <c:choose>
                    <c:when test="${not empty cctvStatus.lastResult}">
                        <p style="color:var(--muted); font-size:13px;">마지막 판정: <c:out value="${cctvStatus.lastResult.message}"/></p>
                        <p style="color:var(--muted); font-size:12px;">${cctvStatus.lastCheckedAt}</p>
                    </c:when>
                    <c:otherwise>
                        <p style="color:var(--muted); font-size:13px;">아직 탐지 기록이 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>

        <section class="panel table-panel">
            <div class="panel-header"><div><p class="eyebrow">TREND</p><h2>최근 7일 날씨 위험도</h2></div><a class="safety-panel-link" href="${pageContext.request.contextPath}/safety/weather">날씨 달력 보기 →</a></div>
            <c:choose>
                <c:when test="${empty recentWeatherLog}">
                    <p style="padding:16px; color:var(--muted); font-size:13px;">아직 기록된 날씨 데이터가 없습니다. 날씨 화면을 조회하면 하루씩 쌓입니다.</p>
                </c:when>
                <c:otherwise>
                    <div class="trend-bars">
                        <c:forEach var="log" items="${recentWeatherLog}">
                            <div class="trend-bar-col">
                                <div class="trend-bar ${log.riskCssClass}" style="height:${log.temperature != null ? (log.temperature + 20) : 10}%"></div>
                                <span>${log.logDate.monthValue}/${log.logDate.dayOfMonth}</span>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
