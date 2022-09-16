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

$(document).ready(function() {
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/common/scheduler/schedulerMan.json" />',
		postData : gridPostData,
		colNames:['<%= localeMessage.getString("scheduler.job") %> ',
				  '<%= localeMessage.getString("scheduler.desc") %> ',
                  '<%= localeMessage.getString("scheduler.cycle") %>',
                  '<%= localeMessage.getString("scheduler.class") %>',
                  '<%= localeMessage.getString("combo.useYn") %>',
                  '<%= localeMessage.getString("scheduler.instance") %>'
                  ,'<%= localeMessage.getString("scheduler.status") %>'
                  ],
		colModel:[
				{ name : 'JOBNAME'      , align:'left'	, sortable:false  },
				{ name : 'JOBDESC'      , align:'left'  , width : '100px' },
				{ name : 'CRONDESC'     , align:'left'  , width : '130px' },
				{ name : 'JOBCLASSNAME' , align:'left'  , width : '200px' },
				{ name : 'USEYN'        , align:'center', width : '40px'  },
				{ name : 'INSTANCENAME' , align:'left'  },
				{ name : 'STATUS' 		, align:'center'}
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
		loadComplete:function(d){
	    	//에러 행 색상 표시
	    	var rows = $(this).getDataIDs();
	    	for( var i= 0; i < rows.length; i++){
	    		var colName = "STATUS";
	    		var val = $("#grid").getCell(rows[i],colName);
	    		var color = "black";
	    		if(val.indexOf("success")>=0){
	    			if(val.indexOf("failed")>=0)		{ color = "orange";}
	    			else color = "blue";
	    		}else if(val.indexOf("started")>=0){
	    			if(val.indexOf("failed")>=0)		{ color = "purple";}
	    			else color = "green";		
	    		}else if(val.indexOf("failed")>=0){
	    			color = "red";
				}
	    		$("#grid").setCell(rows[i],colName,'',{color:color});
	    		//$("#"+rows[i]).find($("td[name=STATUS]")).css("color",color);
	    	} 
		},	
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var url = '<c:url value="/common/scheduler/schedulerMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//검색값
            url = url + '&'+getSearchUrl();
            //key값
            url = url + '&jobName='+rowData['JOBNAME'];
            goNav(url);
            
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		$("#grid").setGridParam({ postData: { searchJobName: $('input[name=searchJobName]').val()},page:"1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/common/scheduler/schedulerMan.view"/>';
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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title"><%= localeMessage.getString("scheduler.title") %></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("scheduler.search") %></th>
							<td><input type="text" name="searchJobName" value="${param.searchJobName}"></td>
						</tr>						
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

