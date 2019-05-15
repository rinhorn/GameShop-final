<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="game.model.domain.Member"%>
<%@ include file="/client/inc/top.jsp"%>
<%@ include file="/client/inc/style.jsp"%>
<%!Member member;%>
<%
   String member_id=request.getParameter("member_id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
<style>
html, body {
	background-color: #2b2b2b; 
}

.wrapper {
   background-color: #e9e9e9; 
   width: 550px;
   margin: auto;
   margin-top: 50px; 
   padding: 20px 20px 0 20px;
   border: 2px solid #ccc;
   border-radius: 7px;
}

.container legend { 
   color: #ccc;
   margin: 0 0 0 280px;
   padding: 0;
   letter-spacing: 2px;
}

.wrap {
   margin: 0 0 20px 0;
}


.lbl-tb {
   font-size: 15px;
   text-transform: uppercase;
}

.frm-ctrl {
   background: transparent;
   margin: 5px 0;
   padding: 5px;
   border: 1px solid #ccc;
   border-radius: 3px;
   outline: none;
   font-family: Calibri;
}

.tb {
   width: 100%;
   font-size: 17px;
}

input[type="text"], input[type="password"] { 
	background-color: #fff;
}

.edit-button {
   width: 150px;
   height: 40px;
   text-transform: uppercase;
   letter-spacing: 2px;
   cursor: pointer;
   transition: all 0.2s
}

.edit-button:hover {
   background: #46a260;
}

.edit-button:active {
   border: 1px solid #333;
}
</style>
<script>
var beforeNick;
var beforeEmail;
var successNick;
var successEmail;
var countNick=0;
var countEmail=0;
$(function() {
   <%if (session.getAttribute("member") == null) {%>
	         alert("로그인이 필요한 서비스입니다.");
	         location.href = "/client/login/index.jsp";
   <%}else {
         	member = (Member) session.getAttribute("member");
  		}%>
   
   memberDetail();
   
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
      cancel();
   });
   $($("input[type=button]")[4]).click(function(){
      del();
   });
});
function memberDetail(){
   $.ajax({
      url : "/rest/client/profile",
      type : "get",
      data : {
         "member_id" : "<%=member.getMember_id() %>"
      },
      success : function(result) {
         beforeNick=result.nick;
         beforeEmail=result.email;
         successNick=beforeNick;
         successEmail=beforeEmail;
         $("input[name='nick']").val(result.nick);
         $("input[name='email']").val(result.email);
      }
   });
}
function checkNick(){
   $.ajax({
      url:"/rest/client/member/checkNick",
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
               countNick++;
               successNick=$("input[name='nick']").val();
               $("div[name='nick_check']").append("사용 가능한 닉네임입니다.");
               $("div[name='nick_check']").css('color', 'blue');
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
      url:"/rest/client/member/checkEmail",
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
               countEmail++;
               successEmail=$("input[name='email']").val();
               $("div[name='email_check']").append("사용 가능한 이메일입니다.");
               $("div[name='email_check']").css('color', 'blue');
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
   }else if($("input[name='pass']").val()!=$("input[name='pass2']").val()){
      alert("비밀번호를 다시 한번 확인해주세요");
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
   }else if(countNick==0 && beforeNick!=$("input[name='nick']").val()){
       alert("닉네임 중복 체크를 해주세요.");
       return;
   }else if(successEmail!=$("input[name='email']").val()){
        alert("이메일 중복 체크를 다시 한 번 해주세요");
        return;
   }else if(countEmail==0 && beforeEmail!=$("input[name='email']").val()){
       alert("이메일 중복 체크를 해주세요.");
       return;
    }
   
      alert("수정이 완료되었습니다.");
      $("form").attr({
         method:"post",
         action:"/client/member/edit"
      });
      $("form").submit();
}
function cancel(){
   $(location).attr("href", "index.jsp");
}
function del(){
   if(!confirm("정말 탈퇴하시겠습니까?")){
      return;
   }
   $("form").attr({
      method:"get",
      action:"/client/member/delete"
   });
   $("form").submit();
}
</script>
</head>
<body>
   <fieldset class="wrapper">
      <form>
      <legend>
         <i class="fa fa-empire fa-4x"></i>
      </legend>
      <input type="hidden" name="member_id" value="<%=member.getMember_id()%>"/> 
      <div class="wrap">
         <label for="tbUnm" class="lbl-tb">
         <i class="fa fa-user fa-fw"></i>
            아이디
         </label> <br /> 
         <input name="id" id="tbUnm" type="text" class="frm-ctrl tb" value="<%=member.getId()%>"readonly/>
      </div>
      <div class="wrap">
         <label for="tbPwd1" class="lbl-tb">
         <i class="fa fa-unlock fa-fw"></i> 
         비밀번호
         </label> 
         <br /> 
         <input name="pass" id="tbPwd1" type="password" class="frm-ctrl tb" />
      </div>
      <div class="wrap">
         <label for="tbPwd2" class="lbl-tb">
         <i class="fa fa-unlock fa-fw"></i> 
         비밀번호 확인
         </label> 
         <br /> 
         <input name="pass2" id="tbPwd2" type="password" class="frm-ctrl tb" />
      </div>
      <div class="wrap">
         <label for="tbUnm" class="lbl-tb">
         <i class="fa fa-user fa-fw"></i>
            이름
         </label> <br /> 
         <input name="name" id="tbUnm" type="text" class="frm-ctrl tb" value="<%=member.getName()%>" readonly/>
      </div>
      <div class="wrap">
         <label for="tbUnm" class="lbl-tb">
         <i class="fa fa-user fa-fw"></i>
            닉네임
         </label> <br /> 
         <input name="nick" id="tbUnm" type="text" class="frm-ctrl tb" value="<%=member.getNick()%>" style="width:80%"/>
         <input type="button" name="nick_check"" value="중복 체크"/>
      </div>
      <div name="nick_check"></div></br>
      <div class="wrap">
         <label for="tbEmail" class="lbl-tb">
         <i class="fa fa-envelope-o fa-fw"></i> 
           이메일
         </label>
         <br /> 
         <input name="email" id="tbEmail" type="text" class="frm-ctrl tb" value="<%=member.getEmail()%>" style="width:80%"/>
         <input name="email_check" type="button" value="중복 체크"/>
      </div>
      <div name="email_check"></div></br>
      <div class="wrap">
         <input type="button" class="frm-ctrl edit-button" value="수정"/>
         <input type="button" class="frm-ctrl edit-button" value="취소"/>
         <input type="button" class="frm-ctrl edit-button" value="회원 탈퇴"  style="background:red;"/>
      </div>
</form>
   </fieldset>
</body>
</html>