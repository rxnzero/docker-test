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
var url      = '<c:url value="/onl/admin/service/stdMessageMan.json" />';
var url_view = '<c:url value="/onl/admin/service/stdMessageMan.view" />';
var roleString	= "<%=SessionManager.getRoleIdString(request)%>";
var admin;
var isDetail = false;
function init(key,callback){
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=HEADER_MESGDMANDVCD]")).setData(json.reqResList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=COMMON_HMABDVCD]")).setData(json.stndTelgmWtinExtnlDstcdList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=COMMON_SYSOPRTENVDVCD]")).setData(json.sysOperEvirnDstcdList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=COMMON_ORTRRESTRYN]")).setData(json.ogtranRstrYnList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=COMMON_CHNLTYCD]")).setData(json.chnlDstcdList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=COMMON_CHNLDTLSCLCD]")).setData(json.chnlDvDstcdList).setFormat(codeName3OptionFormat).rendering();
			
			$("select[name=COMMON_CHNLTYCD]").change(function(){
				$("select[name=COMMON_CHNLDTLSCLCD] option").remove();
				var postData = [];
				postData.push({name:"cmd",value:"LIST_DYNAMIC_COMBO"});
				postData.push({name:"value",value:$("select[name=COMMON_CHNLTYCD]").val()});
			
				$.ajax({
					type : "POST",
					url:url,
					dataType:"json",
					async:false,
					data:postData,
					success:function(json){
						var obj = $("select[name=COMMON_CHNLDTLSCLCD]");
						new makeOptions("CODE","NAME").setObj(obj).setNoValueInclude(true).setData(json.chnlDvDstcdList).setFormat(codeName3OptionFormat).rendering();
					},
					error:function(e){
						alert(e.responseText);
					}
				});		
			});			
			{
				var arrRoleID	= roleString.split(",");
				for(var i = 0; i < arrRoleID.length; i++)
				{
					if(arrRoleID[i] == "admin")
						admin = true;
				}
				if(admin){
					$(".table_detail").find("TR").first().show();
				}else{
					$(".table_detail").find("TR").first().hide();
				}
			}
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
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', bzwkSvcKeyName : key},
		success:function(json){
			var rows = json.rows;
			var keys = json.keys;
			var data=[];
			var keyData=[];
			

			$("input[name=bzwkSvcKeyName]").attr('readonly',true);
			$("input[name=bzwkSvcKeyName]").val(data[name.toUpperCase()]);
			

			for(var i=0;i<rows.length;i++){
				if (i==0) data["BZWKSVCKEYNAME"] = rows[0].BZWKSVCKEYNAME;
				data[rows[i].COLUMNNAME]= rows[i].COLUMNVALUE;
			}
			
			$("#ajaxForm input,#ajaxForm textarea,#ajaxForm select").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				//isKey check ==> disable
				for(var i=0;i<keys.length;i++){
					if(name == keys[i].COLUMNNAME && keys[i].ISKEY == "Y" ){
						if( tag == "input")					
							$("[name="+keys[i].COLUMNNAME+"]").attr('readonly',true);
						else
							$("[name="+keys[i].COLUMNNAME+"]").prop('disabled',true);
					}	
				}
			});
			if(admin)
				$("input[name=COMMON_IFID]").attr('readonly',false);
			//$("select[name=HEADER_MESGDMANDVCD]").val(data["HEADER_MESGDMANDVCD"]);
			//$("select[name=COMMON_HMABDVCD]").val(data["COMMON_HMABDVCD"]);
			//$("select[name=COMMON_SYSOPRTENVDVCD]").val(data["COMMON_SYSOPRTENVDVCD"]);
			//$("select[name=COMMON_ORTRRESTRYN]").val(data["COMMON_ORTRRESTRYN"]);
			//$("select[name=COMMON_CHNLTYCD]").val(data["COMMON_CHNLTYCD"]);
			$("select[name=COMMON_CHNLTYCD]").change();
			$("select[name=COMMON_CHNLDTLSCLCD]").val(data["COMMON_CHNLDTLSCLCD"]);
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
	function isValid(){
		if ($('input[name=bzwkSvcKeyName]').val()==""){
			alert("업무서비스키값을 입력하여 주십시요.");
			return false;
		}
		if ($('input[name=COMMON_IFID]').val()==""){
			alert("인터페이스ID를 입력하여 주십시요.");
			return false;
		}
		if ($('select[name=HEADER_MESGDMANDVCD]').val()==""){
			alert("전문요청 구분코드를 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=COMMON_HMABDVCD]').val()==""){
			alert("내외부 구분코드를 선택하여 주십시요.");
			return false;
		}
		if ($('input[name=COMMON_GROUPCMPCD]').val()==""){
			alert("그룹회사 코드를 입력하여 주십시요.");
			return false;
		}
		if ($('select[name=COMMON_SYSOPRTENVDVCD]').val()==""){
			alert("시스템 운영환경 구분코드를 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=COMMON_ORTRRESTRYN]').val()==""){
			alert("원거래 복원 여부를 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=COMMON_CHNLTYCD]').val()==""){
			alert("채널 유형코드를 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=COMMON_CHNLDTLSCLCD]').val()==""){
			alert("채널 세부 분류코드를 선택하여 주십시요.");
			return false;
		}
		

		
		return true;
	}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key ="${param.bzwkSvcKeyName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	init(key,detail);
	
	
	$("#btn_modify").click(function(){
		if (!isValid())return;
		
		// disable이면 serializeArray에 속하지 않음.	
		$('#ajaxForm select[disabled]').each(function(){
			$(this).prop('disabled','');
		}); 
		var postData = $('#ajaxForm').serializeArray();
		
		$('#ajaxForm select[disabled]').each(function(){
			$(this).prop('disabled','disabled');
		}); 		
		
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
				alert(e.responseText);
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
	$("#btn_clone").click(function(){
		if ($("input[name=bzwkSvcKeyNameClone]").val()==""){
			alert("복제할 업무서비스키를 입력하여 주십시요.");
			return;
		}
		if (!isValid())return;
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"CLONE"});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("저장 되었습니다.");
				goNav(returnUrl);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	
	$("#btn_initialize").click(function(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZE',bzwkSvcKeyName:$("input[name=bzwkSvcKeyName]").val()},
			success:function(json){
				alert(json.message);
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
		
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
				<div class="title">내부표준메시지<span class="tooltip">기동, 수동 시스템의 비표준 메시지를 입력 받아 서비스 코드별 표준 메시지로 변환하기 위한 공통부 IF 서비스코드 (인터페이스ID+전문요청구분코드+내외부구분코드)</span></div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						
						<tr level="W" status="DETAIL" style="display:none">
							<th style="width:20%;">복제할 업무서비스키</th>
							<td style="width:80%;">
								<input type="text" name="bzwkSvcKeyNameClone" size="20"/> 
								<img id="btn_clone" src="<c:url value="/img/btn_clone.png"/>"/>
							</td>
						</tr>
						<tr>
							<th style="width:20%;">업무서비스키</th>
							<td style="width:80%;"><input type="text"  name="bzwkSvcKeyName"/></td>
						</tr>
						<tr>
							<th>인터페이스ID</th><td><input type="text"  name="COMMON_IFID"/></td>
						</tr>
						<tr>
							<th>전문요청구분코드</th>
							<td><div class="select-style"><select name="HEADER_MESGDMANDVCD"></select></div></td>
						</tr>
						<tr>
							<th>내외부구분코드</th>
							<td><div class="select-style"><select name="COMMON_HMABDVCD"></select></div></td>
						</tr>
						<tr>
							<th>서비스ID</th><td><input type="text"  name="COMMON_SRVCID"/></td>
						</tr>
						<tr>
							<th>처리결과수신서비스ID</th><td><input type="text"  name="COMMON_PROCSRSLTRCMSSRVCID"/></td>
						</tr>
						<tr>
							<th>그룹회사코드</th><td><input type="text"  name="COMMON_GROUPCMPCD" value="000" /></td>
						</tr>
						<tr>
							<th>대외채널기관코드</th><td><input type="text"  name="COMMON_OTSDCHNLINSTCD"/></td>
						</tr>
						<tr>
							<th>시스템운영환경구분코드</th>
							<td><div class="select-style"><select name="COMMON_SYSOPRTENVDVCD"></select></div></td>
						</tr>
						<tr>
							<th>원거래복원여부</th>
							<td><div class="select-style"><select name="COMMON_ORTRRESTRYN"></select></div></td>
						</tr>
						<tr>
							<th>화면번호</th><td><input type="text"  name="COMMON_SCNNO"/></td>
						</tr>
						<tr>
							<th>채널유형코드</th>
							<td><div class="select-style"><select name="COMMON_CHNLTYCD"></select></div></td>
						</tr>
						<tr>
							<th>채널세부분류코드</th>
							<td><div class="select-style"><select name="COMMON_CHNLDTLSCLCD"></select></div></td>
						</tr>
						<tr>
							<th>거래부점코드</th><td><input type="text"  name="COMMON_TXBRCD"/></td>
						</tr>
						<tr>
							<th>실거래점코드</th><td><input type="text"  name="COMMON_RLTRBRCD"/></td>
						</tr>
						<tr>
							<th>대외텔러번호</th><td><input type="text"  name="COMMON_TLRNO"/></td>
						</tr>

					</table>
				</form>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

