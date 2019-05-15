<%@page import="game.model.domain.Member"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@include file="/client/inc/style.jsp" %>
<%
	Member member=(Member)session.getAttribute("member");
%>
<script>
$(function(){
	getEventList();
	
	$("#searchGame").keydown(function(key) {
		if (key.keyCode == 13) {
			if($("#searchGame").val()==""){
				alert("검색하고 싶은 게임 이름을 입력해주세요");
				return;
			}
			searchGame();
		}
	});
})
function searchGame(){
	$.ajax({
		url:"/rest/client/game/search",
		type:"get",
		data:{
			game_name:$("#searchGame").val()
		},
		success:function(result){
			if(result==0){
				alert("일치하는 정보가 없습니다");
				return;
			}
			location.href="/client/game/single.jsp?game_id="+result.game_id;
		}
	});
}
function getEventList(){
	$.ajax({
		url:"/rest/client/events",
		type:"get",
		success:function(result){
			if(result.length!=0){
				$("#menu-event").prop("href", "/client/event/index.jsp?event_id="+result[0].event_id);
			}
		}		
	});	
}
</script>
<div class="site-header">
	<div class="container">
		<a href=" /client/main/index.jsp" id="branding"> <img
			src="/images/logo.png" class="logo">
			<div class="logo-text">
				<h1 class="site-title">게임 상점</h1>
			</div>
		</a>
		<!-- #branding -->
		<div class="right-section pull-right" style="float: right">
			<a href="/client/pay/cart.jsp" class="cart"><i class="icon-cart"></i>장바구니</a>
			<%if(member==null){ %>
			<a href="/client/login/index.jsp">로그인/회원가입</a>
			<%}else{ %>
			<a><%=member.getNick() %>님 환영합니다</a>
			<a href="/client/login/logout.jsp">로그아웃</a>
			<%} %>
		</div>
		<!-- .right-section -->
		<div class="main-navigation">
			<button class="toggle-menu">
				<i class="fa fa-bars"></i>
			</button>
			<ul class="menu">
				<li class="menu-item home current-menu-item">
				<a href="/client/main/index.jsp"><i class="icon-home"></i></a></li>
				<li class="menu-item"><a href="/client/game/products.jsp">게임</a></li>
				<li class="menu-item"><a href="/client/event/index.jsp" id="menu-event">이벤트</a></li>
				<li class="menu-item"><a href="/client/pay/cart.jsp">장바구니</a></li>
				<li class="menu-item"><a href="/client/myPage/index.jsp">내 페이지</a></li>
			</ul>
			<!-- .menu -->
			<div class="search-form">
				<label style="height: 50%"><img
					src="/images/icon-search.png"></label> <input type="text"
					placeholder="게임 이름을 검색하세요" id="searchGame" style="text-indent:40px;" />
			</div>
			<!-- .search-form -->
			<div class="mobile-navigation"></div>
			<!-- .mobile-navigation -->
		</div>
	</div>
</div>