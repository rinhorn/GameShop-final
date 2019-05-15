<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/client/inc/top.jsp"%>
<%@ include file="/client/inc/style.jsp"%>
<%
	String[] game_id=request.getParameterValues("game_id");
%>
<!DOCTYPE html>
<html>
<head>
<script>
$(function(){
	<%if(session.getAttribute("member")==null){%>
		alert("로그인이 필요한 서비스입니다.");
		location.href="/client/login/index.jsp";
	<%}	%>
	
	$("#cancel").click(function(){
		location.href="/client/pay/cart.jsp";
	});
	$("#pay").click(function(){
		pay();
	});
	expmonth();
})

function expmonth(){
	for(var i=1; i<=12; i++){
		if(i<10){
			$("select").append("<option value='0"+i+"'>0"+i+"</option>");
		}else{
			$("select").append("<option value='"+i+"'>"+i+"</option>");
		}
	}
}

function pay(){
	if($("input[name='name']").val()==""){
		alert("이름을 입력하세요.");
		return;
	}else if($("input[name='email']").val()==""){
		alert("이메일을 입력하세요.");
		return;
	}else if($("input[name='addr1']").val()==""){
		alert("주소를 입력하세요.");
		return;
	}else if($("input[name='addr2']").val()==""){
		alert("상세주소를 입력하세요.");
		return;
	}else if($("input[name='zipcode']").val()==""){
		alert("우편번호를 입력하세요.");
		return;
	}else if($("input[name='cardname']").val()==""){
		alert("카드 명의자를 입력하세요.");
		return;
	}else if($("input[name='cardnumber']").val()==""){
		alert("카드 번호를 입력하세요.");
		return;
	}else if($("select").val()==""){
		alert("만료 월을 선택하세요.");
		return;
	}else if($("input[name='expyear']").val()==""){
		alert("만료 년을 입력하세요.");
		return;
	}else if($("input[name='cvc']").val()==""){
		alert("CVC를 입력하세요.");
		return;
	}
	
	$("#payForm").attr({
		action:"/client/sales/regist",
		method:"post"
	});
	$("#payForm").submit();
	
	alert("결제 완료");
}
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="payment">
<div class="row">
  <div class="col-75">
    <div class="container">
    <form id="payForm">
		<input type="hidden" name="member_id" value="<%=member.getMember_id() %>"/>
		<% for(int i=0;i<game_id.length;i++){%>
			<input type="hidden" name="game_id" value="<%=game_id[i]%>"/>
		<%} %>
    </form>
      <form>
      
        <div class="row">
          <div class="col-50">
            <h3>카드 청구서 주소</h3>
            <label for="fname"><i class="fa fa-user"></i> 이름</label>
            <input type="text" id="name" name="name" placeholder="이름 입력">
            <label for="email"><i class="fa fa-envelope"></i> 이메일</label>
            <input type="text" id="email" name="email" placeholder="이메일 입력">
            <label for="adr"><i class="fa fa-address-card-o"></i> 주소</label>
            <input type="text" id="addr1" name="addr1" placeholder="주소 입력 (도시명,구,동)">
            <label for="city"><i class="fa fa-institution"></i>상세주소</label>
            <input type="text" id="addr2" name="addr2" placeholder="상세주소 입력 (건물명,도로명,번지) ">
            <label for="city"><i class="fa fa-institution"></i>우편번호</label>
            <input type="text" id="zipcode" name="zipcode" placeholder="우편번호 입력">
          </div>

          <div class="col-50">
            <h3>결제</h3>
            <label for="fname">다음 유형으로 결제 가능합니다.</label>
            <div class="icon-container">
				<img src="/images/cards.PNG" width="200px">
            </div>
            <label for="cname">카드 명의자</label>
            <input type="text" id="cname" name="cardname">
            <label for="ccnum">신용/직불카드 번호</label>
            <input type="text" id="ccnum" name="cardnumber">
            <div class="row">
              <div class="col-50">
	            <label for="expmonth">만료 월</label>
	            <select name="expmonth">
	            	<option value="">월 선택</option>
	            </select>
              </div>
              <div class="col-50">
                <label for="expyear">만료 년</label>
                <input type="text" id="expyear" name="expyear">
              </div>
              <div class="col-50">
                <label for="cvc">CVC</label>
                <input type="text" id="cvc" name="cvc">
              </div>
            </div>
          </div>
        </div>
        <div class="btdiv">
	        <input type="button" value="취소" class="btn" id="cancel"/>
	        <input type="button" value="결제하기" class="btn" id="pay"/>
        </div>
      </form>
    </div>
  </div>
</div>
</div>

</body>
</html>