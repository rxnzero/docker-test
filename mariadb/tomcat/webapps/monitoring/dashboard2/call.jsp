<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%
	int  callCount = (Integer)session.getAttribute("callCount") == null? 0 :(Integer)session.getAttribute("callCount") ;
	callCount++;
	session.setAttribute("callCount", callCount);	
%>
<html>

<head> 
<meta http-equiv='refresh' content='10;url=call.jsp'> 
</head>
<body>
callCount : <%= callCount %><br>
JSESSIONID=<%=session.getId()%><br>
</body>

</html>