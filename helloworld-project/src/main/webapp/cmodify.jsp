<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="helloworld.vo.*"%>
<%
			
Member member = (Member) session.getAttribute("login");
String bnoParam = request.getParameter("bno");

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

BoardFile bf = new BoardFile(); // 파일 수정 테스트

try {

	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);

	String sql = "SELECT bno, btitle, b.mno, m.mname, m.mnickname, b.rdate, b.mdate, b.bcontent, b.bhit " 
				+ "  FROM board b"
				+ " INNER JOIN member m" 
				+ " ON b.mno = m.mno" 
				+ " WHERE b.bno = ?";

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, bno);
	rs = psmt.executeQuery();

	if (rs.next()) {
		board.setBno(rs.getInt("bno"));
		board.setBtitle(rs.getString("btitle"));
		board.setMno(rs.getInt("mno"));
		board.setMname(rs.getString("mname"));
		board.setRdate(rs.getString("rdate"));
		board.setMdate(rs.getString("mdate"));
		board.setBcontent(rs.getString("bcontent"));
		board.setBhit(rs.getInt("bhit"));
		board.setMnickname(rs.getString("mnickname"));
	}
	
	if(psmt != null) psmt.close(); // 파일 수정 테스트 위해 연결 종료
	if(rs != null) rs.close();	   // 파일 수정 테스트 위해 연결 종료
	
	// 파일 수정 테스트
	
	sql = "SELECT *FROM boardFile WHERE bno = ? ";
	
	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, bno);
	rs = psmt.executeQuery();
	
	while (rs.next()){
		bf.setBfno(rs.getInt("bfno"));
		bf.setBno(rs.getInt("bno"));
		bf.setBfrealnm(rs.getString("bfrealnm"));
		bf.setBforiginnm(rs.getString("bforiginnm"));
		bf.setRdate(rs.getString("rdate"));
		
	}
	// 파일 수정 테스트
	
	

} catch (Exception e) {
	e.printStackTrace();
} finally {
	if (conn != null)conn.close();
	if (psmt != null)psmt.close();
	if (rs != null)rs.close();
}

