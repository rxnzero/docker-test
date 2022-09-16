<%@ page language="java" import="java.util.*" pageEncoding="EUC-KR"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <title>RMS REFRESH PAGE</title>
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        <meta http-equiv="expires" content="0">
    </head>

    <body>
    <table border="1" cellspacing="2" cellpadding="1">
        <tr bgcolor="#77BBFF">
            <th>KEY</th>
            <th>VALUE</th>
        </tr>
<%
    Object obj = session.getAttribute("After.Refresh.Properties");
    if( obj != null ) {
        Properties p = (Properties)obj;
        Enumeration keys = p.keys();
        while( keys.hasMoreElements()) {
            String key = (String)keys.nextElement();
            String value = (String)p.get(key);
            out.print("<tr><td>" + key + "</td>");
            out.print("<td>" + value + "</td></tr>");
        }
    } else {
        out.print("<tr><td>Empty key</td>");
        out.print("<td>Empty value</td></tr>");
    }
 %>
    </table>

    </body>
</html>