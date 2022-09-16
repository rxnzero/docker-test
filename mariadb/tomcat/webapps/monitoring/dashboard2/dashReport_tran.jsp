<%@ page language="java" contentType="text/html; charset=euc-kr"
    pageEncoding="EUC-KR"%>
<%@ page import="java.util.*,com.eactive.eai.rms.onl.tracking.vo.MemStaticsVo,com.eactive.eai.rms.onl.common.service.EaiServerInfoServiceImpl,com.eactive.eai.rms.onl.dashboard.repository.Dashboard2Repository,
                 org.springframework.web.context.support.WebApplicationContextUtils,                 
                 org.springframework.web.context.WebApplicationContext
                 " %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<% boolean isStarted = Boolean.parseBoolean(request.getParameter("refresh")); %>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="refresh" content="<%=isStarted?1:-1%>;">
<style>

/******************************************************* 
/* 기본 스타일    */
/*******************************************************/
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,form,fieldset,p,blockquote{margin:0px;padding:0px;}

body {
	margin: 0px 0px 0px 0px;	
	padding: 0px 0px 10px 0px;
	font-family:돋움, 돋움체, Tahoma, Arial;
	font-size: 12px;
	line-height: 18px;
	color: #fff;
	background-color:#000;
		
	scrollbar-face-color:#EBEBEB;
	scrollbar-shadow-color:#CDCDCD;
	scrollbar-highlight-color:#CDCDCD;
	scrollbar-3dlight-color:#F3F3F3;
	scrollbar-darkshadow-color:#F3F3F3;
	scrollbar-track-color:#F3F3F3;
	scrollbar-arrow-color:#FFFFFD;
}
div			{ clear:both; padding: 10px; 	font: 12px 돋움, 돋움체, Tahoma, Arial;	color: #FFF;	}
strong		{ letter-spacing:0px;}
/* 기본 table 스타일 */
table, th, td, ul, p {font: 14px 돋움, 돋움체,Tahoma;	color: #FFF; line-height: 20px;}
table 		{ border-collapse: collapse; word-break: break-all;border:1px solid #ffeeaa;}
table .backT { border-collapse: collapse; word-break: break-all;border:1px solid #ffffff;}
thead td{background:#ffaeae; font-weight:bold; color:#000; align:center;}
td			{padding: 5px; border:1px solid #ffeeaa; align:center;}
</style>
<script language="javascript" src="<%=request.getContextPath() %>/js/jquery-1.7.2.min.js"></script>
<script>
var isStart = <%=isStarted%>;
$(document).ready(function() {	
	$("#btnRefresh").val(isStart ? 'STOP' : 'START');
});
function fncRefresh() {
	location.href = './dashReport_tran.jsp?refresh=' + !isStart ; 
}
</script>
<title>Insert title here</title>
</head>
<body>

<%
ServletContext              ctx                  = request.getSession().getServletContext();
WebApplicationContext       context              = WebApplicationContextUtils.getWebApplicationContext(ctx);
EaiServerInfoServiceImpl    eaiServerInfoService = (EaiServerInfoServiceImpl) context.getBean("eaiServerInfoService");
Dashboard2Repository        dashboardRepository  = (Dashboard2Repository) context.getBean("dashboard2Repository");

String[] services = {"EAI", "FEP"};
%>
<!-- start traninfo-->
<div id="traninfo">
	<h1>TRAN INFO <input type="button" value="STOP" id="btnRefresh" onclick="fncRefresh()""/></h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>Service</TD>
			<TD>Host Name</TD>
			<TD>Instance Name</TD>
			<TD>Proc</TD>
			<TD>Timeout</TD>
			<TD>Error</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%	
	MemStaticsVo totalVo = new MemStaticsVo();
	 for(String service : services ) { 

			HashSet<String> hostList = new HashSet<String>();
			List<Map<String, String>> list = eaiServerInfoService.getEaiServerIpList(service);
			for( Map<String,String> map : list ) {
				hostList.add(map.get("HOSTNAME"));
			}
			for(String host: hostList) {
				List<Map<String, String>> instList = eaiServerInfoService.getEaiServerIpListByHostName(service, host);  
				for( Map<String, String> inst : instList ) {
					MemStaticsVo vo = dashboardRepository.getMemTradeVo(inst.get("HOSTNAME"), inst.get("EAISVRINSTNM"));
					totalVo.add(vo);
	%>
		<TR>
			<TD><%=service%></TD>
			<TD><%=vo.getHostName()%></TD>
			<TD><%=vo.getInstName()%></TD>
			<TD><%=vo.getProcTotal()%></TD>
			<TD><%=vo.getTimeoutTotal()%></TD>
			<TD><%=vo.getErrorTotal()%></TD>
		</TR>
  <%
			} // end for instList
		} // end for hostList
	 } // end for service
	%>
		<TR>
			<TD colspan="3">TOTAL</TD>
			<TD><%=totalVo.getProcTotal()%></TD>
			<TD><%=totalVo.getTimeoutTotal()%></TD>
			<TD><%=totalVo.getErrorTotal()%></TD>
		</TR>
	</TBODY>
	</TABLE>
</div>
<!-- start traninfo-->
</body>
</html>