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
var eaiSvcName = window.dialogArguments["eaiSvcName"];

var url ='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />';


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
$(document).ready(function() {		
	$('input[name=searchEaiSvcName]').val(eaiSvcName);

	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		url : '<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />',
		postData : {cmd : "LIST_POP",eaiSvcName : eaiSvcName },
		colNames : [ '업무구분',
		             'IF서비스코드',
		             '인터페이스ID설명',
		             '인터페이스ID',
		             '당타발구분',
		             '전문요청구분',

		              ],
		colModel : [ { name : 'EAIBZWKDSTCD'            , align : 'center' , width:'40'	,sortable:false},
		             { name : 'EAISVCNAME'              , align : 'left'   , width:'100'},
		             { name : 'EAISVCDESC'              , align : 'left'   },
		             { name : 'EAITRANNAME'             , align : 'left'   , width:'150'},
		             { name : 'IO'                      , align : 'center' , width:'50' , formatter:ioFormatter},
		             { name : 'SPLIZDMNDDSTCD'          , align : 'center' , width:'50' , edittype:'select',editoptions:{value:"S:요청;R:응답"}, formatter:"select"}
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
			var key = rowData['EAISVCNAME'];
			var eaiSvcDesc = rowData['EAISVCDESC'];
			var eaiBzwkDstCd = rowData['EAIBZWKDSTCD'];
			var retData=new Object() ;
			retData['key'] = key;
			retData['eaiSvcDesc'] = eaiSvcDesc;
			retData['eaiBzwkDstCd'] = eaiBzwkDstCd;
			window.returnValue = retData;
			
			$("#btn_close").trigger("click");
        }	
	
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
	   
	   var _eaiSvcName = $('input[name=searchEaiSvcName]').val();


		$("#grid").setGridParam({ postData:{cmd:"LIST_POP",eaiSvcName:_eaiSvcName} ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_close").click(function(){
		window.close();
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
	//buttonControl();
	
}); 
 
</script>
</head>
	<body>
		<div class="popup_box">
			<div class="search_wrap">
					
				<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />		
				<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="W" />
			</div>
			<div class="title">메시지항목 관리</div>
			<table class="search_condition" cellspacing=0;>
				<tbody>
					<tr>
						<th style="width:180px;">인터페이스ID</th>
						<td><input type="text" name="searchEaiSvcName" value=""></td>							
					</tr>
				</tbody>
			</table>
			<table id="grid" ></table>
			<div id="pager"></div>
			
		</div><!-- end.popup_box -->
	</body>
</html>