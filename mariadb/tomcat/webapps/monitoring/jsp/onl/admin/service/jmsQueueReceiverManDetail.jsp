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

<style>
	.table_desc
	{
		font-size: 12px;
		margin-top: 3px;
		padding-left: 10px;
		line-height: 180%;
	}
</style>

<script language="javascript" >
var url      = '<c:url value="/onl/admin/service/jmsQueueReceiverMan.json" />';
var url_view = '<c:url value="/onl/admin/service/jmsQueueReceiverMan.view" />';

var isDetail = false;

function onlyNumber(event)
{
	event = event || window.event;
	
	var keyCode = (event.which) ? event.which : event.keyCode;
	
	if( (keyCode >= 48 && keyCode <= 57) || (keyCode >= 96 && keyCode <= 105) 
	  	|| keyCode == 8 || keyCode == 46 || keyCode == 37 || keyCode == 39
	  	|| keyCode == 16 || keyCode == 36)
	{
		return;
	}
	else
	{
		return false;
	}
}

function removeChar(event)
{
	event = event || window.event;
	
	var keyCode = (event.which) ? event.which : event.keyCode;
	
	if( keyCode == 8 || keyCode == 46 || keyCode == 37 || keyCode == 39)
	{
		return;
	}
	else
	{
		event.target.value = event.target.value.replace(/[^0-9]/g, '');
	}
}

function setNonSynczTranQue(data)
{
	new makeOptions("CODE","NAME").setObj($("select[name=nonSynczTranQueName]")).setData(data.listQueRows).rendering();
	new makeOptions("CODE","NAME").setObj($("select[name=nonSynczTranObstclQueName]")).setData(data.listErrQueRows).setNoValueInclude(true).rendering();
}

