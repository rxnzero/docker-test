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
	var url      = '<c:url value="/onl/admin/service/hostHeaderMan.json" />';
	var url_view = '<c:url value="/onl/admin/service/hostHeaderMan.view" />';
	var isDetail = false;
	var selectName = 'eaiBizCode';
	
	function init(key,callback){
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_DETAIL_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=sysSend]")).setNoValueInclude(false).setData(json.ynList).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=sysRecv]")).setNoValueInclude(false).setData(json.ynList).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=eaiBizCode]")).setData(json.bizRows).setFormat(codeName3OptionFormat).rendering();//업무구분코드
				
				if(key == "") setSearchable(selectName);	// 콤보에 searchable 설정
				
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
			$("input[name=tranCode]").val('DWRV ');
			$("input[name=startBit]").val('####');
			$("input[name=sysMode]").val('ONL');
			$("input[name=sysType]").val('R');
			$("select[name=sysSend]").val('2');
			$("select[name=sysRecv]").val('1');
			$("input[name=ubmugign]").val('KFTC ');
			
			$('select[name=eaiBizCode]').focus();
			return;
		}
		
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL', columnName : key},
			success:function(json){
				var data = json;
				
				$("input,select").each(function(){
					var name = $(this).attr('name').toUpperCase();
// 					alert('name='+name + ' val=' +data[name])
					if ( name != null )
					$(this).val(data[name]);
				});
				$("select[name=eaiBizCode]").val(data['EAIBZWKDSTCD']);
				$("select[name=eaiBizCode]").attr("disabled", true);
				$("select[name=eaiBizCode]").css("background-color", "#E6E6E6");
				
				setSearchable(selectName);	
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	function isValid(){
		if ($('select[name=eaiBizCode]').val()==""){
			alert("기관 어댑터 업무코드 을 입력하여 주십시요.");
			$('select[name=eaiBizCode]').focus();
			return false;
		}
		return true;
	}
	
	$(document).ready(function() {	
// 		$("input[name=columnLength], input[name=keySeq], input[name=comboDepth]").inputmask("9999",{'autoUnmask':true});
		
		var returnUrl = getReturnUrlForReturn();
		var key ="${param.eaiBizCode}";
		
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
				<div class="title">Host Header Default값</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">기관 어댑터 업무코드</th>
							<td>
<!-- 							<input type="text"  name="eaiBizCode" maxlength="4" size="4"/> -->
							<div class="select-style">
							<select name="eaiBizCode">
							</select>	
							</td>
						</tr>
						<tr>
							<th style="width:20%;">TRANCODE</th><td><input type="text"  name="tranCode" maxlength="9" size="9"/></td>
						</tr>
						<tr>
							<th style="width:20%;">STARTBIT</th><td><input type="text"  name="startBit" maxlength="4" size="4"/></td>
						</tr>
						<tr>
							<th style="width:20%;">SYSMODE (ONL/FTP)</th>
							<td><input type="text"  name="sysMode" maxlength="3" size="3"/></td>
						</tr>
						<tr>
							<th style="width:20%;">SYSTYPE(R/T)</th>
							<td><input type="text"  name="sysType" maxlength="1" size="1"/></td>
						</tr>
						<tr>
							<th style="width:20%;">SYSSEND</th>
							<td><div class="select-style"><select name="sysSend">
							<option value="1">계정계(1)</option>
							<option value="2">대외계(2)</option>
							<option value="3">정보계(3)</option>
							</select></div></td>
						</tr>
						<tr>
							<th style="width:20%;">SYSRECV</th>
							<td><div class="select-style"><select name="sysRecv">
							<option value="1">계정계(1)</option>
							<option value="2">대외계(2)</option>
							<option value="3">정보계(3)</option>
							</select></div></td>
						</tr>
						<tr>
							<th style="width:20%;">기관코드</th><td><input type="text"  name="ubmugign" maxlength="5" size="5"/></td>
						</tr>
						<tr>
							<th style="width:20%;">기관별 업무구분</th><td><input type="text"  name="ubmuSeq" maxlength="3" size="3"/></td>
						</tr>						
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

