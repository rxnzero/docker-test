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
var level = window.dialogArguments["level"];
var parentMenuId = window.dialogArguments["parentMenuId"]; 
var url ='<c:url value="/common/acl/menu/menuMan.json" />';

function init(){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=displayYn]")).setData(json.displayYnRows).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=useYn]")).setData(json.useYnTypeRows).setFormat(codeName3OptionFormat).rendering();
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function isValid(){
	if($('input[name=menuId]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd1") %>");
		return false;
	}else if($('input[name=menuName]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd2") %>");
		return false;
	}else if($('textarea[name=menuUrl]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd4") %>");
		return false;
	}
    var pmenu = $('input[name=parentMenuId]').val();
    var menuId = $('input[name=menuId]').val();
	
    var index = 0;
    if (level == 1) {
    	index = 0;
    }else if (level == 2){
    	index = 2;
    }else if (level == 3){
    	index = 4;
    }

	if (pmenu.substr(0,index) != menuId.substr(0,index)){

		 var r = confirm(replaceMsg("<%=localeMessage.getString("menu.checkMsg1")%>", pmenu.substr(0,index),menuId.substr(0,index)));        
	        
		 if (r == false) return false;
	}

	return true;
}


$(document).ready(function() {	
	init();
	$("input[name=level]").val(level);
	$("input[name=parentMenuId]").val(parentMenuId);
	$("select[name=displayYn]").val('N');
	$("select[name=useYn]").val('N');
	$("select[name=sortOrder]").val('1');
	if (level != 3){
		$(".dynamic").hide();
	}
		
	$("#btn_modify").click(function(){
		if (!isValid()){
			return;
		}
		
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"INSERT"});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("<%= localeMessage.getString("common.saveMsg") %>");
				$("#btn_close").trigger("click");
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("#btn_close").click(function(){
		window.close();
	});
	
	buttonControl();
	
});
 
</script>
</head>
	<body>
		<div class="popup_box">
			<div class="search_wrap">
				<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" />
				<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" />	
			</div>
			<div class="title"><%= localeMessage.getString("menu.title") %></div>
			<form id="ajaxForm">
			<table class="table_row" cellspacing=0;>
				<tbody>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("menu.id") %></th>
						<td><input type="text" name="menuId"></td>							
					</tr>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("menu.name") %></th>
						<td><input type="text" name="menuName"></td>							
					</tr>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("menu.parent") %></th>
						<td><input type="text" name="parentMenuId" readonly="readonly"></td>							
					</tr>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("menu.img") %></th>
						<td><input type="text" name="menuImage"></td>							
					</tr>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("menu.display") %></th>
						<td>
							<div class="select-style">
								<div class="select-style"><select name="displayYn"/></div>
						</td>							
					</tr>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("combo.useYn") %></th>
						<td><div class="select-style"><div class="select-style"><select name="useYn"/></div></td>							
					</tr>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("menu.order") %></th>
						<td><div class="select-style"><div class="select-style"><select name="sortOrder">
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
						<option value="6">6</option>
						<option value="7">7</option>
						<option value="8">8</option>
						<option value="9">9</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
					</select></div></td>							
					</tr>
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("menu.url") %><div style="color:red;"><%= localeMessage.getString("menu.checkMsg4") %></div></th>
						<td><textarea name="menuUrl" style="width:100%;height:100px"></textarea></td>							
					</tr>
				</tbody>
			</table>	
			</form>
		</div><!-- end.popup_box -->
	</body>
</html>

