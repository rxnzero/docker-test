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
var url      = '<c:url value="/onl/admin/rule/transformFuncMan.json" />';
var url_view = '<c:url value="/onl/admin/rule/transformFuncMan.view" />';
var select_CNVSNFUNTNRETUNPTRNIDNAME = new Array();
var select_CNVSNFUNTNPTRNIDNAME      = new Array();

function init( callback) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_COMBO'},
		success:function(json){
			
			select_CNVSNFUNTNRETUNPTRNIDNAME['value'] = ": ;"+getGridSelectText("CODE","NAME",json.returnTypeList);
			select_CNVSNFUNTNPTRNIDNAME['value']      = ": ;"+getGridSelectText("CODE","NAME",json.typeList);

			if (typeof callback === 'function') {
				callback();
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});	
}
function detail(){
    var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['변환함수명',
                  '변환함수반환유형명',
                  '변환함수 클래스명',
                  '변환함수 유형ID'
                  ],
		colModel:[
				{ name : 'CNVSNFUNTNNAME'            , align:'left'	,sortable:false  },
				{ name : 'CNVSNFUNTNRETUNPTRNIDNAME' , align:'left'  , edittype:'select',editoptions:select_CNVSNFUNTNRETUNPTRNIDNAME, formatter:"select"},
				{ name : 'CNVSNFUNTNCLSNAME'         , align:'left'  },
				{ name : 'CNVSNFUNTNPTRNIDNAME'      , align:'left'  , edittype:'select',editoptions:select_CNVSNFUNTNPTRNIDNAME, formatter:"select"}
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
            var key = rowData['CNVSNFUNTNNAME'];
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//검색값
            url2 += '&'+getSearchUrl();
            //key값
            url2 += '&cnvsnFuntnName='+key;
            goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');	
}

$(document).ready(function() {	
    init(detail);



	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1"  }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=DETAIL';
		url2 += '&page=1';
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
		<div class="right_box">
			<div class="content_top">
				<ul class="path">
					<li><a href="#">${rmsMenuPath}</a></li>					
				</ul>					
			</div><!-- end content_top -->
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" />
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />		
				</div>
				<div class="title">변환함수 관리<span class="tooltip">변환엔진의 변환함수를 조회하는 화면입니다. 변환엔진에서 메시지 변환시 사용하게될 함수를 나타냅니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">변환함수명</th>
							<td>
								<input type="text" name="searchCnvsnFuntnName" value="${param.searchCnvsnFuntnName}">
							</td>							
						</tr>						
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

