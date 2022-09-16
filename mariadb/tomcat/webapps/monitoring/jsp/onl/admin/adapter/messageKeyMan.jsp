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
var url      = '<c:url value="/onl/admin/adapter/messageKeyMan.json" />';
var url_view = '<c:url value="/onl/admin/adapter/messageKeyMan.view" />';

$(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['어댑터명 ',
                  '메시지유형',
                  '기능구분',
                  '그룹',
                  '순서',
                  '업무필드명',
                  '클래스명',
                  '필드시작위치',
                  '필드길이',
                  '정상값'
                  ],
		colModel:[
				{ name : 'ADPTRBZWKGROUPNAME'   , align:'left'	,sortable:false  },
				{ name : 'MSGDSTCD'             , align:'left'  },
				{ name : 'IODSTCD'              , align:'left'  },
				{ name : 'GROUPINORNO'          , align:'left'  },
				{ name : 'FLDPRCSSNO'           , align:'left'  },
				{ name : 'BZWKFLDNAME'          , align:'left'  },
				{ name : 'CLSNAME'              , align:'left'  },
				{ name : 'MSGFLDSTARTSITUVAL'   , align:'left'  },
				{ name : 'MSGFLDLEN'            , align:'left'  },
				{ name : 'NOMALPRCSSCTNT'       , align:'left'  }
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
		loadComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}
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
            url2 += '&adptrBzwkGroupName='+rowData['ADPTRBZWKGROUPNAME'];
            url2 += '&msgDstcd='+rowData['MSGDSTCD'];
            url2 += '&ioDstcd='+rowData['IODSTCD'];
            url2 += '&groupInorNo='+rowData['GROUPINORNO'];

            goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1"  }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=NEW';
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
				<div class="title">메시지 키 관리</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">어댑터명</th>
							<td>
								<input type="text" name="searchAdptrBzwkGroupName" value="${param.searchAdptrBzwkGroupName}">
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

