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

<jsp:include page="/jsp/common/include/jqplotCss.jsp"/>
<jsp:include page="/jsp/common/include/jqplotScript.jsp"/>


<script language="javascript" >
var url      ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameDailyMan.json" />';
var url_view ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameDailyMan.view" />';

var plotChart1;			// jqplot ���� (chart1).
var plotChart2;			// jqplot ���� (chart2).

// Browser ������ ���� jqgrid�� �ɼ��߿� rownum ���� �����մϴ�.
function getRowNum()
{
	return ieV8Chk() ? 100 : 10000;
}

function detail(){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$("#grid").setGridParam({ url:url,postData: postData ,page:1 }).trigger("reloadGrid");
}

$(document).ready(function() {

	$("input[name=searchStart],input[name=searchEnd]").inputmask("9999-99",{'autoUnmask':true});
	$("input[name=searchStart],input[name=searchEnd]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == ""){
			$(this).val(getToday());
		}
	});
	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��
	
	$('#grid').jqGrid({
		datatype:'json',
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['�����ڵ�', '������'
		         ,'����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����'
		         ,'����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����'
		         ,'����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����','����'
                 ,'����','����'
                  ],
		colModel:[
// 				{ name : 'EAIBZWKDSTCD'		, hidden:true		, sortable:false},
				{ name : 'EAISVCNAME'		, sortable:false},
				{ name : 'EAISVCDESC'		, align:'left'		,width:'200px'},
				{ name : 'DDTRSMTNOITM1'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM1'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM2'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM2'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM3'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM3'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM4'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM4'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM5'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM5'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM6'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM6'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM7'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM7'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM8'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM8'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM9'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM9'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM10'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM10'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM11'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM11'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM12'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM12'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM13'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM13'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM14'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM14'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM15'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM15'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM16'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM16'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM17'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM17'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM18'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM18'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM19'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM19'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM20'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM20'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM21'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM21'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM22'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM22'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM23'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM23'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM24'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM24'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM25'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM25'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM26'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM26'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM27'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM27'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM28'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM28'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM29'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM29'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM30'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM30'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDTRSMTNOITM31'	, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} },
				{ name : 'DDERRNOITM31'		, align:'right'		,width:'60px'	, 	formatter: 'integer', formatoptions:{thousandsSeparator:","} }
				],
				
        jsonReader: {
             repeatitems:false
        },
	    height: 260,
	    autowidth: true,
	    
		rowNum : 10000,								// Grid�� ǥ�õ� ���ڵ� �� ����.
// 		rowList : eval('[${rmsDefaultRowList}]'),	// Grid�� ǥ���� ���ڵ� ���� �����ϴ� Select Box ����.
		viewrecords: true,							// �� ���ڵ� ���� ����¡�ٿ� ǥ��. (default: false)
		gridview: true,								// jqGrid�� ���� ��� - treeGrid, subGrid, afterInsertRow event�� ��� ����.
		shrinkToFit: false,							// ���� ��ũ�ѹ� ���
		
		footerrow:true,								// �ϴܿ� summary row ��¿���.(default: false) 
		userDataOnFooter:true,
		rownumbers:true,							// Grid�� ���ȣ ��¿���.(default: false)
		
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)		
			}
		},
		loadComplete:function (d){

			if(plotChart1 == undefined || plotChart1 == null)
			{
				var rowsData	= d.rows;
				var sumData		= d.totalSum;
				var sumDataObj	= new Object();
				var i = 1;

				// ��Ʈ ����.
				plotChart1 = jqLineChart('chart1',rowsData, 31, 'DDTRSMTNOITM', "���۰Ǽ�");
				plotChart2 = jqLineChart('chart2',rowsData, 31, 'DDERRNOITM', "�����Ǽ�");

	 			// Summary CSS ����.
				$(".ui-jqgrid-ftable tr:first").children("td").css("background-color", "#D4F4FA");	// td ����
				$(".ui-jqgrid-ftable tr:first").css("height", "30px");								// tr ����
				$(".ui-jqgrid-ftable tr:first").css("font-size", "10pt");							// tr ���� ũ��
				$(".ui-jqgrid-ftable td:eq(2)").css("text-align", "center");						// td ���� ����
				
				// �հ� ����.
				while(sumData["DDTRSMTNOITM"+i+"_SUM"] != undefined)
				{
					if(i==1)
						sumDataObj["EAISVCDESC"] = "�հ�";
					
					sumDataObj["DDTRSMTNOITM"+i]	= sumData["DDTRSMTNOITM" + i + "_SUM"];
					sumDataObj["DDERRNOITM"+i]		= sumData["DDERRNOITM" + i + "_SUM"];
					
					i++;
				}
				
				$(this).jqGrid("footerData", "set",sumDataObj);
				// End �հ� ����.
			}
		},
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
			var data =[];

			if(plotChart1 != undefined)
			{
				// ��Ʈ ����
				plotChart1.destroy();
				plotChart2.destroy();
			}
			
			// ��Ʈ ����.
			data[0]=rowData;
			plotChart1 = jqLineChart('chart1', data, 31, 'DDTRSMTNOITM', "���۰Ǽ�");
			plotChart2 = jqLineChart('chart2', data, 31, 'DDERRNOITM', "�����Ǽ�");
        }
	});
	
	
	$("#grid").jqGrid('setGroupHeaders', {
  		useColSpanStyle: true, 
  		groupHeaders:[
			{startColumnName: 'DDTRSMTNOITM1', numberOfColumns: 2, titleText: '1'},
			{startColumnName: 'DDTRSMTNOITM2', numberOfColumns: 2, titleText: '2'},
			{startColumnName: 'DDTRSMTNOITM3', numberOfColumns: 2, titleText: '3'},
			{startColumnName: 'DDTRSMTNOITM4', numberOfColumns: 2, titleText: '4'},
			{startColumnName: 'DDTRSMTNOITM5', numberOfColumns: 2, titleText: '5'},
			{startColumnName: 'DDTRSMTNOITM6', numberOfColumns: 2, titleText: '6'},
			{startColumnName: 'DDTRSMTNOITM7', numberOfColumns: 2, titleText: '7'},
			{startColumnName: 'DDTRSMTNOITM8', numberOfColumns: 2, titleText: '8'},
			{startColumnName: 'DDTRSMTNOITM9', numberOfColumns: 2, titleText: '9'},
			{startColumnName: 'DDTRSMTNOITM10', numberOfColumns: 2, titleText: '10'},
			{startColumnName: 'DDTRSMTNOITM11', numberOfColumns: 2, titleText: '11'},
			{startColumnName: 'DDTRSMTNOITM12', numberOfColumns: 2, titleText: '12'},
			{startColumnName: 'DDTRSMTNOITM13', numberOfColumns: 2, titleText: '13'},
			{startColumnName: 'DDTRSMTNOITM14', numberOfColumns: 2, titleText: '14'},
			{startColumnName: 'DDTRSMTNOITM15', numberOfColumns: 2, titleText: '15'},
			{startColumnName: 'DDTRSMTNOITM16', numberOfColumns: 2, titleText: '16'},
			{startColumnName: 'DDTRSMTNOITM17', numberOfColumns: 2, titleText: '17'},
			{startColumnName: 'DDTRSMTNOITM18', numberOfColumns: 2, titleText: '18'},
			{startColumnName: 'DDTRSMTNOITM19', numberOfColumns: 2, titleText: '19'},
			{startColumnName: 'DDTRSMTNOITM20', numberOfColumns: 2, titleText: '20'},
			{startColumnName: 'DDTRSMTNOITM21', numberOfColumns: 2, titleText: '21'},
			{startColumnName: 'DDTRSMTNOITM22', numberOfColumns: 2, titleText: '22'},
			{startColumnName: 'DDTRSMTNOITM23', numberOfColumns: 2, titleText: '23'},
			{startColumnName: 'DDTRSMTNOITM24', numberOfColumns: 2, titleText: '24'},
			{startColumnName: 'DDTRSMTNOITM25', numberOfColumns: 2, titleText: '25'},
			{startColumnName: 'DDTRSMTNOITM26', numberOfColumns: 2, titleText: '26'},
			{startColumnName: 'DDTRSMTNOITM27', numberOfColumns: 2, titleText: '27'},
			{startColumnName: 'DDTRSMTNOITM28', numberOfColumns: 2, titleText: '28'},
			{startColumnName: 'DDTRSMTNOITM29', numberOfColumns: 2, titleText: '29'},
			{startColumnName: 'DDTRSMTNOITM30', numberOfColumns: 2, titleText: '30'},
			{startColumnName: 'DDTRSMTNOITM31', numberOfColumns: 2, titleText: '31'}
  		]
	});
	
	
	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��
		
		if(!isFromToDate(postData.searchStart, postData.searchEnd, "yymm"))
		{
			alert("�Է��� ��¥�� Ȯ���Ͽ��ֽʽÿ�.\n"
				 + "������ : " + setDateFormat(postData.searchStart) + "\n"
				 + "������ : " + setDateFormat(postData.searchEnd));
			return;
		}
		
		if(plotChart1 != undefined)
		{
			// ��Ʈ ����
			plotChart1.destroy();
			plotChart2.destroy();
		}
		
		plotChart1 = null;
		plotChart2 = null;
		
		// grid ��ȸ
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
				<div class="title">���񽺺� �Ϻ� �ŷ���Ȳ</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:120px;">������</th>
							<td>
								<input type="text" name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
							</td>
							<th style="width:120px;">�Ⱓ</th>
							<td>
								<input type="text" name="searchStart" value="${param.searchStart}" style="width:100px"> ~
								<input type="text" name="searchEnd" value="${param.searchEnd}" style="width:100px">					
							</td>							
						</tr>						
					</tbody>
				</table>
				
				<table width="100%">
					<tr width="100%">						
						<td width="50%"><div id="chart1"></div></td>						
						<td width="50%"><div id="chart2"></div></td>
					</tr>					
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

