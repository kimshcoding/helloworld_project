<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="helloworld.vo.Member" %> 
<%
	
	Member member = (Member)session.getAttribute("login");

	String mnoParam = request.getParameter("mno");

	int mno=0;

	if(mnoParam != null && !mnoParam.equals("")){
		mno = Integer.parseInt(mnoParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	String mid = "";
	String mpassword = "";
	String mname = "";
	String memail = "";
	String mphone = "";
	String rdate = "";
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "SELECT mid, mpassword, mname, memail, mphone, rdate FROM member WHERE mno = ?";
		psmt = conn.prepareStatement(sql);
		
		psmt.setInt(1,mno);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			mid = rs.getString("mid");
			mpassword = rs.getString("mpassword");
			mname = rs.getString("mname");
			memail = rs.getString("memail");
			mphone = rs.getString("mphone");
			rdate = rs.getString("rdate");
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}
	
	

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
       <%@ include file="header.jsp" %>
        <!-- end header section -->
    </div>

   

     <!------- 게시판 시작 ------->
    <section class="about_section layout_padding">
        <div class="container  ">
            <div class="heading_container heading_center">
                <h2>
                    회원 <span>상세보기</span>
                </h2>
                <p>

                </p><br>

                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">아이디</th>
                            <th scope="col">비밀번호</th>
                            <th scope="col">이름</th>
                            <th scope="col">이메일</th>
                            <th scope="col">연락처</th>
                            <th scope="col">가입일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="noBorder"><%=mid %></td>
                            <td class="noBorder"><%=mpassword %></td>
                            <td class="noBorder"><%=mname %></td>
                            <td class="noBorder"><%=memail %></td>
                            <td class="noBorder"><%=mphone %></td>
                            <td class="noBorder"><%=rdate %></td>
                        </tr>
                    </tbody>
                </table>
                <div class="d-grid gap-2 d-md-block">
                    <button type="button" class="btn btn-primary" onclick="location.href='mmodify.jsp?mno=<%=memberHeader.getMno()%>'">수정</button>
                    <button type="button" class="btn btn-primary" onclick="document.frm.submit();">탈퇴</button>
                    <%
						if((member != null) && (member.getGrade() == 'A')){  // 관리자에게만 목록 버튼 노출
              		%>
                   
                    <button type="button" class="btn btn-success" onclick="location.href='list.jsp';">회원 목록</button>
                    <%
						}
			 		%>
                    
                    
                    <form name="frm" action="mdelete.jsp" method="post">
						<input type="hidden" name="mno" value="<%= mno%>">
					</form>
                </div>

            </div>
        </div>
    </section>
     <!-- 게시판 종료-->


    <!-- footer section -->
    <%@ include file="footer.jsp" %>
    <!-- footer section -->

    <!-- jQery -->
    <script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
    <!-- popper js -->
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
        integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous">
        </script>
    <!-- bootstrap js -->
    <script type="text/javascript" src="js/bootstrap.js"></script>
    <!-- owl slider -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
    </script>
    <!-- custom js -->
    <script type="text/javascript" src="js/custom.js"></script>
    <!-- Google Map -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCh39n5U-4IoWpsVGUHWdqB6puEkhRLdmI&callback=myMap">
    </script>
    <!-- End Google Map -->

</body>

</html>