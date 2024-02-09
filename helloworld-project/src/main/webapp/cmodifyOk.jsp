<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="helloworld.vo.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
	request.setCharacterEncoding("UTF-8");

	String method = request.getMethod();
	if(method.equals("GET")){
	%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='cboard.jsp';
		</script>
	<%
	}
	
	// 업로드된 파일이 저장될 디렉토리 경로를 지정합니다. 이 경로는 프로젝트의 실제 파일 시스템 경로입니다.
	String directory = "D:\\@kimsh@\\workspace\\helloworld-project\\helloworld-project\\src\\main\\webapp\\helloworldupload";
	int sizeLimit = 100*1024*1024;//100mb 제한

	MultipartRequest multi = new MultipartRequest(request 	// 클라이언트의 HTTP 요청 객체입니다.
										, directory			// 파일이 저장될 디렉토리 경로입니다.
										, sizeLimit			// 업로드할 파일의 최대 크기 제한입니다.
										, "UTF-8"			// 요청 및 파일 업로드시 사용할 문자 인코딩 방식을 설정합니다.
										, new DefaultFileRenamePolicy()); // 파일명 중복 시 새로운 파일명을 부여하는 정책을 설정합니다. 여기서는 기본 정책을 사용하고 있습니다.
	
	// MultipartRequest 객체는 클라이언트로부터 전송된 HTTP 요청(request)에서 멀티파트 데이터(파일 업로드)를 추출하기 위해 사용됩니다.
	
	
		// 수정할 게시글 bno 와 수정한 게시글 제목과 내용을 가져옴
		Board board = new Board();
		board.setBtitle(multi.getParameter("btitle"));
		board.setBcontent(multi.getParameter("bcontent"));
		
	 	int bno=0;
	 	if(multi.getParameter("bno")!=null && !multi.getParameter("bno").equals("")){
	 		bno= Integer.parseInt(multi.getParameter("bno"));
	 	}
	 	
	 	board.setBno(bno);
	 	System.out.println("bno:"+bno);
	%>

	<%
		BoardFile bf = new BoardFile();
		

		//첨부파일 삭제하기 위해 bfno 가져옴 
		String bfnoParam = multi.getParameter("bfno");
		int bfno=0;
		if(multi.getParameter("bfno")!=null && !multi.getParameter("bfno").equals("")){
			bfno=Integer.parseInt(multi.getParameter("bfno"));
		}
		System.out.println("bfno:"+bfno);
	

	Connection conn = null;
	PreparedStatement psmt= null;
	String url = "jdbc:mysql://localhost:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	
	int result = 0;
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "UPDATE board        "
				   + "   SET btitle   = ? "
				   + "     , bcontent = ? "
				   + "     , mdate = NOW() " //<---- 게시글수정시간
				   + " WHERE bno = ? AND type = 'C'";  //<--- C 게시글 수정!
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, board.getBtitle());
		psmt.setString(2, board.getBcontent());
		psmt.setInt(3, board.getBno());
		
		
		result = psmt.executeUpdate();
		
				//-------------------기존 파일 삭제하기 ----------------------
				if(psmt != null) psmt.close();
				
				 sql = "DELETE FROM boardfile WHERE bfno = ?";
				
				 psmt = conn.prepareStatement(sql);
				 psmt.setInt(1,bfno);
					
				psmt.executeUpdate();
				
		
				//------------------- 새로운 파일 등록하기 ----------------------
				
				if(psmt != null) psmt.close();
				
				
				//업로드 된 실제 파일명
				String realFileNM = multi.getFilesystemName("uploadFile");
				
				//원본 파일명
				String originFileNM = multi.getOriginalFileName("uploadFile");
				
				if(realFileNM != null && originFileNM != null){
					
				
				sql = "INSERT INTO "
					+ "  boardFile(bno"
					+"			 , bfrealnm"
					+"			 , bforiginnm"
					+"			 , rdate)"
					+"	VALUES( ?, ?, ?, now())";
				
				psmt = conn.prepareStatement(sql);
				
				psmt.setInt(1,bno);
				psmt.setString(2,realFileNM);
				psmt.setString(3,originFileNM);
				
				psmt.executeUpdate();		
				
				}
	
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}

	if(result>0){
		%>
		<script>
			alert("수정되었습니다.");
			location.href='cview.jsp?bno=<%=board.getBno()%>';
		</script>
		<%
	}else{
		%>
		<script>
			alert("수정되지 않았습니다.");
			location.href='cview.jsp?bno=<%=board.getBno()%>';
		</script>
		<%
	}
%>
