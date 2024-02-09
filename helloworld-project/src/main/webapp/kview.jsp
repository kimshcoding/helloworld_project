<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="helloworld.vo.*"%>
<%@ page import="java.util.*"%>
<%
// 현재 로그인한 회원 정보를 세션에서 가져옴
Member member = (Member) session.getAttribute("login");

//요청 파라미터에서 게시글 번호를 가져옴
String bnoParam = request.getParameter("bno");

int before = 0; // 이전글 변수 초기화
int after = 0;	// 다음글 변수 초기화

int bno = 0;
if (bnoParam != null && !bnoParam.equals("")) {
	bno = Integer.parseInt(bnoParam);
}

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/helloworld";
String user = "bteam";
String pass = "project1";

Board board = new Board(); //sql의 결과 행을 담을 객체
List<BoardFile> bflist = new ArrayList<BoardFile>(); //게시글 첨부파일 목록 변수
List<Reply> rlist = new ArrayList<Reply>(); //댓글 목록

try {
	// 게시글 조회 수 중복 방지를 위한 쿠키 설정
	boolean isBnoCookie = false; // 게시글 번호에 대한 쿠키가 있는지 여부를 나타내는 변수 초기화
	Cookie[] cookies = request.getCookies(); // 현재 요청으로부터 모든 쿠키를 가져옴

	// 모든 쿠키를 반복하면서 게시글 번호에 대한 쿠키가 있는지 확인
	for (Cookie tempCookie : cookies) {
		if (tempCookie.getName().equals("board" + bno)) {
	isBnoCookie = true; // 해당 게시글 번호에 대한 쿠키가 있다면 변수를 true로 설정하고 반복문 종료
	break;
		}
	}
	// 해당 게시글 번호에 대한 쿠키가 없다면 새로운 쿠키를 생성하여 응답에 추가
	if (!isBnoCookie) {
		Cookie cookie = new Cookie("board" + bno, "ok"); // 게시글 번호에 대한 쿠키 생성
		cookie.setMaxAge(60 * 60 * 24); // 쿠키의 유효 기간을 하루로 설정
		response.addCookie(cookie); // 응답에 쿠키 추가
	}

	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);

	String sql = "";

	// 게시글 번호에 대한 쿠키가 없는 경우에 해당하는 조건문입니다. 
	// 이 조건문은 쿠키가 없을 때 조회수를 증가시키는 작업을 수행
	if (!isBnoCookie) {

		// UPDATE 문을 사용하여 board 테이블에서 bhit(조회수)를 1 증가시키는 쿼리입니다. 
		// 조건은 게시글 번호(bno)가 특정한 값일 때입니다.
		sql = "UPDATE board " + "	  SET bhit = bhit+1" + " WHERE bno = ? ";

		psmt = conn.prepareStatement(sql);

		psmt.setInt(1, bno); // PreparedStatement에 쿼리의 파라미터로 게시글 번호(bno)를 설정합니다.

		psmt.executeUpdate(); // 조회수를 1 증가시키는 쿼리를 실행하므로 해당 게시글의 조회수가 증가됩니다.

		if (psmt != null)
	psmt.close();
	}

	//----------------------------------------------------------------------------------------------------

	sql = "SELECT bno, btitle, b.mno, m.mnickname, b.rdate, b.mdate, b.bcontent, b.bhit "
			   + "  FROM board b"
			   + " INNER JOIN member m"
			   + " ON b.mno = m.mno"
			   + " WHERE b.bno = ?";
			
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1,bno);
			rs = psmt.executeQuery();
			
			if(rs.next()){
		board.setBno(rs.getInt("bno"));
		board.setBtitle(rs.getString("btitle"));
		board.setMno(rs.getInt("mno"));
		board.setMname(rs.getString("mnickname"));
		board.setRdate(rs.getString("rdate"));
		board.setMdate(rs.getString("mdate"));
		board.setBcontent(rs.getString("bcontent"));
		board.setBhit(rs.getInt("bhit"));
			}

	//----------------------------------------------------------------------------------------------
	// 이전글 bno 가져오기
	
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
		
		sql = "SELECT * FROM board WHERE type = 'K' and delyn='N' and bno < ? order by bno DESC limit 0,1 ";  // ? -> 현재 페이지 bno
	
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1, board.getBno());
		rs = psmt.executeQuery();
	
	if (rs.next()) {
		before = rs.getInt("bno");
	}
	
	//----------------------------------------------------------------------------------------------
	// 다음글 bno 가져오기
	
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	
		sql = "SELECT * FROM board WHERE type = 'K' and delyn='N' and bno > ? order by bno ASC limit 0,1 ";  // ? -> 현재 페이지 bno
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1, board.getBno());
		rs = psmt.executeQuery();
	
		if (rs.next()) {
		after = rs.getInt("bno");
		}
		
	
	//-----------------------------------------------------------------------------------------------------------------	
	

	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();

	sql = "SELECT * FROM boardFile WHERE bno = ?";

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, bno);

	rs = psmt.executeQuery();

	while (rs.next()) {
		// 각 행의 데이터를 담을 BoardFile 객체를 생성합니다.
		BoardFile bf = new BoardFile();

		bf.setBfno(rs.getInt("bfno")); // bfno 열의 값을 읽어와서 BoardFile 객체에 설정합니다.
		bf.setBno(rs.getInt("bno"));
		bf.setBfrealnm(rs.getString("bfrealnm"));
		bf.setBforiginnm(rs.getString("bforiginnm"));
		bf.setRdate(rs.getString("rdate"));

		bflist.add(bf); // BoardFile 객체를 bflist라는 리스트에 추가합니다. 이 리스트는 특정 게시글에 첨부된 파일 정보를 담고 있습니다.
		// 이 코드는 특정 게시글에 첨부된 파일 정보를 데이터베이스에서 조회하여 bflist 리스트에 저장하는 역할을 합니다.
	}

	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();

	// 저장된 댓글 목록 
	// 이 코드는 특정 게시글에 대한 댓글 목록을 데이터베이스에서 가져와서 rlist라는 리스트에 저장하는 부분입니다. 
	// 각 댓글은 Reply 객체에 매핑되어 저장됩니다.

	sql = " select r.rno, r.bno, m.mname, m.mnickname, m.mno, r.rcontent, r.mdate" //<----댓글수정시간
	+ "   from reply r " + " inner join member m " + "     on r.mno = m.mno "
	+ "  where r.bno = ? AND r.delyn = 'N' " // 삭제된 댓글은 화면 출력 안됨!
	+ "ORDER BY r.rno DESC"; // <--- 업데이트를 해도 최신 댓글의 내림차순이 유지됨

	// reply 테이블과 member 테이블을 조인하여 해당 게시글 (r.bno = ?)에 대한 
	// 댓글 정보와 작성자 정보를 가져오는 쿼리입니다.

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, board.getBno());
	// ?를 게시글 번호 (board.getBno())로 설정합니다.
	rs = psmt.executeQuery();
	//쿼리를 실행하고 결과를 ResultSet 객체에 저장합니다.
	while (rs.next()) {
		Reply reply = new Reply();
		reply.setRno(rs.getInt("rno"));
		reply.setBno(rs.getInt("bno"));
		reply.setMno(rs.getInt("mno"));
		reply.setMname(rs.getString("mname"));
		reply.setMnickname(rs.getString("mnickname"));
		reply.setRcontent(rs.getString("rcontent"));
		reply.setMdate(rs.getString("mdate"));

		rlist.add(reply);
		//생성된 Reply 객체는 rlist라는 리스트에 추가됩니다.
		//결과적으로, rlist에는 해당 게시글에 대한 모든 댓글이 Reply 객체로 저장되어 있게 됩니다. 
		//이 리스트는 후속 코드에서 댓글을 화면에 표시하는 데 사용될 것입니다.
	}

} catch (Exception e) {
	e.printStackTrace();
} finally {
	if (conn != null)
		conn.close();
	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();
}
%>

