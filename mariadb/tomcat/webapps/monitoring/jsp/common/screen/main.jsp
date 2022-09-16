<%@ page contentType="text/html; charset=euc-kr"%>
<%@page import="com.eactive.eai.rms.common.util.StringUtils"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>

<%
    String topPage = request.getContextPath()
            + StringUtils.defaultString((String) request.getAttribute("topPage"), "/top_04.do");

    String mainPage = StringUtils.defaultString((String) request.getAttribute("mainPage"), "");

    if (!"".equals(mainPage)) {
        topPage = topPage + "?mainPage=" + mainPage;
    }

%>

<!DOCTYPE html>
<html>
  <head>
    <title><%= localeMessage.getString("screen.title") %></title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<link rel="stylesheet" type="text/css" media="screen" href="<c:url value="/css/web_ui.css"/>"/>
	<link rel="stylesheet" type="text/css" media="screen" href="<c:url value="/css/theme_${themeColor}.css"/>" />
	<script language="javascript" src="<c:url value="/js/jquery-1.12.1.min.js"/>"></script>
   	<script language="javascript">
   	var $ = jQuery.noConflict();
	var urlParam = window.document.location.search;
	var mod		 = "";
	var strServiceType = "<%=request.getParameter("serviceType")%>";
	if(urlParam != ""){
 		if(urlParam.indexOf("mod=") > -1){
 			mod = urlParam.substring((urlParam.indexOf("mod=") + 4), urlParam.lastIndexOf("&"));
 			sessionStorage["mod"] = mod;
 		}
 		
 		// ��ú��� ��ȭ�����κ��� Ư��ȭ���� �����Ͽ� Open �ϴ� ���.
 		// session�� ����Ǿ� �ִ� serviceType�� ȭ�� ������ �� ������ serviceType�� �ٸ� ���
 		// ��ú��� ��ȭ�鿡�� ������ serviceType���� session�� ����Ǿ� �ִ� serviceType�� �����մϴ�.
		if(strServiceType != "null" && sessionStorage["serviceType"] != strServiceType)
		{
			sessionStorage["serviceType"] = strServiceType;
		}
	}   	
   	$(document).ready(function() { 

   	

    	var url = '<%=topPage%>';
   		if (url.indexOf("mainPage")>=0){
   			url = url + "&serviceType="+ sessionStorage["serviceType"];
   		}else{
   			url = url + "?serviceType="+ sessionStorage["serviceType"];
   		}
   		$("#topFrame").attr('src',url); 
   		
	 	$(".topMenu").load(function(){    // iframe�� ��� load���� ����
				$(".topMenu").contents().find('.gnb').on("mouseenter", function(e){
					$(".topMenu").css("height","450px");
				});
				$(".topMenu").contents().find('.gnb').on("mouseleave",function(e){	
					$(".topMenu").css("height","80px");
				});
	
			});			   		 
   	});

   	</script>
  </head>
  <body>
		<iframe class="topMenu" src="" id="topFrame" name="topFrame" scrolling="no" noresize="noresize"></iframe>
		<iframe class="leftMenu" src="" name="leftFrame" scrolling="no" noresize="noresize"></iframe>
		<iframe class="rightCon" src="" name="mainFrame" scrolling="auto"></iframe>
</body>	
</html>
 
