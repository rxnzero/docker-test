<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page isErrorPage="true"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>

<%
  Object obj = session.getAttribute("LAST_DECORATOR");
  String decoratorName = null;
  decoratorName = (String)obj;
  if (decoratorName == null || decoratorName.equals("")) {
    decoratorName = "adapterSnaPage";
  }
  
  // String errorMessage = (String)request.getAttribute("errorMessage")==null?"":(String)request.getAttribute("errorMessage");
%>
<html>
<head>
<title><%= localeMessage.getString("common.POSITION_ROOT") %></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet"
  href="/monitoring/common/css/Sitemapstyle.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0">
<table width="765" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
    <table width="626" border="0" cellspacing="0" cellpadding="0"
      align="center" >
      <tr>
        <td height="80" width="565">&nbsp;</td>
        <td height="330" rowspan="4" width="61">&nbsp;</td>
      </tr>
      <tr>
        <td height="137" width="565"><img
          src="/monitoring/common/image/error01.gif" width="565"
          height="137"></td>
      </tr>
      <tr>
        <td height="88" width="565" align="left"
          background="/monitoring/common/image/error_bg.gif"
          class="left2" width="565" ><br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>[ <%= localeMessage.getString("errors.title") %> ]</b>
        <div align="center"><br>
       
        <table width="25%" border="0" cellspacing="0" cellpadding="0"
          align="right">
          <tr>
            <td >
            <div align="center"><a href="#" onClick="history.back()"><img
              src="/monitoring/common/image/btn6_previous.gif"
              width="79" height="22" border="0"></a></div>
            </td>
          </tr>
        </table>
        </div>
        <div align="right"></div>
        </td>
      </tr>
      <tr>
        <td height="25" width="565"><img
          src="/monitoring/common/image/error02.gif" width="565"
          height="25"></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
<table width="765" border="0" >
  <tr>
    <td align="left" valign="top" width="765" >
    </td>
  </tr>
</table>
</body>
</html>
