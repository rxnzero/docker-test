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

$(document).ready(function() {	
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/adapter/socket/instStatus.json" />',
		postData : { cmd : 'LIST' },
		colNames:['업무구분',
                  '대외기관',
                  'IP',
                  'PORT',
                  '사용여부',
                  '상태'
                  ],
		colModel:[
				{ name : 'BJOBBZWKNAME'       , align:'left', width:200, sortable:false },
				{ name : 'OSIDINSTINAME'      , align:'left', width:200  },
				{ name : 'LNKGIPINFONAME'     , align:'left'  },
				{ name : 'LNKGPORTINFONAME'   , align:'right'  },
				{ name : 'THISMSGUSEYN'       , align:'center',
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '사용';
                              } else {
                                  return '<span style="color:red">사용안함</span>';
                              }
                          }
				},
				{ name : 'TCIRTLNKGSTUSCD'    , align:'center' ,
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '정상';
                              } else {
                                  return '<span style="color:red">장애</span>';
                              }
                          }
				},
				],
	    autoheight: true,
	    height: $("#container").height(),
	    //height: "500",
	    rowNum: 10000,
        jsonReader: {
             repeatitems:false
        },
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}

		},	        		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		$("#grid").trigger("reloadGrid");
	});
	
	buttonControl();
	
});
 
</script>
</head>
<body>
	<div class="right_box">
		<div class="content_top">
			<ul>
			<li><a href=#>${rmsMenuPath}</a></li>
			</ul>						
	</div><!-- end content_top -->
		<div class="content_middle" id="content_middle">
			<div class="search_wrap">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
			</div>
		<div class="title">연결유지형 소켓 상태정보</div>
			
			<!-- grid -->
		<table id="grid"></table>
		<div id="pager"></div>

		<!-- end content_middle -->
	</div>
	<!-- end right_box -->
</body>
</html>