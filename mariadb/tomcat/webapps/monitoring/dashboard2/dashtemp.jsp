<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="com.eactive.eai.rms.common.util.StringUtils"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	request.setCharacterEncoding("euc-kr");
%>

<html>
<head>
<style>
#main{margin: 0 auto; width:600px; height:150px; background-color:#888888; border-left:1px solid #333333; border-right:1px solid #333333; float:left;}
</style>
<title>EAI ��ú���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"> </script>
<script language="JavaScript">
function requestData() {

	// ĳ�ù���, �ѱ�ó�� ���� Ȯ���Ұ�.

	var url = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=all" ;
	var optRefresh = "&t=" + ((new Date()).valueOf()); // ĳ�ù���
	reqAjax.open("GET", url + optRefresh, true);
	reqAjax.onreadystatechange = updatePage ;
	reqAjax.send(null);
}

function updatePage() {
	if( reqAjax.readyState == 4 ) {
		if( reqAjax.status == 200 ) {
			var retVal = reqAjax.responseText ;
			
			alert( retVal );
			
			document.getElementById("INST1").value = extractData(retVal, "INST1");
			document.getElementById("INST2").value = extractData(retVal, "INST2");
			document.getElementById("INST3").value = extractData(retVal, "INST3");
			document.getElementById("INST4").value = extractData(retVal, "INST4");
			document.getElementById("INST5").value = extractData(retVal, "INST5");			
		} else {
			alert( 'reqAjax.status=' + reqAjax.status );
		}
	} else {
		alert( 'reqAjax.readyState=' + reqAjax.readyState );
	}
}

function extractData( line, type ) {
	var arr = new Array();
	arr = line.split("|");
	for( i = 0 ; i < arr.length ; i++ ) {
		var sub = new Array();
		sub = arr[i].split("=");
		if( sub[0] == type ) {
			return sub[1];
		}		
	}
	
	return "" ;	
}

function keydown(){ 
     if(event.keyCode==122 || event.altKey==true || event.altLeft==true){
            event.keyCode=0;
            event.cancelBubble = true;
            event.returnValue = false;
            alert('�� Ư��Ű�� ����� �� �����ϴ�.');
     }        
}
// F11 Ű ���� 
document.onkeydown=keydown; 
</script>

</head>
<body bgcolor="grey">

<div id="main">

��ú��� ���� ������<br>

<form id="mainForm">
������ ��û : <input type='button' value='�����Ϳ�û' onclick='requestData()'></input><br>
��� : <input id='INST1' type='text' width='80' value='0'></input><br>
���� : <input id='INST2' type='text' width='80' value='0'></input><br>
���� : <input id='INST3' type='text' width='80' value='0'></input><br>
DMZ : <input id='INST4' type='text' width='80' value='0'></input><br>
�ϰ� : <input id='INST5' type='text' width='80' value='0'></input><br>
</form>

</div>


<br>
<a href="dashonline.jsp">�¶��� ��ȭ��</a>
<br>
<a href="dashbatch.jsp">�ϰ� ��ȭ��</a>
</body>
</html>