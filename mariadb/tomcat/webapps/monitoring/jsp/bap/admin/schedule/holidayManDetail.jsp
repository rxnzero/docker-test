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

function isValid(){
	if($('input[name=holdyYmd]').val() == ""){
		alert("���� ���ڸ� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('input[name=evntSchdrHoldyCtnt]').val() == ""){
		alert("���� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}
	
	return true;
}

function detail( holdyYmd, holdyDstcd, evntSchdrHoldyCtnt){
	if (!isDetail)return;
	$("input[name=holdyYmd]").val(holdyYmd);
	$("select[name=holdyDstcd]").val(holdyDstcd);
	$("input[name=evntSchdrHoldyCtnt]").val(evntSchdrHoldyCtnt);
	$("input[name=holdyYmd]").attr('readonly',true);
	$("select[name=holdyDstcd]").attr('disabled',true);
}

$(document).ready(function() {
	var returnUrl = getReturnUrlForReturn();
	var url = '<c:url value="/bap/admin/schedule/holidayMan.json" />';
	var holdyYmd ="${param.holdyYmd}";
	var holdyDstcd ="${param.holdyDstcd}";
	var evntSchdrHoldyCtnt ="${param.evntSchdrHoldyCtnt}";
	debugger;
	if (holdyYmd != "" && holdyYmd !="null"){
		isDetail = true;
	}	
	
	detail(holdyYmd,holdyDstcd,evntSchdrHoldyCtnt);
	

	$("#btn_modify").click(function(){

		if (!isValid())return;
	
		//����θ� form���� ����
		var postData = $('#ajaxForm').serializeArray();
        		
		if (isDetail){
			postData.push({ name: "cmd" , value:"UPDATE"});
		}else{
			postData.push({ name: "cmd" , value:"INSERT"});
		}
		postData.push({ name: "holdyDstcd" , value:$("select[name=holdyDstcd]").val()});
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
		postData.push({ name: "holdyDstcd" , value:$("select[name=holdyDstcd]").val()});
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
				<div class="title">����</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- ����-->
						<tr>
							<th>��������</th><td><input type="text" maxlength="8" name="holdyYmd" /> </td>
						</tr>
						<tr>
							<th style="width:180px;">��������</th>
							<td><div class="select-style"><select name="holdyDstcd">
									<option value="1">������</option>
									<option value="2">�ӽð�����</option>
									<option value="3">��������</option>
								</select></div>
							</td>
						</tr>
						<tr>
							<th>����</th><td><input type="text" maxlength="40" name="evntSchdrHoldyCtnt" /> </td>
						</tr>
					</table>
				</form>

				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

