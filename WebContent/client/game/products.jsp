<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/client/inc/style.jsp"%>
<%@ include file="/client/inc/top.jsp"%>
<%!
	int currentPage;
	int category_id;
	String type;
%>
<%
	if(request.getParameter("currentPage")==null){
		currentPage=1;
	}else{
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}
	
	if(request.getParameter("category_id")==null){
		category_id=-1;
	}else{
		category_id=Integer.parseInt(request.getParameter("category_id"));
	}
	
	if(request.getParameter("type")==null){
		type=null;
	}else{
		type=request.getParameter("type");
	}
%>
<html>
<head>
<script>
var currentPage=1;
var type=null; 
var category_id=0;

$(function(){
  	 getCategories(); 
  	 
	<% if(category_id==-1 && type==null){%>
			getPager();
  	<%}else{%>
  			currentPage=<%=currentPage%>;
  			type=<%=type%>;
  			category_id=<%=category_id%>;
  			
  			$("#sortList").val(type);
  			getSortPager();
  	<%}%>
})

function getPager(){
	$.ajax({
		url:"/rest/client/gamePagers",
		type:"get",
		data:{
			currentPage:<%=currentPage%>
		},
		success:function(result){
			$(".pagination-bar").html("");
			var str="";
			
			if(result.firstPage-1>0){
				str+="<a href='/client/game/products.jsp?currentPage="+result.firstPage-1+"'><font color='black'>◀</font></a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"이전 페이지가 없습니다.\")'><font color='black'>◀</font></a>&nbsp&nbsp";
			}
			
			for(var i=result.firstPage; i<result.lastPage; i++){
				if(i>result.totalPage) break;
				if(i==result.currentPage){
					str+="<a class='pageNum' href='/client/game/products.jsp?currentPage="+i+"'><font size='5px'>["+i+"]</font></a>&nbsp&nbsp";
				}else{
					str+="<a href='/client/game/products.jsp?currentPage="+i+"''><font color='black'>["+i+"]</font></a>&nbsp&nbsp";
				}
			}
			
			if(result.lastPage+1<=result.totalPage){
				str+="<a href='/client/game/products.jsp?currentPage="+result.lastPage+1+"'><font color='black'>▶</font></a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"다음 페이지가 없습니다.\")'><font color='black'>▶</font></a>&nbsp&nbsp";
			}
			
			$(".pagination-bar").append(str);
			
			getGames(result);
		}
	});
}

function getGames(pager) {
      $.ajax({
          url : "/rest/client/gameList",
          type : "get",
          success : function(result) {
             var str = "";
             for (var i=1; i<=pager.pageSize; i++) {
            	 if(pager.num<1) break;
                str += "<div class='product'>";
                str += "<div class='inner-product'>";
                str += "<div id='game-event-icon' name='icon"+result[pager.curPos].game_id+"'></div>";
				isEventGame(result[pager.curPos].game_id);
                str += "<div class='figure-image'>";
                getImages(result[pager.curPos].game_id);
                str += "<a href='/client/game/single.jsp?game_id="+result[pager.curPos].game_id+"'><img name='"+result[pager.curPos].game_id+"'></a>";
                str += "</div>"
                str += "<h3 class='product-title'><a href='/client/game/single.jsp?game_id="+result[pager.curPos].game_id+"'>"
                      + result[pager.curPos].game_name + "</a></h3>";
                      
                if(result[pager.curPos].game_sale!=0){
                   str+="<small class='price'><del>"+numberFormat(result[pager.curPos].game_price)+"원</del>";  
                   str+="&nbsp&nbsp <font size='4px' color='red'>"+result[pager.curPos].game_sale+"%</font></small>"
                      var sale_price=result[pager.curPos].game_price*(100-result[pager.curPos].game_sale)*0.01;
                   str+="<small class='price'>"+numberFormat(sale_price)+"원</small>";
                }else{
                   str += "<small class='price'>"
                      + numberFormat(result[pager.curPos].game_price) + "원</small>";
                   str+="<small class='price' style='height:20px'></small>";
                }
                if(result[pager.curPos].game_detail.length>85){
                         str += "<p>" + result[pager.curPos].game_detail.substring(0,85) + "...</p>";
                     }else{
                         str += "<p>" + result[pager.curPos].game_detail + "</p>";
                      }
                str += "<a href='#' onclick='loginCheck("+result[pager.curPos].game_id+","+0+")' class='button'>장바구니에 추가</a>&nbsp";
                str += "<a href='#' onclick='loginCheck("+result[pager.curPos].game_id+","+1+")' class='button' style='background-color:orange'>구매하기</a>";
                str += "</div>";
                str += "</div>";
                
                pager.num--;
				pager.curPos++;
             }
             $(".product-list").append(str);
          }
       });
   }
   
