<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
	<title>입고 관리 | 앙사모 ERP</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css?v=20260804-4">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/material.css?v=20260804-2">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
	<div class="app-shell">
		<jsp:include page="/WEB-INF/views/common/header.jsp"/>
		<main class="workspace">
			<section class="page-heading"><div><p class="eyebrow">RECEIVING</p><h1>자재 입고 관리</h1><p>구매 발주 확인부터 검수, 반품 또는 저장, 입고 마감까지 처리합니다.</p></div></section>
			<c:if test="${not empty success}"><div class="flash success">${success}</div></c:if>
			<c:if test="${not empty error}"><div class="flash error">${error}</div></c:if>

			<section class="receiving-flow" aria-label="자재 입고 업무 흐름">
				<div><strong>1</strong><span>구매 발주 확인</span></div><i>→</i>
				<div><strong>2</strong><span>협력회사 출하</span></div><i>→</i>
				<div class="current"><strong>3</strong><span>입고 검수</span></div><i>→</i>
				<div><strong>4</strong><span>정품 저장 / 반품</span></div><i>→</i>
				<div><strong>5</strong><span>입고 마감</span></div><i>→</i>
				<div><strong>6</strong><span>명세서·발주 마감</span></div>
			</section>

			<section class="notice"><span class="notice-mark">ⓘ</span><p><strong>운영 기준:</strong> 발주서와 계약 조건, 출하품 실물, 품질 상태를 모두 확인합니다. 정상 수량은 재고에 저장되고 불량 수량은 협력회사 반품으로 자동 연결됩니다.</p></section>

			<section class="panel report-filter">
				<div><p class="eyebrow">ORDER REPORT</p><h2>발주 진행 현황 조회</h2><p>기간, 진행 상태, 발주번호·품목·협력회사 조건으로 빠르게 검색합니다.</p></div>
				<form method="get" action="${pageContext.request.contextPath}/material/receivings">
					<label>시작일<input type="date" name="fromDate" value="${fromDate}"></label><label>종료일<input type="date" name="toDate" value="${toDate}"></label>
					<label>진행 상태<select name="status"><option value="">전체 상태</option><option value="PLANNED" ${status == 'PLANNED' ? 'selected' : ''}>발주 예정</option><option value="ORDERED" ${status == 'ORDERED' ? 'selected' : ''}>발주서 발행</option><option value="IN_PROGRESS" ${status == 'IN_PROGRESS' ? 'selected' : ''}>조달 진행 중</option><option value="CLOSED" ${status == 'CLOSED' ? 'selected' : ''}>마감 완료</option></select></label>
					<label>검색어<input type="search" name="keyword" value="${keyword}" placeholder="발주번호, 품목, 협력회사"></label><button class="action-button" type="submit">조회</button>
				</form>
				<div class="report-results"><c:forEach items="${orderReport}" var="report"><div><strong>PO-${report.poId}</strong><span>${report.itemName} · ${report.vendorName}</span><span>${report.acceptedQty}/${report.orderQty} 입고</span><em>${report.poStatus}</em></div></c:forEach><c:if test="${empty orderReport}"><p class="hint">조건에 맞는 발주가 없습니다.</p></c:if></div>
			</section>

			<section class="material-grid">
				<c:forEach items="${pending}" var="row">
					<article class="panel receiving-card">
						<div class="receiving-card-head">
							<div><p class="eyebrow">SHIPMENT S-${row.shipmentId}</p><h2>PO-${row.poId} · ${row.itemName}</h2><p>${row.vendorName} · ${row.itemCode}</p></div>
							<span class="state-badge enabled">검수 대기</span>
						</div>
						<div class="order-facts">
							<div><span>발주 수량</span><strong>${row.orderQty}</strong></div>
							<div><span>출하 수량</span><strong>${row.shipmentQty}</strong></div>
							<div><span>기입고 수량</span><strong>${row.previousAcceptedQty}</strong></div>
							<div><span>조달 납기</span><strong>${row.procurementDue}</strong></div>
							<div><span>입고 예정</span><strong>${row.expectedArrivalDate}</strong></div>
							<div><span>제작 진척</span><strong>${empty row.makeStatus ? '확인 필요' : row.makeStatus}</strong></div>
							<div><span>기존 재고</span><strong>${row.currentAvailableQty}</strong></div>
							<div><span>조달 소요 공정</span><strong>${empty row.processNeeded ? '-' : row.processNeeded}</strong></div>
							<div><span>조달계획 수량</span><strong>${row.requiredQty}</strong></div>
						</div>
						<div class="contract-note"><strong>거래 계약 조건</strong><p>${empty row.agreedTerms ? '연결된 계약 조건이 없습니다. 구매부서에 확인해 주세요.' : row.agreedTerms}</p></div>
						<form class="inspection-form" method="post" action="${pageContext.request.contextPath}/material/receivings">
							<input type="hidden" name="shipmentId" value="${row.shipmentId}">
							<fieldset><legend>필수 검수 확인</legend>
								<label><input type="checkbox" name="orderConfirmed" value="true" required> 구매 발주서의 품목·수량·납기를 확인했습니다.</label>
								<label><input type="checkbox" name="itemChecked" value="true" required> 출하 품목 실물과 발주 품목이 일치합니다.</label>
								<label><input type="checkbox" name="qualityChecked" value="true" required> 외관·규격·품질 상태를 검수했습니다.</label>
							</fieldset>
							<div class="inspection-inputs">
								<label>정상 수량<input type="number" name="acceptedQty" min="0" max="${row.shipmentQty}" value="${row.shipmentQty}" required></label>
								<label>불량/반품 수량<input type="number" name="rejectedQty" min="0" max="${row.shipmentQty}" value="0" required></label>
								<label class="reason-field">불량 사유<input type="text" name="reason" maxlength="500" placeholder="불량 수량이 있으면 반드시 입력"></label>
								<button class="action-button" type="submit">검수 완료 및 입고 마감</button>
							</div>
							<p class="hint">정상 수량 + 불량 수량은 출하 수량 ${row.shipmentQty}와 정확히 같아야 합니다.</p>
						</form>
					</article>
				</c:forEach>
				<c:if test="${empty pending}"><article class="panel empty-process"><strong>현재 입고 검수 대기 건이 없습니다.</strong><p>협력회사가 구매 발주에 대한 출하를 등록하면 이곳에 표시됩니다.</p></article></c:if>
			</section>

			<section class="panel table-panel receiving-history">
				<div class="panel-header"><div><p class="eyebrow">RESULT</p><h2>입고 마감 및 후속 처리 현황</h2></div><span class="list-count">${receivings.size()}건</span></div>
				<div class="table-scroll"><table class="data-table"><thead><tr><th>입고/발주</th><th>품목·협력회사</th><th>정상/반품</th><th>검수 결과</th><th>재고</th><th>조달계획</th><th>후속 처리</th></tr></thead><tbody>
				<c:forEach items="${receivings}" var="row"><tr>
					<td>R-${row.receivingId}<br><span class="hint">PO-${row.poId}</span></td><td>${row.itemName}<br><span class="hint">${row.vendorName}</span></td>
					<td>${row.acceptedQty} / ${row.rejectedQty}</td><td><span class="state-badge ${row.rejectedQty > 0 ? 'disabled' : 'enabled'}">${row.rejectedQty > 0 ? '반품 포함' : '정품'}</span><c:if test="${not empty row.rejectionReason}"><br><span class="hint">${row.rejectionReason}</span></c:if></td>
					<td>${row.availableQty}</td><td>${row.planCompleted == 1 ? '조달 완료' : '진행 중'}</td>
					<td><c:choose><c:when test="${row.rejectedQty > 0}"><a class="action-link" href="${pageContext.request.contextPath}/material/returns">반품 ${row.returnStatus}</a></c:when><c:when test="${empty row.statementId}"><a class="action-link" href="${pageContext.request.contextPath}/material/statements">명세서 발행</a></c:when><c:otherwise><a class="action-link" target="_blank" href="${pageContext.request.contextPath}/material/statements/print?statementId=${row.statementId}">명세서 확인·인쇄</a></c:otherwise></c:choose></td>
				</tr></c:forEach>
				<c:if test="${empty receivings}"><tr><td colspan="7" class="empty-cell">완료된 입고 검수가 없습니다.</td></tr></c:if>
				</tbody></table></div>
			</section>

			<section class="panel close-ready-panel">
				<div class="panel-header"><div><p class="eyebrow">PURCHASE NOTIFICATION</p><h2>구매부서 알림 · 발주 마감 대상</h2></div><span class="list-count">${closeReadyOrders.size()}건</span></div>
				<div class="close-ready-list"><c:forEach items="${closeReadyOrders}" var="order"><div><span><strong>PO-${order.poId} · ${order.itemName}</strong><small>${order.vendorName} · 입고 ${order.acceptedQty}/${order.orderQty}</small></span><form method="post" action="${pageContext.request.contextPath}/material/receivings/orders/close"><input type="hidden" name="poId" value="${order.poId}"><button class="action-button" type="submit">완료 체크 및 발주 마감</button></form></div></c:forEach><c:if test="${empty closeReadyOrders}"><p class="empty-cell">입고와 거래명세서 발행이 모두 완료된 발주가 없습니다.</p></c:if></div>
			</section>
		</main>
	</div>
	<script src="${pageContext.request.contextPath}/resources/js/common.js?v=20260804-5"></script>
</body></html>
