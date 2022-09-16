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

var url			= '<c:url value="/bap/admin/schedule/procPeriodMan.json" />';
var url_view	= '<c:url value="/bap/admin/schedule/procPeriodMan.view"/>';
var select_sndRcvTyp     = new Array();

function init(){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL_INIT_COMBO'},
		success:function(json){
			list();
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function list(){
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['거래처리 주기ID',
				  '업무명',
                  '대외기관명',
                  '배치작업구분코드',
                  '배치작업 메시지 구분명',
                  '송수신유형',
                  '송수신시작시간',
                  '송수신종료시간',
                  '송수신주기타입'
                  ],
		colModel:[
				{ name : 'BJOBMSGSCHEID'		, align : 'center',hidden:true},
				{ name : 'BJOBBZWKNAME'			, align : 'left'},
				{ name : 'OSIDINSTINAME'		, align : 'left'},
				{ name : 'BJOBTRANDSTCDNAME'	, align : 'left'},
				{ name : 'BJOBMSGDSTICNAME'		, align : 'left'},
				{ name : 'SENDRECVYN'			, align : 'center', editable : false , edittype:'select',editoptions:{value:" : ;S:송신;R:수신"}, formatter:"select"},
				{ name : 'SNDRCVSTARTHMS'		, align : 'center', formatter: timeFormat},
				{ name : 'SNDRCVENDHMS'			, align : 'center', formatter: timeFormat},
				{ name : 'SNDRCVCYCLTYPNAME'	, align : 'left', editable : false , edittype:'select',editoptions:select_sndRcvTyp, formatter:"select"}
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
            var bJobMsgScheId = rowData['BJOBMSGSCHEID'].trim();
            var detailUrl = url_view;
            detailUrl = detailUrl + '?cmd=DETAIL';
            detailUrl = detailUrl + '&page='+$(this).getGridParam("page");
            detailUrl = detailUrl + '&returnUrl='+getReturnUrl();
            detailUrl = detailUrl + '&menuId='+'${param.menuId}';
	    	detailUrl = detailUrl + '&returnUrl='+getReturnUrl();
            detailUrl = detailUrl + '&bJobMsgScheId='+bJobMsgScheId;
            detailUrl = detailUrl + '&'+getSearchUrl();
		    //검색값
            goNav(detailUrl);
        }
	});
}

$(document).ready(function() {
	// 그리드 - 송수신 주기타입 설정
	select_sndRcvTyp['value'] = ": ;C1:일반복;C2:월반복;C3:월 영업일 반복;C4:주반복;C5:매주 영업일 반복;C6:주 요일 반복;C7:주 영업일 반복";
	
	resizeJqGridWidth('grid','title','1000');
	
	init();

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({url:url, postData: postData, page:"1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var returnUrl = url_view;
		returnUrl = returnUrl + '?cmd=DETAIL';
		returnUrl = returnUrl + '&page='+$("#grid").getGridParam("page");
		returnUrl = returnUrl + '&returnUrl='+getReturnUrl();
        returnUrl = returnUrl + '&menuId='+'${param.menuId}';
		//검색값
        returnUrl = returnUrl + '&'+getSearchUrl();

        goNav(returnUrl);
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
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">거래처리 주기 관리<span class="tooltip">일괄 전송 파일의 거래처리 주기 목록을 조회하는 화면입니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:150px;">업무명</th>
							<td><input type="text" name="searchBjobBzwkName" value="${param.searchBjobBzwkName}"></td>
							<th style="width:150px;">대외기관명</th>
							<td><input type="text" name="searchOsidInstiName" value="${param.searchOsidInstiName}"></td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>	
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

