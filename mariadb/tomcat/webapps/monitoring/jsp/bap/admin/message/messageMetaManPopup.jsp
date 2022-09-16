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
var arg = window.dialogArguments["check"];
 $(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/message/messageItemMan.json" />',
		postData : gridPostData,
		colNames:['�޽����׸񱸺и�',
                  '�޽����÷���',
                  '�޽����÷� �Ӽ������ڵ�',
                  '�޽����÷���',
                  '��޽��� �÷� ��뿩��'
                  ],
		colModel:[
				{ name : 'MSGITEMDSTICNAME'  	, align:'left'		,width:40	,sortable:false  },
				{ name : 'MSGCLMNNAME'          , align:'center'	,width:40  },
				{ name : 'MSGCLMNATTRIPTRNCD'   , align:'center'	,width:40  },
				{ name : 'MSGCLMNVAL'         	, align:'center'  	,width:40  },
				{ name : 'THISMSGCLMNUSEYN'  	, align:'center' 	,width:40   ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '0' ) {
				                 	return '<span style="color:red">FALSE</span>';
                                 } else if ( cellvalue == '1' ) {
				                 	return 'TRUE';
                                 } else {
                                  	return cellvalue;
                                 }
                              }	
                }			
				],
        jsonReader: {
             repeatitems:false
        },	          
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : '${rmsDefaultRowNum}',
	    autoheight: true,
	    height: $("#container").height(),
		autowidth: true,
		viewrecords: true,
		rowList : eval('[${rmsDefaultRowList}]'),
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)		
			}
		
		},			
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
			window.returnValue = rowData;
			$("#btn_close").trigger("click");
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
	    var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
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
				<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" />	
			</div>
			<div class="title">�޽����׸� ����</div>						
			<table class="search_condition" cellspacing="0">
				<tr>
					<th style="width:150px;">�޽����׸� ���и�</th>
					<td><input type="text" name="searchMsgItemDsticName" value="${param.searchMsgItemDsticName}"></td>
					<th style="width:150px;">�޽��� �÷���</th>
					<td><input type="text" name="searchMsgClmnName" value="${param.searchMsgClmnName}"></td>
				</tr>
			</table>
			<!-- tree -->
			<table id="grid" ></table>
			<div id="pager"></div>	
			</div><!-- end content_middle -->
		</div><!-- end popup_box -->	
	</body>
</html>