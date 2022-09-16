<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
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
var url      = '<c:url value="/onl/admin/common/unifbwkMan.json" />';
var url_view = '<c:url value="/onl/admin/common/unifbwkMan.view" />';

	var isDetail = false;
	function isValid() {

		var eaiBzwkDstcd = $('input[name=eaiBzwkDstcd]').val(); 
		if ( eaiBzwkDstcd == "") {
			alert("<%= localeMessage.getString("unifbwkDetail.checkRequired1") %>");
			$('input[name=eaiBzwkDstcd]').focus();
			return false;
		}
		
		var bzwkDsticName = $('input[name=bzwkDsticName]').val();
		if ( bzwkDsticName == "") {
			alert("<%= localeMessage.getString("unifbwkDetail.checkRequired1") %>");
			$('input[name=bzwkDsticName]').focus();
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
				eaiBzwkDstcd : key
			},
			success : function(json) {
				var data = json;
				$("input[name=eaiBzwkDstcd]").attr('readonly', true);
				
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
		var key = "${param.eaiBzwkDstcd}";

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
					alert("<%= localeMessage.getString("common.saveMsg") %>");
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
					alert("<%= localeMessage.getString("common.deleteMsg") %>");
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
				<div class="title"><%= localeMessage.getString("unifbwkDetail.title") %></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("unifbwk.bizCode") %></th>
							<td><input type="text" name="eaiBzwkDstcd" /></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("unifbwk.bizName") %></th>
							<td><input type="text" name="bzwkDsticName" /></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("unifbwk.trackAsisKey1") %></th>
							<td><input type="text" name="trackAsisKey1Name" /></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("unifbwk.trackAsisKey2") %></th>
							<td><input type="text" name="trackAsisKey2Name" /></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("unifbwk.description") %></th>
							<td><input type="text" name="bzwkDsticDesc" /></td>
						</tr>
					</table>
				</form>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>