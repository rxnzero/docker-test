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
var url      = '<c:url value="/onl/admin/common/routingMan.json" />';
var url_view = '<c:url value="/onl/admin/common/routingMan.view" />';

	var isDetail = false;
	function isValid() {

		var routName = $('input[name=routName]'); 
		if ( routName.val() == "") {
			alert("<%= localeMessage.getString("routingDetail.checkRequired1") %>");
			routName.focus();
			return false;
		}
		
		var motivRoutUriName = $('input[name=motivRoutUriName]');
		if ( motivRoutUriName.val() == "") {
			alert("<%= localeMessage.getString("routingDetail.checkRequired2") %>");
			motivRoutUriName.focus();
			return false;
		}
		var nonMotivRoutUriName = $('input[name=nonMotivRoutUriName]');
		if ( nonMotivRoutUriName.val() == "") {
			nonMotivRoutUriName.val(" ");
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
				routName : key
			},
			success : function(json) {
				var data = json;
				$("input[name=routName]").attr('readonly', true);
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				
				$("#ajaxForm input[type=radio]:first").each(function(){
					var name = $(this).attr("name");
					$("input[type=radio][name="+name+"][value="+data[name.toUpperCase()]+"]").prop("checked",true);
				});

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.routName}";

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
				<div class="title"><%= localeMessage.getString("routingDetail.title") %></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("routingDetail.name") %></th>
							<td><input type="text" name="routName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("routingDetail.syncUri") %></th>
							<td><input type="text" name="motivRoutUriName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("routingDetail.asynUri") %></th>
							<td><input type="text" name="nonMotivRoutUriName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("routingDetail.layerCode") %></th>
							<td>
								<input type="radio" name="layerDstcd" value="F" id="routingManDetail_1"/><label for="routingManDetail_1">F</label>
								<input type="radio" name="layerDstcd" value="O" id="routingManDetail_2" checked/><label for="routingManDetail_2">O</label>
								<input type="radio" name="layerDstcd" value="T" id="routingManDetail_3"/><label for="routingManDetail_3">T</label>
							</td>
						</tr>

					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>