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
var url      = '<c:url value="/onl/admin/common/sysDomainMan.json" />';
var url_view = '<c:url value="/onl/admin/common/sysDomainMan.view" />';


$(document).ready(function() {	
    var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['시스템 도메인명',
                  '시스템 도메인 설명'
                  ],
		colModel:[
				{ name : 'SYSDOMNNAME' , align:'left'	,sortable:false },
				{ name : 'SYSDOMNDESC' , align:'left' }
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
            var key = rowData['SYSDOMNNAME'];
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//검색값
            url2 += '&'+getSearchUrl();
            //key값
            url2 += '&sysDomnName='+key;
            goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=DETAIL';
		url2 += '&page='+$("#grid").getGridParam("page");
		url2 += '&returnUrl='+getReturnUrl();
        url2 += '&menuId='+'${param.menuId}';
		//검색값
        url2 += '&'+getSearchUrl();

        goNav(url2);
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
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">연동시스템</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	
	<!-- comment -->
	<div class="container">
		<div class="left full" >
			<p class="comment" >표준 Header의 기동, 수동 시스템의 관리 및 정합성 보장, IF 시스템과 연동하고 있는 기동, 수동 시스템의 도메인명을 확인할 수 있습니다.</p>
		</div>
	</div>
	
	<!-- button -->
	<table  width="100%" height="35px"  >
	<tr>
		<td align="left">
		<table width="100%">
			<tr>
				<td class="search_td_title" width="150px">시스템 도메인 명</td>
				<td><input type="text" name="searchSysDomnName" value="${param.searchSysDomnName}" style="width:100%"></td>
			</tr>
		</table>
		</td>
		<td align="right" width="200px">
			<img id="btn_new"    src="<c:url value="/images/bt/bt_new.gif"/>"    level="W"/>
			<img id="btn_search" src="<c:url value="/images/bt/bt_search.gif"/>" level="R"/>
		</td>
	</tr>
	</table>	
	<!-- grid -->
	<table id="grid" ></table>
	<div id="pager"></div>
	</body>
</html>

