<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
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

	var url      = '<c:url value="/bat/admin/interface/interfaceFileMan.json" />';
	var url_view = '<c:url value="/bat/admin/interface/interfaceFileMan.view" />';
	var isDetail = false;

	function isValid(){
		if($("select[name=intfId]").val() == null){
			alert("인터페이스ID를 선택하여 주십시요.");
			return false;
		}
		if ($("input[name=fileNamePtrn]").val()==""){
			alert("파일명 패턴을 입력하여 주십시요.");
			$("input[name=fileNamePtrn]").focus();
			return false;
		}
		
		return true;
	}

	function init(key1, key2, callback) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL_INIT_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=intfId]")).setData(json.intfList).setAttr("WORKGRPCD","WORKGRPCD").setFormat(codeNameOptionFormat).rendering();
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=workGrpCd]")).setData(json.bizList).setNoValueInclude(true).setNoValue("","").setFormat(codeNameOptionFormat).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=transFreq]")).setData(json.transFreqList).rendering();
// 				$("select[name=workGrpCd]").searchable();
				if (typeof callback === 'function') {
					callback(key1, key2);
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}

	function detail(key1, key2) {
		
		
		if (!isDetail)
		{
			var userName = "<%=SessionManager.getUserName(request)%>";
			$("select[name=workGrpCd]").attr("disabled", true);
				
			$("input[name=reqChgr]").val(userName);
			$("input[name=resChgr]").val(userName);
			
			$("select[name=intfId]").first().change();
			return;
		}

		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				intfId : key1,
				fileNamePtrn : key2
			},
			success : function(json) {
				var detail = json.detail;
				
				$("select[name=intfId]").attr("disabled", true);
				$("select[name=workGrpCd]").attr("disabled", true);
				$("input[name=fileNamePtrn]").css("background-color", "#e5e5e5");
				$("input[name=fileNamePtrn]").attr("readOnly", true);
				
				$("input,select").each(function(){
					var name = $(this).attr('name');
					//.toUpperCase();
					if ( name != null )
						$(this).val(detail[name.toUpperCase()]);
				});
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key1 = "${param.intfId}";
		var key2 = "${param.fileNamePtrn}";

		if (key1 != "" && key1 != "null") {
			isDetail = true;
		}

		init(key1, key2, detail);

		$("#btn_modify").click(function() {
			
			if(!isValid()) return;
			
			$("select[name=intfId]").attr("disabled", false);
			var postData = $('#ajaxForm').serializeArray();

			if (isDetail) {
				postData.push({
					name : "cmd",
					value : "UPDATE"
				});
			} else {
				postData.push({
					name : "cmd",
					value : "INSERT"
				});
			}
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(json) {
					alert("저장 되었습니다.");
					goNav(returnUrl);//LIST로 이동
				},
				error : function(e) {
					var txt = JSON.parse(e.responseText).errorMsg;
					alert(txt);
				}
			});
		});
		$("#btn_delete").click(function() {
			if(!isValid()) return;
			
			$("select[name=intfId]").attr("disabled", false);
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
					var txt = JSON.parse(e.responseText).errorMsg;
					alert(txt);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST로 이동
		});
		
		$("select[name=intfId]").change(function(){
			$("select[name=workGrpCd]").val($("select[name=intfId] option:selected").attr("WORKGRPCD"));
		});
		
		$("input[name=fileNamePtrn]").click(function(){
			if($("input[name=fileNamePtrn]").attr("readOnly") == "readonly")
				$("input[name=fileNamePtrn]").blur();
		});
		
		buttonControl(key1);
		titleControl(key1);
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
					<img id="btn_delete" src="<c:url value="/img/btn_delete.png" />"level="W" status="DETAIL" />				
					<img id="btn_delete" src="<c:url value="/img/btn_delete.png" />"level="W" status="DETAIL" />
					<img id="btn_modify" src="<c:url value="/img/btn_modify.png" />"level="W" status="DETAIL,NEW" />
					<img id="btn_previous" src="<c:url value="/img/btn_previous.png" />"level="R" status="DETAIL,NEW" />
				</div>
				<div class="title">인터페이스별 파일</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:15%;">인터페이스ID</th>
							<td style="width:35%;">
								<div style="position: relative; width: 100%;">
									<div class="select-style">
										<select name="intfId"></select>
									</div><!-- end.select-style -->		
								</div>	
							</td>
							<th style="width:15%;">업무구분명</th>
							<td style="width:35%;">
								<div class="select-style">
									<select name="workGrpCd"></select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th style="width:15%;">파일명패턴</th>
							<td style="width:35%;"><input type="text" name="fileNamePtrn"></td>
							<th style="width:15%;">전송주기</th>
							<td style="width:35%;">
								<div class="select-style">
									<select name="transFreq"></select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th>1회 크기</th>
							<td><input type="text" name="sizeOnce"> </td>
							<th>처리시간구간</th>
							<td><input type="text" name="procTerm"></td>
						</tr>
						<tr>
							<th>송신담당자</th>
							<td><input type="text" name="reqChgr"> </td>
							<th>송신담당자 전화번호</th>
							<td><input type="text" name="reqChgrTlno"></td>
						</tr>
						<tr>
							<th>수신담당자</th>
							<td ><input type="text" name="resChgr"/></td>
							<th>수신담당자 전화번호</th>
							<td ><input type="text" name="resChgrTlno"/></td>
						</tr>
						<tr>
							<th style="width:15%;">사용여부</th>
							<td colspan="3">
								<div class="select-style">
									<select name="delYn">
										<option value="2">사용안함</option>
										<option value="1">사용</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
					</table>
				</form>
				<br />
				<!-- grid -->
				<form id="formDB" hidden="hidden">
					<table id="gridDB" ></table>
				</form>
				<form id="formFile" hidden="hidden">
					<table id="gridFile"></table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>