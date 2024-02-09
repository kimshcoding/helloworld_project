<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="helloworld.vo.Member" %>
<%@ page import="helloworld.vo.Board" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
	request.setCharacterEncoding("UTF-8");

	String directory ="D:\\@kimsh@\\workspace\\helloworld-project\\helloworld-project\\src\\main\\webapp\\helloworldupload";
	int sizeLimit = 100*1024*1024;//100mb 제한
	
	MultipartRequest multi = new MultipartRequest(request
			, directory
			,sizeLimit
			,"UTF-8"
			, new DefaultFileRenamePolicy());
	
	
	Member member = (Member)session.getAttribute("login");
	
	String method = request.getMethod();
	
	if(method.equals("GET") || member == null){
		response.sendRedirect("cboard.jsp");
	}
	
	Board board = new Board();
	board.setBtitle(multi.getParameter("btitle"));
	board.setBcontent(multi.getParameter("bcontent"));
	
	
	
	Connection conn = null;
	PreparedStatement psmt = null;

	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";

	int result =0;
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "INSERT INTO board(btitle, bcontent, mno, type, rdate, mdate) VALUES (?, ?, ?, 'C', NOW(), NOW())"; // C 타입으로 커뮤니티 게시판 분류
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,board.getBtitle());
		psmt.setString(2,board.getBcontent());
		psmt.setInt(3,member.getMno());

		
		
		result = psmt.executeUpdate();
		System.out.println(result);
		
		//현재 삽입된 게시글의 기본키(bno)값을 조회하세요.
		
				if(psmt != null) psmt.close();
				
				sql = "select max(bno) as bno from board";
				psmt = conn.prepareStatement(sql);
				
				ResultSet rs = psmt.executeQuery();
				
				int bno = 0;
				if(rs.next()){
					bno = rs.getInt("bno");
				}
				
				
				
				if(rs != null) rs.close();
				if(psmt != null) psmt.close();
	
	
				//업로드 된 실제 파일명
				String realFileNM = multi.getFilesystemName("uploadFile");
				
				//원본 파일명
				String originFileNM = multi.getOriginalFileName("uploadFile");
			

				sql = "INSERT INTO "
				    + "  boardfile(bno"
				    + "			 , bfrealnm"
				    + "			 , bforiginnm"
				    + "			 , rdate)"
				    + "	VALUES( ?, ?, ?, now())";

				psmt = conn.prepareStatement(sql);

				psmt.setInt(1, bno);
				psmt.setString(2, realFileNM);
				psmt.setString(3, originFileNM);
					
				psmt.executeUpdate();
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
					if(conn != null) conn.close();
					if(psmt != null) psmt.close();
				}
				if(result>0){
					%>
					<script>
						alert("게시글이 등록되었습니다.");
						location.href="cboard.jsp";
					</script>
					<%
				}else{
					%>
					<script>
						alert("게시글이 등록되지 않았습니다.");
						location.href="cwrite.jsp";
					</script>
					<%	
				}
			%>

