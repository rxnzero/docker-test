<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<html>

<head> 
<script language="JavaScript">
var winDashboard = null ;
function goDashboard() {
	winDashboard = window.open("<%=request.getContextPath()%>/dashboard2/dashmain.html", "RMSDASHBOARD", "width=1280,height=1024,left=0,top=0,scrollbars=yes,resizable=no,status=yes");
	//window.open("<%=request.getContextPath()%>/dashboard2/dashboard.html", "RMSDASHBOARD", "fullscreen");
	
	winDashboard.focus();
}

function reopenDashboard() {
	if( winDashboard ) {
		winDashboard.close();
		winDashboard = null ;
		setTimeout("goDashboard();", 3000);
	} else {
	}
}
</script>
</head>
<body> 
</body>
</html>