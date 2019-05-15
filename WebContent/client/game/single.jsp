<%@page import="game.model.domain.Member"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/client/inc/style.jsp"%>
<%@ include file="/client/inc/top.jsp"%>
<%!
	Member member;
	int member_id;
%>
<%
	int game_id=Integer.parseInt(request.getParameter("game_id"));
%>
<html>
<head>
<script>
$(function(){
	<%if(session.getAttribute("member")!=null){
			member_id=member.getMember_id();
		}%>

	getComments();
	gameInfo();
	getImage();
})
function getComments(){
	$.ajax({
		type:"get",
		url:"/rest/client/game/comment/<%=game_id%>",
		success:function(result){
			var count=0;
			var str="";
			for(var i=0;i<result.length;i++){
				var type=result[i].recommend;
				if(type==1){
					count++;
				}
				str+="<form name='comment"+result[i].comments_id+"'>";
	        	str+="<div class='co-one'>"
		        if(result[i].recommend==1){
		        str+="<img src='/images/good.png' id='co-recom-img'>";
		        }else{
		        str+="<img src='/images/bad.png' id='co-recom-img'>"; 
		        }
		        str+="<p>";
		        str+="<input type='hidden' name='game_id' value='"+<%=game_id%>+"'>";
		        str+="<input type='hidden' name='comments_id' value='"+result[i].comments_id+"'>";
		        str+="<font id='co'>";
		        str+="<font id='co-name'>"+result[i].member.nick;
		        str+="</font>&nbsp";
		        if(result[i].recommend==1){
		        	str+="<font id='co-recom' color='blue'>추천</font>";
		        }else{
		        	str+="<font id='co-recom' color='red'>비추천</font>"; 
		        }
		        str+="<font id='co-reco-1' color='blue' onClick='reco(1, "+result[i].comments_id+")'></font>";
		        str+="<font id='co-reco-0' color='red' onClick='reco(0, "+result[i].comments_id+")'></font>";
		       	str+="<input type='hidden' name='recommend' id='reco"+result[i].comments_id+"' value='"+result[i].recommend+"'>";
		        if(result[i].member.member_id==<%=member_id%>){ 
		        	str+="<font id='co-edit' onClick='coedit("+result[i].comments_id+", "+result[i].recommend+")'>수정</font>&nbsp&nbsp"; 
		        	str+="<font id='co-del' onClick='codel("+result[i].comments_id+")'>삭제</font>";
		        	str+="<font id='co-save' onClick='cosave("+result[i].comments_id+")'></font>";
		        }
		        str+="<br><input type='text' name='review' value='"+result[i].review+"' readonly>"; 
		        str+="<br>";
		        str+="<font id='co-date'>"+result[i].regdate+"</font>";
		        str+="</font>";
		        str+="</p>";
		        str+="</div>";
		        str+="</form>";
			}
			$("#grade").html(
				"총 "+result.length+"명 평가 (추천: "+count+"명 비추천: "+(result.length-count)+"명)"
			)
			$(".comments").append(str);
		}
	});
}

function coedit(id,reco){ 
	if(!confirm("댓글을 수정하시겠습니까?")){
		return; 
	} 
	
	$($("form[name='comment"+id+"']").find("input[name='review']")).removeAttr("readonly");
	$($("form[name='comment"+id+"']").find("#co-recom")).html("");
	$($("form[name='comment"+id+"']").find("#co-reco-1")).html("추천");
	$($("form[name='comment"+id+"']").find("#co-reco-0")).html("비추천");
	$($("form[name='comment"+id+"']").find("#co-edit")).html("");
	$($("form[name='comment"+id+"']").find("#co-del")).html("");
	$($("form[name='comment"+id+"']").find("#co-save")).html("수정");
	
	if(reco=="1"){
		$($("form[name='comment"+id+"']").find("#co-reco-1")).css("background-color","yellow");
	}else if(reco=="0"){
		$($("form[name='comment"+id+"']").find("#co-reco-0")).css("background-color","yellow");
	}
}

