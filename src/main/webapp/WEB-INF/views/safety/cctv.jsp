<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>안전모 실시간 확인 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <style>
        .secondary-button { display: inline-flex; height: 38px; align-items: center; padding: 0 14px; color: var(--text); background: var(--white); border: 1px solid var(--border); border-radius: 5px; font-weight: 700; text-decoration: none; }
        .secondary-button:hover { color: var(--blue); border-color: var(--blue); }
        .page-heading { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
        .cctv-panel { padding: 20px; }
        .cctv-controls { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; }
        .cctv-status-line { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--muted); margin-bottom: 12px; }
        .cctv-dot { width: 9px; height: 9px; border-radius: 50%; background: #9aa6b5; display: inline-block; }
        .cctv-dot.on { background: #2e9e5b; }
        .cctv-result { padding: 14px 16px; border-radius: 6px; background: #f5f8fc; font-size: 13px; }
        .cctv-result.violation { background: #fff0f0; color: #9f1d1d; }
        .cctv-result.pass { background: #f0faf4; color: #1d7a3e; }
        .cctv-video-wrap { margin-bottom: 14px; background: #10151c; border-radius: 8px; overflow: hidden; min-height: 320px; display: flex; align-items: center; justify-content: center; }
        .cctv-video-wrap img { width: 100%; max-height: 480px; object-fit: contain; display: block; }
        .cctv-video-wrap .placeholder { color: #7c8798; font-size: 13px; padding: 40px; text-align: center; }
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
                <h1>안전모 실시간 확인</h1>
                <p>실시간 CCTV 영상으로 안전모 착용 여부를 자동 판정합니다.</p>
            </div>
            <a class="secondary-button" href="${pageContext.request.contextPath}/safety">← 안전관리 전체 현황</a>
        </section>

        <c:if test="${not empty success}"><div class="flash success">${success}</div></c:if>
        <c:if test="${not empty error}"><div class="flash error">${error}</div></c:if>

        <section class="panel cctv-panel">
            <div class="panel-header"><div><p class="eyebrow">CCTV</p><h2>실시간 탐지</h2></div></div>
            <div class="cctv-video-wrap">
                <img id="cctvVideo" style="display:none;" alt="CCTV 실시간 영상">
                <p id="cctvPlaceholder" class="placeholder">탐지를 시작하면 CCTV 영상이 여기에 표시됩니다.</p>
            </div>
            <div class="cctv-status-line">
                <span id="cctvDot" class="cctv-dot"></span>
                <span id="cctvStatusText">상태 확인 중...</span>
            </div>
            <div class="cctv-controls">
                <form method="post" action="${pageContext.request.contextPath}/safety/cctv/start" style="margin:0;">
                    <button class="primary-button" type="submit">탐지 시작</button>
                </form>
                <form method="post" action="${pageContext.request.contextPath}/safety/cctv/stop" style="margin:0;">
                    <button class="action-button" type="submit">탐지 종료</button>
                </form>
            </div>
            <div id="cctvResult" class="cctv-result" style="display:none;"></div>
        </section>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script>
    (function () {
        var dot = document.getElementById('cctvDot');
        var statusText = document.getElementById('cctvStatusText');
        var resultBox = document.getElementById('cctvResult');
        var video = document.getElementById('cctvVideo');
        var placeholder = document.getElementById('cctvPlaceholder');
        var statusUrl = '${pageContext.request.contextPath}/safety/cctv/status';
        var streamUrl = '${streamUrl}';
        var streaming = false;

        function refresh() {
            fetch(statusUrl).then(function (res) { return res.json(); }).then(function (data) {
                dot.classList.toggle('on', !!data.running);
                statusText.textContent = data.running
                    ? '탐지 진행 중 (마지막 확인: ' + (data.lastCheckedAt || '-') + ')'
                    : (data.error ? '중지됨 - ' + data.error : '탐지가 실행 중이지 않습니다.');

                if (data.running && !streaming) {
                    video.src = streamUrl + '?t=' + Date.now();
                    video.style.display = 'block';
                    placeholder.style.display = 'none';
                    streaming = true;
                } else if (!data.running && streaming) {
                    video.removeAttribute('src');
                    video.style.display = 'none';
                    placeholder.style.display = 'block';
                    streaming = false;
                }

                var result = data.lastResult;
                if (result && result.message) {
                    resultBox.style.display = 'block';
                    resultBox.textContent = result.message;
                    resultBox.className = 'cctv-result ' + (result.status === 'violation' ? 'violation' : 'pass');
                } else {
                    resultBox.style.display = 'none';
                }
            }).catch(function () {
                statusText.textContent = 'AI 서버 상태를 확인할 수 없습니다.';
            });
        }

        refresh();
        setInterval(refresh, 5000);
    })();
</script>
</body>
</html>