<!DOCTYPE html>
<html>

<head>
<!-- Basic -->
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!-- Mobile Metas -->
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<!-- Site Metas -->
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta name="author" content="" />

<title>Hello World</title>

<!-- bootstrap core css -->
<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />

<!-- fonts style -->
<link
	href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;900&display=swap"
	rel="stylesheet">

<!--owl slider stylesheet -->
<!-- <link rel="stylesheet" type="text/css"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" /> -->

<!-- font awesome style -->
<link href="css/font-awesome.min.css" rel="stylesheet" />

<!-- Custom styles for this template -->
<link href="css/style.css" rel="stylesheet" />
<!-- 건들면 깨짐 -->


<!-- 상세보기 css -->
<link rel="stylesheet" type="text/css" href="css/view.css" />


<script>
	// 댓글 작성 함수
	function replyInsertFn(){
		let loginMember = '<%=member%>'; 
		/* JSP 페이지에서 받아온 member 변수 값을 JavaScript 변수 loginMember에 할당합니다. 
		   이 변수에는 현재 로그인한 사용자의 정보가 들어 있습니다.*/
		 
		if(loginMember != 'null'){
			/* loginMember가 'null'이 아닌 경우를 확인하는 조건문입니다. 
			즉, 사용자가 로그인한 경우에 해당하는 블록의 코드가 실행됩니다.*/
			let params = $("form[name=replyfrm]").serialize();
			/* jQuery를 사용하여 replyfrm이라는 이름을 가진 폼의 데이터를 직렬화하여 문자열로 가져옵니다. 
				이 문자열은 AJAX 요청의 데이터로 사용됩니다.*/ 
			console.log(params);
			
			$.ajax({
				url : "qreplyWriteOk.jsp",  
				type:"post",
				data: params,
				/*AJAX 요청을 통해 서버에 댓글 작성을 요청합니다. 요청은 replyWriteOk.jsp 페이지로 이동하고, 
				  데이터는 params에 담긴 직렬화된 폼 데이터로 전송됩니다.*/
				
				success:function(data){
					if(data.trim() != "FAIL"){
						$(".replyArea").prepend(data.trim());
						
				/* success 콜백 함수에서는 서버로부터 받은 응답 데이터를 처리합니다. 만약 응답이 "FAIL"이 아니라면, 
				새로 작성된 댓글을 .replyArea라는 클래스를 가진 요소의 맨 앞에 추가합니다. 
				이를 통해 댓글 목록이 실시간으로 업데이트됩니다.*/
					}
				},error:function(){
					console.log("error");
				}
			});
			
		}else{
			alert("로그인후에 처리하세요");
			location.href='login.jsp';
		}
		
		$("input[name=rcontent]").val("");
		/* 댓글 작성이 완료되면 댓글 입력 폼의 내용을 비워줍니다. 
			이 코드는 댓글을 작성하고, 작성한 댓글을 실시간으로 화면에 업데이트하는 기능을 구현하고 있습니다.*/
	}
	
	
	// 댓글 삭제 함수
	function replyDelFn(rno,obj){ /* replyDelFn 함수는 댓글 번호(rno)와 해당 댓글이 속한 HTML 요소(obj)를 매개변수로 받습니다. */
		$.ajax({
			url : "qdeleteReplyOk.jsp",
			type : "post",
			data : "rno="+rno, /* 요청에 댓글 번호를 데이터로 첨부하여 전송합니다. */
			success:function(data){
				console.log(data);
				if(data.trim() == 'SUCCESS'){
					alert("댓글이 삭제되었습니다.");
					
					let target = $(obj).parent().parent(); 
					/* 삭제된 댓글이 속한 HTML 요소의 상위(parent)에 해당하는 부모 요소를 찾아서 target 변수에 할당합니다. */
					target.remove(); /* target에 해당하는 HTML 요소를 삭제합니다. 즉, 삭제된 댓글이 화면에서 사라지게 됩니다. */
					
					
					
					
				}else{
					alert("댓글이 삭제되지 못했습니다.");
				}
			},error:function(){
				console.log("error");
			}
		});
		/* 이 코드는 댓글을 삭제하기 위해 AJAX를 사용하고, 성공 또는 실패 여부에 따라 사용자에게 알림을 제공하며, 
			삭제된 댓글을 화면에서 실시간으로 제거하는 기능을 구현하고 있습니다. */
	}
	
	
	// 작성한 댓글 수정 함수
	// isModify 변수는 현재 수정 모드인지 아닌지를 나타내는 상태 변수입니다.
	let isModify = false;
	 
	function modifyFn(obj, rno){
		// 함수는 클릭된 버튼(obj)과 댓글 번호(rno)를 매개변수로 받습니다.
		if(!isModify){
			
			let value = $(obj).parent().prev("span").text().trim();
			// 클릭된 버튼의 부모 요소의 이전 형제 중 span 태그의 텍스트 값을 가져와서 공백을 제거한 후, value 변수에 저장합니다.
			console.log(value);
			let html = "<input type='text' name='rcontent' value='"+value+"' style='width: 100%; padding: 15px; margin-bottom: 10px; border: 1px solid #ccc; box-sizing: border-box;'>";
			html += "<input type='hidden' name='rno' value='"+rno+"'>";
			html += "<input type='hidden' name='oldRcontent' value='"+value+"'>";
			// html 변수에 수정할 댓글을 입력할 수 있는 input 요소와 댓글 번호, 
			// 그리고 수정 전의 댓글 내용을 담은 input 요소들을 문자열 형태로 저장합니다.
			$(obj).parent().prev("span").html(html);
			//클릭된 버튼의 부모 요소의 이전 형제 중 span 태그의 HTML 내용을 위에서 만든 html로 대체합니다.
			html = "<button onclick='saveFn(this)' class='btn btn-outline-primary'>저장</button>"
				 +"<button onclick='cancleFn(this)' class='btn btn-outline-primary'>취소</button>";
			//html 변수에 저장된 input 요소들을 대체하고, 저장과 취소 버튼을 생성하는 HTML 문자열을 저장합니다.
			$(obj).parent().html(html);
			//클릭된 버튼의 부모 요소의 HTML 내용을 위에서 만든 html로 대체합니다.
			isModify = true;
	 
		}else{
			alert("수정중인 댓글을 저장하세요.");
		//이미 수정 중인 상태인 경우 사용자에게 알림을 표시하여 수정 중인 댓글을 먼저 저장하라는 메시지를 출력합니다.
		}
	}
	
	
	// 수정된 댓글 저장 함수
	function saveFn(obj){
		// 함수는 저장 버튼이 클릭될 때 호출됩니다. obj는 클릭된 버튼을 나타냅니다.
		isModify = false;
		
		// 수정된 댓글의 내용(value), 댓글 번호(rno), 그리고 수정 전의 댓글 내용(originalValue)을 변수에 저장합니다. 
		// 이때 jQuery를 사용하여 이전 형제 중 span 태그 내의 input 요소들을 선택합니다.
		let value = $(obj).parent().prev("span")
						.find("input[name=rcontent]").val();
		let rno = $(obj).parent().prev("span")
						.find("input[name=rno]").val();
		let originalValue = $(obj).parent().prev("span")
								.find("input[name=oldRcontent]").val();
		
		$.ajax({
			url : "qreplyModifyOk.jsp",
			type : "post",
			data : {rcontent : value, rno : rno}, //데이터에는 수정된 댓글의 내용과 댓글 번호가 포함되어 있습니다.
			success : function(data){
				if(data.trim() == 'SUCCESS'){
					
					$(obj).parent().prev("span").text(value);
					let html = '<button onclick="modifyFn(this,'+rno+')" class="btn btn-outline-primary">수정</button>'
							+  '<button onclick="replyDelFn('+rno+',this)" class="btn btn-outline-primary">삭제</button>';
											
					$(obj).parent().html(html);	
					
					 location.reload();  // <------ 댓글 수정 저장 버튼을 누르면 수정 입력일로 업데이트됨 (새로고침 기능으로)
					
				//수정된 내용을 이전 형제 중 span 태그에 텍스트로 출력하고, 수정 및 삭제 버튼을 생성하여 해당 부모 요소의 HTML 내용을 갱신합니다.
				
					
				}else{
					$(obj).parent().prev("span").text(originalValue);
					let html = '<button onclick="modifyFn(this,'+rno+')" class="btn btn-outline-primary">수정</button>'
							+  '<button onclick="replyDelFn('+rno+',this)" class="btn btn-outline-primary">삭제</button>';
					$(obj).parent().html(html);	
				//원래의 내용으로 복원하고 수정 및 삭제 버튼을 생성하여 해당 부모 요소의 HTML 내용을 갱신합니다
				}
			
					
			},error:function(){
				console.log("error");
			}
		});
		
	}
	
	
	// 댓글 수정 취소 함수
	function cancleFn(obj){
		// 취소 버튼이 클릭될 때 실행됩니다. obj는 클릭된 버튼을 나타냅니다.
		let originalValue = $(obj).parent().prev("span").find("input[name=oldRcontent]").val();
		console.log(originalValue);
		//수정 전의 댓글 내용(originalValue)을 변수에 저장하고, 콘솔에 출력합니다. 
		//jQuery를 사용하여 이전 형제 중 span 태그 내의 input 요소 중 이름이 'oldRcontent'인 값을 선택합니다.
		let rno = $(obj).parent().prev("span").find("input[name=rno]").val();
		// 댓글 번호(rno)를 변수에 저장합니다. 
		// jQuery를 사용하여 이전 형제 중 span 태그 내의 input 요소 중 이름이 'rno'인 값을 선택합니다.
		
		$(obj).parent().prev("span").text(originalValue);
		//이전 형제 중 span 태그의 텍스트 내용을 수정 전의 댓글 내용으로 복원합니다.
		let html = "<button onclick='modifyFn(this, "+rno+")' class='btn btn-outline-primary'>수정</button>";
		html += "<button onclick='replyDelFn("+rno+",this)' class='btn btn-outline-primary'>삭제</button>";
		$(obj).parent().html(html);
		//수정 및 삭제 버튼을 생성하여 해당 부모 요소의 HTML 내용을 갱신합니다.
		
		isModify = false;
		// isModify 변수를 false로 설정하여 수정 모드를 비활성화합니다. 
		// 이는 다시 수정 버튼을 누를 때 새로운 수정을 시작할 수 있도록 합니다.
	}
	
