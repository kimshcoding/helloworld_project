<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="member" class="helloworld.vo.Member" /> <!-- Member member = new Member(); -->
<jsp:setProperty name="member" property="*" />
<%	
	Connection conn = null;
	PreparedStatement psmt= null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	int insertRow =0;
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		System.out.println("연결성공!");
		
		String sql = "INSERT INTO member(mid,mpassword,mnickname,memail,mname,mphone,rdate)"
				   + "VALUES (?,?,?,?,?,?,now())";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, member.getMid());
		psmt.setString(2, member.getMpassword());
		psmt.setString(3, member.getMnickname());
		psmt.setString(4, member.getMemail());
		psmt.setString(5, member.getMname());
		psmt.setString(6, member.getMphone());
		
		
		
		insertRow = psmt.executeUpdate();
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}
	
	if(insertRow>0){
	%>
		<script>
			alert("회원가입되었습니다.로그인을 시도하세요.");
			location.href="index.jsp";
		</script>
		
	<%	
	}else{
		%>
		<script>
			alert("회원가입에 실패했습니다.다시 시도하세요.");
			location.href="join.jsp";
		</script>
		
		<%
	}
	
	
	
	
%>