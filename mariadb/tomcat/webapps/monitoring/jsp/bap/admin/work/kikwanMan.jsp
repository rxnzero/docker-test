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
		url: '<c:url value="/bap/admin/work/kikwanMan.json" />',
		postData : gridPostData,
		colNames:['기관코드',
                  '기관명',
                  '시스템IP',
                  '암호화IP',
                  '사용여부',
                  //'등록자ID',
                  //'등록시각',
                  //'수정자ID',
                  //'수정시각'
                  ],
		colModel:[
				{ name : 'KIKWANCD'     	 , align:'left' ,width:40	,sortable:false  },
				{ name : 'KIKWANNAME'   	 , align:'center' ,width:40  },
				{ name : 'SYSIP'      		 , align:'center' ,width:40  },
				{ name : 'ENCIP'      		 , align:'center' ,width:40  },
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
				//{ name : 'ThisMsgRegsntI'    , align:'left' 	, hidden:true },
				//{ name : 'ThisMsgRegiHMS'    , align:'left' 	, hidden:true },
				//{ name : 'ThisMsgAmndrID'    , align:'left' 	, hidden:true},
				//{ name : 'ThisMsgAmndHMS'    , align:'left' 	, hidden:true },
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
            var kikwanCd = rowData['KIKWANCD'].trim();
            var url = '<c:url value="/bap/admin/work/kikwanMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
            url = url + '&kikwanCd='+kikwanCd;
		    //검색값
		    url = url + '&'+getSearchUrl();
            goNav(url);
        }
	});
}

$(document).ready(function() {	

	resizeJqGridWidth('grid','title','1000');
	var url ='<c:url value="/bap/admin/work/kikwanMan.json" />';
	list(url);

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({url:url, postData: postData, page:"1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/work/kikwanMan.view"/>';
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
				<div class="title">FTManager기관관리<span class="tooltip">일괄 전송 파일을 송수신 업무 구분 코드를 관리 하는 화면입니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">기관코드</th>
							<td><input type="text" name="searchKikwanCd" value="${param.searchKikwanCd}"></td>
							<th style="width:180px;">기관명</th>
							<td><input type="text" name="searchKikwanName" value="${param.searchKikwanName}"></td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

