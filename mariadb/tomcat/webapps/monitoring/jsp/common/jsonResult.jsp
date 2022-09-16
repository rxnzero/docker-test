<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	String message = (String)request.getAttribute("message");
	ArrayList<Map<String,String>> rows = (ArrayList<Map<String,String>>)request.getAttribute("rows");
	int row = 0; 
%>
{"message":"<%=message%>","rows":[

	<% 
		for(Map<String,String> m : rows){
	%>
	<%=row==0?"":"," %>{
	<%

			int i=0;
			for(String key  : m.keySet()){
			
 	%>
 			<%=i==0?"":"," %>"<%=key%>":"<%=m.get(key) %>"
	<%
				i++;
			}
 	%>
	}		
	<%	
			row++;
		}
	 %>
]}
