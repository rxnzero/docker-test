<%@ page contentType="text/html; charset=euc-kr" %>
<%@page import="com.eactive.eai.rms.common.util.CommonConstants"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eactive.eai.rms.common.login.SessionManager"%>
<%@page import="com.eactive.eai.rms.common.login.LoginVo"%>
<%@page import="com.eactive.eai.common.util.SystemUtil"%>
<%@page import="com.eactive.eai.rms.common.util.StringUtils"%>
<%@page import="com.eactive.eai.rms.common.datasource.DataSourceType"%>
<%@page import="com.eactive.eai.rms.common.datasource.DataSourceTypeManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>

<%
String serviceKey = SessionManager.getServiceTypeKey(request);
String roleScreenId = (String)request.getAttribute("roleScreenId");
String mainPage = (String)request.getAttribute("mainPage");
String themeName = (String)request.getAttribute("themeName");
if( roleScreenId != null && roleScreenId.length() > 3 ) {
    // 중메뉴 아이디를 비교하기 위해서 세부메뉴아이디인 우측 3자리는 제외시킨다.
    //roleScreenId = roleScreenId.substring(0, roleScreenId.length() - 3);
}
	StringBuffer top_img = new StringBuffer();		// top메뉴 이미지 순서
	StringBuffer subLayer = new StringBuffer();		// sub메뉴 레이어 
	int firstSubCnt =0;
	int topCnt =0;
	int topListSize =0;
	String firstTopMenuId = "";
	String firstSubMenuId = "";
	String firstSubMenuUrl = "";
	String firstLayerName  = "menu1";
	
	int topPosition = 1 ;
	int topCount    = 0 ;
	int subPosition = 1 ;
	int subCount    = 0 ;

	List list = (List)request.getAttribute("topMenuList");
	
	//메뉴관련 데이터 정렬 - sub관련 정의를 subMap에 담아 subList에 담기 -> 해당 subList를 topMap에 담기 -> topMap을 topList에 담아 두기.
	HashMap map = null;			
	
	String topTemp = "";		
	String subTemp = "";
	
	List topList = new ArrayList();
	List subList = null;
	
	HashMap topMap = null;
	HashMap subMap = null;
	
	
	
	
	for(int i=0; i< list.size(); i++){
		map = (HashMap)list.get(i);
		String thisTop 		= (String)map.get("LEV2_ID"); 
		String thisTopNm 	= (String)map.get("LEV2_NAME"); 
		String thisSub 		= (String)map.get("LEV3_ID");
		
	
		if(!thisTop.equals(topTemp)){	
			//top end 관련
			if(topCnt > 0){
				//System.out.println("subList -> "+subList);
				topMap.put("SUB_MAP", subList);
				
				// System.out.println("topMap map ###########  -> "+topMap);
				topList.add(topMap);
			}
			
			//top start 관련
			//System.out.println("********************START ");
			topMap = new HashMap();			
			subList = new ArrayList();
			topMap.put("TOP_ID", thisTop);
			topMap.put("TOP_NAME", thisTopNm);
			topMap.put("TOP_IMG", (String)map.get("LEV2_IMG"));
			
			topMap.put("TOP_LEFTID", (String)map.get("LEV3_ID"));
			if(!"NAN".equals((String)map.get("LEV2_URL"))){
				topMap.put("TOP_URLID", (String)map.get("LEV2_ID"));
				topMap.put("TOP_URL", (String)map.get("LEV2_URL"));
				//System.out.println(" YYYY       "+map.get("LEV2_ID")+" ## "+map.get("LEV2_URL"));
			}else{
				topMap.put("TOP_URLID", (String)map.get("LEV4_ID"));
				topMap.put("TOP_URL", (String)map.get("LEV4_URL"));
			}
			
			topCnt++;
			topTemp = thisTop;
			
			subMap = new HashMap();
			subMap.put("SUB_ID", map.get("LEV3_ID"));
			subMap.put("SUB_NAME", map.get("LEV3_NAME"));
			subMap.put("SUB_URL", map.get("LEV4_URL"));
			subMap.put("SUB_URLID", map.get("LEV4_ID"));
			subList.add(subMap);
		}else{	//top 같을때 - sub가 다를경우에만 담아둠 
			if(!thisSub.equals(subTemp)){
				subMap = new HashMap();
				subMap.put("SUB_ID", map.get("LEV3_ID"));
				subMap.put("SUB_NAME", map.get("LEV3_NAME"));
				subMap.put("SUB_URL", map.get("LEV4_URL"));
				subMap.put("SUB_URLID", map.get("LEV4_ID"));
				subList.add(subMap);				
			}
		}
		subTemp = thisSub;
		
		//top end 관련
		if(i+ 1 == list.size()){				
			//System.out.println("subList -> "+subList);
			topMap.put("SUB_MAP", subList);
			
			//System.out.println("topMap map KKKKKKKK -> "+topMap);
			topList.add(topMap);
			//System.out.println("#######END ");
		}		
	}
	//System.out.println("topList.size() -> "+topList.size());
	
	//메뉴 구성하기
	topListSize = topList.size();
	int layerLeft = 0;
  
    topCount  = topListSize ; // default
    
    String tmpScrId = roleScreenId;
    if( tmpScrId != null && tmpScrId.length() > 3 ) {
        tmpScrId = roleScreenId.substring(0, roleScreenId.length() - 3 );
    }
    
	//System.out.println("topListSize -> "+topListSize);
	if(topListSize > 0){
		HashMap displayMap = new HashMap();
		HashMap displaySubMap = new HashMap();
		int topIndex = 0; 
		int subListSize =0; 

		String topUrl = "";
		for(int i=0; i< topListSize; i++){
			topIndex = i+1; 
			displayMap = (HashMap)topList.get(i);
			
			List subMenuList = (List)displayMap.get("SUB_MAP");
			subListSize = subMenuList.size();

			int subIndex = 0;
			String subId = "";
			String subName = "";
			String subUrl = "";	
			String subUrlId = "";	
			for(int j =0; j< subListSize ; j++){
                displaySubMap = (HashMap)subMenuList.get(j);  

				subIndex = j+1;
				layerLeft = 20;	
				subId = (String)displaySubMap.get("SUB_ID");
				subName = (String)displaySubMap.get("SUB_NAME");
				subUrlId = (String)displaySubMap.get("SUB_URLID");
				subUrl= displaySubMap.get("SUB_URL")+"?menuId="+subUrlId;
                
                if(j == 0){
                    //첫번째 메뉴의 서브카운트 갯수 -> loading시 실행될 js에서 사용하기 위함
                    if(i == 0){
                        firstSubCnt = subListSize;
                        subCount    = firstSubCnt; // default
                        firstTopMenuId = subId;
                        firstSubMenuId = subId;
                        firstSubMenuUrl = subUrl;                        
                    }

                    //div start ( for default value )
                    subLayer.append("<li>");
                    subLayer.append("<a href=\"javascript:goPage2('"+ request.getContextPath() + "/leftMenu.do?menuId="+displayMap.get("TOP_LEFTID")+"', '"+subUrl+"', '"+displayMap.get("TOP_URLID")+"')\">"+displayMap.get("TOP_NAME")+"</a>");	
					subLayer.append("<div class='red_box'></div>");	
					subLayer.append("<ul class='depth2'>");	
                    
                }
				
									
				//subLayer.append("<li><a href='sub1_1.html'>"+subName+"</a></li>");				
				subLayer.append("<li><a href=\"javascript:goPage2('"+ request.getContextPath() + "/leftMenu.do?menuId="+subId+"', '"+subUrl+"', '"+subUrlId+"')\">"+subName+"</a></li>");				
				if(subIndex == subListSize){
					// div end
					subLayer.append("</ul>");
					subLayer.append("</li>");
				}
				
                if ( subUrlId.startsWith(tmpScrId) ){
                    // 현재 왼쪽의 첫번째 메뉴만 사용할 수 있으나 
                    // 차후에 기타메뉴도 초기화면에서 선택할수 있도록 수정해야 할것.
                    // 서브메뉴의 하위항목 비교를 수행하면 된다.
                    // System.out.println("****************** OK ~~~~~~~~~~~~~~~~~~~~~" );
                    firstTopMenuId = subId ;
                    firstSubMenuId = subUrlId;
                    firstSubMenuUrl = subUrl;
                    firstLayerName = "menu" + topIndex;
                    topPosition = topIndex ;
                    subPosition = subIndex ;
                    topCount    = topListSize;
                    subCount    = subListSize;
                }        
			}
			
		}
	}

