<%@ page contentType="text/html; charset=UTF-8"%>
<%
	String event_id=request.getParameter("event_id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="/admin/static/css/registStyle.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
$(function(){ 
	getDetail();
	
	$($("#box1").find("input[type=file]")).change(function(){
		readImgURL(this);
	});
	$($("#box2").find("input[type=file]")).change(function(){
		readIconURL(this);
	});
	$($("input[type=button]")[0]).click(function(){
		addGame();
	});
	$($("input[type=button]")[1]).click(function(){
		delGame();
	});
	$($("input[type=button]")[2]).click(function(){
		edit();
	});
	$($("input[type=button]")[3]).click(function(){
		del();
	});
	$($("input[type=button]")[4]).click(function(){
		location.href="/admin/event/";
	});
});

function getDetail(){
	$.ajax({
		url:"/rest/admin/event/"+<%=event_id%>,
		type:"get",
		success:function(result){
			$("input[name='event_id']").val(result.event_id);
			$("input[name='event_name']").val(result.event_name);
			$("#myFile_img_pre").attr({
            	'src' : "/data/event/"+result.event_img,
            	'width' : 300,
            	'heigth' : 300
            });
			$("input[name='event_img']").val(result.event_img);
			$("#myFile_icon_pre").attr({
            	'src' : "/data/event/"+result.event_icon,
            	'width' : 100,
            	'heigth' : 100
            });
			$("input[name='event_icon']").val(result.event_icon);
			getEventGame(result.event_id);
			$("select[name='event_discount']").val(result.event_discount);
		}
	});
}

function getEventGame(event_id){
	$.ajax({
		url:"/rest/admin/event/games",
		type:"get",
		data:{
			event_id:event_id
		},
		success:function(result){
			str="";
			for(var i=0;i<result.length;i++){
				str+="<input type='text' name='game_name' value='"+result[i].game.game_name+"' style='width:20%'/>";
				str+="<input type='hidden' name='game_id' value='"+result[i].game.game_id+"' style='width:20%'/>";
			}
			$("#addGame").append(str);
		}
	});
}

function readImgURL(input){
	if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#myFile_img_pre').attr({
            	'src' : e.target.result,
            	'width' : 150
            });
        }
        reader.readAsDataURL(input.files[0]);
    }
}

function readIconURL(input){
	if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
        	$('#myFile_icon_pre').attr({
            	'src' : e.target.result,
            	'width' : 100
            });
        }
        reader.readAsDataURL(input.files[0]);
    }
}

function addGame(){
	if($("input[name='search_game']").val()==""){
		alert("추가할 게임을 입력하세요.");
		return;
	}
	
	$.ajax({
		url:"/rest/admin/searchgame",
		type:"get",
		data:{
			game_name:$("input[name='search_game']").val()
		},
		success:function(result){
			$("input[name='search_game']").val("");
			
			if(result.length==0){
				alert("일치하는 게임이 없습니다");
			}else{
				if(dupliGame(result)){
					alert("이미 추가한 게임입니다");
				}else{
					existGame(result);
				}
			}
		}
	});
}

function existGame(game){
	$.ajax({
		url:"/rest/admin/existGames",
		type:"get",
		data:{
			"game_id":game.game_id
		},
		success:function(result){
			if(result.length!=0){
				alert("이미 이벤트로 등록된 게임입니다");
			}else{
				var str="";
				str+="<input type='text' name='game_name' value='"+game.game_name+"' style='width:20%'/>";
				str+="<input type='hidden' name='game_id' value='"+game.game_id+"' style='width:20%'/>";
				$("#addGame").append(str);
			}
		}
	});
}

function dupliGame(game){
	var num=0;
	var values = $("input[name='game_name']").map(function(){
		return this.value;
	}).get();
	
	for(var i=0;i<values.length;i++){
		if(game.game_name==values[i]){
			num++;
		}
	}
	
	if(num!=0){
		return true;
	}else{
		return false;
	}
}

function delGame(){
	var num=0;
	var search=$("input[name='search_game']").val();
	
	if(search==""){
		alert("삭제할 게임을 입력하세요.");
		return;
	}
	
	var values = $("input[name='game_name']").map(function(){
		return this.value;
	}).get();
	
	for(var i=0;i<values.length;i++){
		if(search==values[i]){
			$($("input[name='game_name']")[i]).remove();
			$($("input[name='game_id']")[i]).remove();
			num++;
		}
	}
	
	if(num==0){
		alert("일치하는 게임이 없습니다.");
	}
	
	$("input[name='search_game']").val("");
}

function edit(){
	if(!confirm("이벤트를 수정하시겠습니까?")){
		return;
	}
	
	var values = $("input[name='game_name']").map(function(){
		return this.value;
	}).get();
	
	if($("input[name='event_name']").val()==""){
		alert("이벤트명을 입력하세요.");
		return;
	}else if(values.length==0){
		alert("이벤트로 등록할 게임을 입력하세요.");
		return;
	}
	
	$("form").attr({
		method:"post",
		action:"/admin/event/edit"
	});
	$("form").submit();
}

function del(){
	if(!confirm("이벤트를 삭제하시겠습니까?")){
		return;
	}
	$("form").attr({
		method:"post",
		action:"/admin/event/delete"
	});
	$("form").submit();
}
</script>
</head>
<body>
	<h3>이벤트 정보</h3>
	<div class="container">
		<form enctype="multipart/form-data">
			<input type="hidden" name="event_id"/>
		 	<label for="lname">이벤트명</label><p>
			<input type="text" name="event_name"/><hr>
		 	<label for="lname">사진 등록</label><p>
		 	<div class="fileBox" id="box1">
				<label for="file1">사진 선택</label> <input type="file" name="myFile_img"
					id="file1" class="filebt" />
			</div><p>
			<hr>
		 	<input type="hidden" name="event_img"/>
		 	<img id="myFile_img_pre"/><hr>
		 	<label for="lname">아이콘 등록</label><p>
		<div class="fileBox" id="box2">
				<label for="file2">사진 선택</label> <input type="file" name="myFile_icon"
				id="file2" class="filebt"/>
			</div><p>
			<hr>
		 	<input type="hidden" name="event_icon"/>
		 	<img id="myFile_icon_pre"/><hr>
		 	<label for="lname">이벤트로 등록할 게임</label><p>
		 	<input type="text" name="search_game" placeholder="등록할 게임 이름을 검색하세요" style="width:40%"/>
			<input type="button" value="추가"/>
			<input type="button" value="삭제"/><p>
		 	<div id="addGame"></div><hr>
		 	<label for="lname">할인율</label><p>
		 	<select name="event_discount">
		 		<option value="10">10%</option>
		 		<option value="20">20%</option>
		 		<option value="30">30%</option>
		 		<option value="40">40%</option> 
		 		<option value="50">50%</option> 
		 	</select>
		</form>
	</div>
		<input type="button" value="수정"/>
		<input type="button" value="삭제"/>
		<input type="button" value="목록"/>
</body>
</html>
