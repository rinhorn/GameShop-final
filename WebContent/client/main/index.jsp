<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/client/inc/style.jsp"%>
<%@ include file="/client/inc/top.jsp"%>
<style>
.event-list {
	width: 100%;
	height: 500px;
	position: relative;
	text-align: center;
	background: #2b2b2b;
}
.event_bt {
	width: 70px;
	height: 70px;
	margin-bottom: 180px;
}
.event_icon_div {
	padding: 10px;
	position: absolute;
  	left: 190px; 
  	top: 5px;
}
.event-list #event_img {
	width: 1000px;
	height: 400px;
	margin-top: 50px;
}
.event-list #event_icon {
  width: 100px;
  height: 100px;
}
</style>
<script>
var eventNum=0;
var eventUrlList=new Array();
var eventImgList=new Array();
var eventIconList=new Array();

$(function() {
	getEvent();
	getGameList();
	eventGameList();
});

function getEvent() {
	$.ajax({
		url : "/rest/client/events",
		type : "get",
		success : function(result) {
			if(result.length!=0){
				eventNum=result.length-1; 
				
				var str = "";
				str += "<img src='/images/left-arrow.png' onClick='eventBefore("+result.length+")' class='event_bt'>";
				str += "<div class='event_icon_div'>";
				str += "<img src='/data/event/"+result[eventNum].event_icon+"' id='event_icon' width='70px'>";
				str += "</div>";
				str += "<a href='/client/event/index.jsp?event_id="+result[eventNum].event_id+"' id='event_url'><img src='/data/event/"+result[eventNum].event_img+"' id='event_img'></a>";
				str += "<img src='/images/right-arrow.png' onClick='eventNext("+result.length+")' class='event_bt'>";
				$(".event-list").append(str);
				
				for(var i=0;i<result.length;i++){
					eventUrlList[i]=result[i].event_id;
					eventImgList[i]=result[i].event_img;
					eventIconList[i]=result[i].event_icon;
				}
				eventChange(result.length);
			}
		}
	});
}

function eventBefore(length){
	if(eventNum==0){
		eventNum=length-1;
	}else{
		eventNum--;
	}
	$("#event_url").prop("href", "/client/event/index.jsp?event_id="+eventUrlList[eventNum]);
	$("#event_img").attr("src","/data/event/"+eventImgList[eventNum]);
	$("#event_icon").attr("src","/data/event/"+eventIconList[eventNum]);
}

function eventNext(length){
	if(eventNum==length-1){
		eventNum=0;
	}else{
		eventNum++;
	}
	$("#event_url").prop("href", "/client/event/index.jsp?event_id="+eventUrlList[eventNum]);
	$("#event_img").attr("src","/data/event/"+eventImgList[eventNum]);
	$("#event_icon").attr("src","/data/event/"+eventIconList[eventNum]);
}

function eventChange(length){
	eventNext(length);
	setTimeout("eventChange("+length+")", 3000);
}

