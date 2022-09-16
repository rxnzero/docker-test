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


<script language="javascript" >
var url      ='<c:url value="/onl/statistics/eaibzwkdstcd/eaiBzwkDstcdMonthlyMan.json" />';
var url_view ='<c:url value="/onl/statistics/eaibzwkdstcd/eaiBzwkDstcdMonthlyMan.view" />';

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
	//$("input[name=searchStart]").val('201212');
	//$("input[name=searchEnd]").val('201212');
	
// 	detail();

	//chart('chart1',data,'DDTRSMTNOITM');
// 	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 

	// Grid 조회.
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['업무명'
		         ,'전송','오류','전송','오류','전송','오류','전송','오류','전송','오류','전송','오류','전송','오류','전송','오류','전송','오류','전송','오류'
		         ,'전송','오류','전송','오류'
                  ],
		colModel:[
				{ name : 'EAIBZWKDSTCD'		, align:'left'  ,width:'200px'	,sortable:false},
				{ name : 'MNTRSMTNOITM1'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM1',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM1'		, align:'right' ,width:'60px'	, index:'MNERRNOITM1',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM2'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM2',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM2'		, align:'right' ,width:'60px'	, index:'MNERRNOITM2',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM3'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM3',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM3'		, align:'right' ,width:'60px'	, index:'MNERRNOITM3',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM4'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM4',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM4'		, align:'right' ,width:'60px'	, index:'MNERRNOITM4',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM5'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM5',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM5'		, align:'right' ,width:'60px'	, index:'MNERRNOITM5',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM6'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM6',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM6'		, align:'right' ,width:'60px'	, index:'MNERRNOITM6',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM7'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM7',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM7'		, align:'right' ,width:'60px'	, index:'MNERRNOITM7',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM8'	, align:'right' ,width:'60px'	, index:'MNTRSMTNOITM8',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM8'		, align:'right'	,width:'60px'	, index:'MNERRNOITM8',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM9'	, align:'right'	,width:'60px'	, index:'MNTRSMTNOITM9',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM9'		, align:'right'	,width:'60px'	, index:'MNERRNOITM9',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM10'	, align:'right'	,width:'60px'	, index:'MNTRSMTNOITM10',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM10'		, align:'right'	,width:'60px'	, index:'MNERRNOITM10',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM11'	, align:'right'	,width:'60px'	, index:'MNTRSMTNOITM11',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM11'		, align:'right'	,width:'60px'	, index:'MNERRNOITM11',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNTRSMTNOITM12'	, align:'right'	,width:'60px'	, index:'MNTRSMTNOITM12',	formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'MNERRNOITM12'		, align:'right'	,width:'60px'	, index:'MNERRNOITM12',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"}
				],
				//SUM(1DDTRSMTNOITM) AS DDTRSMTNOITM1,  SUM(1DDERRNOITM) AS DDERRNOITM1,  SUM(1DDRSPNSAVGVAL) AS DDRSPNSAVGVAL1,
				
        jsonReader: {
             repeatitems:false
        },	          
		
	    height: 260,
		autowidth: true,
	    
		pager : $('#pager'),
		rowNum : 10000,
		viewrecords: true,
		gridview: true,				// jqGrid의 성능 향상 - treeGrid, subGrid, afterInsertRow event의 경우 제외.
		shrinkTofit:false,
		
		footerrow:true,
		userDataOnFooter:true,
		rownumbers:true,
		//forceFit:true,
		//rowList : eval('[${rmsDefaultRowList}]'),
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
				var sumData		= d.totalSum;
				var sumDataObj	= new Object();
				var i = 1;
				
				// 차트 생성.
				plotChart1 = jqLineChart('chart1', data, 12,'MNTRSMTNOITM', "전송건수");
				plotChart2 = jqLineChart('chart2', data, 12,'MNERRNOITM', "오류건수");
				
				// Summary CSS 설정.
				$(".ui-jqgrid-ftable tr:first").children("td").css("background-color", "#D4F4FA");	// td 배경색
				$(".ui-jqgrid-ftable tr:first").css("height", "30px");								// tr 높이
				$(".ui-jqgrid-ftable tr:first").css("font-size", "10pt");							// tr 글자 크기
				$(".ui-jqgrid-ftable td:eq(1)").css("text-align", "center");						// td 글자 정렬
				
				// 합계 셋팅.
				while(sumData["MNTRSMTNOITM"+i+"_SUM"] != undefined)
				{
					if(i==1)
						sumDataObj["EAIBZWKDSTCD"] = "합계";
					
					sumDataObj["MNTRSMTNOITM"+i]	= sumData["MNTRSMTNOITM" + i + "_SUM"];
					sumDataObj["MNERRNOITM"+i]		= sumData["MNERRNOITM" + i + "_SUM"];
					
					i++;
				}
				
				$(this).jqGrid("footerData", "set",sumDataObj);
				// End 합계 셋팅.
			}
		},
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
			var data =[];
			
			if(plotChart1 != undefined)
			{
				// 차트 삭제
				plotChart1.destroy();
				plotChart2.destroy();
			}
			
			// 차트 생성.
			data[0]=rowData;
			plotChart1 = jqLineChart('chart1', data, 12,'MNTRSMTNOITM', "전송건수");
			plotChart2 = jqLineChart('chart2', data, 12,'MNERRNOITM', "오류건수");
        },
	});
	
	
	$("#grid").jqGrid('setGroupHeaders', {
  		useColSpanStyle: true, 
  		groupHeaders:[
			{startColumnName: 'MNTRSMTNOITM1', numberOfColumns: 2, titleText: '1'},
			{startColumnName: 'MNTRSMTNOITM2', numberOfColumns: 2, titleText: '2'},
			{startColumnName: 'MNTRSMTNOITM3', numberOfColumns: 2, titleText: '3'},
			{startColumnName: 'MNTRSMTNOITM4', numberOfColumns: 2, titleText: '4'},
			{startColumnName: 'MNTRSMTNOITM5', numberOfColumns: 2, titleText: '5'},
			{startColumnName: 'MNTRSMTNOITM6', numberOfColumns: 2, titleText: '6'},
			{startColumnName: 'MNTRSMTNOITM7', numberOfColumns: 2, titleText: '7'},
			{startColumnName: 'MNTRSMTNOITM8', numberOfColumns: 2, titleText: '8'},
			{startColumnName: 'MNTRSMTNOITM9', numberOfColumns: 2, titleText: '9'},
			{startColumnName: 'MNTRSMTNOITM10', numberOfColumns: 2, titleText: '10'},
			{startColumnName: 'MNTRSMTNOITM11', numberOfColumns: 2, titleText: '11'},
			{startColumnName: 'MNTRSMTNOITM12', numberOfColumns: 2, titleText: '12'}
  		]
	});
	
	
	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
		
		if(!isFromToDate(postData.searchStart, postData.searchEnd))
		{
			alert("입력한 날짜를 확인하여주십시요.\n"
				 + "시작일 : " + setDateFormat(postData.searchStart) + "\n"
				 + "종료일 : " + setDateFormat(postData.searchEnd));
			return;
		}
		
		if(plotChart1 != undefined)
		{
			// 차트 삭제
			plotChart1.destroy();
			plotChart2.destroy();
		}
		
		plotChart1 = null;
		plotChart2 = null;
		
		// grid 조회
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
				<div class="title">업무별 월별 거래현황</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:120px;">업무명</th>
							<td>
								<input type="text" name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
							</td>
							<th style="width:120px;">기간</th>
							<td>
								<input type="text" name="searchStart" value="${param.searchStart}" style="width:100px"> ~
								<input type="text" name="searchEnd" value="${param.searchEnd}" style="width:100px">	
							</td>							
						</tr>						
					</tbody>
				</table>
				
				<table width="100%">
					<tr width="100%">						
						<td width="50%"><div id="chart1" style="height:300px;"></div></td>						
						<td width="50%"><div id="chart2" style="height:300px;"></div></td>
					</tr>					
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

