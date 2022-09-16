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
			alert("큐수신자명을 입력하여 주십시요.");
			$('input[name=queRcverName]').focus();
			return false;
		}
		if ($('select[name=sevrInstncName]').val()=="" || isNull($('select[name=sevrInstncName]').val())){
			alert("EAI서버인스턴스명을 선택하여 주십시요.");
			$('input[name=sevrInstncName]').focus();
			return false;
		}
		if ($('select[name=nonSynczTranQueName]').val()=="" || isNull($('select[name=nonSynczTranQueName]').val())){
			alert("비동기거래큐명을 선택하여 주십시요.");
			$('input[name=nonSynczTranQueName]').focus();
			return false;
		}
/* 		if ($('select[name=nonSynczTranObstclQueName]').val()=="" || isNull($('select[name=nonSynczTranObstclQueName]').val())){
			//alert("비동기거래장애큐명을 선택하여 주십시요.");
			//$('input[name=nonSynczTranObstclQueName]').focus();
			$('select[name=nonSynczTranObstclQueName]').val(" ");
			//return false;
		} */
		if ($('input[name=sendDlayTtmVal]').val()==""){
			alert("송신지연시간값을 입력하여 주십시요.");
			$('input[name=sendDlayTtmVal]').focus();
			return false;
		}
		if ($('input[name=sendReTralNotms]').val()==""){
			alert("송신재시도횟수를 입력하여 주십시요.");
			$('input[name=sendReTralNotms]').focus();
			return false;
		}
		if ($('input[name=queRcverCnt]').val()==""){
			alert("큐수신자수를 입력하여 주십시요.");
			$('input[name=queRcverCnt]').focus();
			return false;
		}
		if ($('select[name=bascQueRcverYn]').val()=="" || isNull($('select[name=bascQueRcverYn]').val())){
			alert("기본큐수신자여부를 선택하여 주십시요.");
			$('input[name=bascQueRcverYn]').focus();
			return false;
		}
		/*
		if ($('input[name=queRcverDtalsCtnt]').val()==""){
			alert("큐수신자세부내용 입력하여 주십시요.");
			$('input[name=queRcverDtalsCtnt]').focus();
			return false;
		}
		if ($('input[name=queMsgSelctCtnt]').val()==""){
			alert("큐메시지선택내용 입력하여 주십시요.");
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
				<div class="title">비동기 큐 수신자 정보</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">큐수신자명 *</th>
							<td>
								<input type="text"  name="queRcverName"/>
							</td>
						</tr>
						<tr>
							<th>EAI서버인스턴스명 *</th>
							<td>
								<div class="select-style"><select name="sevrInstncName"></select></div>
							</td>
						</tr>
						<tr>
							<th>비동기거래큐명 *</th>
							<td>
								<div class="select-style"><select name="nonSynczTranQueName"></select></div>
							</td>
						</tr>
						<tr>
							<th>비동기거래장애큐명 *</th>
							<td>
								<div class="select-style"><select name="nonSynczTranObstclQueName"></select></div>
							</td>
						</tr>
						<tr>
							<th>송신지연시간값 *</th>
							<td>
								<input type="text"  name="sendDlayTtmVal" style="width:13%; text-align:right" maxLength = 10 onkeydown="return onlyNumber(event)" onkeyup="return removeChar(event)"/>&nbsp;<strong>ms</strong>
							</td>
						</tr>
						<tr>
							<th>송신재시도횟수 *</th>
							<td>
								<input type="text"  name="sendReTralNotms" style="width:13%; text-align:right" maxLength = 10 onkeydown="return onlyNumber(event)" onkeyup="return removeChar(event)"/>
							</td>
						</tr>
						<tr>
							<th>큐수신자수 *</th>
							<td>
								<input type="text"  name="queRcverCnt" style="width:13%; text-align:right" maxLength = 10 onkeydown="return onlyNumber(event)" onkeyup="return removeChar(event)"/>
							</td>
						</tr>
						<tr>
							<th>기본큐수신자여부 *</th>
							<td><div class="select-style"><select name="bascQueRcverYn" /></div></td>
						</tr>
						<tr>
							<th>큐수신자세부내용</th>
							<td>
								<input type="text"  name="queRcverDtalsCtnt"/>
							</td>
						</tr>
						<tr>
							<th>큐메시지선택내용</th>
							<td>
								<input type="text"  name="queMsgSelctCtnt"/>
							</td>
						</tr>
					</table>				
					<div style="font-weight:bold;">
						큐메시지선택내용은 특수한 경우에 사용합니다.<br>
						허용되는 키는 EAIBWKCLS, EAISVCCD, OSIDINSTCD<br>
						표현방식은 키 = '키에대한값'<br>
						<span style="color:red;">정확하게 입력하지 않을 경우 수신자가 기동되지 않습니다.</span>
					</div>							
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

