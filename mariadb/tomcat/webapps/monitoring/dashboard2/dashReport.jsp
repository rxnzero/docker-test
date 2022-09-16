<%@ page language="java" contentType="text/html; charset=euc-kr"
    pageEncoding="EUC-KR"%>
<%@ page import="java.util.*,com.eactive.eai.rms.onl.server.repository.Repository,com.eactive.eai.rms.onl.dashboard.repository.Dashboard2Repository,com.eactive.eai.rms.onl.common.service.*,com.eactive.eai.rms.onl.dashboard.service.*,com.eactive.eai.rms.onl.tracking.vo.*,com.eactive.eai.rms.onl.vo.*,com.eactive.eai.rms.common.util.CommonUtil,
                 org.springframework.web.context.support.WebApplicationContextUtils,                 
                 org.springframework.web.context.WebApplicationContext,com.eactive.eai.rms.common.datasource.DataSourceTypeManager,com.eactive.eai.rms.common.datasource.DataSourceType" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- link href="<%=request.getContextPath()%>/css/style-dashboard.css" rel="stylesheet" type="text/css" /-->
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

body.popup 	{ background: #FFFFFF url(../image/monitoring/blank.gif) no-repeat;	font-size: 12px;	line-height: 18px; padding: 0px 20px 0px 20px;}
div			{ clear:both; padding: 10px; 	font: 12px 돋움, 돋움체, Tahoma, Arial;	color: #FFF;	}
strong		{ letter-spacing:0px;}
/* 기본 table 스타일 */
table, th, td, ul, p {font: 14px 돋움, 돋움체,Tahoma;	color: #FFF; line-height: 20px;}
table 		{ border-collapse: collapse; word-break: break-all;border:1px solid #ffeeaa;}
table .backT { border-collapse: collapse; word-break: break-all;border:1px solid #ffffff;}
thead td{background:#ffaeae; font-weight:bold; color:#000; align:center;}
td			{padding: 5px; border:1px solid #ffeeaa; align:center;}
/******************************************************* 
/* 링크된 텍스트 글자 색상 스타일 */
/*******************************************************/
img {	border: 0px; margin: 0px;}
div img {	vertical-align: middle}
/******************************************************* 
/*  link style    */
/*******************************************************/
a {	text-decoration: none; padding: 0px; margin: 0px; border:0px;}

a:link		{	color: #888888;}
a:visited	{	color: #656565;}
a:hover		{	color: #FF9900;}

.cursorHand{	cursor: hand;}

/******************************************************* 
/* input style             */
/*******************************************************/
input, select	{ vertical-align:middle; margin-bottom:3px;}
input			{ color: #333 ;padding:4px 5px 0px 5px; line-height: 100%;}
select,textarea {	font-family: Arial, Helvetica, sans-serif, 돋움, 돋움체;	color: #666666 ;	font-size : 12px; 	border: 1px solid #b7b7b7; }
select 			{   margin: 0px; line-height: 100%;}
select.multi 	{   margin: 0px; line-height: 150%;}
textarea		{ padding: 2px;line-height: 150%;margin-bottom:3px;}
textarea.none 	{	border: 0px;	overflow: auto;	background: transparent;}
textarea.border0, select.border0, input.border0{ border: 0px;}
input.none		{ border: 0px; color: #FFFFFF; font-weight:bold; background-color: transparent; }
.bgcEE			{ background-color: #EEEEEE;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Insert title here</title>
<script language="javascript" src="<%=request.getContextPath() %>/js/jquery-1.7.2.min.js"></script>
</head>
<body>
<%
ServletContext              ctx                  = request.getSession().getServletContext();
WebApplicationContext       context              = WebApplicationContextUtils.getWebApplicationContext(ctx);
Dashboard2RepositoryService dashboard2Repository = (Dashboard2RepositoryService) context.getBean("dashboard2RepositoryService");
EaiServerInfoServiceImpl    eaiServerInfoService = (EaiServerInfoServiceImpl) context.getBean("eaiServerInfoService");
DashboardServiceImpl        dashboardService     = (DashboardServiceImpl) context.getBean("dashboardService");
Dashboard2Repository        dashboardRepository  = (Dashboard2Repository) context.getBean("dashboard2Repository");
Repository                  repository           = (Repository) context.getBean("repository");

String[] services = {"EAI", "FEP"};
%>
<TABLE width="100%"><TR>
<% for(String service : services ) { %>
<TD width="20%" valign="top"><!-- PART [R] -->
<!-- start server info -->
<div id="serverInfo">
	<h1><%=service%> SERVER INFO</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>Host Name</TD>
			<TD>Instance Name</TD>
			<TD>IP</TD>
			<TD>Port</TD>
			<TD>Alive</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%
	HashSet<String> hostList = new HashSet<String>();
	List<Map<String, String>> list = eaiServerInfoService.getEaiServerIpList(service);
	for( Map<String,String> map : list ) {
		hostList.add(map.get("HOSTNAME"));
	%>
		<TR>
			<TD><%=map.get("HOSTNAME")%></TD>
			<TD><%=map.get("EAISVRINSTNM")%></TD>
			<TD><%=map.get("EAISVRIP")%></TD>
			<TD><%=map.get("EAISVRLSNPORT")%></TD>
			<TD><%=dashboard2Repository.getHostAlive(map.get("EAISVRIP"))%></TD>
		</TR>
	<%
	} // end for
	%>
	</TBODY>
	</TABLE>
</div>
<!-- end server info -->

<!-- start instanceStatus-->
<div id="instanceStatus">
	<h1><%=service%> InstanceStatus</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>Host Name</TD>
			<TD>Instance Name</TD>
			<TD>Status</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%
	for(String host: hostList) {
		List<Map<String, String>> instList = eaiServerInfoService.getEaiServerIpListByHostName(service, host);            
    List<EAIEngineStatusVo> engineList = dashboardService.findEngineStatus(instList, true);    
    for( EAIEngineStatusVo engineVo : engineList ) {
	%>
		<TR>
			<TD><%=engineVo.getHostName()%></TD>
			<TD><%=engineVo.getInstanceName()%></TD>
			<TD><%=engineVo.getServerState()%></TD>
		</TR>
	<%
		} // end for engineList
	} // end for hostList
	%>
	</TBODY>
	</TABLE>
</div>
<!-- end instanceStatus -->

<!-- start adapterStatus-->
<div id="adapterStatus">
	<h1><%=service%> AdapterStatus</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD rowspan="2">Host Name</TD>
			<TD rowspan="2">Instance Name</TD>
			<TD colspan="3">Status(All/24)<br/>0:정지, 1:부분정상,<br/> 2:정상, 3:no service</TD>
		</TR>
		<TR>
			<TD>total</TD>
			<TD>socket2</TD>
			<TD>http</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%
	for(String host: hostList) {
		List<Map<String, String>> instList = eaiServerInfoService.getEaiServerIpListByHostName(service, host);  
		List<AdaptersVO>          volist   = dashboardService.findAdapterStatusList(instList);
    List<RealTimeAdaptersVO>  rtList   = dashboardService.findRTAdapterStatusList(instList);
    for(AdaptersVO vo : volist) {
    	RealTimeAdaptersVO rtVo = null;
    	for(RealTimeAdaptersVO rt : rtList) { 
    		if( vo.getHostName().equals(rt.getHostName()) && vo.getInstanceName().equals(rt.getInstanceName()) ) {
    			rtVo = rt ;
    			break;
    		}
    	}
	%>
		<TR>
			<TD><%=vo.getHostName()%></TD>
			<TD><%=vo.getInstanceName()%></TD>
			<TD><%=vo.getTotal(3)%>   / <%=rtVo.getTotal(3)%>  </TD>
			<TD><%=vo.getSocket2(3)%> / <%=rtVo.getSocket2(3)%></TD>
			<TD><%=vo.getHttp(3)%>    / <%=rtVo.getHttp(3)%>   </TD>
		</TR>
	<%
    } // end for voList
	} // end for hostList
	%>
	</TBODY>
	</TABLE>
</div>
<!-- end adapterStatus -->

<!-- start procTotal-->
<div id="procTotal">
	<h1><%=service%> Proc</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>Host Name</TD>
			<TD>Instance Name</TD>
			<TD>Count</TD>
			<TD>TotalCount</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%	
	String back = "";
	for(String host: hostList) {
		List<Map<String, String>> instList = eaiServerInfoService.getEaiServerIpListByHostName(service, host);  
		int total = 0;
		for( Map<String, String> inst : instList ) {
			int instTotal = dashboardRepository.getMemTradeVo(inst.get("HOSTNAME"), inst.get("EAISVRINSTNM")).getProcTotal();
	%>
		<TR>
			<TD><%=inst.get("HOSTNAME")%></TD>
			<TD><%=inst.get("EAISVRINSTNM")%></TD>
			<TD><%=instTotal%></TD>
			<%if( !back.equals(host) ) { back = host; %><TD rowspan="<%=instList.size()%>" id="procTotal_<%=service%>_<%=host%>"></TD><% } %>
		</TR>
	<%
		total += instTotal;
    } // end for instList
  %>
  <script language="javascript"> $("#procTotal_<%=service%>_<%=host%>").text('<%=total%>');</script>
  <%
	} // end for hostList
	%>
	</TBODY>
	</TABLE>
</div>
<!-- end procTotal -->
<!-- start procTotalAll-->
<div id="procTotalAll">
	<h1><%=service%> Proc Total</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>Host Name</TD>
			<TD>Count</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%	
	for(String host: hostList) {
		MemStaticsVo mvo = dashboard2Repository.getMemTradeVoByHost(host, list);
	%>
		<TR>
			<TD><%=host%></TD>
			<TD><%=mvo.getProcTotal()%></TD>
		</TR>
  <%
	} // end for hostList
	%>
	</TBODY>
	</TABLE>
</div>
<!-- end procTotalAll -->
<!-- start hostStatus-->
<div id="procTotalAll">
	<h1><%=service%> HostStatus</h1>
	<TABLE width=100%>
		<THEAD>
			<TR>
				<TD>Host Name</TD>
				<TD>CPU</TD>
				<TD width="21%">Memory</TD>
				<TD>Disk</TD>
			</TR>
		</THEAD>
		<TBODY>
		<%	
		for(String host: hostList) {
			List<Map<String, String>> instList = eaiServerInfoService.getEaiServerIpListByHostName(service, host);
			HostStatusVo hostVo = dashboardService.findHostStatus(instList);
		%>
			<TR>
				<TD><%=host%></TD>
				<TD><%=hostVo.getCpu()%></TD>
				<TD><%=hostVo.getMemory()%></TD>
				<TD><%=hostVo.getDisk()%></TD>
			</TR>
	  <%
		} // end for hostList
		%>
		</TBODY>
	</TABLE>
</div>
<!-- end hostStatus -->
</TD>
<%} // end for services %>




<TD width="30%" valign="top"><!-- PART [L] -->
<iframe id="iTranInfo" src="./dashReport_tran.jsp?refresh=true" width="80%" height="300px" frameborder="0" border="0" scrolling="no">

</iframe>

<iframe id="adapterStatusDetail" src="./dashReport_adptr.jsp" width="80%" height="400px" frameborder="0" border="0" scrolling="no">

</iframe>
<!-- start smsinit-->
<div id="smsinit">
	<h1>SMS BREAK TIME</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>SMS BREAKER</TD>
			<TD><input type="button" value="RESET" onclick="fncSmsInit()"/>
			<input type="button" value="RELOAD" onclick="fncRefresh()"/></TD>
		</TR>
	</THEAD>
	<TBODY>
		<TR>
			<TD><%=dashboardService.getSmsBreaker() %></TD>
			<TD><input type="text" name="txtBreaker" size="12" value="00:00:00.000"/></TD>
		</TR>
	</TBODY>
  </TABLE>
	<iframe id="iSmsBreaker" width=0 height=0>
	</iframe>
	<script>
	function fncSmsInit() {
		var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=smsinit&initTime="  + txtBreaker.value ;
		$("#iSmsBreaker").attr("src",urlBase);
	}
	function fncRefresh() {
		location.reload();
	}
	</script>	
</div>
<!-- start smsinit-->

<!-- start smsInfoAll-->
<div id="smsInfoAll">
	<h1>SMS INFO TOTAL</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>Service</TD>
			<TD>Instance Name</TD>
			<TD>Time</TD>
			<TD>Message</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%
		// 1. eai, fep sms message 취합
		List<SmsVO> smsList = new ArrayList<SmsVO>();
		for (DataSourceType d : DataSourceTypeManager.getDynamicDataSourceTypes()){
	    
			List<Map<String, String>> smsServerList = eaiServerInfoService.getEaiServerIpList(d.getName());
			for (int i = 0; i < smsServerList.size(); i++) {
		Map server = (Map) smsServerList.get(i);
		String instanceName = (String) server.get("EAISEVRINSTNCNAME");
		String hostName = (String) server.get("HOSTNAME");
		SmsVO vo = (SmsVO) repository.getMonitorData(hostName, instanceName, SmsVO.class.getName());

		if (vo != null) {
			vo.setService(d.getName());
			smsList.add(vo);
		}
			}
			
		} // end datasourceType
		
		String DEFAULT_DELIMITER = "";
	  //HashMap mapBack = new HashMap();
	  List<String> tmpList = new ArrayList<String>(); 
	  for ( SmsVO vo : smsList ) {
	  	List<String> msgList = vo.getMessage();

	  	for( String msg : msgList ) {
	  		tmpList.add(msg + DEFAULT_DELIMITER + vo.getInstanceName() + DEFAULT_DELIMITER + vo.getService()) ;
	  		//mapBack.put(msg, vo);
	  	}
	  }
	  
	  Object sortList[] = tmpList.toArray();
	  Arrays.sort(sortList);
	  
	  String smsBreaker = dashboardService.getSmsBreaker();
	  if( "".equals(smsBreaker) ) { smsBreaker = "0100 00:00:00" ; }
	    

	    //월일
	    String mmdd = CommonUtil.getToday("MMdd");
	    int count = 10 ;
	    for( int i = sortList.length - 1 ; i >= 0 ; i-- ) {
	    	if( count < 0 ) break;
	    	
	    	String[] msg = ((String)sortList[i]).split(DEFAULT_DELIMITER);
	    	
	    	if( msg == null || msg[0].length() < 17 ) {
	    		continue;
	    	}

	    	// 당일 데이터가 아닌것은 제외한다.
	    	if( mmdd.compareTo(msg[0].substring(0,4)) > 0 ) {
	    		continue;
	    	} 
	    	
	    	// Beaker time 보다 이전의 데이터는 제외한다.
	    	if( msg != null && msg[0].length() > 13 ) {
	        	if ( smsBreaker.compareTo(msg[0].substring(0,13)) > -1 ) {
	        		//기준시간보다 이전이므로 제외합니다.
	        		continue;
	        	}                		
	    	}
	%>
		<TR>
			<TD><%=msg[2]%></TD>
			<TD><%=msg[1]%></TD>
			<TD><%=msg[0].substring(5,17)%></TD>
			<TD><%=msg[0].substring(17)%></TD>
		</TR>
	<%
			count --;
    } // end for count
  %>
	</TBODY>
	</TABLE>
</div>
<!-- end smsInfoAll -->

<%for(String service : services ) {
		HashSet<String> hostList = new HashSet<String>();
		List<Map<String, String>> list = eaiServerInfoService.getEaiServerIpList(service);
		for( Map<String,String> map : list ) {
			hostList.add(map.get("HOSTNAME"));	
		} // end for list
%>
<!-- start smsInfo-->
<div id="smsinfo">
	<h1><%=service %> SMS INFO</h1>
	<TABLE>
	<THEAD>
		<TR>
			<TD>Host Name</TD>
			<TD>Instance Name</TD>
			<TD>Message</TD>
		</TR>
	</THEAD>
	<TBODY>
	<%	
	for(String host: hostList) {
		List<Map<String, String>> instList = eaiServerInfoService.getEaiServerIpListByHostName(service, host);  
		int total = 0;
		for( Map<String, String> inst : instList ) {
			SmsVO vo = (SmsVO) repository.getMonitorData(inst.get("HOSTNAME"), inst.get("EAISVRINSTNM"), SmsVO.class.getName());
			if (vo != null) {
				vo.setService(service);
				String message = "";
				for(String msg : vo.getMessage()) {
					message += msg + "<br/>";
				}
	%>
		<TR>
			<TD><%=inst.get("HOSTNAME")%></TD>
			<TD><%=inst.get("EAISVRINSTNM")%></TD>
			<TD><%=message%></TD>
		</TR>
	<%
			} // end if
    } // end for instList
  %>
  <%
	} // end for hostList
	%>
	</TBODY>
	</TABLE>
</div>
<!-- end smsInfo -->
<%} // end for services %>

</TD></TR></TABLE><!-- END PART -->
</body>
</html>