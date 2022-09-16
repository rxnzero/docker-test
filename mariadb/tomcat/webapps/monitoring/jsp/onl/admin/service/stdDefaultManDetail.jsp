<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
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

<script language="javascript" >
	var url      = '<c:url value="/onl/admin/service/stdDefaultMan.json" />';
	var url_view = '<c:url value="/onl/admin/service/stdDefaultMan.view" />';
	var isDetail = false;
	
	function init(key,callback){
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_DETAIL_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=isKey]")).setNoValueInclude(true).setData(json.ynList).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=isInterface]")).setNoValueInclude(true).setData(json.ynList).rendering();
				
				if (typeof callback === 'function') {
					callback(key);
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	function detail(key){
		if (!isDetail){
			$('input[name=columnName]').focus();
			return;
		}
		
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL', columnName : key},
			success:function(json){
				var data = json;

				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();

					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				
				$("input[name=columnName]").attr("readOnly", true);
				$("input[name=columnName]").css("background-color", "#E6E6E6");
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	function isValid(){
		if ($('input[name=columnName]').val()==""){
			alert("컬럼명을 입력하여 주십시요.");
			$('input[name=columnName]').focus();
			return false;
		}
		return true;
	}
	
	$(document).ready(function() {	
		$("input[name=columnLength], input[name=keySeq], input[name=comboDepth]").inputmask("9999",{'autoUnmask':true});
		
		var returnUrl = getReturnUrlForReturn();
		var key ="${param.columnName}";
		if (key != "" && key !="null"){
			isDetail = true;
		}	
		init(key,detail);
		
		
		$("#btn_modify").click(function(){
			var postData = $('#ajaxForm').serializeArray();
			if (!isValid())return;
			
			if (isDetail){
				postData.push({ name: "cmd" , value:"UPDATE"});
			}else{
				postData.push({ name: "cmd" , value:"INSERT"});
			}
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
		$("#btn_delete").click(function(){
			var postData = $('#ajaxForm').serializeArray();
			postData.push({ name: "cmd" , value:"DELETE"});
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
		$("#btn_previous").click(function(){
			goNav(returnUrl);//LIST로 이동
		});
		$("input[name=columnName]").click(function(){
			if (!isDetail) return;
			
			document.body.focus();
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
				<div class="title">내부표준 Default값</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">컬럼명</th><td><input type="text"  name="columnName"/></td>
						</tr>
						<tr>
							<th style="width:20%;">컬럼설명</th><td><input type="text"  name="columnDesc"/></td>
						</tr>
						<tr>
							<th style="width:20%;">컬럼길이</th><td><input type="text"  name="columnLength"/></td>
						</tr>
						<tr>
							<th style="width:20%;">Key 여부</th>
							<td><div class="select-style"><select name="isKey"></select></div></td>
						</tr>
						<tr>
							<th style="width:20%;">Key SEQ</th><td><input type="text"  name="keySeq"/></td>
						</tr>
						<tr>
							<th style="width:20%;">인터페이스 여부</th>
							<td><div class="select-style"><select name="isInterface"></select></div></td>
						</tr>
						<tr>
							<th style="width:20%;">Combo명</th><td><input type="text"  name="comboName"/></td>
						</tr>
						<tr>
							<th style="width:20%;">Combo Depth</th><td><input type="text"  name="comboDepth"/></td>
						</tr>
						<tr>
							<th style="width:20%;">컬럼 기본값</th><td><input type="text"  name="columnDefault"/></td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

