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
var isJndiname = window.dialogArguments["isJndiName"];
var jndiname = (isJndiname === 'true') ? window.dialogArguments["jndiname"] : "";
var driver = (isJndiname === 'false') ? window.dialogArguments["driver"] : "";
var jdbcUrl = (isJndiname === 'false') ? window.dialogArguments["jdbcUrl"] : "";
var username = (isJndiname === 'false') ? window.dialogArguments["username"] : "";
var password = (isJndiname === 'false') ? window.dialogArguments["password"] : "";
var schema = window.dialogArguments["schema"];
var url ='<c:url value="/onl/admin/common/sqlMan.json" />';

function ioFormatter(cellvalue,options,rowObject){
	var serviceType = sessionStorage["serviceType"];
	if(cellvalue == "I"){
		if(serviceType == "EAI") return "당발";
		else if(serviceType =="FEP") return "타발";
	}else if(cellvalue =="O"){
		if(serviceType == "EAI") return "타발";
		else if(serviceType=="FEP") return "당발";	

	}

}
function getPostData() {
	var postData = getSearchForJqgrid("cmd","LIST_POP");
	postData["isJndiname"] = isJndiname;
	postData["jndiname"] = isEmpty(jndiname) ? "" : jndiname;
	postData["driver"] = isEmpty(driver) ? "" : driver;
	postData["jdbcUrl"] = isEmpty(jdbcUrl) ? "" : jdbcUrl;
	postData["username"] = isEmpty(username) ? "" : username;
	postData["password"] = isEmpty(password) ? "" : password;
	postData["schema"] = schema;
	
	return postData;
}
$(document).ready(function() {		
	var gridPostData = getPostData();
	$('#grid').jqGrid({
		datatype : "json",
 		mtype : 'POST',
		url : url,
		postData : gridPostData,
		colNames : [ '테이블명',
		             '테이블 설명'
		           ],
		colModel : [ { name : 'table_name'            	, align : 'center' , width:'100',sortable:false},
		             { name : 'remarks'              	, align : 'left'   }
 					],
		jsonReader : {
			repeatitems : false
		},
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : '${rmsDefaultRowNum}',
		autoheight : true,
		height : $("#container").height(),
		autowidth : true,
		viewrecords : true,
		rowList : eval('[${rmsDefaultRowList}]'),
		loadComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}
		},		
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
			var tableName = rowData['table_name'];
			var tableDesc = rowData['remarks'];
			var retData=new Object() ;
			retData['tableName'] = tableName;
			retData['schema'] = schema;
			retData['tableDesc'] = tableDesc;
			
			window.returnValue = retData;
			$("#btn_close").trigger("click");
        }	
	});
	
// 	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getPostData();
		$("#grid").setGridParam({postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	
	$("#btn_close").click(function(){
		window.close();
	});
	
	//buttonControl();
	
});
 
</script>
</head>
	<body>
		<div class="popup_box">
			<div class="search_wrap">
				<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="W" />
				<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" />	
			</div>
			<div class="title">Table List</div>
			<table id="grid" ></table>
			<div id="pager"></div>
			
		</div><!-- end.popup_box -->
	</body>
</html>