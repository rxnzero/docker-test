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

	var url = '<c:url value="/bap/transaction/procWorkMan.json" />';
	var isDetail = false;

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

		$("input[name=sndrcvStartYMD],input[name=sndrcvEndYMD],input[name=bjobDmndMsgCretnYMD],input[name=msgQueeTracTdmndYMD]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
		$("input[name=sndrcvStartHMS],input[name=sndrcvEndHMS],input[name=bjobDmndMsgCretnHMS],input[name=msgQueeTracTdmndHMS]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM:ss",outputFormat : "HHMMss"  });
		$("input[name=msgPrcssPrity]").inputmask("9999",{'autoUnmask':true});
		
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.bjobMsgScheID}";
		var key2 = "${param.bjobDmndSubMsgID}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		init(key, key2, detail);

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
	<!-- path -->
	<div class="container">
		<div class="right full">
			<p class="nav">${rmsMenuPath}</p>
		</div>
	</div>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title">
				<img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">진행작업
			</p>
		</div>
	</div>
	<!-- line -->
	<div class="container">
		<div class="left full title_line "></div>
	</div>

	<!-- button -->
	<table width="100%" height="35px">
		<tr>
			<td align="right">
			    <img id="btn_delete" src="<c:url value="/images/bt/bt_delete.gif"/>" level="W" status="DETAIL" />
			    <img id="btn_previous" src="<c:url value="/images/bt/bt_previous.gif"/>" level="R" status="DETAIL,NEW" />
			</td>
		</tr>
	</table>
	<!-- detail -->

	<form id="ajaxForm">
		<input type="hidden" name="bjobDmndMsgID" />
		<input type="hidden" name="bjobDmndSubMsgID" "/>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000">
			<tr>
				<td width="20%" class="detail_title" class="focusIn">업무구분</td>
				<td>
					<select name="bjobBzwkDstcd" value="${param.bjobBzwkDstcd}" style="width:100%"></select> 
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">대외기관구분</td>
				<td>
					<select name="osidInstiDstcd" value="${param.osidInstiDstcd}" style="width:100%"></select> 
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">작업유형구분</td>
				<td>
					<input type="text" name="bjobPtrnDstcd" value="${param.bjobPtrnDstcd}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut"> 
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">시스템연결구분코드</td>
				<td>
					<input type="text" name="sysLnkgDstcd" value="${param.sysLnkgDstcd}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut"> 
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">전문재시도수</td>
				<td>
					<input type="text" name="telgmReTralCnt" value="${param.telgmReTralCnt}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut"> 
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">작업메시지 일정ID</td>
				<td>
					<input type="text" name="bjobMsgScheID" value="${param.bjobMsgScheID}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">송수신 시작시각</td>
				<td>
					<input type="text" name="sndrcvStartYMD" maxlength=10 value="${param.sndrcvStartYMD}" size="10" style="background-color:#E6E6E6;" readOnly>
					<input type="text" name="sndrcvStartHMS" maxlength=9 value="${param.sndrcvStartHMS}" size="8" style="background-color:#E6E6E6;" readOnly>
					<input type="hidden" name="sndrcvStart" >
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">송수신 종료시각</td>
				<td>
					<input type="text" name="sndrcvEndYMD" maxlength=10 value="${param.sndrcvEndYMD}" size="10" style="background-color:#E6E6E6;" readOnly>
					<input type="text" name="sndrcvEndHMS" maxlength=9 value="${param.sndrcvEndHMS}" size="8" style="background-color:#E6E6E6;" readOnly>
					<input type="hidden" name="sndrcvEnd" >
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">송수신 파일 디렉토리명</td>
				<td>
					<input type="text" name="sndrcvFileDirName" value="${param.sndrcvFileDirName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">송수신 파일명</td>
				<td>
					<input type="text" name="sndrcvFileName" value="${param.sndrcvFileName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">백업 송수신 파일명</td>
				<td>
					<input type="text" name="bkupSndrcvFileName" value="${param.bkupSndrcvFileName}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">메시지처리 우선순위</td>
				<td>
					<input type="text" name="msgPrcssPrity" maxlength=3 value="${param.msgPrcssPrity}" size="3" style="background-color:#E6E6E6;" readOnly>
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">작업요청메시지 생성시각</td>
				<td>
					<input type="text" name="bjobDmndMsgCretnYMD" maxlength=10 value="${param.bjobDmndMsgCretnYMD}" size="10" style="background-color:#E6E6E6;" readOnly class="focusOut">
					<input type="text" name="bjobDmndMsgCretnHMS" maxlength=8 value="${param.bjobDmndMsgCretnHMS}" size="8" style="background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">메시지큐추출요청시각</td>
				<td>
					<input type="text" name="msgQueeTracTdmndYMD" maxlength=10 value="${param.msgQueeTracTdmndYMD}" size="10" style="background-color:#E6E6E6;" readOnly class="focusOut">
					<input type="text" name="msgQueeTracTdmndHMS" maxlength=8 value="${param.msgQueeTracTdmndHMS}" size="8" style="background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
			<tr>
				<td width="20%" class="detail_title">메시지처리상태코드</td>
				<td>
					<input type="text" name="msgPrcssStuscd" value="${param.msgPrcssStuscd}" style="width:100%; background-color:#E6E6E6;" readOnly class="focusOut">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>