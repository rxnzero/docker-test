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
var url      = '<c:url value="/onl/admin/common/sysDomainMan.json" />';
var url_view = '<c:url value="/onl/admin/common/sysDomainMan.view" />';

	var isDetail = false;
	function isValid() {

		var sysDomnName = $('input[name=sysDomnName]').val(); 
		if ( sysDomnName == "") {
			alert("시스템 도메인명을 입력하여 주십시요.");
			$('input[name=sysDomnName]').focus();
			return false;
		}
		
		var sysDomnDesc = $('input[name=sysDomnDesc]').val();
		if ( sysDomnDesc == "") {
			alert("시스템 도메인 설명을  입력하여 주십시요.");
			$('input[name=sysDomnDesc]').focus();
			return false;
		}

		return true;
	}

	function init( key, callback) {
		if (typeof callback === 'function') {
			callback( key);
		}
	
	}
	function detail( key) {

		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				sysDomnName : key
			},
			success : function(json) {
				var data = json;
				$("input[name=sysDomnName]").attr('readonly', true);
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.sysDomnName}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		init(key, detail);

		$("#btn_modify").click(function() {
			if (!isValid()){
				return;
			}
		
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
		$("#btn_cancel").click(function() {
			goNav(returnUrl);//LIST로 이동
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
				<img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">연동 시스템
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
			    <img id="btn_modify" src="<c:url value="/images/bt/bt_modify.gif"/>" level="W" status="DETAIL,NEW" />
			    <img id="btn_cancel" src="<c:url value="/images/bt/bt_cancel.gif"/>" level="R" status="DETAIL,NEW" />
			</td>
		</tr>
	</table>
	<!-- detail -->

	<form id="ajaxForm">
		<table class="table_detail" width="100%" border="1" cellpadding="1"
			cellspacing="0" bordercolor="#000000">
			<tr>
				<td width="150px" class="detail_title">시스템 도메인명</td>
				<td><input type="text" name="sysDomnName" style="width: 100%" /></td>
			</tr>
			<tr>
				<td class="detail_title">시스템 도메인 설명</td>
				<td><input type="text" name="sysDomnDesc" style="width: 100%" /></td>
			</tr>
		</table>
	</form>
	<br />
</body>
</html>