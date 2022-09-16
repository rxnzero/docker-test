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
<jsp:include page="/jsp/common/include/jqplotScript.jsp"/>
<jsp:include page="/jsp/common/include/jqplotCss.jsp"/>


<script language="javascript" >
var url      ='<c:url value="/onl/statistics/eaibzwkdstcd/eaiBzwkDstcdYearlyMan.view" />';
var url_view ='<c:url value="/onl/statistics/eaibzwkdstcd/eaiBzwkDstcdYearlyMan.json" />';

var plotChart1;			// jqplot 저장 (chart1).
var plotChart2;			// jqplot 저장 (chart2).

function detail(){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$("#grid").setGridParam({ url:url,postData: postData ,page:1 }).trigger("reloadGrid");
}

$(document).ready(function() {

	$("input[name=searchStart],input[name=searchEnd]").inputmask("9999",{'autoUnmask':true});
	$("input[name=searchStart],input[name=searchEnd]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == ""){
			$(this).val(getToday());
		}
	});
	
	// Grid 조회.
	var postData = getSearchForAjax("cmd","LIST");

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url:url,
		postData:postData,
		colNames:['년도'
		         ,'업무명','전송','오류'
                  ],
		colModel:[
				{ name : 'STATCY'		, align:'left'	,width:'60px'	,sortable:false},
				{ name : 'EAIBZWKDSTCD'	, align:'left'	,width:'200px' },
				{ name : 'YNTRSMTNOITM'	, align:'right'	,width:'60px'	, index:'YNTRSMTNOITM',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'YNERRNOITM'	, align:'right'	,width:'60px'	, index:'YNERRNOITM',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"}
				],
        jsonReader: {
             repeatitems:false
        },	          
		autoheight: true,
	    height: 300,
	    
		rowNum : 10000,				// Grid에 표시될 레코드 수 설정.
		gridview: true,				// jqGrid의 성능 향상 - treeGrid, subGrid, afterInsertRow event의 경우 제외.
	    
		footerrow:true,				// 하단에 summary row 출력여부.(default: false)
		userDataOnFooter:true,
		rownumbers:true,			// Grid의 행번호 출력여부.(default: false)
		
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//그리드 헤더 화살표 삭제(정렬X)		
			}
		},
		loadComplete:function (d){
		
			if(plotChart1 == undefined || plotChart1 == null)
			{
				var data = d.rows;
				
				// 차트 생성.
				plotChart1 = jqBarchart('chart1', data, "EAIBZWKDSTCD",'YNTRSMTNOITM', "전송건수");
				plotChart2 = jqBarchart('chart2', data, "EAIBZWKDSTCD",'YNERRNOITM', "오류건수");
				
				// Summary CSS 설정.
				$(".ui-jqgrid-ftable tr:first").children("td").css("background-color", "#D4F4FA");	// td 배경색
				$(".ui-jqgrid-ftable tr:first").css("height", "30px");								// tr 높이
				$(".ui-jqgrid-ftable tr:first").css("font-size", "10pt");							// tr 글자 크기
				$(".ui-jqgrid-ftable td:eq(1)").css("text-align", "center");						// td 글자 정렬
				
				var yntrsmtnoitm_sum = $("#grid").jqGrid("getCol", "YNTRSMTNOITM", false, 'sum');
				var ynerrnoitm_sum = $("#grid").jqGrid("getCol", "YNERRNOITM", false, 'sum');
													   
				$("#grid").jqGrid("footerData", "set", {STATCY:"합계", YNTRSMTNOITM:yntrsmtnoitm_sum
																	, YNERRNOITM:ynerrnoitm_sum
													   });
			}
		}
	});
	
	$("#btn_search").click(function(){
	
		plotChart1.destroy();
		plotChart2.destroy();
		
		plotChart1 = null;
		plotChart2 = null;
		
		detail();
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
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
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">업무별 년간 거래현황</p>
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
				<td class="search_td_title" width="120px">업무명</td>
				<td>
					<input type='text' name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}" style="width:100%"/>
				</td>
<!-- 				<td class="search_td_title" width="120px">기간</td> -->
<!-- 				<td> -->
<%-- 					<input type='text' name="searchStart" value="${param.searchStart}" style="width:80px">~ --%>
<%-- 					<input type='text' name="searchEnd" value="${param.searchEnd}" style="width:80px"> --%>
<!-- 				</td> -->
			</tr>
		</table>
		</td>
		<td align="right" width="120px">
			<img id="btn_search" src="<c:url value="/images/bt/bt_search.gif"/>" level="R"/>
		</td>
	</tr>
	</table>
	<br>
	<table width="100%">
		<tr width="100%">
			<td width="1%">&nbsp;</td>
			<td width="49%"><div id="chart1"></div></td>
		</tr>
		<tr width="100%">
			<td colspan=2>&nbsp;</td>
		</tr>
		<tr>
			<td width="1%">&nbsp;</td>
			<td width="49%"><div id="chart2"></div></td>
		</tr>
		<tr width="100%">
			<td colspan=2>&nbsp;</td>
		</tr>
	</table>

	<!-- grid -->
	<table id="grid" ></table>
	</body>
</html>

