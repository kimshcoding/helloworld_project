<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="helloworld.vo.Member" %>
<%

	Member mlogin = new Member();
	
	Member member = (Member)session.getAttribute("login");

	if(member == null){
%>
	<script>
		alert("잘못된 접근입니다.");
		location.href='nboard.jsp';
	</script>
<%	
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
    <!-- <link rel="stylesheet" type="text/css"
        href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" /> -->

    <!-- font awesome style -->
    <link href="css/font-awesome.min.css" rel="stylesheet" />

    <!-- Custom styles for this template -->
    <link href="css/style.css" rel="stylesheet" />
    
     <!-- 글쓰기 css -->
     <link rel="stylesheet" type="text/css" href="css/write.css" />
    
    
 <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
 <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
 <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>  
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

    <!-- qwrite section -->

    <section class="about_section layout_padding">
        <div class="container  ">
            <div class="heading_container heading_center">
                <h2>
                    공지사항 게시판 <span>글쓰기</span>
                </h2>
                <p>
                    즐거운 글쓰기 시간이 되시길 바랍니다.
                </p><br><br>

                <!-- 글쓰기 시작-->
     <div class="container">
    <form action="nwriteOk.jsp" method="post" name="frm" enctype="multipart/form-data">
        <div>
            <h5>작성자 : <%= member.getMnickname() %></h5><br>
        </div>
       <div class="form-group">
            <label for="title">제 목</label>
            <input type="text" id="title" name="btitle" placeholder="제목을 입력하세요" style="width: 80%;" required>
        </div> 
        
            <label for="summernote">본 문</label>
       <div class="back">
            <textarea id="summernote" name="bcontent" required></textarea>
        
    	<script>
     	 $('#summernote').summernote({
        placeholder: '내용을 입력하세요.',
        tabsize: 2,
        height: 400,
        toolbar: [
          ['style', ['style']],
          ['font', ['bold', 'underline', 'clear']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture', 'video']],
          ['view', ['fullscreen', 'codeview', 'help']]
      	  ]
     	 });
    	</script>
       </div><br>
    
        
        <div>
            <label for="file">첨부파일</label>
            <input type="file" id="file" name="uploadFile" onchange="displayImagePreview(this)">
        </div>
        <div id="image-preview"></div><br>
        <button class="btn btn-primary">등 록</button>
        <button onclick="location.href='nboard.jsp'" class="btn btn-success">목 록</button>
    </form>
</div>


<!-- 이미지 미리보기 기능 -->
<script>
    function displayImagePreview(input) {
        var file = input.files[0];
        if (file) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#image-preview').html('<img src="' + e.target.result + '" alt="uploaded image" style="max-width:100%;height:auto;">');
            };
            reader.readAsDataURL(file);
        }
    }
</script>
            
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
   <!--  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
        integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous">
        </script> -->
        
    <!-- bootstrap js -->
    <script type="text/javascript" src="js/bootstrap.js"></script>
    
    <!-- owl slider -->
    <!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js">
    </script> -->

</body>
</html>