function init(key,callback){
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=sevrInstncName]")).setData(json.instanceRows).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=bascQueRcverYn]")).setData(json.bascQueRcverYnRows).setFormat(codeName3OptionFormat).rendering();
			
			setNonSynczTranQue(json);
			//$("select[name=sevrInstncName]").change();
			
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
		data:{cmd: 'DETAIL', queRcverName : key},
		success:function(json){
			var data = json.detail;
			
			$("input[name=queRcverName]").attr('readonly',true);
			
			//setNonSynczTranQue(json);
			$("select[name=sevrInstncName]").val(data["SEVRINSTNCNAME"]);
			$("select[name=sevrInstncName]").change();
			
			
			$("#ajaxForm input,#ajaxForm textarea,#ajaxForm select").each(function(){
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
	
		if ($('input[name=queRcverName]').val()==""){
			alert("ť�����ڸ��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=queRcverName]').focus();
			return false;
		}
		if ($('select[name=sevrInstncName]').val()=="" || isNull($('select[name=sevrInstncName]').val())){
			alert("EAI�����ν��Ͻ����� �����Ͽ� �ֽʽÿ�.");
			$('input[name=sevrInstncName]').focus();
			return false;
		}
		if ($('select[name=nonSynczTranQueName]').val()=="" || isNull($('select[name=nonSynczTranQueName]').val())){
			alert("�񵿱�ŷ�ť���� �����Ͽ� �ֽʽÿ�.");
			$('input[name=nonSynczTranQueName]').focus();
			return false;
		}
/* 		if ($('select[name=nonSynczTranObstclQueName]').val()=="" || isNull($('select[name=nonSynczTranObstclQueName]').val())){
			//alert("�񵿱�ŷ����ť���� �����Ͽ� �ֽʽÿ�.");
			//$('input[name=nonSynczTranObstclQueName]').focus();
			$('select[name=nonSynczTranObstclQueName]').val(" ");
			//return false;
		} */
		if ($('input[name=sendDlayTtmVal]').val()==""){
			alert("�۽������ð����� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sendDlayTtmVal]').focus();
			return false;
		}
		if ($('input[name=sendReTralNotms]').val()==""){
			alert("�۽���õ�Ƚ���� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sendReTralNotms]').focus();
			return false;
		}
		if ($('input[name=queRcverCnt]').val()==""){
			alert("ť�����ڼ��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=queRcverCnt]').focus();
			return false;
		}
		if ($('select[name=bascQueRcverYn]').val()=="" || isNull($('select[name=bascQueRcverYn]').val())){
			alert("�⺻ť�����ڿ��θ� �����Ͽ� �ֽʽÿ�.");
			$('input[name=bascQueRcverYn]').focus();
			return false;
		}
		/*
		if ($('input[name=queRcverDtalsCtnt]').val()==""){
			alert("ť�����ڼ��γ��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=queRcverDtalsCtnt]').focus();
			return false;
		}
		if ($('input[name=queMsgSelctCtnt]').val()==""){
			alert("ť�޽������ó��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=queMsgSelctCtnt]').focus();
			return false;
		}
		*/
		
		return true;
	}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key ="${param.queRcverName}";

	if (key != "" && key !="null"){
		isDetail = true;
	}
	else
	{
		$("input[name=queRcverName]").focus();
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
	
	$("select[name=sevrInstncName]").change(function(){
					$("select[name=nonSynczTranQueName] option").remove();
					$("select[name=nonSynczTranObstclQueName] option").remove();
					var postData = [];
					postData.push({name:"cmd",value:"LIST_QUE_COMBO"});
					postData.push({name:"instance",value:$("select[name=sevrInstncName]").val()});
					$.ajax({
						type : "POST",
						url:url,
						dataType:"json",
						async:false,
						data:postData,
						success:function(json){
							setNonSynczTranQue(json);
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">�񵿱� ť ������ ����</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">ť�����ڸ� *</th>
							<td>
								<input type="text"  name="queRcverName"/>
							</td>
						</tr>
						<tr>
							<th>EAI�����ν��Ͻ��� *</th>
							<td>
								<div class="select-style"><select name="sevrInstncName"></select></div>
							</td>
						</tr>
						<tr>
							<th>�񵿱�ŷ�ť�� *</th>
							<td>
								<div class="select-style"><select name="nonSynczTranQueName"></select></div>
							</td>
						</tr>
						<tr>
							<th>�񵿱�ŷ����ť�� *</th>
							<td>
								<div class="select-style"><select name="nonSynczTranObstclQueName"></select></div>
							</td>
						</tr>
						<tr>
							<th>�۽������ð��� *</th>
							<td>
								<input type="text"  name="sendDlayTtmVal" style="width:13%; text-align:right" maxLength = 10 onkeydown="return onlyNumber(event)" onkeyup="return removeChar(event)"/>&nbsp;<strong>ms</strong>
							</td>
						</tr>
						<tr>
							<th>�۽���õ�Ƚ�� *</th>
							<td>
								<input type="text"  name="sendReTralNotms" style="width:13%; text-align:right" maxLength = 10 onkeydown="return onlyNumber(event)" onkeyup="return removeChar(event)"/>
							</td>
						</tr>
						<tr>
							<th>ť�����ڼ� *</th>
							<td>
								<input type="text"  name="queRcverCnt" style="width:13%; text-align:right" maxLength = 10 onkeydown="return onlyNumber(event)" onkeyup="return removeChar(event)"/>
							</td>
						</tr>
						<tr>
							<th>�⺻ť�����ڿ��� *</th>
							<td><div class="select-style"><select name="bascQueRcverYn" /></div></td>
						</tr>
						<tr>
							<th>ť�����ڼ��γ���</th>
							<td>
								<input type="text"  name="queRcverDtalsCtnt"/>
							</td>
						</tr>
						<tr>
							<th>ť�޽������ó���</th>
							<td>
								<input type="text"  name="queMsgSelctCtnt"/>
							</td>
						</tr>
					</table>				
					<div style="font-weight:bold;">
						ť�޽������ó����� Ư���� ��쿡 ����մϴ�.<br>
						���Ǵ� Ű�� EAIBWKCLS, EAISVCCD, OSIDINSTCD<br>
						ǥ������� Ű = 'Ű�����Ѱ�'<br>
						<span style="color:red;">��Ȯ�ϰ� �Է����� ���� ��� �����ڰ� �⵿���� �ʽ��ϴ�.</span>
					</div>							
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

