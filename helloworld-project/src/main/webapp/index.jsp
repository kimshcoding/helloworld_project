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

  <title> Hello World</title>

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


</head>
<body>

  <div class="hero_area">
    <div class="hero_bg_box">
      <div class="bg_img_box">
        <img src="images/hero-bg.png" alt="">
      </div>
    </div>



    <!-- header section strats -->
   <%@ include file="header.jsp" %>
    <!-- end header section -->
    
    
    <!-- slider section -->
    <section class="slider_section ">
      <div id="customCarousel1" class="carousel slide" data-ride="carousel">
        <div class="carousel-inner">
          <div class="carousel-item active">
            <div class="container ">
              <div class="row">
                <div class="col-md-6 ">
                  <div class="detail-box">
                    <h1>
                      지식 공유와 학습 <br>
                    </h1>
                    <h4 style="color: white;">               
                      다른 개발자들의 경험 공유, 튜토리얼, 문서, 블로그 게시물 등을 통해 새로운 기술과 도구에 대한 학습이 가능합니다.<br>
                      개발자들은 서로의 문제에 대한 해결책을 제시하고, 실제 프로젝트에서 발생한 경험을 나누어 주기 때문에 현업에서 유용한 정보를 쉽게 얻을 수 있습니다.
                    </h4>

                  </div>
                </div>
                <div class="col-md-6">
                  <div class="img-box">
                    <img src="images/slider-img.png" alt="">
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="carousel-item ">
            <div class="container ">
              <div class="row">
                <div class="col-md-6 ">
                  <div class="detail-box">
                    <h1>
                      네트워킹과 협업 <br>
                    </h1>
                    <h4 style="color: white;">
                      커뮤니티는 다양한 배경과 경험을 가진 개발자들이 모여있는 장소이므로, 네트워킹 기회를 제공합니다. <br>
                      새로운 친구나 동료 개발자를 만날 수 있으며, 이를 통해 프로젝트 협업이나 새로운 직장 기회를 찾을 수 있습니다.<br>
                      개발자들 간의 협업은 효과적인 문제 해결과 아이디어 교환을 가능케 하며, 다양한 관점에서의 피드백을 받을 수 있습니다.
                    </h4>

                  </div>
                </div>
                <div class="col-md-6">
                  <div class="img-box">
                    <img src="images/slider-img.png" alt="">
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="carousel-item">
            <div class="container ">
              <div class="row">
                <div class="col-md-6 ">
                  <div class="detail-box">
                    <h1>
                      코드 개선과 <br> 오픈 소스 기여 <br>
                    </h1>
                    <h4 style="color: white;">                   
                     개발자들은 오픈 소스 프로젝트에 참여하고 기여함으로써 자신의 실력을 향상시키고, 다른 개발자들과 함께 프로젝트를 개선할 수 있습니다.<br>
                     코드 리뷰를 통해 개선점을 찾고, 버그를 수정하며, 새로운 기능을 제안하고 구현함으로써 실전 경험을 쌓을 수 있습니다. <br>
                     이러한 오픈 소스 기여는 개발자의 포트폴리오를 향상시키고 더 많은 기회를 얻을 수 있도록 도와줍니다.
                    </h4>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="img-box">
                    <img src="images/slider-img.png" alt="">
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <ol class="carousel-indicators">
          <li data-target="#customCarousel1" data-slide-to="0" class="active"></li>
          <li data-target="#customCarousel1" data-slide-to="1"></li>
          <li data-target="#customCarousel1" data-slide-to="2"></li>
        </ol>
      </div>

    </section>
    <!-- end slider section -->
  </div>


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

</body>
</html>