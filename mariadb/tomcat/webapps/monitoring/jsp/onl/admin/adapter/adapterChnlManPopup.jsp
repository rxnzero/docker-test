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

var url = '<c:url value="/onl/admin/adapter/adapterChnlMan.json" />';
var adptrBzwkGroupName = window.dialogArguments["adptrBzwkGroupName"];


$(document).ready(function() {		
	//$('input[name=adptrBzwkGroupName]').val(eaiSvcName);
	var serviceType = $('select[name=serviceType] option:selected').val();
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		url : url,
		postData : {cmd : "LIST_POP",adptrBzwkGroupName : adptrBzwkGroupName==null?"":adptrBzwkGroupName,serviceType:serviceType },
		colNames : [ '어뎁터명',
		             '어뎁터설명'


		              ],
		colModel : [ { name : 'ADPTRBZWKGROUPNAME'            , align : 'left' , width:'40'	,sortable:false},
		             { name : 'ADPTRBZWKGROUPDESC'              , align : 'left'   , width:'100'},

 ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		height: '500',
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
			var key = rowData['ADPTRBZWKGROUPNAME'];

			var retData=new Object() ;
			retData['key'] = key;

			
			window.returnValue = retData;
			$("#btn_close").trigger("click");
        }	
		
	
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){

	   	var _adptrBzwkGroupName = $('input[name=searchAdptrBzwkGroupName]').val();
	  	var serviceType = $('select[name=serviceType] option:selected').val();
	  	var postData = new Array();
      	postData.push({ name: "cmd"       				 , value:"LIST_POP"});
	  	postData.push({ name: "adptrBzwkGroupName"       , value:_adptrBzwkGroupName});
	  	postData.push({ name: "serviceType"       		 , value:serviceType});
	  	$("#grid").setGridParam({ postData:postData}).trigger("reloadGrid");
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
					<img id="btn_search" src="<c:url value="/img/btn_search.png"/>" level="R"/>
					<img id="btn_close" src="<c:url value="/img/btn_close.png"/>"  level="R"/>
				</div>
				<div class="title">어댑터 조회</div>
				
				<table class="search_condition" cellspacing="0">
					<tr>
						<th style="width:20%;">어댑터명</th>
						<td style="width:80%;">
							<input type="text" name="searchAdptrBzwkGroupName" value="${param.searchAdptrBzwkGroupName}" style="width:65%;"> 
							<div class="select-style" style="display:inline-block; width:30%;">
								<select name="serviceType">
									<option value="FEP">FEP</option>
									<option value="EAI">EAI</option>
								</select>
							</div>
						</td>						
					</tr>
				</table>				
				<!-- grid -->
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
	</body>
</html>