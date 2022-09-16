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
var url      ='<c:url value="/onl/admin/adapter/adapterChnlMan.json" />';
var url_view ='<c:url value="/onl/admin/adapter/adapterChnlMan.view" />';

function init(callback) {
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_SEARCH_INIT_COMBO'},
		success:function(json){

			if (typeof callback === 'function') {
				callback();
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
	
}




$(document).ready(function() {	
	

	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
 		url: url,
 		postData : gridPostData,
		colNames:['어댑터그룹명 ',
                  '대외채널구분코드',
                  '대외채널기관코드',
                  '대외채널업체ID',
                  '송수신회선구분코드',

                  ],
		colModel:[
				{ name : 'ADPTRBZWKGROUPNAME' , align:'left'  },
				{ name : 'OTSDCHNLDVCD' , align:'left'  },
				{ name : 'OTSDCHNLINSTCD'      , align:'left'  },
				{ name : 'OSDCHCOID'     , align:'left'  },
 				{ name : 'SNDRCVLNKDVCD'       , align:'left'  }
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
			//$(this).setGridParam({datatype:'local'});
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
            goNav(url2);
            
        }
 
            		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_new").click(function(){
		var url2 = '<c:url value="/onl/admin/adapter/adapterChnlMan.view"/>';
		url2 += '?cmd=DETAIL';
		url2 += '&page='+$("#grid").getGridParam("page");
		url2 += '&returnUrl='+getReturnUrl();
        url2 += '&menuId='+'${param.menuId}';
		//검색값
        url2 += '&'+getSearchUrl();
		
        goNav(url2);
	});
	$("#btn_initialize").click(function(){
		var r = confirm("재로딩 하시겠습니까?");
		if(r !=true) return;
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZES'},
			success:function(json){
				alert("성공");
			},
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
			}
		});		
		
	});	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	$("#btn_search").click(function(){
		$("#grid").setGridParam({ postData: { searchAdptrBzwkGroupName: $('input[name=searchAdptrBzwkGroupName]').val()},page:1 }).trigger("reloadGrid");
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
				<div class="title">어댑터 채널</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">그룹명</th>
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

