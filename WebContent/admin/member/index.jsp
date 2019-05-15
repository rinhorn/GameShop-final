<%@ page contentType="text/html; charset=UTF-8"%>
<%
	if(request.getSession().getAttribute("master")==null){
		response.sendRedirect("/admin/member");
	}

	int currentPage;
	if(request.getParameter("currentPage")==null){
		currentPage=1;
	}else{
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="/admin/static/css/tableStyle.css"/>
<link rel="stylesheet" type="text/css" href="/admin/static/css/barStyle.css"/>
<style>
#member {
	background-color: #4CAF50;
}
</style>
<%@ include file="/admin/inc/bar.jsp" %>
<script>
$(function(){
	getPager();
	
	$(".searchbt").click(function(){
		search();
	});
	$("input[type='text']").keydown(function(key) {
       if (key.keyCode == 13) {
    	   search();
       }
   	});
});

function getPager(){
	$.ajax({
		url:"/rest/admin/memberPagers",
		type:"get",
		data:{
			currentPage:<%=currentPage%>
		},
		success:function(result){
			var str="";
			str+="<tr>";
			str+="<td colspan='5'>";
			
			if(result.firstPage-1>0){
				str+="<a href='/admin/member/index.jsp?currentPage="+result.firstPage-1+">◀</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"이전 페이지가 없습니다.\")'>◀</a>&nbsp&nbsp";
			}
			
			for(var i=result.firstPage; i<result.lastPage; i++){
				if(i>result.totalPage) break;
				if(i==result.currentPage){
					str+="<a class='pageNum' href='/admin/member/index.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}else{
					str+="<a href='/admin/member/index.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}
			}
			
			if(result.lastPage+1<=result.totalPage){
				str+="<a href='/admin/member/index.jsp?currentPage="+result.lastPage+1+">▶</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"다음 페이지가 없습니다.\")'>▶</a>&nbsp&nbsp";
			}
			
			str+="</td>";
			str+="</tr>";
			$("tfoot").append(str);
			
			getMember(result);
		}
	});
}

function getMember(pager){
	$.ajax({
		url:"/rest/admin/members",
		type:"get",
		success:function(result){
			var str="";
			for(var i=1;i<=pager.pageSize;i++){
				if(pager.num<1) break;
				str+="<tr class='member-list'>";
				str+="<td><a href='/admin/member/memberDetail.jsp?member_id="+result[pager.curPos].member_id+"'>"+result[pager.curPos].id+"</a></td>";
				str+="<td>"+result[pager.curPos].pass+"</td>";
				str+="<td>"+result[pager.curPos].name+"</td>";
				str+="<td>"+result[pager.curPos].nick+"</td>";
				str+="<td>"+result[pager.curPos].email+"</td>";
				str+="</tr>";
				
				pager.num--;
				pager.curPos++;
			}
			$("table").append(str);
		}
	});
}

function search(){
	if($("input[name='search']").val()==""){
		alert("검색할 회원 아이디를 입력하세요.");
		return;
	}
	
	$.ajax({
		url:"/rest/admin/membersearch",
		type:"get",
		data:{
			id:$("input[name='search']").val()
		},
		success:function(result){
			$("tfoot").html("");
			
			var re=$("input[type='text']").val();
			
			if($("input[type='text']").val()==result.id){
				var str=""; 
				$(".member-list").html(""); 
				str+="<tr class='member-list'>";
				str+="<td><a href='/admin/member/memberDetail.jsp?member_id="+result.member_id+"'>"+result.id+"</a></td>";
				str+="<td>"+result.pass+"</td>";
				str+="<td>"+result.name+"</td>";
				str+="<td>"+result.nick+"</td>";
				str+="<td>"+result.email+"</td>";
				str+="</tr>";

				$("table").append(str);
			}else{
				alert("일치하는 회원이 없습니다.");
				return;
			}
		}
	});
}
</script>
</head>
<body>
	<div>
		<h2>회원 관리</h2>
	</div>
	<div>
	  <form class="example" action="action_page.php" onsubmit="return false">
         <input type="text" placeholder="회원 아이디를 검색하세요" name="search">
         <button type="button" class="searchbt">
            <i class="fa fa-search"></i>
         </button>
      </form>
	</div>

	<table>
		<tr>
			<th width="15%">아이디</th> 
			<th width="50%">비밀번호</th>
			<th>이름</th>
			<th>닉네임</th>
			<th>이메일</th>
		</tr>
		<tfoot>
		</tfoot>
	</table>
</body>
</html>