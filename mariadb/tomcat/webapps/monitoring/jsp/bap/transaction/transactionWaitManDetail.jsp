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
<jsp:include page="/jsp/common/include/css.jsp" />
<jsp:include page="/jsp/common/include/script.jsp" />

<script language="javascript">

	var url = '<c:url value="/bap/transaction/transactionWaitMan.json" />';
	var isDetail = false;

	// �ۼ��� ����, ����ð� �Է°��� 0�϶� ""�� ��ȯ�ϴ� �Լ�.
	function zeroToStr(str){
		if(str == 0)
			return "";
		else
			return str;
	}
	
	function isValid() {
		var startYmd	= $('input[name=sndrcvStartYMD]').val();
		var startHms	= $('input[name=sndrcvStartHMS]').val();
		var startYmdHms;
		var endYmd		= $('input[name=sndrcvEndYMD]').val();
		var endHms		= $('input[name=sndrcvEndHMS]').val();
		var endYmdHms;
		
		
		if (startYmd == null) {
			alert("�ۼ��� ���� ��¥�� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvStartYMD]').focus();
			return false;
		}
		if (startHms == null) {
			alert("�ۼ��� ���� �ð��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		}
		if (endYmd == null) {
			alert("�ۼ��� ���� ��¥�� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvEndYMD]').focus();
			return false;
		}
		if (endHms == null) {
			alert("�ۼ��� ���� �ð��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		}
		startYmdHms	= startYmd + startHms;
		endYmdHms	= endYmd + endHms;
		if (startYmdHms > endYmdHms) {
			alert("�ۼ��� ����, ����ð��� Ȯ���� �ֽʽÿ�.");
			return false;
		}
		if (endHms == null) {
			alert("�ۼ��� ���� �ð��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		}
		if ($('input[name=msgPrcssPrity]').val() == null) {
			alert("�޽���ó�� �켱������ �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=msgPrcssPrity]').focus();
			return false;
		}

		return true;
	}
	
	function init(key, key2, callback) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=bjobBzwkDstcd]")).setNoValueInclude(true).setNoValue('','��ü').setData(json.bjobBzwkDstcd).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setNoValueInclude(true).setNoValue('','��ü').setData(json.osidInstiDstcd).rendering();

				if (typeof callback === 'function') {
					callback(key, key2);
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	function detail(key, key2) {
	
		if (!isDetail) return;
		
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				bjobMsgScheID : key,
				bjobDmndSubMsgID : key2
			},
			success : function(json) {
				var detail = json.detail;
				
				$("input,select").each(function(){
					var name = $(this).attr('name').toUpperCase();
					$(this).val(detail[name]);
				});
				
				$("select[name=bjobBzwkDstcd] option").not(":selected").remove();
				$("select[name=osidInstiDstcd] option").not(":selected").remove();
			},
			error : function(e) {
				alert("detail error : " + e.responseText);
			}
		});

	}
	$(document).ready(function() {
		$("input[name=sndrcvStartYMD],input[name=sndrcvEndYMD],input[name=bjobDmndMsgCretnYMD]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
		$("input[name=sndrcvStartHMS],input[name=sndrcvEndHMS],input[name=bjobDmndMsgCretnHMS]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM:ss",outputFormat : "HHMMss"  });
		$("input[name=msgPrcssPrity]").inputmask("9999",{'autoUnmask':true});
		
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.bjobMsgScheID}";
		var key2 = "${param.bjobDmndSubMsgID}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		init(key, key2, detail);

		$("#btn_modify").click(function() {
			if (!isValid())return;
			
			var sndrcvStart	= zeroToStr($("input[name=sndrcvStartYMD]").val() + $("input[name=sndrcvStartHMS]").val());
			var sndrcvEnd	= zeroToStr($("input[name=sndrcvEndYMD]").val() + $("input[name=sndrcvEndHMS]").val());
			
			$("input[name=sndrcvStart]").val(sndrcvStart);
			$("input[name=sndrcvEnd]").val(sndrcvEnd);
			
			
			//����θ� form���� ����
			var postData = $('#ajaxForm').serializeArray();
			postData.push({name : "cmd", value : "UPDATE"});
			
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_delete").click(function() {
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "cmd",
				value : "DELETE"
			});
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST�� �̵�
		});
		
		$(".focusOut").click(function(){
			document.body.focus();
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">�۾����</div>						

				<form id="ajaxForm">
					<input type="hidden" name="bjobDmndMsgID" />
					<input type="hidden" name="bjobDmndSubMsgID" "/>
					<table class="table_row" cellspacing="0">
						<!-- ����-->
						<tr>
							<th style="width:180px;">��������</th><td>
								<select name="bjobBzwkDstcd" value="${param.bjobBzwkDstcd}" style="width:100%"></select> 
								</td>
						</tr>
						<tr>
							<th>��ܱ������</th><td>
								<select name="osidInstiDstcd" value="${param.osidInstiDstcd}" style="width:100%"></select> 
							</td>
						</tr>
						<tr>
							<th>�۾���������</th>
							<td>
								<input type="text" name="bjobPtrnDstcd" value="${param.bjobPtrnDstcd}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut"> 
							</td>
						</tr>
						<tr>
							<th>������õ���</th><td>
					<input type="text" name="telgmReTralCnt" value="${param.telgmReTralCnt}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut"> 
				</td>
			</tr>
			<tr>
							<th>�۾��޽��� ����ID</th><td>
					<input type="text" name="bjobMsgScheID" value="${param.bjobMsgScheID}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>�ۼ��� ���۽ð�</th><td>
					<input type="text" name="sndrcvStartYMD" maxlength=10 value="${param.sndrcvStartYMD}" size="10">
					<input type="text" name="sndrcvStartHMS" maxlength=9 value="${param.sndrcvStartHMS}" size="8">
					<input type="hidden" name="sndrcvStart" >
				</td>
			</tr>
			<tr>
							<th>�ۼ��� ����ð�</th><td>
					<input type="text" name="sndrcvEndYMD" maxlength=10 value="${param.sndrcvEndYMD}" size="10">
					<input type="text" name="sndrcvEndHMS" maxlength=9 value="${param.sndrcvEndHMS}" size="8">
					<input type="hidden" name="sndrcvEnd" >
				</td>
			</tr>
			<tr>
							<th>�ۼ��� ���� ���丮��</th><td>
					<input type="text" name="sndrcvFileDirName" value="${param.sndrcvFileDirName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>�ۼ��� ���ϸ�</th><td>
					<input type="text" name="sndrcvFileName" value="${param.sndrcvFileName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>��� �ۼ��� ���ϸ�</th><td>
					<input type="text" name="bkupSndrcvFileName" value="${param.bkupSndrcvFileName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>�޽���ó�� �켱����</th><td>
					<input type="text" name="msgPrcssPrity" maxlength=3 value="${param.msgPrcssPrity}" size="3">
				</td>
			</tr>
			<tr>
							<th>���������</th><td>
					<input type="text" name="hdrInfoName" value="${param.hdrInfoName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>�۾���û�޽��� �����ð�</th><td>
					<input type="text" name="bjobDmndMsgCretnYMD" maxlength=10 value="${param.bjobDmndMsgCretnYMD}" size="10" style="background-color:#E6E6E6;" readOnly class="focusOut">
					<input type="text" name="bjobDmndMsgCretnHMS" maxlength=8 value="${param.bjobDmndMsgCretnHMS}" size="8" style="background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
		</table>
		</form>
		</div><!-- end content_middle -->
		</div>
	</body>
</html>