%>
<!DOCTYPE html>
<html>
<head>
<title><%= localeMessage.getString("screen.title") %></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<!--[if lt IE 9]>
<script language="javascript" src="<c:url value="/js/html5shiv.js"/>"></script>
<script language="javascript" src="<c:url value="/js/IE9.js"/>"></script>
<![endif]-->

	<link rel="stylesheet" type="text/css" media="screen" href="<c:url value="/css/web_ui.css"/>"/>
	<link rel="stylesheet" type="text/css" media="screen" href="<c:url value="/css/theme_${themeColor}.css"/>" />
	<script language="javascript" src="<c:url value="/js/jquery-1.12.1.min.js"/>"></script>
	<script language="javascript" src="<c:url value="/js/prefixfree.min.js"/>"></script> 	


<script language="JavaScript">
	var filter = "win16|win32|win64|mac|macintel";
	var ismobile = false;
	
	if ( navigator.platform ) { 
		if ( filter.indexOf( navigator.platform.toLowerCase() ) < 0 ) { 
			//mobile 
			console.log('mobile 접속'); 
			ismobile = true; 
		}
	}

function strStartsWith(str,prefix){
	return str.indexOf(prefix) === 0;
}

function goNavUrl(url){
	var data ="";
	var isServiceType = false;
	var u = url.split("?");
	if (u.length == 1){
		data = u[0] + "?" + "serviceType=" +sessionStorage["serviceType"];
	}else if (u.length == 2){
		data = u[0] ;
		var u2 = u[1].split("&");
		var prefix ="";
		for (var i=0;i<u2.length;i++){
			if (i==0){
				prefix="?";
			}else{
				prefix="&";
			}
			if (strStartsWith(u2[i],"serviceType=")){
				isServiceType = true;
				data = data + prefix + "serviceType="+sessionStorage["serviceType"];
			}else{
				data = data + prefix + u2[i];
			}
		}
		if (!isServiceType){
			if (data.indexOf("?")>=0){
				data = data +"&" + "serviceType="+sessionStorage["serviceType"];
			}else{
				data = data +"?" + "serviceType="+sessionStorage["serviceType"];
			}
		}
	}else{
		return goNavUrl(u[0]+"?"+u[1]);
	}
	return data;
}

