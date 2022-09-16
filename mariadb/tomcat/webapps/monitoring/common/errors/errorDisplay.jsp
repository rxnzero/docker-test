<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page session="true" autoFlush="true"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
<%--@ taglib uri="netui-tags-html.tld" prefix="netui"--%>

<html>
<head>
<title><%= localeMessage.getString("common.POSITION_ROOT") %></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet"
  href="<c:url value="/common/css/Sitemapstyle.css" />" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
    <table width="626" border="0" cellspacing="0" cellpadding="0"
      align="center">
      <tr>
        <td height="80" width="565"></td>
        <td height="330" rowspan="4" width="61"></td>
      </tr>
      <tr>
        <td height="137" width="565"><img
          src="<c:url value="/common/image/error01.gif" />" width="565"
          height="137"></td>
      </tr>
      <tr>
        <td height="88"
          background="<c:url value="/common/image/error_bg.gif" />"
          class="left2" width="565"><br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>[ <%= localeMessage.getString("errors.title") %> ]</b>
        <div align="center"><br>           
<%--
				<netui:label value="{request.errorMessage}" defaultValue="" />
				<br/>
				<netui:exceptions showMessage="true" />
--%>
        <table width="25%" border="0" cellspacing="0" cellpadding="0"
          align="right">
          <tr>
            <td>
            <div align="center"><a href="#" onClick="history.back()"><img
              src="<c:url value="/common/images/btn6_previous.gif" />"
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
          src="<c:url value="/common/image/error02.gif" />" width="565"
          height="25"></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</body>
</html>

