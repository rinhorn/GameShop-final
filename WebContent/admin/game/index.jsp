<%@ page contentType="text/html; charset=UTF-8"%>
<%
	if(request.getSession().getAttribute("master")==null){
		response.sendRedirect("/admin/game");
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
<link rel="stylesheet" type="text/css" href="/admin/static/css/barStyle.css"/>
<link rel="stylesheet" type="text/css" href="/admin/static/css/tableStyle.css"/>
<style>
#game {
   background-color: #4CAF50;
}
</style>
<%@ include file="/admin/inc/bar.jsp" %>
<script>
$(function(){
	getPager();
   
	$($("button")[0]).click(function(){
			search();
	});
	$("input[type='text']").keydown(function(key) {
	    if (key.keyCode == 13) {
	 		search();
	    }
	});
	$("#registBtn").click(function(){
	   location.href="/admin/game/gameRegist.jsp";
	});
});

function getPager(){
	$.ajax({
		url:"/rest/admin/gamePagers",
		type:"get",
		data:{
			currentPage:<%=currentPage%>
		},
		success:function(result){
			var str="";
			str+="<tr><td colspan='6'>";
			
			if(result.firstPage-1>0){
				str+="<a href='/admin/game/index.jsp?currentPage="+result.firstPage-1+">◀</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"이전 페이지가 없습니다.\")'>◀</a>&nbsp&nbsp";
			}
			
			for(var i=result.firstPage; i<result.lastPage; i++){
				if(i>result.totalPage) break;
				if(i==result.currentPage){
					str+="<a class='pageNum' href='/admin/game/index.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}else{
					str+="<a href='/admin/game/index.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}
			}
			
			if(result.lastPage+1<=result.totalPage){
				str+="<a href='/admin/game/index.jsp?currentPage="+result.lastPage+1+">▶</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"다음 페이지가 없습니다.\")'>▶</a>&nbsp&nbsp";
			}
			
			str+="</td></tr>";
			$("tfoot").append(str);
			
			getList(result);
		}
	});
}

function getList(pager){
   $.ajax({
      url:"/rest/admin/games",
      type:"get",
      success:function(result){
         var str="";
         for(var i=1; i<=pager.pageSize; i++){
        	if(pager.num<1) break;
            str+="<tr class='game-list'>";
            getGame(result[pager.curPos].game_id);
            str+="<td><img name='"+result[pager.curPos].game_id+"' src='#'/></td>";
            str+="<td><a href='/admin/game/gameDetail.jsp?game_id="+result[pager.curPos].game_id+"'>";
            str+=result[pager.curPos].game_name;
            str+="</a></td>";
            str+="<td>"+numberFormat(result[pager.curPos].game_price)+"</td>";
            str+="<td>"+result[pager.curPos].game_sale+"%</td>";
            str+="<td>"+result[pager.curPos].game_company+"</td>";
            str+="<td>"+result[pager.curPos].game_date.substring(0,10)+"</td>";
            str+="</tr>";
            
			pager.num--;
			pager.curPos++;
         }
         $("table").append(str);
      }
   });
}

function getGame(game_id){
   $.ajax({
      url:"/rest/admin/game/images",
      type:"get",
      data:{
         game_id:game_id
      },
      success:function(result){
          $("img[name='"+game_id+"']").attr({
	           'src' : '/data/game/'+result[0].img_filename,
	           'width' : 100
           });
      }
   });
}

function search(){
	if($("input[name='search']").val()==""){
		alert("검색할 게임 이름을 입력하세요.");
		return;
	}
	
   $.ajax({
      url:"/rest/admin/searchgame",
      type:"get",
      data:{
         game_name:$("input[name='search']").val()
      },
      success:function(result){
    	  $("tfoot").html("");
    	  
         if($("input[type='text']").val()==result.game_name){
            var str="";
            $(".game-list").html("");
            str+="<tr class='game-list'>";
            getGame(result.game_id);
            str+="<td><img name='"+result.game_id+"' src='#'/></td>";
            str+="<td><a href='/admin/game/gameDetail.jsp?game_id="+result.game_id+"'>";
              str+=result.game_name;
              str+="</a></td>";
            str+="<td>"+numberFormat(result.game_price)+"</td>";
            str+="<td>"+result.game_sale+"%</td>";
            str+="<td>"+result.game_company+"</td>";
            str+="<td>"+result.game_date.substring(0,10)+"</td>";
            str+="</tr>";
            
            $("table").append(str);
         }else{
            alert("일치하는 게임이 없습니다.");
            return;
         }
      }
   });
}
function numberFormat(num){
   var numstr=num.toString(); 
   var len=numstr.length;
   var result="";
   if(Math.floor(num/1000000)>0){
		result=(Math.floor(num/1000000)).toString()+","+numstr.substring(len-6, len-3)+","+numstr.substring(len-3);
   }else if(Math.floor(num/1000)>0){
		result=(Math.floor(num/1000)).toString()+","+numstr.substring(len-3);  
	}
   return result;
}
</script>
</head>
<body>
   <div>
      <h2>게임 관리</h2>
   </div>
   <div>
   <form class="example" action="action_page.php" onsubmit="return false">
         <input type="text" placeholder="게임 이름을 검색하세요" name="search">
         <button type="button" class="searchbt">
            <i class="fa fa-search"></i>
         </button>
   </form>
   </div>
   <table>
         <tr>
         <th>사진</th>
         <th>이름</th>
         <th>가격</th>
         <th>할인율</th>
         <th>제작사</th>
         <th>출시일</th>
         </tr>
         <tfoot>
        </tfoot>
   </table>
   <button id='registBtn'>등록</button>
</body>
</html>