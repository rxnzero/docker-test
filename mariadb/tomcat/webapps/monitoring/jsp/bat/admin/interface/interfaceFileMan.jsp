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

var url      = '<c:url value="/bat/admin/interface/interfaceFileMan.json" />';
var url_view = '<c:url value="/bat/admin/interface/interfaceFileMan.view" />';
var select_TRANSFREQ = new Array();

function init( callback ) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			select_TRANSFREQ['value']   = ": ;"+getGridSelectText("CODE","NAME",json.transFreqList); // grid SELECT 전송주기 설정
			
			gridRenderingInit();
			
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
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
}

function gridRenderingInit(){
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		colNames:['인터페이스ID',
                  '파일명패턴',
                  '전송주기',
                  '1회크기',
                  '처리시간구간',
                  '송신담당자',
                  '송신담당자 전화번호'
                  ],
		colModel:[
					{ name : 'INTFID'		, align:'left'		},
					{ name : 'FILENAMEPTRN'	, align:'left'	},
					{ name : 'TRANSFREQ'	, align:'center'	, editable : true , edittype:'select',editoptions:select_TRANSFREQ, formatter:"select"		},
					{ name : 'SIZEONCE'		, align:'left'		},
					{ name : 'PROCTERM'		, align:'left'	},
					{ name : 'REQCHGR'		, align:'left'	},
					{ name : 'REQCHGRTLNO'	, align:'left'	}
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
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var intfId = rowData['INTFID'];
            var fileNamePtrn = rowData['FILENAMEPTRN'];
            var url2 = url_view;
            url2 = url2 + '?cmd=DETAIL';
            url2 = url2 + '&page='+$(this).getGridParam("page");
            url2 = url2 + '&returnUrl='+getReturnUrl();
            url2 = url2 + '&menuId='+'${param.menuId}';
			//검색값
            url2 = url2 + '&'+getSearchUrl();
            //key값
            url2 = url2 + '&intfId='+intfId;
            url2 = url2 + '&fileNamePtrn='+fileNamePtrn;
            goNav(url2);
        }		
	});
}

$(document).ready(function() {	

	init( detail );
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ url:url, postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 = url2 + '?cmd=DETAIL';
		url2 = url2 + '&page='+$("#grid").getGridParam("page");
		url2 = url2 + '&returnUrl='+getReturnUrl();
        url2 = url2 + '&menuId='+'${param.menuId}';
		//검색값
        url2 = url2 + '&'+getSearchUrl();

        goNav(url2);
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
// 	buttonControl();
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
				<div class="title">인터페이스별 파일 관리<span class="tooltip">EAI 배치 시스템에서 사용하는 인터페이스별 파일 목록</span></div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:120px;">인터페이스(ID,명)</th>
							<td>
								<input type="text" name="searchIntfId" value="${param.searchIntfId}">
							</td>
							<th style="width:120px;">파일명패턴</th>
							<td>
								<input type="text" name="searchFileNamePtrn" value="${param.searchFileNamePtrn}">
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