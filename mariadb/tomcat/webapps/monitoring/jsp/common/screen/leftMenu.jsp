<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="com.eactive.eai.rms.common.acl.menu.MenuRenderController"%>
<%@page import="com.eactive.eai.rms.common.login.SessionManager"%>
<%@page import="com.eactive.eai.rms.common.util.CommonConstants"%>
<%@page import="com.eactive.eai.rms.common.util.StringUtils"%>
<%@page  import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String menuName = (String) request.getAttribute("menuName");
	List list = (List) request.getAttribute("leftMenuList");
%>
<!DOCTYPE html>
<html>
  <head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="javascript" src="<c:url value="/js/jquery-1.12.1.min.js"/>"></script>    
	<link rel="stylesheet" type="text/css" href="<c:url value="/css/web_ui.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<c:url value="/css/theme_${themeColor}.css"/>" />
    <script>
    function changeBackColor(selectedItemId)
    {
        var ele;
        for (i = 0 ; i < <%=list.size()%> ; i++ )
        {
        	
            ele = $("li[id="+i+"]");           
            if (ele != undefined)
            {
            	var id = ele.attr('id');
                if (id == selectedItemId)
                {
                    //ele.bgColor = onColor;
                    //ele.setAttribute('class', 'on');
                    ele.addClass('on');
                }
                else
                {
                    //ele.bgColor = offColor;
                    //ele.setAttribute('class', '');
                    ele.removeClass('on');
                }

            }
        }
    }

    function selectItem(id)
    {
        selectedItemId = id;
        changeBackColor(id);
    }    
    //메인 페이지 이동하기
    function goPage(pUrl, id)
    {
    	    	
        var pageUrl = pUrl;
    	if (pUrl.indexOf("?")>-1){
	    	pageUrl += "&";
    	}else{
	    	pageUrl += "?";
    	}
    	pageUrl += "menuId="+id;
		pageUrl += "&serviceType="+sessionStorage["serviceType"];
        
        parent.mainFrame.location.href= pageUrl;
    }   
    function isSmallMenu() {
//     	console.log("checked : ", $("#nav").prop('checked'));
    	return !$("#nav").prop('checked');
    }
    $(document).ready(function(){
    	//첫페이지를 select
    	selectItem(0);
    	//$("li[id=0]").addClass('on'); 
    });
    
    
</script>
  </head>

  <body style="margin: 0">
 	<body>
			<div class="left_box">
				<div class="title"><%=menuName%></div>
				<ul class="depth3">
			  	<%
                      HashMap map = null;
                  			for (int i = 0; i < list.size(); i++) {
                  				map = (HashMap) list.get(i);
                %>
                <li id="<%=i%>" onclick="selectItem(<%=i%>)"><a href="javascript:goPage('<%=map.get("MENUURL")%>','<%=map.get("MENUID")%>');"><%=map.get("MENUNAME")%></a></li>
                <%-- <li <%if(menuName.equals((String)map.get("MENUNAME"))){ %>class="on"<%} %>><a href="javascript:goPage('<%=map.get("MENUURL")%>','<%=map.get("MENUID")%>');"><%=map.get("MENUNAME")%></a></li> --%>
 			     <%} %>
				</ul>				
			</div><!-- end left_box -->
			
		
	</body>	
</html>

