<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
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
var url      = '<c:url value="/onl/admin/service/eaiMsgMan.json"/>';
var url_view = '<c:url value="/onl/admin/service/eaiMsgMan.view"/>';
var roleString	= "<%=SessionManager.getRoleIdString(request)%>";

var isDetail = false;
var selectName = "eaiBzwkDstcd,flowCtrlRoutName,gstatSysAdptrBzwkGroupName";	// selectBox Name

function init(key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=eaiBzwkDstcd]"              )).setData(json.bizRows            ).setFormat(codeName3OptionFormat).rendering();//업무구분코드             		
			new makeOptions("CODE","NAME").setObj($("select[name=svcHmsEonot]"               )).setData(json.svcTimeExistRows   ).setFormat(codeName3OptionFormat).rendering();//업무운영 시간여부        		
			new makeOptions("CODE","NAME").setObj($("select[name=svcMotivUseDstcd]"          )).setData(json.svcSameTimeTypeRows).rendering();//인터페이스 사용유형      		
			new makeOptions("CODE","NAME").setObj($("select[name=svcPrcesDsticName]"         )).setData(json.svcProcessTypeRows ).rendering();//서비스 처리유형          		
			new makeOptions("CODE","NAME").setObj($("select[name=flowCtrlRoutName]"          )).setData(json.flowControlRows    ).rendering();//Flow Control 라우팅명    		
			new makeOptions("CODE","NAME").setObj($("select[name=intgraDsticName]"           )).setData(json.unitTypeRows       ).rendering();//거래유형                 		
			new makeOptions("CODE","NAME").setObj($("select[name=svcBfClmnLogYn]"            )).setData(json.svcWholeColLogRows ).setFormat(codeName3OptionFormat).rendering();//보조 로그 사용여부       		
			new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=gstatSysAdptrBzwkGroupName]")).setData(json.inAdapterRows).setFormat(codeName3OptionFormat).rendering();//기동 인터페이스 유형     		
			new makeOptions("CODE","NAME").setObj($("select[name=sevrLogLvelNo]"             )).setData(json.serverLogLevelRows ).setFormat(codeName3OptionFormat).rendering();//서버로그 레벨            		
			new makeOptions("CODE","NAME").setObj($("select[name=svcLogLvelNo]"              )).setData(json.svcLogLevelRows    ).rendering();//서비스 로그레벨          		
			new makeOptions("CODE","NAME").setObj($("select[name=simYn]"                     )).setData(json.simRows            ).setFormat(codeName3OptionFormat).rendering();//시뮬레이터 여부
			
			if(key == "") setSearchable(selectName);	// 콤보에 searchable 설정
			
			if(typeof callback === 'function') {
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
		data:{cmd: 'DETAIL', eaiSvcName : key},
		success:function(json){
			var data = json;
			$("input[name=eaiSvcName]").attr('readonly',true);
			$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			});
			
			setSearchable(selectName);	// 콤보에 searchable 설정
		},
		error:function(e){
			alert(e.responseText);
		}
	});
	var postData = {};
	postData["cmd"]="LIST_SVC";
	postData["eaiSvcName"]=key;
	$("#grid").setGridParam({ url : url, postData: postData }).trigger("reloadGrid");
}
function gridRendering(){
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		rowNum: 10000,
		colNames:['IF서비스코드',
		          '처리순서',
                  '수동인터페이스유형',
                  '수동업무시스템명',
                  '수동시스템인터페이스유형',
                  'FailOver여부',
                  '다음서비스처리순서',
                  'Outbound라우팅명'
                  ],
		colModel:[
				{ name : 'EAISVCNAME'               , align:'left' , hidden: true },
				{ name : 'SVCPRCSSNO'               , align:'left' },
				{ name : 'PSVINTFACDSTICNAME'       , align:'left' },
				{ name : 'PSVSYSBZWKDSTCD'          , align:'left' },
				{ name : 'PSVSYSADPTRBZWKGROUPNAME' , align:'left' },
				{ name : 'FLOVRYN'                  , align:'left' },
				{ name : 'NEXTSVCPRCSSNO'           , align:'left' },
				{ name : 'OUTBNDROUTNAME'           , align:'left' }
				],
        jsonReader: {
             repeatitems:false
        },	   
        loadComplete : function (d) {
        },
        ondblClickRow: function(rowId) {
	    	var rowData = $(this).getRowData(rowId); 
	    	var url2 = url_view;
			url2 += '?cmd=SVC';
			url2 += '&page='+'${param.page}';
			url2 += '&returnUrl='+'${param.returnUrl}';
	        url2 += '&menuId='+'${param.menuId}';
			//검색값
			url2 += '&'+getSearchUrlForReturn();
			//key값
			url2 += '&eaiSvcName='+rowData['EAISVCNAME'];
			url2 += '&svcPrcssNo='+rowData['SVCPRCSSNO'];
			
			
	        goNav(url2);        
        },
	    onSelectRow: function(rowid,status){

	    },        
               
	    height: '300',
		autowidth: true,
		viewrecords: true
	});	
}

