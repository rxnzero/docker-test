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
var isDetail = false;

function isValid(){
	if($('input[name=roleId]').val() == ""){
		alert("<%= localeMessage.getString("role.checkRequired1") %>");
		return false;
	}else if($('input[name=roleName]').val() == ""){
		alert("<%= localeMessage.getString("role.checkRequired2") %>");
		return false;
	}else if($('select[name=useYn]').val() == ""){
		alert("<%= localeMessage.getString("combo.checkRequiredUsed") %>");
		return false;
	}else if($('input[name=roleScreen]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd3") %>");  // 상위메뉴 ID를 입력하여 주십시요.
		return false;
	}
	return true;
}
function init(url,key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=useYn]")).setData(json.useYnTypeRows).setFormat(codeName3OptionFormat).rendering();
			
			
			if(typeof callback === 'function') {
				callback(url,key);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function detail(url,key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', roleId : key},
		success:function(json){
			var data = json;
			$("input[name=roleId]").attr('readonly',true);
			if (data['ROLESCREEN']=="DASHBOARD"){
				$("input[name=dashCheck]").attr("checked", true);
			}
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
	
	var url ='<c:url value="/common/acl/role/roleMan.json" />';
	var key ="${param.roleId}";
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	init(url,key,detail);
	
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
	$("input[name=dashCheck]").click(function(){
		var chk = $(this).is(":checked");
		if (chk){
			$("input[name=roleScreen]").val("DASHBOARD");
		}else{
			$("input[name=roleScreen]").val("");
		}
	});
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});
	$("#roleSearch").click(function(){
	});
	$("#btn_change").click(function(){
	    var args = new Object();
	    args['roleId'] = $("input[name=roleId]").val();
	    
	    var url = '<c:url value="/common/acl/role/roleMan.view"/>';
	    url = url + "?cmd=POPUP";
	    showModal(url,args,460,645);
		
	});
	$("#btn_popup").click(function(){
	    var args = new Object();
	    args['roleId'] = $("input[name=roleId]").val();
	    
	    var url = '<c:url value="/common/acl/role/roleMan.view"/>';
	    url = url + "?cmd=POPUP2";
	    var ret = showModal(url,args,460,645, function(arg){
	    	var args = null;
	        if(arg == null || arg == undefined ) {//chrome
	            args = this.dialogArguments;
	            args.returnValue = this.returnValue;
	        } else {//ie
	            args = arg;
	        }
	        
	        if( !args || !args.returnValue ) return;
	        var ret = args.returnValue;
	        $("input[name=roleScreen]").val(ret);
	        
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
					<img src="<c:url value="/img/btn_change.png"/>" alt="" id="btn_change" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title"><%= localeMessage.getString("role.title") %></div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("role.id") %></th><td><input type="text" name="roleId"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("role.name") %> </th><td><input type="text"  name="roleName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("combo.useYn") %> </td>
							<td><div class="select-style"><select name="useYn" /></td>
						</tr>
						<tr height="100px">
							<th><%= localeMessage.getString("role.description") %></th><td><textarea  name="roleDesc" style="width:100%;height:100px"></textarea></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("role.screen") %></th>
							<td>
								<input type="text"  name="roleScreen" readonly="readonly" style="width:calc(100% - 160px);"/> 
								<img id="btn_popup" src="<c:url value="/img/btn_pop_search.png" />" class="btn_img"> 
								<!-- <input type="checkbox" name="dashCheck" id="sub4_6_2_detail_1"><label for="sub4_6_2_detail_1">대시보드화면</label> --> 
							</td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

