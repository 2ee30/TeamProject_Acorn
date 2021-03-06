<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** banapresso **</title>
<link rel="shortcut icon" type="image/x-icon" href="https://www.banapresso.com/ico_logo.ico">
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
<jsp:include page="../include/navbar.jsp">
	<jsp:param value="board" name="category"/>
</jsp:include>
<style>
	h1{color: #F1648A;}
	thead{background-color: #F1A4BA;}
</style>
<div class="container">
	<c:if test="${not empty keyword }">
		<p>
			<strong>${keyword }</strong> 라는 검색어로 
			<strong>${totalRow }</strong> 개의 글이 검색 되었습니다.
		</p>
	</c:if>
	<h1>사내 게시판</h1>
	<p>내가 작성한 글 목록 입니다.</p> <br/>
	<table class="table table-striped table-condensed">
		<colgroup>
			<col class="col-xs-1"/>
			<col class="col-xs-2"/>
			<col class="col-xs-4"/>
			<col class="col-xs-1"/>
			<col class="col-xs-2"/>
		</colgroup>
		<thead>
			<tr>
				<th>글번호</th>
				<th>작성자</th>
				<th>제목 (댓글수)</th>
				<th>조회수</th>
				<th>등록일</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="tmp" items="${requestScope.list }">
			<tr>
				<td>${tmp.num }</td>
				<td>${tmp.writer }</td>
				<td>
					<c:choose>
						<c:when test="${tmp.countComment gt 0}">
							<a href="detail.go?num=${tmp.num }&pageNum=${pageNum}&condition=${condition }&keyword=${encodedKeyword }" style="color:black">${tmp.title }</a>
							<a>(<a style="color:#F1648A">${tmp.countComment}</a>)</a>
						</c:when>
						<c:otherwise>
							<a href="detail.go?num=${tmp.num }&pageNum=${pageNum}&condition=${condition }&keyword=${encodedKeyword }" style="color:black">${tmp.title }</a>
						</c:otherwise>
					</c:choose> 
				</td>
				<td>${tmp.viewCount }</td>
				<td>${tmp.regdate}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	
	<div class="text-right">
			<a href="insertform.go" class="btn btn-primary">글쓰기  &nbsp;<span class="glyphicon glyphicon-pencil"/></a>
	</div>
	
	<div class="page-display">
		<ul class="pagination">
		<c:choose>
			<c:when test="${startPageNum ne 1 }">
				<li>
					<a href="mylist.go?pageNum=${startPageNum-1 }&condition=${condition }&keyword=${encodedKeyword }">
						&laquo;
					</a>
				</li>
			</c:when>
			<c:otherwise>
				<li class="disabled">
					<a href="javascript:">&laquo;</a>
				</li>
			</c:otherwise>
		</c:choose>
		<c:forEach var="i" begin="${startPageNum }" 
			end="${endPageNum }" step="1">
			<c:choose>
				<c:when test="${i eq pageNum }">
					<li class="active"><a href="mylist.go?pageNum=${i }&condition=${condition }&keyword=${encodedKeyword }">${i }</a></li>
				</c:when>
				<c:otherwise>
					<li><a href="mylist.go?pageNum=${i }&condition=${condition }&keyword=${encodedKeyword }">${i }</a></li>
				</c:otherwise>
			</c:choose>
		</c:forEach>

		<c:choose>
			<c:when test="${endPageNum lt totalPageCount }">
				<li>
					<a href="mylist.go?pageNum=${endPageNum+1 }&condition=${condition }&keyword=${encodedKeyword }">
						&raquo;
					</a>
				</li>
			</c:when>
			<c:otherwise>
				<li class="disabled">
					<a href="javascript:">&raquo;</a>
				</li>
			</c:otherwise>
		</c:choose>
		</ul>		
	</div>
	<%-- 글 검색 기능 폼 --%>
	<form action="mylist.go" method="get">
		<label for="condition">검색조건</label>
		<select name="condition" id="condition">
			<option value="titlecontent" <c:if test="${condition eq 'titlecontent' }">selected</c:if> >제목+내용</option>
			<option value="title" <c:if test="${condition eq 'title' }">selected</c:if> >제목</option>
			<option value="writer" <c:if test="${condition eq 'writer' }">selected</c:if> >작성자</option>
		</select>
		<input type="text" name="keyword" 
			placeholder="검색어 입력..." value="${keyword }"/>
		<button type="submit">검색</button>
		<jsp:include page="../include/footer2.jsp"/>
	</form>
</div>
<jsp:include page="../include/msgbtn.jsp"/>
</body>
</html>