<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="/admin/static/css/registStyle.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
$(function(){
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
		regist();
	});
	$($("input[type=button]")[3]).click(function(){
		location.href="/admin/event/";
	});
});

function readImgURL(input){
	if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $("#myFile_img").attr({
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
        	$("#myFile_icon").attr({
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
				}else {
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

function regist(){
	var values = $("input[name='game_name']").map(function(){
		return this.value;
	}).get();
	
	if($("input[name='event_name']").val()==""){
		alert("이벤트명을 입력하세요.");
		return;
	}else if($("input[name='myFile_img']").val()==""){
		alert("이벤트 사진을 등록하세요.");
		return;
	}else if($("input[name='myFile_icon']").val()==""){
		alert("이벤트 아이콘을 등록하세요.");
		return;
	}else if(values.length==0){
		alert("이벤트로 등록할 게임을 입력하세요.");
		return;
	}else if($("select").val()==""){
		alert("할인율을 선택하세요.");
		return;
	}else if(!confirm("이벤트를 등록할까요?")){
		return;
	}
	
	$("form").attr({
		method:"post",
		action:"/admin/event/regist"
	});
	$("form").submit();
}
</script>
</head>
<body>
	<h3>이벤트 등록</h3>
	<div class="container">
		<form enctype="multipart/form-data">
		 	<label for="lname">이벤트명</label><p>
			<input type="text" name="event_name" placeholder="이벤트명"/><hr>
		 	<label for="lname">사진 등록</label><p>
			<div class="fileBox" id="box1">
				<label for="file1">사진 선택</label> <input type="file" name="myFile_img"
					id="file1" class="filebt" />
			</div><p>
			<hr>
				<img id="myFile_img"/><hr>
		 	<label for="lname">아이콘 등록</label><p>
			<div class="fileBox" id="box2">
				<label for="file2">사진 선택</label> <input type="file" name="myFile_icon"
				id="file2" class="filebt"/>
			</div><p>
			<hr>
			<img id="myFile_icon"/><hr>
		 	<label for="lname">이벤트로 등록할 게임</label><p>
		 	<input type="text" name="search_game" placeholder="등록할 게임 이름을 검색하세요" style="width:40%"/>
			<input type="button" value="추가"/>
			<input type="button" value="삭제"/></p>
		 	<div id="addGame"></div><hr>
		 	<label for="lname">할인율</label><p>
		 	<select name="event_discount">
		 		<option value="">할인율 선택</option>
		 		<option value="10">10%</option>
		 		<option value="20">20%</option>
		 		<option value="30">30%</option>
		 		<option value="40">40%</option> 
		 		<option value="50">50%</option> 
		 	</select><p>
		</form>
	</div>
		<input type="button" value="등록"/>
		<input type="button" value="목록"/>
</body>
</html>
