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
var url      = '<c:url value="/onl/statistics/management/statisticsMan.json" />';
var url_view = '<c:url value="/onl/statistics/management/statisticsMan.view" />';

function init()
{
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=searchJobTypeCd]")).setNoValueInclude(true).setNoValue("","전체").setData(json.jobTypeCdRows).setFormat(codeName3OptionFormat).rendering();
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
	
function search(){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$("#grid").setGridParam({ url:url,postData: postData ,page:1 }).trigger("reloadGrid");
}

$(document).ready(function() {
	init();

	$("input[name=searchStart],input[name=searchEnd]").inputmask("9999-99",{'autoUnmask':true});
	$("input[name=searchStart],input[name=searchEnd]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == ""){
			$(this).val(getToday());
		}
	});
		
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		//url : url,
		//postData : gridPostData,
		colNames : [ '통계작업일',
		             '통계작업구분코드',
		             '통계작업구분',
		             '작업시간',
		             '성공여부코드',
		             '성공여부',
		             '에러메시지',
		              ],
		colModel : [ { name : 'STATCJOBYMD'			, align : 'center'	, width:'70'	,sortable:false},
		             { name : 'STATCJOBCYCLDSTCD'	, hidden: true},
		             { name : 'STATCJOBCYCLDSTNM'	, align : 'center'	, width:'70'},
		             { name : 'STATCJOBHMS'			, align : 'center'	, width:'70'},
		             { name : 'SUCSSYN'				, hidden: true},
		             { name : 'SUCSSYNNM'			, align : 'center'	, width:'70'},
		             { name : 'ERRMSG'				, align : 'left'	, width:'500'},
		           ],
		jsonReader : {
			repeatitems : false
		},
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : 10000,
		autoheight : true,
		height : $("#container").height(),
		autowidth : true,
		viewrecords : true,
		loadComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}
		},		
	});
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		search();
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
	$("#btn_download").click(function(event) {
           event.stopPropagation(); // Do not propagate the event.
           // Create an object that will manage to download the file.
//            var merge = new Array();
//            merge.push(makeMerge("통계작업일","0","0","0","0"));
//            merge.push(makeMerge("통계작업구분","0","0","1","1"));
//            merge.push(makeMerge("작업시간","0","0","2","2"));
//            merge.push(makeMerge("성공여부","0","0","3","3"));
//            merge.push(makeMerge("에러메시지","0","0","4","5"));
           
		gridToExcelSubmit(url,"LIST_GRID_TO_EXCEL",$("#grid"),$("#ajaxForm"),"통계자료 생성 현황");
		return false;
	});	
	
	buttonControl();
	
});
 
</script>
</head>
	<body>
	<!-- path -->
	<div class="container">
		<div class="right full">
			<p class="nav">${rmsMenuPath}</p>
		</div>
	</div>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">통계자료 생성 현황</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	

	<!-- button -->
	<table  width="100%" height="35px"  >
	<tr>
		<td align="left">
		<table width="100%">
		<tr>
			<td class="search_td_title" width="150px">작업구분</td>
			<td><select name="searchJobTypeCd" value="${param.searchJobTypeCd}" style="width:100%" /></td>
			<td class="search_td_title" width="150px">기간</td>
			<td>
				<input type='text' name="searchStart" value="${param.searchStart}" style="width:80px">~
				<input type='text' name="searchEnd" value="${param.searchEnd}" style="width:80px">
			</td>
		</tr>
		</table>
		</td>
		<td align="right" width="200px">
			<img id="btn_search" src="<c:url value="/images/bt/bt_search.gif"/>" level="R"/>
			<img id="btn_download"   level="W" src="<c:url value="/images/bt/bt_download.gif"/>"/>
		</td>
	</tr>
	</table>	

	<!-- grid -->
	<table id="grid" ></table>
	<div id="pager"></div>
	
	</body>
</html>

