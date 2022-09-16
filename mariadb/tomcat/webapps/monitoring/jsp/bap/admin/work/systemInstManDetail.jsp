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

	var url ='<c:url value="/bap/admin/work/systemInstMan.json" />';

    var isDetail = false;
    var lastsel2;
    var flag1 = false;
    var flag2 = false;
    var flag3 = false;


function isValid(){
	if($('input[name=bjobBzwkDstcd]').val() == ""){
		alert("업무그룹코드를 입력하여 주십시요.");
		return false;
	}else if($('input[name=bjobBzwkName]').val() == ""){
		alert("업무그룹명를 입력하여 주십시요.");
		return false;
	}
	
	return true;
}
function isValidGrid(){
	if($('select[name=addPrptyTypDstcd]').val() == ""){
		alert("프라퍼티구분코드를 선택하여 주십시요.");
		return false;
	}else if($('input[name=addPrptyName]').val() == ""){
		alert("프라퍼티명을 입력하여 주십시요.");
		return false;
	}else if($('input[name=addPrptyDesc]').val() == ""){
		alert("프라퍼티 설명을 입력하여 주십시요.");
		return false;
	}
	//중복체크
	var data = $("#grid").getRowData();
	for ( var i = 0; i < data.length; i++) {
		if (data[i]['PRPTYTYPDSTCD'] == $('select[name=addPrptyTypDstcd]').val()
		    && data[i]['PRPTYNAME'] == $('input[name=addPrptyName]').val()
		    ){
			alert("증복된 프라퍼티명이 존재합니다. 확인하여주십시요.");
		    return false;
		}
	}
	
	return true;
}

function localSave(){
	var key =$("input[name=sysLnkgDstcd]").val();
	//객체 생성
	var save ={};
	$("#sysLnkgList input,#sysLnkgList select").not('select[name=sysLnkgDstcdList]').each(function(){
		var name = $(this).attr('name').toUpperCase();
		save[name] = $(this).val();
	});
	//var fullData = $("#grid").getRowData();
	//for(var i=0;i<fullData.length;i++){
	//	fullData[i]["PRPTYGROUPNAME"]=$("input[name=PRPTYGROUPNAME]").val();
	//}
	//save["rows"]=fullData;	
	submitData[key]=save;	
}

function gridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
		loadonce: true,
		rowNum: 10000,
		editurl : "clientArray",
		colNames:['프라퍼티명',
                  '프라퍼티설명',
                  '프라퍼티값'
                  ],
		colModel:[
				{ name : 'PRPTYNAME' , align:'left' },
				{ name : 'PRPTYDESC' , align:'left' },
				{ name : 'PRPTY2VAL' , align:'left', editable : true }
				],
        jsonReader: {
             repeatitems:false
        },	   
        loadComplete : function () {

        },
		onSelectRow: function(rowid,status){
	    	if (lastsel2 !=undefined){
	            if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
	        	  $("#grid").saveRow(lastsel2,false,"clientArray");
				}
	    	}
	        $('#grid').restoreRow(lastsel2);
	        $('#grid').editRow(rowid,true);
	        lastsel2=rowid;

        },  
        onSortCol : function(){
        	return 'stop';	//정렬 방지
        },       
	    height: '300',
		autowidth: true,
		viewrecords: true
	});
	
	
	resizeJqGridWidth('grid','title','1000');	
}
function init(key1,key2){
    getBjobBzwkDstcd(key1,key2);
    getBjobBzwkPrcssDstcd(key1,key2);
    getAdaptorGroup(key1,key2);
}

function getBjobBzwkDstcd(key1, key2 ){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_BJOB_BZWK_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=bjobBzwkDstcd]")).setData(json.bjobBzwkDstcd).rendering();
			
			flag1 = true;

			if ( isDetail ){
			    if ( flag1 && flag2 && flag3 ){
			        detail(key1, key2);
			    }
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function getBjobBzwkPrcssDstcd(key1, key2 ){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_BJOB_BZWK_PRCSS_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=sendPrcssRuleCd]")).setData(json.bjobBzwkPrcssDstcd).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=recvPrcssRuleCd]")).setData(json.bjobBzwkPrcssDstcd).rendering();
			
			flag2 = true;

			if ( isDetail ){
			    if ( flag1 && flag2 && flag3 ){
			        detail(key1, key2);
			    }
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}


