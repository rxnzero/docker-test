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
var lastsel1,lastsel2;

var selectName = "psvSysBzwkDstcd,psvSysAdptrBzwkGroupName,outbndRoutName";	// selectBox Name

function replaceRowName(rows){
	var json ={};
	json["rows"]=rows;
	return json;
}

function init(url,key1,key2,callback){
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
			new makeOptions("CODE","NAME").setObj($("select[name=sevrLogLvelNo]"             )).setData(json.serverLogLevelRows ).setFormat(codeName3OptionFormat).rendering();//서버로그 레벨            		
			new makeOptions("CODE","NAME").setObj($("select[name=svcLogLvelNo]"              )).setData(json.svcLogLevelRows    ).rendering();//서비스 로그레벨          		
			new makeOptions("CODE","NAME").setObj($("select[name=simYn]"                     )).setData(json.simRows            ).setFormat(codeName3OptionFormat).rendering();//시뮬레이터 여부          		
			new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=gstatSysAdptrBzwkGroupName]")).setData(json.inAdapterRows      ).setFormat(codeName3OptionFormat).rendering();//기동 인터페이스 유형     		
			


			new makeOptions("CODE","NAME").setObj($("select[name=psvIntfacDsticName]" )).setData(json.psvItfTypeRows        ).rendering();//수동 인터페이스 유형	             		
			new makeOptions("CODE","NAME").setObj($("select[name=psvSysBzwkDstcd]"    )).setData(json.bizRows               ).setFormat(codeName3OptionFormat).rendering();//수동업무구분        		
			new makeOptions("CODE","NAME").setObj($("select[name=psvSysIdName]"       )).setData(json.psvIdRows             ).rendering();//수동시스템ID        		
			new makeOptions("CODE","NAME").setObj($("select[name=flovrYn]"            )).setData(json.failOverClsRows       ).setFormat(codeName3OptionFormat).rendering();//FailOver여부           		
			new makeOptions("CODE","NAME").setObj($("select[name=chngEonot]"          )).setData(json.cnvExistNotRows       ).rendering();//변환유무             		
			new makeOptions("CODE","NAME").setObj($("select[name=bascRspnsChngEonot]" )).setData(json.bsRspCnvExistNotRows  ).setFormat(codeName3OptionFormat).rendering();//기본응답변환유무             		
			new makeOptions("CODE","NAME").setObj($("select[name=errRspnsChngEonot]"  )).setData(json.errRspCnvExistNotRows ).setFormat(codeName3OptionFormat).rendering();//오류응답변환유무             		
			new makeOptions("CODE","NAME").setObj($("select[name=outbndRoutName]"     )).setData(json.outBoundRoutingRows   ).rendering();//Outbound라우팅명             		
			new makeOptions("CODE","NAME").setObj($("select[name=supplDelYn]"         )).setData(json.addDelYnRows          ).rendering();//추가삭제여부             		
			new makeOptions("CODE","NAME").setObj($("select[name=hdrCtrlDstcd]"       )).setData(json.hdrCtlCdRows          ).setFormat(codeName3OptionFormat).rendering();//헤더제어구분코드             		
			new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=psvSysAdptrBzwkGroupName]")).setData(json.ouAdapterRows).setFormat(codeName3OptionFormat).rendering();//수동시스템인터페이스유형             		
			
			if(key2 == "") setSearchable(selectName);	// 콤보에 searchable 설정
			
			if(typeof callback === 'function') {
				callback(url,key1,key2);
    		}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function detail(url,key1,key2){
	//IF 메시지 정보
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', eaiSvcName : key1 },
		success:function(json){
			var data = json;
			$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				$(tag+"[name="+name+"]").attr('readonly',true);
				$(tag+"[name="+name+"]").css({'background-color' : '#e5e5e5'});
				if (tag =="select"){
					$("select[name="+name+"]").attr("disabled",true);
				}
			});
		},
		error:function(e){
			alert(e.responseText);
		}
	});
	$("input[name=svcPrcssNo]").val('${param.svcPrcssNoForIndex}');
	if (!isDetail)return;
	//IF 서비스 메시지 등록
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL_SVC', eaiSvcName : key1 , svcPrcssNo:key2},
		success:function(json){
			var data = json;
			$("input[name=svcPrcssNo]").attr('readonly',true);
			$("#ajaxForm2 input,#ajaxForm2 select,#ajaxForm2 textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			});
			$("#grid1")[0].addJSONData(replaceRowName(json.refRows));
			$("#grid2")[0].addJSONData(replaceRowName(json.conRuleRows));
			
			setSearchable(selectName);	// 콤보에 searchable 설정
		},
		error:function(e){
			alert(e.responseText);
		}
	});	
}
function gridRendering(){
	$('#grid1').jqGrid({
		datatype:"local",
	    editurl : "clientArray",
	    dataType:"json",
		loadonce: true,
		rowNum: 10000,
		colNames:['IF서비스코드',
		          '처리순서',
		          '참조 메시지ID순서',
                  '참조 메시지ID'
                  ],
		colModel:[
				{ name : 'EAISVCNAME'   , align:'left' , hidden: true },
				{ name : 'SVCPRCSSNO'   , align:'left' , hidden: true},
				{ name : 'REFMSGIDNO'   , align:'left' },
				{ name : 'REFMSGIDNAME' , align:'left' ,editable: true}
				],
        jsonReader: {
             repeatitems:false,
             root : 'rows'
		                  
        },	
        onSortCol : function(){
        	return 'stop';	//정렬 방지
        },     
        loadComplete : function (d) {
        },
        ondblClickRow: function(rowId) {
     
        },
	    onSelectRow: function(rowid,status){
	    	if (lastsel1 !=undefined){
	            if($("#grid1 tr#" + lastsel1).attr("editable") == 1){ //editable=1 means row in edit mode
	        	  $("#grid1").saveRow(lastsel1,false,"clientArray");
				}
	    	}
	        $('#grid1').restoreRow(lastsel1);
	        $('#grid1').editRow(rowid,true);
	        lastsel1=rowid;
	    },        
	    height: '100',
		autowidth: true,
		viewrecords: true
	});	
	$('#grid2').jqGrid({
		datatype:"local",
	    editurl : "clientArray",
		//loadonce: true,
		rowNum: 10000,
		dataType:"json",
		colNames:['IF서비스코드',
		          '처리순서',
                  '규칙일련번호',
                  '결과처리번호',
                  '규칙필드그룹명',
                  '규칙필드명',
                  '비교내용'
                  ],

		colModel:[
				{ name : 'EAISVCNAME'       , align:'left' , hidden: true },
				{ name : 'SVCPRCSSNO'       , align:'left' , hidden: true},
				{ name : 'RULESERNO'        , align:'left' },
				{ name : 'RSULTPRCSSNO'     , align:'left' ,editable: true},
				{ name : 'RULEFLDGROUPNAME' , align:'left' ,editable: true},
				{ name : 'RULEFLDNAME'      , align:'left' ,editable: true},
				{ name : 'CMPRCTNT'         , align:'left' ,editable: true}
				],
        jsonReader: {
             repeatitems:false,
             root : 'conRuleRows'
        },	   
        loadComplete : function (d) {
        },
        ondblClickRow: function(rowId) {
     
        },
        onSortCol : function(){
        	return 'stop';	//정렬 방지
        },   
	    onSelectRow: function(rowid,status){
	    	if (lastsel2 !=undefined){
	            if($("#grid2 tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
	        	  $("#grid2").saveRow(lastsel2,false,"clientArray");
				}
	    	}
	        $('#grid2').restoreRow(lastsel2);
	        $('#grid2').editRow(rowid,true);
	        lastsel2=rowid;
	    },        
               
	    height: '300',
		autowidth: true,
		viewrecords: true
	});		
}
$(document).ready(function() {	
	var returnUrl = '${param.returnUrl}';
	returnUrl = returnUrl + '?cmd='+'DETAIL';
	returnUrl = returnUrl + '&page='+'${param.pages}';
	returnUrl = returnUrl + '&menuId='+'${param.menuId}';
	//검색조건
	returnUrl = returnUrl + '&'+ getSearchUrlForReturn();
	//key
	returnUrl = returnUrl + '&eaiSvcName='+ "${param.eaiSvcName}";
	
	
	
	var url ='<c:url value="/onl/admin/service/eaiMsgMan.json" />';
	var key1 ="${param.eaiSvcName}";
	var key2 ="${param.svcPrcssNo}";
	if (key2 != "" && key2 !="null"){
		isDetail = true;
	}
	gridRendering();
	
	init(url,key1,key2,detail);
	$("img").click(function(){
		if($("#grid1 tr#" + lastsel1).attr("editable") == 1){ //editable=1 means row in edit mode
          $("#grid1").saveRow(lastsel1,false,"clientArray");
		}
		if($("#grid2 tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
          $("#grid2").saveRow(lastsel2,false,"clientArray");
		}
	});		
	$("#btn_modify").click(function(){
		var data     = $("#grid1").getRowData();
		var gridRef = new Array();
		for (var i = 0; i <data.length; i++) {
			if (data[0]["REFMSGIDNAME"] !=null){
				gridRef.push(data[i]);
			}
		}
		
		data     = $("#grid2").getRowData();
		var gridConRule = new Array();
		for (var i = 0; i <data.length; i++) {
			if (data[0]["RSULTPRCSSNO"] !=null){
				gridConRule.push(data[i]);
			}
		}
	
		var postData = $('#ajaxForm2').serializeArray();
		postData.push({ name: "eaiSvcName" , value:key1});
		if (isDetail){
			postData.push({ name: "cmd" , value:"UPDATE_SVC"});
		}else{
			postData.push({ name: "cmd" , value:"INSERT_SVC"});
		}
		postData.push({ name: "gridRef" , value:JSON.stringify(gridRef)});
		postData.push({ name: "gridConRule" , value:JSON.stringify(gridConRule)});
		
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
	$("img[name=grid1add]").click(function(){
		var rows = $("#grid1")[0].rows;
		var index = Number($(rows[rows.length-1]).attr("id"));
		if (isNaN(index)) index=0;
	    var rowid = index + 1;
		var data = new Object();
		data["EAISVCNAME"]=key1; 
		data["SVCPRCSSNO"]=key2; 
		data["REFMSGIDNO"]=rowid; 
		data["REFMSGIDNAME"]=null;; 	    
	    
		$("#grid1").jqGrid('addRow', {
           rowID : rowid,          
           initdata : data,
           position :"last",    //first, last
           useDefValues : false,
           useFormatter : false,
           addRowParams : {extraparam:{}}
		});
		$("#"+$('#grid1').jqGrid('getGridParam','selrow')).focus();
	});
	$("img[name=grid2add]").click(function(){
		var rows = $("#grid2")[0].rows;
		var index = Number($(rows[rows.length-1]).attr("id"));
		if (isNaN(index)) index=0;
	    var rowid = index + 1;
		var data = new Object();
		data["EAISVCNAME"]=key1; 
		data["SVCPRCSSNO"]=key2; 
		data["RULESERNO"]=rowid; 
		data["RSULTPRCSSNO"]=null; 	    
		data["RULEFLDGROUPNAME"]=null; 	    
		data["RULEFLDNAME"]=null; 	    
		data["CMPRCTNT"]=null; 	    
	    
		$("#grid2").jqGrid('addRow', {
           rowID : rowid,          
           initdata : data,
           position :"last",    //first, last
           useDefValues : false,
           useFormatter : false,
           addRowParams : {extraparam:{}}
		});
		$("#"+$('#grid2').jqGrid('getGridParam','selrow')).focus();
	});	
	$("img[name=grid1delete").click(function(){
		var rowId = $("#grid1").getGridParam( "selrow" );
		if (rowId == null){
			alert("그리드의 행을 선택하여 주십시요.");
			return;
		}
		$('#grid1').jqGrid('delRowData',rowId);
	});	
	$("img[name=grid2delete").click(function(){
		var rowId = $("#grid2").getGridParam( "selrow" );
		if (rowId == null){
			alert("그리드의 행을 선택하여 주십시요.");
			return;
		}
		
		$('#grid2').jqGrid('delRowData',rowId);
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
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">IF메시지 등록</div>						
				
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
										<div class="select-style"><select name="eaiBzwkDstcd">
										</select>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th>업무운영 시간여부</th>
							<td >
								<div class="select-style">
								<div class="select-style"><select name="svcHmsEonot"></select>
								</div>
							</td>
							<th>인터페이스 사용유형</th>
							<td >
								<div class="select-style">
								<div class="select-style"><select name="svcMotivUseDstcd"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>서비스 처리유형</th>
							<td >
								<div class="select-style">
								<div class="select-style"><select name="svcPrcesDsticName"></select>
								</div>
							</td>
							<th>Flow Control 라우팅명</th>
							<td >
								<div style="position:relative;">
									<div class="select-style">
									<div class="select-style"><select name="flowCtrlRoutName">
									</select>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th>거래유형</th>
							<td >
								<div class="select-style">
								<div class="select-style"><select name="intgraDsticName"></select>
								</div>
							</td>
							<th>보조 로그 사용여부</th>
							<td >
								<div class="select-style">
								<div class="select-style"><select name="svcBfClmnLogYn"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>기동 인터페이스 유형</th>
							<td >
								<div style="position:relative;">
									<div class="select-style">
									<div class="select-style"><select name="gstatSysAdptrBzwkGroupName">
									</select>
									</div>
								</div>	
							</td>
							<th>서버 로그 레벨</th>
							<td >
								<div class="select-style">
								<div class="select-style"><select name="sevrLogLvelNo"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>서비스 로그 레벨</th>
							<td >
								<div class="select-style">
								<div class="select-style"><select name="svcLogLvelNo"></select>
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
								<div class="select-style"><select name="simYn"></select>
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
					
				<div class="table_row_title">IF 서비스 메시지 목록</div>	
				<form id="ajaxForm2">
					<table class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:20%;">서비스처리 순서</th>
							<td style="width:30%;"><input type="text" name="svcPrcssNo" /> </td>
							<th style="width:20%;">수동인터페이스유형</th>
							<td style="width:30%;"><div class="select-style"><select name="psvIntfacDsticName" /></div> </td>
						</tr>
						<tr>
							<th>수동업무구분</th><td><div class="select-style"><select name="psvSysBzwkDstcd" /></div> </td>
							<th>수동시스템ID</th><td><div class="select-style"><select name="psvSysIdName" /></div> </td>
						</tr>
						<tr>
							<th>수동시스템서비스코드</th><td><input type="text" name="psvSysSvcDsticName" /> </td>
							<th>수동시스템인터페이스유형</th><td><div class="select-style"><select name="psvSysAdptrBzwkGroupName" /></div> </td>
						</tr>
						<tr>
							<th>FailOver여부</th><td><div class="select-style"><select name="flovrYn" /></div> </td>
							<th>변환유무</th><td><div class="select-style"><select name="chngEonot" /></div> </td>
						</tr>
						<tr>
							<th>변환메시지ID</th><td colspan="3"><input type="text" name="chngMsgIdName" /> </td>
						</tr>
						<tr>
							<th>기본응답메시지비교값</th><td><input type="text" name="bascRspnsMsgCmprCtnt" /> </td>
							<th>기본응답변환유무</th><td><div class="select-style"><select name="bascRspnsChngEonot" /></div> </td>
						</tr>
						<tr>
							<th>기본응답변환메시지ID</th><td colspan="3"><input type="text" name="bascRspnsChngMsgIdName" /> </td>
							
						</tr>
						<tr>
							<th>오류응답메시지비교값</th><td><input type="text" name="errRspnsMsgCmprCtnt" /> </td>
							<th>오류응답변환유무</th><td><div class="select-style"><select name="errRspnsChngEonot" /></div> </td>
						</tr>
						<tr>
							<th>오류응답변환메시지ID</th><td colspan="3"><input type="text" name="errRspnsChngMsgIdName" /> </td>
							
						</tr>
						<tr>
							<th>다음서비스처리순서</th><td><input type="text" name="nextSvcPrcssNo" /> </td>
							<th>Outbound라우팅명</th><td><div class="select-style"><select name="outbndRoutName" /></div> </td>
						</tr>
						<tr>
							<th>타임아웃값</th><td><input type="text" name="toutVal" /> </td>
							<th>보상서비스처리코드</th><td><input type="text" name="cmpenSvcPrcssDsticName" /> </td>
						</tr>
						<tr>
							<th>추가삭제여부</th><td><div class="select-style"><select name="supplDelYn" /></div> </td>
							<th>헤더제어구분코드</th><td><div class="select-style"><select name="hdrCtrlDstcd" /></div> </td>
						</tr>
						<tr>
							<th>참고클래스명</th><td colspan="3"><input type="text" name="hdrRefClsName" /> </td>
						</tr>
						<!-- RESTOPTION 추가 시작 -->
						<tr>
							<th>REST추가내용</th><td colspan="3"><input type="text" name="restOption" /> </td>
						</tr>
						<!-- RESTOPTION 추가 종료 -->
					</table>
				</form>
				
				<div style="position:relative;">
					<div class="table_row_title">참조 메시지 ID 리스트</div>
					<div style="position:absolute;right:0; top:0;">
						<img id="btn_pop_new" src="<c:url value="/img/btn_new.png"/>" name="grid1add" class="btn_img" />
						<img id="btn_pop_delete" src="<c:url value="/img/btn_delete.png"/>" name="grid1delete" class="btn_img" />
					</div>
				</div>
				<!-- grid -->
				<table id="grid1" ></table>	
				<div style="position:relative; margin-top:15px;">
					<div class="table_row_title">조건부 라우팅 룰 리스트</div>
					<div style="position:absolute;right:0; top:0;">
						<img id="btn_pop_new" src="<c:url value="/img/btn_new.png"/>" name="grid2add" class="btn_img" />
						<img id="btn_pop_delete" src="<c:url value="/img/btn_delete.png"/>" name="grid2delete" class="btn_img" />
					</div>
				</div>
				<table id="grid2" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

