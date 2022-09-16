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
var url      = '<c:url value="/onl/admin/service/jmsQueueReceiverMan.json" />';
var url_view = '<c:url value="/onl/admin/service/jmsQueueReceiverMan.view" />';
$(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['큐수신자명',
                  '인스턴스',
                  '비동기거래큐명',
                  '비동기거래장애큐명',
                  '큐메시지선택내용',
                  '송신지연시간값',
                  '송신재시도횟수',
                  '큐수신자수',
                  '큐수신자세부내용',
                  '기본큐수신자여부코드',
                  '기본큐수신자여부'
                  ],
		colModel:[
				{ name : 'QUERCVERNAME'					, align:'left'		,sortable:false  },
				{ name : 'SEVRINSTNCNAME'				, align:'left'  },
				{ name : 'NONSYNCZTRANQUENAME'			, align:'left'  	, width:"300px"	},
				{ name : 'NONSYNCZTRANOBSTCLQUENAME'	, align:'left'		, width:"300px"	},
				{ name : 'QUEMSGSELCTCTNT'				, align:'left'	},
				{ name : 'SENDDLAYTTMVAL'				, align:'right'	, width:"90px"	},
				{ name : 'SENDRETRALNOTMS'				, align:'right'	, width:"90px"	},
				{ name : 'QUERCVERCNT'					, align:'right'	, width:"90px"	},
				{ name : 'QUERCVERDTALSCTNT'			, align:'left'  },
				{ name : 'BASCQUERCVERYN'				, hidden: true	},
				{ name : 'BASCQUERCVERYNNAME'			, align:'center'	, width:"90px"	}
				
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
		loadComplete:function (d){
		},
        loadError: function (jqXHR, textStatus, errorThrown) {
        	alert('HTTP status code: ' + jqXHR.status + '\n' +
              'textStatus: ' + textStatus + '\n' +
              'errorThrown: ' + errorThrown);
        	alert('HTTP message body (jqXHR.responseText): ' + '\n' + jqXHR.responseText);
    	},		
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//검색값
            url2 += '&'+getSearchUrl();
            //key값
            url2 += '&queRcverName='+rowData['QUERCVERNAME'];
            goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

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
	//검색값  enter시  조회
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
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">비동기 큐 수신자 관리<span class="tooltip">비동기 거래를 위해 큐에서 메시지를 수신받아 처리하는 수신자 정보를 관리하는 화면입니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">큐수신자명</th>
							<td>
								<input type="text" name="searchQueRcverName" value="${param.searchQueRcverName}">
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

