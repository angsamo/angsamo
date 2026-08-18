<%@ tag pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ attribute name="role" required="true" type="java.lang.String" %>
<c:choose>
    <c:when test="${role == 'ADMIN'}">관리자</c:when>
    <c:when test="${role == 'VENDOR'}">협력회사</c:when>
    <c:when test="${role == 'MEMBER'}">일반 사용자</c:when>
    <c:otherwise><c:out value="${role}" /></c:otherwise>
</c:choose>
