<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>협력회사 업무 현황 | 앙사모 ERP</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/vendor.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
<div class="app-shell">
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    <main class="workspace">
        <section class="page-heading">
            <div>
                <p class="eyebrow">VENDOR</p>
                <h1>협력회사 업무 현황</h1>
                <p>견적 요청부터 제작, 출하, 검사와 보완 진행 상태를 확인합니다.</p>
            </div>
        </section>

        <section class="notice">
            <span class="material-symbols-outlined">info</span>
            <p><strong>협력회사 전용 화면</strong>입니다. 협력회사 계정은 자기 회사의 견적과 발주만 조회하고 처리할 수 있습니다.</p>
        </section>

        <section class="summary-grid" aria-label="협력회사 업무 요약">
            <a class="summary-card" href="${pageContext.request.contextPath}/vendor/quotes?status=REQUESTED">
                <div class="card-top"><span class="card-label">견적 관리</span><span class="icon-box blue material-symbols-outlined">request_quote</span></div>
                <strong>${summary.requestedQuoteCount}</strong><p>제출 대기 견적</p>
            </a>
            <a class="summary-card" href="${pageContext.request.contextPath}/vendor/orders?status=ORDERED">
                <div class="card-top"><span class="card-label">발주 관리</span><span class="icon-box violet material-symbols-outlined">shopping_cart_checkout</span></div>
                <strong>${summary.orderedCount}</strong><p>제작 시작 대기</p>
            </a>
            <a class="summary-card" href="${pageContext.request.contextPath}/vendor/shipments?status=IN_PROGRESS">
                <div class="card-top"><span class="card-label">제작 관리</span><span class="icon-box green material-symbols-outlined">precision_manufacturing</span></div>
                <strong>${summary.inProgressCount}</strong><p>제작 진행 중</p>
            </a>
            <a class="summary-card" href="${pageContext.request.contextPath}/vendor/shipments?status=SHIPPED">
                <div class="card-top"><span class="card-label">출하 관리</span><span class="icon-box amber material-symbols-outlined">local_shipping</span></div>
                <strong>${summary.shippedCount}</strong><p>검사 대기 출하 건</p>
            </a>
        </section>

        <section class="content-grid">
            <article class="panel">
                <div class="panel-header"><div><p class="eyebrow">WORK QUEUE</p><h2>협력회사 처리 업무</h2></div><a class="text-button" href="${pageContext.request.contextPath}/vendor/orders">전체보기</a></div>
                <div class="work-list vendor-work-list">
                    <a class="work-row" href="${pageContext.request.contextPath}/vendor/quotes"><span class="work-icon material-symbols-outlined">request_quote</span><div><strong>견적 요청 확인·제출</strong><p>단가, 납품 가능일과 거래 조건을 제출합니다.</p></div><span class="status blue">견적</span><span class="row-count">${summary.requestedQuoteCount}</span></a>
                    <a class="work-row" href="${pageContext.request.contextPath}/vendor/shipments"><span class="work-icon material-symbols-outlined">factory</span><div><strong>제작·출하 진행</strong><p>확인 완료된 발주의 제작 상태와 출하를 처리합니다.</p></div><span class="status violet">출하</span><span class="row-count">${summary.inProgressCount}</span></a>
                    <a class="work-row" href="${pageContext.request.contextPath}/vendor/inspections"><span class="work-icon material-symbols-outlined">fact_check</span><div><strong>검사 결과·보완 확인</strong><p>검사 결과를 확인하고 보완 진행 상태를 등록합니다.</p></div><span class="status green">검사</span><span class="row-count">${summary.returnCount}</span></a>
                </div>
            </article>

            <article class="panel compact-panel">
                <div class="panel-header"><div><p class="eyebrow">STATUS</p><h2>주요 진행 상태</h2></div><span class="material-symbols-outlined">monitoring</span></div>
                <a class="deadline" href="${pageContext.request.contextPath}/vendor/quotes?status=SUBMITTED"><strong>${summary.submittedQuoteCount}</strong><div><p>제출 완료 견적</p><span>구매부서 선정 결과 대기</span></div></a>
                <a class="deadline vendor-alert" href="${pageContext.request.contextPath}/vendor/returns"><strong>${summary.returnCount}</strong><div><p>보완 대상</p><span>검사 결과 확인 및 재출하 필요</span></div></a>
            </article>
        </section>
    </main>
</div>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/vendor.js"></script>
</body>
</html>
