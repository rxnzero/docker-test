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

	var url      = '<c:url value="/bat/transaction/count/countMonitorMan.json" />';

	function init( callback ) {

		$("input[name=searchStartDate],input[name=searchEndDate]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
		//$("input[name*=Cnt]").inputmask('decimal',{groupSeparator:',',digits:0,autoGroup:true,prefix:'',rightAlign:false,autoUnmask:true,removeMaskOnSubmit:true});
		$("input[name=searchStartDate]").val(getToday());
		$("input[name=searchEndDate]").val(getToday());
		detail();
	}

	function detail(){
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'LIST',
				searchStartDate : $("input[name=searchStartDate]").val(),
				searchEndDate : $("input[name=searchEndDate]").val()
			},
			success : function(json) {
				debugger;
				$("#ajaxForm input").each(function(){
					var name = $(this).attr('name');
					if ( name != null )
						$(this).val(json.rows[0][name.toUpperCase()]);
				});
			},
			error : function(e) {
				alert(e.responseText);
			}
		});


	}

$(document).ready(function() {	

	init( detail);

	$("#btn_search").click(function(){
		detail();
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />						
				</div>
				<div class="title">송수신 현황</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">거래기간</th>
							<td>
								<input type="text" name="searchStartDate" maxlength="10" size="10" style="width:150px;"> ~
								<input type="text" name="searchEndDate" maxlength="10" size="10" style="width:150px;">
							</td>
						</tr>
					</tbody>
				</table>
				
				<form id="ajaxForm">	
					<table class="table_row" cellspacing="0">
						<tr>
							<th colspan="2" class="center">전 체</th>
							<th colspan="2" class="center">정 상</th>
							<th colspan="2" class="center">에 러</th>
							<th colspan="2" class="center">대 기</th>
						</tr>
						<tr>
							<th class="center">송 신</th>
							<th class="center">수 신</th>
							<th class="center">송 신</th>
							<th class="center">수 신</th>
							<th class="center">송 신</th>
							<th class="center">수 신</th>
							<th class="center">송 신</th>
							<th class="center">수 신</th>
						</tr>
						<tr>
							<td><input type="number" name="sndStatusCnt0" readonly/></td>
							<td><input type="number" name="rcvStatusCnt0" readonly/></td>
							<td><input type="number" name="sndStatusCnt1" readonly/></td>
							<td><input type="number" name="rcvStatusCnt1" readonly/></td>
							<td><input type="number" name="sndStatusCnt2" readonly/></td>
							<td><input type="number" name="rcvStatusCnt2" readonly/></td>
							<td><input type="number" name="sndStatusCnt3" readonly/></td>
							<td><input type="number" name="rcvStatusCnt3" readonly/></td>
						</tr>
					</table>
				</form>
								
				<!-- <table id="grid" ></table>
				<div id="pager"></div>				 -->
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>