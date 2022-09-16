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
var loutName = window.dialogArguments["loutName"];
var url	= '<c:url value="/onl/admin/rule/layoutMan.json"/>';
$(document).ready(function() {		

	$('input[name=searchLoutName]').val(loutName);

	
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		url : url,
		postData : { cmd : 'LIST_POP'
			       , searchEaiBzwkDstcd : $('input[name=searchEaiBzwkDstcd]').val()
			       , searchLoutName     : $('input[name=searchLoutName]').val()
			       , searchLoutDesc     : $('input[name=searchLoutDesc]').val()
			       
		},
		colNames:['업무구분코드',
                  '업무구분명',
                  '전문레이아웃코드',
                  '전문레이아웃설명',
                  '전문레이아웃 유형명'
                  ],
		colModel:[
				{ name : 'EAIBZWKDSTCD'  , align:'left', sortable:false  },
				{ name : 'BZWKDSTICNAME' , align:'left'  },
				{ name : 'LOUTNAME'      , align:'left'  },
				{ name : 'LOUTDESC'      , align:'left'  },
				{ name : 'LOUTPTRNNAME'  , align:'left'  }
				],
		jsonReader : {
			repeatitems : false
		},
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : '${rmsDefaultRowNum}',
		autoheight : true,
		height : $("#container").height(),
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
			var key = rowData['LOUTNAME'];
			var loutDesc = rowData['LOUTDESC'];
			var retData=new Object() ;
			retData['key'] = key;
			retData['loutDesc'] = loutDesc;
			
			window.returnValue = retData;
			$("#btn_close").trigger("click");
        }	
		
	
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST_POP"); //jqgrid에서는 object 로 
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
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
	</body>
</html>