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
var loutName = window.dialogArguments["layoutName"];

var url ='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />';
$(document).ready(function() {		

	$('input[name=searchLoutName]').val(loutName);

	$('#tree').jqGrid({
		    datatype:'json',
		    loadui: "disable",
		    mtype: 'POST',
		    url:url,
		    postData:{cmd:"LIST_FIELD", loutName:$('input[name=searchLoutName]').val()},
		    colNames: ["번호","항목명(영문)","항목설명","최대발생건수","참조정보","테이타타입","테이터길이","소수점길이","레이아웃명","path"],
		    colModel: [
		        {name: "LOUTITEMSERNO"          , width:"30"},
		        {name: "LOUTITEMNAME"           , width:"250"},
		        {name: "LOUTITEMDESC"                      },
		        {name: "LOUTITEMMAXOCCURNOITM"  },
		        {name: "LOUTITEMREFINFO2"       },
		        
		        {name: "LOUTITEMPTRNIDDESC" , width:"60"},
		        {name: "LOUTITEMLENCNT"         , width:"60"},
		        {name: "DECPTLENCNT"            , width:"60"},
		        
		        {name: "LOUTNAME"               , hidden:true},
		        {name: "LOUTITEMPATH"           , hidden:true}
		        
				],
		    treeGrid: true,
		    treeGridModel: "adjacency",
		    ExpandColumn: "LOUTITEMNAME",
		    height:"400",
		    rowNum: 10000,
		    autowidth : true,
		    treeIcons: {leaf:'ui-icon-document-b'},
		    jsonReader: {
		        repeatitems: false
		     },
			loadComplete:function (d){
				var colModel = $(this).getGridParam("colModel");
				for(var i = 0 ; i< colModel.length; i++){
					$(this).setColProp(colModel[i].name, {sortable : false});
				}
			},		
			ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
				var key = rowData["LOUTITEMPATH"].replace(rowData["LOUTNAME"]+".","");
				var retData=new Object() ;
				retData['key'] = key;
				
				window.returnValue = retData;
				$("#btn_close").trigger("click");
       		 }	

	});
	
	
	resizeJqGridWidth('tree','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST_FIELD"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1"  }).trigger("reloadGrid");
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
			<div class="popup_box" id="title">
				<div class="search_wrap">
					<img id="btn_search" src="<c:url value="/img/btn_search.png"/>" level="R"/>
					<img id="btn_close" src="<c:url value="/img/btn_close.png"/>"  level="R"/>
				</div>
				<div class="title">메시지항목 관리</div>
				
				<table class="search_condition" cellspacing="0">
					<tr>
						<th style="width:20%;">업무구분 코드</th>
						<td style="width:30%;">
							<input type="text" name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
						</td>	
						<th style="width:20%;">전문레이아웃 코드</th>	
						<td style="width:30%;">
							<input type="text" name="searchLoutName" value="${param.searchLoutName}">
						</td>	
					</tr>
					<tr>
						<th style="width:20%;">전문레이아웃  설명</th>
						<td colspan="3"><input type="text" name="searchLoutDesc" value="${param.searchLoutDesc}"></td>
					</tr>
				</table>				
				<!-- grid -->
				<table id="tree" ></table>
				
			</div><!-- end content_middle -->
</html>