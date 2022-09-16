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
var url      = '<c:url value="/bat/admin/cron/cronMan.json" />';
var url_view = '<c:url value="/bat/admin/cron/cronMan.view" />';

	var isDetail = false;
	function isValid() {

		var schedId = $('input[name=schedId]').val(); 
		if (schedId == "") {
			alert("<%= localeMessage.getString("cronDetail.checkRequired1") %>");
			$('input[name=schedId]').focus();
			return false;
		}
		
		return true;
	}

	function init(key, callback) {
		if (typeof callback === 'function') {
			callback(key);
		}
	
	}
	function detail(key) {

		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				schedId : key
			},
			success : function(json) {
				var data = json;
								
				$("input").each(function(){
					var name = $(this).attr('name');
					if (name != null)
						$(this).val(data[name.toUpperCase()]);
				});
				
				$("input[name=schedId]").attr('readonly', true);
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.schedId}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		init(key, detail);

		$("#btn_modify").click(function() {
			if (!isValid()){
				return;
			}
		
			// 공통부만 form으로 구성
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
					// LIST로 이동
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
					alert("<%= localeMessage.getString("common.deleteMsg") %>");
					// LIST로 이동
					goNav(returnUrl);

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			// LIST로 이동
			goNav(returnUrl);
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
				<div class="title"><%= localeMessage.getString("cron.title") %></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("cron.schedId") %></th>
							<td><input type="text" name="schedId"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("cron.cronExp") %></th>
							<td><input type="text" name="cronExp"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("cron.jobClassName") %></th>
							<td><input type="text" name="jobClassName"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("cron.schedDstCd") %></th>
							<td><input type="text" name="schedDstCd"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("cron.scanDirName") %></th>
							<td><input type="text" name="scanDirName"/> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("cron.timerMsg") %></th>
							<td><input type="text" name="timerMsg"/> </td>
						</tr>
					</table>
				</form>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>
