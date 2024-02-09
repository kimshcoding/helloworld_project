<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String rnoParam = request.getParameter("rno");

	int rno =0; 
	if(rnoParam != null && !rnoParam.equals("")){
		rno = Integer.parseInt(rnoParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = " update reply set delyn = 'Y' where rno = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1,rno);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			out.print("SUCCESS");
		}else{
			out.print("FAIL");
		}
		
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt !=  null) psmt.close();
	}
	

%>