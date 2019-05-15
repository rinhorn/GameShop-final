<%@ page contentType="text/html; charset=UTF-8"%>
<%String game_id=request.getParameter("game_id");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="/admin/static/css/registStyle.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
$(function(){ 
	   getCategories();
	   getImages();
	   getDetail();
	   $($("input[type=file]")[0]).change(function(){
	      readImgURL(this);
	   });   
	   $($("input[type=button]")[0]).click(function(){
	      nullCheck();
	   });
	   $($("input[type=button]")[1]).click(function(){
	      del();
	   });
	   $($("input[type=button]")[2]).click(function(){
	      location.href="/admin/game/";
	   });
	});

	function readImgURL(input){
	   $("#image_area").html("");
	   var str="";
	   for(var i=0;i<input.files.length;i++){
	      if (input.files && input.files[i]) {
	           var reader = new FileReader();
	           reader.onload = function (e){       
	              $("#image_area").append("<img src='"+e.target.result+"' style='width:100px'/>&nbsp&nbsp")
	              
	           }
	           reader.readAsDataURL(input.files[i]);
	       }
	   }
	}

	function getCategories(){
	   $.ajax({
	      url:"/rest/admin/categories",
	      type:"get",
	      success:function(result){
	         for(var i=0;i<result.length;i++){
	            $("select").append("<option value="+result[i].category_id+" id='category_name'>"+result[i].category_name+"</option>");
	         }
	      }
	   });
	}

	function getImages(){
	   $.ajax({
	      url:"/rest/admin/game/images",
	      type:"get",
	      data:{
	         game_id:<%=game_id%>
	      },
	      success:function(result){
	         for(var i=0;i<result.length;i++){
	            $("#image_area").append("<img id='"+<%=game_id%>+"' src='/data/game/"+result[i].img_filename+"' style='width:100px'/>&nbsp&nbsp");
	            $("#image_area").append("<input type='hidden' value='"+result[i].img_filename+"' name='myfile_name'>");
	         }
	      }
	   });
	}

	function getDetail(){
	   $.ajax({
	      url:"/rest/admin/games/<%=game_id%>",   
	      type:"get",
	      success:function(result){
	         $("#game_name").val(result.game_name);
	         $("#game_company").val(result.game_company);
	         $("#game_price").val(result.game_price);
	         $("#game_sale").val(result.game_sale);
	         $("#game_detail").val(result.game_detail);
	         $("#category_id").val(result.category_id);
	         getCategory(result.category_id);
	      }
	   });
	}

	function getCategory(category_id){
	   $.ajax({
	      url:"/rest/admin/categories/"+category_id,
	      type:"get",
	      success:function(result){
	         $("select").val(result.category_id);
	      }
	   });
	}

	function nullCheck(){
	   if($("#game_name").val()==""){
	      alert("게임 이름을 입력해주세요");
	      return;
	   }else if($("#game_company").val()==""){
	      alert("제작 회사를 입력해주세요");
	      return;
	   }else if($("#game_price").val()==""){
	      alert("게임의 가격을 입력해주세요");
	      return;
	   }else if($("#game_sale").val()==""){
	      alert("게임의 할인율을 입력해주세요");
	      return;
	   }else if($("#game_detail").val()==""){
	      alert("게임의 상세 설명을 입력해주세요");
	      return;
	   }
	   edit();   
	}

	function edit(){
		if(!confirm("정말 수정하시겠습니까?")){
			return;
		}
	   $("form").attr({
	      action:"/admin/game/update",
	      method:"post"
	   })
	   $("form").submit();
	}

	function del(){
		if(!confirm("정말 삭제하시겠습니까?")){
			return;
		}
	   $("form").attr({
	      action:"/admin/game/delete",
	      method:"post"
	   });
	   $("form").submit();
	}
</script>
</head>
<body>
	<h3>게임 정보</h3>
	<div class="container">
		<form enctype="multipart/form-data">
			<label for="lname">카테고리</label>
			<p>
				<select name="category_id"></select>
			<hr>

			<input type="hidden" name="game_id" value=<%=game_id%>> <label
				for="lname">게임명</label>
			<p>
				<input type="text" name="game_name" id="game_name" />
			<hr>

			<label for="lname">제작사</label>
			<p>
				<input type="text" name="game_company" id="game_company" />
			<hr>

			<label for="lname">가격</label>
			<p>
				<input type="text" name="game_price" id="game_price" />
			<hr>

			<label for="lname">할인율</label> 
			<p>
				<input type="text" name="game_sale" id="game_sale" readonly/>
			<hr>

			<label for="lname">사진</label>
			<p>
			<div class="fileBox">
				<label for="filebt">업로드</label> <input type="file" name="myfile"
					id="filebt" multiple />
			</div>
			<hr>
			<div id="image_area"></div>
			<hr>
			<label for="lname">상세 설명</label>
			<p>
				<textarea name="game_detail" style="height: 200px" id="game_detail">
         </textarea>
		</form>
	</div>
	<input type="button" value="수정" />
	<input type="button" value="삭제" />
	<input type="button" value="목록" />
</body>
</html>