function getAdaptorGroup(key1, key2 ){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_ADPTR_BZWK_GROUP_NAME_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=adptrBzwkGroupName]")).setNoValueInclude(true).setNoValue(' ','없음').setData(json.adptrBzwkGroupName).rendering();
			
			flag3 = true;

			if ( isDetail ){
			    if ( flag1 && flag2 && flag3 ){
			        detail(key1, key2);
			    }
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function detail(key1,key2){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{ cmd: 'DETAIL',
		       bjobBzwkDstcd : key1,
		       osidInstiDstcd : key2
		    },
		success:function(json){
			var data = json;
			var detail = json.detail;
			var sysConnList = json.sysConnList;
			//adapterType
			$("select[name=bjobBzwkDstcd]").attr('disabled',true);
			$("input[name=osidInstiDstcd]").attr('readonly',true);
			$("input,select").each(function(){
				var name = $(this).attr('name').toUpperCase();
				$(this).val(detail[name]);
			});
			$("input[name=prptyGroupName]").val("TelegramInfo{" + detail["BJOBBZWKDSTCD"] + "_" + detail["OSIDINSTIDSTCD"] + "}");
			if (sysConnList.length > 0){
				$("#sysLnkgList input,#sysLnkgList select").not('select[name=sysLnkgDstcdList]').each(function(){
					var name = $(this).attr('name').toUpperCase();
					$(this).val(sysConnList[0][name]);
				});
				//addoption
				new makeOptions("SYSLNKGDSTCD","SYSLNKGDSTCD").setObj($("select[name=sysLnkgDstcdList]")).setData(sysConnList).rendering();
				for(var i=0;i<sysConnList.length;i++){
					submitData[sysConnList[i]["SYSLNKGDSTCD"]]=sysConnList[i];
				}
				$("select[name=rqstRspnsDstcd]").trigger("change");
			}
			
			//Prop 
			$("#grid")[0].addJSONData(data);
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}

function setRqstRspnsDstcd(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_ADPTR_BZWK_NAME_COMBO',
			       adptrBzwkGroupName : $("select[name=adptrBzwkGroupName]").val(),
			       rqstRspnsDstcd : $("select[name=rqstRspnsDstcd]").val()
			},
			success:function(json){
			    $("select[name=adptrBzwkName]").empty();
				new makeOptions("ADPTRBZWKNAME","ADPTRDESC").setObj($("select[name=adptrBzwkName]")).setData(json.adptrBzwkNameList).rendering();
				var sysLnkgList = submitData[$("select[name=sysLnkgDstcdList]").val()];
				$("select[name=adptrBzwkName]").val(sysLnkgList["ADPTRBZWKNAME"]);
			},
			error:function(e){
				alert(e.responseText);
			}
		});
}

var submitData = {};