function getGameList() {
	$.ajax({
		url : "/rest/client/game/sort",
		type : "get",
		data: {
			category_id: 0,
			type: 4
		},
		success : function(result) {
			for (var i = 0; i < 8; i++) {
				if (i == result.length-1) break;
				
				var str = "";
				str += "<div class='product'>";
				str += "<div class='inner-product'>";
				str += "<div id='game-event-icon' name='icon"+result[i].game_id+"'></div>";
				isEventGame(result[i].game_id);
				str += "<div class='figure-image'>";
				gameimage(result[i].game_id);
				str += "<a href='/client/game/single.jsp?game_id="+result[i].game_id+"'><img name='"+result[i].game_id+"'></a>";
				str += "<input type='hidden' name='game_id_' value='"+result[i].game_id+"'>";
				str += "</div>"
				str += "<h3 class='product-title'><a href='/client/game/single.jsp?game_id="+result[i].game_id+"'>"
						+ result[i].game_name + "</a></h3>";
						
				if(result[i].game_sale!=0){
					str+="<small class='price'><del>"+numberFormat(result[i].game_price)+"원</del>";  
					str+="&nbsp&nbsp <font size='4px' color='red'>"+result[i].game_sale+"%</font></small>"
					   var sale_price=result[i].game_price*(100-result[i].game_sale)*0.01;
					str+="<small class='price'>"+numberFormat(sale_price)+"원</small>";
				}else{
					str += "<small class='price'>"
						+ numberFormat(result[i].game_price) + "원</small>";
					str+="<small class='price' style='height:20px'></small>";
				}
				
				if(result[i].game_detail.length>85){
					str += "<p>" + result[i].game_detail.substring(0,85) + "...</p>";
				}else{
					str += "<p>" + result[i].game_detail + "</p>";
				}
				
				str += "<a href='#' onclick='loginCheck("+result[i].game_id+","+0+")' class='button'>장바구니에 추가</a>&nbsp";
				str += "<a href='#' onclick='loginCheck("+result[i].game_id+","+1+")' class='button' style='background-color:orange'>구매하기</a>";
				str += "</div>";
				str += "</div>";
				$("#new-product").append(str);
			}
		}
	});
}

function gameimage(game_id) {
	$.ajax({
		url : "/rest/admin/game/images",
		type : "get",
		data : {
			game_id : game_id
		},
		success : function(result) {
			$("img[name='" + game_id + "']").attr({
				'src' : '/data/game/' + result[0].img_filename
			});
		}
	});
}

function isEventGame(game_id){
	$.ajax({
		url : "/rest/client/existGames",
		type : "get",
		data : {
			game_id : game_id
		},
		success : function(result) {
			if(result.length!=0){
				$("div[name='icon"+game_id+"']").html("");
				$("div[name='icon"+game_id+"']").append("<img src='/data/event/"+result[0].event.event_icon+"'>");
			}
		}
	});
}

function eventGameList() {
	$.ajax({
		url : "/rest/client/eventGames",
		type : "get",
		success : function(result) {
			if(result.length!=0){
				$("#eventUrl").prop("href", "/client/event/index.jsp?event_id="+result[0].event.event_id);
			}else{
				$("#eventUrl").prop("href", "/client/event/index.jsp");
			}
			
			for(var i=0;i<8;i++){
				if(i==result.length-1) break;
				
				var num = Math.floor(Math.random()*result.length);
			    var num_game_id=result[num].game.game_id;
			    var cnt=0;
			    
			    var values = $("input[name='game_id']").map(function(){
					return this.value;
				}).get();
				for(var j=0;j<values.length;j++){
					if(num_game_id==values[j]){
						cnt++;
					}
				}
				
			   if(cnt!=0){
					i--;
			   }else{
				   var str="";
				   str+="<div class='product'>";
				   str+="<div class='inner-product'>";
				   str+="<div id='icon'>";
				   str+="<img src='/data/event/"+result[num].event.event_icon+"'>";
				   str+="</div>";
				   str+="<div class='figure-image'>";
				   gameimage(result[num].game.game_id);
				   str+="<a href='/client/game/single.jsp?game_id="+result[num].game.game_id+"'><img name='"+result[num].game.game_id+"'></a>";
				   str+="<input type='hidden' name='game_id' value='"+result[num].game.game_id+"'>";
				   str+="</div>";
				   str+="<h3 class='product-title'><a href='#'>"+result[num].game.game_name+"</a></h3>";
				   str+="<small class='price'><del>"+numberFormat(result[num].game.game_price)+"원</del>";  
				   str+="&nbsp&nbsp <font size='4px' color='red'>"+result[num].event.event_discount+"%</font></small>"
				   var sale_price=result[num].game.game_price*(100-result[num].event.event_discount)*0.01;
				   str+="<small class='price'>"+numberFormat(sale_price)+"원</small>";
				   
				   if(result[num].game.game_detail.length>85){
						str += "<p>" + result[num].game.game_detail.substring(0,85) + "...</p>";
					}else{
						str += "<p>" + result[num].game.game_detail + "</p>";
					}

				   str+="<a href='#' onclick='loginCheck("+result[num].game.game_id+","+0+")' class='button'>장바구니에 추가</a>&nbsp";
				   str += "<a href='#' onclick='loginCheck("+result[num].game.game_id+","+1+")' class='button' style='background-color:orange'>구매하기</a>";
				   str+="</div>";
				   str+="</div>";
					$("#sale-product").append(str);
			   }
			}
		}
	}); 
}

