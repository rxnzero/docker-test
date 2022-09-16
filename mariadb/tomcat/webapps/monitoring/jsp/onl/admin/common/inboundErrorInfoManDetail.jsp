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
var isDetail = false;
var url      = '<c:url value="/onl/admin/common/inboundErrorInfoMan.json" />';
var url_view = '<c:url value="/onl/admin/common/inboundErrorInfoMan.view" />';
function init(key,callback){
	if(typeof callback === 'function') {
		callback(key);
  	}

}
function detail(key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL'
		    , eaiSvcSerno : key
		    },
		success:function(json){
			var data = json;
			$("input[name=eaiSvrSerno]").attr('readonly',true);
			$("#ajaxForm input,#ajaxForm select,#ajaxForm textarea").each(function(){
				$(this).attr('readonly',true);
			});			
			$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			});
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});


}

$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key ="${param.eaiSvcSerno}";
	if (key != "" && key !="null"){
		isDetail = true;
	}
	init(key,detail);


	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});

	buttonControl(isDetail);
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
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title"><%= localeMessage.getString("inboundErrorDetail.title") %><span class="tooltip"><%= localeMessage.getString("inboundErrorDetail.tooltip") %></span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.serno") %></th>
							<td><input type="text" name="eaiSvcSerno"/> </td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.adapter") %></th>
							<td><input type="text" name="adptrBzwkGroupName"/> </td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.errorsection") %></th>
							<td><input type="text" name="eaiErrDstcd"/> </td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.errorCode") %></th>
							<td><input type="text" name="eaiErrCd"/> </td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.reason") %></th>
							<td><textarea type="text" name="eaiErrCtnt" rows="10"></textarea> </td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.occurhms") %></th>
							<td><input type="text" name="errOccurHms"/> </td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.message") %></th>
							<td><textarea type="text" name="bzwkDataCtnt" rows="10"></textarea> </td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("inboundError.instncName") %></th>
							<td><input type="text" name="eaiSevrInstncName"/> </td>
						</tr>																		
					</table>
				</form>
								
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>	
</html>

