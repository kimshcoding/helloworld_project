<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%

	String method = request.getMethod();
	if(method.equals("GET")){
	%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='kboard.jsp';
		</script>
	<%
	}
	
	String bnoParam = request.getParameter("bno");
	
	int bno=0;
	
	if(bnoParam!= null && !bnoParam.equals("")){
		bno = Integer.parseInt(bnoParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	int result =0;
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "UPDATE board      "
				   + "   SET delyn = 'Y'"
				   + " WHERE bno = ? AND type = 'K'";  //K 게시글만 삭제!
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1, bno);
		
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
			alert("삭제 되었습니다.");
			location.href="kboard.jsp";
		</script>
		<%
	}else{
		%>
		<script>
			alert("삭제되지 않았습니다.");
			location.href="kboard.jsp";
		</script>
		<%	
	}
%>
    