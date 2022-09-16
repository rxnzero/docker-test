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
var url      = '<c:url value="/onl/adapter/socket/socketTracking.json" />';
var url_view = '<c:url value="/onl/adapter/socket/socketTracking.view" />';
var timer;
function fontFormatterFunction(cellvalue, options, rowObject) {
	var rowId = options["rowId"];
	if (cellvalue=="true"){
		return "<font color='#0000FF'>"+cellvalue+"</font>";
	}else if (cellvalue=="false"){
		return "<font color='#FF0000'>"+cellvalue+"</font>";
	}
}	

function formatterFunction(cellvalue, options, rowObject) {
	var rowId = options["rowId"];
	return "<img id='btn_stop' src='<c:url value='/images/bt/bt_level"+cellvalue+"_sm.gif'/>' name='img_"+cellvalue+"_"+rowId+"' />";
}

function init( callback) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=searchEaiSevrInstncName]")).setData(json.instanceList).rendering();
			
			$("select[name=searchEaiSevrInstncName]").val('${param.searchEaiSevrInstncName}');
			
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
		             '<%= localeMessage.getString("adapterStat.status") %>',
		             'LEVEL',
		             'LEVEL0',
		             'LEVEL1',
		             'LEVEL2',
		             'LEVEL3'
		              ],
		colModel : [ 
		             { name : 'AdptrBzwkGroupName' , align : 'left'   , width:'140' ,sortable : false },
		             { name : 'AdptrBzwkName'      , align : 'left'   , width:'170'  },
		             { name : 'AdptrBzwkDesc'      , align : 'left'   , width:'200'   },
		             { name : 'Status'             , align : 'center'   , width:'40' , formatter : fontFormatterFunction},
		             { name : 'Level'              , align : 'center'   , width:'60'},
		             { name : 'Level0'             , align : 'center'   , width:'50' , formatter : formatterFunction},
		             { name : 'Level1'             , align : 'center'   , width:'50' , formatter : formatterFunction},
		             { name : 'Level2'             , align : 'center'   , width:'50' , formatter : formatterFunction},
		             { name : 'Level3'             , align : 'center'   , width:'50' , formatter : formatterFunction}
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		height : '500',
		viewrecords : true,
		gridview: true,
		ondblClickRow : function(rowId) {
		},
	    loadComplete:function (d){
			$("img[name*=img]").unbind("click");
				    
			$("img[name*=img]").click(function() {
				var name = $(this).attr("name");
				var rowId = name.split("_")[2];
				var control = name.split("_")[1];
				var data = $('#grid').jqGrid('getRowData', rowId);
				var postData = [];
				postData.push({name:"cmd"                     , value:"TRANSACTION_STARTSTOP"});
				postData.push({name:"searchEaiSevrInstncName" , value:$("select[name=searchEaiSevrInstncName]").val() });
				postData.push({name:"adptrBzwkGroupName"      , value:data["AdptrBzwkGroupName"]});
				postData.push({name:"adptrBzwkName"           , value:data["AdptrBzwkName"]});
				postData.push({name:"level"                   , value:control});
				
				var msgStartStop = "level"+control;
				var resultConfirm = confirm(replaceMsg("<%= localeMessage.getString("common.confirmMsg1") %>"
						,msgStartStop,data["AdptrBzwkGroupName"],data["AdptrBzwkName"])); 
				/* var resultConfirm = confirm(
				data["AdptrBzwkGroupName"]
				+ " "
				+ data["AdptrBzwkName"]
				+ "을\n\n"
				+ msgStartStop
				+ "으로 설정 하시겠습니까?"); */

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
				<ul class="path">
					<li><a href="#">${rmsMenuPath}</a></li>					
				</ul>						
			</div><!-- end content_top -->
			<div class="content_middle">
				<div class="search_wrap">
						<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title"><%= localeMessage.getString("socketTracking.title") %></div>
				
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
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>		
</html>

