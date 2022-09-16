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


$(document).ready(function() {	
	$("#btn_close").click(function(key){
		window.close();
	});
});

 
</script>
</head>
	<body>
	
	<!-- button -->
	<table  width="98%" height="35px"  align="center">
	<tr>
		<td align="left" height="25px"><p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">가이드 자료 다운받기</p></td>
		<td align="right">
			<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>"  level="R"/> 
		</td>
	</tr>	
	<tr>
		<td colspan="2">&nbsp;</td></tr>
	<tr height="200px">
		<td colspan="2" align="center">
			<table border="1" cellspacing="0" cellpadding="0" width="95%" height="95%">
			<tr>
				<td valign="top">
					<table border="0" cellspacing="0" cellpadding="0" >
						<tr height="40">
							<td><font size="2"><a href='<c:url value="/common/download/EAI_FEP_guide_interface.zip" />'>1. EAI/FEP 시스템인터페이스식별및정의 가이드</a></font></td>
						</tr>
						<tr height="40">
							<td><font size="2"><a href='<c:url value="/common/download/EAI_FEP_guide_layout.zip" />'>2. EAI/FEP 시스템인터페이스송수신항목설계 가이드</a></font></td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr>						
	</table>	
	
	

		
		
		
		
		
		
		
</html>

