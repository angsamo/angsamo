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
        .forecast-row { display: flex; gap: 10px; overflow-x: auto; padding-bottom: 4px; }
        .forecast-point { flex: none; min-width: 64px; padding: 12px 10px; text-align: center; background: #f5f8fc; border-radius: 6px; }
        .forecast-point span { display: block; margin-bottom: 6px; color: var(--muted); font-size: 11px; }
        .forecast-point strong { font-size: 15px; }
        .dashboard-panels { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-top: 18px; }
        @media (max-width: 900px) { .weather-grid { grid-template-columns: 1fr; } .dashboard-panels { grid-template-columns: 1fr; } }
        .metric-card { padding: 20px; background: var(--white); border: 1px solid var(--border); border-radius: 8px; }
        .metric-card p { margin: 0 0 12px; color: var(--muted); font-size: 12px; font-weight: 700; }
        .metric-card strong { font-size: 30px; font-variant-numeric: tabular-nums; }
        .alert-banner { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; padding: 14px 16px; color: #9f1d1d; background: #fff0f0; border: 1px solid #f1b8b8; border-radius: 6px; font-weight: 700; }
        .alert-empty { padding: 16px; color: var(--muted); text-align: center; }
        .secondary-button { display: inline-flex; height: 38px; align-items: center; padding: 0 14px; color: var(--text); background: var(--white); border: 1px solid var(--border); border-radius: 5px; font-weight: 700; text-decoration: none; }
        .secondary-button:hover { color: var(--blue); border-color: var(--blue); }
        .page-heading { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
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
            <a class="secondary-button" href="${pageContext.request.contextPath}/safety">← 안전관리 전체 현황</a>
        </section>

        <section class="weather-grid">
            <div class="metric-card"><p>현재 기온 (초단기실황)</p><strong>${weather.temperature}℃</strong></div>
            <div class="metric-card"><p>1시간 강수량</p><strong>${weather.precipitation}mm</strong></div>
            <div class="metric-card"><p>ASOS 실측 기온</p><strong>${weather.asosTemperature}℃</strong></div>
        </section>

        <section class="panel table-panel">
            <div class="panel-header"><h2>날씨 경보</h2></div>
            <c:forEach items="${weather.alerts}" var="alert">
                <div class="alert-banner">
                    <span class="material-symbols-outlined">warning</span>
                    <span><c:out value="${alert.regionName}"/> - <c:out value="${alert.message}"/></span>
                </div>
            </c:forEach>
            <c:if test="${empty weather.alerts}">
                <p class="alert-empty">현재 발효 중인 특보가 없습니다.</p>
            </c:if>
        </section>

        <div class="dashboard-panels">
            <section class="panel table-panel">
                <div class="panel-header"><h2>시간별 기온 예보 (초단기예보)</h2></div>
                <div class="forecast-row">
                    <c:forEach items="${weather.hourlyForecast}" var="point">
                        <div class="forecast-point"><span><c:out value="${point.timeLabel}"/></span><strong><c:out value="${point.temperature}"/>℃</strong></div>
                    </c:forEach>
                    <c:if test="${empty weather.hourlyForecast}"><p class="alert-empty">예보 데이터가 없습니다.</p></c:if>
                </div>
            </section>

            <section class="panel table-panel">
                <div class="panel-header"><h2>일별 최고기온 예보 (단기예보)</h2></div>
                <div class="forecast-row">
                    <c:forEach items="${weather.dailyForecast}" var="point">
                        <div class="forecast-point"><span><c:out value="${point.timeLabel}"/></span><strong><c:out value="${point.temperature}"/>℃</strong></div>
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
