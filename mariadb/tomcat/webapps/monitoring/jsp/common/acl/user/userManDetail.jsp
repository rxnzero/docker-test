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
var url      = '<c:url value="/common/acl/user/userMan.json" />';
var url_view = '<c:url value="/common/acl/user/userMan.view" />';

var isDetail = false;
function isValid(){
	if($('input[name=userId]').val() == ""){
		alert("<%= localeMessage.getString("user.checkRequired1") %>");
		return false;
	}else if($('input[name=userName]').val() == ""){
		alert("<%= localeMessage.getString("user.checkRequired2") %>");
		return false;
	}else if($('input[name=password]').val() == ""){
		alert("<%= localeMessage.getString("user.checkRequired3") %>");
		return false;
	}else if($('select[name=useYn]').val() == ""){
		alert("<%= localeMessage.getString("combo.checkRequiredUsed") %>");
		return false;
	}
	return true;
}
function init(key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=useYn]")).setData(json.useYnTypeRows).setFormat(codeName3OptionFormat).rendering();
			
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
		data:{cmd: 'DETAIL', userId : key},
		success:function(json){
			var data = json;
			$("input[name=userId]").attr('readonly',true);

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
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key ="${param.userId}";
	if (key != "" && key !="null"){
		isDetail = true;
	}
	init(key,detail);
	
	$("#btn_modify").click(function(){
		if (!isValid()){
			return;
		}
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
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});
	
	$("#btn_change").click(function(){
	    var args = new Object();
	    args['userId'] = $("input[name=userId]").val();
	    
	    var url2 = url_view;
	    url2 += "?cmd=POPUP";
	    showModal(url2,args,450,600);
		
	});
	$("#btn_biz_change").click(function(){
	    var args = new Object();
	    args['userId'] = $("input[name=userId]").val();
	    
	    var url2 = url_view;
	    url2 += "?cmd=POPUP2";
	    showModal(url2,args,980,600);
		
	});	
	$("#btn_initialize").click(function(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'UPDATE_PASSWORD', userId : $("input[name=userId]").val()},
			success:function(json){
				alert("<%= localeMessage.getString("common.successMsg") %>");		
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	

	buttonControl(isDetail);
	titleControl(isDetail);
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
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_biz_change.png"/>" alt="" id="btn_biz_change" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_change.png"/>" alt="" id="btn_change" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>						
				</div>
				<div class="title"><%= localeMessage.getString("userDetail.title") %></div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("user.id") %></th><td ><input type="text" name="userId"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.name") %> </th><td><input type="text"  name="userName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.pw") %> </th><td><input type="password"  name="password"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("combo.useYn") %> </th>
							<td><div class="select-style"><select name="useYn" /></div></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.depart") %> </th><td><input type="text"  name="deptName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.position") %> </th><td><input type="text"  name="positionName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.depCode") %> </th><td><input type="text"  name="branchCode"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.mobile") %> </th><td><input type="text"  name="mobile"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.phone") %> </th><td><input type="text"  name="phone"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.email") %> </th><td><input type="text"  name="email"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.createBy") %> </th><td><input type="text"  name="createBy" readonly="readonly"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.updateBy") %> </th><td><input type="text"  name="updateBy" readonly="readonly"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.createOn") %> </th><td><input type="text"  name="createOn" readonly="readonly"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("user.updateOn") %> </th><td><input type="text"  name="updateOn" readonly="readonly"/></td>
						</tr>

					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

