<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="result" required="false" type="java.lang.String" %>
<c:choose>
    <c:when test="${result == 'ACCEPTED'}">정상 입고</c:when>
    <c:when test="${result == 'RETURNED'}">반품</c:when>
    <c:when test="${result == 'PARTIAL'}">부분 입고</c:when>
    <c:when test="${result == 'REJECTED'}">불합격</c:when>
    <c:when test="${empty result}">검수 대기</c:when>
    <c:otherwise><c:out value="${result}" /></c:otherwise>
</c:choose>
