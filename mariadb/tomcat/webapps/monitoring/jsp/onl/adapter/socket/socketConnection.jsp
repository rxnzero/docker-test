<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
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
var url      = '<c:url value="/onl/adapter/socket/socketConnection.json" />';
var url_view = '<c:url value="/onl/adapter/socket/socketConnection.view" />';
var timer;

var selectName = "searchAdptrBzwkGroupName";	// selectBox Name

function fontFormatterFunction(cellvalue, options, rowObject) {
	var rowId = options["rowId"];
	if (cellvalue=="true"){
		return "<font color='#0000FF'>"+cellvalue+"</font>";
	}else if (cellvalue=="false"){
		return "<font color='#FF0000'>"+cellvalue+"</font>";
	}
}	

function unformatterFunction(cellvalue, options, rowObject) {
	return "";
}

function formatterFunction(cellvalue, options, rowObject) {
	var rowId = options["rowId"];
	if (cellvalue=="03"){
		return "<img id='btn_stop' src='<c:url value='/images/bt/bt_end_sm.gif'/>' name='img_"+rowId+"' />";
	}else if (cellvalue=="01"){
		return "<img id='btn_start' src='<c:url value='/images/bt/bt_boot_sm.gif'/>' name='img_"+rowId+"' />";
	}
	return "";
}

function init( callback) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=searchEaiSevrInstncName]")).setData(json.instanceList).rendering();
			new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=searchAdptrBzwkGroupName]")).setData(json.adapterList).setFormat(codeName3OptionFormat).rendering();
			
			$("select[name=searchEaiSevrInstncName]").val('${param.searchEaiSevrInstncName}');
			$("select[name=searchAdptrBzwkGroupName]").val('${param.searchAdptrBzwkGroupName}');
			setSearchable(selectName);	// 콤보에 searchable 설정
			
			if (typeof callback === 'function') {
				callback(url);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
	
}
function list(){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	$("#grid").setGridParam({ url:url,postData: postData ,datatype:'json'}).trigger("reloadGrid");
}
function startStop(postData) {
	$.ajax({
		type : "POST",
		url : url,
		dataType : "json",
		data : postData,
		success : function(json) {
			list();
		},
		error : function(e) {
			alert(e.responseText);
		}
	});

}

$(document).ready(function() {	
	
	$('#grid').jqGrid({
		datatype : "local",
		mtype : 'POST',
		colNames : [ 
		             '<%= localeMessage.getString("adapterStat.adapterGroup") %>',
		             '<%= localeMessage.getString("adapterStat.adapterName") %>',
		             '<%= localeMessage.getString("adapterStat.adapterDesc") %>',
		             '<%= localeMessage.getString("adapterStat.adapterDv") %>',
		             'INBOUND',
		             'CLIENT',
		             'SYNC',
		             'L.IP/PORT',
		             'R.IP/PORT',
		             '<%= localeMessage.getString("socket.sendCnt") %>',
		             '<%= localeMessage.getString("socket.recvCnt") %>',
		             '<%= localeMessage.getString("socket.firstConnDt") %>',
		             '<%= localeMessage.getString("socket.lastIoDt") %>',
		             '<%= localeMessage.getString("adapterStat.close") %>',
		             'session'
		              ],
		colModel : [ 
		             { name : 'AdptrBzwkGroupName' , align : 'left'   , width:'160', sortable : false  },
		             { name : 'AdptrBzwkName'      , align : 'left'   , width:'200'  },
		             { name : 'AdptrBzwkDesc'      , align : 'left'   },
		             { name : 'BwkClsCd'           , align : 'center'   , width:'60' },
		             { name : 'BoundUsage'         , align : 'center'   , width:'60' },
		             { name : 'SocketType'         , align : 'center'   , width:'60' },
		             { name : 'AckSupport'         , align : 'center'   , width:'60' },
		             { name : 'LocalAddress'       , align : 'center'   , width:'60' },
		             { name : 'RemoteAddress'      , align : 'center'   , width:'60' },
		             { name : 'WrittenMessages'    , align : 'center'   , width:'60' },
		             { name : 'ReadMessages'       , align : 'center'   , width:'60' },
		             { name : 'CreationTime'       , align : 'center'   , width:'60' },
		             { name : 'LastIoTime'         , align : 'center'   , width:'60' },
		             { name : 'Button'             , align : 'center'   , width:'60' , unformat : unformatterFunction, formatter : formatterFunction },
		             { name : 'Session'            , hidden:true }
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		autoheight : true,
		height : '500',
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
		},
	    loadComplete:function (d){
			$("img[name*=img]").unbind("click");
				    
			$("img[name*=img]").click(function() {
				var name = $(this).attr("name");
				var rowId = name.split("_")[1];
				var control =$(this).attr("id").split("_")[1];
				var data = $('#grid').jqGrid('getRowData', rowId);
				var postData = [];
				postData.push({name:"cmd"                     , value:"TRANSACTION_STARTSTOP"});
				postData.push({name:"searchEaiSevrInstncName" , value:$("select[name=searchEaiSevrInstncName]").val() });
				postData.push({name:"adptrBzwkGroupName"      , value:data["AdptrBzwkGroupName"]});
				postData.push({name:"adptrBzwkName"           , value:data["AdptrBzwkName"]});
				postData.push({name:"remoteAddress"           , value:data["RemoteAddress"]});
				postData.push({name:"localAddress"            , value:data["LocalAddress"]});
				postData.push({name:"session"                 , value:data["Session"]});
				
				var msgStartStop = control=="start"?"<%= localeMessage.getString("adapterStat.start") %>":"<%= localeMessage.getString("adapterStat.close") %>";
				/* var resultConfirm = confirm(
				data["AdptrBzwkGroupName"]
				+ " "
				+ data["AdptrBzwkName"]
				+ "을\n\n"
				+ msgStartStop
				+ " 하시겠습니까?"); */
				var resultConfirm = confirm(replaceMsg("<%= localeMessage.getString("common.confirmMsg1") %>"
						,msgStartStop,data["AdptrBzwkGroupName"],data["AdptrBzwkName"])); 

				if (resultConfirm != true)
					return;
				startStop(postData);
				
			});	   	
	    },
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}

		},		    
	    loadError:function(xhr,status,error){
	    	alert(error);
	    	//clearInterval(timer);
	    }	
		
	});
	resizeJqGridWidth('grid','title','1000');
	$("#btn_search").click(function(){
		list();
	});
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			list();
		}
	});

	
	buttonControl();
	init(list);
	
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
			<div class="content_middle">
				<div class="search_wrap">
						<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title"><%= localeMessage.getString("socketConn.title") %></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("adapterStat.instanceName") %></th>
							<td>
								<div class="select-style">
									<select  name="searchEaiSevrInstncName" value="${param.searchEaiSevrInstncName}" style="width:100%"></select>
								</div>	
							</td>
						</tr>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("adapterStat.adapterGroup") %></th>
							<td>
								<div style="position: relative; width: 100%;">
									<div class="select-style">
										<select  name="searchAdptrBzwkGroupName" value="${param.searchAdptrBzwkGroupName}" style="width:100%" readonly="true"></select>
									</div><!-- end.select-style -->										
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
	
</html>

