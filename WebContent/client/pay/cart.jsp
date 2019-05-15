<%@page import="java.util.Formatter"%>
<%@page import="game.model.domain.Member"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/client/inc/top.jsp"%>
<%@ include file="/client/inc/style.jsp"%>
<%!
	Member member;
	int member_id;
%>
<html>
<head>
<script>
var exist=0;

$(function(){
	<%if(session.getAttribute("member")==null){%>
		alert("로그인이 필요한 서비스입니다.");
		location.href="/client/login/index.jsp";
		return;
	<%
		}else{
			member_id=member.getMember_id();
		}
	%>
	getCart();

 	$("#checkAll").click(function(){
        if($(this).is(":checked")){
        	$(".checkOne").prop('checked', true);
        }else{
        	$(".checkOne").prop('checked', false);
        }
    });
 	$("#del_select").click(function(){
 		delSelect();
 	});
 	$("#del_all").click(function(){
 		delAll();
 	});
 	$("#button").click(function(){
 		pay();
 	});
})
	
function getCart(){
	$.ajax({
		url:"/rest/client/pay/cart/<%=member_id %>",
		type:"get",
		success:function(result){
			exist=result.length;
			
			if(result.length==0){
				var str="";
				str+="<tr>";
				str+="<td colspan='6' style='text-align:center'>장바구니에 담긴 상품이 없습니다.</td>";
				str+="</tr>";
				$("tbody").append(str);
				
			}else{
				var before=0;
				var after=0;
				for(var i=0;i<result.length;i++){
					var obj=result[i].game;
					var str="";
					str+="<tr>";
					str+="<td class='product-choice' style='text-align:center'>";
					str+="<input type='checkBox' class='checkOne' id='check"+i+"'/>";
					str+="<input type='hidden' id='gameId"+i+"' name='game_id' value='"+obj.game_id+"'/>";
					str+="</td>";
					str+="<td class='product-img'>";
					str+="<div class='product-thumbnail'>";
					str+="<a href='/client/game/single.jsp?game_id="+obj.game_id+"'><img name='cart-img"+obj.game_id+"'></a>";
					str+="</div>";
					str+="<div class='product-detail'>";
					str+="<td class='product-name'><h3 class='product-title'>"+obj.game_name+"</h3></td>";
					str+="</div>";
					str+="</td>";
					str+="<td class='product-price'>"+numberFormat(obj.game_price)+"원</td>";
					str+="<td class='product-qty'>- "+obj.game_sale+"%</td>";
					str+="<td class='product-total'>"+numberFormat(obj.game_price*(100-obj.game_sale)*0.01)+"원</td>";
					str+="</tr>";
					
					getCartImg(obj.game_id);
					$("tbody").append(str);
					
					before+=obj.game_price;
					after+=obj.game_price*(100-obj.game_sale)*0.01;
				}
				 totalPrice(before,after);
			}
		}
	});
}

function getCartImg(game_id){
	$.ajax({
		url:"/rest/client/pay/cart/image",
		type:"get",
		data:{
			"game_id":game_id
		},
		success:function(result){
			$("img[name='cart-img"+game_id+"']").attr({
				src:"/data/game/"+result[0].img_filename,
				width:"200px"
			});
		}
	});
}

function totalPrice(before,after){
	$("#beforePrice").html(numberFormat(before)+"원");
	$("#afterPrice").html(numberFormat(after)+"원");
}

function delSelect(){
	if(!confirm("선택하신 상품을 삭제하시겠습니까?")){
		return;
	}
	
	var index=0;
	var gameIdArray = new Array();
	for(var i=0;i<exist;i++){
		if($("#check"+i).is(":checked")){
			gameIdArray[index]=$("#gameId"+i).val();
			index++;
		}
	}
	
	if(index==0){
		alert("상품을 먼저 선택해주세요.");
		return;
	}
	
	jQuery.ajaxSettings.traditional = true;
	
	$.ajax({
		url:"/rest/client/pay/cart/delSelect",
		type:"get",
		data:{
			"member_id":<%=member_id%>,
			"game_id":gameIdArray
		},
		success:function(result){
			$("tbody").html("");
			getCart();
		}
	});
}

function delAll(){
	if(!confirm("장바구니를 모두 비우시겠습니까?")){
		return;
	}
	if(exist==0){
		alert("장바구니에 담긴 상품이 없습니다.");
		return;
	}
	
	$.ajax({
		url:"/rest/client/pay/cart/delAll",
		type:"get",
		data:{
			"member_id":<%=member_id%>
		},
		success:function(result){
			$("tbody").html("");
			getCart();
		}
	});
}

function pay(){
	if(exist==0){
		alert("결제할 상품이 없습니다.");
		return;
	}
	
	$("#cartForm").attr({
		action:"/client/pay/pay.jsp",
		method:"post"
	});
	$("#cartForm").submit();
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
<body>
	<div id="site-content">
		<!-- Top -->
		<main class="main-content">
		<div class="container">
			<div class="page">
				<form id="cartForm">
				<table class="cart">
					<thead>
						<tr>
							<th class="product-choice"><input type='checkBox' id="checkAll"/></th>							
							<th class="product-img">게임 사진</th>
							<th class="product-name">게임 이름</th>
							<th class="product-price">가격</th>
							<th class="product-qty">할인율</th>
							<th class="product-total">최종 가격</th>
						</tr>
					</thead>
						<tbody>
						</tbody>
				</table>
					</form>
				<div class="cart-del">
					<p>
						<input type="button" id="del_select" value="선택상품 삭제하기"/> 
						<input type="button" id="del_all" value="장바구니 모두 비우기"/>
					</p>
				</div>
				<!-- .cart -->
					<div class="cart-total">
						<p class="before-total">
							<strong>할인 전 금액 </strong><text id="beforePrice"></text>
						</p>
						<p class="total">
							<strong>결제 금액</strong><span class="num" id="afterPrice"></span>
						</p>
						<p>
							<a href="/client/game/products.jsp" class="button muted">쇼핑 계속하기</a>
							<input type="button" id="button" value="결제하기">
						</p>
					</div>
				<!-- .cart-total -->
			</div>
		</div>
		<!-- .container --> </main>
		<!-- .main-content -->
	</div>
	<div class="overlay"></div>
</body>
</html>