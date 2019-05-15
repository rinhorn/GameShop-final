<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="game.model.domain.Member"%>
<%@ include file="/client/inc/style.jsp"%>
<%@ include file="/client/inc/top.jsp"%>
<%!
	Member member;
	int member_id;
%>
<!DOCTYPE html>
<html>
<head>
<style>
html, body, div {
	background-color: #2b2b2b;
}

#profile div, .mygame-list {
   border-radius: 4px;
   box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
   max-width: 500px;
   margin: 50px auto;
   text-align: center;
}

#profile div {
	max-width: 76%;
	background-color: white;
	text-align: left; 
}

#propro {
	padding: 10px; 
}

.mygame-list {
	max-width: 900px;
	box-shadow: none; 
}

h2 {
	margin-top: 20px;
	margin-left: 10px;
	font-size: 30px;
}

font {
	margin-left: 10px;
	font-size: 18px;
	font-weight: 200px;
}

p {
	margin-top: 15px;
	width: 100%; 
	float: left;
	font-size: 20px; 
	text-align: center;
}

#gameTitle {
	margin-top: 0px;
	font-size: 24px;
	font-weight: bold;
	color: #fff;
}

hr {
	border: 1px solid;
	text-align: center;
	margin-top: 10px; 
}

button {
   border: none;
   border-radius: 2px; 
   outline: 0;
   display: inline-block;
   padding: 8px;
   color: white;
   background-color: #45b77d;
   text-align: center;
   cursor: pointer;
   width: 100%;
   font-size: 18px;
}

#propro button:hover { 
   background: #46a260; 
}
</style>
<script>
$(function() {
<%if (session.getAttribute("member") == null) {%>
      alert("로그인이 필요한 서비스입니다.");
      location.href = "/client/login/index.jsp";
<%}else {
      member = (Member) session.getAttribute("member");
      member_id=member.getMember_id();
	 }
%>
   getProfile();
   myGame();
});

function myGame(){
   $.ajax({
      url:"/rest/client/game/myPage",
      type:"GET",
      data:{
         "member_id": <%=member_id%>
      },
      success:function(result){
    	var num=0;
    	if(result.length==0){ 
    		var str="";
			str+="<tr>";
			str+="<td colspan='6' style='text-align:center'>보유 게임이 없습니다.</td>";
			str+="</tr>";
			$("tbody").append(str);
			
    	}else{
		  	var str = "";
		  	for(var i=0;i<result.length;i++){
		  		for(var j=0;j<result[i].detailList.length;j++){
			        str+="<tr>";
			        str+="<td class='game-img'>";
			        str+="<a href='/client/game/single.jsp?game_id="+result[i].detailList[j].game.game_id+"'><img name='game-img"+result[i].detailList[j].game.game_id+"'></a>";
			        gameimage(result[i].detailList[j].game.game_id); 
			        str+="</td>";
			        str+="<td class='game-name'>"+result[i].detailList[j].game.game_name+"</td>";
			        str+="<td class='sales-date'>"+result[i].order_date.substring(0,10)+"</td>";
			        str+="</tr>";
			        num++;
		  		}
		  	}
		  	$("tbody").append(str);
    	}
		$("font[name='gameNum']").append("보유 게임 수 : "+num+" 개");
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
			$("img[name='game-img"+game_id+"']").attr({
				'src' : '/data/game/' + result[0].img_filename,
				width:"200px"
			});
		}
	});
}

function edit(){
   $(location).attr("href", "../myPage/edit.jsp");
}
	
function getProfile() {
   $.ajax({
      url : "/rest/client/profile",
      type : "get",
      data : {
         "member_id" : <%=member_id%>
      },
      success : function(result) {
         $("font[name='id']").text("아이디 : "+result.id);
         $("font[name='name']").text("이름 : "+result.name);
         $("font[name='nick']").text("닉네임 : "+result.nick);
         $("font[name='email']").text("이메일 : "+result.email);
      }
   });
}
</script>
</head>
<body>
	<div class="wrapper">
   <div id="profile"> 
      <div id="propro"> 
           <h2>내 프로필</h2><hr>
           <font name="id"></font><br><br>
           <font name="name"></font><br><br>
           <font name="nick"></font><br><br>
           <font name="email"></font><br><br>
           <font name="gameNum"></font><br><br> 

           <button onClick="edit()">개인 정보 수정</button>
      </div>
   </div>
   <hr width="76%">
   <div>
   		<p id="gameTitle">보유 게임 목록</p>
   </div>
   <div class="mygame-list">
   <table class="cart">
      <thead>
         <tr>
            <th class="product-img" width="30%">게임 사진</th> 
            <th class="product-name" width="50%">게임 이름</th>
            <th class="product-date" width="20%">구매일</th>
         </tr>
      </thead>
      <tbody>
      </tbody>
   </table>
  	</div>
  	</div>
</body>
</html>