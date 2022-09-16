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
<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" src="<c:url value="/js/jquery.mask.min.js"/>"></script>

<script language="javascript" >

	var url ='<c:url value="/bap/admin/schedule/scheduleMan.json" />';
	var isDetail = false;
	var jsonData;
	
	function init(key,callback){

		$("input[name=standYmd]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
        $("input[name=standYmd]").val(getToday());
        $("input[name=sndrcvStartHMS],input[name=sndrcvEndHMS]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM",outputFormat : "HHMM"  });
		$("input[name=scheFrstRegiHMS]").inputmask("9999-99-99 99:99:99.999",{'autoUnmask':false});
    	$("input[name=sndrcvStartHMS]").val('0000');
		$("input[name=sndrcvEndHMS]").val('2359');
		$("input[name=sndrcvEndHMS]").val('2359');
		$("input[name*=DlayNoday]").val('0');
		$("input[name=rqstRecvReTralCnt]").val('0');
		$("input[name=rqstRecvReTralIntvalTtm]").val('0');
		$("select[name=rqstRecvReTralUseYn]").val('0');
        
	
		if(typeof callback === 'function') {
			callback(key);
		}	
	}

function getBjobBzwkDstcd(key){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_BJOB_BZWK_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=bjobBzwkDstcd]")).setData(json.bjobBzwkDstcd).rendering();

			if ( isDetail ){
				detail(key);
			}else{
				getOgranFile(key);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function getOgranFile(key){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_ORGAN_FILE'
		     , bjobBzwkDstcd : $("select[name=bjobBzwkDstcd]").val()			     
		},
		success:function(json){
		    $("select[name=bjobMsgDstcd],select[name=osidInstiDstcd]").empty();
			new makeOptions("CODE","NAME").setObj($("select[name=osidInstiDstcd]")).setData(json.osidInstiDstcd).rendering();	
			new makeOptions("CODE","NAME").setObj($("select[name=bjobMsgDstcd]")).setData(json.bjobMsgDstcd).rendering();
			debugger;
			if ( !isDetail ){
				getBjobPtrnDstcd(key);
			}else{
				$("select[name=bjobMsgDstcd]").val(jsonData['BJOBMSGDSTCD']);
				$("select[name=osidInstiDstcd]").val(jsonData['OSIDINSTIDSTCD']);
				getBjobPtrnDstcd(key);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function getBjobPtrnDstcd(key){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_SEND_RECV'
		     , bjobMsgDstcd : $("select[name=bjobMsgDstcd]").val()			     
		},
		success:function(json){
		    $("select[name=bjobPtrnDstcd]").empty();
			new makeOptions("CODE","NAME").setObj($("select[name=bjobPtrnDstcd]")).setData(json.bjobPtrnDstcd).rendering();
			if ( isDetail ){
			    //$("select[name=bjobPtrnDstcd]").val(jsonData['BJOBPTRNDSTCD']);
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
			        var name = $(this).attr("name");
			        var tag  = $(this).prop("tagName").toLowerCase();
			        $(tag+"[name="+name+"]").val(jsonData[name.toUpperCase()]);
			    });
			    $("#creator").show();
			}
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function detail(key){
	if (!isDetail){
		return;
	}
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', bJobMsgScheId : key},
		success:function(json){
			var data = json;
			jsonData = json;
			$("select[name=bjobBzwkDstcd]").val(data['BJOBBZWKDSTCD']);
			getOgranFile(key);
			var bjobPtrnDstcd = data['BJOBPTRNDSTCD'];
			if ( bjobPtrnDstcd  == 'RR'){
				$("#reqForm").show();
			}
			//$("select[name=bjobMsgDstcd]").val(data['BJOBMSGDSTCD']);
			//$("select[name=osidInstiDstcd]").val(data['OSIDINSTIDSTCD']);
			//getBjobPtrnDstcd(key);
			//$("select[name=bjobPtrnDstcd]").val(data['BJOBPTRNDSTCD']);
			
			//$("input[name=bJobMsgScheId]").attr('readonly',true);
			//$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
			//	var name = $(this).attr("name");
			//	var tag  = $(this).prop("tagName").toLowerCase();
			//	$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			//});

		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	
	var key ="${param.bJobMsgScheId}";
	if (key != "" && key !="null"){
	    isDetail = true;
	}
	init(key,getBjobBzwkDstcd);
	
	$("select[name=bjobBzwkDstcd]").change(function(){
	    getOgranFile();
	});

	$("select[name=bjobMsgDstcd]").change(function(){
	    getBjobPtrnDstcd();
	});
	
	$("#btn_modify").click(function(){
		var postData = $('#ajaxForm').serializeArray();
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
		postData.push({ name: "bjobMsgScheID" , value:key});
		
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
	$("#btn_operate").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"TRANSACTION"});
		postData.push({ name: "standYmd" , value: $("input[name=standYmd]").val()});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("수신 작업이 요청 되었습니다.");
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

	//$("input[name=sndrcvStartHMS],input[name=sndrcvEndHMS]").mask("00:00");

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
				<div class="title">스케쥴 <span class="tooltip">일괄전송 파일 송수신 스케쥴을 추가합니다</span></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr style="display:none"><td><input name="bJobMsgScheId" ></td></tr>
						<tr>
							<th style="width:180px;">BATCH작업거래구분코드 *</th>
							<td><div class="select-style"><select name="bjobBzwkDstcd">
							</select></div></td>
							<th>BATCH작업메시지구분코드 *</th>
							<td><div class="select-style"><select name="bjobMsgDstcd">
							</select></div></td>
						</tr>
						<tr>
							<th>대외기관코드 *</th>
							<td><div class="select-style"><select name="osidInstiDstcd">
							</select></div></td>
							<th>송수신구분 *</th>
							<td><div class="select-style"><select name="bjobPtrnDstcd">
							</select></div></td>
						</tr>
						<tr>
							<th>송수신시작시각 *</th><td><input type="text"  name="sndrcvStartHMS" maxlength=5 size="5"/></td>
							<th>송수신종료시각 *</th><td><input type="text"  name="sndrcvEndHMS" maxlength=5 size="5"/></td>
						</tr>
						<tr>
							<th>송수신시작 지연일수 *</th><td><input type="text"  name="startDlayNoday"/></td>
							<th>송수신종료 지연일수 *</th><td><input type="text"  name="endDlayNoday"/></td>
						</tr>
						<tr>
							<th>요구송수신재시도수 *</th><td><input type="text"  name="rqstRecvReTralCnt"/></td>
							<th>요구송수신재시도사용여부 *</td>
							<td>
								<div class="select-style"><select name="rqstRecvReTralUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div>
							</td>
						</tr>
						<tr>
							<th>요구송수신재시도간격(초)</th><td><input type="text"  name="rqstRecvReTralIntvalTtm"/></td>
							<th>반복여부 *</td>
							<td>
								<div class="select-style"><select name="rpttYn">
									<option value="0">사용안함</option>
									<option value="1">사용</option>
								</select></div>
							</td>
						</tr>
						<tr>
							<th>공휴일처리유형 *</td>
							<td>
								<div class="select-style"><select name="holdyPrcssDstcd">
									<option value="0">해당없음</option>
									<option value="1">영업일만처리(토요일처리안함)</option>
									<option value="2">영업일만처리(토요일처리)</option>
								</select></div>
							</td>
							<th>당메시지 사용여부 *</td>
							<td>
								<div class="select-style"><select name="thisMsgUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div>
							</td>
						</tr>
						<tr id="creator" style="display:none">
							<th>최초 등록 일시</th><td><input type="text"  name="scheFrstRegiHMS" readonly="readonly" /></td>
							<th>최초 등록자 ID</th><td><input type="text"  name="msgSndrID" readonly="readonly"/></td>
						</tr>

					</table>
				</form>
				<form id="reqForm" hidden="hidden">
					<table class="table_row" cellspacing="0">
					<caption>[선택 수신 작업 요청]</caption>
						<tr>
							<th style="width:180px;">기준일자</th>
							<td><input type="text"  name="standYmd" maxlength=10 size="10" style="width:calc(100% - 70px);" /> <img id="btn_operate" src="<c:url value="/img/btn_pop_operate.png"/>" class="btn_img"></td> 
						</tr>
					</table>
				</form>
	
	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>