//왼쪽메뉴, 메인 페이지 이동 
function goPage2(page1, page2, page2_id)
{
	parent.leftFrame.location.href=goNavUrl(page1);	
	parent.mainFrame.location.href=goNavUrl(page2);
}

var sessionAjax =  createAjaxRequest();

function getAjaxData( ) {
	var reqAjax = sessionAjax;

	try {	
		if( reqAjax.readyState == 4 ) {
			if( reqAjax.status == 200 ) {
				return reqAjax.responseText ;
			} 
		}
	} catch ( e ){
	} finally {
		reqAjax = null ;
	}
	return null ;
}

function createAjaxRequest() {
	var reqAjax = null ;
	try {
		reqAjax = new XMLHttpRequest();
	} catch ( trymicrosoft ) {
		try {
			reqAjax = new ActiveXObject("Msxml2.XMLHTTP");
		} catch ( othermicrosoft ) {
			try {
				reqAjax = new ActiveXObject("Microsoft.XMLHTTP");
			} catch( failed ) {
				reqAjax = null ;
			}
		}
	}

	if( reqAjax == null ) {
		alert("Error creating request object!");
	}
	
	return reqAjax;
}

var isSession = "";
function getSession() {
	var url = "<%=request.getContextPath()%>/checkSession.do" ;
	var reqAjax = sessionAjax;
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = getSessionAfter ;
	reqAjax.send(null);
	reqAjax = null;
}

