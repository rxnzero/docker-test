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
var url      ='<c:url value="/onl/admin/rule/layoutTypeMan.json" />';
var url_view ='<c:url value="/onl/admin/rule/layoutTypeMan.view" />';
var isDetail = false;
function init(key,callback){
	if(typeof callback === 'function') {
		callback(key);
	}	
}
function detail(key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', loutPtrnName : key},
		success:function(json){
			var data = json;
			$("input[name=loutPtrnName]").attr('readonly',true);
			
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
	var key ="${param.loutPtrnName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	init(key,detail);
	
	
	$("#btn_modify").click(function(){
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
				alert("���� �Ǿ����ϴ�.");
				goNav(returnUrl);//LIST�� �̵�
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
				alert("���� �Ǿ����ϴ�.");
				goNav(returnUrl);//LIST�� �̵�

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST�� �̵�
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
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">�������̾ƿ� ����<span class="tooltip">�������̾ƿ� ���ο����� �������̾ƿ� ������ �����ϴ� ȭ���Դϴ�. ���ο������� ��밡���� ���� Ÿ���� ��Ÿ���ϴ�</span></div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">�������̾ƿ�������</th><td width="80%"><input type="text" name="loutPtrnName"/> </td>
						</tr>
						<tr>
							<th>�������̾ƿ� ���� Ŭ����</th><td><input type="text"  name="msgLoutCretnClsName"/></td>
						</tr>
						<tr height="100px">
							<th>�������̾ƿ� ���� ����</th><td><textarea  name="loutPtrnDesc" style="width:100%;height:100px"></textarea></td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

