<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*, 
java.util.*,
javax.xml.parsers.*,
org.w3c.dom.*,
javax.xml.xpath.*,
java.sql.*,
javax.sql.*,
com.eactive.eai.agent.command.*,
com.eactive.eai.agent.*,
com.eactive.eai.rms.onl.common.util.*,

org.apache.commons.logging.Log,
org.apache.commons.logging.LogFactory,
com.eactive.eai.transformer.dao.jdbc.oracle.DataSourceFactory,


java.util.Arrays,
com.eactive.eai.rms.common.util.StringUtils,
com.eactive.eai.common.util.SystemUtil

"%>
<%!

/*
	"운영환경" 어뎁터 상태정보 및 컨트롤 기능

*/
private static final Log logger = LogFactory.getLog("runSql.jsp");



private String   NEW_LINE    = "\n";
private static Object obj = new Object();

public StringBuffer ListToString(List<String[]> list){
	StringBuffer sb = new StringBuffer();
	//first item is ColName
	boolean isHead = true;
	for(String[] ar : list){
		for(int i =0; i < ar.length; i++){
			sb.append(ar[i]).append("\t\t\t");
		}
		sb.append(NEW_LINE);
		if(isHead){
			sb.append(StringUtils.repeat("-----",sb.length())).append(NEW_LINE);
			isHead= false;
		}
	}
	return sb;
}
public HashMap runSql(List<String> list,String serviceType ) throws Exception {
	Connection conn = null;
	Statement stmt = null;
	String driver = null;
	String url = null;
	String id =null;
	String pwd=null;


	HashMap<String, Object> results = new HashMap();
	StringBuffer sb = new StringBuffer();
	int rownum = 0;
	try	{
	
		DataSourceFactory dsf = new DataSourceFactory();
		DataSource ds = dsf.getDataSource(serviceType);
		conn = ds.getConnection();
		stmt = conn.createStatement();
  		
  		int cnt = 0;
  		for(String sql : list){
	  		try{
	  		
	  			if(sql.toUpperCase().startsWith("SELECT")){
	  					ResultSet rs = null;
	  			  		stmt.execute(sql);
  						rs = stmt.getResultSet();

				  		List ret = new ArrayList();
				  		int maxColumn = rs.getMetaData().getColumnCount();
				  		ResultSetMetaData rsmd = rs.getMetaData();
				  		String[] colName = new String[maxColumn];
				  		//get Col Name
				  		for(int i =1; i<=maxColumn; i++){
				  			
				  			colName[i-1] = rsmd.getColumnName(i);
				  		}
				  		ret.add(colName);
				        while(rs.next()) {
				        	String[] row = new String[maxColumn];
				        	for (int i=0;i<maxColumn;i++){
								row[i] = rs.getString(i+1);
				        	}    	
				        	ret.add(row);
						}
				        sb = ListToString(ret);
				        //sb.append(Arrays.toString(ret.toArray()));
						results.put("SEL"+(cnt++),ret);  
						
	  			}else{	//INSERT, UPDATE, DELETE
	  				int affected =	stmt.executeUpdate(sql);
	  				sb.append("==> Execute - ["+sql.trim()+"], affected "+ affected +" rows").append(NEW_LINE);
	  			}
	
	  		}catch(Exception e){
	  			sb.append("==> Error   - ["+sql + "] : " +e.getMessage()).append(NEW_LINE);
	  		}
		}
	}catch(Exception e) {
		logger.error(e.getMessage(),e);
		throw e;
	}
	finally {
		try {
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
		catch (SQLException sqle) {
			logger.error("SQLException was thrown: " + sqle.getMessage());
		}
	}
	HashMap retMap = new HashMap();
	
	retMap.put("records",results);
	retMap.put("result", sb.toString());
	
	return retMap;
}




public HashMap execute(String statements, String serviceType,ServletRequest request) throws Exception {
	String[] results = new String[2];
	
    String[] arr = statements.split(";");
    List<String> list = Arrays.asList(arr);
    
    	
	return runSql(list, serviceType);
	
}

%>


<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
%>

<%
	request.setCharacterEncoding("euc-kr");
	String filter = request.getParameter("filter");

	String serviceType = request.getParameter("serviceType");
	String statement = request.getParameter("statement");
	String userType=request.getParameter("userType");
	String run=request.getParameter("run");
	//String message=request.getParameter("message");

	String displayType="all";
	if (run == null) run = "";
	if (serviceType == null) serviceType = "";
	if (statement == null) statement = "";
	
	HashMap runResult =new HashMap();

	if (!"".equals(run) ){
		runResult = execute(statement,serviceType,request);	
		//response.sendRedirect("/monitoring/jsp/common/jsonResult.jsp");
	}else{
		
	}

	
		

%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
<script language="javascript" src="<c:url value="/common/js/common.js" />"></script>
 <jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/> 
<%-- <script language="javascript" src="<c:url value="/js/jquery-1.7.2.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jquery-ui.min.js"/>"></script> --%>
<script language="javascript" >
var $ = jQuery.noConflict();
var url = '<c:url value="/runSql.jsp" />';

$(document).ready(function() {		
	$('select[name=serviceType]').val("<%=serviceType%>");
	//$('select[name=serviceType]').attr('disabled','disabled');
	$("#btn_submit").click(function(){
		var serviceType = $('select[name=serviceType] option:selected').val();
		var postData = new Array();
		var statement = $("textarea[name=statement]").val();
		if(statement == "" || statement == null){
			alert("<%= localeMessage.getString("runSql.checkMsg") %>");
			return;
		}
		document.forms.runSql.run.value = "1";
		document.forms.runSql.action= url;
		document.forms.runSql.submit();		
/* 		postData.push({name: "statement" , value:statement});
		postData.push({name: "serviceType", value:serviceType});
		postData.push({name: "run", value:"1"});
		$.ajax({
			type : "POST",
			//url:url,
			data:postData,
			success:function(args){		
				alert("executed");

				$("textarea[name=result]").val($(args).find('result'));		
			},
			error:function(xhr, status, errorMsg){
				//$("textarea[name=result]").val(errorMsg);
				//alert(JSON.parse(xhr.responseText).errorMsg);
			}
		}); */

	});

	$("#btn_close").click(function(){
		window.close();
	});
	

	
}); 
 
</script>
</head>
	<body>

	<!-- button -->
	<table  width="98%" height="35px"  align="center">
	<form method="post" name="runSql">
	<tr>
		<td align="right" >
	    	<select name="serviceType" width="100px">
	    	<option value="FEP">FEP</option>
	    	<option value="EAI">EAI</option>
	    	</select>		
			<img id="btn_submit" src="<c:url value="/images/bt/bt_operate.gif"/>" level="W" style="cursor:hand"/>
			<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>"  level="R"/>
		</td>
	</tr>
	<tr>
		<td align="left" width="80%">
		<table width="100%">
		    <tr>
		        <td class="search_td_title" width="150px"><%= localeMessage.getString("runSql.excute") %></td>
		    </tr>
		    
		    <tr>
		        <td height="450px"><textarea name="statement"  style="width:100%;height:100%"><%= statement%></textarea>
			 	<INPUT type=hidden name="run" value="<%=run%>">
		    	</td>
		    </tr>
		    </form>
		    <tr>
		        <td class="search_td_title" width="150px"><%= localeMessage.getString("runSql.result") %></td>
		    </tr>		
		    <tr>
		    <td height="450px"><textarea name="result"  style="width:100%;height:100%"><%= runResult.get("result")%></textarea>
		    </tr>   
		</table>
		</td>

	</tr>
	</table>	
	</body>
</html>


