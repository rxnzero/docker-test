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
var url      ='<c:url value="/onl/statistics/management/creaStatisticsMan.json" />';
var url_view ='<c:url value="/onl/statistics/management/creaStatisticsMan.view" />';

function init()
{
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=STATCJOBCYCLDSTCD]")).setData(json.jobTypeCdRows).setFormat(codeName3OptionFormat).rendering();
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

$(document).ready(function() {
	init();
	
	var returnUrl = getReturnUrlForReturn();
	
	$("input[name=STATCJOBYMD]").inputmask("9999-99-99",{'autoUnmask':true});

	$("#btn_operate").click(function(){

		var searchJobTypeCd	= $("select[name=STATCJOBCYCLDSTCD]").val();
		var statisticsDt	= $("input[name=STATCJOBYMD]").val();
		var postData;
		
		
		if(statisticsDt == null)
		{
			statisticsDt = "";
		}
		
		if (searchJobTypeCd == "D")
		{
			postData = {service: searchJobTypeCd, day: statisticsDt, cmd: "INSERT_DAILY"};
		}
		else if(searchJobTypeCd == "M")
		{
			postData = {service: searchJobTypeCd, month: statisticsDt, cmd: "INSERT_MONTHLY"};
		}
		else
		{
			alert("작업구분을 선택해주세요.");
			return;
		}
		
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("처리 되었습니다.");
				goNav(returnUrl);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	
	$("input[name=STATCJOBYMD]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_operate").click();
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
					<img src="<c:url value="/img/btn_operate.png"/>" alt="" id="btn_operate" level="W" />										
				</div>
				<div class="title">통계생성</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:120px;">작업구분</th>
							<td>
								<div class="select-style">
									<select name="STATCJOBCYCLDSTCD" value=""><option value="D">[D]일별작업</option><option value="M">[M]월별작업</option>
									</select>
								</div><!-- end.select-style -->	
							</td>
							<th style="width:120px;">통계생성일</th>
							<td>
								<input type="text" name="STATCJOBYMD" maxlength="10">				
							</td>							
						</tr>						
					</tbody>
				</table>
				
				<!-- <table id="grid" ></table>
				<div id="pager"></div>				 -->
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

