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

function getHoldyDstcd ( holdyDstcdName ){
    if ( holdyDstcdName == '공휴일' ) {
        return '1';
    } else if( holdyDstcdName == '임시공휴일' ) {	
        return '2';
    } else if( holdyDstcdName == '음력휴일' ) {	
        return '3';
    }

}
$(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/schedule/holidayMan.json" />',
		postData : gridPostData,
		colNames:['휴일일자',
                  '휴일 유형',
                  '설명'
                  ],
		colModel:[
				{ name : 'HOLDYYMD'   , align:'center', width: '30px',	sortable:false  },
				{ name : 'HOLDYDSTCD' , align:'center', width: '30px' ,
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '공휴일';
                              } else if( cellvalue == '2' )  {	
                                  return '임시공휴일';
                              } else if( cellvalue == '3' )  {
                                  return '음력휴일';
                              } else {
                                  return cellvalue;
                              }
                          }
				 },
				{ name : 'EVNTSCHDRHOLDYCTNT'  , align:'left'  }
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
            var holdyYmd = rowData['HOLDYYMD'];
            var holdyDstcd = rowData['HOLDYDSTCD'];
            var evntSchdrHoldyCtnt = rowData['EVNTSCHDRHOLDYCTNT'];
            var url = '<c:url value="/bap/admin/schedule/holidayMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//검색값
            url = url + '&'+getSearchUrl();
            //key값
            url = url + '&holdyYmd='+holdyYmd;
            url = url + '&holdyDstcd='+ getHoldyDstcd(holdyDstcd);
            url = url + '&evntSchdrHoldyCtnt='+ (evntSchdrHoldyCtnt);
            url = url + '&end=Yes';
            goNav(encodeURI(url));
        }		
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/schedule/holidayMan.view"/>';
		url = url + '?cmd=DETAIL';
		url = url + '&page='+$("#grid").getGridParam("page");
		url = url + '&returnUrl='+getReturnUrl();
        url = url + '&menuId='+'${param.menuId}';
		//검색값
        url = url + '&'+getSearchUrl();

        goNav(url);
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title">휴일 관리<span class="tooltip">일괄전송 시스템에서 관리 하는 휴일 목록을 조회합니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:150px;">휴일 일자</th><td><input type="text" name="likeHoldyYmd" maxlength="8" value="${param.searchHoldyYmd}"></td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>	
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>