<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/board/detail.jsp</title>
<jsp:include page="../include/resource.jsp"/>
<style>
	/* 글 내용을 출력할 div 에 적용할 css */
	.contents, table{
		width: 100%;
		border: 1px dotted #cecece;
		box-shadow: 3px 3px 5px 6px #ccc;
	}
	/* 댓글에 관련된 css */
	.comments ul{
		padding: 0;
		margin: 0;
		list-style-type: none;
	}
	.comments ul li{
		border-top: 1px solid #888; /* li 의 윗쪽 경계선 */
	}
	.comments dt{
		margin-top: 5px;
	}
	.comments dd{
		margin-left: 26px;
	}
	.comments form textarea, .comments form button{
		float: left;
	}
	.comments li{
		clear: left;
	}
	.comments form textarea{
		width: 85%;
		height: 100px;
	}
	.comments form button{
		width: 15%;
		height: 100px;
	}
	/* 댓글에 댓글을 다는 폼과 수정폼을 일단 숨긴다. */
	.comment form{
		display: none;
	}
	.comment{
		position: relative;
	}
	.comment .reply_icon{
		width: 15px;
		height: 15px;
		position: absolute;
		top: 10px;
		left: 30px;
	}
	.comments .user-img{
		width: 25px;
		height: 25px;
		border-radius: 50%;
	}
</style>
</head>
<body>
<jsp:include page="../include/navbar.jsp">
	<jsp:param value="board" name="category"/>
