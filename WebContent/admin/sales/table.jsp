<%@ page contentType="text/html; charset=UTF-8"%>
<%
	if (request.getSession().getAttribute("master") == null) {
		response.sendRedirect("/admin/sales/table");
	}

	int currentPage;
	if (request.getParameter("currentPage") == null) {
		currentPage = 1;
	} else {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css"
	href="/admin/static/css/barStyle.css" />
<link rel="stylesheet" type="text/css"
	href="/admin/static/css/tableStyle.css" />
<style>
#table {
	background-color: #4CAF50;
}
</style>
<%@ include file="/admin/inc/bar.jsp"%>
<script>
var total=0;

$(function(){
	getPager();
	getTotal();
	
	$($("button")[0]).click(function(){
		search();
	});
	$("input[type='text']").keydown(function(key) {
	    if (key.keyCode == 13) {
	    	search();
	    	event.preventDefault();
	    }
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
			str+="<tr>";
			str+="<td colspan='5'>";
			
			if(result.firstPage-1>0){
				str+="<a href='/admin/sales/table.jsp?currentPage="+result.firstPage-1+">◀</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"이전 페이지가 없습니다.\")'>◀</a>&nbsp&nbsp";
			}
			
			for(var i=result.firstPage; i<result.lastPage; i++){
				if(i>result.totalPage) break;
				if(i==result.currentPage){
					str+="<a class='pageNum' href='/admin/sales/table.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}else{
					str+="<a href='/admin/sales/table.jsp?currentPage="+i+"'>["+i+"]</a>&nbsp&nbsp";
				}
			}
			
			if(result.lastPage+1<=result.totalPage){
				str+="<a href='/admin/sales/table.jsp?currentPage="+result.lastPage+1+">▶</a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"다음 페이지가 없습니다.\")'>▶</a>&nbsp&nbsp";
			}
			
			str+="</td>";
			str+="</tr>";
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
    	 for(var i=1;i<=pager.pageSize;i++){
			if(pager.num<1) break;
         	var str="";
            str+="<tr class='sales-list'>";
            str+="<td>"+result[pager.curPos].game_name+"</td>";
            str+="<td>"+numberFormat(result[pager.curPos].game_price)+"</td>";
            getSales(result[pager.curPos].game_id, result[pager.curPos].game_price,str);
            
            pager.num--;
			pager.curPos++;
         }
      }
   });
}

function getSales(game_id,game_price,str){
   $.ajax({
	   url: "/rest/admin/salesGames",
		type: "get",
		data:{
			"game_id": game_id
		},
      success:function(result){ 
         str+="<td>"+result.length+"</td>";
    	 if(result.length==0){
    		 str+="<td>"+0+"</td>";
    	 }else{
    		 var tprice=0;
	         for(var i=0;i<result.length;i++){
	        	tprice+=game_price*(100-result[i].sales_rate)*0.01;
	         }
	         str+="<td>"+numberFormat(tprice)+"</td>"
    	 }
         str+="</tr>"; 
         $("table").append(str);
      }
   });
}

function getTotal(){
	$.ajax({
		url: "/rest/admin/totalSales",
		type: "get",
		success:function(result){
			$(".total").append("총 매출액 : "+numberFormat(result)+"원");
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
         if($("input[type='text']").val()==result.game_name){
               $("tfoot").html("");
               $(".sales-list").html("");
               
               var str="";
               str+="<tr class='sales-list'>";
               str+="<td>"+result.game_name+"</td>";
               str+="<td>"+numberFormat(result.game_price)+"</td>";
               searchSales(result.game_id,result.game_price,str);
            }else{
               alert("일치하는 게임이 없습니다.");
            }
      }
   });
}

function searchSales(game_id,game_price, str){
    $.ajax({
         url: "/rest/admin/salesGames",
         type: "get",
         data:{
            "game_id": game_id
         },
         success:function(result){ 
            
            str+="<td>"+result.length+"</td>";
            
             if(result.length==0){
                      str+="<td>"+0+"</td>";
               }else{
                     var tprice=0;
                      for(var i=0;i<result.length;i++){
                         tprice+=game_price*(100-result[i].sales_rate)*0.01;
                  }
                  str+="<td>"+numberFormat(tprice)+"</td>"
               }
                  str+="</tr>";
                  
                  $("table").append(str);
            }
    });
}
</script>
</head>
<body>
	<div>
		<h2>매출 관리</h2>
	</div>
	<div>
		<p class="total"></p>
		 <form class="example" action="action_page.php" onsubmit="return false">
         <input type="text" placeholder="게임 이름을 검색하세요" name="search">
         <button type="button" class="searchbt">
            <i class="fa fa-search"></i>
         </button>
      </form>
	</div>

	<table>
		<tr>
			<th>게임 이름</th>
			<th>게임 가격</th>
			<th>판매 개수</th>
			<th>판매 총액</th>
		</tr>
		<tfoot>
		</tfoot>
	</table>
</body>
</html>
