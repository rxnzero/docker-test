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
var url      ='<c:url value="/onl/admin/common/comDomainMan.json" />';
var url_view ='<c:url value="/onl/admin/common/comDomainMan.view" />';

	var selectName = "EAIBZWKDSTCD"; // selectBox Name

	var isDetail = false;
	function isValid() {
		
		return true;
	}

	function detail(key) {
		if (!isDetail)
			return;
		$("input[name=domainNM]").attr('readonly', true);
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				domainNM : key
			},
			success : function(json) {
				var detail = json.detail;

				//adapterGroup
				

				$("#ajaxForm input,#ajaxForm select,#ajaxForm textarea").each(function() {
					var name = $(this).attr('name').toUpperCase();
					$(this).val(detail[name]);
				});
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}

	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();

		var key = "${param.domainNM}";
		if (key != "" && key != "null") {
			isDetail = true;
		}
		detail(key);

		$("#btn_modify").click(function() {
			if (!isValid())
				return;

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
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
			
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
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
			}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST로 이동
		});
		
		$("select[name=domainType]").change(function() {
			var val = $(this).val();
			if(val == "INPUT"){
				$("select[name=domainOption]").val("MASKING");
			}else if($("select[name=domainOption]").val() == "MASKING"){
				alert("<%= localeMessage.getString("domain.checkMsg1") %>"); // MASKING은 도메인타입이 INPUT일때만 가능합니다.
				$("select[name=domainOption]").val("NONE");
			}
		});
		$("select[name=domainOption]").change(function() {
			var val = $(this).val();
			if(val == "MASKING" && $("select[name=domainType]").val() != "INPUT"){
				alert("<%= localeMessage.getString("domain.checkMsg1") %>");  //MASKING은 도메인타입이 INPUT일때만 가능합니다.

				$("select[name=domainOption]").val("NONE");
			}else if($("select[name=domainType]").val() == "INPUT" && val != "MASKING"){
				alert("<%= localeMessage.getString("domain.checkMsg2") %>");  // INPUT은 도메인옵션 중 MASKING만 가능합니다.
				$("select[name=domainOption]").val("NONE");
			}
		});
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
				<div class="title"><%= localeMessage.getString("domain.title") %><span class="tooltip"></span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("domain.name") %></th>
							<td><input type="text" name="domainNM" /></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("domain.type") %></th>
							<td>
								<div class="select-style">
									<select name="domainType">
									<option value="INPUT">INPUT</option>
									<option value="SELECT">SELECT</option>
									<option value="RADIO">RADIO</option>
									<option value="CHECK">CHECK</option>	
									</select>									
								</div>	
							</td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("domain.option") %></th>
							<td>
								<div class="select-style">
									<select name="domainOption">
									<option value="NONE">NONE</option>	
									<option value="CODE">CODE</option>
									<option value="SQL">SQL</option>
									<option value="MASKING">MASKING</option>									
									</select>
								</div>	
							</td>
						</tr>
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("domain.reference") %></th>
							<td><textarea type="text" name="domainVal"></textarea> </td>
						</tr>
					</table>
				</form>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

