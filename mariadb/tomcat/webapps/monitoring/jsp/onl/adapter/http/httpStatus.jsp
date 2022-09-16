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
var url      = '<c:url value="/onl/adapter/http/httpStatus.json" />';
var url_view = '<c:url value="/onl/adapter/http/httpStatus.view" />';
var timer;
function list(){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	postData["adapterType"]="HTT";
	$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
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
}	

function fontFormatterFunction(cellvalue, options, rowObject) {
	var rowId = options["rowId"];
	if (cellvalue=="<%= localeMessage.getString("httpStat.normal") %>"){
		return "<font color='#0000FF'>"+cellvalue+"</font>";
	}else if (cellvalue=="<%= localeMessage.getString("httpStat.abnormal") %>"){
		return "<font color='#FF0000'>"+cellvalue+"</font>";
	}
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
		datatype : "json",
		mtype : 'POST',
		//url : url,
		//postData : gridPostData,
		colNames : [ 
		             '<%= localeMessage.getString("adapterStat.instanceName") %>',
		             '<%= localeMessage.getString("adapterStat.adapterGroup") %>[TX]',
		             '<%= localeMessage.getString("adapterStat.adapterName") %>',
		             '<%= localeMessage.getString("adapterStat.adapterDesc") %>',
		             '<%= localeMessage.getString("adapterStat.adapterDv") %>',
		             '<%= localeMessage.getString("adapterStat.status") %>',
		             '<%= localeMessage.getString("adapterStat.startStat") %>',
		             '<%= localeMessage.getString("adapterStat.startup") %>',
		             'adapterGroupSimple'
		              ],
		colModel : [ 
		             { name : 'eaiSvrInstNm'       , align : 'left'   , width:'100' , sortable:false },
		             { name : 'adapterGroupName'   , align : 'left'   , width:'160'    },
		             { name : 'adapterName'        , align : 'left'   , width:'200'  },
		             { name : 'adapterGroupDesc'   , align : 'left'   },
		             { name : 'adapterKind'        , align : 'center'   , width:'100'  },
		             { name : 'adapterStatus'      , align : 'center'   , width:'60' , unformat : unformatterFunction, formatter : fontFormatterFunction },
		             { name : 'adapterStartStatus' , align : 'center'   , width:'60' , },
		             { name : 'adapterStartStop'   , align : 'center'   , width:'60' , unformat : unformatterFunction, formatter : formatterFunction },
		             { name : 'adapterGroupSimple' , hidden:true }
		             

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
				postData.push({name:"cmd"              ,value:"TRANSACTION_STARTSTOP"});
				postData.push({name:"control"          ,value:control.toUpperCase()});
				postData.push({name:"eaiInstanceName"  ,value:data["eaiSvrInstNm"]});
				postData.push({name:"adapterGroupName" ,value:data["adapterGroupSimple"]});
				postData.push({name:"adapterName"      ,value:data["adapterName"]});
				postData.push({name:"adapterType"      ,value:"HTT"});
				
				var msgStartStop = control=="start"?"<%= localeMessage.getString("adapterStat.start") %>":"<%= localeMessage.getString("adapterStat.close") %>";
				var resultConfirm = confirm(replaceMsg("<%= localeMessage.getString("common.confirmMsg1") %>"
						,msgStartStop,data["adapterGroupName"],data["adapterName"])); 
				// data["adapterGroupName"]+ " "+ data["adapterName"]+ "을\n\n"+ msgStartStop+ " 하시겠습니까?"

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
	    	//alert(error);
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
	list();
	
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
				<div class="title"><%= localeMessage.getString("httpStat.title") %></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th width="180px"><%= localeMessage.getString("httpStat.search") %></th>
							<td>
								<input type="text" name="searchAdapterGroup" value="${param.searchAdapterGroup}">
								<input type="hidden" name="adapterType" value="HTT" style="width:100%">
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

