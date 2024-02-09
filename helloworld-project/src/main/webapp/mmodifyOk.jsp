<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
 <%@ page import="java.sql.*" %>  
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="member" class="helloworld.vo.Member" scope="page"/>
<jsp:setProperty property="*" name="member" />

<%
	Connection conn = null;
	PreparedStatement psmt= null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	int result = 0;
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "UPDATE member "
				   + "   SET mpassword = ? "
				   + "     , memail = ? "
				   + "     , mphone = ? "
				   + " WHERE mno = ? ";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,member.getMpassword());
		psmt.setString(2,member.getMemail());
		psmt.setString(3,member.getMphone());
		psmt.setInt(4,member.getMno());
		
		result = psmt.executeUpdate();
		
		
		
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}
	
	if(result>0){
%>
	<script>
		alert("수정이 완료되었습니다.");
		location.href="view.jsp?mno=<%=member.getMno() %>";
	</script>	
<%
	}else{
%>
		<script>
			alert("수정이 완료되지 않았습니다.");
			location.href="view.jsp?mno=<%=member.getMno() %>";
		</script>	
<%		
	}
	
%>