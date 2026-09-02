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
        .item-form { padding: 18px; margin-bottom: 18px; }
        .item-form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 14px; }
        .item-form label { display: flex; flex-direction: column; gap: 6px; color: var(--muted); font-size: 12px; font-weight: 700; }
        .item-form input[type="file"], .item-form input[type="text"] { height: 40px; padding: 0 10px; border: 1px solid var(--border); border-radius: 5px; }
        .photo-preview-wrap { margin-top: 8px; display: flex; align-items: flex-start; gap: 10px; }
        .photo-preview-box { position: relative; display: none; }
        .photo-preview-box img, .photo-preview-box canvas { max-width: 260px; max-height: 260px; border-radius: 6px; border: 1px solid var(--border); display: block; }
        .photo-preview-box canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; pointer-events: none; }
        .preview-cancel-btn { display: none; height: 30px; padding: 0 10px; border: 1px solid var(--border); border-radius: 5px; background: var(--white); color: #9f1d1d; font-size: 12px; font-weight: 700; cursor: pointer; }
        .preview-cancel-btn:hover { background: #fde8e8; }
        .preview-status { font-size: 12px; color: var(--muted); margin-top: 4px; }
        .ai-note { display: flex; align-items: center; gap: 6px; padding: 10px; background: #eef4ff; border: 1px solid #cdddfb; border-radius: 6px; font-size: 12px; color: #2255c4; }
        .check-items { display: grid; grid-template-columns: 1fr repeat(3, minmax(0, 1fr)); gap: 10px; margin-bottom: 14px; }
        .check-item { display: flex; flex-direction: column; gap: 6px; padding: 10px; background: #f8fafc; border: 1px solid var(--border); border-radius: 6px; }
        .check-item span { font-size: 12px; font-weight: 700; color: var(--muted); }
        .check-item label { flex-direction: row; align-items: center; gap: 6px; font-weight: 400; color: var(--text); font-size: 13px; }
        .item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; padding: 0 20px 20px; }
        .item-card { position: relative; padding: 12px; background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; }
        .item-card .item-media-wrap { position: relative; margin-bottom: 8px; display: inline-block; max-width: 100%; }
        .item-card .item-media-wrap img { display: block; max-width: 100%; max-height: 160px; border-radius: 6px; background: #eef2f7; }
        .item-card .item-media-wrap canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; }
        .item-card .no-media { display: flex; align-items: center; justify-content: center; height: 120px; margin-bottom: 8px; color: var(--muted); background: #eef2f7; border-radius: 6px; }
        .item-card .badge-row { display: flex; flex-wrap: wrap; gap: 4px; margin-bottom: 6px; }
        .item-card .memo { margin: 6px 0 0; color: var(--muted); font-size: 12px; }
        .item-card .time { margin: 4px 0 0; color: var(--muted); font-size: 11px; }
        .item-delete-form { position: absolute; top: 8px; right: 8px; margin: 0; }
        .item-delete-btn { width: 26px; height: 26px; border-radius: 999px; border: 1px solid var(--border); background: rgba(255,255,255,0.9); color: #9f1d1d; cursor: pointer; display: flex; align-items: center; justify-content: center; }
        .item-delete-btn:hover { background: #fde8e8; }
        .item-delete-btn .material-symbols-outlined { font-size: 16px; }
        .active-header { display: flex; align-items: center; justify-content: space-between; padding: 18px 20px 0; }
        @media (max-width: 900px) { .start-form, .item-form-row, .check-items { grid-template-columns: 1fr; } }
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
                        <div class="item-form-row">
                            <label>
                                사진/영상<input type="file" id="mediaInput" name="media" accept="image/*,video/*" required>
                                <div class="photo-preview-wrap">
                                    <div class="photo-preview-box" id="previewBox">
                                        <img id="mediaPreview" alt="미리보기">
                                        <canvas id="previewCanvas"></canvas>
                                    </div>
                                    <button type="button" class="preview-cancel-btn" id="previewCancelBtn">취소</button>
                                </div>
                                <p class="preview-status" id="previewStatus"></p>
                            </label>
                            <label>비고<input type="text" name="memo" maxlength="300" placeholder="특이사항 입력"></label>
                        </div>
                        <div class="ai-note"><span class="material-symbols-outlined" style="font-size:16px;">smart_toy</span>사진을 올리면 AI가 안전모 착용 여부를 자동으로 판정합니다.</div>
                        <div class="check-items">
                            <div class="check-item">
                                <span>턱끈 체결 여부</span>
                                <label><input type="radio" name="chinStrapFastened" value="true" checked> 체결</label>
                                <label><input type="radio" name="chinStrapFastened" value="false"> 미체결</label>
                            </div>
                            <div class="check-item">
                                <span>안전모 파손 여부</span>
                                <label><input type="radio" name="damaged" value="false" checked> 정상</label>
                                <label><input type="radio" name="damaged" value="true"> 파손</label>
                            </div>
                            <div class="check-item">
                                <span>사용기한 초과 여부</span>
                                <label><input type="radio" name="expired" value="false" checked> 정상</label>
                                <label><input type="radio" name="expired" value="true"> 초과</label>
                            </div>
                        </div>
                        <button class="action-button" type="submit">확인 항목 추가</button>
                    </form>

                    <c:if test="${empty items}"><div class="empty-state"><span class="material-symbols-outlined">checklist</span><p>아직 등록된 확인 항목이 없습니다.</p></div></c:if>
                    <div class="item-grid">
                        <c:forEach var="item" items="${items}">
                            <div class="item-card">
                                <form class="item-delete-form" method="post"
                                      action="${pageContext.request.contextPath}/safety/checklist/${active.checklistId}/items/${item.itemId}/delete"
                                      onsubmit="return confirm('이 확인 항목을 삭제하시겠습니까?');">
                                    <button type="submit" class="item-delete-btn" title="삭제"><span class="material-symbols-outlined">close</span></button>
                                </form>
                                <c:choose>
                                    <c:when test="${not empty item.mediaPath}">
                                        <div class="item-media-wrap">
                                            <img src="${pageContext.request.contextPath}/safety/uploads/${item.mediaPath}" alt="확인 사진"
                                                 class="detection-photo" data-boxes='<c:out value="${empty item.detectionBoxes ? '[]' : item.detectionBoxes}" escapeXml="false"/>'>
                                            <canvas class="detection-canvas"></canvas>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-media"><span class="material-symbols-outlined">image_not_supported</span></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="badge-row">
                                    <span class="state-badge ${item.helmetWorn ? 'enabled' : 'disabled'}">안전모 ${item.helmetWorn ? '착용' : '미착용'}</span>
                                    <span class="state-badge ${item.chinStrapFastened ? 'enabled' : 'disabled'}">턱끈 ${item.chinStrapFastened ? '체결' : '미체결'}</span>
                                    <span class="state-badge ${item.damaged ? 'disabled' : 'enabled'}">${item.damaged ? '파손' : '정상'}</span>
                                    <span class="state-badge ${item.expired ? 'disabled' : 'enabled'}">${item.expired ? '기한초과' : '기한정상'}</span>
                                    <span class="state-badge">${item.detectionSource == 'AI' ? 'AI' : '수동'}</span>
                                </div>
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
                            <thead><tr><th>점검일</th><th>부서</th><th>장소</th><th>점검자</th><th>확인 건수</th><th>부적합</th><th>상태</th></tr></thead>
                            <tbody>
                                <c:forEach var="row" items="${checklists}">
                                    <tr class="row-link" onclick="location.href='${pageContext.request.contextPath}/safety/checklist/${row.checklistId}'" style="cursor:pointer;">
                                        <td>${row.checkDate}</td>
                                        <td><c:out value="${empty row.departmentName ? '전체' : row.departmentName}"/></td>
                                        <td><c:out value="${empty row.location ? '-' : row.location}"/></td>
                                        <td><c:out value="${row.checkedByName}"/></td>
                                        <td>${row.itemCount}</td>
                                        <td><c:if test="${row.violationCount > 0}"><span class="state-badge disabled">${row.violationCount}건</span></c:if><c:if test="${row.violationCount == 0}">-</c:if></td>
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
<script>
    (function () {
        var input = document.getElementById('mediaInput');
        if (!input) return;
        var previewBox = document.getElementById('previewBox');
        var preview = document.getElementById('mediaPreview');
        var canvas = document.getElementById('previewCanvas');
        var cancelBtn = document.getElementById('previewCancelBtn');
        var status = document.getElementById('previewStatus');
        var detectUrl = '${pageContext.request.contextPath}/safety/checklist/detect-preview';

        function clearSelection() {
            input.value = '';
            previewBox.style.display = 'none';
            cancelBtn.style.display = 'none';
            preview.removeAttribute('src');
            var ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            status.textContent = '';
        }

        function drawBoxes(predictions) {
            var ctx = canvas.getContext('2d');
            canvas.width = preview.naturalWidth;
            canvas.height = preview.naturalHeight;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.lineWidth = Math.max(2, canvas.width / 200);
            ctx.font = (canvas.width / 30) + 'px sans-serif';
            ctx.textBaseline = 'bottom';
            (predictions || []).forEach(function (p) {
                var isHelmet = p['class'] === 'helmet';
                var color = isHelmet ? '#1d9e4b' : '#e02525';
                var x1 = p.x - p.width / 2;
                var y1 = p.y - p.height / 2;
                ctx.strokeStyle = color;
                ctx.strokeRect(x1, y1, p.width, p.height);
                var label = (isHelmet ? '안전모' : '미착용') + ' ' + Math.round(p.confidence * 100) + '%';
                var textWidth = ctx.measureText(label).width;
                ctx.fillStyle = color;
                ctx.fillRect(x1, Math.max(0, y1), textWidth + 8, canvas.width / 30 + 6);
                ctx.fillStyle = '#fff';
                ctx.fillText(label, x1 + 4, Math.max(0, y1) + canvas.width / 30 + 4);
            });
        }

        input.addEventListener('change', function () {
            var file = input.files && input.files[0];
            if (!file || !file.type.startsWith('image/')) {
                clearSelection();
                return;
            }
            var reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                previewBox.style.display = 'block';
                cancelBtn.style.display = 'inline-flex';
                status.textContent = 'AI 판정 중...';
            };
            reader.readAsDataURL(file);

            preview.onload = function () {
                var formData = new FormData();
                formData.append('media', file);
                fetch(detectUrl, { method: 'POST', body: formData })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        drawBoxes(data.predictions);
                        if (!data.success) {
                            status.textContent = 'AI가 안전모/머리를 인식하지 못했습니다. 수동으로 확인해 주세요.';
                        } else {
                            status.textContent = 'AI 판정: 안전모 ' + (data.helmetWorn ? '착용' : '미착용');
                        }
                    })
                    .catch(function () {
                        status.textContent = 'AI 판정 요청에 실패했습니다.';
                    });
            };
        });

        cancelBtn.addEventListener('click', clearSelection);
    })();

    (function () {
        function drawBoxesOn(img, canvas, predictions) {
            var ctx = canvas.getContext('2d');
            canvas.width = img.naturalWidth;
            canvas.height = img.naturalHeight;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.lineWidth = Math.max(2, canvas.width / 150);
            ctx.font = (canvas.width / 22) + 'px sans-serif';
            ctx.textBaseline = 'bottom';
            (predictions || []).forEach(function (p) {
                var isHelmet = p['class'] === 'helmet';
                var color = isHelmet ? '#1d9e4b' : '#e02525';
                var x1 = p.x - p.width / 2;
                var y1 = p.y - p.height / 2;
                ctx.strokeStyle = color;
                ctx.strokeRect(x1, y1, p.width, p.height);
                var label = (isHelmet ? '안전모' : '미착용') + ' ' + Math.round(p.confidence * 100) + '%';
                var textWidth = ctx.measureText(label).width;
                var fontSize = canvas.width / 22;
                ctx.fillStyle = color;
                ctx.fillRect(x1, Math.max(0, y1), textWidth + 8, fontSize + 6);
                ctx.fillStyle = '#fff';
                ctx.fillText(label, x1 + 4, Math.max(0, y1) + fontSize + 4);
            });
        }

        document.querySelectorAll('.detection-photo').forEach(function (img) {
            var canvas = img.parentElement.querySelector('.detection-canvas');
            if (!canvas) return;
            var predictions;
            try { predictions = JSON.parse(img.getAttribute('data-boxes') || '[]'); } catch (e) { predictions = []; }
            if (!predictions.length) return;
            if (img.complete) {
                drawBoxesOn(img, canvas, predictions);
            } else {
                img.addEventListener('load', function () { drawBoxesOn(img, canvas, predictions); });
            }
        });
    })();
</script>
</body>
</html>
