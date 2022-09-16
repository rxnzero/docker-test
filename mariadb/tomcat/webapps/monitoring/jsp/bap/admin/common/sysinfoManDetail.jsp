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

	var url      = '<c:url value="/bap/admin/common/sysinfoMan.json" />';
	var url_view = '<c:url value="/bap/admin/common/sysinfoMan.view" />';
	var isDetail = false;

	function detail(key) {

		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				sysCd : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				debugger;
// 				$("select[name=workGrpCd]").attr("disabled",true);
// 				$("select[name=sndRcvKind]").attr("disabled",true);
// 				$("select[name=adptrKind]").attr("disabled",true);
// 				$("select[name=workGrpCd]").css({'background-color' : '#e5e5e5'});
// 				$("select[name=sndRcvKind]").css({'background-color' : '#e5e5e5'});
// 				$("select[name=adptrKind]").css({'background-color' : '#e5e5e5'});
				$("input,select,textarea").each(function(){
					var name = $(this).attr('name');
					//.toUpperCase();
					if ( name != null )
						$(this).val(json[name.toUpperCase()]);
				});
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var key = "${param.sysCd}";
		var returnUrl = '${param.returnUrl}';
		
		returnUrl = returnUrl + '?cmd='+'LIST';
		returnUrl = returnUrl + '&page='+'${param.pages}';
		returnUrl = returnUrl + '&menuId='+'${param.menuId}';
		//검색조건
		returnUrl = returnUrl + '&'+ getSearchUrlForReturn();

		if (key != "" && key != "null") {
			isDetail = true;
		}

		detail(key);

		$("#btn_modify").click(function() {
			//공통부만 form으로 구성
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
					goNav(returnUrl);
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
					goNav(returnUrl);
					

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);
		});
		$("select[name=sftpYn]").change(function(){
		
			if ( $("select[name=sftpYn]").val() == '0' ){
				$("input[name=sysPort]").val('21');
			}else{
				$("input[name=sysPort]").val('22');
			}
		
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">내부 연계 시스템</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr><th style="width:180px;">시스템 코드</th><td><input type="text" name="sysCd"></td></tr>
						<tr><th style="width:180px;">시스템 명칭</th><td><input type="text" name="sysName"></td></tr>
						<tr><th style="width:180px;">시스템 IP</th><td><input type="text" name="sysIp"></td></tr>
						<tr><th style="width:180px;">시스템 Port</th><td><input type="text" name="sysPort"></td></tr>
						<tr><th style="width:180px;">USER ID</th><td><input type="text" name="userId"></td></tr>
						<tr><th style="width:180px;">비밀번호</th><td><input type="password" name="userPassword"></td></tr>
						<tr><th style="width:180px;">송신디렉토리</th><td><input type="text" name="sendDir"></td></tr>
						<tr><th style="width:180px;">수신디렉토리</th><td><input type="text" name="recvDir"></td></tr>
						<tr><th>SFTP여부</th>
							<td><div class="select-style"><select name="sftpYn">
									<option value="1">SFTP</option>
									<option value="0">FTP</option>
								</select></div></td>
						</tr>
						<tr><th>사용여부</th>
							<td><div class="select-style"><select name="thisMsgUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div></td>
						</tr>

					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>