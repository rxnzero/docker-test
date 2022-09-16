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

 $(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/message/messageMetaMan.json" />',
		postData : gridPostData,
		colNames:['메시지메타구분코드',
                  '메시지설명',
                  '당메시지 사용여부'
                  ],
		colModel:[
				{ name : 'MSGMETADSTCD'  	, align:'left'		,width:40	,sortable:false  },
				{ name : 'MSGDESC'          , align:'center'	,width:40  },
				{ name : 'THISMSGUSEYN'  	, align:'center' 	,width:40   ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '0' ) {
				                 	return '<span style="color:red">사용안함</span>';
                                 } else if ( cellvalue == '1' ) {
				                 	return '사용';
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
            var key = rowData['MSGMETADSTCD'];
            var url = '<c:url value="/bap/admin/message/messageMetaMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//검색값
            url = url + '&'+getSearchUrl();
            //key값
            url = url + '&key='+key;
            goNav(url);
        }		
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
	    var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/message/messageMetaMan.view"/>';
		url = url + '?cmd=DETAIL';
		url = url + '&page='+$("#grid").getGridParam("page");
		url = url + '&returnUrl='+getReturnUrl();
        url = url + '&menuId='+'${param.menuId}';
		//검색값
        url = url + '&'+getSearchUrl();
		
        goNav(url);
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
		<div class="right_box">
			<div class="content_top">
				<ul class="path">
					<li><a href="#">${rmsMenuPath}</a></li>					
				</ul>				
			</div><!-- end content_top -->
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">메시지메타 관리<span class="tooltip">메시지메타 정보를 등록 관리합니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:150px;">메시지메타 구분코드</th>
							<td><input type="text" name="searchMsgMetaDstcd" value="${param.searchMsgMetaDstcd}"></td>
							<th style="width:150px;">메시지 설명</th>
							<td><input type="text" name="searchMsgDesc" value="${param.searchMsgDesc}"></td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>	
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>