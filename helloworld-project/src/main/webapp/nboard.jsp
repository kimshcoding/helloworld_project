<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="helloworld.vo.Member" %>    
<%@ page import="helloworld.vo.Board" %>   
<%@ page import="helloworld.vo.PagingVO" %> 
<%@ page import="java.sql.*" %>
<%

Member member = (Member)session.getAttribute("login");

request.setCharacterEncoding("UTF-8");

String searchType = request.getParameter("searchType");
String searchValue = request.getParameter("searchValue");

String nowPageParam = request.getParameter("nowPage");

int nowPage = 1;
if(nowPageParam != null && !nowPageParam.equals("")){
	nowPage = Integer.parseInt(nowPageParam);
}

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;

String url = "jdbc:mysql://localhost:3306/helloworld";
String user = "bteam";
String pass = "project1";

PagingVO pagingVO = null;

	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url, user, pass);
		System.out.println("연결성공!");
		
		String totalSql = "SELECT count(*) as cnt "
		 		+ "  FROM board b      "
		   		+ " INNER JOIN member m"
		   		+ " ON b.mno = m.mno   "
				+ " WHERE b.delyn = 'N' AND b.type = 'N'";  // N 게시판만 선택!
if(searchType != null){
	if(searchType.equals("title")){
		totalSql += " AND btitle LIKE CONCAT('%',?,'%') ";
	}else if(searchType.equals("writer")){
		totalSql += " AND m.mnickname LIKE CONCAT('%',?,'%')";
	}
}

psmt = conn.prepareStatement(totalSql);
if(searchType != null 
		&&(searchType.equals("title") 
				||searchType.equals("writer"))){
	psmt.setString(1,searchValue);
}
rs = psmt.executeQuery();

int totalCnt = 0;

if(rs.next()){
	totalCnt = rs.getInt("cnt");
}
System.out.println(totalCnt);

if(rs != null) rs.close();
if(psmt != null) psmt.close();

//paging 객체 생성
pagingVO = new PagingVO(nowPage,totalCnt,10);
		
		
		rs =  null;
		String sql = "SELECT bno, btitle, m.mnickname, b.rdate "
		 		+ " FROM board b "
		   		+ " INNER JOIN member m "
		   		+ " ON b.mno = m.mno   "	
				+ " WHERE b.delyn = 'N' AND b.type = 'N'"; // N 게시글만 가져옴!
		
		if(searchType != null){
			if(searchType.equals("title")){
				sql += " AND btitle LIKE CONCAT('%',?,'%') ";
			}else if(searchType.equals("writer")){
				sql += " AND m.mnickname LIKE CONCAT('%',?,'%')";
			}
		}
		sql += " ORDER BY bno desc ";
		sql += " limit ?, ?";
		
		
		psmt = conn.prepareStatement(sql);
		
		if(searchType != null 
				&&(searchType.equals("title") 
						||searchType.equals("writer"))){
			psmt.setString(1,searchValue);
			psmt.setInt(2, pagingVO.getStart()-1);
			psmt.setInt(3, pagingVO.getPerPage());
		}else{
			psmt.setInt(1, pagingVO.getStart()-1);
			psmt.setInt(2, pagingVO.getPerPage());
		}
		
		rs = psmt.executeQuery();
		
%>

<!DOCTYPE html>
<html>

<head>
  <!-- Basic -->
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <!-- Mobile Metas -->
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <!-- Site Metas -->
  <meta name="keywords" content="" />
  <meta name="description" content="" />
  <meta name="author" content="" />

  <title> Hello World </title>

  <!-- bootstrap core css -->
  <link rel="stylesheet" type="text/css" href="css/bootstrap.css" />

  <!-- fonts style -->
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;900&display=swap" rel="stylesheet">

  <!--owl slider stylesheet -->
  <!-- <link rel="stylesheet" type="text/css"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" /> -->

  <!-- font awesome style -->
  <link href="css/font-awesome.min.css" rel="stylesheet" />

  <!-- Custom styles for this template -->
  <link href="css/style.css" rel="stylesheet" />
  
   <!-- 게시판 css -->
  <link rel="stylesheet" type="text/css" href="css/board.css" />
  