$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key1 ="${param.bjobBzwkDstcd}";
	var key2 ="${param.osidInstiDstcd}";
	
	$("input[name=thisMsgRegiHMS]").inputmask("9999-99-99 99:99:99.999",{'autoUnmask':true});
	$("input[name*=Size]").inputmask('decimal',{groupSeparator:',',digits:0,autoGroup:true,prefix:'',rightAlign:false,autoUnmask:true,removeMaskOnSubmit:true});
	$("input[name*=Indx]").inputmask('decimal',{groupSeparator:',',digits:0,autoGroup:true,prefix:'',rightAlign:false,autoUnmask:true,removeMaskOnSubmit:true});

	
	if (key1 != "" && key1 !="null"){
		isDetail = true;
	}	
	
	gridRendering();

	init(key1,key2);
	

	$("#btn_modify").click(function(){
		if (!isValid())return;
		if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
			$("#grid").saveRow(lastsel2,false,"clientArray");
		}
	
	
		var data     = $("#grid").getRowData();
		var gridData = new Array();
		for (var i = 0; i <data.length; i++) {
			gridData.push(data[i]);
		}
	
	
		//공통부만 form으로 구성
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "gridData" , value:JSON.stringify(gridData)});
		postData.push({ name: "sysConnList" , value:JSON.stringify(submitData)});
		postData.push({ name: "bjobBzwkDstcd"  , value:$("select[name=bjobBzwkDstcd]").val()});
		postData.push({ name: "prptyGroupName" , value:$("input[name=prptyGroupName]").val()});
		postData.push({ name: "prptyGroupDesc" , value:$("select[name=bjobBzwkDstcd]").val()+"배치 작업의 [" +$("input[name=osidInstiName]").val() +  "]대외기관의 송수신 전문용 프로퍼티 정의"});
        		
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
		// selectBox의 disable 해제
		// vaildation을 추가 하게 되면 validation 후에 disable 해제 해야합니다. 
		$("select[name=bjobBzwkDstcd]").attr("disabled", false);
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

	$("select[name=sysLnkgDstcdList]").change(function(){
		if (!($(this).val() == null || $(this).val() == undefined || $(this).val() == "")){
			var sysLnkgList = submitData[$(this).val()];
			$("#sysLnkgList input,#sysLnkgList select").not('select[name=sysLnkgDstcdList]').each(function(){
				var name = $(this).attr('name').toUpperCase();
				$(this).val(sysLnkgList[name]);
			});
			$("select[name=rqstRspnsDstcd]").trigger("change");
		}else{
			$("#sysLnkgList input,#sysLnkgList select").not('select[name=sysLnkgDstcdList]').each(function(){
				$(this).val("");
			});
		}
	});
	$("select[name=bjobBzwkDstcd]").change(function(){
		debugger;
		$.ajax({  
		    type : "POST",
		    url:url,
		    dataType:"json",
		    data:{ cmd: 'LIST_PROP',
		           bjobBzwkDstcd : $(this).val()
		         },
		    success:function(json){
		        $("#grid")[0].addJSONData(json);
		    }
		});
	    $("input[name=prptyGroupName]").val("TelegramInfo{" + $("select[name=bjobBzwkDstcd]").val() + "_" + $("input[name=osidInstiDstcd]").val() + "}");
	});
	$("input[name=osidInstiDstcd]").keyup(function(){
	    $("input[name=prptyGroupName]").val("TelegramInfo{" + $("select[name=bjobBzwkDstcd]").val() + "_" + $("input[name=osidInstiDstcd]").val() + "}");
	});
	$("#btn_pop_new").click(function(){
		//
		var isDuplication = false;
		var isEmpty = false;
		$("select[name=sysLnkgDstcdList] option").each(function(){
			if ($(this).val() == $("input[name=sysLnkgDstcd]").val()){
				isDuplication = true;
			}
		});
		if (isDuplication){
			alert("중복된 시스템연결구분코드가 존재합니다.확인하여 주십시요.");
			return;
		}
		if ($("input[name=sysLnkgDstcd]").val() == null || $("input[name=sysLnkgDstcd]").val() == undefined || $("input[name=sysLnkgDstcd]").val() == "" || $("input[name=sysLnkgDstcd]").val().trim() == ""){
			    isEmpty = true;
		} 
		
		if (isEmpty){
			alert(" 시스템연결구분코드를 입력하여 주십시요.");
			return;
		}
		var key = $("input[name=sysLnkgDstcd]").val();
		var str = new makeOptions("CODE","NAME").setData(key,key).getOption();
		$("select[name=sysLnkgDstcdList]").append(str);
		$("select[name=sysLnkgDstcdList]").val(key);
		submitData[key]=""; 
		localSave();
		
	});
	$("#btn_pop_modify").click(function(){
		//
		var isDuplication = false;
		$("select[name=sysLnkgDstcdList] option").each(function(){
			if ($(this).val() == $("input[name=sysLnkgDstcd]").val()){
				isDuplication = true;
			}
		});
		if (!isDuplication){
			alert("시스템연결구분코드가 존재 하지 않습니다.확인하여 주십시요.");
			return;
		}
		localSave();
		
	});	
	$("#btn_pop_delete").click(function(){
		//
		var isDuplication = false;
		$("select[name=sysLnkgDstcdList] option").each(function(){
			if ($(this).val() == $("input[name=sysLnkgDstcd]").val()){
				isDuplication = true;
			}
		});
		if (!isDuplication){
			alert("삭제할 시스템연결구분코드가 존재 하지 않습니다.확인하여 주십시요.");
			return;
		}
		//어댑터 목록 삭제
		var key = $("input[name=sysLnkgDstcd]").val();
		$("select[name=sysLnkgDstcdList] option[value='"+key+"']").remove();
		delete submitData[key];
		$("select[name=sysLnkgDstcdList]").trigger("change");
		
	});	
	$("#btn_pop_initialize").click(function(){
		$("#sysLnkgList input,#sysLnkgList select").not('select[name=sysLnkgDstcdList]').each(function(){
			$(this).val("");
		});
	});
	$("select[name=rqstRspnsDstcd]").change(function(){
		setRqstRspnsDstcd();
	});

	$("select[name=adptrBzwkGroupName]").change(function(){
		$("input[name=adptrBzwkGroupName]").val($("select[name=adptrBzwkGroupName]").val());
		setRqstRspnsDstcd();
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">시스템 대외 기관</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th>업무구분코드</th>
							<td><div class="select-style"><select name="bjobBzwkDstcd">
							</select></div></td>
							<th style="width:180px;">대외기관구분코드</th>
							<td ><input type="text" name="osidInstiDstcd" maxlength="4"  /> </td>
						</tr>
						<tr>
							<th>대외기관명</th><td><input type="text" maxlength="40" name="osidInstiName" /> </td>
							<th>전문블럭크기</th><td><input type="text" name="telgmBlckSize" /> </td>
						</tr>
						<tr>
							<th>전문일련번호크기</th><td><input type="text" name="telgmSernoSize" /> </td>
							<th>전문패킷크기</th><td><input type="text" name="telgmPcketSize" /> </td>
						</tr>
						<tr>
							<th>거래시작인덱스</th><td><input type="text" name="tranStartIndx" /> </td>
							<th>거래종료인덱스</th><td><input type="text" name="tranEndIndx" /> </td>
						</tr>
						<tr>
							<th>송신구분코드</th>
							<td><div class="select-style"><select name="sendPrcssRuleCd">
							</select></div></td>
							<th>수신구분코드</td>
							<td><div class="select-style"><select name="recvPrcssRuleCd">
							</select></div></td>
						</tr>
						<tr>
							<th>파일송신유형</th>
							<td><div class="select-style"><select name="fileSendPtrnDstcd">
								<option value="R">[R]요구</option>
								<option value="A">[A]응답</option>
							</select></div></td>
							<th>파일수신유형</th>
							<td><div class="select-style"><select name="fileRecvPtrnDstcd">
								<option value="R">[R]요구</option>
								<option value="A">[A]응답</option>
							</select></div></td>
						</tr>
						<tr>
							<th>어댑터그룹</th>
							<td><div class="select-style"><select name="adptrBzwkGroupName">
							</select></div></td>
							<th>당메시지 사용여부 *</th>
							<td>
								<div class="select-style"><select name="thisMsgUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div>
							</td>
						</tr>
					</table>
				</form>
				<div class="table_row_title">대외기관 연결 정보</div>
				<table id="sysLnkgList" class="table_row" cellspacing="0">
					<tr>
						<th style="width:180px;">시스템연결구분코드 리스트</th>
						<td colspan="3">
							<div class="select-style" style="display:inline-block; width:calc(100% - 260px);">
								<select name="sysLnkgDstcdList" ></select>
							</div> 
							<img id="btn_pop_new" src="<c:url value="/img/btn_pop_new.png"/>" class="btn_img" /> 
							<img id="btn_pop_modify" src="<c:url value="/img/btn_pop_modify.png"/>" class="btn_img" /> 
							<img id="btn_pop_delete" src="<c:url value="/img/btn_pop_delete.png"/>" class="btn_img" /> 
							<img id="btn_pop_initialize" src="<c:url value="/img/btn_pop_initialize.png"/>" class="btn_img" /> 
						</td>
					</tr>
					<tr>
						<th style="width:180px;">시스템연결구분코드</th>
						<td><input type="text" name="sysLnkgDstcd" /> </td>
						<th style="width:180px;">요구어댑터구분코드</th>
						<td ><div class="select-style"><select name="rqstRspnsDstcd" >
							<option value="R">[R]필요시 연결</option>
							<option value="A">[A]어댑터 연결</option>				
						</select></div> </td>
					</tr>
					<tr>
						<th>연결 IP 정보</th><td><input type="text" name="lnkgIPInfoName" /> </td>
						<th>연결 PORT 정보</th><td><input type="text" name="lnkgPortInfoName" /> </td>
					</tr>
					<tr>
						<th>연결 ID 정보 1</th><td><input type="text" name="lnkgID" /> </td>
						<th>연결 ID 정보 2</th><td><input type="text" name="lnkgPwd" /> </td>
					</tr>
					<tr>
						<th>연결 회선 상태 코드</th>
						<td ><div class="select-style"><select name="tCirtLnkgStusCd" >
							<option value="1">[1]정상</option>
							<option value="0">[0]장애</option>				
						</select></div> </td>
						<th>어댑터그룹명</th><td><input type="text" name="adptrBzwkGroupName" /> </td>
					</tr>
					<tr>
						<th>어댑터업무명</th>
						<td><div class="select-style"><select name="adptrBzwkName">
						</select></div></td>
						<th>당메시지 사용여부 *</th>
						<td>
							<div class="select-style"><select name="thisMsgUseYn">
								<option value="1">사용</option>
								<option value="0">사용안함</option>
							</select></div>
						</td>
					</tr>
					<tr> <!--   style="visibility: hidden;"--> 
						<th>등록자ID</th><td><input type="text" name="thisMsgRegsntID" readonly="readonly" /> </td>
						<th>등록일시</th><td><input type="text" name="thisMsgRegiHMS" readonly="readonly"/> </td>
					</tr>
				</table>
				<div class="table_row_title">프라퍼티 정보</div>
				<table id="prptyGroupNameTitle" class="table_row" cellspacing="0">
					<tr>
						<th style="width:180px;">프로퍼티 그룹명</th><td><input type="text" name="prptyGroupName" readonly="readonly" ></input> </td>
					</tr>
				</table>
				
				<!-- grid -->
				<table id="grid" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