function getCategories(){
   $.ajax({
      url:"/rest/client/game/category",
      type:"get",
      success:function(result){
         var str="";
         str+="<option value='0'>모두</option>";
         for(var i=0;i<result.length;i++){
            str+="<option value='"+result[i].category_id+"'>"+result[i].category_name+"</option>";
         }
         $("select[name='category_id']").append(str);
         $("select[name='category_id']").val(category_id); 
      }      
   });
}

function getImages(game_id){
   $.ajax({
      url:"/rest/admin/game/images",
      type:"get",
      data:{
         game_id:game_id
      },
      success:function(result){
         $("img[name='"+game_id+"']").attr({
            'src':'/data/game/'+result[0].img_filename
         });
      } 
   });
}

function isEventGame(game_id){
	$.ajax({
		url : "/rest/client/existGames",
		type : "get",
		data : {
			game_id : game_id
		},
		success : function(result) {
			if(result.length!=0){
				$("div[name='icon"+game_id+"']").html("");
				$("div[name='icon"+game_id+"']").append("<img src='/data/event/"+result[0].event.event_icon+"'>");
			}
		}
	});
}

function sortBt(){
	currentPage=1;
	type=$("#sortList").val();
	category_id=$("select[name='category_id']").val();
	getSortPager();
}

function getSortPager(){
	$.ajax({
		url:"/rest/client/gameSortPagers",
		type:"get",
		data:{
			currentPage:currentPage,
			"type":type,
		    "category_id":category_id
		},
		success:function(result){
			$(".pagination-bar").html("");
			var str=""; 
			
			if(result.firstPage-1>0){
				str+="<a href='/client/game/products.jsp?currentPage="+result.firstPage-1+"&category_id="+category_id+"&type="+type+"'><font color='black'>◀</font></a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"이전 페이지가 없습니다.\")'><font color='black'>◀</font></a>&nbsp&nbsp";
			}
			
			for(var i=result.firstPage; i<result.lastPage; i++){
				if(i>result.totalPage) break;
				if(i==result.currentPage){
					str+="<a class='pageNum' href='/client/game/products.jsp?currentPage="+i+"&category_id="+category_id+"&type="+type+"'><font size='5px'>["+i+"]</font></a>&nbsp&nbsp";
				}else{
					str+="<a href='/client/game/products.jsp?currentPage="+i+"&category_id="+category_id+"&type="+type+"'><font color='black'>["+i+"]</font></a>&nbsp&nbsp";
				}
			}
			
			if(result.lastPage+1<=result.totalPage){
				str+="<a href='/client/game/products.jsp?currentPage="+result.lastPage+1+"&category_id="+category_id+"&type="+type+"'><font color='black'>▶</font></a>&nbsp&nbsp";
			}else{
				str+="<a href='javascript:alert(\"다음 페이지가 없습니다.\")'><font color='black'>▶</font></a>&nbsp&nbsp"; 
			}
			
			$(".pagination-bar").append(str);
			
			sort(result);
		}
	});
}
 
