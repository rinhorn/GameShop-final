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
	getCategory();
	
	$($("input[type=file]")[0]).change(function(){
		readImgURL(this);
	});
	$($("input[type=button]")[0]).click(function(){
		regist();
	});
	$($("input[type=button]")[1]).click(function(){
		location.href="/admin/game/";
	});
});

function readImgURL(input){
	for(var i=0;i<input.files.length;i++){
		if (input.files && input.files[i]) {
	        var reader = new FileReader();
	        reader.onload = function (e) {
	        	$("#myFile").append("<img src='"+e.target.result+"' style='width:100px'/>&nbsp&nbsp");
	        }
	        reader.readAsDataURL(input.files[i]);
	    }
	}
}

function getCategory(){
	$.ajax({
		url:"/rest/admin/categories",
		type:"get",
		success:function(result){
			for(var i=0;i<result.length;i++){
				$("select").append("<option value="+result[i].category_id+">"+result[i].category_name+"</option>");
			}
		}
	});
}

function regist(){
	if($("select").val()==""){
		alert("카테고리를 선택하세요.");
		return;
	}else if($("input[name='game_name']").val()==""){
		alert("게임명을 등록하세요.");
		return;
	}else if($("input[name='game_company']").val()==""){
		alert("제작사를 등록하세요.");
		return;
	}else if($("input[name='game_price']").val()==""){
		alert("가격을 등록하세요.");
		return;
	}else if($("input[name='myfile']").val()==""){
		alert("사진을 등록하세요.");
		return;
	}else if($("textarea").val()==""){
		alert("상세 설명을 등록하세요.");
		return;
	}else if(!confirm("게임을 등록할까요?")){
		return;
	}	
	
	$("form").attr({
		method:"post",
		action:"/admin/game/regist"
	});
	$("form").submit();
}
</script>
</head>
<body>
	<h3>게임 등록</h3>
	<div class="container">
		<form enctype="multipart/form-data">
		 	<label for="lname">카테고리</label><p>
		 	<select name="category_id">
		 		<option value="">카테고리 선택</option>
		 	</select><hr>
		 	<label for="lname">게임명</label><p>
			<input type="text" name="game_name" placeholder="게임명"/><hr>
		 	<label for="lname">제작사</label><p>
			<input type="text" name="game_company" placeholder="제작사"/><hr>
		 	<label for="lname">가격</label><p>
			<input type="text" name="game_price" placeholder="가격"/><hr>
		 	<label for="lname">사진 등록</label><p>
			<div class="fileBox">
				<label for="filebt">사진 선택</label> <input type="file" name="myfile"
					id="filebt" multiple />
			</div>
			<hr>
			<div id="myFile"></div><hr>
		 	<label for="lname">상세 설명</label><p>
			<textarea name="game_detail" placeholder="상세 설명" style="height: 200px"></textarea>
		</form>
	</div>
	<input type="button" value="등록"/>
	<input type="button" value="목록"/>
</body>
</html>