<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="status" required="true" type="java.lang.String" %>
<c:choose>
    <c:when test="${status == 'PLANNED'}"><span class="status-badge planned">계획</span></c:when>
    <c:when test="${status == 'IN_PROGRESS'}"><span class="status-badge in-progress">진행 중</span></c:when>
    <c:when test="${status == 'COMPLETED'}"><span class="status-badge completed">완료</span></c:when>
    <c:when test="${status == 'CANCELLED'}"><span class="status-badge cancelled">취소</span></c:when>
    <c:otherwise><span class="status-badge unknown"><c:out value="${status}" /></span></c:otherwise>
</c:choose>