</jsp:include>
<div class="container">
	<ol class="breadcrumb">
		<li><a href="${pageContext.request.contextPath }/board/list.go?pageNum=${pageNum }&condition=${condition }&keyword=${encodedKeyword }">목록</a></li>
	</ol>
	<c:if test="${not empty keyword }">
		<p> <strong>${keyword }</strong> 검색어로 검색된
		결과 자세히 보기 입니다.</p>
	</c:if>
	
	<h3>게시글 상세 보기</h3>
	
	<c:if test="${dto.prevNum ne 0 }">
		<a href="detail.go?num=${dto.prevNum }&condition=${condition}&keyword=${encodedKeyword}">이전글</a>
	</c:if>
	
	<c:if test="${dto.nextNum ne 0 }">
		<a href="detail.go?num=${dto.nextNum }&condition=${condition}&keyword=${encodedKeyword}">다음글</a>
	</c:if>	
	<table class="table table-bordered table-condensed">
		<colgroup>
			<col class="col-xs-3"/>
			<col class="col-xs-9"/>
		</colgroup>
		<tr>
			<th>글번호</th>
			<td>${dto.num }</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${dto.writer }</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${dto.title }</td>
		</tr>
		<tr>
			<th>등록일</th>
			<td>${dto.regdate }</td>
		</tr>
	</table>
	<div class="contents">${dto.content }</div>
	<%-- 
		글 작성자와 로그인 된 아이디가 같을때만 기능을 제공해 준다. 
		즉, 본인이 작성한 글만 수정할수 있도록 하기 위해
	--%>
	<c:if test="${dto.writer eq id }">
		<a href="updateform.go?num=${dto.num }">
			수정
		</a>
		<a href="javascript:deleteConfirm()">삭제</a>
	</c:if>
	<div class="comments">
		<ul>
		<c:forEach items="${commentList }" var="tmp">
			<c:choose>
				<c:when test="${tmp.deleted ne 'yes' }">
					<li class="comment" id="comment${tmp.num }" <c:if test="${tmp.num ne tmp.comment_group }">style="padding-left:50px;"</c:if> >
						<c:if test="${tmp.num ne tmp.comment_group }">
							<img class="reply_icon" src="${pageContext.request.contextPath}/resources/images/re.gif"/>
						</c:if>
						<dl>
							<dt>
								<c:choose>
									<c:when test="${empty tmp.profile }">
										<img class="user-img" src="${pageContext.request.contextPath}/resources/images/default_user.jpeg"/>
									</c:when>
									<c:otherwise>
										<img class="user-img" src="${pageContext.request.contextPath}${tmp.profile}"/>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${tmp.num ne tmp.comment_group}">
										<strong style="color:#B8B6B6">@${tmp.target_id}</strong>
										<strong>${tmp.writer}</strong>
									</c:when>
									<c:otherwise>
										 <span>${tmp.writer }</span>
									</c:otherwise>
								</c:choose>
								<span>${tmp.regdate }</span>
								<a href="javascript:" class="reply_link">답글</a> |
								<c:choose>
									<%-- 로그인된 아이디와 댓글의 작성자가 같으면 --%>
									<c:when test="${id eq tmp.writer }">
										<a href="javascript:" class="comment-update-link">수정</a> |
										<a href="javascript:deleteComment(${tmp.num })">삭제</a>
									</c:when>
									<c:otherwise>
										<a href="javascript:">신고</a>
									</c:otherwise>
								</c:choose>
							</dt>
							<dd>
								<pre>${tmp.content }</pre>
							</dd>
						</dl>
						<form class="comment-insert-form" action="comment_insert.go" method="post">
							<!-- 덧글 그룹 -->
							<input type="hidden" name="ref_group" value="${dto.num }" />
							<!-- 덧글 대상 -->
							<input type="hidden" name="target_id" value="${tmp.writer }" />
							<input type="hidden" name="comment_group" value="${tmp.comment_group }" />
							<textarea name="content" id="content"><c:if test="${empty id }">로그인이 필요합니다.</c:if></textarea>
							<button type="submit" disabled id="insertBtn" class="btn btn-primary">등록</button>
						</form>	
						<!-- 로그인한 아이디와 댓글의 작성자와 같으면 수정폼 출력 -->				
						<c:if test="${id eq tmp.writer }">
							<form class="comment-update-form" action="comment_update.go" method="post">
								<input type="hidden" name="num" value="${tmp.num }" />
								<textarea name="updatecontent">${tmp.content }</textarea>
								<button type="submit" disabled>수정</button>
							</form>
						</c:if>
					</li>				
				</c:when>
				<c:otherwise>
					<li <c:if test="${tmp.num ne tmp.comment_group }">style="padding-left:50px;"</c:if> >삭제된 댓글 입니다.</li>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		</ul>
		<div class="clearfix"></div>	
		<!-- 원글에 댓글을 작성할수 있는 폼 -->
		<div class="comment_form">
			<form action="comment_insert.go" method="post">
				<!-- 댓글의 그룹번호는 원글의 글번호가 된다.  -->
				<input type="hidden" name="ref_group" 
					value="${dto.num }"/>
				<!-- 댓글의 대상자는 원글의 작성자가 된다. -->
				<input type="hidden" name="target_id" 
					value="${dto.writer }"/>
				<textarea name="content"><c:if test="${empty id }">로그인이 필요합니다.</c:if></textarea>
				<button type="submit">등록</button>
			</form>
		</div>
	</div>
	<!--  댓글 페이징 구역 -->
<div class="page-display">
		<ul class="pagination">
		<c:choose>
			<c:when test="${re_startPageNum ne 1 }">
				<li>
					<a href="detail.go?num=${dto.num }&re_pageNum=${re_startPageNum-1 }">
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
		<c:forEach var="i" begin="${re_startPageNum }" 
			end="${re_endPageNum }" step="1">
			<c:choose>
				<c:when test="${i eq re_pageNum }">
					<li class="active"><a href="detail.go?num=${dto.num }&re_pageNum=${i }">${i }</a></li>
				</c:when>
				<c:otherwise>
					<li><a href="detail.go?num=${dto.num }&re_pageNum=${i }">${i }</a></li>
				</c:otherwise>
			</c:choose>
		</c:forEach>

		<c:choose>
			<c:when test="${re_endPageNum lt re_totalPageCount }">
				<li>
					<a href="detail.go?num=${dto.num }&re_pageNum=${re_endPageNum+1 }">
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
</div>
<jsp:include page="../include/footer.jsp"/>

