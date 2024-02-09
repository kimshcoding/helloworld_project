<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="helloworld.vo.Member.*" %> 
<%@ page import="java.sql.*" %>
<%
	Member member = (Member) session.getAttribute("login");
	String mnoParam = request.getParameter("mno");

	int mno=0;
	
	if(mnoParam != null && !mnoParam.equals("")){
		mno = Integer.parseInt(mnoParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://192.168.0.88:3306/helloworld";
	String user = "bteam";
	String pass = "project1";
	
	
	int mno2 = 0;
	String mid = "";
	String mpassword = "";
	String mname = "";
	String memail = "";
	String mphone = "";
	String mnickname = "";
	String rdate = "";
	

	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "SELECT * FROM member WHERE mno = ?";
		psmt = conn.prepareStatement(sql);
		
		psmt.setInt(1,mno);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			mno2 = rs.getInt("mno");
			mid = rs.getString("mid");
			mname = rs.getString("mname");
			memail = rs.getString("memail");
			mpassword = rs.getString("mpassword");
			mphone = rs.getString("mphone");
			mnickname = rs.getString("mnickname");
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
    <link rel="shortcut icon" href="images/favicon.png" type="">

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
    <!-- responsive style -->
    <link href="css/responsive.css" rel="stylesheet" />

    <style>
        tr:nth-child(even) {
            background-color: #2e2649;
        }

        tr:nth-child(odd) {
            background-color: #483b78;
        }

        th {
            background-color: #342F44;
            color: white;
        }

        .noBorder {
            border: none !important;
            color: white;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        input,
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
    </style>
    
    <script>
	    let checkNickRs = false; 
		let checkNickFlag = false;	
    	
    
	    function checkPass(obj){
			let regId = /[^0-9a-zA-Z]/g;
			let regRs = regId.test(obj.value)
			let checkRs = obj.parentElement.nextElementSibling;
			if(obj.value == ""){
				checkRs.innerHTML = '필수입력입니다.';
				checkRs.style.color = 'red';
				return false;
			}else if(!regRs){
				checkRs.innerHTML = '숫자,영문,특수문자 조합만 입력 가능합니다.';
				checkRs.style.color = 'red';
				return false;
			}else if(obj.value.length < 6){
				checkRs.innerHTML = '여섯 자리 이상 입력하세요.';
				checkRs.style.color = 'red';
				return false;
			}else{
				checkRs.innerHTML = '사용가능합니다.';
				checkRs.style.color = 'green';
				return true;
			}
		}
	    
	    function checkEmail(obj){
	    	let regId = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
			let regRs = regId.test(obj.value)
	    	let checkRs = obj.parentElement.nextElementSibling;
			if(obj.value == ""){
				checkRs.innerHTML = '필수입력입니다.';
				checkRs.style.color = 'red';
				return false;
			}else if(!regRs){
				checkRs.innerHTML = '유효한 이메일 형식이 아닙니다.';
				checkRs.style.color = 'red';
				return false;
			}else{
				checkRs.innerHTML = '사용가능합니다.';
				checkRs.style.color = 'green';
				return true;
			}
		}
	    
	    function checkPhone(obj){
			let regId = /[^0-9]/g;
			let regRs = regId.test(obj.value)
			let checkRs = obj.parentElement.nextElementSibling;
			if(obj.value == ""){
				checkRs.innerHTML = '필수입력입니다.';
				checkRs.style.color = 'red';
				return false;
			}else if(obj.value.length < 13 || obj.value.length > 13){
				checkRs.innerHTML = '유효한 휴대폰번호가 이닙니다.';
				checkRs.style.color = 'red';
				return false;
			}else{
				checkRs.innerHTML = '사용가능합니다.';
				checkRs.style.color = 'green';
				return true;
			}
		}
	    
	    function checkNick(obj){
			let checkRs = obj.parentElement.nextElementSibling;
			if(obj.value == ""){
				checkRs.innerHTML = '필수입력입니다.';
				checkRs.style.color = 'red';
				checkNickRs = false;
				return false;
			}else{
				checkRs.innerHTML = '닉네임 중복확인을 해주세요.';
				checkRs.style.color = 'red';
				checkNickRs = true;
				return true;
			}
		}
		

		function checkNickFn(obj){
			//닉네임 중복확인 함수
			
			let nickname = document.frm.mnickname.value;
			let checkRs = obj.parentElement.nextElementSibling;
			
			if(!checkNickRs){
				checkRs.innerHTML = '닉네임을 입력하세요.';
				checkRs.style.color = 'red';
				checkNickFlag = false;
				return false;
			}else{
				$.ajax({
					url : "checkNickname.jsp",
					type : "get",
					data : {nickname : nickname},
					success : function(data){
						//0 :사용가능, 1:사용 불가능
						let result = data.trim();
						if(result == 0){
							checkNickFlag = true;
							checkRs.innerHTML = '사용 가능합니다.';
							checkRs.style.color = 'green';
						}else{
							checkNickFlag = false;
							checkRs.innerHTML = '이미 존재하는 닉네임입니다.';
							checkRs.style.color = 'red';
						}
					},error:function(){
						console.log("error");
						checkNickFlag = false;
					}
				});
			}
				
			
		}
	    
	    function validation(){
			if(checkPass(document.frm.mpassword) & checkEmail(document.frm.memail) 
				& checkPhone(document.frm.mphone) & checkNickRs & checkNickFlag){
				return true;
			}else{
				alert("입력란을 모두 작성하세요.");
				return false;
			}
			
			
		}
	    
		function resetFn(){
	    	checkNickFlag = false;
	    }  
    </script>
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

    <!-- member modify section -->

   <section class="about_section layout_padding">
        <div class="container  ">
            <div class="heading_container heading_center">
                <h2>
                    회원정보 <span>수정</span>
                </h2>
                <p>
                    회원정보를 수정하세요.
                </p><br><br>

                <!-- 수정 시작-->
                <form name="frm" action="mmodifyOk.jsp" method="post" onsubmit="return validation();">
    				<input type="hidden" name="mno" value="<%=mno%>">

						<div class="container text-center">
						 <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4">
						  
						  	<div class="col">
						      <h5>아이디  </h5>
						      <%=member.getMid() %>
						    </div>
						    <div class="col">
						      <h5>성명  </h5>
						      <%=member.getMname()%>
						    </div>
						     
						  </div>
						</div>
						<br>
						
						<table class="table">
						       <thead>
						           <tr>
						               <th>비밀번호</th>
						           </tr>
						       </thead>
						       <tbody>
						           <tr>
						               <td>
						               	<div class="form-group">
						               	<input type="password" id="mpassword" name="mpassword" placeholder="사용할 비밀번호를 입력하세요" onblur="checkPass(this)">
						               	</div>
						               	<div class="checkRs"></div>
						               </td>
						           </tr>
						       </tbody>
						    </table>
						    <table class="table">
						       <thead>
						           <tr>
						               <th>이메일</th>
						           </tr>
						       </thead>
						       <tbody>
						           <tr>
						               <td>
						               	<div class="form-group">
						               	<input type="email" id="memail" name="memail" placeholder="<%=memail %>" onblur="checkEmail(this)">
						               	</div>
						               	<div class="checkRs"></div>
						               </td>
						           </tr>
						       </tbody>
						    </table>
						    <table class="table">
						       <thead>
						           <tr>
						               <th>연락처</th>
						           </tr>
						       </thead>
						       <tbody>
						           <tr>
						               <td>
						               	 <div class="form-group">
						               	 <input type="text" id="mphone" name="mphone" placeholder="<%=mphone %>" onblur="checkPhone(this)">
						               	 </div>
						               	 <div class="checkRs"></div>
						               </td>
						           </tr>
						       </tbody>
						    </table>
						    <table class="table">
						       <thead>
						           <tr>
						               <th>닉네임</th>
						           </tr>
						       </thead>
						       <tbody>
						           <tr>
						               <td>
						               	 <div class="form-group">
						               	 <input type="text" id="mnickname" name="mnickname" placeholder="<%=mnickname %>" onblur="checkNick(this)">
						               	 <button type="button" class="btn btn-primary onclick=" onclick="checkNickFn(this)">중복확인</button>
						               	 </div>
						               	 <div class="checkRs"></div>
						               </td>
						           </tr>
						       </tbody>
						    </table>
						    
						    <div class="btn-group">
						        <button class="btn btn-primary" type="submit">저장</button>
						        <button type="button" onclick="location.href='view.jsp?mno=<%=member.getMno() %>'" class="btn btn-success">목록</button>
						    </div>
				 </form>
						                
				 <!-- 글쓰기 종료-->
				</div>
		</div>
    </section>

    <!-- end qwrite section -->



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
