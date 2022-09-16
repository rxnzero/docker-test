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
var url      ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameYearlyMan.view" />';
var url_view ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameYearlyMan.json" />';

var plotChart1;			// jqplot ���� (chart1).
var plotChart2;			// jqplot ���� (chart2).

function detail(){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$("#grid").setGridParam({ url:url,postData: postData ,page:1 }).trigger("reloadGrid");
}

$(document).ready(function() {
	
	$("input[name=searchStart],input[name=searchEnd]").inputmask("9999",{'autoUnmask':true});
	$("input[name=searchStart],input[name=searchEnd]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == ""){
			$(this).val(getToday());
		}
	});
	
	// Grid ��ȸ.
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['�⵵', '�����ڵ�'
		         ,'������','����','����'
                  ],
		colModel:[
				{ name : 'STATCY'		, align:'left'	,width:'60px'},
				{ name : 'EAIBZWKDSTCD'	, hidden: true	,sortable:false},
				{ name : 'EAISVCDESC'	, align:'left'	,width:'200px' },
				{ name : 'YNTRSMTNOITM'	, align:'right'	,width:'60px'	, index:'YNTRSMTNOITM',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"},
				{ name : 'YNERRNOITM'	, align:'right'	,width:'60px'	, index:'YNERRNOITM',		formatter: 'integer', formatoptions:{thousandsSeparator:","}, summaryType:"sum"}
				],
        jsonReader: {
             repeatitems:false
        },
        
        autoheight: true,
	    height: 260,
	    	          
		rowNum : 10000,				// Grid�� ǥ�õ� ���ڵ� �� ����.
		gridview: true,				// jqGrid�� ���� ��� - treeGrid, subGrid, afterInsertRow event�� ��� ����.
		
		footerrow:true,				// �ϴܿ� summary row ��¿���.(default: false)
		userDataOnFooter:true,
		rownumbers:true,			// Grid�� ���ȣ ��¿���.(default: false)
		
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)		
			}
		},
		loadComplete:function (d){
		
			if(plotChart1 == undefined || plotChart1 == null)
			{
				var data = d.rows;

				// ��Ʈ ����.
				plotChart1 = jqBarchart('chart1', data, "EAISVCDESC",'YNTRSMTNOITM', "���۰Ǽ�");
				plotChart2 = jqBarchart('chart2', data, "EAISVCDESC",'YNERRNOITM', "�����Ǽ�");
				
				// Summary CSS ����.
				$(".ui-jqgrid-ftable tr:first").children("td").css("background-color", "#D4F4FA");	// td ����
				$(".ui-jqgrid-ftable tr:first").css("height", "30px");								// tr ����
				$(".ui-jqgrid-ftable tr:first").css("font-size", "10pt");							// tr ���� ũ��
				$(".ui-jqgrid-ftable td:eq(1)").css("text-align", "center");						// td ���� ����
				
				var yntrsmtnoitm_sum = $("#grid").jqGrid("getCol", "YNTRSMTNOITM", false, 'sum');
				var ynerrnoitm_sum = $("#grid").jqGrid("getCol", "YNERRNOITM", false, 'sum');
													   
				$("#grid").jqGrid("footerData", "set", {STATCY:"�հ�", YNTRSMTNOITM:yntrsmtnoitm_sum
																	, YNERRNOITM:ynerrnoitm_sum
													   });
			}
		}		
	});
	
	$("#btn_search").click(function(){
// 		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��
		
// 		if(!isFromToDate(postData.searchStart, postData.searchEnd))
// 		{
// 			alert("�Է��� ��¥�� Ȯ���Ͽ��ֽʽÿ�.\n"
// 				 + "������ : " + setDateFormat(postData.searchStart) + "\n"
// 				 + "������ : " + setDateFormat(postData.searchEnd));
// 			return;
// 		}
		
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
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">���񽺺� �Ⱓ �ŷ���Ȳ</p>
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
				<td class="search_td_title" width="120px">������</td>
				<td>
					<input type='text' name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}" style="width:100%"/>
				</td>
<!-- 				<td class="search_td_title" width="120px">�Ⱓ</td> -->
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
	
	<!-- chart -->
	<br>
	<table width="99%">
		<tr width="100%">
			<td width="1%">&nbsp;</td>
			<td width="43%"><div id="chart1"></div></td>
		</tr>
		<tr width="100%">
			<td colspan=2 height=40px>&nbsp;</td>
		</tr>
		<tr>
			<td width="1%">&nbsp;</td>
			<td width="43%"><div id="chart2"></div></td>
		</tr>
		<tr width="100%">
			<td colspan=2>&nbsp;</td>
		</tr>
	</table>
	<br>
	
	<!-- grid -->
	<table id="grid"></table>
	</body>
</html>

