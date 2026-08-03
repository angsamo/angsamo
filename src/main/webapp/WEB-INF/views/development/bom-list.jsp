<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BOM 목록</title>
</head>

<body>

<h1>BOM 목록</h1>

<table border="1">

    <tr>
        <th>BOM번호</th>
        <th>부모품목</th>
        <th>구성품</th>
        <th>소요량</th>
        <th>단위</th>
        <th>사용여부</th>
    </tr>

    <c:forEach var="bom" items="${boms}">

        <tr>

            <td>${bom.bomId}</td>

            <td>
                ${bom.parentItemName}
                (${bom.parentItemCode})
            </td>

            <td>
                ${bom.componentItemName}
                (${bom.componentItemCode})
            </td>

            <td>${bom.requiredQty}</td>

            <td>${bom.unit}</td>

            <td>

                <c:choose>

                    <c:when test="${bom.active == 1}">
                        사용
                    </c:when>

                    <c:otherwise>
                        미사용
                    </c:otherwise>

                </c:choose>

            </td>

        </tr>

    </c:forEach>

</table>

</body>
</html>