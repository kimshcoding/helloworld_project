<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="helloworld.vo.Member" %>
<%
	Member memberHeader = (Member)session.getAttribute("login");
%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
 <header class="header_section">
	  <div class="container-fluid">
        <nav class="navbar navbar-expand-lg custom_nav-container ">
          <a class="navbar-brand" href="index.jsp">
            <span>
              Hello World
            </span>
          </a>

          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class=""> </span>
          </button>

          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav  ">
              <li class="nav-item active">
                <a class="nav-link" href="index.jsp">Home</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="qboard.jsp">Q & A</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="kboard.jsp">지  식</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="cboard.jsp">커뮤니티</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="nboard.jsp">공지사항</a>
              </li>
               <%
				if((memberHeader != null) && (memberHeader.getGrade() == 'N')){
			  %>
              <li class="nav-item">
                <a class="nav-link" href="view.jsp?mno=<%=memberHeader.getMno() %>">마이 페이지</a>
              </li>
              <%
				}
				
				if((memberHeader != null) && (memberHeader.getGrade() == 'A')){
              %>
              <li class="nav-item">
                <a class="nav-link" href="list.jsp">회원 정보</a>
              </li>
              <%
				}
               
              	if(memberHeader == null){
			  %>
              <li class="nav-item">
                <a class="nav-link" href="login.jsp"> <i class="fa fa-user" aria-hidden="true"></i> 로그인</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="join.jsp"> <i class="fa fa-user" aria-hidden="true"></i> 회원가입</a>
              </li>
			  <%
				}else{
			  %>
			  <li class="nav-item">
                <a class="nav-link"> <i class="fa fa-user" aria-hidden="true"></i> <%=memberHeader.getMnickname() %> 님 환영합니다.</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="logOut.jsp"> <i class="fa fa-user" aria-hidden="true"></i> 로그아웃</a>
              </li>
			  <%
				}
			  %>
            </ul>
          </div>
        </nav>
      </div>		
</header>
</body>
</html>


