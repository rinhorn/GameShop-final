<%@ page contentType="text/html; charset=UTF-8"%>
<%
	if(request.getSession().getAttribute("master")==null){
		response.sendRedirect("/admin/event");
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
#event {
   background-color: #4CAF50;
}
</style>
<%@ include file="/admin/inc/bar.jsp" %>
<script>
$(function(){
	getPager();
   
   $($("button")[0]).click(function(){
	      eventSearch();
	   });
   $("input[type='text']").keydown(function(key) {
       if (key.keyCode == 13) {
    	   eventSearch();
       }
   });
   $($("button")[1]).click(function(){
      location.href="/admin/event/eventRegist.jsp";
   });
});

function getPager(){
	$.ajax({
		url:"/rest/admin/eventPagers",
		type:"get",
		data:{
			currentPage:<%=currentPage%>
		},
		success:function(result){
			var str="";
			str+="<tr><td colspan='5'>";
			
			if(result.firstPage-1>0){
				str+="<a href='/admin/event/index.jsp?currentPage="+result.firstPage-1+">◀</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"이전 페이지가 없습니다.\")'>◀</a>&nbsp&nbsp";
			}
			
			for(var i=result.firstPage; i<result.lastPage; i++){
				if(i>result.totalPage) break;
				if(i==result.currentPage){
					str+="<a class='pageNum' href='/admin/event/index.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}else{
					str+="<a href='/admin/event/index.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}
			}
			
			if(result.lastPage+1<=result.totalPage){
				str+="<a href='/admin/event/index.jsp?currentPage="+result.lastPage+1+">▶</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"다음 페이지가 없습니다.\")'>▶</a>&nbsp&nbsp";
			}
			
			str+="</td></tr>";
			$("tfoot").append(str);
			
			getEvent(result);
		}
	});
}

function getEvent(pager){
   $.ajax({
      url:"/rest/admin/events",
      type:"get",
      success:function(result){
         var str="";
         for(var i=1; i<=pager.pageSize; i++){
        	if(pager.num<1) break;
            str+="<tr class='event-list'>";
            str+="<td><img src='/data/event/"+result[pager.curPos].event_img+"' width='100px'/></td>";
            str+="<td><a href='/admin/event/eventDetail.jsp?event_id="+result[pager.curPos].event_id+"'>"+result[pager.curPos].event_name+"</a></td>";
            
            str+="<td><select name='select"+result[pager.curPos].event_id+"'>";
            getEventGame(result[pager.curPos].event_id);
            str+="</select></td>";
            
            str+="<td>"+result[pager.curPos].event_discount+"%</td>";
            str+="<td><img src='/data/event/"+result[pager.curPos].event_icon+"' width='70px'/></td>";
            str+="</tr>";
            
 			pager.num--;
 			pager.curPos++;
         }
         $("table").append(str);      
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
            str+="<option>"+result[i].game.game_name+"</option>";
         }
         $("select[name='select"+event_id+"']").append(str);
      }
   });
}

function eventSearch(){
	if($("input[name='search']").val()==""){
		alert("검색할 이벤트 이름을 입력하세요.");
		return;
	}
	
   $.ajax({
      url:"/rest/admin/eventsearch",
      type:"get",
      data:{
         event_name:$("input[name='search']").val()
      },
      success:function(result){
    	  $("tfoot").html("");
    	  
         if($("input[type='text']").val()==result.event_name){
            var str="";
            $(".event-list").html("");
            str+="<tr class='event-list'>";
            str+="<td><img src='/data/event/"+result.event_img+"' width='80px' height='60px'/></td>";
            str+="<td><a href='/admin/event/eventDetail.jsp?event_id="+result.event_id+"'>"+result.event_name+"</a></td>";
            str+="<td><select name='select"+result.event_id+"'>";
            getEventGame(result.event_id);
            str+="</select></td>";
            str+="<td>"+result.event_discount+"%</td>";
            str+="<td><img src='/data/event/"+result.event_icon+"' width='50px'/></td>";
            str+="</tr>";
            $("table").append(str);
         }else{
            alert("일치하는 이벤트가 없습니다.");
            return;
         }
      }
   });
}
</script>
</head>
<body>
   <div>
      <h2>이벤트 관리</h2>
   </div>
   <div>
      <form class="example" action="action_page.php" onsubmit="return false">
         <input type="text" placeholder="이벤트 이름을 검색하세요" name="search">
         <button type="button" class="searchbt">
            <i class="fa fa-search"></i>
         </button>
      </form>
   </div>
   <table>
      <tr>
         <th>이벤트 사진</th>
         <th>이벤트 이름</th>
         <th>해당 게임</th>
         <th>할인율</th>
         <th>이벤트 아이콘</th>
      </tr>
      <tfoot>
      </tfoot>
   </table>
   <button id='registBtn'>등록</button>
   
</body>
</html>