</script>

<style>
.btn {
	border-radius : 6.25rem;
}
</style>

</head>

<body class="sub_page">

	<div class="hero_area">
		<div class="hero_bg_box">
			<div class="bg_img_box">
				<img src="images/hero-bg.png" alt="">
			</div>
		</div>

		<!-- header section strats -->
		<%@ include file="header.jsp"%>
		<!-- end header section -->
	</div>


	<!-- qboard section -->

	<section class="about_section layout_padding">
		<div class="container  ">
		
		
<!-- 이전글, 다음글, 목록 버큰 위치 ---------------------------------------------------------------------------- -->	

	<div class="d-grid gap-3 d-md-flex justify-content-md-end">
		<!-- 이전 글 -->
		<!-- 제일 처음 글일 때 "제일 처음 글입니다" 알림창 보여주고, 이전글 미노출 -->
		<%
			if (before != 0) {
		%>
		<%-- <script>
			alert("제일 처음 글입니다.");
		</script>
		<% 
			} else {
		%> --%>
		<button onclick="location.href='kview.jsp?bno=<%= before %>'" class="btn btn-primary me-md-3" type="button">이전글</button>
		<%
			}
		%>
		
		
		<!-- 다음 글 -->
		
		<!-- 마지막 글일 때 "마지막 글입니다" 알림창 보여주고, 다음글 미노출 -->
		<%
			if (after != 0) {
		%>
		<%-- <script>
			alert("제일 마지막 글입니다.");
		</script>
		<% 
			} else {
		%> --%>
		
		<button onclick="location.href='kview.jsp?bno=<%= after %>'" class="btn btn-primary me-md-3" type="button">다음글</button>
		<%
			}
		%>
		
		<!-- 클릭시 게시글 목록 페이지로 이동 -->
		<button onclick="location.href='kboard.jsp'" class="btn btn-success">목록</button>
	</div>
		<br>		
		
