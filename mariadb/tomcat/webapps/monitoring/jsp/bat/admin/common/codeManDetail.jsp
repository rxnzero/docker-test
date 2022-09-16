<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	//returnUrl = returnUrl + '?cmd='+'LIST';
	//returnUrl = returnUrl + '&page='+'${param.pages}';
	//returnUrl = returnUrl + '&menuId='+'${param.menuId}';
	//검색 조건
	//returnUrl = returnUrl + '&searchMsg='+'${param.searchMsg}';
	
	
	var url ='<c:url value="/bat/admin/common/codeMan.json" />';
	var msgId ="${param.msgId}";
	if (msgId != "" && msgId !="null"){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL', msgId : msgId},
			success:function(json){
				var data = json;
				$("input[name=msgId]").attr('readonly',true);
				$("input,select").each(function(){
					var name = $(this).attr('name').toUpperCase();
					$(this).val(data[name]);
				});

			},
			error:function(e){
				alert(e.responseText);
			}
		});
		
	}
	
	
	$("#btn_modify").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		if (msgId != "" && msgId !="null"){
			postData.push({ name: "cmd" , value:"UPDATE"});
		}else{
			postData.push({ name: "cmd" , value:"INSERT"});
		}
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("저장 되었습니다.");
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
				alert("삭제 되었습니다.");
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
	buttonControl(key);
	titleControl(key);
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
				<div class="title">오류메시지<span class="tooltip">표준화된 IF시스템 에러 응답코드를 추가합니다.</span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">오류메시지 코드 *</th>
							<td><input type="text" name="msgId"/> </td>
						</tr>
						<tr>
							<th>오류메시지 *</th>
							<td><input type="text" name="msgCtnt"/></td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