function reco(type, id){
	if(type=="1"){
		$("#reco"+id+"").val("1");
		$($("form[name='comment"+id+"']").find("#co-reco-0")).css("background-color","white");
		$($("form[name='comment"+id+"']").find("#co-reco-1")).css("background-color","yellow");
	}else if(type=="0"){
		$("#reco"+id+"").val("0");
		$($("form[name='comment"+id+"']").find("#co-reco-0")).css("background-color","yellow");
		$($("form[name='comment"+id+"']").find("#co-reco-1")).css("background-color","white"); 
	}
} 

function cosave(id){
	$("form[name='comment"+id+"']").attr({
    	 action:"/client/comment/edit",
   	 	 method:"post"
	});
	$("form[name='comment"+id+"']").submit();
	  
	alert("댓글이 수정되었습니다.");
}

function codel(id){
	if(!confirm("댓글을 삭제하시겠습니까?")){
		return;
	}
	$("form[name='comment"+id+"']").attr({
      	 action:"/client/comment/delete",
     	 method:"post"
   });
   $("form[name='comment"+id+"']").submit();
   
   alert("댓글이 삭제되었습니다.");
}

function gameInfo(){
	$.ajax({
		type:"get",
		url:"/rest/client/games/<%=game_id%>",
		success:function(result){
			$(".entry-title").html(result.game_name); 
			$("#game_company").html("개발사: "+result.game_company);			
			$("#game_date").html("출시일: "+result.game_date.substring(0,10)); 
			 if(result.game_sale!=0){
				 var str="";
				 str+="<font size='4px'><del>"+numberFormat(result.game_price)+"원 </del></font>&nbsp&nbsp";
				 str+="<font size='5px' color='red'>"+result.game_sale+"%</font><br>";
                 var sale_price=result.game_price*(100-result.game_sale)*0.01;
                 str+=numberFormat(sale_price)+"원";
				 $(".price").html(str);
              }else{
            	  $(".price").html(numberFormat(result.game_price)+"원");
              }
			
			$("#detail_first").html(result.game_detail);
		}
	});
}
function getImage(){
	$.ajax({	     
		url : "/rest/client/game/images",
		type : "get",
		data : {
			game_id : <%=game_id%>
		},
		success : function(result) {
			for(var i=0;i<result.length;i++){
				$("#image_"+i+" img").attr({
					'src' : '/data/game/' + result[i].img_filename
				});
				$("#image_"+i+" img").click(function(){
					var url = $(this).attr("src");
					var left = (screen.width/2)-(700/2);
					var top = (screen.height/2)-(400/2);
					window.open(url,null,
					"height=400,width=700,top="+top+", left="+left+",status=yes,toolbar=no,menubar=no,location=no");
				});
			}
		}
	});
}

function recommend(type){
	if(type=="1"){
		$("input[name='recommend']").val("1");
		$("#norec").css("background-color","#2b2b2b");
		$("#rec").css("background-color","yellow");
	}else if(type=="0"){
		$("input[name='recommend']").val("0");
		$("#norec").css("background-color","yellow");
		$("#rec").css("background-color","#2b2b2b");
	}
}

function registComment(){
	<%if(member==null){ %>
		alert("로그인이 필요한 서비스입니다");
		return;
	<%} %>
	if($("input[name='recommend']").val()==""){
		alert("추천/비추천을 선택해주세요");	
		return;
	}else if($("textarea[name='review']").val()==""){
		alert("게임에 대한 평가를 최소 1자 이상 입력해주세요");
		return;
	}
	$("form[name='registForm']").attr({
		action:"/client/game/comments/regist",
		method:"post"
	});
	$("form[name='registForm']").submit();
	alert("리뷰가 등록되었습니다");
}

function loginCheck(type){
	<%if(member==null){%> 
		alert("로그인이 필요한 서비스입니다");
		return;
	<%}else{%>
		checkMyGame(type);
	<%}%>
}

