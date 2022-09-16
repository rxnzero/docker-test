<%@ page language="java" contentType="text/html; charset=euc-kr"%>

<%@page import="com.eactive.eai.rms.common.datasource.DataSourceType"%>
<%@page import="com.eactive.eai.rms.common.datasource.DataSourceTypeManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>

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
		<title></title>
		<jsp:include page="/jsp/common/include/css.jsp"/>
		<jsp:include page="/jsp/common/include/script.jsp"/>
		<script type="text/javascript">
        if( self.name == 'mainFrame' || self.name == 'leftFrame' || self.name == 'topFrame') {
			parent.window.location.href='<c:url value="/"/>';
		}
		
		function fncPreMain() {
			if ($("select[name=serviceType]").val() ==null|| $("select[name=serviceType]").val().length == 0 ){
				alert("<%= localeMessage.getString("choice.checkMsg") %>");
				$("select[name=serviceType]").trigger("focus");
				return;
			}
			sessionStorage["serviceType"]= $("select[name=serviceType]").val();
			$("form").submit();
	 	}
		
		$(document).ready(function() {	
			$("select[name=serviceType]").change(function(){
				fncPreMain();
			});	
			
			$("img[name=login]").click(function(){
				fncPreMain();
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
			  <img src='<c:url value="/images/logo/login_logo.gif"/>' align="middle" width="180" height="64" />
			  <hr width="400"/>
		  </td>
		</tr>
		<tr>
		  <td>
			<table align="center" width="350" height="67" align="center" cellspacing="0" border="0" cellpadding="0" background='<c:url value="/login/img/image/login_tbox.gif"/>'>
					<tr>
						<td width="150px" align="right" style="font:bold 13px;" ><%= localeMessage.getString("choice.system") %>&nbsp;&nbsp;</td>
						<td width="120px" >
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
						<td width="80px"><img name="login" style="height: 67px; width: 73px;margin:2px 0px 0px 12px" src='<c:url value="/images/login/login_butn_01.gif"/>'/></td>
					</tr>
					
					<% if( !resultMsg.equals("") ){  %>
					<tr>
						<td style="background: #FFFEC1; font: bold; color: red" colspan="3"><%=resultMsg %></td>
					</tr>
					<% } %>
	      		</table>		  
		  

		  </td>		  
		</tr>
		<tr align="center"><td style="padding-top:15px;"><img name="workFlow" style="height: 500px; width: 800px;margin:2px 0px 0px 12px" src='<c:url value="/images/common/fepAdapterWorkFlow.jpg"/>'/></td></tr>
		<tr align="center"><td style="padding-top:15px;"><font size="3"><a href='<c:url value="/common/download/FEP_adapter_register_form.zip" />'><%= localeMessage.getString("choice.adapterTemplete") %></a></font></td></tr>
	</table>
	</form>
	</td></tr>
	</table>
	</body>	

</html>

