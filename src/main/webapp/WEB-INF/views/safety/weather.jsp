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
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
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
        #weatherMap { height: 260px; border-radius: 8px; }
        .map-temp-badge { display: flex; flex-direction: column; align-items: center; justify-content: center; width: 46px; height: 46px; border-radius: 50%; background: #2271d1; color: #fff; font-size: 11px; font-weight: 800; border: 2px solid #fff; box-shadow: 0 3px 8px rgba(0,0,0,.25); }
        .calendar-nav { display: flex; align-items: center; gap: 10px; }
        .calendar-nav a { display: inline-flex; width: 28px; height: 28px; align-items: center; justify-content: center; border: 1px solid var(--border); border-radius: 5px; color: var(--text); text-decoration: none; }
        .calendar-nav a:hover { color: var(--blue); border-color: var(--blue); }
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; padding: 16px; }
        .calendar-dow { text-align: center; color: var(--muted); font-size: 11px; font-weight: 700; padding-bottom: 4px; }
        .calendar-cell { min-height: 62px; padding: 6px; border: 1px solid var(--border); border-radius: 6px; background: #fff; }
        .calendar-cell.blank { border: none; background: transparent; }
        .calendar-cell.today { border-color: var(--blue); border-width: 2px; }
        .calendar-cell .cal-day { font-size: 12px; font-weight: 700; color: var(--muted); }
        .calendar-cell .cal-temp { margin-top: 6px; font-size: 15px; font-weight: 800; }
        .calendar-cell.safe { background: #eaf7f0; } .calendar-cell.caution { background: #fff8e8; } .calendar-cell.danger { background: #fff0f0; }
        .calendar-cell.clickable { cursor: pointer; } .calendar-cell.clickable:hover { box-shadow: 0 0 0 2px var(--blue) inset; }
        .day-modal-overlay { display: none; position: fixed; inset: 0; background: rgba(20,30,45,.45); z-index: 1000; align-items: center; justify-content: center; }
        .day-modal-overlay.open { display: flex; }
        .day-modal { width: 360px; max-height: 88vh; overflow-y: auto; background: #fff; border-radius: 10px; padding: 22px; box-shadow: 0 20px 50px rgba(0,0,0,.25); }
        .day-modal h3 { margin: 0 0 14px; font-size: 17px; }
        .day-modal .day-signal { display: inline-flex; padding: 6px 14px; border-radius: 999px; color: #fff; font-weight: 800; font-size: 13px; margin-bottom: 14px; }
        .day-modal .day-signal.safe { background: #26945a; } .day-modal .day-signal.caution { background: #e39b20; } .day-modal .day-signal.danger { background: #d83b3b; }
        .day-modal .day-facts { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 8px; margin-bottom: 16px; }
        .day-modal .day-facts div { padding: 8px; background: #f3f6fa; border-radius: 6px; text-align: center; }
        .day-modal .day-facts strong { display: block; font-size: 15px; }
        .day-modal .day-facts span { font-size: 10px; color: var(--muted); }
        .day-modal-close { width: 100%; height: 38px; border: 1px solid var(--border); border-radius: 6px; background: #fff; font-weight: 700; cursor: pointer; }
        .day-modal-close:hover { color: var(--blue); border-color: var(--blue); }
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
            <div class="panel-header"><div><p class="eyebrow">MAP</p><h2>사업장 위치 기온</h2></div></div>
            <div id="weatherMap"></div>
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

        <section class="panel table-panel">
            <div class="panel-header">
                <div><p class="eyebrow">CALENDAR</p><h2>날씨 달력</h2></div>
                <div class="calendar-nav">
                    <a href="${pageContext.request.contextPath}/safety/weather?month=${prevMonth}">&lt;</a>
                    <strong><c:out value="${calendarMonth}"/></strong>
                    <a href="${pageContext.request.contextPath}/safety/weather?month=${nextMonth}">&gt;</a>
                </div>
            </div>
            <div class="calendar-grid">
                <div class="calendar-dow">일</div><div class="calendar-dow">월</div><div class="calendar-dow">화</div>
                <div class="calendar-dow">수</div><div class="calendar-dow">목</div><div class="calendar-dow">금</div><div class="calendar-dow">토</div>
                <c:forEach items="${calendarDays}" var="d">
                    <c:choose>
                        <c:when test="${d.blank}"><div class="calendar-cell blank"></div></c:when>
                        <c:otherwise>
                            <div class="calendar-cell ${d.riskCssClass} ${d.today ? 'today' : ''} ${d.hasData ? 'clickable' : ''}"
                                 <c:if test="${d.hasData}">
                                 data-iso="${d.date}"
                                 data-date="${calendarMonth} ${d.dayNumber}일"
                                 data-temp="${d.temperature}"
                                 data-precip="${d.precipitation}"
                                 data-risk="${d.riskLevel}"
                                 data-maxtemp="${d.maxTemperature}"
                                 data-mintemp="${d.minTemperature}"
                                 data-snow="${d.snowfall}"
                                 data-alerts="<c:out value="${d.alertSummary}"/>"
                                 data-memo="<c:out value="${d.memo}"/>"
                                 onclick="showDayDetail(this)"
                                 </c:if>>
                                <div class="cal-day">${d.dayNumber}</div>
                                <c:if test="${d.hasData}"><div class="cal-temp">${d.temperature}℃</div></c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
            <p style="padding:0 16px 16px; color:var(--muted); font-size:12px;">이 화면을 조회한 날부터 하루씩 자동으로 기록됩니다. 과거 날짜는 데이터가 없을 수 있습니다.</p>
        </section>
    </main>
</div>

<div class="day-modal-overlay" id="dayModalOverlay" onclick="if(event.target===this) closeDayDetail();">
    <div class="day-modal">
        <h3 id="dayModalDate">-</h3>
        <div class="day-signal" id="dayModalSignal">-</div>
        <div class="day-facts">
            <div><strong id="dayModalTemp">-℃</strong><span>기온</span></div>
            <div><strong id="dayModalPrecip">-mm</strong><span>강수량</span></div>
            <div><strong id="dayModalMax">-℃</strong><span>최고기온</span></div>
            <div><strong id="dayModalMin">-℃</strong><span>최저기온</span></div>
            <div><strong id="dayModalSnow">-cm</strong><span>적설량</span></div>
        </div>
        <p style="font-size:12px; color:var(--muted); margin:0 0 4px; font-weight:700;">발효됐던 특보</p>
        <p id="dayModalAlerts" style="font-size:13px; margin:0 0 14px;">-</p>
        <p style="font-size:12px; color:var(--muted); margin:0 0 4px; font-weight:700;">관리자 메모</p>
        <textarea id="dayModalMemo" rows="3" maxlength="300"
                  style="width:100%; box-sizing:border-box; padding:8px; border:1px solid var(--border); border-radius:6px; font-family:inherit; font-size:13px; margin-bottom:10px;"
                  placeholder="예: 폭염으로 오후 실외작업 중지"></textarea>
        <div style="display:flex; gap:8px;">
            <button class="day-modal-close" style="flex:1;" onclick="saveDayMemo()">메모 저장</button>
            <button class="day-modal-close" style="flex:1;" onclick="closeDayDetail()">닫기</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script>
    (function () {
        var mapEl = document.getElementById('weatherMap');
        if (!mapEl || typeof L === 'undefined') return;
        var lat = ${latitude};
        var lng = ${longitude};
        var map = L.map(mapEl).setView([lat, lng], 12);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: 18
        }).addTo(map);

        var tempIcon = L.divIcon({
            className: '',
            html: '<div class="map-temp-badge">${weather.temperature}<span style="font-size:9px;">℃</span></div>',
            iconSize: [46, 46],
            iconAnchor: [23, 23]
        });
        L.marker([lat, lng], { icon: tempIcon }).addTo(map)
            .bindPopup('사업장 · 기온 ${weather.temperature}℃ / 강수 ${weather.precipitation}mm');
    })();

    var RISK_LABEL = { '위험': '위험', '주의': '주의', '안전': '안전' };
    var RISK_MESSAGE = {
        '위험': '기상 위험이 높았던 날입니다. 실외작업 중지 여부를 검토하세요.',
        '주의': '기상 변화에 주의가 필요했던 날입니다.',
        '안전': '작업 가능한 수준의 기상 조건이었습니다.'
    };

    var dayMemoUrlBase = '${pageContext.request.contextPath}/safety/weather/log/';
    var currentDayIso = null;

    function orDash(value, suffix) {
        return (value === null || value === undefined || value === '' || value === 'null') ? '-' : (value + (suffix || ''));
    }

    function showDayDetail(cell) {
        var risk = cell.getAttribute('data-risk');
        currentDayIso = cell.getAttribute('data-iso');
        document.getElementById('dayModalDate').textContent = cell.getAttribute('data-date');
        document.getElementById('dayModalTemp').textContent = orDash(cell.getAttribute('data-temp'), '℃');
        document.getElementById('dayModalPrecip').textContent = orDash(cell.getAttribute('data-precip'), 'mm');
        document.getElementById('dayModalMax').textContent = orDash(cell.getAttribute('data-maxtemp'), '℃');
        document.getElementById('dayModalMin').textContent = orDash(cell.getAttribute('data-mintemp'), '℃');
        document.getElementById('dayModalSnow').textContent = orDash(cell.getAttribute('data-snow'), 'cm');
        var alertsText = cell.getAttribute('data-alerts');
        document.getElementById('dayModalAlerts').textContent = alertsText ? alertsText : '발효된 특보가 없습니다.';
        document.getElementById('dayModalMemo').value = cell.getAttribute('data-memo') === 'null' ? '' : (cell.getAttribute('data-memo') || '');

        var signal = document.getElementById('dayModalSignal');
        signal.textContent = (RISK_LABEL[risk] || risk) + ' · ' + (RISK_MESSAGE[risk] || '');
        signal.className = 'day-signal ' + (risk === '위험' ? 'danger' : risk === '주의' ? 'caution' : 'safe');
        document.getElementById('dayModalOverlay').classList.add('open');
    }

    function closeDayDetail() {
        document.getElementById('dayModalOverlay').classList.remove('open');
    }

    function saveDayMemo() {
        if (!currentDayIso) return;
        var memo = document.getElementById('dayModalMemo').value;
        var formData = new FormData();
        formData.append('memo', memo);
        fetch(dayMemoUrlBase + currentDayIso + '/memo', { method: 'POST', body: formData })
            .then(function (res) { return res.json(); })
            .then(function () { location.reload(); })
            .catch(function () { alert('메모 저장에 실패했습니다.'); });
    }
</script>
</body>
</html>
