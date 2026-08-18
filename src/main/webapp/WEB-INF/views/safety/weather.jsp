<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>날씨 현황 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <style>
        .weather-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 14px; margin-bottom: 18px; }
        .forecast-chart { display: flex; height: 210px; align-items: flex-end; gap: 10px; padding: 18px 8px 8px; border-bottom: 1px solid var(--border); overflow-x: auto; }
        .forecast-column { display: flex; flex: 1 0 52px; height: 100%; min-width: 52px; flex-direction: column; justify-content: flex-end; align-items: center; gap: 7px; }
        .forecast-column strong { font-size: 13px; }
        .forecast-bar { width: 28px; min-height: 8px; background: linear-gradient(180deg,#4e9cff,#2271d1); border-radius: 7px 7px 2px 2px; }
        .forecast-column span { color: var(--muted); font-size: 11px; white-space: nowrap; }
        .dashboard-panels { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-top: 18px; }
        .metric-card { padding: 20px; background: var(--white); border: 1px solid var(--border); border-radius: 8px; }
        .metric-card p { margin: 0 0 12px; color: var(--muted); font-size: 12px; font-weight: 700; }
        .metric-card strong { font-size: 30px; font-variant-numeric: tabular-nums; }
        .risk-summary { display: grid; grid-template-columns: 120px 1fr auto; align-items: center; gap: 20px; margin-bottom: 18px; padding: 22px; }
        .risk-signal { display: flex; width: 92px; height: 92px; align-items: center; justify-content: center; color: #fff; border-radius: 50%; font-size: 19px; font-weight: 800; box-shadow: 0 8px 20px rgba(30,50,70,.15); }
        .risk-summary.safe .risk-signal { background: #26945a; } .risk-summary.caution .risk-signal { background: #e39b20; } .risk-summary.danger .risk-signal { background: #d83b3b; }
        .risk-copy h2 { margin: 0 0 6px; font-size: 22px; } .risk-copy p { margin: 0; color: var(--muted); }
        .risk-facts { display: flex; gap: 8px; } .risk-facts span { padding: 9px 12px; background: #f3f6fa; border-radius: 6px; font-size: 12px; font-weight: 700; }
        .alert-list { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 12px; padding: 16px; }
        .alert-card { display: grid; grid-template-columns: 42px 1fr; gap: 12px; padding: 16px; border-radius: 8px; }
        .alert-card.caution { background:#fff8e8; border:1px solid #f2d38b; } .alert-card.danger { background:#fff0f0; border:1px solid #f1b0b0; }
        .alert-icon { display:flex; width:42px; height:42px; align-items:center; justify-content:center; color:#fff; background:#e39b20; border-radius:50%; } .alert-card.danger .alert-icon { background:#d83b3b; }
        .alert-card h3 { margin:0 0 4px; font-size:16px; } .alert-card p { margin:3px 0; color:#516376; font-size:12px; line-height:1.55; } .alert-card time { color:#7b8997; font-size:11px; }
        .alert-empty { padding: 16px; color: var(--muted); text-align: center; }
        .secondary-button { display: inline-flex; height: 38px; align-items: center; padding: 0 14px; color: var(--text); background: var(--white); border: 1px solid var(--border); border-radius: 5px; font-weight: 700; text-decoration: none; }
        .secondary-button:hover { color: var(--blue); border-color: var(--blue); }
        .page-heading { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
        .weather-source { display: flex; justify-content: space-between; gap: 12px; margin-bottom: 18px; padding: 12px 16px; color: #33516f; background: #edf6ff; border: 1px solid #c8dff5; border-radius: 6px; }
        .weather-source strong { color: #123b62; }
        @media (max-width: 900px) { .weather-grid { grid-template-columns: 1fr; } .dashboard-panels,.alert-list { grid-template-columns: 1fr; } .risk-summary { grid-template-columns: 90px 1fr; } .risk-facts { grid-column:1/-1; } }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <main class="workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">SAFETY / WEATHER</p>
                <h1>날씨 현황</h1>
                <p>기온·강수량과 발효 중인 특보를 확인합니다.</p>
            </div>
            <div><a class="secondary-button" href="${pageContext.request.contextPath}/safety/weather">새로고침</a> <a class="secondary-button" href="${pageContext.request.contextPath}/safety">← 안전관리 전체 현황</a></div>
        </section>

        <div class="weather-source">
            <span><strong><c:out value="${weather.dataSource}"/></strong> · <c:out value="${weather.statusMessage}"/></span>
            <span>기준 시각: <c:out value="${weather.observedAt}"/></span>
        </div>

        <section class="panel risk-summary ${weather.riskCssClass}">
            <div class="risk-signal"><c:out value="${weather.riskLevel}"/></div>
            <div class="risk-copy"><p class="eyebrow">오늘의 작업 안전도</p><h2><c:out value="${weather.riskMessage}"/></h2><p>현장 작업자가 바로 이해할 수 있도록 기상 정보를 정리했습니다.</p></div>
            <div class="risk-facts"><span>기온 ${weather.temperature}℃</span><span>강수 ${weather.precipitation}mm</span><span>특보 ${weather.alerts.size()}건</span></div>
        </section>

        <section class="weather-grid">
            <div class="metric-card"><p>현재 기온</p><strong>${weather.temperature}℃</strong></div>
            <div class="metric-card"><p>현재 강수량</p><strong>${weather.precipitation}mm</strong></div>
            <div class="metric-card"><p>교차 확인 기온</p><strong>${weather.asosTemperature}℃</strong></div>
        </section>

        <section class="panel table-panel">
            <div class="panel-header"><div><p class="eyebrow">LOCAL ALERT</p><h2>사업장 주변 기상특보</h2></div><span>서울특별시 기준</span></div>
            <div class="alert-list"><c:forEach items="${weather.alerts}" var="alert">
                <article class="alert-card ${alert.severityClass}"><div class="alert-icon"><span class="material-symbols-outlined">warning</span></div><div><h3><c:out value="${alert.message}"/></h3><p><strong><c:out value="${alert.regionName}"/></strong> · <c:out value="${alert.guidance}"/></p><c:if test="${not empty alert.effectiveAt}"><time>발효: <c:out value="${alert.effectiveAt}"/></time></c:if></div></article>
            </c:forEach></div>
            <c:if test="${empty weather.alerts}">
                <p class="alert-empty">현재 사업장 주변에 발효 중인 특보가 없습니다. 일반 작업이 가능합니다.</p>
            </c:if>
        </section>

        <div class="dashboard-panels">
            <section class="panel table-panel">
                <div class="panel-header"><h2>시간별 기온 예보 (초단기예보)</h2></div>
                <div class="forecast-chart">
                    <c:forEach items="${weather.hourlyForecast}" var="point">
                        <div class="forecast-column"><strong><c:out value="${point.temperature}"/>℃</strong><div class="forecast-bar" style="height:${point.chartHeight}%"></div><span><c:out value="${point.timeLabel}"/></span></div>
                    </c:forEach>
                    <c:if test="${empty weather.hourlyForecast}"><p class="alert-empty">예보 데이터가 없습니다.</p></c:if>
                </div>
            </section>

            <section class="panel table-panel">
                <div class="panel-header"><h2>일별 최고기온 예보 (단기예보)</h2></div>
                <div class="forecast-chart">
                    <c:forEach items="${weather.dailyForecast}" var="point">
                        <div class="forecast-column"><strong><c:out value="${point.temperature}"/>℃</strong><div class="forecast-bar" style="height:${point.chartHeight}%"></div><span><c:out value="${point.timeLabel}"/></span></div>
                    </c:forEach>
                    <c:if test="${empty weather.dailyForecast}"><p class="alert-empty">예보 데이터가 없습니다.</p></c:if>
                </div>
            </section>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
</body>
</html>