if (member == null || board.getMno() != member.getMno()) {
%>
	<script>
		alert("잘못된 접근입니다.");
		location.href='cboard.jsp';
	</script>
<%
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
	href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" />
 -->
<!-- font awesome style -->
<link href="css/font-awesome.min.css" rel="stylesheet" />

<!-- Custom styles for this template -->
<link href="css/style.css" rel="stylesheet" />


<!-- 게시글 수정 css -->
<link rel="stylesheet" type="text/css" href="css/modify.css" />

<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
 <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
 <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>  

<!-- 파일 수정 테스트 -->
<script>
	function boardFileDeleteFn(obj){
		let value = $(obj).parent().prev("span").text().trim();
		console.log(value);
		
		let html = "<input type='file' name='uploadFile'>" // 새로 첨부파일을 넣을 수 있는 양식으로 교체됨
				  + "<input type='hidden' name='bfno' value='"+<%=bf.getBfno()%>+"'>"; // 삭제할 파일 번호
				  
				  $(obj).parent().prev("span").html(html);
				  
				  html = "";
				  $(obj).parent().html(html);
				  
	}
	
	
	
	//첨부파일 번호인 bfno(PK값) 을 넘겨주어야 modifyOk.jsp에서 삭제를 할 수 있다. 
	// 그런데 bfno를 밑에서 아무조건없이 무조건 넘기게 되면 파일삭제여부와 상관없이 
	//modifyOk.jsp에서 첨부파일을 무조건 삭제시키게 된다. 
	//그러므로 (기존파일을) 삭제버튼 누를때만 bfno 를 넘겨주면 된다. 
	//즉, 새로운 첨부파일 보낼때 같이hidden 사용해서 보내면 된다. 

	
	
	function cancleModifyFn(){
		
		<%
     	if(bf.getBforiginnm() != null){
     	%>
     	
		let html= "<%= bf.getBforiginnm()%>";
		
		$("#target").html(html);
		
		html ="<button type='button' onclick='boardFileDeleteFn(this)' class='btn btn-danger'>삭제</button>";
		$("#del").html(html);
		
		
		<%
     	}
		%>
		let bcontent= '<%=board.getBcontent()%>';  /* 기존 내용을 가져와서*/
	      
        $(".note-editable").html(bcontent);		  /* 스마트 에디터 내용에 넣어준다 */
	
	}
</script>


<!-- 파일 수정 테스트 -->
</head>

<body class="sub_page">

	<div class="hero_area">

		<div class="hero_bg_box">
			<div class="bg_img_box">
				<img src="images/hero-bg.png" alt="">
			</div>
		</div>

		<!-- header section strats -->
	 <%@ include file="header.jsp" %>	
		<!-- end header section -->
	</div>

	<!-- qboard section -->

	<section class="about_section layout_padding">
		<div class="container  ">
			<div class="heading_container heading_center">
				<h2>
					커뮤니티 게시글 <span>수정</span>
				</h2>
				<p></p>
				<br>
				

	<form name="frm" action="cmodifyOk.jsp" method="post" enctype="multipart/form-data">
	 <!-- 파일 수정을 위해 enctype="multipart/form-data" 추가됨 
		 해당 폼이 파일 업로드와 같은 이진 데이터를 서버로 전송할 때 사용
	 -->
    <input type="hidden" name="bno" value="<%=board.getBno()%>">


<div class="container text-center">
 <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4">
  
    <div class="col">
      <h5>작성자</h5>
      <%=board.getMnickname()%>
    </div>
    <div class="col">
    <h5>수정일</h5>
    <%=board.getMdate()%>
    </div>
    <div class="col">
     <h5>조회수</h5>
     <%=board.getBhit()%>
    </div>
  
  	<!-- 파일 수정 테스트 -->
  	<div class="col">
     <h5>파일첨부</h5>
     <%
     	if(bf.getBforiginnm() != null){
     %>
    	<span id="target"><%=bf.getBforiginnm()%></span>
    	<span id="del"><button type="button" onclick="boardFileDeleteFn(this)" class="btn btn-danger">삭제</button></span>
    <%
     	}else{
    %>	<span id="target"></span>
    	<span id="del"><button type="button" onclick="boardFileDeleteFn(this)" class="btn btn-warning">추가</button></span>
    	<%
     	}
    	%>
    </div>
 
  	<!-- 파일 수정 테스트 -->
  	
  </div>
</div><br>

  <div>
      <h5>제목</h5>
      <input type="text" name="btitle" style="width: 100%; "value="<%= board.getBtitle() %>">
    </div>
    <br>
    
    <table class="table">
        <thead>
            <tr>
               
                <th>내 용</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><textarea id = "summernote" name="bcontent" rows="15" cols="100"><%=board.getBcontent()%></textarea></td>
            </tr>
        </tbody>
    </table>
    
        <script>
     	 $('#summernote').summernote({
        placeholder: '내용을 입럭하세요.',
        tabsize: 2,
        height: 500,
        toolbar: [
          ['style', ['style']],
          ['font', ['bold', 'underline', 'clear']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture', 'video']],
          ['view', ['fullscreen', 'codeview', 'help']]
      	  ]
     	 });
    	</script>
  
        <button class="btn btn-primary" type="submit">저장</button>
        <!-- 수정취소 버튼 추가 -->
       <input type="reset" value="취소" onclick="cancleModifyFn()" class="btn btn-primary">
        <button type="button" onclick="cancelModification()" class="btn btn-success">목록</button>
        
    
	</form>

	<script>
    function cancelModification() {
        location.href='cview.jsp?bno=<%=board.getBno()%>';
    }

	</script>
					
			</div>
		</div>
		<!-- 게시판 종료-->

	</section>
	<!-- end qboard section -->

	<!-- footer section -->
	  <%@ include file="footer.jsp" %>
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
	<!-- <script type="text/javascript"
		src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
  </script> -->


</body>
</html>