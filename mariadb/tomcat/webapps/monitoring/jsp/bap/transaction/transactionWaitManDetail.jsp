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

	// 송수신 시작, 종료시간 입력값이 0일때 ""로 변환하는 함수.
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
			alert("송수신 시작 날짜를 입력하여 주십시요.");
			$('input[name=sndrcvStartYMD]').focus();
			return false;
		}
		if (startHms == null) {
			alert("송수신 시작 시간을 입력하여 주십시요.");
			$('input[name=sndrcvStartHMS]').focus();
			return false;
		}
		if (endYmd == null) {
			alert("송수신 종료 날짜를 입력하여 주십시요.");
			$('input[name=sndrcvEndYMD]').focus();
			return false;
		}
		if (endHms == null) {
			alert("송수신 종료 시간을 입력하여 주십시요.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		}
		startYmdHms	= startYmd + startHms;
		endYmdHms	= endYmd + endHms;
		if (startYmdHms > endYmdHms) {
			alert("송수신 시작, 종료시각을 확인해 주십시요.");
			return false;
		}
		if (endHms == null) {
			alert("송수신 종료 시간을 입력하여 주십시요.");
			$('input[name=sndrcvEndHMS]').focus();
			return false;
		}
		if ($('input[name=msgPrcssPrity]').val() == null) {
			alert("메시지처리 우선순위를 입력하여 주십시요.");
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
				new makeOptions("CODE","NAME").setObj($("select[name=bjobBzwkDstcd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.bjobBzwkDstcd).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.osidInstiDstcd).rendering();

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
			
			
			//공통부만 form으로 구성
			var postData = $('#ajaxForm').serializeArray();
			postData.push({name : "cmd", value : "UPDATE"});
			
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("저장 되었습니다.");
					goNav(returnUrl);//LIST로 이동
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
					alert("삭제 되었습니다.");
					goNav(returnUrl);//LIST로 이동
				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST로 이동
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
				<div class="title">작업대기</div>						

				<form id="ajaxForm">
					<input type="hidden" name="bjobDmndMsgID" />
					<input type="hidden" name="bjobDmndSubMsgID" "/>
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:180px;">업무구분</th><td>
								<select name="bjobBzwkDstcd" value="${param.bjobBzwkDstcd}" style="width:100%"></select> 
								</td>
						</tr>
						<tr>
							<th>대외기관구분</th><td>
								<select name="osidInstiDstcd" value="${param.osidInstiDstcd}" style="width:100%"></select> 
							</td>
						</tr>
						<tr>
							<th>작업유형구분</th>
							<td>
								<input type="text" name="bjobPtrnDstcd" value="${param.bjobPtrnDstcd}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut"> 
							</td>
						</tr>
						<tr>
							<th>전문재시도수</th><td>
					<input type="text" name="telgmReTralCnt" value="${param.telgmReTralCnt}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut"> 
				</td>
			</tr>
			<tr>
							<th>작업메시지 일정ID</th><td>
					<input type="text" name="bjobMsgScheID" value="${param.bjobMsgScheID}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>송수신 시작시각</th><td>
					<input type="text" name="sndrcvStartYMD" maxlength=10 value="${param.sndrcvStartYMD}" size="10">
					<input type="text" name="sndrcvStartHMS" maxlength=9 value="${param.sndrcvStartHMS}" size="8">
					<input type="hidden" name="sndrcvStart" >
				</td>
			</tr>
			<tr>
							<th>송수신 종료시각</th><td>
					<input type="text" name="sndrcvEndYMD" maxlength=10 value="${param.sndrcvEndYMD}" size="10">
					<input type="text" name="sndrcvEndHMS" maxlength=9 value="${param.sndrcvEndHMS}" size="8">
					<input type="hidden" name="sndrcvEnd" >
				</td>
			</tr>
			<tr>
							<th>송수신 파일 디렉토리명</th><td>
					<input type="text" name="sndrcvFileDirName" value="${param.sndrcvFileDirName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>송수신 파일명</th><td>
					<input type="text" name="sndrcvFileName" value="${param.sndrcvFileName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>백업 송수신 파일명</th><td>
					<input type="text" name="bkupSndrcvFileName" value="${param.bkupSndrcvFileName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>메시지처리 우선순위</th><td>
					<input type="text" name="msgPrcssPrity" maxlength=3 value="${param.msgPrcssPrity}" size="3">
				</td>
			</tr>
			<tr>
							<th>헤더정보명</th><td>
					<input type="text" name="hdrInfoName" value="${param.hdrInfoName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
							<th>작업요청메시지 생성시각</th><td>
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