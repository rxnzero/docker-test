<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
<%@ page import="com.eactive.eai.rms.common.datasource.DataSourceContextHolder"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
<%

String SERVER_TYPE = (com.eactive.eai.common.util.SystemUtil.isProdServer())? "" :
                     (com.eactive.eai.common.util.SystemUtil.isTestServer())? "T" :
                     (com.eactive.eai.common.util.SystemUtil.isDevServer()) ? "D"	:"";
%>
<c:set var="SERVER_TYPE" value="<%=SERVER_TYPE%>"/>
<script language="Javascript">
    function logout(){

        if( ! confirm('<%= localeMessage.getString("screen.logoutMsg") %>') ) {
            return ;
        }
        
        // 자식창이 있으면 닫아준다.
        var winChild = window.open("", "RMSDASHBOARD", "width=1,height=1,left=1,top=1");
        if( winChild ) {
        	winChild.close();
        }
        
        //top.location.href='<%=request.getContextPath()%>/LoginServlet?method=logout';
        top.location.href='<%=request.getContextPath()%>/rms/logout.do';
    }    
</script>
<table width="167px" style="margin-top:0px">
<tr>
	<td align="center"><font size="6"> <%=DataSourceContextHolder.getDataSourceType().getText() %></font></td>
</tr>
</table>
<table width="167px" background="images/common/userBg.gif" style="margin-top:0px">
<c:if test="${!empty SERVER_TYPE}">
  <tr>
  <td colspan="4" height="30px" background="images/common/eaiDevTitle_<c:out value="${SERVER_TYPE }"/>.gif"></td>
  </tr>
</c:if>
  <tr>
	<td width="7px" height="30px"><img src="images/common/userLeft.gif"></td>
	<td background="images/common/userBg.gif"><a href="#"><img src="images/button/btnLogout.gif"  onclick="logout()" alt="<%= localeMessage.getString("screen.logout") %>"></a></td>
	<td align="right" background="images/common/userBg.gif" class="userName"> <%=SessionManager.getUserId(request)%> <%= localeMessage.getString("screen.customer") %></td>
	<td width="7px" align="right"><img src="images/common/userRight.gif"></td>
  </tr>
</table>
