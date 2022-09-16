<%@ page language="java" contentType="text/html; charset=euc-kr"%>

<%@page import="com.eactive.eai.rms.common.datasource.DataSourceType"%>
<%@page import="com.eactive.eai.rms.common.datasource.DataSourceTypeManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
 <%@ include file="/jsp/common/include/localemessage.jsp" %>
 <c:set var="themeColor" value="<%=System.getProperty(\"theme.color\")%>" scope="session" />
<%
    String resultMsg = (String)session.getAttribute("resultMsg");
    session.removeAttribute("resultMsg");
    
    if( resultMsg == null ) {
      resultMsg = "";
    }
 %>

<html>
	<head>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
		<META HTTP-EQUIV="Cache-control" CONTENT="no-cache">
		<title><%= localeMessage.getString("screen.title") %></title>
		<jsp:include page="/jsp/common/include/css.jsp"/>
		<jsp:include page="/jsp/common/include/script.jsp"/>
		<script type="text/javascript">
        if( self.name == 'mainFrame' || self.name == 'leftFrame' || self.name == 'topFrame') {
			parent.window.location.href='<c:url value="/"/>';
		}
		
		function fncPreMain() {
			if ($("input[name=userId]").val() ==null || $("input[name=userId]").val().length == 0 ){
				alert("<%= localeMessage.getString("login.checkid") %>");
				$("input[name=userId]").trigger("focus");
				return;
			}
			if ($("input[name=password]").val() ==null || $("input[name=password]").val().length == 0 ){
				alert("<%= localeMessage.getString("login.checkpwd1") %>");
				$("input[name=password]").trigger("focus");
				return;
			}
			if ($("select[name=serviceType]").val() ==null|| $("select[name=serviceType]").val().length == 0 ){
				alert("<%= localeMessage.getString("login.checkservicetype") %>");
				$("select[name=serviceType]").trigger("focus");
				return;
			}
			sessionStorage["serviceType"]= $("select[name=serviceType]").val();
			$("form").submit();
	 	}
			function changePwd(){
				if ($("input[name=userId]").val() == null || $("input[name=userId]").val().length == 0 ){
					alert("<%= localeMessage.getString("login.checkid") %>");
					$("input[name=userId]").trigger("focus");
					return;
				}
				if ($("input[name=password]").val() == null || $("input[name=password]").val().trim().length == 0 ){
					alert("<%= localeMessage.getString("login.checkpwd1") %>");
					$("input[name=password]").trigger("focus");
					return;
				}
			   if ($("input[name=password]").length == 0){
				   alert("<%= localeMessage.getString("login.checkpwd2") %>");
				   return ;
			   }
			   if ($("input[name=changePassword]").length == 0){
				   alert("<%= localeMessage.getString("login.checkpwd3") %>");
				   return ;
			   }	   
			   if ($("input[name=confirmPassword]").val() != $("input[name=changePassword]").val()){
				   alert("<%= localeMessage.getString("login.checkpwd4") %>");
				   return ;
			   }
			   if ($("input[name=userId]").val() == $("input[name=changePassword]").val()){
				   alert("<%= localeMessage.getString("login.checkpwd5") %>");
				   return ;
			   }				   
			   
			   //if (idCheck.checked){
			   //		setCookie("key",id);
			   //}	
			   $("form").attr("action","<c:url value="/changePassword.do"/>");
			   //$("form").action = "<%=request.getContextPath()%>/changePassword.do";
			  
			   $("form").submit();	
			}	 	
		
		$(document).ready(function() {	
			$("input[name=userId]").keydown(function(event){
				if ( event.which == 13 ) {
					fncPreMain();
				}
			});	
			$("input[name=password]").keydown(function(event){
				if ( event.which == 13 ) {
					fncPreMain();
				}
			});	
			$("input[name=changePassword]").keydown(function(event){
				if ( event.which == 13 ) {
					changePwd();
				}
			});	
			$("input[name=confirmPassword]").keydown(function(event){
				if ( event.which == 13 ) {
					changePwd();
				}
			});				
			$("select[name=serviceType]").change(function(){
				fncPreMain();
			});	
			
			$("img[name=login]").click(function(){
				fncPreMain();
			});	
			$("img[name=change]").click(function(){
				changePwd();
			});	
			
		});
		
		
		</script>
	</head>
	<body>
	<table width="100%" height="100%" >
	<tr>
	<td valign="middle" width="100%">
	<form name="form" action="<c:url value="/login.do"/>" method="post">
	<table width="100%" align="center" cellspacing="0" border="0" cellpadding="0">
		<tr>
			<td align="center" valign="middle" height="90px">
			  <img src='<c:url value="/images/logo/logo-eactive.gif"/>' align="middle" />
			  <hr width="400"/>
		  </td>
		</tr>
		<tr>
		  <td>
			<table align="center" width="350" height="67" align="center" cellspacing="0" border="0" cellpadding="0" background='<c:url value="/login/img/image/login_tbox.gif"/>'>
		    		<tr width="100%">
						<td width="150" align="right" style="font:bold 13px;"><%= localeMessage.getString("login.userId") %>&nbsp;&nbsp;</td>
						<td width="120"><input type="text" name="userId" value="" style="width: 120px;" /></td>
						<td width="80" rowspan="3"><img name="login" style="height: 67px; width: 73px;margin:2px 0px 0px 12px" src='<c:url value="/images/login/login_butn_01.gif"/>'/></td>
		    		</tr>
					<tr>
						<td align="right" style="font:bold 13px;"><%= localeMessage.getString("login.password") %>&nbsp;&nbsp;</td>
						<td><input type="password" name="password" value="" style="width: 120px; " /></td>
					</tr>
					<tr>
						<td align="right" style="font:bold 13px;"><%= localeMessage.getString("login.serviceType") %>&nbsp;&nbsp;</td>
						<td>
							<select name="serviceType" style="width: 120px; ">
							<%
							for (DataSourceType dt : DataSourceTypeManager.getDynamicDataSourceTypes()){
							%>
							<option value="<%=dt.getName()%>"><%=dt.getText()%></option>
							<%
							}
							%>
						    </select>
						</td>
					</tr>
					<tr>
						<td align="right" style="font:bold 13px;"><%= localeMessage.getString("login.changePassword") %>&nbsp;&nbsp;</td>
						<td>
							<input type="password" name="changePassword" value="" style="width: 120px;"/>
						</td>
						<td rowspan="2"><img name="change" style="width: 73px;margin:2px 0px 0px 12px" src='<c:url value="/images/login/login_butn_04.png"/>'/></td>						
					</tr>
					<tr>
						<td align="right" style="font:bold 13px;"><%= localeMessage.getString("login.confirmPassword") %>&nbsp;&nbsp;</td>
						<td>
							<input type="password" name="confirmPassword" value="" style="width: 120px;"/>
						</td>
					</tr>					
					<% if( !resultMsg.equals("") ){  %>
					<tr>
						<td style="background: #FFFEC1; font: bold; color: red" colspan="3"><%=resultMsg %></td>
					</tr>
					<% } %>
	      		</table>		  
		  

		  </td>		  
		</tr>

	</table>
	</form>
	</td></tr></table>
	</body>	

</html>

