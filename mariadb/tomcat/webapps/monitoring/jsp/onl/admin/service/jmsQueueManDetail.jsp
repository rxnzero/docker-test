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
var url      = '<c:url value="/onl/admin/service/jmsQueueMan.json" />';
var url_view = '<c:url value="/onl/admin/service/jmsQueueMan.view" />';

var selectName = "bzwkDstcd";	// selectBox Name

var isDetail = false;
function init(key,callback){
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=sevrInstncName]")).setData(json.instanceRows).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=bzwkDstcd]")).setFormat(codeName3OptionFormat).setData(json.bizRows).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=queUseYn]")).setFormat(codeName3OptionFormat).setData(json.useYnRows).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=queUsagDstcd]")).setFormat(codeName3OptionFormat).setData(json.sendReceiveStsRows).rendering();
			
			if(key == "") setSearchable(selectName);	// �޺��� searchable ����
			
			if (typeof callback === 'function') {
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
		data:{cmd: 'DETAIL', nonSynczTranQueName : key},
		success:function(json){
			var data = json;
			
			$("input[name=nonSynczTranQueName]").attr('readonly',true);
			
			$("#ajaxForm input,#ajaxForm textarea,#ajaxForm select").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			});
			
			setSearchable(selectName);	// �޺��� searchable ����
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
	function isValid(){
		if ($('input[name=nonSynczTranQueName]').val()==""){
			alert("ť���� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=nonSynczTranQueName]').focus();
			return false;
		}
		if ($('select[name=sevrInstncName]').val()=="" || isNull($('select[name=sevrInstncName]').val())){
			alert("EAI�����ν��Ͻ����� �����Ͽ� �ֽʽÿ�.");
			$('input[name=sevrInstncName]').focus();
			return false;
		}
		if ($('input[name=queBzwkCtnt]').val()==""){
			alert("�������� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=queBzwkCtnt]').focus();
			return false;
		}
		if ($('select[name=queUseYn]').val()=="" || isNull($('select[name=queUseYn]').val())){
			alert("��뿩�θ� �����Ͽ� �ֽʽÿ�.");
			$('input[name=queUseYn]').focus();
			return false;
		}
		if ($('select[name=queUsagDstcd]').val()=="" || isNull($('select[name=queUsagDstcd]').val())){
			alert("�뵵�� �����Ͽ� �ֽʽÿ�.");
			$('input[name=queUsagDstcd]').focus();
			return false;
		}
		if ($('select[name=bzwkDstcd]').val()=="" || isNull($('select[name=bzwkDstcd]').val())){
			alert("���������ڵ带 �����Ͽ� �ֽʽÿ�.");
			$('input[name=bzwkDstcd]').focus();
			return false;
		}
		if ($('input[name=queBzwkDtalsCtnt]').val()==""){
			alert("ť�������γ����� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=queBzwkDtalsCtnt]').focus();
			return false;
		}
		
		return true;
	}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key ="${param.nonSynczTranQueName}";

	if (key != "" && key !="null"){
		isDetail = true;
	}
	else
	{
		$('input[name=nonSynczTranQueName]').focus();
	}
	
	init(key,detail);
	
	
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
				<div class="title">�񵿱� ť ����</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">ť��</th>
							<td>
								<input type="text"  name="nonSynczTranQueName"/>
							</td>
						</tr>
						<tr>
							<th>EAI�����ν��Ͻ���</th>
							<td>
								<div class="select-style"><select name="sevrInstncName"></select></div>
							</td>
						</tr>
						<tr>
							<th>������</th>
							<td>
								<input type="text" name="queBzwkCtnt" />
							</td>
						</tr>
						<tr>
							<th>��뿩��</th>
							<td>
								<div class="select-style"><select name="queUseYn"></select></div>
							</td>
						</tr>
						<tr>
							<th>�뵵</th>
							<td>
								<div class="select-style"><select name="queUsagDstcd"></select></div>
							</td>
						</tr>
						<tr>
							<th>���������ڵ�</th>
							<td>
								<div class="select-style"><select name="bzwkDstcd"></select></div>
							</td>
						</tr>
						<tr>
							<th>ť�������γ���</th>
							<td>
								<input type="text"  name="queBzwkDtalsCtnt"/>
							</td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

