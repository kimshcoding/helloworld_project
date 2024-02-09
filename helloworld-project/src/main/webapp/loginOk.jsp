<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="helloworld.vo.Member" %>
<%@ page import="java.sql.*" %>
<%
	
	//1.파라미터 아이디와 패스워드를 얻어온다.
	String mid = request.getParameter("mid");
	String mpassword = request.getParameter("mpassword");
	
	//2.DB에 연결한다.
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	boolean isLogin = false;
	
	Member member = null;
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		//3.연결된 DB에서 아래 sql을 호출한다.
		String sql = "SELECT mid   "
				+"      ,mname "
				+"      ,mno   " 
				+"      ,mnickname "
				+"      ,grade "
				+"      ,quityn "
				+"      ,rdate "
			 	+"  FROM member"
				+" WHERE mid=? "
			 	+"   AND mpassword= ?";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,mid);
		psmt.setString(2,mpassword);
		
		rs = psmt.executeQuery();
		
		//4.가져온 결과가 존재 하는지 확인한다.
		if(rs.next()){
			member = new Member();
			member.setMno(rs.getInt("mno"));
			member.setMid(rs.getString("mid"));
			member.setMname(rs.getString("mname"));
			member.setMnickname(rs.getString("mnickname"));
			member.setGrade(rs.getString("grade").charAt(0));
			member.setQuityn(rs.getString("quityn").charAt(0));
			member.setRdate(rs.getString("rdate"));
			
//			session.setAttribute("login",member);
//			isLogin = true;
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}
	
	if(member == null )
	{
		// 가져온 결과가 존재하지 않음
		%>
		<script>
			alert("아이디와 비밀번호를 확인하세요.");
			location.href="login.jsp";
		</script>
	<%
	}
	
	if( member != null )
	{
		if( member.getQuityn() == 'Y' )
		{
			// 탈퇴 회원
			%>
			<script>
				alert("탈퇴한 계정은 이용할 수 없습니다.");
				location.href="index.jsp";
			</script>
		<%	
		}else if( member.getQuityn() == 'N' )
		{
			// 로그인 처리
			session.setAttribute("login",member);
			%>
			<script>
				alert("로그인 되었습니다");
				location.href="index.jsp";
			</script>
			<%
		}else
		{
			// 오류인 상태
			// member 정보를 받아왔는데, 탈퇴정보가 이상함
			// 작업을 하세요
			%>
			<script>
				alert("계정 인증정보에 오류가 발생했습니다. 다른 계정으로 로그인하세요.")
				location.href="login.jsp";
			</script>
			<%
		}
	}
	
%>