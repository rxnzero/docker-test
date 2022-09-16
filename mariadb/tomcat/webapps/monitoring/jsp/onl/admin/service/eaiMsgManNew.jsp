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
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=flovrSevrName]")).setData(json.serverRows).rendering();
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
		data:{cmd: 'DETAIL', msg : key},
		success:function(json){
			var data = json;
			$("input[name=msg]").attr('readonly',true);
			$("input[name=msg]").val(data['MSG']);
			$("input[name=msgCtnt]").val(data['MSGCTNT']);
			$("textarea[name=treatMatrCtnt]").val(data['TREATMATRCTNT']);

		},
		error:function(e){
			alert(e.responseText);
		}
	});

}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	
	var url ='<c:url value="/onl/admin/server/eaiMsgMan.json" />';
	var key ="${param.eaiSvcName}";
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
	<!-- path -->
	<div class="container">
		<div class="right full">
			<p class="nav">${rmsMenuPath}</p>
		</div>
	</div>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">IF�޽���</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	
	<!-- button -->
	<table width="100%" height="35px" >
	<tr>
		<td align="right">
			<img id="btn_modify" src="<c:url value="/images/bt/bt_modify.gif"/>" level="W" status="DETAIL,NEW"/>
			<img id="btn_previous" src="<c:url value="/images/bt/bt_previous.gif"/>" level="R" status="DETAIL,NEW"/>
		</td>
	</tr>
	</table>	
	<!-- detail -->
	<form id="ajaxForm">
	<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
		<tr>
			<td width="150px" class="detail_title">IF���� �ڵ�</td><td><input type="text" name="eaiSvcName" style="width:100%"/> </td>
			<td width="150px" class="detail_title">�������� �ڵ�</td><td><select name="eaiBzwkDstcd" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title">����� �ð�����</td><td><select name="svcHmsEonot" style="width:100%"/> </td>
			<td class="detail_title">�������̽� �������</td><td><select name="svcMotivUseDstcd" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title">���� ó������</td><td><select name="svcPrcesDsticName" style="width:100%"/> </td>
			<td class="detail_title">Flow Control ����ø�</td><td><select name="flowCtrlRoutName" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title">�ŷ�����</td><td><select name="intgraDsticName" style="width:100%"/> </td>
			<td class="detail_title">���� �α� ��뿩��</td><td><select name="svcBfClmnLogYn" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title">�⵿ �������̽� ����</td><td><select name="gstatSysAdptrBzwkGroupName" style="width:100%"/> </td>
			<td class="detail_title">���� �α� ����</td><td><select name="sevrLogLvelNo" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title">���� �α� ����</td><td><select name="svcLogLvelNo" style="width:100%"/> </td>
			<td class="detail_title">����IF���񽺸�</td><td><input type="text" name="errEAISvcName" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title">��û������ȯID��</td><td><input type="text" name="dmndErrChngIdName" style="width:100%"/> </td>
			<td class="detail_title">��û�����ʵ��</td><td><input type="text" name="dmndErrFldName" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title">���������ȯID��</td><td><input type="text" name="rspnsErrChngIdName" style="width:100%"/> </td>
			<td class="detail_title">���信���ʵ��</td><td><input type="text" name="rspnsErrFldName" style="width:100%"/> </td>
		</tr>
		<tr>
			<td class="detail_title" height="50px">IF���� ����</td><td colspan="3"><textarea name="eaiSvcDesc" style="width:100%;height:50px"></textarea> </td>
		</tr>


	</table>
	</form>
	
	</body>
</html>

