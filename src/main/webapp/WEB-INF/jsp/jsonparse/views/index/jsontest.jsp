<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>title</title>
		<link rel="stylesheet" href="${contextPath}/resources/css/layout.css" type="text/css" />
		<c:set var="contextPath" value="${pageContext.request.contextPath}" />
		
		<script type="text/javascript">
		</script>

	</head>
	
	<body>
	
		<table style="width: 500px; text-align: center;">
			<colgroup>
				<col width="10%"/>
				<col width="50%"/>
				<col width="40%"/>
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>내용</th>
					<th>등록일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="jsontest" items="${jsontestList}">
					<tr>
						<td>${jsontest.num}</td>
						<td>${jsontest.contents}</td>
						<td>${jsontest.regDate}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		
		<br />
		<form action="${contextPath}/jsontest/save" method="POST">
			<input type="text" name="contents" value="" />
			<input type="submit" name="btn" value="저장"/>
		</form>
		
	</body>
</html>

