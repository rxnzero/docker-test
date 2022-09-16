<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
%>


<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>

<script language="javascript" >
var url      = '<c:url value="/onl/admin/common/serverMan.json" />';
var url_view = '<c:url value="/onl/admin/common/serverMan.view" />';
var isDetail = false;
function init(key,callback){
	key = key == "" ? " " : key;
	
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO', svrInstName:key},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=flovrSevrName]")).setNoValueInclude(true).setData(json.serverRows).rendering();
			if(typeof callback === 'function') {
				callback(key);
    		}				
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function detail(key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL'
		    , eaiSevrInstncName : key
		    },
		success:function(json){
			var data = json;
			$("input[name=eaiSevrInstncName]").attr('readonly',true);
			$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			});
		},
		error:function(e){
			alert(e.responseText);
		}
	});


}
function isValid(){
	if($('input[name=eaiSevrInstncName]').val() == ""){
		alert("<%= localeMessage.getString("serverDetail.checkRequired1") %>");
		return false;
	}else if($('select[name=flovrSevrName]').val() == ""){
// 		alert("<%= localeMessage.getString("serverDetail.checkRequired2") %>");
// 		return false;
	}else if($('select[name=eaiSevrIp]').val() == ""){
		alert("<%= localeMessage.getString("serverDetail.checkRequired3") %>");
		return false;
	}else if($('input[name=sevrLsnPortName]').val() == ""){
		alert("<%= localeMessage.getString("serverDetail.checkRequired4") %>");
		return false;
	}else if($('select[name=hostName]').val() == ""){
		alert("<%= localeMessage.getString("serverDetail.checkRequired5") %>");
		return false;
	}
	
	return true;
}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	
	var key ="${param.eaiSevrInstncName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}			
	init(key,detail);

	buttonControl(isDetail);
	titleControl(isDetail);
	
	
	$("#btn_modify").click(function(){
		if (!isValid())return;
		var postData = $('#ajaxForm').serializeArray();
		if (isDetail){
			postData.push({ name: "cmd" , value:"UPDATE"});
		}else{
			postData.push({ name: "cmd" , value:"INSERT"});
		}
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("<%= localeMessage.getString("common.saveMsg") %>");
				goNav(returnUrl);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("#btn_delete").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"DELETE"});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("<%= localeMessage.getString("common.deleteMsg") %>");
				goNav(returnUrl);//LIST로 이동

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});

});
 
</script>
</head>
	<body>
		<div class="right_box">
			<div class="content_top">
				<ul class="path">
					<li><a href="#">${rmsMenuPath}</a></li>					
				</ul>					
			</div><!-- end content_top -->
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title"><%= localeMessage.getString("serverDetail.title") %><span class="tooltip"><%= localeMessage.getString("serverDetail.tooltip") %></span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("server.instncName") %></th>
							<td><input type="text" name="eaiSevrInstncName"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("server.flovrsevrName") %></th>
							<td>
								<div class="select-style">
									<select name="flovrSevrName"/>
								</div>	
							</td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("server.ip") %></th>
							<td><input type="text" name="eaiSevrIp"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("server.port") %></th>
							<td><input type="text" name="sevrLsnPortName"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("server.hostname") %></th>
							<td><input type="text" name="hostName"/> </td>
						</tr>
					</table>
				</form>
				
				<!-- grid -->
				<form id="formDB" hidden="hidden">
					<table id="gridDB" ></table>
				</form>
				<form id="formFile" hidden="hidden">
					<table id="gridFile"></table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

