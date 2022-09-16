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
			alert("업무구분명을 선택하여 주십시요.");
			$('select[name=bjobBzwkDstcd]').focus();
			return false;
		}
		if ($('select[name=osidInstiDstcd]').val()==""){
			alert("대상기관명을 선택하여 주십시요.");
			$('select[name=osidInstiDstcd]').focus();
			return false;
		}
		if ($('select[name=bjobMsgDstcd]').val()==""){
			alert("파일명을 선택하여 주십시요.");
			$('select[name=bjobMsgDstcd]').focus();
			return false;
		}
		if ($('input[name=sndrcvStartHMS]').val()==null){
			alert("시작시간을 입력하여 주십시요.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		}
		if ($('input[name=sndrcvEndHMS]').val()==null){
			alert("종료시간을 입력하여 주십시요.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		}
		if($('input[name=sndrcvStartHMS]').val().length < 4 )
		{
			alert("시작시간을 확인하여 주십시요.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		} 
		if($('input[name=sndrcvEndHMS]').val().length < 4)
		{
			alert("종료시간을 확인하여 주십시요.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		} 
		if($('input[name=sndrcvStartHMS]').val() > $('input[name=sndrcvEndHMS]').val())
		{
			alert("시작시간과 종료시간을 확인하여 주십시요.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		} 
		
		return true;
	}
	
	// 거래처리 주기 관리 상세화면 초기화
	function init(key,callback){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL_INIT_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=bjobBzwkDstcd]")).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.bjobBzwkDstcdList).rendering();	// BATCH작업 거래구분코드
				new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.osidInstiDstcdList).setAttr("BJOBBZWKDSTCD", "BJOBBZWKDSTCD").rendering();	// BATCH작업 거래구분코드
				new makeOptions("CODE","NAME").setObj($("select[name=bjobMsgDstcd]")).setNoValueInclude(true).setData(json.bjobMsgDstcdList).setAttr("BJOBBZWKDSTCD", "BJOBBZWKDSTCD").rendering();	// BATCH작업 거래구분코드
				new makeOptions("CODE","NAME").setObj($("select[name=sendRecvYn]")).setFormat(codeName3OptionFormat).setData(json.sndRcvTypeList).rendering();			// 송수신구분
				
				if(typeof callback === 'function') {
					callback(key);
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	
	// BATCH작업메시지구분코드, 대외기관코드 콤보 조회
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
					new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setData("", "선택안함").rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=bjobMsgDstcd]")).setData("", "선택안함").rendering();
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
	
	// 거래처리 주기 관리 등록 기본설정
	function detailInit()
	{
		$(":radio[name=periodType]:radio[value=C1]").attr("checked", true);
		$(":radio[name=daily]:radio[value=D]").attr("checked", true);
		
		$(":radio[name=periodType]").change();
	}

	// 거래처리 주기 관리 상세조회
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
				
				// 거래처리 주기 설정.
				setSendRecvType(data.SNDRCVCYCLTYPNAME);
	
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	
	// 거래처리 주기 생성(등록 및 수정할 때)
	function getSendRecvType()
	{
		var selectedCase = $(":radio[name=periodType]:checked").val();
		
		var sendRecvType = '';
		
		if(selectedCase == 'C1') {			// 일반복
			sendRecvType = $(":radio[name=daily]:checked").val();
		}
		else if(selectedCase == 'C2') {		// 월반복
			sendRecvType = $("select[name=monthly]").val();
			sendRecvType = sendRecvType + $("select[name=monthDaily]").val();
			sendRecvType = sendRecvType + $(":radio[name=monthlyHYDaily]:checked").val();
		}
		else if(selectedCase == 'C3') {		// 월 영업일 반복
			sendRecvType = $("select[name=monthlyY]").val();
			sendRecvType = sendRecvType + $("select[name=monthlyYDaily]").val();
		}
		else if(selectedCase == 'C4') {		// 주반복
			sendRecvType = $("select[name=weekYDay]").val();
		}
		else if(selectedCase == 'C5') {		// 매주 영업일 반복
			sendRecvType = $("select[name=weekYDaily]").val();
		}
		else if(selectedCase == 'C6') {		// 주 요일 반복
			sendRecvType = $("select[name=week]").val();
			sendRecvType = sendRecvType + $("select[name=day]").val();
		}
		else if(selectedCase == 'C7') {		// 주 영업일 반복
			sendRecvType = $("select[name=weekY]").val();
			sendRecvType = sendRecvType + $("select[name=dailyY]").val();
		}
		
		return $.trim(sendRecvType);
	}
	
	// 거래처리 주기 설정(상세조회)
	function setSendRecvType(sendRecvType)
	{
		var selectedCase = 'C1';
		
		if(
			sendRecvType == 'D' ||
			sendRecvType == 'Y' ||
			sendRecvType == 'Y+' ||
			sendRecvType == 'S'
		) {
			// 일반복
			$(":radio[name=daily]:radio[value='" + sendRecvType + "']").attr("checked", true);
			selectedCase = 'C1';
		}
		else if(sendRecvType.length >= 4 &&
			       !isNaN(sendRecvType.substring(0,1))
		) {
			// 월반복
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
			// 월 영업일 반복
			sendRecvType.length == 5 &&
			sendRecvType.charAt(0) == 'Y'
		) {
			$("select[name=monthlyY]").val(sendRecvType.substring(0,3));
			$("select[name=monthlyYDaily]").val(sendRecvType.substring(3,5));
			selectedCase = 'C3';
		}
		else if(
			// 주반복
			sendRecvType.length == 2 &&
			sendRecvType.charAt(0) == 'D'
		) {
			$("select[name=weekYDay]").val(sendRecvType);
			selectedCase = 'C4';
		}
		else if(
			// 매주 영업일 반복
			sendRecvType.length >= 3 &&
			sendRecvType.substring(0,2) == 'DY'
		) {
			$("select[name=weekYDaily]").val(sendRecvType);
			selectedCase = 'C5';
		}
		else if(
			// 주 요일 반복
			sendRecvType.length == 4 &&
			sendRecvType.charAt(0) == 'W' &&
			sendRecvType.charAt(2) == 'D'
		) {
			$("select[name=week]").val(sendRecvType.substring(0,2));
			$("select[name=day]").val(sendRecvType.substring(2,4));
			selectedCase = 'C6';
		}
		else if(
			// 주 영업일 반복
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
	
		// BATCH작업거래구분코드 이벤트
		$("select[name=bjobBzwkDstcd]").change(function(){
			// Batch작업메시지 구분코드
			osidFileCombo();
		});
		
		// 주기구분 선택 이벤트
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
	
		// 등록 및 수정 이벤트
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
					alert("저장 되었습니다.");
					goNav(returnUrl);//LIST로 이동
				},
				error:function(e){
					var txt = JSON.parse(e.responseText).errorMsg;
					alert(txt);
				}
			});
		});
		
		// 삭제 이벤트
		$("#btn_delete").click(function(){
			var postData = $('#ajaxForm').serializeArray();
			postData.push({ name: "cmd" , value:"DELETE"});
			postData.push({ name: "bjobMsgScheID" , value:key});
			
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
	
		// 이전화면 이벤트
		$("#btn_previous").click(function(){
			goNav(returnUrl);//LIST로 이동
		});

		// 버튼 및 TITLE 제어(공통함수)
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
				<div class="title">거래처리 주기<span class="tooltip">일괄전송 파일의 거래처리 주기를 관리하는 화면입니다</span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr style="display:none"><td><input name="bjobMsgScheID" ></td></tr>
						<tr>
							<th style="width:180px;">업무구분명 *</th>
							<td><div class="select-style"><select name="bjobBzwkDstcd"></select></div></td>
							<th style="width:160px;">대상기관명 *</th>
							<td><div class="select-style"><select name="osidInstiDstcd"></select></div></td>
						</tr>
						<tr>
							<th>파일명 *</th>
							<td><div class="select-style"><select name="bjobMsgDstcd"></select></div></td>
							<th>송수신구분 *</th>
							<td><div class="select-style"><select name="sendRecvYn"></select></div></td>
						</tr>
					</table>
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:180px;"><input type="radio" name="periodType" value="C1" id="sub4_8_3_detail_1"><label for="sub4_8_3_detail_1">일반복</label></th>
							<td class="sndrcvCyclTyp1">
								<input type="radio" name="daily" value="D" id="sub4_8_3_detail_2"><label for="sub4_8_3_detail_2">매일처리(D)</label>
								<input type="radio" name="daily" value="Y" id="sub4_8_3_detail_3"><label for="sub4_8_3_detail_3">매 영업일 처리(Y)</label>
								<input type="radio" name="daily" value="Y+" id="sub4_8_3_detail_4"><label for="sub4_8_3_detail_4">매 영업 익일 처리(Y+)</label>
								<input type="radio" name="daily" value="S" id="sub4_8_3_detail_5"><label for="sub4_8_3_detail_5">매 영업일/토요일 처리(S)</label>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C2" id="sub4_8_3_detail_6"><label for="sub4_8_3_detail_6">월반복</label></th>
							<td>
								<div class="sndrcvCyclTyp2 select-style" style="display:inline-block; width:30%;">
									<select name="monthly">
										<option value="00">매월</option>
										<option value="01">1월</option>
										<option value="02">2월</option>
										<option value="03">3월</option>
										<option value="04">4월</option>
										<option value="05">5월</option>
										<option value="06">6월</option>
										<option value="07">7월</option>
										<option value="08">8월</option>
										<option value="09">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select>
								</div>
								<div class="sndrcvCyclTyp2 select-style" style="display:inline-block; width:30%;">
									<select name="monthDaily">
										<option value="01">1일</option>
										<option value="02">2일</option>
										<option value="03">3일</option>
										<option value="04">4일</option>
										<option value="05">5일</option>
										<option value="06">6일</option>
										<option value="07">7일</option>
										<option value="08">8일</option>
										<option value="09">9일</option>
										<option value="10">10일</option>
										<option value="11">11일</option>
										<option value="12">12일</option>
										<option value="13">13일</option>
										<option value="14">14일</option>
										<option value="15">15일</option>
										<option value="16">16일</option>
										<option value="17">17일</option>
										<option value="18">18일</option>
										<option value="19">19일</option>
										<option value="20">20일</option>
										<option value="21">21일</option>
										<option value="22">22일</option>
										<option value="23">23일</option>
										<option value="24">24일</option>
										<option value="25">25일</option>
										<option value="26">26일</option>
										<option value="27">27일</option>
										<option value="28">28일</option>
										<option value="29">29일</option>
										<option value="30">30일</option>
										<option value="31">31일</option>
										<option value="-1">말일</option>
									</select>
								</div>
								<div class="monthlyDay sndrcvCyclTyp2" style="display:inline-block; width:30%;">
									<input type="radio" name="monthlyHYDaily" value="" id="sub4_8_3_detail_7"><label for="sub4_8_3_detail_7">휴일포함</label>
									<input type="radio" name="monthlyHYDaily" value="-" id="sub4_8_3_detail_8"><label for="sub4_8_3_detail_8">전영업일(-)</label>
									<input type="radio" name="monthlyHYDaily" value="+" id="sub4_8_3_detail_9"><label for="sub4_8_3_detail_9">후영업일(+)</label>
								</div>
							</td>	
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C3" id="sub4_8_3_detail_10"><label for="sub4_8_3_detail_10">월 영업일 반복</label></th>
							<td>
								<div class="sndrcvCyclTyp3 select-style" style="display:inline-block; width:30%;">
									<select name="monthlyY">
										<option value="Y00">매월</option>
										<option value="Y01">1월</option>
										<option value="Y02">2월</option>
										<option value="Y03">3월</option>
										<option value="Y04">4월</option>
										<option value="Y05">5월</option>
										<option value="Y06">6월</option>
										<option value="Y07">7월</option>
										<option value="Y08">8월</option>
										<option value="Y09">9월</option>
										<option value="Y10">10월</option>
										<option value="Y11">11월</option>
										<option value="Y12">12월</option>
									</select>
								</div>							
								<div class="sndrcvCyclTyp3 select-style" style="display:inline-block; width:30%;">
									<select name="monthlyYDaily">
										<option value="01">1영업일</option>
										<option value="02">2영업일</option>
										<option value="03">3영업일</option>
										<option value="04">4영업일</option>
										<option value="05">5영업일</option>
										<option value="06">6영업일</option>
										<option value="07">7영업일</option>
										<option value="08">8영업일</option>
										<option value="09">9영업일</option>
										<option value="10">10영업일</option>
										<option value="11">11영업일</option>
										<option value="12">12영업일</option>
										<option value="13">13영업일</option>
										<option value="14">14영업일</option>
										<option value="15">15영업일</option>
										<option value="16">16영업일</option>
										<option value="17">17영업일</option>
										<option value="18">18영업일</option>
										<option value="19">19영업일</option>
										<option value="20">20영업일</option>
										<option value="21">21영업일</option>
										<option value="22">22영업일</option>
										<option value="23">23영업일</option>
										<option value="24">24영업일</option>
										<option value="25">25영업일</option>
										<option value="26">26영업일</option>
										<option value="-1">마지막 영업일</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C4" id="sub4_8_3_detail_11"><label for="sub4_8_3_detail_11">주반복</label></th>
							<td>
								<div class="sndrcvCyclTyp4 select-style" style="display:inline-block; width:30%;">
									<select name="weekYDay">
										<option value="D0">매일요일</option>
										<option value="D1">매월요일</option>
										<option value="D2">매화요일</option>
										<option value="D3">매수요일</option>
										<option value="D4">매목요일</option>
										<option value="D5">매금요일</option>
										<option value="D6">매토요일</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C5" id="sub4_8_3_detail_12"><label for="sub4_8_3_detail_12">매주 영업일 반복</label></th>
							<td>
								<div class="sndrcvCyclTyp5 select-style" style="display:inline-block; width:30%;">
									<select name="weekYDaily">
										<option value="DY1">매주 첫 영업일</option>
										<option value="DY2">매주 2영업일</option>
										<option value="DY3">매주 3영업일</option>
										<option value="DY4">매주 4영업일</option>
										<option value="DY-1">매주 마지막 영업일</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C6" id="sub4_8_3_detail_13"><label for="sub4_8_3_detail_13">주 요일 반복</label></th>
							<td>
								<div class="sndrcvCyclTyp6 select-style" style="display:inline-block; width:30%;">
									<select name="week">
										<option value="W1">1주</option>
										<option value="W2">2주</option>
										<option value="W3">3주</option>
										<option value="W4">4주</option>
										<option value="W5">5주</option>
									</select>
								</div>
								<div class="sndrcvCyclTyp6 select-style" style="display:inline-block; width:30%;">
									<select name="day">
										<option value="D0">일요일</option>
										<option value="D1">월요일</option>
										<option value="D2">화요일</option>
										<option value="D3">수요일</option>
										<option value="D4">목요일</option>
										<option value="D5">금요일</option>
										<option value="D6">토요일</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th><input type="radio" name="periodType" value="C7" id="sub4_8_3_detail_14"><label for="sub4_8_3_detail_14">주 영업일 반복</label></th>
							<td>
								<div class="sndrcvCyclTyp7 select-style" style="display:inline-block; width:30%;">
									<select name="weekY">
										<option value="W1">1주</option>
										<option value="W2">2주</option>
										<option value="W3">3주</option>
										<option value="W4">4주</option>
										<option value="W5">5주</option>
									</select>
								</div>
								<div class="sndrcvCyclTyp7 select-style" style="display:inline-block; width:30%;">
									<select name="dailyY">
										<option value="Y1">1영업일</option>
										<option value="Y2">2영업일</option>
										<option value="Y3">3영업일</option>
										<option value="Y4">4영업일</option>
										<option value="Y-1">끝영업일</option>
									</select>
								</div>
							</td>
						</tr>						
					</table>
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:180px;">시작시간</th><td><input type="text"  name="sndrcvStartHMS" maxlength=5 size="5"/></td>
							<th style="width:180px;">종료시간</th><td><input type="text"  name="sndrcvEndHMS" maxlength=5 size="5"/></td>
							<th style="width:180px;">알람여부</th>
							<td>
								<div class="select-style"><select name="warnYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div>
							</td>
							<th style="width:180px;">사용여부</th>
							<td>
								<div class="select-style"><select name="thisMsgUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div>
							</td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>