<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*,com.eactive.eai.rms.onl.common.util.*,com.eactive.eai.rms.common.datasource.*,com.eactive.eai.rms.common.util.CommonUtil"%>
<%@ page import="com.eactive.eai.rms.common.context.MonitoringContext"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	request.setCharacterEncoding("euc-kr");

	String logTime = (String)session.getAttribute("logTime");
	String domainType = (String)session.getAttribute("domainType");
	String errorType = (String)session.getAttribute("errorType");
	String commDiv = (String)session.getAttribute("commDiv");
	String nodeIndex = (String)session.getAttribute("nodeIndex");
	Vector<String[]> logList = (Vector<String[]>)session.getAttribute("logList");
	
  session.removeAttribute("logTime");
  session.removeAttribute("domainType");
  session.removeAttribute("errorType");
  session.removeAttribute("commDiv");
  session.removeAttribute("nodeIndex");
  session.removeAttribute("logList");
%>
<head>
<title>��SMS �˾���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"> </script>
<script language="JavaScript" type="text/JavaScript"><!--
function doSubmit() {
	var logTime = document.frm.logTime.value;
  if(logTime.length == 5) {
		document.frm.submit();
	}
	else {
		alert("�ð��� �Է��ϼ���");
		document.frm.logTime.focus();
	}
}

window.document.onkeydown = function() {
if(event.keyCode==116 || event.keyCode == 13) {
	 event.keyCode=505; // key ����
	 doSubmit();	 
	 return false;
	}
};


//-->
</script>

<style>

.tableBoxBg01	{background: #000033 url(../image/box/tableBoxBg.jpg) repeat-y top left; margin-top:5px}

.obstacleBox{ width:100%; height: 154px; margin-top:5px}


.main_control {
  color            : #ccc;
  font             : bold 14px Tahoma;
}

.main_table {
  border           : solid;
  border-color     : #000000;
  border-width     : 0px 0px 0px 0px;
  background-color : #000000;
  text-align       : center;
  table-layout     : fixed;
  color            : #000000;
  font             : bold 12px Tahoma;
}
.main_head {
  background-color : #CCCCCC;
  font             : bold 12px Tahoma;
}
.main_body {
  background-color : #FFFFFF;
  font             : 12px Tahoma;
}
</style>	

</head>

<!--
****************************************************************************
* body �ڵ� start
****************************************************************************
-->
<body class="tableBoxBg01">

	<!-- ����뺸��Ȳ ���� **************************** -->	
				<!-- Ÿ��Ʋ -->
				<div>
					<img src="<%=request.getContextPath()%>/image/bullet/titleIcon01.jpg"  /> &nbsp;
					<img src="<%=request.getContextPath()%>/image/label/title03.jpg" alt="����뺸��Ȳ"  />
				</div>
				
				<!-- �Է� ��Ʈ�� -->
				<form name="frm" method="post" action="<%=request.getContextPath()%>/dashboard2/popupError.do">
				<table class="main_control" >
					<tr>
						<th width="150px">�ð� : <input name="logTime" type="text" size="5" maxlength="5" value="<%=logTime%>"/></th>
						<th width="150px">�����׷� : <select name="domainType"><option value="EAI" <%="EAI".equals(domainType) ? "selected" : ""%> >����</option>
						                     				<option value="FEP" <%="FEP".equals(domainType) ? "selected" : ""%> >���</option>
						             				</select></th>
						<th width="150px">������� : <select name="commDiv"><option value="0" <%="0".equals(commDiv) ? "selected" : ""%>></option>
						                                                  <option value="1" <%="1".equals(commDiv) ? "selected" : ""%>>����</option>
						                                                  <option value="2" <%="2".equals(commDiv) ? "selected" : ""%>>���</option>
						<th width="120px">��� : <input name="nodeIndex" type="text" size="8" maxlength="15" value="<%=nodeIndex%>"/></th>
						<th width="200px">���� : <select name="errorType">
													<option value="ERROR" <%="ERROR".equals(errorType) ? "selected" : ""%> >����</option>
						                  			<option value="TIMEOUT" <%="TIMEOUT".equals(errorType) ? "selected" : ""%> >Ÿ�Ӿƿ�</option>
						          				</select></th>
						<th><input type="button" value="��ȸ" onClick="javascript:doSubmit();"/></th>
					</tr>
				</table>
			</form>
				<!-- ���̺� ����-->

<table cellspacing="1" cellpadding="0" border="0" class="main_table">
        <tr height="25" class="main_head">
            <td width="40">��ȣ</td>
            <td width="165">GUID</td>
            <td width="135">IF�����ڵ�</td>
            <td width="100">�������и�</td>
            <td width="100">�����ڵ�</td>
            <td width="310" >�����޽���</td>
            <td width="60">���</td>
            <td width="55">����</td>
            <td width="85">�ð�</td>
        </tr>
<%
	if (logList != null) {
		for (int i = 0; i < logList.size(); i++) {
			String[] row = (String[]) logList.get(i);
%>
          <tr height="25" class="main_body">
            <td align="center" class="main_head"><%=i + 1%></td>
            <td> <%=row[0]%></td>
            <td align="center" ><%=row[1]%></td>
            <td> <%=row[2]%></td>
            <td align="center" ><%=row[3]%></td>
            <td align="left" > <%=row[4]%></td>
            <td align="center" ><%=row[5]%></td>
            <td align="center" ><%=row[7]%></td>
            <td align="center" ><fmt:parseDate value="<%=row[6]%>" var="fDate" pattern="yyyyMMddHHmmssSSS"/>
            <fmt:formatDate value="${fDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
          </tr>
<%
	  }
	}
	if (logList == null || logList.size() == 0) {
%>
		<tr height="30" class="main_body">
            <td align="center" colspan="9">��ȸ�� ����� �����ϴ�.</td>
        </tr>
<%
	}
%>          
</table>
				<!--  ���̺� �� -->

	<!-- ����뺸��Ȳ �� **************************** -->
<!-- ���γ��� �� **************************** -->

	
</body>
<!--
****************************************************************************
* body �ڵ� end
****************************************************************************
-->
</html>