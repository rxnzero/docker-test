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
<title>▣SMS 팝업▣</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"> </script>
<script language="JavaScript" type="text/JavaScript"><!--
function doSubmit() {
	var logTime = document.frm.logTime.value;
  if(logTime.length == 5) {
		document.frm.submit();
	}
	else {
		alert("시간을 입력하세요");
		document.frm.logTime.focus();
	}
}

window.document.onkeydown = function() {
if(event.keyCode==116 || event.keyCode == 13) {
	 event.keyCode=505; // key 차단
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
* body 코드 start
****************************************************************************
-->
<body class="tableBoxBg01">

	<!-- 장애통보현황 시작 **************************** -->	
				<!-- 타이틀 -->
				<div>
					<img src="<%=request.getContextPath()%>/image/bullet/titleIcon01.jpg"  /> &nbsp;
					<img src="<%=request.getContextPath()%>/image/label/title03.jpg" alt="장애통보현황"  />
				</div>
				
				<!-- 입력 컨트롤 -->
				<form name="frm" method="post" action="<%=request.getContextPath()%>/dashboard2/popupError.do">
				<table class="main_control" >
					<tr>
						<th width="150px">시간 : <input name="logTime" type="text" size="5" maxlength="5" value="<%=logTime%>"/></th>
						<th width="150px">업무그룹 : <select name="domainType"><option value="EAI" <%="EAI".equals(domainType) ? "selected" : ""%> >내부</option>
						                     				<option value="FEP" <%="FEP".equals(domainType) ? "selected" : ""%> >대외</option>
						             				</select></th>
						<th width="150px">개설취급 : <select name="commDiv"><option value="0" <%="0".equals(commDiv) ? "selected" : ""%>></option>
						                                                  <option value="1" <%="1".equals(commDiv) ? "selected" : ""%>>개설</option>
						                                                  <option value="2" <%="2".equals(commDiv) ? "selected" : ""%>>취급</option>
						<th width="120px">노드 : <input name="nodeIndex" type="text" size="8" maxlength="15" value="<%=nodeIndex%>"/></th>
						<th width="200px">구분 : <select name="errorType">
													<option value="ERROR" <%="ERROR".equals(errorType) ? "selected" : ""%> >에러</option>
						                  			<option value="TIMEOUT" <%="TIMEOUT".equals(errorType) ? "selected" : ""%> >타임아웃</option>
						          				</select></th>
						<th><input type="button" value="조회" onClick="javascript:doSubmit();"/></th>
					</tr>
				</table>
			</form>
				<!-- 테이블 시작-->

<table cellspacing="1" cellpadding="0" border="0" class="main_table">
        <tr height="25" class="main_head">
            <td width="40">번호</td>
            <td width="165">GUID</td>
            <td width="135">IF서비스코드</td>
            <td width="100">업무구분명</td>
            <td width="100">에러코드</td>
            <td width="310" >에러메시지</td>
            <td width="60">노드</td>
            <td width="55">구분</td>
            <td width="85">시간</td>
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
            <td align="center" colspan="9">조회된 결과가 없습니다.</td>
        </tr>
<%
	}
%>          
</table>
				<!--  테이블 끝 -->

	<!-- 장애통보현황 끝 **************************** -->
<!-- 메인내용 끝 **************************** -->

	
</body>
<!--
****************************************************************************
* body 코드 end
****************************************************************************
-->
</html>