<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/bootstrap.css" />

    <!-- fonts style -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700;900&display=swap" rel="stylesheet">

    <!--owl slider stylesheet -->
    <link rel="stylesheet" type="text/css"
        href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" />

    <!-- font awesome style -->
    <link href="<%=request.getContextPath()%>/css/font-awesome.min.css" rel="stylesheet" />

    <!-- Custom styles for this template -->
    <link href="<%=request.getContextPath()%>/css/style.css" rel="stylesheet" />
    
    <!-- responsive style -->
   <%--  <link href="<%=request.getContextPath()%>/css/responsive.css" rel="stylesheet" /> --%>

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
    </style>
	
	<script>
		
		/* if(check&&checkIdFlag){
			document.frm.submit();
		} 
			
		
		let checkIdFlag = false;  */
		let checkIdRs = false;
		let checkIdFlag = false;
		let checkNickRs = false; 
		let checkNickFlag = false;
		const korean = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
		
		function checkId(obj){
				let regId = /^[0-9a-zA-Z]{5,19}/g;
				let regRs = regId.test(obj.value)
				let checkRs = obj.parentElement.nextElementSibling;
				if(obj.value == ""){
					checkRs.innerHTML = '필수입력입니다.';
					checkRs.style.color = 'red';
					checkIdRs = false;
					return false;
				}else if(obj.value.length <5 || obj.value.length >18){
					checkRs.innerHTML = '다섯자리 이상 19자리 미만이어야 합니다.';
					checkRs.style.color = 'red';
					checkIdRs = false;
					return false;
				}else if(korean.test(obj.value)){
					checkRs.innerHTML = '영문, 숫자 조합으로만 구성되어야 합니다.';
					checkRs.style.color = 'red';
					checkIdRs = false;
					return false;
				}else{
					checkRs.innerHTML = '아이디 중복확인을 해주세요.';
					checkRs.style.color = 'red';
					checkIdRs = true;
					return true;
				}

			}

		function checkIdFn(obj){
		//아이디 중복확인 함수
			
			let id = document.frm.mid.value;
			let checkRs = obj.parentElement.nextElementSibling;
			
			if(!checkIdRs && obj.value == ""){
				checkRs.innerHTML = '아이디를 입력해주세요.';
				alert("아이디를 입력해주세요.");
				checkRs.style.color = 'red';
				checkIdFlag = false;
			}else{
				$.ajax({
				url : "checkId.jsp",
				type : "get",
				data : {id : id},
				success : function(data){
					//0 :사용가능, 1:사용 불가능
					let result = data.trim();
					if(result == 0){
						checkIdFlag = true;
						
						checkRs.innerHTML = '사용 가능합니다.';
						checkRs.style.color = 'green';
					}else{
						checkIdFlag = false;
						
						checkRs.innerHTML = '이미 존재하는 아이디입니다.';
						checkRs.style.color = 'red';
					}
				},error:function(){
					console.log("error");
					checkIdFlag = false;
				}
				});
			
			}
			
	
		} 
		
		function checkPass(obj){
			let regId = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,15}$/;  /* /^[a-zA-Z0-9](?=,*[a-zA-Z])(?=,*[0-9])/g; */
			let regRs = regId.test(obj.value)
			let checkRs = obj.parentElement.nextElementSibling;
			if(obj.value == ""){
				checkRs.innerHTML = '필수입력입니다.';
				checkRs.style.color = 'red';
				return false;
			}else if(obj.value.length < 6){
				checkRs.innerHTML = '여섯 자리 이상 입력하세요.';
				checkRs.style.color = 'red';
				return false;
			}else if(!regRs){
				checkRs.innerHTML = '숫자, 영문, 특수문자 조합만 입력 가능합니다.';
				checkRs.style.color = 'red';
				return false;
			}else{
				checkRs.innerHTML = '사용가능합니다.';
				checkRs.style.color = 'green';
				return true;
			}
		}

		function checkPassRe(obj){
			let confirmPass = document.getElementById("mpassword").value == obj.value;
			let checkRs = obj.parentElement.nextElementSibling;
			if(obj.value == ""){
				checkRs.innerHTML = '필수입력입니다.';
				checkRs.style.color = 'red';
				return false;
			}else if(!confirmPass){
				checkRs.innerHTML = '비밀번호가 일치하지 않습니다.';
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
		
		
		function checkName(obj){
			let regId = /[^가-힣]/g;
			let regRs = regId.test(obj.value)
			let checkRs = obj.parentElement.nextElementSibling;
			if(obj.value == ""){
				checkRs.innerHTML = '필수입력입니다.';
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
				checkRs.innerHTML = '유효한 휴대폰번호가 아닙니다.';
				checkRs.style.color = 'red';
				return false;
			}else{
				checkRs.innerHTML = '사용가능합니다.';
				checkRs.style.color = 'green';
				return true;
			}
		}

		
		function validation(){
			if(checkIdRs & checkIdFlag & checkPass(document.frm.mpassword) & checkPassRe(document.frm.mpasswordre)
					& checkName(document.frm.mname) & checkNickRs & checkNickFlag
					& checkEmail(document.frm.memail) 
					& checkPhone(document.frm.mphone)){
				return true;
			}else{
				alert("모든 요건을 충족해야합니다.");
				return false;
			}
			
			
		}
		
		
		
		function resetFn(){
			checkIdFlag = false;
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

    <!-- qboard section -->

    <section class="about_section layout_padding">
        <div class="container">
            <div class="heading_container heading_center">
                <h2>
                    Hello World에 오신 것을 <span>환영합니다.</span>
                </h2>
                <p>
                    Hello World는 개발자를 위한 지식 공유 플랫폼입니다.
                </p><br><br>

                <!-- 회원가입 시작 -->
                <form name="frm" action="joinOk.jsp" method="post" class="col-md-4 offset-md-0" onsubmit="return validation();">
                    <div class="form-group">
                         <label for="mid">아이디</label>
        			<div class="input-group">
            		<input type="text" id="mid" name="mid" placeholder="아이디를 입력하세요" class="form-control" required onblur="checkId(this)">
            		<button type="button" class="btn btn-primary" onclick="checkIdFn(this)">중복확인</button>
        		</div>
                    <div class="checkRs"></div>
                    </div>
                    
                    
                    
                    <div class="form-group">
                        <label for="mpassword">비밀번호</label>
                        <input type="password" id="mpassword" name="mpassword" placeholder="사용할 비밀번호를 입력하세요."
                            class="form-control" required onblur="checkPass(this)">
                    </div>
                    
                    <div class="checkRs"></div>
                    
                    <div class="form-group">
                        <label for="mpassword">비밀번호 재입력</label>
                        <input type="password" id="mpasswordre" name="mpasswordre" placeholder="비밀번호를 다시 입력하세요."
                            class="form-control" required onblur="checkPassRe(this)">
                    </div>
                    
                    <div class="checkRs"></div>
                    
                    <div class="form-group">
                        <label for="mnickname">닉네임</label>
                        <div class="input-group">
                        <input type="text" id="mnickname" name="mnickname" placeholder="사용할 닉네임을 입력하세요."
                            class="form-control" required onblur="checkNick(this)">
                        <button type="button" class="btn btn-primary onclick=" onclick="checkNickFn(this)">중복확인</button>
                       </div>   
                    <div class="checkRs"></div>
                    </div>
                    
                    
                    <div class="form-group">
                        <label for="memail">이메일</label>
                        <input type="email" id="memail" name="memail" placeholder="example@example.com"
                            class="form-control" required onblur="checkEmail(this)">
                    </div>
                    
                    <div class="checkRs"></div>
                    
                    
                    <div class="form-group">
                        <label for="mname">성명</label>
                        <input type="text" id="mname" name="mname" placeholder="홍길동" class="form-control"
                            required onblur="checkName(this)">
                    </div>
                    
                    <div class="checkRs"></div>
                    
                    <div class="form-group">
                        <label for="mphone">연락처</label>
                        <input type="text" id="mphone" name="mphone" placeholder="010-1111-1111"
                            class="form-control" required onblur="checkPhone(this)">
                    </div>
                    
                    <div class="checkRs"></div>
                    
                    <button type="submit" class="btn btn-primary">가입하기</button>
                </form>
                <!-- 회원가입 종료-->
            </div>
        </div>
    </section>

    <!-- end qboard section -->



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

</html>