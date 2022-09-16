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
<style>
	.img_pointer{
		cursor:pointer;
	}
</style>
<script language="javascript" >
	var cdGroup = "";

	$("input[name=cdGroup]").focus();

	function isValid(){
		if($('input[name=cdGroup]').val() == "")
		{
			alert("<%= localeMessage.getString("codePop.checkRequierd1") %>");
			$("input[name=cdGroup]").focus();
			return false;
		}
		
		return true;
	}

	$(document).ready(function() {	
		
		$("#btn_modify").click(function(){
			if (!isValid()){
				return;
			}
			
			var r = confirm("<%= localeMessage.getString("common.checkSave") %>");
 			if (r == false){
 				return;
 			}
			
			var url      ='<c:url value="/onl/admin/common/codeMan.json" />';
			var postData = $('#ajaxForm').serializeArray();
			
			postData.push({ name: "cmd" , value:"INSERT_GROUP"});
			$.ajax({
				type : "POST",
				url:url,
				data:postData,
				success:function(args){
					alert("<%= localeMessage.getString("common.saveMsg") %>");
					cdGroup = $("input[name=cdGroup]").val();
					$("#btn_close").trigger("click");
				},
				error:function(e){
					alert(e.responseText);
				}
			});
		});
		
		$("#btn_close").click(function(){
			window.returnValue = cdGroup;
			window.close();
		});
		
		buttonControl();
		
	});
 
</script>
</head>
	<body>
		<div class="popup_box">
			<div class="search_wrap">
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" status="DETAIL,NEW"/>	
			</div>
			<div class="title"><%= localeMessage.getString("codeGroupPop.title") %></div>
			
			<form id="ajaxForm">
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:20%;"><%= localeMessage.getString("code.codeGroup") %></th>
						<td><input type="text" name="cdGroup"/> </td>
					</tr>
					<tr>
						<th><%= localeMessage.getString("code.codeGroupDesc") %></th>
						<td ><input type="text" name="cdGroupDesc"/> </td>
					</tr>
				</table>
			</form>
			
		</div><!-- end.popup_box -->
	</body>
</html>