function sort(pager){
   $.ajax({
      url:"/rest/client/game/sort",
      type:"get",
      data:{
    	  "type":type,
		  "category_id":category_id
      },
      success:function(result){
         $(".product-list").html("");
		 var str = "";
         for (var i=1; i<=pager.pageSize; i++) { 
        	if(pager.num<1) break;        
	
            str += "<div class='product'>";
            str += "<div class='inner-product'>";
            str += "<div id='game-event-icon' name='icon"+result[pager.curPos].game_id+"'></div>";
			isEventGame(result[pager.curPos].game_id);
            str += "<div class='figure-image'>";
            str += "<input type='hidden' id='game_id' value='"+result[pager.curPos].game_id+"'/>";
            getImages(result[pager.curPos].game_id);
            str += "<a href='/client/game/single.jsp?game_id="+result[pager.curPos].game_id+"'><img name='"+result[pager.curPos].game_id+"'></a>";
            str += "</div>"
            str += "<h3 class='product-title'><a href='/client/game/single.jsp?game_id="+result[pager.curPos].game_id+"'>"
                  + result[pager.curPos].game_name + "</a></h3>";
                  
            if(result[pager.curPos].game_sale!=0){
               str+="<small class='price'><del>"+numberFormat(result[pager.curPos].game_price)+"원</del>";  
               str+="&nbsp&nbsp <font size='4px' color='red'>"+result[pager.curPos].game_sale+"%</font></small>"
                  var sale_price=result[pager.curPos].game_price*(100-result[pager.curPos].game_sale)*0.01;
               str+="<small class='price'>"+numberFormat(sale_price)+"원</small>";
            }else{
               str += "<small class='price'>"+ numberFormat(result[pager.curPos].game_price) + "원</small>";
               str+="<small class='price' style='height:20px'></small>";
            }
            if(result[pager.curPos].game_detail.length>85){
                str += "<p>" + result[pager.curPos].game_detail.substring(0,85) + "...</p>";
            }else{
                str += "<p>" + result[pager.curPos].game_detail + "</p>";
            }
            str += "<a href='#' onclick='loginCheck("+result[pager.curPos].game_id+","+0+")' class='button'>장바구니에 추가</a>&nbsp";
            str += "<a href='#' onclick='loginCheck("+result[pager.curPos].game_id+","+1+")' class='button' style='background-color:orange'>구매하기</a>";
            str += "</div>";
            str += "</div>";
            
            pager.num--;
			pager.curPos++;
	   }
       $(".product-list").append(str);
      }
   });
}

function loginCheck(game_id, type){
   <%if(member==null){%> 
   alert("로그인이 필요한 서비스입니다");
   <%}else{%>
   checkMyGame(game_id,type);
   <%}%>
}

<%if(member!=null){%>
function checkMyGame(game_id,type){
	$.ajax({
		url:"/rest/client/game/myPage",
		type:"get",
		data:{
			"member_id":<%=member.getMember_id()%>
		},
		success:function(result){
			for(var i=0;i<result.length;i++){
				for(var j=0;j<result[i].detailList.length;j++){
					if(result[i].detailList[j].game.game_id==game_id){
						alert("이미 구매한 게임입니다");
						return;
					}
				}
			}
			if(type==0){
				checkCart(game_id);
			}else if(type==1){
				location.href="/client/pay/pay.jsp?game_id="+game_id;
			}
		}
	});
}
<%}%>

<%if(member!=null){%>
function checkCart(game_id){
   $.ajax({
      url:"/rest/client/pay/cart/game",
      type:"get",
      data:{
         "game_id":game_id,
         "member_id":<%=member.getMember_id()%>
      },
      success:function(result){
         if(result!=""){
            alert("이미 장바구니에 추가한 게임입니다");
            return;
         }else{
            registCart(game_id);
         }
      }
   });
}
<%}%>

function registCart(game_id){
   $("input[name='game_id']").val(game_id);
   $("form").attr({
      action:"/client/pay/cart/regist",
      method:"post"
   });
   $("form").submit();
   alert("장바구니에 상품이 등록되었습니다");
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
<form style="display:none">
   <%if (member != null) {%>
   <input type="hidden" value="<%=member.getMember_id()%>" name="member_id" />
   <%}%>
   <input type="hidden" name="game_id" />
</form>
<body bgcolor="#2b2b2b">
   <div id="site-content" style="background-color:#2b2b2b">
      <!-- Top -->
      <main class="main-content">
      <div class="container">
         <div class="page">
            <div class="filter-bar">
               <div class="filter">
                  <span> <label>정렬 :</label> 
                  <select id="sortList">   
                        <option value="0">정렬</option>
                        <option value="1">이름 순</option>
                        <option value="2">가격 순</option>
                        <option value="3">최신 상품 순</option>
                        <option value="4">인기 순</option>
                  </select>
                  </span>
                  <span><label>카테고리 :</label>
                  <select name="category_id">
                  </select>
                  <a class="button" onclick="sortBt()">정렬</a> 
                  </span>
               </div>
               <!-- .filter -->
            </div>
            <!-- .filter-bar -->
            <div class="product-list"></div>
            <!-- .product-list -->
            <div class="pagination-bar">
            </div>
         </div>
      </div>
      </main>
</body>
</html>