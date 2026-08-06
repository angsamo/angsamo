<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@ taglib prefix="c" uri="jakarta.tags.core" %><%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageSep" value="${fn:contains(baseUrl, '?') ? '&' : '?'}"/>
<c:if test="${totalPages > 1}">
<nav class="pagination" aria-label="페이지 이동">
	<c:choose>
		<c:when test="${page > 1}"><a class="page-link" href="${pageContext.request.contextPath}${baseUrl}${pageSep}page=${page - 1}">이전</a></c:when>
		<c:otherwise><span class="page-link disabled">이전</span></c:otherwise>
	</c:choose>
	<c:forEach begin="1" end="${totalPages}" var="p">
		<c:choose>
			<c:when test="${p == page}"><span class="page-link current">${p}</span></c:when>
			<c:otherwise><a class="page-link" href="${pageContext.request.contextPath}${baseUrl}${pageSep}page=${p}">${p}</a></c:otherwise>
		</c:choose>
	</c:forEach>
	<c:choose>
		<c:when test="${page < totalPages}"><a class="page-link" href="${pageContext.request.contextPath}${baseUrl}${pageSep}page=${page + 1}">다음</a></c:when>
		<c:otherwise><span class="page-link disabled">다음</span></c:otherwise>
	</c:choose>
</nav>
</c:if>
