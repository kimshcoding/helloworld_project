<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="helloworld.vo.Member" %>
<%@ page import="java.sql.*" %>
<%
    // 요청으로부터 받은 문자열을 UTF-8로 인코딩
    request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="reply" class="helloworld.vo.Reply" />
<jsp:setProperty name="reply" property="*" />
<%
    // 세션에서 현재 로그인한 회원 정보를 가져옴
    Member member = (Member)session.getAttribute("login");

    if(member != null){
        // 현재 로그인한 회원의 회원번호를 댓글 객체에 설정
        reply.setMno(member.getMno());
        
        Connection conn = null;
        PreparedStatement psmt= null;
        // 데이터베이스 연결 정보 설정
        String url = "jdbc:mysql://localhost:3306/helloworld";
        String user = "bteam";
        String pass = "project1";
        
        try{
            // JDBC 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 데이터베이스 연결
            conn = DriverManager.getConnection(url, user, pass);
            
            // 댓글 등록 SQL 쿼리
            String sql  = "INSERT INTO reply( "
                        + "   bno "
                        + " , mno "
                        + " , rcontent "
                        + " , mdate " // 댓글 수정 시간을 현재 시간으로 설정
                        + " , rdate ) VALUES( "
                        + "   ?"
                        + " , ?"
                        + " , ?"
                        + " , now()" // 현재 시간을 가져와 댓글의 작성 시간으로 설정
                        + " , now()) ";
            
            // PreparedStatement를 생성하고 SQL 쿼리에 값을 설정
            psmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            psmt.setInt(1, reply.getBno());
            psmt.setInt(2, reply.getMno());
            psmt.setString(3, reply.getRcontent());
            
            // SQL 실행 결과를 확인
            int result = psmt.executeUpdate();
            
            if(result > 0 ){
                // 댓글 등록 성공
                
                // PreparedStatement 닫기
                if(psmt != null) psmt.close();
                
                // 현재 등록된 댓글의 rno와 rdate를 가져오기 위한 SQL 쿼리
                sql = "SELECT rno, rdate FROM reply WHERE rno = LAST_INSERT_ID()";
                
                // PreparedStatement 생성
                psmt = conn.prepareStatement(sql);
                
                // SQL 실행 결과를 ResultSet으로 받음
                ResultSet rs = psmt.executeQuery();
                
                // 댓글 번호와 작성 시간을 저장할 변수 초기화
                int rno = 0;
                String rdate = "";
                
                // ResultSet에서 데이터 읽기
                if(rs.next()){
                    rno = rs.getInt("rno");
                    rdate = rs.getString("rdate");
                }
                
                // ResultSet 닫기
                if(rs != null) rs.close();
    %>
                <!-- 댓글 정보를 화면에 출력 -->
                <div class="replyRow">
                   <span style="color: yellow; font-weight: bold; text-align: left;"><%= member.getMnickname() %></span> 
                    <span style="color: orange; text-align: left;">
                        <%= rdate %> <!-- 댓글 작성 시간을 표시 -->
                    </span><br>
                   
                    <span style="text-align: left;">
                        <%= reply.getRcontent() %>
                    </span>
                    
                    <span style="text-align: left;">
                        <!-- 수정 및 삭제 버튼 -->
                        <button onclick="modifyFn(this, <%= rno %>)" class='btn btn-outline-primary'>수정</button>
                        <button onclick="replyDelFn(<%= rno %>, this)" class='btn btn-outline-primary'>삭제</button>
                    </span>
                <hr>
                <br>
                </div>
                
                
                
                
    <%
            } else {
                // 댓글 등록 실패
                out.print("FAIL");
            }
            
        } catch(Exception e){
            // 예외 발생 시 예외 정보 출력
            e.printStackTrace();
        } finally{
            // 데이터베이스 연결 해제
            if(conn != null) conn.close();
            if(psmt != null) psmt.close();
        }
    } else {
        // 로그인한 회원이 없을 경우
        out.print("FAIL");
    }
%>
