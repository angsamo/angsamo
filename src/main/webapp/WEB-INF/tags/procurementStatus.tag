<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="status" required="true" type="java.lang.String" %>
<c:choose>
    <c:when test="${status == 'REQUESTED'}"><span class="state-badge enabled">요청</span></c:when>
    <c:when test="${status == 'QUOTING'}"><span class="state-badge enabled">견적 진행중</span></c:when>
    <c:when test="${status == 'SELECTED'}"><span class="state-badge enabled">업체 선정</span></c:when>
    <c:when test="${status == 'CONTRACTED'}"><span class="state-badge enabled">계약 확정</span></c:when>
    <c:when test="${status == 'ORDERED'}"><span class="state-badge enabled">발주 완료</span></c:when>
    <c:when test="${status == 'SHIPPED'}"><span class="state-badge enabled">출하 완료</span></c:when>
    <c:when test="${status == 'RECEIVED'}"><span class="state-badge enabled">입고 완료</span></c:when>
    <c:when test="${status == 'CLOSED'}"><span class="state-badge enabled">마감 완료</span></c:when>
    <c:when test="${status == 'RETURNED'}"><span class="state-badge disabled">반품 판정</span></c:when>
    <c:when test="${status == 'RETURN_REQUESTED'}"><span class="state-badge disabled">반품 요청</span></c:when>
    <c:when test="${status == 'RESUPPLYING'}"><span class="state-badge disabled">보완 중</span></c:when>
    <c:when test="${status == 'RETURN_COMPLETED'}"><span class="state-badge enabled">반품 완료</span></c:when>
    <c:when test="${status == 'STATEMENT_ISSUED'}"><span class="state-badge enabled">명세서 발행</span></c:when>
    <c:when test="${status == 'CANCELLED'}"><span class="state-badge disabled">취소</span></c:when>
    <c:otherwise><span class="state-badge">${status}</span></c:otherwise>
</c:choose>
