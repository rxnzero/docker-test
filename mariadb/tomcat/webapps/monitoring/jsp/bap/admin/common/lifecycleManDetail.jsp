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
var isDetail = false;
function init(url,key,callback){
	if(typeof callback === 'function') {
		callback(url,key);
	}	
}
function detail(url,key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', lifeCyclClsName : key},
		success:function(json){
			var data = json;
			$("input[name=lifeCyclClsName]").attr('readonly',true);
			
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
	var url ='<c:url value="/bap/admin/common/lifecycleMan.json" />';
	var key ="${param.key}";
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	init(url,key,detail);
	
	
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
				<div class="title">����������Ŭ<span class="tooltip">IF�ý��� �⵿ �� �ε��Ǵ� ����������Ŭ Ŭ������ �߰��մϴ�.</span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">����������Ŭ Ŭ������ *</th>
							<td><input type="text" name="lifeCyclClsName"/> </td>
						</tr>
						<tr>
							<th>�ε����� *</th>
							<td><input type="text"  name="lodinSeq"/></td>
						</tr>
						<tr>
							<th>����������Ŭ ����</th>
							<td>
								<div class="select-style">
									<select name="lifeCyclUseDstcd" />
								</div>	
							</td>
						</tr>
					</table>
				</form>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>
