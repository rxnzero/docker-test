<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
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
var url      = '<c:url value="/onl/admin/common/serverMan.json" />';
var url_view = '<c:url value="/onl/admin/common/serverMan.view" />';
var $Grid ={};

$(document).ready(function() {	
	$Grid = $('#grid');
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,		
		colNames:['<%= localeMessage.getString("server.instncName") %>',
                  '<%= localeMessage.getString("server.ip") %>',
                  '<%= localeMessage.getString("server.port") %>',
                  '<%= localeMessage.getString("server.flovrsevrName") %>',
                  '<%= localeMessage.getString("server.hostname") %>'
                  ],
		colModel:[ 
				{ name : 'EAISEVRINSTNCNAME',   align:'left' , sortable:false },
				{ name : 'EAISEVRIP',           align:'left'  },
				{ name : 'SEVRLSNPORTNAME',     align:'left'  },
				{ name : 'FLOVRSEVRNAME',       align:'left'  },
				{ name : 'HOSTNAME',            align:'left'  }
				],
		          
        jsonReader: {
             repeatitems:false
        },	          
		pager : $('#pager'),		
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
            var eaiSevrInstncName = rowData['EAISEVRINSTNCNAME'];
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//검색값
            //
            //key값
            url2 += '&eaiSevrInstncName='+eaiSevrInstncName;
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
		url2 += '?cmd=DETAIL';
		url2 += '&page='+$("#grid").getGridParam("page");
		url2 += '&returnUrl='+getReturnUrl();
        url2 += '&menuId='+'${param.menuId}';
		//검색값
        //url = url + '&'+getSearchUrl();
		
        goNav(url2);
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
				<div class="title"><%= localeMessage.getString("server.title") %><span class="tooltip"><%= localeMessage.getString("server.tooltip") %></span></div>
				
				<table id="grid" ></table>
				<div id="pager"></div>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

