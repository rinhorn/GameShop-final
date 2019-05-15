<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head>
<link rel="stylesheet"
   href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
   integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
   crossorigin="anonymous">
<link rel="stylesheet" type="text/css"
   href="/client/static/css/loginStyle.css" />
<script src="https://code.jquery.com/jquery-3.1.1.min.js"
   integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
   crossorigin="anonymous"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<script>
   var isCheckId = false;
   var isCheckNick = false;
   var isCheckEmail = false;
   var successId;
   var successNick;
   var successEmail;

   $(function() {
      $(".veen .rgstr-btn button").click(function() {
         $('.veen .wrapper').addClass('move');
         $('.body').css('background', '#e0b722');
         $(".veen .login-btn button").removeClass('active');
         $(this).addClass('active');
      });
      $(".veen .login-btn button").click(function() {
         $('.veen .wrapper').removeClass('move');
         $('.body').css('background', '#ff4931');
         $(".veen .rgstr-btn button").removeClass('active');
         $(this).addClass('active');
      });
      $($("input[type='button']")[0]).click(function() {
         login();
      });
      $($("input[type='button']")[1]).click(function() {
         idCheck();
      });
      $($("input[type='button']")[2]).click(function() {
         nickCheck();
      });
      $($("input[type='button']")[3]).click(function() {
         emailCheck();
      });
      $($("input[type='button']")[4]).click(function() {
         register();
      });
   });
   function login() {
      if ($("#login input[name='id']").val() == "") {
         alert("아이디를 입력하세요.");
         return;
      } else if ($("#login input[name='pass']").val() == "") {
         alert("비밀번호를 입력하세요.");
         return;
      }
      $("#login").attr({
         method : "post",
         action : "/client/member/login"
      });
      $("#login").submit();
   }
   function idCheck() {
      $.ajax({
         url : "/rest/client/member/checkId",
         type : "get",
         data : {
            id : $("#register input[name='id']").val()
         },
         success : function(result) {
            $("div[name='id_check']").html("");
            if ($("#register input[name='id']").val() == "") {
               alert("사용할 아이디를 적어주세요.");
            } else {
               if (result.length == 0) {
                  $("div[name='id_check']").append("사용 가능한 아이디입니다.");
                  $("div[name='id_check']").css('color', 'blue');
                  successId=$("#register input[name='id']").val();
                  isCheckId = true;
               } else {
                  $("div[name='id_check']").append("이미 존재하는 아이디입니다.");
                  $("div[name='id_check']").css('color', 'red');
                  $("#register input[name='id']").val("");
                  isCheckId = false;
               }
            }
         }
      });
   }
   function nickCheck() {
      $.ajax({
         url : "/rest/client/member/checkNick",
         type : "get",
         data : {
            nick : $("#register input[name='nick']").val()
         },
         success : function(result) {
            $("div[name='nick_check']").html("");
            if ($("#register input[name='nick']").val() == "") {
               alert("사용할 닉네임을 적어주세요.");
            } else {
               if (result.length == 0) {
                  $("div[name='nick_check']").append("사용 가능한 닉네임입니다.");
                  $("div[name='nick_check']").css('color', 'blue');
                  successNick=$("#register input[name='nick']").val();
                  isCheckNick = true;
               } else {
                  $("div[name='nick_check']").append("이미 존재하는 닉네임입니다.");
                  $("div[name='nick_check']").css('color', 'red');
                  $("#register input[name='nick']").val("");
                  isCheckNick = false;
               }
            }
         }
      });
   }
   function emailCheck() {
      $.ajax({
         url : "/rest/client/member/checkEmail",
         type : "get",
         data : {
            email : $("#register input[name='email']").val()
         },
         success : function(result) {
            $("div[name='email_check']").html("");
            if ($("#register input[name='email']").val() == "") {
               alert("사용할 이메일을 적어주세요.");
            } else {
               if (result.length == 0) {
                  $("div[name='email_check']").append("사용 가능한 이메일입니다.");
                  $("div[name='email_check']").css('color', 'blue');
                  successEmail=$("#register input[name='email']").val();
                  isCheckEmail = true;
               } else {
                  $("div[name='email_check']").append("이미 존재하는 이메일입니다.");
                  $("div[name='email_check']").css('color', 'red');
                  $("#register input[name='email']").val("");
                  isCheckEmail = false;
               }
            }
         }
      });
   }
   function register() {
      if ($("#register input[name='id']").val() == "") {
         alert("아이디를 입력하세요.");
         return;
      } else if (isCheckId != true || successId!=$("#register input[name='id']").val()) {
         alert("아이디 중복체크를 해주세요.");
         return;
      } else if ($("#register input[name='pass']").val() == "") {
         alert("비밀번호를 입력하세요.");
         return;
      } else if ($("#register input[name='name']").val() == "") {
         alert("이름을 입력하세요.");
         return;
      } else if ($("#register input[name='nick']").val() == "") {
         alert("닉네임을 입력하세요.");
         return;
      } else if (isCheckNick != true || successNick!=$("#register input[name='nick']").val()) {
         alert("닉네임 중복체크를 해주세요.");
         return;
      } else if ($("#register input[name='email']").val() == "") {
         alert("이메일을 입력하세요.");
         return;
      } else if (isCheckEmail != true || successEmail!=$("#register input[name='email']").val()) {
         alert("이메일 중복체크를 해주세요.");
         return;
      }
      $("#register").attr({
         method : "post",
         action : "/client/member/register"
      });
      $("#register").submit();
      alert("회원가입 완료");
   }
</script>
</head>
<body>
   <div class="body">
      <div class="veen">
         <div class="login-btn splits">
            <p>이미 회원이십니까?</p>
            <button class="active">로그인</button>
         </div>
         <div class="rgstr-btn splits">
            <p>계정이 존재하지 않습니까?</p>
            <button>회원가입</button>
         </div>
         <div class="wrapper">
            <form id="login" tabindex="500">
               <h3>로그인</h3>
               <div class="id">
                  <input type="id" name="id"> <label>아이디</label>
               </div>
               <div class="pass">
                  <input type="password" name="pass"> <label>비밀번호</label>
               </div>
               <div class="submit">
                  <input type="button" class="dark" name="login" value="로그인" />
               </div>
            </form>
            <form id="register" tabindex="502">
               <h3>회원가입</h3>
               <div class="id">
                  <input type="text" name="id"> <label>아이디</label> <input
                     type="button" name="idCheck" value="중복체크" />
                  <div class="check" name="id_check"></div>
               </div>
               <div class="pass">
                  <input type="password" name="pass"> <label>비밀번호</label>
               </div>
               <div class="name">
                  <input type="text" name="name"> <label>이름</label>
               </div>
               <div class="nick">
                  <input type="text" name="nick"> <label>닉네임</label> <input
                     type="button" name="nickCheck" value="중복체크" />
                  <div class="check" name="nick_check"></div>
               </div>
               <div class="email">
                  <input type="text" name="email"> <label>이메일</label> <input
                     type="button" name="emailCheck" value="중복체크" />
                  <div class="check" name="email_check"></div>
               </div>
               <div class="submit">
                  <input type="button" class="dark" name="register" value="회원가입" />
               </div>
            </form>
         </div>
      </div>
   </div>
</body>
</html>