<script>
	//댓글 수정 링크를 눌렀을때 호출되는 함수 등록
	$(".comment-update-link").click(function(){
		$(this)
		.parent().parent().parent()
		.find(".comment-update-form")
		.slideToggle(200);
	});
	
	//댓글 수정 폼에 submit 이벤트가 일어났을때 호출되는 함수 등록
	$(".comment-update-form").on("submit", function(){
		// "comment_update.go"
		var url=$(this).attr("action");
		//폼에 작성된 내용을 query 문자열로 읽어온다.
		// num=댓글번호&content=댓글내용
		var data=$(this).serialize();
		//이벤트가 일어난 폼을 선택해서 변수에 담아 놓는다.
		var $this=$(this);
		$.ajax({
			url:url,
			method:"post",
			data:data,
			success:function(responseData){
				// responseData : {isSuccess:true}
				if(responseData.isSuccess){
					//폼을 안보이게 한다 
					$this.slideUp(200);
					//폼에 입력한 내용 읽어오기
					var content=$this.find("textarea").val();
					//pre 요소에 수정 반영하기 
					$this.parent().find("pre").text(content);
				}
			}
		});
		//폼 제출 막기 
		return false;
	});
	
	//댓글 삭제를 눌렀을때 호출되는 함수
	function deleteComment(num){
		var isDelete=confirm("확인을 누르면 댓글이 삭제 됩니다.");
		if(isDelete){
			//페이지 전환 없이 ajax 요청을 통해서 삭제 하기 
			$.ajax({
				url:"comment_delete.go", // "/board/comment_delete.go" 요청
				method:"post",
				data:{"num":num, "ref_group":${dto.num}}, // num 이라는 파라미터명으로 삭제할 댓글의 번호 전송
				success:function(responseData){
					if(responseData.isSuccess){
						var sel="#comment"+num;
						$(sel).text("삭제된 댓글 입니다.");
					}
				}
			});
		}
	}
	
	//폼에 submit 이벤트가 일어 났을때 실행할 함수 등록 
	$(".comments form").on("submit", function(){
		//로그인 여부
		var isLogin=${not empty id};
		if(isLogin==false){
			alert("로그인 페이지로 이동 합니다.");
			location.href="${pageContext.request.contextPath}/users/loginform.go?url=${pageContext.request.contextPath}/board/detail.go?num=${dto.num}";
			return false;//폼 전송 막기 
		}
	});
	//폼에 click 이벤트가 일어 났을때 실행할 함수 등록 
	$(".comments form textarea").on("click", function(){
		//로그인 여부
		var isLogin=${not empty id};
		if(isLogin==false){
			var isMove=confirm("로그인 페이지로 이동 하시겠습니까?");
			if(isMove){
				location.href="${pageContext.request.contextPath}/users/loginform.go?url=${pageContext.request.contextPath}/board/detail.go?num=${dto.num}";
			}
		}
	});
	
	//댓글 미 입력시 미제출
	$("#content").on("input",function(){
		var insertreply=$("#content").val();
		if(insertreply.length!=0){
			$("#insertBtn").removeAttr("disabled");
		}else{
			$("#insertBtn").attr("disabled","disabled");
		}
	});
	
	//답글 달기 링크를 클릭했을때 실행할 함수 등록
	$(".comment .reply_link").click(function(){
		$(this)
		.parent().parent().parent()
		.find(".comment-insert-form")
		.slideToggle(200);
		
		// 답글 <=> 취소가 서로 토글 되도록 한다. 
		if($(this).text()=="답글"){
			$(this).text("취소");
		}else{
			$(this).text("답글");
		}
	});
	function deleteConfirm(){
		var isDelete=confirm("글을 삭제 하시 겠습니까?");
		if(isDelete){
			location.href="delete.go?num=${dto.num}";
		}
	}
</script>
</body>
</html>