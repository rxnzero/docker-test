<%@page contentType="text/html; charset=euc-kr"%>
<%@page import="com.eactive.eai.common.util.SystemUtil"%>
<%@page import="com.eactive.eai.rms.common.util.StringUtils"%>
<%@page import="com.eactive.eai.rms.common.util.CommonConstants"%>
<%@page import="com.eactive.eai.rms.common.context.MonitoringContext"%>
<%@page import="com.eactive.eai.rms.common.datasource.DataSourceType"%>
<%@page import="com.eactive.eai.rms.common.datasource.DataSourceTypeManager"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>

<%
	String selected = "selected='selected'";
    String serviceKey = (String) session.getAttribute(com.eactive.eai.rms.common.util.CommonConstants.SERVICE_TYPE_KEY);
            
    String title_image = null; //(String) session.getAttribute(MonitoringContext.RMS_TITLE_IMAGE);
    String help_desk   = null; //(String) session.getAttribute(MonitoringContext.RMS_HELP_DESK);
    
    if( title_image == null ) title_image = "site_name.gif" ;
    else title_image = title_image.trim();
    
    if( help_desk == null ) help_desk = "" ;
    else help_desk = help_desk.trim();
%>
<html>
	<head>
		<title><%= localeMessage.getString("screen.title") %></title>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<link href="css/eai_css.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="<c:url value="/js/prototype.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/js/jquery-1.7.2.min.js"/>"></script>
		<script language="JavaScript" type="text/JavaScript">
	
	$(document).ready(function() {
		// 상단 serviceType Combo 셋팅.
		$("select[name=flag]").val(sessionStorage["serviceType"]);
	});
	
	function changeOwner(obj)
	{
		var selectedValue = obj.value;
		parent.location.replace('<c:url value="/main.do?serviceType=' + selectedValue + '" />');
	}
	
	<%
	String OPS = SystemUtil.isDevServer()  ? CommonConstants.DB_MANAGE_TYPE_D : 
		           SystemUtil.isTestServer() ? CommonConstants.DB_MANAGE_TYPE_T :
			         SystemUtil.isProdServer() ? CommonConstants.DB_MANAGE_TYPE_P : "";
	%>
	function goDashboard() {	
		//top.location.replace("<c:url value="/gfm/dashboard/dashboard04.gfm" />");
		
		// You must open from parent window !
		var w = parent.window.open("<%=request.getContextPath()%>/dashboard2/dashboard.html", "RMSDASHBOARD<%=OPS%>", "width=1280,height=1024,left=0,top=0,scrollbars=yes,resizable=no,status=yes");
		w.focus();
	}
	
	function goSitemap() {	
		parent.location.href="<%=request.getContextPath()%>/sitemap.html";
	}
  
  
    function goTranMap() {
    
        var stats = 'toolbar=no'
              + ',location=no'
              + ',directories=no'
              + ',status=no'
              + ',menubar=no'
              + ',dependent=yes'
              + ',scrollbars=no'
              + ',resizable=yes'
              + ',width=700'
              + ',height=550' ;
              //+ ',top=100'
              //+ ',left=100'
              
        var win = window.open("<c:url value="/gfm/admin/mapping/tranCodeMap.gfm" />", "tranCodeMap", stats );
    }
  
  
  
</script>
	</head>
	<body style="margin: 0">
		<form id="form1" name="form1">
			<table width="100%" height="35" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="226">
					<!--  	<img src="images/<%=title_image%>" width="200" height="35" onclick="alert('<%=com.eactive.eai.rms.common.Version.getVersionInfomation()%>');">
					 -->
					</td>
          <td width="300">
          <!--  <marquee scrollamount=3 direction=right style="color:grey;font-size:10pt;font-weight:bold;padding:2"><%=help_desk%></marquee> -->
          </td>
          <td width="*">&nbsp;</td>
					<td align="right" width="300">
					<!-- userID가 admin이면 Dashboard 버튼 활성화 -->
<%--					<% if(((String)SessionManager.getRoleIdString(request)).indexOf("admin") > -1) { %>  --%>
						<!-- <img src="<%=request.getContextPath()%>/images/go_dashboard.gif" width="106" height="21"
							align="right" onclick="goDashboard()" alt="대시보드 화면으로 이동" style="cursor:hand"></img> -->
<%-- 					<% } %>--%>
<%--                     <% if ( "Y".equals((String)session.getAttribute(CommonConstants.MENUID_DASHBOARD))) { %> --%>
                        <!-- img src="<%=request.getContextPath()%>/images/button/go_tranmap.jpg"
                            align="right" onclick="goTranMap()" alt="거래코드 매핑 조회 화면 팝업" style="cursor:hand"></img-->
<%-- 						<img src="<%=request.getContextPath()%>/images/go_dashboard.gif" width="106" height="21" --%>
<!-- 							align="right" onclick="goDashboard()" alt="대시보드 화면으로 이동" style="cursor:hand"></img> -->
<%--                     <% } %> --%>
						<!-- img src="<%=request.getContextPath()%>/images/go_sitemap.gif" width="106" height="21"
							align="right" onclick="goSitemap()" alt="sitemap 화면으로 이동" style="cursor:hand"></img> -->
					</td>
					<td align="right" width="70">
					<% if(((String)SessionManager.getRoleIdString(request)).indexOf("admin") > -1) { %>	 
						<select name="flag" onchange="changeOwner(this);">
							<% for (DataSourceType d : DataSourceTypeManager.getDynamicDataSourceTypes()){	%>
                                <option value="<%= d.getName() %>"
                                <%=d.getName().equals(serviceKey) ? selected : ""%>
                                >
                                <%=d.getText()%>
                                </option>
							<%}%>
						</select>
					<% } %>	 
					</td>
					<td width="30">&nbsp;</td>
				</tr>
			</table>
			<input type="hidden" name="service" value="" />
			<input type="hidden" name="serviceType" value="" />
		</form>
	</body>
</html>
