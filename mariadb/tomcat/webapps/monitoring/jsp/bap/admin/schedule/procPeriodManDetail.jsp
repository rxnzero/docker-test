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
<script language="javascript" src="<c:url value="/js/jquery.mask.min.js"/>"></script>

<script language="javascript" >

	var url ='<c:url value="/bap/admin/schedule/procPeriodMan.json" />';
	var isDetail = false;
	
	function isValid(){
		if ($('select[name=bjobBzwkDstcd]').val()==""){
			alert("�������и��� �����Ͽ� �ֽʽÿ�.");
			$('select[name=bjobBzwkDstcd]').focus();
			return false;
		}
		if ($('select[name=osidInstiDstcd]').val()==""){
			alert("��������� �����Ͽ� �ֽʽÿ�.");
			$('select[name=osidInstiDstcd]').focus();
			return false;
		}
		if ($('select[name=bjobMsgDstcd]').val()==""){
			alert("���ϸ��� �����Ͽ� �ֽʽÿ�.");
			$('select[name=bjobMsgDstcd]').focus();
			return false;
		}
		if ($('input[name=sndrcvStartHMS]').val()==null){
			alert("���۽ð��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		}
		if ($('input[name=sndrcvEndHMS]').val()==null){
			alert("����ð��� �Է��Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		}
		if($('input[name=sndrcvStartHMS]').val().length < 4 )
		{
			alert("���۽ð��� Ȯ���Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		} 
		if($('input[name=sndrcvEndHMS]').val().length < 4)
		{
			alert("����ð��� Ȯ���Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		} 
		if($('input[name=sndrcvStartHMS]').val() > $('input[name=sndrcvEndHMS]').val())
		{
			alert("���۽ð��� ����ð��� Ȯ���Ͽ� �ֽʽÿ�.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		} 
		
		return true;
	}
	
	// �ŷ�ó�� �ֱ� ���� ��ȭ�� �ʱ�ȭ
	function init(key,callback){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL_INIT_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=bjobBzwkDstcd]")).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.bjobBzwkDstcdList).rendering();	// BATCH�۾� �ŷ������ڵ�
				new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.osidInstiDstcdList).setAttr("BJOBBZWKDSTCD", "BJOBBZWKDSTCD").rendering();	// BATCH�۾� �ŷ������ڵ�
				new makeOptions("CODE","NAME").setObj($("select[name=bjobMsgDstcd]")).setNoValueInclude(true).setData(json.bjobMsgDstcdList).setAttr("BJOBBZWKDSTCD", "BJOBBZWKDSTCD").rendering();	// BATCH�۾� �ŷ������ڵ�
				new makeOptions("CODE","NAME").setObj($("select[name=sendRecvYn]")).setFormat(codeName3OptionFormat).setData(json.sndRcvTypeList).rendering();			// �ۼ��ű���
				
				if(typeof callback === 'function') {
					callback(key);
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	
	// BATCH�۾��޽��������ڵ�, ��ܱ���ڵ� �޺� ��ȸ
	function osidFileCombo()
	{
		var strBjobBzwkDstcd	= $("select[name=bjobBzwkDstcd]").val();
		
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL_OSID_FILE_COMBO', bjobBzwkDstcd : strBjobBzwkDstcd},
			success:function(json){
				$("select[name=bjobMsgDstcd],select[name=osidInstiDstcd]").empty();
				
				if(strBjobBzwkDstcd == "" || strBjobBzwkDstcd == null || strBjobBzwkDstcd == undefined)
				{
					new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setData("", "���þ���").rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=bjobMsgDstcd]")).setData("", "���þ���").rendering();
				}
				else{
					new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setNoValueInclude(true).setFormat(codeName3OptionFormat).setData(json.osidInstiDstcd).rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=bjobMsgDstcd]")).setNoValueInclude(true).setData(json.bjobMsgDstcd).rendering();
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	
	// �ŷ�ó�� �ֱ� ���� ��� �⺻����
	function detailInit()
	{
		$(":radio[name=periodType]:radio[value=C1]").attr("checked", true);
		$(":radio[name=daily]:radio[value=D]").attr("checked", true);
		
		$(":radio[name=periodType]").change();
	}

	// �ŷ�ó�� �ֱ� ���� ����ȸ
	function detail(key){
		if (!isDetail){
			osidFileCombo();
			detailInit();
			return;
		}
		
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL', bJobMsgScheId : key},
			success:function(json){
				var data = json;

				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				
				$("select[name=bjobBzwkDstcd] option, select[name=osidInstiDstcd] option, select[name=bjobMsgDstcd] option, select[name=sendRecvYn] option").not(":selected").remove();
				
				// �ŷ�ó�� �ֱ� ����.
				setSendRecvType(data.SNDRCVCYCLTYPNAME);
	
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	
	// �ŷ�ó�� �ֱ� ����(��� �� ������ ��)
	function getSendRecvType()
	{
		var selectedCase = $(":radio[name=periodType]:checked").val();
		
		var sendRecvType = '';
		
		if(selectedCase == 'C1') {			// �Ϲݺ�
			sendRecvType = $(":radio[name=daily]:checked").val();
		}
		else if(selectedCase == 'C2') {		// ���ݺ�
			sendRecvType = $("select[name=monthly]").val();
			sendRecvType = sendRecvType + $("select[name=monthDaily]").val();
			sendRecvType = sendRecvType + $(":radio[name=monthlyHYDaily]:checked").val();
		}
		else if(selectedCase == 'C3') {		// �� ������ �ݺ�
			sendRecvType = $("select[name=monthlyY]").val();
			sendRecvType = sendRecvType + $("select[name=monthlyYDaily]").val();
		}
		else if(selectedCase == 'C4') {		// �ֹݺ�
			sendRecvType = $("select[name=weekYDay]").val();
		}
		else if(selectedCase == 'C5') {		// ���� ������ �ݺ�
			sendRecvType = $("select[name=weekYDaily]").val();
		}
		else if(selectedCase == 'C6') {		// �� ���� �ݺ�
			sendRecvType = $("select[name=week]").val();
			sendRecvType = sendRecvType + $("select[name=day]").val();
		}
		else if(selectedCase == 'C7') {		// �� ������ �ݺ�
			sendRecvType = $("select[name=weekY]").val();
			sendRecvType = sendRecvType + $("select[name=dailyY]").val();
		}
		
		return $.trim(sendRecvType);
	}
	
	// �ŷ�ó�� �ֱ� ����(����ȸ)
	function setSendRecvType(sendRecvType)
	{
		var selectedCase = 'C1';
		
		if(
			sendRecvType == 'D' ||
			sendRecvType == 'Y' ||
			sendRecvType == 'Y+' ||
			sendRecvType == 'S'
		) {
			// �Ϲݺ�
			$(":radio[name=daily]:radio[value='" + sendRecvType + "']").attr("checked", true);
			selectedCase = 'C1';
		}
		else if(sendRecvType.length >= 4 &&
			       !isNaN(sendRecvType.substring(0,1))
		) {
			// ���ݺ�
			var rdoVal = "";
			$("select[name=monthly]").val(sendRecvType.substring(0,2));
			$("select[name=monthDaily]").val(sendRecvType.substring(2,4));
			if(sendRecvType.length == 5) {
				rdoVal = sendRecvType.substring(4,5);
			}
			
			$(":radio[name=monthlyHYDaily]:radio[value='" + rdoVal + "']").attr("checked", true);
			
			selectedCase = 'C2';
		}
		else if(
			// �� ������ �ݺ�
			sendRecvType.length == 5 &&
			sendRecvType.charAt(0) == 'Y'
		) {
			$("select[name=monthlyY]").val(sendRecvType.substring(0,3));
			$("select[name=monthlyYDaily]").val(sendRecvType.substring(3,5));
			selectedCase = 'C3';
		}
		else if(
			// �ֹݺ�
			sendRecvType.length == 2 &&
			sendRecvType.charAt(0) == 'D'
		) {
			$("select[name=weekYDay]").val(sendRecvType);
			selectedCase = 'C4';
		}
		else if(
			// ���� ������ �ݺ�
			sendRecvType.length >= 3 &&
			sendRecvType.substring(0,2) == 'DY'
		) {
			$("select[name=weekYDaily]").val(sendRecvType);
			selectedCase = 'C5';
		}
		else if(
			// �� ���� �ݺ�
			sendRecvType.length == 4 &&
			sendRecvType.charAt(0) == 'W' &&
			sendRecvType.charAt(2) == 'D'
		) {
			$("select[name=week]").val(sendRecvType.substring(0,2));
			$("select[name=day]").val(sendRecvType.substring(2,4));
			selectedCase = 'C6';
		}
		else if(
			// �� ������ �ݺ�
			sendRecvType.length >= 4 &&
			sendRecvType.charAt(0) == 'W' &&
			sendRecvType.charAt(2) == 'Y'
		) {
			$("select[name=weekY]").val(sendRecvType.substring(0,2));
			$("select[name=dailyY]").val(sendRecvType.substring(2,sendRecvType.length));
			selectedCase = 'C7';
		}
		
		$(":radio[name=periodType]:radio[value=" + selectedCase + "]").attr("checked", true);
		$(":radio[name=periodType]").change();
	}

	$(document).ready(function() {
		$("input[name=sndrcvStartHMS],input[name=sndrcvEndHMS]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM",outputFormat : "HHMMss" });
		
		var returnUrl = getReturnUrlForReturn();
		
		var key ="${param.bJobMsgScheId}";
		if (key != "" && key !="null"){
		    isDetail = true;
		}
		init(key, detail);
	
		// BATCH�۾��ŷ������ڵ� �̺�Ʈ
		$("select[name=bjobBzwkDstcd]").change(function(){
			// Batch�۾��޽��� �����ڵ�
			osidFileCombo();
		});
		
		// �ֱⱸ�� ���� �̺�Ʈ
		$(":radio[name=periodType]").change(function(){
			var radioSize	= $(":radio[name=periodType]").size();
			var rdoVal		= $(":radio[name=periodType]:checked").val();
			var rdoIdx		= rdoVal.substring(1);
			
			for(var i = 0; i < radioSize; i++)
			{
				if(i+1 == rdoIdx)
				{
					$(".sndrcvCyclTyp"+(i+1)).attr("disabled", false);
					continue;
				}
				else
				{
					$(".sndrcvCyclTyp"+(i+1)).attr("disabled", true);
				}
			}
			
		});
	
		// ��� �� ���� �̺�Ʈ
		$("#btn_modify").click(function(){
			if(!isValid()) return;
			
			var postData = $('#ajaxForm').serializeArray();
			if (isDetail){
				postData.push({ name: "cmd" , value:"UPDATE"});
			}else{
				postData.push({ name: "cmd" , value:"INSERT"});
			}
			
			postData.push({ name: "sndrcvCyclTypName" , value:getSendRecvType()});
			
			$.ajax({
				type : "POST",
				url:url,
				data:postData,
				success:function(args){
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
				},
				error:function(e){
					var txt = JSON.parse(e.responseText).errorMsg;
					alert(txt);
				}
			});
		});
		
		// ���� �̺�Ʈ
		$("#btn_delete").click(function(){
			var postData = $('#ajaxForm').serializeArray();
			postData.push({ name: "cmd" , value:"DELETE"});
			postData.push({ name: "bjobMsgScheID" , value:key});
			
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
	
		// ����ȭ�� �̺�Ʈ
		$("#btn_previous").click(function(){
			goNav(returnUrl);//LIST�� �̵�
		});

		// ��ư �� TITLE ����(�����Լ�)
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
				<div class="title">�ŷ�ó�� �ֱ�<span class="tooltip">�ϰ����� ������ �ŷ�ó�� �ֱ⸦ �����ϴ� ȭ���Դϴ�</span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr style="display:none"><td><input name="bjobMsgScheID" ></td></tr>
						<tr>
							<th style="width:180px;">�������и� *</th>
							<td><div class="select-style"><select name="bjobBzwkDstcd"></select></div></td>
							<th style="width:160px;">������� *</th>
							<td><div class="select-style"><select name="osidInstiDstcd"></select></div></td>
						</tr>
						<tr>
							<th>���ϸ� *</th>
							<td><div class="select-style"><select name="bjobMsgDstcd"></select></div></td>
							<th>�ۼ��ű��� *</th>
							<td><div class="select-style"><select name="sendRecvYn"></select></div></td>
						</tr>
					</table>
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:180px;"><input type="radio" name="periodType" value="C1" id="sub4_8_3_detail_1"><label for="sub4_8_3_detail_1">�Ϲݺ�</label></th>
							<td class="sndrcvCyclTyp1">
								<input type="radio" name="daily" value="D" id="sub4_8_3_detail_2"><label for="sub4_8_3_detail_2">����ó��(D)</label>
								<input type="radio" name="daily" value="Y" id="sub4_8_3_detail_3"><label for="sub4_8_3_detail_3">�� ������ ó��(Y)</label>
								<input type="radio" name="daily" value="Y+" id="sub4_8_3_detail_4"><label for="sub4_8_3_detail_4">�� ���� ���� ó��(Y+)</label>
								<input type="radio" name="daily" value="S" id="sub4_8_3_detail_5"><label for="sub4_8_3_detail_5">�� ������/����� ó��(S)</label>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C2" id="sub4_8_3_detail_6"><label for="sub4_8_3_detail_6">���ݺ�</label></th>
							<td>
								<div class="sndrcvCyclTyp2 select-style" style="display:inline-block; width:30%;">
									<select name="monthly">
										<option value="00">�ſ�</option>
										<option value="01">1��</option>
										<option value="02">2��</option>
										<option value="03">3��</option>
										<option value="04">4��</option>
										<option value="05">5��</option>
										<option value="06">6��</option>
										<option value="07">7��</option>
										<option value="08">8��</option>
										<option value="09">9��</option>
										<option value="10">10��</option>
										<option value="11">11��</option>
										<option value="12">12��</option>
									</select>
								</div>
								<div class="sndrcvCyclTyp2 select-style" style="display:inline-block; width:30%;">
									<select name="monthDaily">
										<option value="01">1��</option>
										<option value="02">2��</option>
										<option value="03">3��</option>
										<option value="04">4��</option>
										<option value="05">5��</option>
										<option value="06">6��</option>
										<option value="07">7��</option>
										<option value="08">8��</option>
										<option value="09">9��</option>
										<option value="10">10��</option>
										<option value="11">11��</option>
										<option value="12">12��</option>
										<option value="13">13��</option>
										<option value="14">14��</option>
										<option value="15">15��</option>
										<option value="16">16��</option>
										<option value="17">17��</option>
										<option value="18">18��</option>
										<option value="19">19��</option>
										<option value="20">20��</option>
										<option value="21">21��</option>
										<option value="22">22��</option>
										<option value="23">23��</option>
										<option value="24">24��</option>
										<option value="25">25��</option>
										<option value="26">26��</option>
										<option value="27">27��</option>
										<option value="28">28��</option>
										<option value="29">29��</option>
										<option value="30">30��</option>
										<option value="31">31��</option>
										<option value="-1">����</option>
									</select>
								</div>
								<div class="monthlyDay sndrcvCyclTyp2" style="display:inline-block; width:30%;">
									<input type="radio" name="monthlyHYDaily" value="" id="sub4_8_3_detail_7"><label for="sub4_8_3_detail_7">��������</label>
									<input type="radio" name="monthlyHYDaily" value="-" id="sub4_8_3_detail_8"><label for="sub4_8_3_detail_8">��������(-)</label>
									<input type="radio" name="monthlyHYDaily" value="+" id="sub4_8_3_detail_9"><label for="sub4_8_3_detail_9">�Ŀ�����(+)</label>
								</div>
							</td>	
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C3" id="sub4_8_3_detail_10"><label for="sub4_8_3_detail_10">�� ������ �ݺ�</label></th>
							<td>
								<div class="sndrcvCyclTyp3 select-style" style="display:inline-block; width:30%;">
									<select name="monthlyY">
										<option value="Y00">�ſ�</option>
										<option value="Y01">1��</option>
										<option value="Y02">2��</option>
										<option value="Y03">3��</option>
										<option value="Y04">4��</option>
										<option value="Y05">5��</option>
										<option value="Y06">6��</option>
										<option value="Y07">7��</option>
										<option value="Y08">8��</option>
										<option value="Y09">9��</option>
										<option value="Y10">10��</option>
										<option value="Y11">11��</option>
										<option value="Y12">12��</option>
									</select>
								</div>							
								<div class="sndrcvCyclTyp3 select-style" style="display:inline-block; width:30%;">
									<select name="monthlyYDaily">
										<option value="01">1������</option>
										<option value="02">2������</option>
										<option value="03">3������</option>
										<option value="04">4������</option>
										<option value="05">5������</option>
										<option value="06">6������</option>
										<option value="07">7������</option>
										<option value="08">8������</option>
										<option value="09">9������</option>
										<option value="10">10������</option>
										<option value="11">11������</option>
										<option value="12">12������</option>
										<option value="13">13������</option>
										<option value="14">14������</option>
										<option value="15">15������</option>
										<option value="16">16������</option>
										<option value="17">17������</option>
										<option value="18">18������</option>
										<option value="19">19������</option>
										<option value="20">20������</option>
										<option value="21">21������</option>
										<option value="22">22������</option>
										<option value="23">23������</option>
										<option value="24">24������</option>
										<option value="25">25������</option>
										<option value="26">26������</option>
										<option value="-1">������ ������</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C4" id="sub4_8_3_detail_11"><label for="sub4_8_3_detail_11">�ֹݺ�</label></th>
							<td>
								<div class="sndrcvCyclTyp4 select-style" style="display:inline-block; width:30%;">
									<select name="weekYDay">
										<option value="D0">���Ͽ���</option>
										<option value="D1">�ſ�����</option>
										<option value="D2">��ȭ����</option>
										<option value="D3">�ż�����</option>
										<option value="D4">�Ÿ����</option>
										<option value="D5">�űݿ���</option>
										<option value="D6">�������</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C5" id="sub4_8_3_detail_12"><label for="sub4_8_3_detail_12">���� ������ �ݺ�</label></th>
							<td>
								<div class="sndrcvCyclTyp5 select-style" style="display:inline-block; width:30%;">
									<select name="weekYDaily">
										<option value="DY1">���� ù ������</option>
										<option value="DY2">���� 2������</option>
										<option value="DY3">���� 3������</option>
										<option value="DY4">���� 4������</option>
										<option value="DY-1">���� ������ ������</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C6" id="sub4_8_3_detail_13"><label for="sub4_8_3_detail_13">�� ���� �ݺ�</label></th>
							<td>
								<div class="sndrcvCyclTyp6 select-style" style="display:inline-block; width:30%;">
									<select name="week">
										<option value="W1">1��</option>
										<option value="W2">2��</option>
										<option value="W3">3��</option>
										<option value="W4">4��</option>
										<option value="W5">5��</option>
									</select>
								</div>
								<div class="sndrcvCyclTyp6 select-style" style="display:inline-block; width:30%;">
									<select name="day">
										<option value="D0">�Ͽ���</option>
										<option value="D1">������</option>
										<option value="D2">ȭ����</option>
										<option value="D3">������</option>
										<option value="D4">�����</option>
										<option value="D5">�ݿ���</option>
										<option value="D6">�����</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C7" id="sub4_8_3_detail_14"><label for="sub4_8_3_detail_14">�� ������ �ݺ�</label></th>
							<td>
								<div class="sndrcvCyclTyp7 select-style" style="display:inline-block; width:30%;">
									<select name="weekY">
										<option value="W1">1��</option>
										<option value="W2">2��</option>
										<option value="W3">3��</option>
										<option value="W4">4��</option>
										<option value="W5">5��</option>
									</select>
								</div>
								<div class="sndrcvCyclTyp7 select-style" style="display:inline-block; width:30%;">
									<select name="dailyY">
										<option value="Y1">1������</option>
										<option value="Y2">2������</option>
										<option value="Y3">3������</option>
										<option value="Y4">4������</option>
										<option value="Y-1">��������</option>
									</select>
								</div>
							</td>
						</tr>						
					</table>
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:180px;">���۽ð�</th><td><input type="text"  name="sndrcvStartHMS" maxlength=5 size="5"/></td>
							<th style="width:180px;">����ð�</th><td><input type="text"  name="sndrcvEndHMS" maxlength=5 size="5"/></td>
							<th style="width:180px;">�˶�����</th>
							<td>
								<div class="select-style"><select name="warnYn">
									<option value="1">���</option>
									<option value="0">������</option>
								</select></div>
							</td>
							<th style="width:180px;">��뿩��</th>
							<td>
								<div class="select-style"><select name="thisMsgUseYn">
									<option value="1">���</option>
									<option value="0">������</option>
								</select></div>
							</td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>