function isValid(){
	if ($('input[name=eaiSvcName]').val()==""){
		alert("IF서비스 코드를 입력하여 주십시요.");
		return false;
	}
	if ($('select[name=eaiBzwkDstcd]').val()==""){
		alert("업무구분 코드를 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=svcHmsEonot]').val()==""){
		alert("업무운영 시간여부를 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=svcMotivUseDstcd]').val()==""){
		alert("인터페이스 사용유형을 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=svcPrcesDsticName]').val()==""){
		alert("서비스 처리유형을 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=flowCtrlRoutName]').val()==""){
		alert("Flow Control 라우팅명을 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=intgraDsticName]').val()==""){
		alert("거래유형을 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=svcBfClmnLogYn]').val()==""){
		alert("보조 로그 사용여부를 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=gstatSysAdptrBzwkGroupName]').val()==""){
		alert("기동 인터페이스 유형을 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=sevrLogLvelNo]').val()==""){
		alert("서버 로그 레벨을 선택하여 주십시요.");
		return false;
	}
	if ($('select[name=svcLogLvelNo]').val()==""){
		alert("서비스 로그 레벨을 선택하여 주십시요.");
		return false;
	}
	
	return true;
}

$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key ="${param.eaiSvcName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}
	gridRendering();
	
	init(key,detail);
	
	$("#btn_clone").click(function(){
		if ($("input[name=newEaiSvcName]").val()==""){
			alert("복제할 IF서비스 코드를 입력하여 주십시요.");
			return;
		}
		
		if (!isValid())return;

		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"CLONE"}, { name: "newEaiSvcName" , value:$("input[name=newEaiSvcName]").val()});
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
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=SVC';
		url2 += '&page='+'${param.page}';
		url2 += '&returnUrl='+'${param.returnUrl}';
        url2 += '&menuId='+'${param.menuId}';
		//검색값
		url2 += '&'+getSearchUrlForReturn();
		//key값
		url2 += '&eaiSvcName='+key;
		//generator key
		
		var rows = $("#grid")[0].rows;
		var index = Number($(rows[rows.length-1]).attr("id"));
		if (isNaN(index)) index=0;
	    var rowid = index + 1;
		
		
		url2 += '&svcPrcssNoForIndex='+rowid;
        goNav(url2);
	});
	
	$("#btn_initialize").click(function(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZE',eaiSvcName:$("input[name=eaiSvcName]").val()},
			success:function(json){
				alert(json.message);
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
		
	});		
	
	resizeJqGridWidth('grid','title','1000');

	buttonControl(isDetail);
	titleControl(isDetail);
	setBtnHide(roleString, "admin", "btn_initialize");
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
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W"  status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">IF메시지</div>						
				
				<form id="ajaxForm">
					<div class="table_row_title">IF메시지 정보</div>
					<table id="detail" class="table_row"  cellspacing="0"  >
						<tr>
							<td colspan="4">
								<input type="text" name="newEaiSvcName" style="width:calc(100% - 70px);">
								<img id="btn_clone" src="<c:url value="/img/btn_clone.png"/>" class="btn_img"/>							
							</td>
						</tr>
					</table>	
					<table id="detail" class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:20%;">IF서비스 코드</th>
							<td style="width:30%;"><input type="text" name="eaiSvcName"> </td>
							<th style="width:20%;">업무구분코드</th>
							<td style="width:30%;">
								<div style="position:relative;">
									<div class="select-style">
										<select name="eaiBzwkDstcd">
											
										</select>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th>업무운영 시간여부</th>
							<td >
								<div class="select-style">
								<select name="svcHmsEonot"> <option value="0">[0]없음</option><option value="1">[1]있음</option></select>
								</div>
							</td>
							<th>인터페이스 사용유형</th>
							<td >
								<div class="select-style">
								<select name="svcMotivUseDstcd"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>서비스 처리유형</th>
							<td >
								<div class="select-style">
								<select name="svcPrcesDsticName"></select>
								</div>
							</td>
							<th>Flow Control 라우팅명</th>
							<td >
								<div style="position:relative;">
									<div class="select-style">
									<select name="flowCtrlRoutName">									
									</select>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th>거래유형</th>
							<td >
								<div class="select-style">
								<select name="intgraDsticName"></select>
								</div>
							</td>
							<th>보조 로그 사용여부</th>
							<td >
								<div class="select-style">
								<select name="svcBfClmnLogYn"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>기동 인터페이스 유형</th>
							<td >
								<div style="position:relative;">
									<div class="select-style">
									<select name="gstatSysAdptrBzwkGroupName">
									</select>
									</div>
								</div>	
							</td>
							<th>서버 로그 레벨</th>
							<td >
								<div class="select-style">
								<select name="sevrLogLvelNo"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>서비스 로그 레벨</th>
							<td >
								<div class="select-style">
								<select name="svcLogLvelNo"></select>
								</div>
							</td>
							<th>오류IF서비스명</th>
							<td >
								<input type="text" name="errEAISvcName">
							</td>
						</tr>
						<tr>
							<th>요청오류변환ID명</th>
							<td >
								<input type="text" name="dmndErrChngIdName">
							</td>
							<th>요청에러필드명</th>
							<td >
								<input type="text" name="dmndErrFldName">
							</td>
						</tr>
						<tr>
							<th>응답오류변환ID명</th>
							<td >
								<input type="text" name="rspnsErrChngIdName">
							</td>
							<th>응답에러필드명</th>
							<td >
								<input type="text" name="rspnsErrFldName">
							</td>
						</tr>
						<tr>
							<th>시뮬레이터 여부</th>
							<td colspan="3">
								<div class="select-style">
								<select name="simYn"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>IF서비스 설명</th>
							<td colspan="3">
								<textarea name="eaiSvcDesc" style="width:100%;height:50px"></textarea>
							</td>
						</tr>
					</table>
					</form>
					
					<div class="table_row_title">IF 서비스 메시지 목록					
							<img id="btn_new" src="<c:url value="/img/btn_pop_new.png" />" class="btn_img" />		
	
					</div>
					<!-- grid -->
					<table id="grid" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

