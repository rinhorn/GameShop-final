<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/client/inc/style.jsp"%>
<%@ include file="/client/inc/top.jsp"%>
<%
	String event_id="-1";
	if(request.getParameter("event_id")!=null){
		event_id=request.getParameter("event_id");
	}
	
	int currentPage;
	if(request.getParameter("currentPage")==null){
		currentPage=1;
	}else{
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}
%>
<html>
<head>
<script>
$(function(){
	getEventList();
	getPager();
})

function getPager(){
	$.ajax({
		url:"/rest/client/eventPagers",
		type:"get",
		data:{
			currentPage:<%=currentPage%>,
			"event_id":<%=event_id%>
		},
		success:function(result){
			var str="";
			
			if(result.firstPage-1>0){
				str+="<a href='/client/event/index.jsp?event_id="+<%=event_id%>+"&currentPage="+result.firstPage-1+"><font color='black'>◀</font></a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"이전 페이지가 없습니다.\")'><font color='black'>◀</font></a>&nbsp&nbsp";
			}
			
			for(var i=result.firstPage; i<result.lastPage; i++){
				if(i>result.totalPage) break;
				if(i==result.currentPage){
					str+="<a class='pageNum' href='/client/event/index.jsp?event_id="+<%=event_id%>+"&currentPage="+i+"'><font size='5px'>["+i+"]</font></a>&nbsp&nbsp";
				}else{
					str+="<a href='/client/event/index.jsp?event_id="+<%=event_id%>+"&currentPage="+i+"''><font color='black'>["+i+"]</font></a>&nbsp&nbsp";
				}
			}
			
			if(result.lastPage+1<=result.totalPage){
				str+="<a href='/client/event/index.jsp?event_id="+<%=event_id%>+"&currentPage="+result.lastPage+1+"><font color='black'>▶</font></a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"다음 페이지가 없습니다.\")'><font color='black'>▶</font></a>&nbsp&nbsp";
			}
			
			$(".pagination-bar").append(str);
			
			getEventGame(result);
		}
	});
}

function getEventGame(pager){
	if(<%=event_id%>=="-1"){
		$(".product-list").css({
			"font-size":"25px",
			"text-align":"center",
			"margin-bottom":"100px"
		});
		$(".product-list").append("진행중인 이벤트가 없습니다.");
		return;
	}
	
	$.ajax({
		type:"get",
		url:"/rest/client/event/games",
		data:{
			"event_id":<%=event_id%>
		},
		success:function(result){
			$(".eventPage-image").append("<img src='/data/event/"+result[0].event.event_img+"'/>");
			
			var str="";
			for(var i=1; i<=pager.pageSize; i++){
	        	if(pager.num<1) break;
				str+="<div class='product'>";
				str+="<div class='inner-product'>";
				str+="<div class='figure-image'>";
				str+="<a href='/client/game/single.jsp?game_id="+result[pager.curPos].game.game_id+"'><img name='"+result[pager.curPos].game.game_id+"'></a>";
				str+="</div>";
				str+="<h3 class='product-title'>";
				str+="<a href='/client/game/single.jsp?game_id="+result[pager.curPos].game.game_id+"'>"+result[pager.curPos].game.game_name+"</a>";
				str+="</h3>";
				
				if(result[pager.curPos].game.game_sale!=0){
					str+="<small class='price'><del>"+numberFormat(result[pager.curPos].game.game_price)+"원</del>";  
					str+="&nbsp&nbsp <font size='4px' color='red'>"+result[pager.curPos].game.game_sale+"%</font></small>"
					   var sale_price=result[pager.curPos].game.game_price*(100-result[pager.curPos].game.game_sale)*0.01;
					str+="<small class='price'>"+numberFormat(sale_price)+"원</small>";
				}else{
					str += "<small class='price'>"
						+ numberFormat(result[pager.curPos].game.game_price) + "원</small>";
				}
				
				if(result[pager.curPos].game.game_detail.length>85){
					str += "<p>" + result[pager.curPos].game.game_detail.substring(0,85) + "...</p>";
				}else{
					str += "<p>" + result[pager.curPos].game.game_detail + "</p>";
				}
				
				str += "<a href='#' onclick='loginCheck("+result[pager.curPos].game.game_id+","+0+")' class='button'>장바구니에 추가</a>&nbsp";
				str += "<a href='#' onclick='loginCheck("+result[pager.curPos].game.game_id+","+1+")' class='button' style='background-color:orange'>구매하기</a>";
				str+="</div>";
				str+="</div>";
				getImages(result[pager.curPos].game.game_id);
				
				pager.num--;
				pager.curPos++;
			}
			$(".product-list").append(str);
		}
	});
}
function getImages(game_id){
	$.ajax({
		url:"/rest/admin/game/images",
		type:"get",
		data:{
			game_id:game_id
		},
		success:function(result){
			$("img[name='"+game_id+"']").attr({
				'src':'/data/game/'+result[0].img_filename
			});
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
				
				$("select[name='event_id']").html("");
				var str="";
				for(var i=0;i<result.length;i++){
					str+="<option value='"+result[i].event_id+"'>"+result[i].event_name+"</option>";
				}
				$("select[name='event_id']").append(str);
				$("select[name='event_id']").val(<%=event_id%>);
			}
		}		
	});	
}

function sort(){
	var event_id=$("select[name='event_id']").val();
	location.href="/client/event/index.jsp?event_id="+event_id;
}

function loginCheck(game_id, type){
	   <%if(member==null){%> 
	   alert("로그인이 필요한 서비스입니다");
	   <%}else{%>
	   checkMyGame(game_id, type);
	   <%}%>
	}

<%if(member!=null){%>
function checkMyGame(game_id, type){
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

<%if(member!=null){%>
function checkCart(game_id){
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
}
<%}%>
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
<body bgcolor="#2b2b2b">
	<div id="site-content" style="background-color:#2b2b2b">
		<!-- Top -->
		<main class="main-content">
		<div class="container">
			<div class="page">
				<div class="filter-bar">
					<div class="filter">
						<span><label>이벤트 목록  :</label>
						<select name="event_id"></select>
						<a class="button" onclick="sort()">보기</a>
						</span>
					</div>
					<!-- .filter -->
				</div>
				<!-- .filter-bar -->
				<div class="eventPage-image">
					
				</div>
				<div class="product-list"></div>
				<!-- .product-list -->
				<div class="pagination-bar">
				</div>
			</div>
		</div>
		</main>
</body>
</html>