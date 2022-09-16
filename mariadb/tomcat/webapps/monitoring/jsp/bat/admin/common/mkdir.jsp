<%@ page import="java.io.*, java.util.*"%>
<%@ page language="java" contentType="text/html;charset=euc-kr"%>

<%
    String dir       = request.getParameter("dir");
	
	if (dir != null && dir.trim().length() >0){
		File file = new File(dir);
		file.mkdir();
//		file.setReadable(true, false);
		file.setWritable(true, false);
		file.setExecutable(true, false);
	}

%>

<html>
    <head>
        <title>
            디렉토리 생성
        </title>
        <script>
        function doAction() {
        	
            document.frm.submit();
        } 
        </script>
    </head>
    <body>
        <p style="font-size:12pt;">
        <b>디렉토리생성</b> <br><br>
        </p>

        <form name="frm" action="" method="POST">
        <table border='0' width="800" >
        <tr>
        <td align='left'>
        <table width="450" border=0 bgcolor='black' cellpadding="1" cellspacing="1">
        <tr bgcolor='white'>
            <td align='right' width='180' bgcolor="#ccccff">경로 :&nbsp;</td>
            <td><input type="text" name="dir" size="10" class="form1" value="<%=dir%>"></td>
            <td align="right"><input type="button" class="form1" value="    확인    " onclick="doAction();"></td>
        </tr>
        </table>
        </td>
        </tr>
        </form>
    </body>
</html>