</head>

<body class="sub_page">

  <div class="hero_area">

    <div class="hero_bg_box">
      <div class="bg_img_box">
        <img src="images/hero-bg.png" alt="">
      </div>
    </div>
    

    <!-- header section strats -->
<%@ include file="/header.jsp" %>
    <!-- end header section -->
  </div>

  <!-- kboard section -->

  <section class="about_section layout_padding">
    <div class="container  ">
      <div class="heading_container heading_center">
        <h2>
          공지사항 <span>게시판</span>
        </h2>
        <p>
          Hello World의 새소식, 이벤트, 행사 정보를 공유하는 공간입니다.
        </p><br>

		<form name="frm" action="nboard.jsp" method="get">
			<select name="searchType">
				<option value="title"<%if(searchType != null && searchType.equals("title")) out.print("selected"); %>>제목</option>
				<option value="writer"<%if(searchType != null && searchType.equals("writer")) out.print("selected"); %>>작성자</option>
			</select>
			<%-- <input type="text" name="searchValue" value="<%if(searchValue != null) out.print(searchValue); %>"> --%>
			<input type="text" name="searchValue" value="<%if(searchValue == null) out.print(""); %>">
			<button class="btn btn-success">검색</button>
		</form>
		<br>
		
        <!-- 게시판 시작-->
        <table class="table">
          <thead>
            <tr>
              <th scope="col">번호</th>
              <th scope="col">제목</th>
              <th scope="col">작성자</th>
              <th scope="col">등록일</th>
            </tr>
          </thead>
          <tbody>
            <% 
			while(rs.next()){
				int bno = rs.getInt("bno");
				String btitle = rs.getString("btitle");
				String mnickname = rs.getString("mnickname");
				String rdate = rs.getString("rdate");
				%>
					<tr>
						<td><%=bno%></td>
						<td><a href="nview.jsp?bno=<%=bno%>" style="color: pink;"><%=btitle%></a></td>
						<td><%=mnickname%></td>
						<td><%=rdate%></td>
					</tr>
				
		<%
			}
		%>
           
          </tbody>
        </table>
        
<%
	if((member != null) && (member.getGrade() == 'A')){   // 로그인이 안되어 있거나 관리자가 아니면 공지사항 글쓰기 버튼 노출시키지 않음!
%>
		
<button type="button" class="btn btn-primary" onclick="location.href='nwrite.jsp';">글쓰기</button><br><br>
 <%
     }
 %>   
   


		<!-- 페이징 영역 -->
			<div class="paging">
		 	<%
		 		if(pagingVO.getStartPage() > pagingVO.getCntPage()){
		 	%>
		 		<a href="nboard.jsp?nowPage=<%=pagingVO.getStartPage()-1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">이전</a>
		 	<%		
		 		}
		 	
		 		for(int i = pagingVO.getStartPage(); 
		 				i<=pagingVO.getEndPage(); i++){
		 			if(nowPage == i){
 				%>
 				<b><%=i %></b>
 				<%
		 			}else{
		 				if(searchType != null){
				%>
			 	<a href="nboard.jsp?nowPage=<%=i%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=i %></a>
			 	<%		
		 				}else{
 				%>
 			 	<a href="nboard.jsp?nowPage=<%=i%>"><%=i %></a>
 			 	<%	
		 				}
		 			}
		 		}
		 		
		 		if(pagingVO.getEndPage() < pagingVO.getLastPage()){
		 			%>
		 		<a href="nboard.jsp?nowPage=<%=pagingVO.getEndPage()+1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">다음</a>
		 			<%
		 		}
		 	%>
		 </div>


      </div>
      <!-- 게시판 종료-->

    </div>
  </section>

  <!-- end kboard section -->

  <!-- footer section -->
  <%@ include file="/footer.jsp" %>
  <!-- footer section -->

  <!-- jQery -->
  <script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
  
  <!-- popper js -->
  <!-- <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
    integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous">
    </script> -->
    
  <!-- bootstrap js -->
  <script type="text/javascript" src="js/bootstrap.js"></script>
  
  <!-- owl slider -->
  <!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
  </script>
   -->
</body>
</html>
<%		
	
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}
%>
