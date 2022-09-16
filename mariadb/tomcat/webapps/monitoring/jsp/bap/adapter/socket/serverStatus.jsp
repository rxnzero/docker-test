<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" >

function control(startStop, group, adapter){
    var startStopStr = '기동';
    if ( startStop == 'STOP_SOCKET_SERVER' ){
        startStopStr = '중지';
    }
    if ( confirm( "어댑터 그룹[" + group + "], 어댑터 명[" + adapter+ "]을 " + startStopStr + "하시겠습니까?" ) != true ){
        return;
    }
    	var postData = new Array();
    	postData.push({ name: "cmd"       , value:"CONTROL"});
    	postData.push({ name: "startStop" , value:startStop});
    	postData.push({ name: "group"     , value:group});
    	postData.push({ name: "adapter"   , value:adapter});
    	$.ajax({
			type : "POST",
			url:'<c:url value="/bap/adapter/socket/serverStatus.json" />',
			data:postData,
			success:function(args){
				$("#grid").trigger("reloadGrid");
			},
			error:function(e){
				alert(e.responseText);
			}
		});
    
}
$(document).ready(function() {	
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/adapter/socket/serverStatus.json" />',
		postData : { cmd : 'LIST' },
		colNames:['업무구분',
                  '대외기관',
                  '어댑터그룹',
                  '어댑터명',
                  'IP',
                  'PORT',
                  '최대연결수',
                  '현재연결수',
                  '상태',
                  '상태',
                  '기동/종료'
                  ],
		colModel:[
				{ name : 'processName'        , align:'left' , width:200, sortable : false },
				{ name : 'organName'          , align:'left' , width:200 },
				{ name : 'adptrBzwkGroupName' , align:'left' , width:200 },
				{ name : 'adptrBzwkName'      , align:'left' , width:200},
				{ name : 'ip'                 , align:'left'  },
				{ name : 'port'               , align:'right', width:70 },
				{ name : 'maxConnectioncount' , align:'right', width:70 ,
						formatter: function (cellvalue) {
				              if ( cellvalue == '0' ) {
				                  return '무제한';
                              } else {
                                  return cellvalue;
                              }
                          }
				
				},
				{ name : 'curConnectioncount' , align:'right' , width:70},
				{ name : 'status'             , align:'center', hidden:true},
				{ name : 'status2'            , align:'center', width:70},
				{ name : 'startStop'          , align:'center'}
				],
	    autoheight: true,
	    height: $("#container").height(),
	    //height: "500",
	    rowNum: 10000,
        jsonReader: {
             repeatitems:false
        },
        gridComplete: function(){
        	var ids = $(this).getDataIDs();
        	for(var i=0;i<ids.length;i++){
        		var cl = ids[i];
        		var rowData = $(this).getRowData(cl); 
        		var adptrBzwkGroupName = rowData['adptrBzwkGroupName'];
        		var adptrBzwkName      = rowData['adptrBzwkName'];
        		var status             = rowData['status'];
        		var color = 'black';
        		//alert( 'status -->' + status );
        		if ( status == '중지' ){
        		    be = "<input style='height:22px;width:60px;' type='button' value='기동' onclick=\"control('START_SOCKET_SERVER','"+adptrBzwkGroupName+"','"+adptrBzwkName+"');\" />";
        		    color = 'red';
        		    $(this).setRowData(ids[i],{startStop:be});
        		}else if ( status == '기동중' ){
        		    be = "<input style='height:22px;width:60px;' type='button' value='중지' onclick=\"control('STOP_SOCKET_SERVER','"+adptrBzwkGroupName+"','"+adptrBzwkName+"');\" />";
        		    color = 'blue';
        		    $(this).setRowData(ids[i],{startStop:be});
        		}
        		$(this).setRowData(ids[i],{status2:'<span class="cellWithoutBackground" style="color:' + color + ';">' + status + '</span>'});
        	} 
        },
		loadComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}

		},	        		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		$("#grid").trigger("reloadGrid");
	});
	
	buttonControl();
	
});
 
</script>
</head>
<body>
	<div class="right_box">
		<div class="content_top">
			<ul>
			<li><a href=#>${rmsMenuPath}</a></li>
			</ul>						
	</div><!-- end content_top -->
		<div class="content_middle" id="content_middle">
			<div class="search_wrap">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
			</div>
		<div class="title">연결유지형 소켓 상태정보</div>
			
			<!-- grid -->
		<table id="grid"></table>
		<div id="pager"></div>

		<!-- end content_middle -->
	</div>
	<!-- end right_box -->
</body>
	
</html>