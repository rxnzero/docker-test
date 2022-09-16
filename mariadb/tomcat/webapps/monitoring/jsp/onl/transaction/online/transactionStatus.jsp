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
var url      = '<c:url value="/onl/transaction/online/transactionStatus.json" />';
var url_view = '<c:url value="/onl/transaction/online/transactionStatus.view" />';
var timer;
var recentYn="N";
function list(recentYn){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��
	postData["recentYn"] = recentYn;
	$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
}
	
	
$(document).ready(function() {	
	//var gridPostData = getSearchForJqgrid("cmd", "LIST"); //jqgrid������ object �� 
	
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		//url : url,
		//postData : gridPostData,
		colNames : [ 
		             '���������ڵ�',
		             '�������и�',
		             '100',
		             '200',
		             '300',
		             '400',
		             '100',
		             '200',
		             '300',
		             '400',
		             '900',
		             '300',
		             '400',
		             '900',
		             'IF',
		             '����',
		             '��',
		              ],
		colModel : [ 
		             { name : 'BIZCODE'    , hidden : true },
		             { name : 'BIZNAME'    , align : 'left'    },
		             { name : 'P100'       , align : 'center'   , width:'50'	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'  },
		             { name : 'P200'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'P300'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'P400'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
                                           
		             { name : 'E100'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E200'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E300'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E400'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E900'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},

		             { name : 'E9300'      , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E9400'      , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E9900'      , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},

		             { name : 'AVGEAI'     , align : 'center'   , width:'46'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'avg'},
		             { name : 'AVGPSV'     , align : 'center'   , width:'46'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'avg'},
		             { name : 'AVGTOTAL'   , align : 'center'   , width:'46'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'avg'}

		              ],
		jsonReader : {
			repeatitems : false
		},
		footerrow:true,
		userDataOnFooter:true,
		rowNum: 10000,
		height : 480,
		viewrecords : true,
		gridview: true,
		frozen:true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
		    var key = rowData['BIZCODE'];
		    var url2 = url_view;
		    url2 += "?cmd=DETAIL";
		    url2 += "&searchEaiBzwkDstcd="+key;
		    goNav(url2);
		},
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}
		
		},			
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    	var rowCnt = $('#grid').getGridParam("reccount");
	    	var colModel = $(this).getGridParam("colModel");
	    	for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
				var propName = colModel[i].name;
				var summaryType = colModel[i].summaryType;
				var Total = $('#grid').jqGrid('getCol',propName,false,'sum');
				if(summaryType =='avg'){
					if(rowCnt == 0) 
						Total = 0;
					else
	    				Total = (Total/rowCnt).toFixed(3);		//avg�� �ٷ� ���� row ���� +1 �Ǿ� ����.
	    		}	
	    		eval("$('#grid').jqGrid('footerData','set',{BIZNAME:'�հ�', "+propName+":Total});");
	    	}
			
			$(".ui-jqgrid-ftable tr:first").children("td").css("background-color", "#D4F4FA");	// td ����
			$(".ui-jqgrid-ftable tr:first").css("height", "30px");								// tr ����
			$(".ui-jqgrid-ftable tr:first").css("font-size", "10pt");							// tr ���� ũ��
			$(".ui-jqgrid-ftable td:eq(1)").css("text-align", "center");						// td ���� ����	    	

			$(".ui-jqgrid-ftable").css('position','fixed');					// �Ұ� �ϴܿ� ����
			$(".ui-jqgrid-ftable").css('bottom','0');
			
	    },
	    loadError:function(xhr,status,error){
	    	//alert(error);
	    	//clearInterval(timer);
	    }	
		
	});
	$("#grid").jqGrid('setGroupHeaders', {
  		useColSpanStyle: true, 
  		groupHeaders:[
			{startColumnName: 'P100', numberOfColumns: 4, titleText: '���������� ó���Ǽ�'},
			{startColumnName: 'E100', numberOfColumns: 5, titleText: '���������� �����Ǽ�'},
			{startColumnName: 'E9300', numberOfColumns: 3, titleText: 'Ÿ�� �ƿ�'},
			{startColumnName: 'AVGEAI', numberOfColumns: 3, titleText: '���ó���ð�(��)'}
  		]
	});
	
	$("#btn_10min").click(function(){
		recentYn ="Y";
		list(recentYn);
	});
	$("#btn_detail").click(function(){
	    var args = new Object();
	    args['userId'] = $("input[name=userId]").val();
	    
	    var url2 = url_view;
	    url2 += "?cmd=POPUP";
	    showModal(url2,args,470,740);
	});	
	$("#btn_initialize").click(function(){
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZE',recentYn:recentYn},
			success:function(json){
				alert("�����Ͽ����ϴ�.");
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
		
	});	
	$("#btn_download").click(function(event) {
           event.stopPropagation(); // Do not propagate the event.
           // Create an object that will manage to download the file.
           var merge = new Array();
           merge.push(makeMerge("��������","0","1","0","0"));
           merge.push(makeMerge("���������� ó���Ǽ�","0","0","1","4"));
           merge.push(makeMerge("���������� �����Ǽ�","0","0","5","9"));
           merge.push(makeMerge("Ÿ�Ӿƿ�","0","0","10","12"));
           merge.push(makeMerge("���ó���ð�(��)","0","0","13","15"));
           
		gridToExcelSubmit(url,"LIST_GRID_TO_EXCEL",$("#grid"),$("#ajaxForm"),"������ �ŷ���Ȳ",merge);
		return false;
	});		
	buttonControl();

	window.onload=function(){
		list(recentYn);
	}
	timer = setInterval(function(){
		list(recentYn);
	},5000);
	
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
					<img src="<c:url value="/img/btn_10min.png" />" alt="" id="btn_10min" level="W" />
					<img src="<c:url value="/img/btn_detail.png" />" alt="" id="btn_detail" level="R" />
					<img src="<c:url value="/img/btn_initialize.png" />" alt="" id="btn_initialize" level="W" />
					<img src="<c:url value="/img/btn_download.png" />" alt="" id="btn_download" level="W" />
				</div>
				<div class="title">������ �ŷ���Ȳ(�ϴ���)<span class="tooltip">100=��û���� 200=��û�۽� 300=������� 400=����۽� 900=IF���ο���</span></div>
				<table id="grid" ></table>
				<div id="pager"></div>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

