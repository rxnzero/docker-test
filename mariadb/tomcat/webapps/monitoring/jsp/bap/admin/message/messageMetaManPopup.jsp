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
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/message/messageItemMan.json" />',
		postData : gridPostData,
		colNames:['메시지항목구분명',
                  '메시지컬럼명',
                  '메시지컬럼 속성유형코드',
                  '메시지컬럼값',
                  '당메시지 컬럼 사용여부'
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
				$(this).setColProp(colModel[i].name, {sortable : false});	//그리드 헤더 화살표 삭제(정렬X)		
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
	    var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
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
			<div class="title">메시지항목 관리</div>						
			<table class="search_condition" cellspacing="0">
				<tr>
					<th style="width:150px;">메시지항목 구분명</th>
					<td><input type="text" name="searchMsgItemDsticName" value="${param.searchMsgItemDsticName}"></td>
					<th style="width:150px;">메시지 컬럼명</th>
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