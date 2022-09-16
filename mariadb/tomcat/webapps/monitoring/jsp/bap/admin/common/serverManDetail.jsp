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
function init(url){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			debugger;
			new makeOptions("CODE","NAME").setObj($("select[name=flovrSevrName]")).setNoValueInclude(true).setNoValue(' ','��ü').setData(json.serverRows).rendering();
			detail(url);
				
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function detail(url){
	var key ="${param.eaiSevrInstncName}";
	if (key != "" && key !="null"){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL'
			    , eaiSevrInstncName : key
			    },
			success:function(json){
				$("input[name=eaiSevrInstncName]").attr('readonly',true);
				$("input,select").each(function(){
					var name = $(this).attr('name').toUpperCase();
					$(this).val(json[name]);
				});
			},
			error:function(e){
				alert(e.responseText);
			}
		});
		
	}

}
function isValid(){
	if($('input[name=eaiSevrInstncName]').val() == ""){
		alert("�ϰ����� �����ν��Ͻ����� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('select[name=flovrSevrName]').val() == ""){
		alert("��ֱغ��������� �����Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('select[name=eaiSevrIp]').val() == ""){
		alert("�ϰ����� ����IP�� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('input[name=sevrLsnPortName]').val() == ""){
		alert("����������Ʈ���� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('select[name=hostName]').val() == ""){
		alert("ȣ��Ʈ���� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}
	
	return true;
}
$(document).ready(function() {	
	var returnUrl = '${param.returnUrl}';
	returnUrl = returnUrl + '?cmd='+'LIST';
	returnUrl = returnUrl + '&page='+'${param.pages}';
	returnUrl = returnUrl + '&menuId='+'${param.menuId}';
	//�˻� ����
	
	
	var url ='<c:url value="/bap/admin/common/serverMan.json" />';
	var key ="${param.eaiSevrInstncName}";
	titleControl(key);
	buttonControl(key);
		
	init(url);

	
	
	$("#btn_modify").click(function(){
		if (!isValid())return;
		var postData = $('#ajaxForm').serializeArray();
		if (key != "" && key !="null"){
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
				<div class="title">IF����<span class="tooltip">�ϰ����� ���� ������ ����,���� �մϴ�. �ϰ����� ���� �� ����ȭ�� ���� �߿��� �ڷ��̹Ƿ� ���Ǹ� ���մϴ�</span></div>						
						
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">IF�����ν��Ͻ���</th><td><input type="text" name="eaiSevrInstncName"/> </td>
						</tr>
						<tr>
							<th>��ֱغ�������</th><td><div class="select-style"><select name="flovrSevrName"/></div></td>
						</tr>
						<tr>
							<th>IF����IP</th><td><input type="text" name="eaiSevrIp"/> </td>
						</tr>
						<tr>
							<th>����������Ʈ��</th><td><input type="text" name="sevrLsnPortName"/> </td>
						</tr>
						<tr>
							<th>ȣ��Ʈ��</th><td><input type="text" name="hostName"/> </td>
						</tr>
					</table>
				</form>
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>