<%if(member!=null){%>
function checkMyGame(type){
	$.ajax({
		url:"/rest/client/game/myPage",
		type:"get",
		data:{
			"member_id":<%=member.getMember_id()%>
		},
		success:function(result){
			for(var i=0;i<result.length;i++){
				for(var j=0;j<result[i].detailList.length;j++){
					if(result[i].detailList[j].game.game_id==<%=game_id%>){
						alert("이미 구매한 게임입니다");
						return;
					}
				}
			}
			if(type=="cart"){
				checkCart();
			}else if(type=="pay"){
				location.href="/client/pay/pay.jsp?game_id="+<%=game_id%>;
			}
		}
	});
}
<%}%>

<%if(member!=null){%>
function checkCart(){
	$.ajax({
		url:"/rest/client/pay/cart/game",
		type:"get",
		data:{
			"game_id":<%=game_id%>,
			"member_id":<%=member.getMember_id()%>
		},
		success:function(result){
			if(result!=""){
				alert("이미 장바구니에 추가한 게임입니다");
				return;
			}else{
				registCart(<%=game_id%>);
			}
		}
	});
}
<%}%>

function registCart(game_id){
	$("#cart-data").attr({
		action:"/client/pay/cart/regist",
		method:"post"
	});
	$("#cart-data").submit();
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
<form id="cart-data" style="display:none">
	<%if(member!=null){ %>
	<input type="hidden" name="member_id" value="<%=member.getMember_id()%>" />
	<%} %>
	<input type="hidden" name="game_id" value="<%=game_id%>"/>
</form>
<body bgcolor="#2b2b2b">
	<div id="site-content" style="background-color:#2b2b2b">
		<!-- Top -->
		<main class="main-content">
		<div class="container">
			<div class="page">
				<div class="entry-content">
					<div class="row">
						<div class="col-sm-6 col-md-4">
							<div class="product-images">
								<!-- 이미지들 -->
								<figure class="large-image">
									<a href="#" id="image_0"><img></a>
								</figure>
								<div class="thumbnails">
									<a href="#" id="image_1"><img></a> <a href="#"
										id="image_2"><img></a> <a href="#" id="image_3"><img></a>
								</div>
							</div>
						</div>
						<div class="col-sm-6 col-md-8">
							<div>
								<h2 class="entry-title"></h2>
								<div id="game_company" class="game_info2"></div>
								<div id="game_date" class="game_info2"></div> 
								<small class="price"></small>
								<!-- p 태그는 게임설명..  -->
								<p id="detail_first"></p>
							</div>
							<h3 style="color: white" id="grade"></h3>
							<!-- <div class="addtocart-bar" style="width: 30%"> -->
							<form>
								<input type="button" value="장바구니에 추가" onclick="loginCheck('cart')">&nbsp&nbsp
								<input type="button" value="구매하기" onclick="loginCheck('pay')" style="background-color: orange">
							</form>
							<!-- </div> -->
						</div>
					</div>
					<br>
					<hr>
					<br>
					<form name="registForm">
						<div>
							<%if(member!=null){ %>
							<input type="hidden" name="member_id"
								value="<%=member.getMember_id()%>" /> <input type="hidden"
								name="game_id" value="<%=game_id %>" />
							<h1 id="my_nick" style="color: white"><%=member.getNick() %></h1>
							<%}else{ %>
							<h1 id="need-login" style="color: orange">로그인을 해주세요.</h1>
							<%} %>
							<h2 id="recommendType">
								<input type="hidden" name="recommend" /><a style="color: blue"
									id="rec" onclick="recommend(1)"><img src='/images/good.png' width='30px'><b> 추천</b></a> / <a
									style="color: red" id="norec" onclick="recommend(0)"><img src='/images/bad.png' width='30px'><b> 비추천</b></a>
							</h2>
							<textarea placeholder="댓글 입력...." name="review"
								style="background-color: white"></textarea>
							<br> <br> <input type="button" value="댓글 등록"
								id="registCom" onclick="registComment()" />
						</div>
					</form>
					<hr>	
					<div class="comments">
					</div>
				</div>
			</div>
		</div>
		<!-- .container --> </main>
		<!-- .main-content -->
		<!-- bottom -->
	</div>
</body>
</html>