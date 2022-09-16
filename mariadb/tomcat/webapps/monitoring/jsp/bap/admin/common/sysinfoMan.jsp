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

	var url      = '<c:url value="/bap/admin/common/sysinfoMan.json" />';
	var url_view = '<c:url value="/bap/admin/common/sysinfoMan.view" />';

	function init( callback ) {
		if (typeof callback === 'function') {
			callback();
		}
	}

	function detail(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
	}

$(document).ready(function() {	
debugger;
	init( detail);
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : getSearchForJqgrid("cmd","LIST"),
		colNames:['시스템코드',
		          '시스템명칭',
                  '시스템IP',
                  '유저ID',
                  '송신디렉토리',
                  '수신디렉토리',
                  'SFTP여부',
                  '사용여부'
                  ],
		colModel:[
				{ name : 'SYSCD'         , align:'center' ,width:40	,sortable:false   },
				{ name : 'SYSNAME'       , align:'center' ,width:40   },
				{ name : 'SYSIP'         , align:'center' ,width:40   },
				{ name : 'USERID'        , align:'center' ,width:40   },
				{ name : 'SENDDIR'       , align:'center' ,width:40   },
				{ name : 'RECVDIR'       , align:'center' ,width:40   },
				{ name : 'SFTPYN'        , align:'center' ,width:40   ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '0' ) {
				                 	return 'FTP';
                                 } else if ( cellvalue == '1' ) {
				                 	return 'SFTP';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				},
				{ name : 'THISMSGUSEYN'  , align:'center' ,width:40   ,
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
            var sysCd = rowData['SYSCD'];
            var url2 = url_view;
            url2 = url2 + '?cmd=DETAIL';
            url2 = url2 + '&page='+$(this).getGridParam("page");
            url2 = url2 + '&returnUrl='+getReturnUrl();
            url2 = url2 + '&menuId='+'${param.menuId}';
			//검색값
            url2 = url2 + '&'+getSearchUrl();
            //key값
            url2 = url2 + '&sysCd='+sysCd;
            goNav(url2);
        }
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	
	$("#btn_new").click(function(){
		var url = url_view;
		url = url + '?cmd=DETAIL';
		url = url + '&page='+$(this).getGridParam("page");
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">내부 연계 시스템 관리</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">시스템 코드</th>
							<td><input type="text" name="searchSysCd" value="${param.searchSysCd}"></td>
							<th style="width:180px;">시스템 명</th>
							<td><input type="text" name="searchSysName" value="${param.searchSysName}"></td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>