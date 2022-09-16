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

<script language="javascript" >
	var isDetail = false;
	
	var selectName = "eaiBzwkDstcd";	// selectBox Name
	
	function getAdapters(obj,adptrIoDstcd,type){
		var postData = [];
		if ($("input[name=eaiTranName]").val()=="")return;
		if ($("select[name=eaiBzwkDstcd]").val()=="")return;
		if (adptrIoDstcd =="IN"){
		 	queryType ="1";
		}else{
		 	queryType ="3";
		}
		
		
		var eaiTranName = $("input[name=eaiTranName]").val();
		postData.push({name:"cmd",value:"LIST_ADAPTER_COMBO"});
		postData.push({name:"adptrIoDstcd",value:adptrIoDstcd});
		postData.push({name:"queryType",value:queryType});
		postData.push({name:"chnlCd",value:eaiTranName.substring(0,3)});
		postData.push({name:"chnlCd2",value:eaiTranName.substring(eaiTranName.length-3,eaiTranName.length)});
		postData.push({name:"eaiBzwkDstcd",value:$("select[name=eaiBzwkDstcd]").val()});
		if (type !=undefined){
			postData.push({name:"asyncDstcd",value:type});
		}
		obj.find('option').remove();
	
		$.ajax({
			type : "POST",
			url:'<c:url value="/onl/transaction/extnl/interfaceMan.json" />',
			dataType:"json",
			async:false,
			data:postData,
			success:function(json){
				new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj(obj).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.adapter).setAttr("std","ADPTRMSGPTRNCD").rendering();
			},
			error:function(e){
				alert(e.responseText);
			}
		});	
	}	
	function adapterChange(){
		var value = $("select[name=svcMotivUseDstcd]").val();
		var reqRes = $("select[name=splizDmndDstcd]").val();
		$("select[name=toAdapter]").attr('disabled',false);
		if (value=="SYNC"){
			$("tr[name=tr_extAdapter]").hide();
			getAdapters($("select[name=fromAdapter]"),"IN","Sy");
			getAdapters($("select[name=toAdapter]"),"OU","Sy");
		}else if (value=="ASYN"){
			$("tr[name=tr_extAdapter]").hide();
			getAdapters($("select[name=fromAdapter]"),"IN","As");
			getAdapters($("select[name=toAdapter]"),"OU","As");
		}else if (value=="ASYN_SYNC"){
			$("tr[name=tr_extAdapter]").show();
			getAdapters($("select[name=fromAdapter]"),"IN","As");
			getAdapters($("select[name=toAdapter]"),"OU","Sy");
			getAdapters($("select[name=extAdapter]"),"OU","As");
		}	
		
		else if (value=="SYNC_ASYN"){
			$("tr[name=tr_extAdapter]").hide();
			if(reqRes != "R"){
				getAdapters($("select[name=fromAdapter]"),"IN","Sy");
				getAdapters($("select[name=toAdapter]"),"OU","As");
			}else{
				getAdapters($("select[name=fromAdapter]"),"IN","As");
				$("select[name=toAdapter]").attr('disabled',true);
			}
			
		}
				
	}
	function init(url,key,callback){
			$.ajax({
				type : "POST",
				url:url,
				dataType:"json",
				data:{cmd: 'LIST_DETAIL_COMBO'},
				success:function(json){
					new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=eaiBzwkDstcd]")).setData(json.bizList).setFormat(codeName3OptionFormat).rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=io]")).setNoValueInclude(true).setData(json.ioList).setFormat(codeName3OptionFormat).rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=splizDmndDstcd]")).setNoValueInclude(true).setData(json.reqResList).setFormat(codeName3OptionFormat).rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=svcMotivUseDstcd]")).setNoValueInclude(true).setData(json.syncAsyncList).rendering();
					
					if(key == "") setSearchable(selectName);	// 콤보에 searchable 설정
					
					if (typeof callback === 'function') {
						callback(url,key);
					}
				},
				error:function(e){
					alert(e.responseText);
				}
			});
	}
	function detail(url,key){
		if (!isDetail)return;
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL', eaiSvcName : key},
			success:function(json){
				var data = json;
				$("input[name=eaiSvcName]").attr('readonly',true);
				$("#ajaxForm input,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				$("select[name=eaiBzwkDstcd]"            ).val(data["EAIBZWKDSTCD"]);//업무구분코드
				$("select[name=io]"                      ).val(data["IO"]);//당타발구분
				$("select[name=splizDmndDstcd]"          ).val(data["SPLIZDMNDDSTCD"]);//전문요청구분
				$("select[name=stndTelgmWtinExtnlDstcd]" ).val(data["STNDTELGMWTINEXTNLDSTCD"]);//내외부구분
				$("select[name=svcMotivUseDstcd]"        ).val(data["SVCMOTIVUSEDSTCD"]);//송수신방법구분
				adapterChange();
				$("select[name=fromAdapter]"             ).val(data["FROMADAPTER"]);//fromAdapter
				$("select[name=toAdapter]"               ).val(data["TOADAPTER"]);//toAdapter
				$("select[name=extAdapter]"              ).val(data["EXTADAPTER"]);//extAdapter
				
				$("select[name=occurDstcd]"              ).val(data["OCCURDSTCD"]);//extAdapter
				$("select[name=transKind]"              ).val(data["TRANSKIND"]);//extAdapter
				
				setSearchable(selectName);	// 콤보에 searchable 설정
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	function makeEaiSvcName(){
		var eaiTranName = $("input[name=eaiTranName]").val();
		if (eaiTranName == "") return;
		
		var io = $("select[name=io]").val();
		if (io == "") return;
		var reqRes = $("select[name=splizDmndDstcd]").val();
		if (reqRes == "") return;
		var inout = "";
		if("EAI"==sessionStorage["serviceType"]){
			if (io=="I"){ //당발 
				inout ="1"; 
			}else{
				inout ="2";
			}
		}else{
			if(reqRes=="S" && io=="O"){ //당발요청
				inout = "2";
			}else if (reqRes=="R" && io=="O"){ //당발응답
				inout = "1";
			}else if (reqRes=="S" && io=="I"){ //타발응답
				inout = "1";
			}else if (reqRes=="R" && io=="I"){ //타발응답
				inout = "2";
			}
		}
		$("input[name=stndTelgmWtinExtnlDstcd]").val(inout);
		$("input[name=eaiSvcName]").val(eaiTranName.trim()+reqRes+inout);
		
		
	}
	function isValid(){
		if ($('select[name=eaiBzwkDstcd]').val()==""){
			alert("업무구분을 선택하여 주십시요.");
			return false;
		}
		if ($('input[name=eaiTranName]').val()==""){
			alert("인터페이스ID를 입력하여 주십시요.");
			return false;
		}
		if ($('input[name=eaiSvcDesc]').val()==""){
			alert("인터페이스ID설명을 입력하여 주십시요.");
			return false;
		}
		if ($('select[name=io]').val()==""){
			alert("당타발구분을 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=splizDmndDstcd]').val()==""){
			alert("전문요청구분을 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=svcMotivUseDstcd]').val()==""){
			alert("송수신방법을 선택하여 주십시요.");
			return false;
		}
		
		if (($('select[name=bzwkFldName1]').val()!="" || $('select[name=bzwkFldName12').val()!="")&&$('select[name=layoutMappingName]').val()==""){
			alert("전문추적관리필드를 셋팅하기 위해서는 레이아웃매핑을 입력하여 주십시요.");
			return false;
		}
		$("input[name^=msgFldStartSituVal],input[name^=msgFldLen]").each(function(){
			var value = $(this).val();
			if (isNaN(parseInt(value))){
				alert("통전문관리필드 항목이 숫자 타입이 아닙니다.("+$(this).attr("name")+")");
				return false;
			}
		});		
		if ($('select[name=fromAdapter]').val()=="" ){
			alert("거래흐름(INBOUND)어댑터를 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=toAdapter]').val()=="" ){
			if($('select[name=svcMotivUseDstcd]').val() !="SYNC_ASYN" || $("select[name=splizDmndDstcd] :selected").val() != "R" || sessionStorage["serviceType"] != "EAI"){
				
				alert("거래흐름(OUTBOUND)어댑터를 선택하여 주십시요.");
				return false;
			
			}
			
		}

		if ($('select[name=extAdapter]').val()=="" && $('select[name=svcMotivUseDstcd]').val()=="ASYN_SYNC" ){
			alert("거래흐름(ASYN-SYNC)어댑터를 선택하여 주십시요.");
			return false;
		}
		if ($("select[name=fromAdapter] option:selected").attr("std") == "K"){
			//표준일경우
			if($("input[name=serviceId]").val() !=""){
				alert("서비스ID를 삭제 하셔야 됩니다.");
				return false;
			}
		}else{
			if($("input[name=serviceId]").val().trim() ==""){				
				if($("select[name=splizDmndDstcd]").val() == "R" ){	
					var ret = confirm("서비스ID가 입력되지 않았습니다. \n공백으로 처리하면 요청의 서비스ID를 참조합니다. \n계속하시겠습니까?");
					if(ret){
						$("input[name=serviceId]").val(" ");	
					}else{
						alert("서비스ID를 입력 하셔야 됩니다.");
						return false;
					}
				}else{
					alert("서비스ID를 입력 하셔야 됩니다.");
					return false;
				}
				
			}	

		}
		
		return true;
	}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var url ='<c:url value="/onl/transaction/extnl/interfaceMan.json" />';
	var key ="${param.eaiSvcName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	init(url,key,detail);
	
	
	$("#btn_modify").click(function(){
		if (!isValid())return;
		
		
		//업무추출키 control
		if ($("select[name=fromAdapter] option:selected").attr("std") == "K"){
			//표준일경우 업무추출키 삭제되어야 됨
			$("input[name=bzwkSvcKeyName]").val("");
		}else{
			//표준이 아닐경우 업무추출키 셋팅되어야 됨
			$("input[name=bzwkSvcKeyName]").val($("input[name=eaiTranName]").val());
		}
	
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
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
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
	
	$("input[name=eaiTranName]").keyup(function(key){
		//$("input[name=bzwkSvcKeyName]").val($("input[name=eaiTranName]").val())
		makeEaiSvcName();
	});
	$("select[name=io]").change(function(){
		makeEaiSvcName();
	});
	$("select[name=splizDmndDstcd]").change(function(){
		makeEaiSvcName();
	});
	$("select[name=svcMotivUseDstcd]").change(function(){
		adapterChange();
	});
	$("select[name=eaiBzwkDstcd]").change(function(){
		adapterChange();
	});	
	$("input[name=interfaceId]").blur(function(){
		adapterChange();
	});	
	$("input[name=layoutMappingName]").dblclick(function(){
		var layoutName = $(this).val();
		if($.trim(layoutName) =="") return;

		 var args = new Object();

		var url = '<c:url value="/onl/admin/rule/layoutMan.view" />';
		url += "?cmd=DETAILPOPUP";
        url += '&loutName='+layoutName;
        url += '&pop=true';
	    
	    showModal(url,args,1200,800); 
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
				<div class="title">인터페이스ID</div>				
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
				<!-- detail -->
				<form id="ajaxForm">				
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">IF서비스코드</th>
							<td style="width:80%;"><input type="text" name="eaiSvcName" readonly="readonly"/></td>
						</tr>
					</table>	
					
					<div class="table_row_title">[기본 정보]</div>
					
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">업무구분</th>
							<td style="width:80%;">
								<div style="position: relative; width: 100%;">
									<div class="select-style">
										<select type="text" name="eaiBzwkDstcd">
										</select>
									</div><!-- end.select-style -->										
								</div>	
							</td>
						</tr>
						<tr><th>인터페이스ID</th><td><input type="text" name="eaiTranName"/></td></tr>
						<tr><th>인터페이스ID설명</th><td><input type="text" name="eaiSvcDesc"/></td></tr>
						<tr>
							<th>당타발구분</th>
							<td>
								<div class="select-style">
									<select type="text" name="io">
									</select>
								</div><!-- end.select-style -->			
							</td>
						</tr>
						<tr>
							<th>전문요청구분</th>
							<td>
								<div class="select-style">
									<select type="text" name="splizDmndDstcd" style="width:100%">
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr style="display:none"><th>내외부구분</th><td><input type="text" name="stndTelgmWtinExtnlDstcd"/></td></tr>
					</table>	
					
					<div class="table_row_title">[추가 정보]</div>
					
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">송수신방법</th>
							<td style="width:80%;">
								<div class="select-style">
									<select name="svcMotivUseDstcd">
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr style="display:none">
							<th>업무추출키</th><td><input type="text" name="bzwkSvcKeyName" readonly="readonly"/></td>
						</tr>
						<tr><th>서비스ID</th><td><input type="text" name="serviceId"/></td></tr>
						<!--tr><th>응답서비스ID</th><td><input type="text" name="returnSerivceId"/></td></tr-->
						<tr><th>레이아웃매핑</th><td><input type="text" name="layoutMappingName"/></td></tr>
						<tr><th>전문추적관리필드1</th><td><input type="text" name="bzwkFldName1"></td></tr>
						<tr><th>전문추적관리필드2</th><td><input type="text" name="bzwkFldName2"></td></tr>
						<tr><th>통전문관리필드1</th><td><input type="text" name="msgFldStartSituVal1" size="3" value="0" style="width:100px; border:1px solid #ebebec;">,<input type="text" name="msgFldLen1" size="3" value="0" style="width:100px; border:1px solid #ebebec;"></td></tr>
						<tr><th>통전문관리필드2</th><td><input type="text" name="msgFldStartSituVal2" size="3" value="0" style="width:100px; border:1px solid #ebebec;">,<input type="text" name="msgFldLen2" size="3" value="0" style="width:100px; border:1px solid #ebebec;"></td></tr>
						<tr><th>REST OPTION</th><td><input type="text" name="restOption"/></td></tr>
					</table>	
					
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">거래흐름선택(INBOUND)</th>
							<td style="width:80%;">
								<div class="select-style">
									<select type="text" name="fromAdapter"></select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th>거래흐름선택(OUTBOUND)</th>
							<td>
								<div class="select-style">
									<select name="toAdapter"/></select>
								</div><!-- end.select-style -->	
							</td>
						</tr>
						<tr name="tr_extAdapter" style="display:none">
							<th>거래흐름선택(ASYNC-SYNC)</th>
							<td>
								<div class="select-style">
									<select name="extAdapter"/></select>
								</div><!-- end.select-style -->	
							</td>
						</tr>
					</table>	
					
				
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">데이터발생유형</th>
							<td style="width:80%;" colspan="3">
								<div class="select-style">
									<select type="text" name="occurDstcd">
										<option value="REALTIME">[REALTIME] 전문</option>							
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th>전송유형</th>
							<td colspan=3>
								<div class="select-style">
									<select type="text" name="transKind">
										<option value="">선택안함</option>
										<option value="REQRES">[REQ&RES] 요청시스템에서 타겟시스템에 서비스 요청 후 응답을 기다리는 유형</option>
										<option value="REQ">[REQ] 요청시스템에서 타겟시스템에 서비스 요청 후 응답을 기다리지 않는 유형]</option>
										<option value="RES">[RES] 타겟시스템에서 원천시스템으로 서비스 요청에 대한 응답 유형</option>
										<option value="ETC">[ETC] 기타</option>
									</select>
								</div><!-- end.select-style -->	
							</td>
						</tr>
						<tr>
							<th>전송주기( ex)연1회, 수시)</th>
							<td colspan=3><input type="text" name="transFreq"> </td>
						</tr>
						<tr>
							<th>1회크기( ex) 3KB 등)</th>
							<td  colspan=3><input type="text" name="sizeOnce"> </td>
						</tr>
						<tr>
							<th>처리시간구간( ex) 13시~14시 )</th>
							<td colspan=3><input type="text" name="procTerm"> </td>
						</tr>			
						<tr>
							<th>요청담당자</th>
							<td style="width:30%;"><input type="text" name="reqChgr"> </td>
							<th>요청담당자 전화번호</th>
							<td style="width:30%;"><input type="text" name="reqChgrTlno"></td>
						</tr>
						<tr>
							<th>응답담당자</th>
							<td><input type="text" name="resChgr"/></td>
							<th>응답담당자 전화번호</th>
							<td><input type="text" name="resChgrTlno"/></td>
						</tr>
						<tr>
							<th>비고</th>
							<td colspan=3><input type="text" name="rmk"> </td>
						</tr>
						
					</table>	
					
				
					<table class="table_row" cellspacing="0" style="display:none">
						<tr><th>개발담당자</th><td><input type="text" name="devUser" size="10"/><input type="text" name="devUserName" size="10"/><img src="<c:url value="/images/role_search.gif"/>" name="searchDev" /> </td></tr>
						<tr><th>은행담당자</th><td><input type="text" name="bankUser" size="10"/><input type="text" name="bankUserName" size="10"/><img src="<c:url value="/images/role_search.gif"/>" name="searchBank" /> </td></tr>
					</table>	
					
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