function getSessionAfter() {
	var msg =  getAjaxData();
	
	if(msg =="F") {
		  isSession = msg;
		  parent.window.location.href='<%=request.getContextPath()%>';
	}
}
function changeOwner(obj)
{
	var selectedValue = obj;
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
function menuRender() {
<%if(topListSize > 0){%>
    // 처음 로딩시 제일첫번째 화면 보여주기 
    
//    topMenuControl(3,4,1);
//    subMenuControl('menu3',1,2);
//    goPage2('/monitoring/leftMenu.do?menuId=INST1OD0401000', '/monitoring/gfm/transaction/online/transactionStatus.gfm?menuId=INST1OD0401001', 'INST1OD0401001')
//    topMenuControl(<%=topPosition%>,<%=topCount%>,<%=subCount%>);
//    subMenuControl('<%=firstLayerName%>',<%=subPosition%>,<%=subCount%>);
//    alert( '/monitoring/leftMenu.do?menuId=<%=firstSubMenuId%>' );
//    alert( '<%=firstSubMenuUrl%>?menuId=<%=firstSubMenuId%>' );
//    alert( '<%=firstSubMenuId%>' );
    <%if(mainPage != null && !mainPage.equals("")) { %>
    goPage2('/monitoring/leftMenu.do?menuId=<%=firstTopMenuId%>', '<%=mainPage%>?menuId=<%=roleScreenId%>', '<%=roleScreenId%>');
    <%} else { %>
    goPage2('/monitoring/leftMenu.do?menuId=<%=firstTopMenuId%>', '<%=firstSubMenuUrl%>?menuId=<%=firstSubMenuId%>', '<%=firstSubMenuId%>');
    <%} %>

<%}%>    
}
//-->
$(document).ready(function() { 

	var $service_type_list = $('.service_type .list');
	var $service_type_title = $('.service_type .title');
	
	$(".service_type .title").on("click",function(e){	
		$service_type_list.toggle();
		if($service_type_list.css("display")=="block"){
			$(top.document).find(".topMenu").css("height","130px");
			//$(this).parent(".topMenu").css("height","130px");
			$service_type_title.find(".icon").css("transform","rotate(180deg)");
		}else{
			$(top.document).find(".topMenu").css("height","80px");
			$service_type_title.find(".icon").css("transform","rotate(0deg)");
		}
		
	});
	
	$('.service_type .list').find("li > a").on("click",function(e){	
		$service_type_title.find("span").text($(this).text());
		$service_type_list.toggle();
		if($service_type_list.css("display")=="block"){
			$(top.document).find(".topMenu").css("height","130px");
			$service_type_title.find(".icon").css("transform","rotate(180deg)");
			changeOwner($(this).text());
		}else{
			$(top.document).find(".topMenu").css("height","80px");
			$service_type_title.find(".icon").css("transform","rotate(0deg)");
			changeOwner($(this).text());
		}
	});	 
	$('.gnb a').on("click",function(e){
		if(!ismobile) {
			$(top.document).find(".topMenu").css("height","80px");
		} else {
			console.log("height : ", $(top.document).find(".topMenu").css("height"));
			if($(top.document).find(".topMenu").css("height") == "80px") {
				$(top.document).find(".topMenu").css("height","410px");
				$(top.document).find(".gnb_bg").css("height","322px");
			}
		}
	});
	$('.depth2 a').on("click",function(e){
		$(top.document).find(".topMenu").css("height","80px");
	});
	
	
}); 	
function logout(){
	if(! confirm('<%= localeMessage.getString("screen.logoutMsg") %>')){
		return;
	}
	var winChild = window.open("","RMSDASHBOARD","width=1,height=1,left=1,top=1");
	if(winChild){
		winChild.close();
	}
	parent.location.href='<%=request.getContextPath()%>/rms/logout.do';
}	 
</script>
</head>
    <body onload="menuRender()">
		<header class="sub">
			<div class="gnb_wrap">
				<h1 class="logo" ><a href="#"><img src="/monitoring/images/top_logo.png"/></a></h1>
				<div class="topmenu_box">
					<ul>
						<li><a href="#"><span><%=SessionManager.getUserId(request) %></span><%= localeMessage.getString("screen.customer") %></a></li>
						<li onclick="logout()"><a href="#" class=""><img src="<c:url value="/img/icon_logout.png"/>" alt="" /><%= localeMessage.getString("screen.logout") %></a></li>					
						
					<% //if(((String)SessionManager.getRoleIdString(request)).indexOf("admin") > -1) { %>
							<li><a href="javascript:goDashboard();" class=""><img src="/monitoring/images/icon_dash.png" alt=""/>대시보드</a></li>
						<% //} %>						
											
					</ul>
					<div class="service_type" name="serviceType">
						<a href="javascript:void(0)" class="title"><span><%=serviceKey%></span>
						<% if(((String)SessionManager.getRoleIdString(request)).indexOf("admin") > -1) { %>	
						 	<div class="icon"><img src="/monitoring/images/icon_arrow_down.png" alt="" /></div></a>
							<ul class="list">					 				
							<% for (DataSourceType d : DataSourceTypeManager.getDynamicDataSourceTypes()){	%>
								<li><a href="" id="<%=d.getName()%>"><%= d.getName() %></a></li>
							<%}%>	
							</ul>
						<%}else{%>	
						 	</a>		
						<% } %>	 						
						
					</div><!-- end.service_type -->
				</div><!-- end.topmenu_box -->				
				<div class="gnb">				
					<nav>
						<ul class="depth1">
							<%=subLayer.toString()%>
						</ul>					
					</nav>	
				</div><!-- end gnb -->
				<div class="gnb_bg"></div>	
			</div><!-- end gnb_wrap -->		
		</header>		
    </body>
</html>