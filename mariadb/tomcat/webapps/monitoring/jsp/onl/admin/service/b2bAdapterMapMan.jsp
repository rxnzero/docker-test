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
var url      = '<c:url value="/onl/admin/service/b2bAdapterMapMan.json" />';
var url_view = '<c:url value="/onl/admin/service/b2bAdapterMapMan.view" />';



$(document).ready(function() {	
    var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['IF서버인스턴스명',
		          'IF서비스코드',
                  '기관코드',
                  '세부업무구분명',
                  '어댑터업무그룹',
                  '어댑터업무이름'
                  ],
		colModel:[
				{ name : 'EAISEVRINSTNCNAME'        , align:'left'	,sortable:false  },
				{ name : 'EAISVCNAME'               , align:'left'  },
				{ name : 'EXTNLINSTIIDNFINAME'      , align:'left'  },
				{ name : 'DMNDDTALSBZWKDSTICNAME'   , align:'left'  },
				{ name : 'PSVSYSADPTRBZWKGROUPNAME' , align:'left'  },
				{ name : 'ADPTRBZWKNAME'            , align:'left'  }
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
            var key = rowData['EAISEVRINSTNCNAME'];
            var key2 = rowData['EAISVCNAME'];
            var key3 = rowData['EXTNLINSTIIDNFINAME'];
            var key4 = rowData['DMNDDTALSBZWKDSTICNAME'];
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//검색값
            url2 += '&'+getSearchUrl();
            //key값
            url2 += '&eaiSevrInstncName='+key;
            url2 += '&eaiSvcName='+key2;
            url2 += '&extnlInstiIdnfiName='+key3;
            url2 += '&dmndDtalsBzwkDsticName='+key4;
            goNav(url2);
        },
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
	
	$("input[name*=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	$("#btn_initialize").click(function(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZES'},
			success:function(json){
				alert(json.message);
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
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
				<div class="title">라우팅 특정포트 매핑 관리<span class="tooltip">라우팅 필드 추출 정보 관리에서 등록한 정보를 토대로 데이터 중 일부를 추출하여 특정기관의 특정 Port로 데이터를 송신하기 위한 룰 등록</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">IF서버인스턴스명</th>
							<td>
								<input type="text" name="searchEaiSevrInstncName" value="${param.searchEaiSevrInstncName}">
							</td>		
							<th style="width:180px;">IF서비스 코드</th>
							<td>
								<input type="text" name="searchEaiSvcName" value="${param.searchEaiSvcName}">
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

