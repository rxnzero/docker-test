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

function list(url){
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/work/messageProcMan.json" />',
		postData : gridPostData,
		colNames:['메시지구분코드',
                  '업무구분명',
                  '송수신파일명',
                  '송수신파일설명',
                  '레코드 길이',
                  '송신여부',
                  '수신여부',
                  '사용여부'
                  ],
		colModel:[
				{ name : 'BJOBMSGDSTCD'       , hidden:true },
				{ name : 'BJOBBZWKNAME'       , align:'left'  },
				{ name : 'BJOBTRANDSTCDNAME'  , align:'left'  },
				{ name : 'BJOBMSGDSTICNAME'   , align:'left'  },
				{ name : 'BJOBTELGMRECSIZE'   , align:'center'}, 
				{ name : 'EAIFILESENDUSEYN'   , align:'center',
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '사용';
                              } else {
                                  return '<span style="color:red">사용안함</span>';
                              }
                          }
                },
				{ name : 'EAIFILERECVUSEYN'    , align:'center',
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '사용';
                              } else {
                                  return '<span style="color:red">사용안함</span>';
                              }
                          }
                },
				{ name : 'THISMSGUSEYN'            , align:'center',
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '사용';
                              } else {
                                  return '<span style="color:red">사용안함</span>';
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
            var bjobMsgDstcd = rowData['BJOBMSGDSTCD'].trim();
            var url = '<c:url value="/bap/admin/work/messageProcMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&menuId='+'${param.menuId}';
	    	url = url + '&returnUrl='+getReturnUrl();
            url = url + '&bjobMsgDstcd='+bjobMsgDstcd;
            url = url + '&'+getSearchUrl();
		    //검색값
            goNav(url);
        }
	});
}

$(document).ready(function() {	

	resizeJqGridWidth('grid','title','1000');
	var url ='<c:url value="/bap/admin/work/messageProcMan.json" />';
	list(url);

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({url:url, postData: postData,page:"1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/work/messageProcMan.view"/>';
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
	$("input[name^=like]").keydown(function(key){
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
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">송수신 파일 관리<span class="tooltip">일괄 전송에서 사용하는 송수신 파일을 관리 하는 화면입니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">업무구분명</th>
							<td><input type="text" name="likeBjobBzwkName" value="${param.likeBjobBzwkName}"></td>
							<th style="width:180px;">송수신파일명</th>
							<td><input type="text" name="likeBjobTranDstcdName" value="${param.likeBjobTranDstcdName}"></td>
							<th style="width:180px;">송수신파일설명</th>
							<td><input type="text" name="likeBjobMsgDsticName" value="${param.likeBjobMsgDsticName}"></td>
							<th style="width:180px;" hidden="hidden">어플리케이션코드</th>
							<td hidden="hidden"><input type="text" name="likeUapplCd" value="${param.likeUapplCd}"></td>
							<th style="width:180px;" hidden="hidden">담당자ID</th>
							<td hidden="hidden"><input type="text" name="likeThisMsgChrgIDs" value="${param.likeThisMsgChrgIDs}"></td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

