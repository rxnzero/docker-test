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
	var url      = '<c:url value="/common/scheduler/schedulerStatusHistoryMan.json" />';
	var url_view = '<c:url value="//common/scheduler/schedulerStatusHistoryMan.view" />';


	function getStartTime(){
		var now = new Date();
		var tm = right("0" + now.getHours(), 2);
		tm += right("0" + now.getMinutes(), 2);

		tm = (Math.floor(tm.substr(0, 2)) * 60) + Math.floor(right(tm, 2)) - 5;
		tm = right("0" + parseInt(tm/60), 2) + right("0" + tm%60, 2);
		return tm + '00';	
	}
	function getEndTime(){
		var now = new Date();
		var tm = right("0" + now.getHours(), 2);
		tm += right("0" + now.getMinutes(), 2);
		return tm + '60';
	}
	function init( callback) {
		detail();
		
	}
	function detail(){
		var start = $("input[name=searchStartYYYYMMDD]").val()+$("input[name=searchStartHHMM]").val();
		var end = $("input[name=searchEndYYYYMMDD]").val()+$("input[name=searchEndHHMM]").val();
		$("input[name=searchStartTime]").val(start);
		$("input[name=searchEndTime]").val(end);
		
		// guid로 검색 할 때 자리수 체크.
		
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ url:url,postData: postData ,datatype:'json' }).trigger("reloadGrid");
	}

$(document).ready(function() {	
	$("input[name=searchStartYYYYMMDD],input[name=searchEndYYYYMMDD]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
	$("input[name=searchStartHHMM],input[name=searchEndHHMM]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM:ss",outputFormat : "HHMMss"  });
	
	$("input[name=searchStartYYYYMMDD],input[name=searchEndYYYYMMDD]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "yyyymmdd"){
			$(this).val(getToday());
		}
	});
	$("input[name=searchStartHHMM]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "HHMMss"){
			$(this).val("000000");
		}
	});
	$("input[name=searchEndHHMM]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "HHMMss"){
			$(this).val("235959");
		}
	});

	
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ '<%= localeMessage.getString("scheduler.job") %>',
					 '<%= localeMessage.getString("scheduler.instance") %>',
		             '<%= localeMessage.getString("common.startTime") %>',
		             '<%= localeMessage.getString("common.endTime") %>',
		             '<%= localeMessage.getString("scheduler.status") %>'	            
		              ],
		colModel : [ 
		             { name : 'JOBNAME'     ,sortable:false },
		             { name : 'INSTANCENAME',sortable:false },
		             { name : 'STARTDATE'   ,sortable:false ,formatter: timeStampFormat  },
		             { name : 'ENDDATE'     ,sortable:false ,formatter: timeStampFormat  },
		             { name : 'STATUS'      ,sortable:false ,align:'center'},
		            
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		autoheight : true,
		height : $("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			
		},
		gridComplete:function (d){

		},			
	    loadComplete:function (d){
    	
 	    	//에러 행 색상 표시
	    	var rows = $(this).getDataIDs();
	    	for( var i= 0; i < rows.length; i++){
	    		var colName = "STATUS";
	    		var val = $("#grid").getCell(rows[i],colName);
	    		if(val !="success"){
	    			$("#"+rows[i]).find("td").css("background-color","#FFCC99");
	    		}
	    	} 
	    },
        loadError: function(xhr, status, error){       	
        }		
		
	});
	
	detail();
	//resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		detail();
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	$("input[name=searchStartYYYYMMDD]").keyup(function(e){
		$("input[name=searchEndYYYYMMDD]").val($(this).val());
	})
	
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title"><%= localeMessage.getString("schedulerHistory.title") %></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("scheduler.job") %></th>
							<td><input type="text" name="searchJobName" value=""></td>
							<th style="width:180px;"><%= localeMessage.getString("search.period") %></th>
							<td>
								<input type="text" name="searchStartYYYYMMDD" value="" size="10" style="width:100px;"> 
								<input type="text" name="searchStartHHMM" value="" size="8" style="width:100px;">
								~<input type="text" name="searchEndYYYYMMDD" value="" size="10" readonly="readonly" style="width:100px;">
								<input type="text" name="searchEndHHMM" value="" size="8" style="width:100px;">
								<input type="hidden" name="searchStartTime" value="20170202000000">
								<input type="hidden" name="searchEndTime" value="20170202235959">
							</td>
						</tr>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("scheduler.instance") %></th>
							<td colspan="3"><input type="text" name="searchInstanceName" value="${param.searchInstanceName}"></td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

