<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="status" required="true" type="java.lang.String" %>
<c:choose>
    <c:when test="${status == 'REQUESTED'}"><span class="state-badge enabled">제출 대기</span></c:when>
    <c:when test="${status == 'SUBMITTED'}"><span class="state-badge enabled">제출 완료</span></c:when>
    <c:when test="${status == 'SELECTED'}"><span class="state-badge enabled">선정</span></c:when>
    <c:when test="${status == 'REJECTED'}"><span class="state-badge disabled">미선정</span></c:when>
    <c:otherwise><span class="state-badge">${status}</span></c:otherwise>
</c:choose>
