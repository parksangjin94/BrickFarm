<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html class="no-js" lang="en">
  <head>
    <meta charset="UTF-8" />
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c64e680ac9425e2fedc14f0b4adece37&libraries=services"></script>
    <script src="/resources/user/js/psj/searchAddress.js" type="text/javascript"></script>
    <link href="/resources/user/images/logo/logo-1.png" rel="shortcut icon" />
    <title>Brick Farm</title>
    <!--====== Google Font ======-->
<link
	href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,700,800"
	rel="stylesheet">

<!--====== Vendor Css ======-->
<link rel="stylesheet" href="/resources/user/css/vendor.css">

<!--====== Utility-Spacing ======-->
<link rel="stylesheet" href="/resources/user/css/utility.css">

<!--====== App ======-->
<link rel="stylesheet" href="/resources/user/css/app.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

<script type="text/javascript">

$(function() { 
	console.log("sss")
$("#goPopup-address").on("click", function () {
	searchAddress();
  });
$("#goPopup-zip-code").on("click", function () {
	searchAddress();
});
})


</script>

</head>
  
  <body class="config">
  	<c:set var="contextPath" value="<%=request.getContextPath()%>" />
	<jsp:include page="../header.jsp"></jsp:include>
    <!--====== Main App ======-->
    <div id="app">


  <!--====== App Content ======-->
        <div class="app-content">

            <!--====== Section 1 ======-->
            <div class="u-s-p-y-60">

                <!--====== Section Content ======-->
                <div class="section__content">
                    <div class="container">
                        <div class="breadcrumb">
                            <div class="breadcrumb__wrap">
                                <ul class="breadcrumb__list">
                                    <li class="has-separator"><a href="/">Home</a></li>
                                    <li class="has-separator"><a href="profileinfo">마이페이지</a></li>
                                    <li class="has-separator"><a href="addresslist">배송지 관리</a></li>
                                    <li class="is-marked"><a>배송지 등록</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--====== End - Section 1 ======-->


            <!--====== Section 2 ======-->
            <div class="u-s-p-b-60">

                <!--====== Section Content ======-->
                <div class="section__content">
                    <div class="dash">
                        <div class="container">
                            <div class="row">
                                <div class="col-lg-3 col-md-12">

                                    <!--====== Dashboard Features ======-->
                                <jsp:include page="./dashBoard.jsp"/>
                                    <!--====== End - Dashboard Features ======-->
                                </div>
                                <div class="col-lg-9 col-md-12">
                                    <div class="dash__box dash__box--shadow dash__box--radius dash__box--bg-white" style="display: flex;">
                                        
                                        <div class="dash__pad-2" style="width: 50%">
                                            <h1 class="dash__h1 u-s-m-b-14">신규 배송지</h1>

                                            <!-- <span class="dash__text u-s-m-b-30">We need an address where we could deliver products.</span>  -->
                                            <form class="dash-address-manipulation" name="completeForm" action="/mypage/addaddresslist" method="post">
                                                <div class="gl-inline" >
                                                    	<div class="u-s-m-b-15">

                                                        <label class="gl-label" for="address-name">배송지명 (선택)</label>

                                                        <input class="input-text input-text--primary-style" type="text" name="address_name" id="address_name" >
                                                        </div>
                                                 </div>  
                                                 		
                                                <div class="gl-inline" >
                                                    <div class="u-s-m-b-15">
                                                        <label class="gl-label" for="address-fname">수령인*</label>

                                                        <input class="input-text input-text--primary-style" type="text" id="address-member-name" name="recipient" required="required"></div>
                                                </div>
                                                <div class="gl-inline" >
                                                    <div class="u-s-m-b-15">

                                                        <label class="gl-label" for="address-country">휴대전화*</label>
														<div style="display: flex">
                                                        <input name="mobile1" class="input-text input-text--primary-style" type="text" id="address-phoneNumber" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" value maxlength="3" required="required">
                                                        <span>&nbsp-&nbsp</span>
                                                        <input name="mobile2" class="input-text input-text--primary-style" type="text" id="address-phoneNumber" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" value maxlength="4" required="required">
                                                        <span>&nbsp-&nbsp</span>
                                                        <input name="mobile3" class="input-text input-text--primary-style" type="text" id="address-phoneNumber" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" value maxlength="4" required="required">
                                                        </div>
                                                    </div>
                                                    
                                                </div>
                                                
                                                <div class="gl-inline" >
                                                    <div class="u-s-m-b-15">

                                                        <label id="goPopup-zip-code" class="gl-label" for="postcode">우편번호* <i class="btn--icon fas fa-search"></i>
                                                        

                                                        <input class="input-text input-text--primary-style" type="text" id="postcode"
							                              name="recipient_zip_code"
							                              data-bill="" required="required">
                                                        </label>
                                                        
                                                     </div>
                                                        
                                                </div>
                                                
                                                
                                                <div class="gl-inline" >
                                                    <div class="u-s-m-b-15" id="address_div" hidden="true">

                                                        <label for="address" class="gl-label">배송지 주소*
                                                        

                                                        <input class="input-text input-text--primary-style" id="address" data-bill=""
                              							name="recipient_address" required="required" readonly="readonly">
                                                        </label>
                                                        
                                                        </div>
                                                        
                                                        
                                                </div>
                                                
                                                <div class="gl-inline" >
                                                    <div class="u-s-m-b-15" id="detail_address_div" hidden="true">

                                                        <label for="detail_address" class="gl-label" >상세 주소*</i>
                                                        

                                                        <input class="input-text input-text--primary-style" id="detail_address" data-bill=""
                              							name="recipient_detail_address" required="required">
                                                        </label>
                                                        
                                                        </div>
                                                        
                                                        
                                                </div>
                                                
                                                
                                           
                                                        <div class="u-s-m-b-10">
                                                           <div class="check-box">
								                            <input type="checkbox" id="is-default" name="is-default" />
								                            <div class="check-box__state check-box__state--primary">
								                              <label class="check-box__label" for="get-address">기본 배송지 설정</label>
								                            </div>
								                          </div>
                                                        </div>
                                                
												<div class="gl-inline" style=" display: flex; justify-content: space-between;">
                                                <button class="btn btn--e-brand-b-2" type="submit">등록</button>
                                                <button class="btn btn--e-transparent-brand-b-2" type="button" onclick="history.back()">취소</button>
                                                </div>
                                            </form>
                                        </div>
                                        
                                        <div class="dash__pad-2" style="width: 50%">
                                        	<div id="map" style="width:100%;height:440px;margin-top:60px;display:none;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--====== End - Section Content ======-->
            </div>
            <!--====== End - Section 2 ======-->
        </div>
        <!--====== End - App Content ======-->

      <!--====== Modal Section ======-->

     
      <!--====== End - Modal Section ======-->
    </div>
    <!--====== End - Main App ======-->

	


    <!--====== Google Analytics: change UA-XXXXX-Y to be your site's ID ======-->
    <script>
      window.ga = function () {
        ga.q.push(arguments);
      };
      ga.q = [];
      ga.l = +new Date();
      ga("create", "UA-XXXXX-Y", "auto");
      ga("send", "pageview");
    </script>
    <script
      src="https://www.google-analytics.com/analytics.js"
      async
      defer
    ></script>

	<!--====== Vendor Js ======-->
	<script src="/resources/user/js/vendor.js"></script>

	<!--====== jQuery Shopnav plugin ======-->
	<script src="/resources/user/js/jquery.shopnav.js"></script>

	<!--====== App ======-->
	<script src="/resources/user/js/app.js"></script>
	<script src="/resources/user/js/psj/kakaoMap.js" type="text/javascript"></script>

    <jsp:include page="../footer.jsp"></jsp:include>
  </body>
</html>
