<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="com.eactive.eai.rms.common.util.CommonConstants"%>
<%@ page import="com.eactive.eai.rms.common.context.MonitoringContext"%>
<%@ page import="com.eactive.eai.rms.common.datasource.DataSourceType"%>
<%@ page import="com.eactive.eai.rms.common.datasource.DataSourceTypeManager"%>
<%
	request.setCharacterEncoding("euc-kr");
	
	// 대시보드
	String dashMenu = (String)session.getAttribute(CommonConstants.MENUID_DASHBOARD);
	
	String dashMenuUrl  = "#" ;
	String dashMenuImage = "_disable" ;
	if( "Y".equals(dashMenu) ) {
		dashMenuUrl = "javascript:goDashboard();" ;
		dashMenuImage = "" ;
	}
	
	String monitor = (String)session.getAttribute(CommonConstants.DASH_MENU_MONITOR);
	String tran = (String)session.getAttribute(CommonConstants.DASH_MENU_TRAN);
	String rule = (String)session.getAttribute(CommonConstants.DASH_MENU_RULE);
	
	
%>
<head>
<title>◇ 반갑습니다. EAI 시스템입니다. ◇</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link href="<%=request.getContextPath()%>/css/style-index.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
//var winDashboard = null ;
function goDashboard() {	
		//top.location.replace("<c:url value="/gfm/dashboard/dashboard04.gfm" />");
		var w = window.open("<%=request.getContextPath()%>/dashboard2/dashboard.html", "RMSDASHBOARD", "width=1280,height=1024,left=0,top=0,scrollbars=yes,resizable=no,status=yes");
		w.focus();
}

</script>
</head>

<body>
	<div>
	<table width="100%" height="100%">
	  <tr>
		<td valign="top"   class="bottomImg">
			<div class="topBg">
				<div class="topImg">
					<!-- img src="<=request.getContextPath()>/image/indexonly/common/topLogo.gif" style="margin:30px 0px 0px 1px" / -->
					<img src="<%=request.getContextPath()%>/image/indexonly/common/topSI.jpg" style="margin:30px 0px 0px -70px" />
					<!-- 링크영역 시작 -->
					<div class="linkBox">
						<table>
						  <tr>
							<td>
								<div class="linkBox01">
									<a href="<%=dashMenuUrl %>"><img src="<%=request.getContextPath()%>/image/indexonly/button/btnDash<%=dashMenuImage %>.gif" alt="대시보드팝업" /></a>									
								</div>
							</td>
							<td>
								<div class="linkBox02">
									<table height=120><tr><td></td></tr></table>
								    <% for(DataSourceType d : DataSourceTypeManager.getDynamicDataSourceTypes() ){
								           if ("Y".equals(monitor)){ 

								    %>
									<a href="<%=request.getContextPath() + "/main.do?service="+d.getName()%>"><%=d.getText() %></a>
								    	
								    <%     }%>
								    <%}%>
									<!-- a href="<//=request.getContextPath() + "/main.do?service=INST5"//>">일괄</a-->
								</div>
							</td>
						  </tr>
						  <tr>
							<td>
								<div class="linkBox03">
									<table height=120><tr><td></td></tr></table>
								    <% for(DataSourceType d : DataSourceTypeManager.getDynamicDataSourceTypes() ){
								           if ("Y".equals(tran)){ 

								    %>
									<a href="<%=request.getContextPath() + "/main/adapter.do?service="+d.getName()+"&adapterType=TRANSACTION"%>"><%=d.getText() %></a>
								    	
								    <%     }%>
								    <%}%>
									<!--a href="<//=request.getContextPath() + "/main/adapter.do?service=INST5&adapterType=TRANSACTION"//>">일괄</a-->
								</div>
							</td>
							<td>
								<div class="linkBox04">
									<table height=120><tr><td></td></tr></table>
								   <% for(DataSourceType d : DataSourceTypeManager.getDynamicDataSourceTypes() ){
								           if ("Y".equals(rule)){ 

								    %>
									<a href="<%=request.getContextPath() + "/main/adapter.do?service="+d.getName()+"&adapterType=RULE"%>"><%=d.getText() %></a>
								    	
								    <%     }%>
								    <%}%>
								 <!--a href="<//=request.getContextPath() + "/main/adapter.do?service=INST5&adapterType=RULE"//>">일괄</a>-->
								</div>
							</td>
						  </tr>
						</table>			
					</div>
					<!-- 링크영역 끝 -->
				</div>
			</div>
		</td>
	  </tr>
	</table>
	</div>
   
</body>
<iframe src= "<%=request.getContextPath()%>/activeupdate/install.html" width="0px" height="0px"></iframe>

</html>