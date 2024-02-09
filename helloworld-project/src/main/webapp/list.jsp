<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "select * from member";
		psmt = conn.prepareStatement(sql);
		
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
  <link rel="stylesheet" type="text/css"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" />

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

  <!-- list section -->

  <section class="about_section layout_padding">
    <div class="container  ">
      <div class="heading_container heading_center">
       

<h2>회원 목록</h2><br>
		<table width="800">
		<colgroup>
			<col width="10%">
			<col width="20%">
			<col width="20%">
			<col width="20%">
			<col width="30%">
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>아이디</th>
				<th>이름</th>
				<th>닉네임</th>
				<th>가입일</th>
			</tr>
		</thead>
		<tbody>
		<%
			while(rs.next()){
				int mno = rs.getInt("mno");
				String mid = rs.getString("mid");
				String mname = rs.getString("mname");
				String mnickname = rs.getString("mnickname");
				String rdate = rs.getString("rdate");
		%>
			<tr>
				<td><%=mno %></td>
				<td><a href="view.jsp?mno=<%=mno%>"><%=mid %></a></td>
				<td><%=mname %></td>
				<td><%=mnickname %></td>
				<td><%=rdate %></td>
			</tr>
		<%
			}
		%>
		</tbody>
		</table>

      </div>
    </div>
  </section>

  <!-- end list section -->



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
 <!--  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
  </script> -->
  

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
