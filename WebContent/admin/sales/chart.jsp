<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/admin/inc/bar.jsp" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/admin/static/css/barStyle.css"/>
<style>
#chart {
   background-color: #4CAF50;
}

*, *:before, *:after {
   -moz-box-sizing: border-box;
   -webkit-box-sizing: border-box;
   box-sizing: border-box;
}

.chart-title {
   margin: 0 0 20px 0;
   padding: 0 0 5px 0;
   border-bottom: 1px solid #999;
   font-family: sans-serif;
   font-weight: normal;
   color: #333;
}

.container { 
   width: 700px; 
   height: 600px;
   margin: 20px;
   background: #fff;
   padding: 20px;
   overflow: hidden;
   float: left;
   border: 1px solid black;
}

/* Vertical */
.vertical .progress-bar {
   float: left;
   height: 440px;
   width: 45px;
   margin-right: 48px;
   margin-bottom: 20px;
   font-size: 13px;
   text-align: center;
}

.vertical .progress-track {
   position: relative;
   width: 45px;
   height: 100%;
   background: #ebebeb;
}

.vertical .progress-fill {
   position: relative;
   background: #825;
   height: 50%;
   width: 45px; 
   color: #fff;
   text-align: center;
   font-family: "Lato", "Verdana", sans-serif;
   font-size: 12px;
   line-height: 20px;
}

.rounded .progress-track, .rounded .progress-fill {
   box-shadow: inset 0 0 5px rgba(0, 0, 0, .2);
   border-radius: 3px;
}
</style>
<script src="/client/static/js/moment.js"></script>
<script>
var allTotal=0;
   $(function() {
      getData();
      getSalesDetail();
      vertical();
   });

   function getDate(){
      var today=moment().format('YY/MM/DD');
      var day;

      var str="";
      for(var i=0;i<7;i++){
         str+="<div class='progress-bar'>";
         str+="<div class='progress-track'>";
         str+="<div class='progress-fill' name='weekDiv'>";
         if(i==0){
            var merong=moment().format('MMDD');
            str+="<input type='hidden' value='0%' id='"+merong+"'/>";
         }else{
            var meron=moment().add(-i, 'days').format('MMDD');
            str+="<input type='hidden' value='0%' id='"+meron+"'/>";
         }
         str+="</div>";
         str+="</div>";
         if(i==0){
            day=today;
            str+="<text style='font-size:20px;'>"+moment().format('MM/DD')+"</text>";
            getSales(day, moment().format('MMDD').toString());
         }else{
            day=moment().add(-i, 'days').format('YY/MM/DD');
            str+="<text style='font-size:20px;'>"+moment().add(-i, 'days').format('MM/DD')+"</text>";
            getSales(day, moment().add(-i, 'days').format('MMDD'));
         }
         str+="</div>";
      }
      $("#7days_sales").append(str);
   }

   function getData(){
      $.ajax({
         url:"/rest/admin/sales/data",
         type:"get",
         success:function(result){
            for(var i=0;i<result.length;i++){
               for(var j=0;j<result[i].detailList.length;j++){
                  allTotal=allTotal+result[i].detailList[j].game.game_price;
               }
            }
            getDate();
         }
      });
   }
   
   function getSales(resultDay, type){
      $.ajax({
         url:"/rest/admin/sales",
         type:"get",
         data:{
            order_date:resultDay.toString()
         },
         success:function(result){
            var total=0;
            if(result.length!=0){
               for(var i=0;i<result.length;i++){
                  for(var j=0;j<result[i].detailList.length;j++){
                     total=total+result[i].detailList[j].game.game_price;
                  }
               }
               $("#"+type).val(total/allTotal*100+"%");
               vertical2();
            }
         }            
      });
   }

   function getSalesDetail(){
      $.ajax({
         url:"/rest/admin/sales/detail",
         type:"get",
         success:function(result){
            var str="";
            
            var checkId=[];            
            for(var i=0;i<result.length;i++){
            	if(i==6) break; 
               if(checkId.indexOf(result[i].game.game_id)==1 && i!=0){
                  getTopSales(result[i].game.game_id, result.length, -1);   
               }else{
                  checkId[i]=result[i].game.game_id;
                  if(i==0){
                     str+="<div class='progress-bar' style='margin-right:50px;margin-left:10px;'>";
                  }else{
                     str+="<div class='progress-bar' style='margin-right:50px;'>";
                  }
                  str+="<div class='progress-track'>";
                  str+="<div class='progress-fill' name='detailDiv'>";
                  str+="<input type='hidden' id='"+result[i].game.game_id+"'/>";
                  str+="<span id='"+i+"'></span>";
                  str+="</div>";
                  str+="</div>";
                  str+="<text>"+result[i].game.game_name+"</text>";
                  str+="</div>";
                  getTopSales(result[i].game.game_id, result.length, i);
               }
            }
            $("#topGames").append(str);
         }
      });
   }

   function getTopSales(id, total, index){
      $.ajax({
         url:"/rest/admin/sales/countGame",
         type:"get",
         data:{
            game_id:id
         },
         success:function(result){
            if(index==-1){
               $("#"+id).val($("#"+id).val().substring(0,($("#"+id).val().length-1))+"%");   
            }else{
               $("#"+id).val(result/total*100+"%");
               $("#"+index).html(result);
               vertical();
            }
         }
      });
   }
   
   function vertical() {
      $("div[name='detailDiv'] input").each(function() {
         var percent = $(this).val();
         var pTop = 100 - (percent.slice(0, percent.length - 1)) + "%";
         $(this).parent().css({
            'height' : percent,
            'top' : pTop
         });
      });
   }

   function vertical2() {
      $("div[name='weekDiv'] input").each(function() {
         var percent = $(this).val();
         var pTop = 100 - (percent.slice(0, percent.length - 1)) + "%";
         $(this).parent().css({
            'height' : percent,
            'top' : pTop
         });
      });
   }
</script>
</head>
<body>
   <div>
      <h2>매출 현황</h2>
   </div>
   <div class="container vertical flat" id="7days_sales">
      <h2 class="chart-title">최근 7일 매출 현황</h2>
      <h4 align="right">단위 : 10000원</h4>
   </div>
   
   <div class="container vertical flat" id="topGames">
      <h2 class="chart-title">Top 6 매출</h2> 
      <h4 align="right">단위 : 판매 개수</h4>
   </div>
</body>
</html>