<%@ page contentType="text/html; charset=UTF-8"%>
<%
   String member_id=request.getParameter("member_id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="/admin/static/css/registStyle.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
var beforeNick;
var beforeEmail;
var successNick;
var successEmail;
var nickCnt=0;
var emailCnt=0;

$(function(){ 
   getDetail();
   
   $($("input[type=button]")[0]).click(function(){
      checkNick();
   });
   $($("input[type=button]")[1]).click(function(){
      checkEmail();
   });
   
   $($("input[type=button]")[2]).click(function(){
      edit();
   });
   $($("input[type=button]")[3]).click(function(){
      del();
   });
   $($("input[type=button]")[4]).click(function(){
      location.href="/admin/member/";
   });
});

function getDetail(){
   $.ajax({
      url:"/rest/admin/member/"+<%=member_id%>,
      type:"get",
      success:function(result){
         beforeNick=result.nick;
         beforeEmail=result.email;
         successNick=beforeNick;
         successEmail=beforeEmail;
         $("input[name='member_id']").val(result.member_id);
         $("input[name='id']").val(result.id);
         $("input[name='pass']").val(result.pass);
         $("input[name='name']").val(result.name);
         $("input[name='nick']").val(result.nick);
         $("input[name='email']").val(result.email);
      }
   });
}

function checkNick(){
   $.ajax({
      url:"/rest/admin/member/checkNick",
      type:"get",
      data:{
         nick:$("input[name='nick']").val()   
      },
      success:function(result){         
         $("div[name='nick_check']").html("");
         
         if($("input[name='nick']").val()==""){
            alert("사용할 닉네임을 적어주세요.");
         }else{
            if(result.length==0){
               successNick=$("input[name='nick']").val();
               $("div[name='nick_check']").append("사용 가능한 닉네임입니다.");
               $("div[name='nick_check']").css('color', 'blue');
               nickCnt++;
            }else{
               $("div[name='nick_check']").append("이미 존재하는 닉네임입니다.");
               $("div[name='nick_check']").css('color', 'red');
               $("input[name='nick']").val("");
            }
         }
      }
   });
}

function checkEmail(){
   $.ajax({
      url:"/rest/admin/member/checkEmail",
      type:"get",
      data:{
         email:$("input[name='email']").val()   
      },
      success:function(result){
         $("div[name='email_check']").html("");
         
         if($("input[name='email']").val()==""){
            alert("사용할 이메일을 적어주세요.");
         }else{
            if(result.length==0){
               successEmail=$("input[name='email']").val();
               $("div[name='email_check']").append("사용 가능한 이메일입니다.");
               $("div[name='email_check']").css('color', 'blue');
               emailCnt++;
            }else{
               $("div[name='email_check']").append("이미 존재하는 이메일입니다.");
               $("div[name='email_check']").css('color', 'red');
               $("input[name='email']").val("");
            }
         }
      }
   });
}

function edit(){
   if(!confirm("회원을 수정하시겠습니까?")){
      return;
   }else if($("input[name='pass']").val()==""){
      alert("비밀번호를 입력하세요.");
      return;
   }else if($("input[name='nick']").val()==""){
      alert("닉네임을 입력하세요.");
      return;
   }else if($("input[name='email']").val()==""){
      alert("이메일을 입력하세요.");
      return;
   }else if(successNick!=$("input[name='nick']").val()){
      alert("닉네임 중복 체크를 다시 한 번 해주세요");
      return;
   }else if(beforeNick!=$("input[name='nick']").val() && nickCnt==0){
      alert("닉네임 중복 체크를 해주세요.");
      return;
   }else if(successEmail!=$("input[name='email']").val()){
      alert("이메일 중복 체크를 다시 한 번 해주세요");
      return;
   }else if(beforeEmail!=$("input[name='email']").val() && emailCnt==0){
      alert("이메일 중복 체크를 해주세요.");
      return;
   }
   
   $("form").attr({
      method:"post",
      action:"/admin/member/edit"
   });
   $("form").submit();
   alert("수정되었습니다");
}

function del(){
   if(!confirm("회원을 삭제하시겠습니까?")){
      return;
   }
   $("form").attr({
      method:"get",
      action:"/admin/member/delete"
   });
   $("form").submit();
}
</script>
</head>
<body>
   <h3>회원 정보</h3>
   <div class="container">
      <form enctype="multipart/form-data">
         <input type="hidden" name="member_id"/> 
          <label for="lname">아이디</label><p>
         <input type="text" name="id" readonly/><hr>
          <label for="lname">비밀번호</label><p>
         <input type="text" name="pass"/><hr>
          <label for="lname">이름</label><p>
         <input type="text" name="name" readonly/><hr>
          <label for="lname">닉네임</label><p>
         <input type="text" name="nick" style="width:40%"/>
         <input type="button" name="nick_check" value="중복 체크"/></p>
         <div name="nick_check"></div><hr>
          <label for="lname">이메일</label><p>
         <input type="text" name="email" style="width:40%"/>
         <input type="button" name="email_check" value="중복 체크"/></p> 
         <div name="email_check"></div><p>
      </form>
   </div>
   <input type="button" value="수정"/>
   <input type="button" value="삭제"/>
   <input type="button" value="목록"/>
</body>
</html>