<!-- -----------------------------------------------------------------------------------------------------------	 -->			
		
		
			<div class="heading_container heading_center">
				<h2>
					지식 게시글 <span>상세보기</span>
				</h2>
				<br>
				<br>

				<!-- 게시판 시작-->
				<div class="container text-center">
					<div class="row row-cols-1 row-cols-sm-2 row-cols-md-5">
						<div class="col">
							<h5>제목</h5>
							<%=board.getBtitle()%>
						</div>
						<div class="col">
							<h5>작성자</h5>
							<%=board.getMname()%>
						</div>
						<div class="col">
							<h5>수정일</h5>
							<%=board.getMdate()%>
						</div>
						<div class="col">
							<h5>조회수</h5>
							<%=board.getBhit()%>
						</div>
						<div class="col">
							<h5>첨부파일</h5>
							<%
							for (BoardFile tempbf : bflist) {
							%>
							<a
								href="qdownload.jsp?realNM=<%=tempbf.getBfrealnm()%>&originNM=<%=tempbf.getBforiginnm()%>"><%=tempbf.getBforiginnm()%></a><br>
							<%
							}
							%>
						</div>
					</div>
				</div>
				<br>
				<table class="table">
					<tbody>
						<tr>
							<th>내 용</th>
						</tr>
						<tr>
							<td><%=board.getBcontent()%></td>
						</tr>
					</tbody>
				</table>
				<br>

				<!-- 로그인한 유저가 쓴 게시글에서만 수정, 삭제 버튼 노출 -->
				<%
				if (member != null && member.getMno() == board.getMno()) {
				%>
				<div class="d-grid gap-2 d-md-block">
					<button
						onclick="location.href='kmodify.jsp?bno=<%=board.getBno()%>'"
						class="btn btn-warning">수정</button>
					<button onclick="delFn()" class="btn btn-danger">삭제</button>
					<script>
			function delFn(){
				let isDel = confirm("정말 삭제하시겠습니까?");
				 
				if(isDel){
					document.frm.submit();	
				}
			}
		</script>

					<%
					}
					%>

				</div>
				<br>


				<form name="frm" action="kdelete.jsp" method="post">
					<input type="hidden" name="bno" value="<%=board.getBno()%>">
				</form>


				<!--- 댓글 영역 --->
				<div class="d-flex justify-content-center align-items-center">
					<form name="replyfrm">
						<input type="hidden" name="bno" value="<%=board.getBno()%>">
						<!-- bno는 현재 게시글의 번호를 나타내며, 숨김 필드로 사용되어 전송됩니다. -->

						댓글 <input type="text" name="rcontent" maxlength="20"
							oninput="checkInputLength(this)" style="width: 300px;">
						<button type="button" onclick="replyInsertFn()"
							class="btn btn-primary">저장</button>
					</form>
					<br>
					<br>
				</div>

		 <!-- 댓글 100글자수 이상 입력 불가능 -->
				<script>
		 		function checkInputLength(inputElement) {
		        if (inputElement.value.length > 20) {
		            alert("댓글은 100글자 이하로 입력해주세요.");
		            inputElement.value = inputElement.value.substring(0, 20);
		        	}
		    	}
				</script>




				<!-- 저장된 댓글 목록을 출력하는 부분입니다. -->
				<div class="d-flex justify-content-center align-items-center">
					<div class="replyArea">
						<%
						for (Reply reply : rlist) {
						%>
						<!-- rlist에 저장된 각각의 댓글에 대해 반복문을 실행하여 화면에 표시합니다. -->
						<div class="replyRow">
							<span style="color: yellow; font-weight: bold; text-align: left;"><%=reply.getMnickname()%></span>
							<span style="color: orange; text-align: left;"> <%-- 수정 입력일이 있으면 그것을, 없으면 최초 입력일을 표시합니다. --%>
								<%
								String displayDate = (reply.getMdate() != null) ? reply.getMdate() : reply.getRdate();
								%>
								<%=displayDate%>
							</span><br> <span style="text-align: left;"> <%=reply.getRcontent()%>
							</span>
							<!-- 로그인한 유저에게만 댓글 수정 삭제 버튼 노출 -->
							<%
							if (member != null && member.getMno() == reply.getMno()) {
							%>
							<span style="text-align: left;">
								<button onclick="modifyFn(this,<%=reply.getRno()%>)"
									class="btn btn-outline-primary">수정</button>
								<button onclick="replyDelFn(<%=reply.getRno()%>,this)"
									class="btn btn-outline-primary">삭제</button>
							</span>
							<%
							}
							%>
							<hr>
							<br>
						</div>

						<%
						}
						%>
					</div>
				</div>




				<!-- 게시판 종료-->

			</div>
		</div>
	</section>
	<!-- end qview section -->

	<!-- footer section -->
	<%@ include file="footer.jsp"%>
	<!-- footer section -->

	<!-- jQery -->
	<script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
	<!-- popper js -->
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
		integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
		crossorigin="anonymous">
    </script>
	<!-- bootstrap js -->
	<script type="text/javascript" src="js/bootstrap.js"></script>
	<!-- owl slider -->
	<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
  </script> -->

</body>
</html>