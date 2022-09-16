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

	var level		= window.dialogArguments["level"];
	var codeGroup	= window.dialogArguments["codeGroup"];
	var code		= window.dialogArguments["code"];
	var parentCode	= window.dialogArguments["parentCode"];
	var seq			= window.dialogArguments["seq"];
	
	var modifyFlag	= "false";

	function isValid(){
		if($('input[name=codeGroup]').val() == "")
		{
			alert("<%= localeMessage.getString("codePop.checkRequierd1") %>");
			$("input[name=codeGroup]").focus();
			return false;
		}
		else if($('input[name=code]').val() == "")
		{
			alert("<%= localeMessage.getString("codePop.checkRequierd2") %>");
			$("input[name=code]").focus();
			return false;
		}
		else if($('input[name=codeName]').val() == "")
		{
			alert("<%= localeMessage.getString("codePop.checkRequierd3") %>");
			$("input[name=codeName]").focus();
			return false;
		}
		
		return true;
	}

	$(document).ready(function() {	
		$("input[name=level]").val(level);
		$("input[name=codeGroup]").val(codeGroup);
		$("select[name=useYn]").val('N');
		$("select[name=SEQ]").val("1");
		
		/* level 값으로 코드그룹 입력 제어. */
		if(level == 0)
		{
			$("input[name=code]").focus();
		}
		else if(level == 1)
		{
			$("input[name=parentCode]").val(code);
			$("input[name=code]").focus();
		}
		else
		{
			$("input[name=parentCode]").val(code);
			$("input[name=code]").focus();
		}
		
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
			
			postData.push({ name: "cmd" , value:"INSERT"});
			$.ajax({
				type : "POST",
				url:url,
				data:postData,
				success:function(args){
					alert("<%= localeMessage.getString("common.saveMsg") %>");
					modifyFlag = "true";
					$("#btn_close").trigger("click");
				},
				error:function(e){
					alert(e.responseText);
				}
			});
		});
		
		$("#btn_close").click(function(){
			window.returnValue = modifyFlag;
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
			<div class="title"><%= localeMessage.getString("codePop.title") %></div>
			
			<form id="ajaxForm">
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:20%;"><%= localeMessage.getString("code.codeGroup") %></th>
						<td><input type="text" name="codeGroup" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th><%= localeMessage.getString("code.code") %></th><td ><input type="text" name="code"/> </td>
					</tr>
					<tr>
						<th><%= localeMessage.getString("code.codeName") %></th><td ><input type="text" name="codeName"/> </td>
					</tr>
					<tr>
						<th><%= localeMessage.getString("code.parentCode") %></th><td ><input type="text" name="parentCode" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th><%= localeMessage.getString("combo.useYn") %></th>
						<td>
							<div class="select-style">
								<select name="useYn">
									<option value="Y"><%= localeMessage.getString("combo.usey") %></option>
									<option value="N"><%= localeMessage.getString("combo.usen") %></option>
								</select> 
							</div>	
						</td>
					</tr>
					<tr>
						<th><%= localeMessage.getString("code.order") %></th>
						<td>
							<div class="select-style">
								<select name="seq">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="8">8</option>
									<option value="9">9</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
								</select> 
							</div>	
						</td>
					</tr>
				</table>
			</form>
			
		</div><!-- end.popup_box -->
	</body>
</html>