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

function stopSession(serverName, processName, organName, localIpPort, remoteIpPort, uuid){

    if ( confirm( "* FEP ����           : "+ serverName +"\n"+
                  "* ��������           : "+ processName + "\n"+
                  "* ��ܱ��           : "+ organName +"\n"+
                  "* FEP IP:Port        : "+ localIpPort + "\n"+
                  "* ��ܱ�� IP:Port : " + remoteIpPort +"\n\n"+
                  "�ش� Socket ������ ���� ���� �Ͻðڽ��ϱ�?") != true ){
        return;
    }
    	var postData = new Array();
    	postData.push({ name: "cmd"       , value:"CONTROL"});
    	postData.push({ name: "startStop" , value:"STOP_SOCKET_SESSION"});
    	postData.push({ name: "uuid"      , value:uuid});
    	$.ajax({
			type : "POST",
			url:'<c:url value="/bap/adapter/socket/connStatus.json" />',
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
		url: '<c:url value="/bap/adapter/socket/connStatus.json" />',
		postData : { cmd : 'LIST' },
		colNames:['�����ν��Ͻ���',
                  '��������',
                  '��ܱ��',
                  '��������',
                  'UUID',
                  '����ͱ׷�',
                  '����͸�',
                  'Local IP:Port',
                  'REMOTE IP:Port',
                  '����ð�',
                  '����',
                  '��������'
                  ],
		colModel:[
				{ name : 'serverName'       , align:'left', sortable : false  },
				{ name : 'processName'      , align:'left'  },
				{ name : 'organName'        , align:'left'  },
				{ name : 'processType'      , align:'left'  },
				{ name : 'uuid'             , align:'left'  },
				{ name : 'adapterGroupName' , align:'left' },
				{ name : 'adapterName'      , align:'left' },
				{ name : 'localIpPort'      , align:'left' },
				{ name : 'remoteIpPort'     , align:'center'},
				{ name : 'startTimeStamp'   , align:'center'},
				{ name : 'status'           , align:'center'},
				{ name : 'stop'             , align:'center'}
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
        		var serverName   = rowData['serverName'];
        		var processName  = rowData['processName'];
        		var organName    = rowData['organName'];
        		var localIpPort  = rowData['localIpPort'];
        		var remoteIpPort = rowData['remoteIpPort'];
        		var uuid         = rowData['uuid'];
        		var be = "<input style='height:22px;width:60px;' type='button' value='��������' onclick=\"stopSession('"+serverName+"','"+processName+"','"+organName+"','"+localIpPort+"','"+remoteIpPort+"','" +uuid +"');\" >";
        	    $(this).setRowData(ids[i],{stop:be});
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
		<div class="title">����� ��������</div>
			
			<!-- grid -->
		<table id="grid"></table>
		<div id="pager"></div>

		<!-- end content_middle -->
	</div>
	<!-- end right_box -->
</body>
</html>