function loginCheck(game_id, type){
   <%if(member==null){%> 
   alert("로그인이 필요한 서비스입니다");
   <%}else{%>
   checkMyGame(game_id,type);
   <%}%>
}

<%if(member!=null){%>
function checkMyGame(game_id,type){
	$.ajax({
		url:"/rest/client/game/myPage",
		type:"get",
		data:{
			"member_id":<%=member.getMember_id()%>
		},
		success:function(result){
			for(var i=0;i<result.length;i++){
				for(var j=0;j<result[i].detailList.length;j++){
					if(result[i].detailList[j].game.game_id==game_id){
						alert("이미 구매한 게임입니다");
						return;
					}
				}
			}
			if(type==0){
				checkCart(game_id);
			}else if(type==1){
				location.href="/client/pay/pay.jsp?game_id="+game_id;
			}
		}
	});
}
<%}%>

function checkCart(game_id){
	<%if(member==null){%>
	alert("로그인이 필요한 서비스입니다");
	return;
	<%}else{%>
	$.ajax({
		url:"/rest/client/pay/cart/game",
		type:"get",
		data:{
			"game_id":game_id,
			"member_id":<%=member.getMember_id()%>
		},
		success:function(result){
			if(result!=""){
				alert("이미 장바구니에 추가한 게임입니다");
				return;
			}else{
				registCart(game_id);
			}
		}
	});
	<%}%>
}
function registCart(game_id){
	$("input[name='game_id']").val(game_id);
	$("form").attr({
		action:"/client/pay/cart/regist",
		method:"post"
	});
	$("form").submit();
	alert("장바구니에 상품이 등록되었습니다");
}
function numberFormat(num){
   var numstr=num.toString(); 
   var len=numstr.length;
   var result="";
   if(Math.floor(num/1000000)>0){
		result=(Math.floor(num/1000000)).toString()+","+numstr.substring(len-6, len-3)+","+numstr.substring(len-3);
   }else if(Math.floor(num/1000)>0){
		result=(Math.floor(num/1000)).toString()+","+numstr.substring(len-3);  
	}
   return result;
}
</script>
</head>
<form style="display:none">
	<%if (member != null) {%>
	<input type="hidden" value="<%=member.getMember_id()%>" name="member_id" />
	<%}%>
	<input type="hidden" name="game_id" />
</form>
<body class="slider-collapse">
	<div id="site-content">
		<!-- Top -->
		<div class="event-list">
		</div>

		<!-- .home-slider -->
		<main class="main-content">
		<div class="container">
			<div class="page">
				<section>
					<header>
						<h2 class="section-title">인기 상품</h2>
						<!-- 전체 상품 보기 -->
						<a href="/client/game/products.jsp" class="all">모두 보기</a>
					</header>
					<!-- 상품 정보 -->
					<div class="product-list" id="new-product"></div>
					<!-- .product-list -->
				</section>
				<section>
					<header>
						<h2 class="section-title">할인 상품</h2>
						<a href="#" id="eventUrl" class="all">모두 보기</a>
					</header>
					<div class="product-list" id="sale-product"></div>
					<!-- .product-list -->
				</section>
			</div>
		</div>
		<!-- .container --> </main>
	</div>
	<div class="overlay"></div>
</body>
</html>