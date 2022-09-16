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

	var url ='<c:url value="/bap/transaction/transactionStatusMan.json" />';
	var stageList;
	var fileList;

	function statusFormat (cellvalue){
		if ( cellvalue == 'T' ){
			return '정상';
		}else if ( cellvalue == 'Q' ) {
			return '수행대기';
		}else if ( cellvalue == 'C' ) {
			return '사용자중지';
		}else if ( cellvalue == 'N' ) {
			return '파일없음';
		}else if ( cellvalue == 'S' ) {
			return '<span style="color:blue">진행중</span>';
		}else if ( cellvalue == 'E' ) {
			return '<span style="color:red">비정상종료</span>';
		}
		return "";
	}


	function getSubLayerName (cellvalue){
		if ( cellvalue == 'UI' ){
			return '관리화면';
		}else if ( cellvalue == 'FE' ) {
			return '파일이벤트'                  ;         
		}else if ( cellvalue == 'SS' ) {
			return '소켓서버'                    ;         
		}else if ( cellvalue == 'SQ' ) {
			return '스케쥴러(대기)'              ;         
		}else if ( cellvalue == 'SP' ) {
			return '스케쥴러(진행)'              ;         
		}else if ( cellvalue == 'FC' ) {
			return '플로우컨트롤러'              ;         
		}else if ( cellvalue == 'ST' ) {
			return 'F/C 개시 단계'               ;         
		}else if ( cellvalue == 'FI' ) {
			return 'F/C 파일정보교환 단계'       ;         
		}else if ( cellvalue == 'DS' ) {
			return 'F/C Data 송수신 단계'        ;         
		}else if ( cellvalue == 'MI' ) {
			return 'F/C 결번정보교환 단계'       ;         
		}else if ( cellvalue == 'MS' ) {
			return 'F/C 결번 송수신 단계'        ;         
		}else if ( cellvalue == 'UE' ) {
			return 'F/C 단위업무종료 단계'       ;         
		}else if ( cellvalue == 'AE' ) {
			return 'F/C 전업무종료 단계'         ;         
		}else if ( cellvalue == 'EX' ) {
			return 'F/C 예외 단계'               ;         
		}else if ( cellvalue == 'LT' ) {
			return 'F/C 시스템회선상태확인 단계' ;         
		}else if ( cellvalue == 'SE' ) {
			return 'F/C 시스템장애통보 단계'     ;         
		}else if ( cellvalue == 'SR' ) {
			return 'F/C 시스템장애회복통보 단계' ;         
		}else if ( cellvalue == 'CK' ) {
			return 'F/C 요구송신 테스트전문단계' ;         
		}
		return "";
	}

function detail(key1,key2){
	
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', bjobDmndMsgID : key1, bjobDmndSubMsgID : key2 },
		success:function(json){
			var data = json.detail;
			stageList = json.stage;
			fileList = json.file;
			$("#detailForm input,#detailForm select,#detailForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(this).val(data[name.toUpperCase()]);
			});
			
			$("#gridFile")[0].addJSONData(json);
			$("#gridStage")[0].addJSONData(json);


		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	
	var key1 ="${param.bjobDmndMsgID}";
	var key2 ="${param.bjobDmndSubMsgID}";
	$("input[name*=HMS]").inputmask("9999-99-99 99:99:99.999",{'autoUnmask':true});
	$("select").attr('disabled',true);
	$("select").css({'background-color' : '#ffffff'});
	$("input[name*=Size]").inputmask('decimal',{groupSeparator:',',digits:0,autoGroup:true,prefix:'',rightAlign:false,autoUnmask:true,removeMaskOnSubmit:true});
	detail(key1,key2);
	
	$(".tab_content").hide();
    $(".tab_content:first").show();
	
	$("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("active").css("color", "#333");
        $(this).addClass("active").css("color", "darkred");
        $(".tab_content").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).show();
    });	
	
	$('#gridFile').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 'UUID',
		             'SUBUUID',
		             '파일명',
		             '자료건수',
		             '파일크기',
		             '파일상태',
		             '파일시작시각',
		             '파일종료시각',
		             '작업구분',
		             '거래구분',
		             '파일경로',
		             '저장파일명',
		             '장애발생내용'
		              ],
		colModel : [ { name : 'BJOBDMNDMSGID'            , align : 'left'   , hidden:true },
		             { name : 'BJOBDMNDSUBMSGID'         , align : 'left'   , hidden:true },
		             { name : 'SNDRCVFILENAME'           , align : 'left'  , width:'70' },
		             { name : 'SNDRCVRECCNT'             , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'SNDRCVFILESIZE'           , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'THISSTGEPRCSSRSULTCD'     , align : 'center' , width:'70'  , formatter: statusFormat },
		             { name : 'FILETRSMTSTARTHMS'        , align : 'center' , width:'159', formatter: timeStampFormat },
		             { name : 'FILETRSMTENDHMS'          , align : 'center' , width:'159', formatter: timeStampFormat },
		             { name : 'BJOBMSGDSTICNAME'         , align : 'left'  , width:'70' },
		             { name : 'BJOBTRANDSTCDNAME'        , align : 'left'  , width:'70' },
		             { name : 'RQSTRECVFILESTORGDIRNAME' , align : 'left' , width:'70' },
		             { name : 'SNDRCVFILENAME'           , align : 'left' , width:'70' },
		             { name : 'EAIOBSTCLOCCURCAUSCTNT'   , align : 'left' , width:'200'  }
		              ],
		jsonReader : {
			root : "file",
			repeatitems : false
		},
		rowNum: 10000,
		//autoheight : true,
		height : 100, //$("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
			$("#fileForm input,#fileForm select,#fileForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(this).val(fileList[rowId-1][name.toUpperCase()]);
			});
		},
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    }	
	});
	
	$('#gridStage').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 'UUID',
		             'SUBUUID',
		             '처리단계',
                     '흐름규칙',
                     '흐름단계',
                     '흐름단계설명',
                     '흐름번호',
                     '흐름유형',
                     '전문코드',
                     '응답코드',
                     '단계상태',
                     '단계시작시각',
                     '단계종료시각',
                     '작업구분',
                     '거래구분코드',
                     '파일명',
		             '장애발생내용'
		              ],
		colModel : [ { name : 'BJOBDMNDMSGID'         , align : 'left'   , hidden:true },
		             { name : 'BJOBDMNDSUBMSGID'      , align : 'left'   , hidden:true },
		             { name : 'PRCSSSTGEDSTCD'        , align : 'left'   , width:'100' , formatter: getSubLayerName},
		             { name : 'BJOBRULECD'            , align : 'center' , width:'70' },
		             { name : 'BJOBSTGECD'            , align : 'right'  , width:'70' },
		             { name : 'BJOBSTGEFLXBLCNDNDESC' , align : 'center' , width:'159'},
		             { name : 'BJOBNODECASNO'         , align : 'center' , width:'50'},
		             { name : 'BJOBSTGEPTRNNAME'      , align : 'center' , width:'50'},
		             { name : 'TELGMPERTYPCDVALCTNT'  , align : 'left'   , width:'70' },
		             { name : 'RSPNSCDVALCTNT'        , align : 'left'   , width:'70' },
		             { name : 'THISSTGEPRCSSRSULTCD'  , align : 'center' , width:'70'  , formatter: statusFormat },
		             { name : 'THISSTGESTARTHMS'      , align : 'center' , width:'159' , formatter: timeStampFormat },
		             { name : 'THISSTGEENDHMS'        , align : 'center' , width:'159' , formatter: timeStampFormat },
		             { name : 'BJOBMSGDSTICNAME'      , align : 'left'   , width:'70' },
		             { name : 'BJOBTRANDSTCDNAME'     , align : 'left'   , width:'70' },
		             { name : 'SNDRCVFILENAME'        , align : 'left'   , width:'70' },
		             { name : 'EAIOBSTCLOCCURCAUSCTNT', align : 'left'   , width:'200'  }
		              ],
		jsonReader : {
			root : "stage",
			repeatitems : false
		},
		rowNum: 10000,
		//autoheight : true,
		height : 100, //$("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			//var rowData = $(this).getRowData(rowId);
			$("#stageForm input,#stageForm select,#stageForm textarea").each(function(){
				var name = $(this).attr("name");
				//var tag  = $(this).prop("tagName").toLowerCase();
				$(this).val(stageList[rowId-1][name.toUpperCase()]);
			});
		},
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    }	
	});
	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});

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
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">거래로그상세</div>						

	<!-- detail -->
	<form id="detailForm">
	<div class="container">
		<div class="left full" >
			<p class="comment" >▣ 거래 기본 정보</p>
		</div>
	</div>
	<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
		<tr>
			<td class="detail_title">UUID</td><td><input type="text" readonly="readonly" name="bjobDmndMsgID" style="width:100%"/></td>
			<td class="detail_title">대외기관</td><td><input type="text" readonly="readonly" name="osidInstiName" style="width:100%"/></td>
			<td class="detail_title">재시도횟수</td><td><input type="text" readonly="readonly" name="telgmReTralCnt" style="width:100%"/></td>
			<td class="detail_title">대외기관IP</td><td><input type="text" readonly="readonly" name="lnkgIPInfoName" style="width:100%"/></td>
		</tr>
		<tr>
			<td class="detail_title">SUB_UUID</td><td><input type="text" readonly="readonly" name="bjobDmndSubMsgID" style="width:100%"/></td>
			<td class="detail_title">거래처리시간</td><td><input type="text" readonly="readonly" name="tranStartHMS" style="width:100%"/></td>
			<td class="detail_title">흐름규칙코드</td><td><input type="text" readonly="readonly" name="flowRuleCd" style="width:100%"/></td>
			<td class="detail_title">메시지송신자</td><td><input type="text" readonly="readonly" name="msgSndrID" style="width:100%"/></td>
		</tr>
		<tr>
			<td class="detail_title">작업유형</td>
			<td><select name="bjobPtrnDstcd" style="width:100%">
			        <option value="AR">응답수신</option>
					<option value="AS">응답송신</option>
					<option value="RS">요구송신</option>
					<option value="RR">요구수신</option>
				</select>
			</td>
			<td class="detail_title">작업상태</td>
			<td><select name="tranPrcssDstcd" style="width:100%">
			        <option value=""></option>
			        <option value="Q">수행대기</option>
					<option value="S">진행중</option>
					<option value="T">정상종료</option>
					<option value="E">비정상종료</option>
					<option value="C">사용자중지</option>
					<option value="N">파일없음</option>
				</select>
			</td>
			<td class="detail_title">업무구분</td><td><input type="text" readonly="readonly" name="bjobBzwkDstcd" style="width:100%"/></td>
			<td class="detail_title">메시지생성시간</td><td><input type="text" readonly="readonly" name="bjobDmndMsgCretnHMS" style="width:100%"/></td>
		</tr>
	</table>
	</form>
	<div id="container-1" >
		<ul class="tabs">
			<li class="active" rel="tabFile">▣ 거래 파일 정보</li>
			<li rel="tabStage">▣ 거래 처리단계 리스트</li>
		</ul>
		<div class="tab_container" style="width:100%">
			<div id="tabFile" class="tab_content">
				<form id="fileForm">
					<table id="gridFile" ></table>
					<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
						<tr>
							<td class="detail_title">거래구분</td><td><input type="text" readonly="readonly" name="bjobMsgDstcd" style="width:100%"/></td>
							<td class="detail_title">파일크기</td><td><input type="text" readonly="readonly" name="sndrcvFileSize" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">거래파일명</td><td><input type="text" readonly="readonly" name="sndrcvFileName" style="width:100%"/></td>
							<td class="detail_title">저장된파일명</td><td><input type="text" readonly="readonly" name="bkupSndrcvFileName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">파일경로</td><td><input type="text" readonly="readonly" name="rqstRecvFileStorgDirName" style="width:100%"/></td>
							<td class="detail_title">파일처리시간</td><td><input type="text" readonly="readonly" name="fileTrsmtStartHMS" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">파일전송상태</td>
							<td><select name="thisStgePrcssRsultCd" style="width:100%">
									<option value=""></option>
									<option value="Q">수행대기</option>
									<option value="S">진행중</option>
									<option value="T">정상종료</option>
									<option value="E">비정상종료</option>
									<option value="C">사용자중지</option>
									<option value="N">파일없음</option>
								</select>
							</td>
							<td class="detail_title">파일담당자</td><td><input type="text" readonly="readonly" name="thisMsgChrgIDs" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">체크파일내용</td><td colspan=3><input type="text" readonly="readonly" name="hdrInfoName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">장애내용</td><td colspan=3><textarea  name="eAIObstclOccurCausCtnt" readonly="readonly" style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">파일 헤더 내용</td><td colspan=3><textarea  name="bjobFileHdrCtnt" readonly="readonly"  style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">파일 트레일러 내용</td><td colspan=3><textarea  name="bjobFileTrailCtnt" readonly="readonly" style="width:100%;height:100%"></textarea></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="tab_container" style="width:100%">
			<div id="tabStage" class="tab_content">
				<form id="stageForm">
					<table id="gridStage" ></table>
					<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
						<tr>
							<td class="detail_title">처리단계</td>
							<td><select name="prcssStgeDstcd" style="width:100%">
							    	<option value=" ">                   </option>
							    	<option value="UI">관리화면                   </option>
							    	<option value="FE">파일이벤트                 </option>
							    	<option value="SS">소켓서버                   </option>
							    	<option value="SQ">스케쥴러(대기)             </option>
							    	<option value="SP">스케쥴러(진행)             </option>
							    	<option value="FC">플로우컨트롤러             </option>
							    	<option value="ST">F/C 개시 단계              </option>
							    	<option value="FI">F/C 파일정보교환 단계      </option>
							    	<option value="DS">F/C Data 송수신 단계       </option>
							    	<option value="MI">F/C 결번정보교환 단계      </option>
							    	<option value="MS">F/C 결번 송수신 단계       </option>
							    	<option value="UE">F/C 단위업무종료 단계      </option>
							    	<option value="AE">F/C 전업무종료 단계        </option>
							    	<option value="EX">F/C 예외 단계              </option>
							    	<option value="LT">F/C 시스템회선상태확인 단계</option>
							    	<option value="SE">F/C 시스템장애통보 단계    </option>
							    	<option value="SR">F/C 시스템장애회복통보 단계</option>
							    	<option value="CK">F/C 요구송신 테스트전문단계</option>
							    </select>
							</td>
							<td class="detail_title">흐름규칙코드</td><td><input type="text" readonly="readonly" name="bjobRuleCd" style="width:100%"/></td>
							<td class="detail_title">흐름단계코드</td><td><input type="text" readonly="readonly" name="bjobStgeCd" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">단계수행번호</td><td><input type="text" readonly="readonly" name="bjobNodeCasNo" style="width:100%"/></td>
							<td class="detail_title">Flow클래스명</td><td><input type="text" readonly="readonly" name="bjobFlowCmpoClsName" style="width:100%"/></td>
							<td class="detail_title">단계유형</td><td><input type="text" readonly="readonly" name="bjobStgePtrnName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">전문결정수행정보<br>(RECV시)</td>
							<td>
								<table width="100%">
									<tr>
										<td>- TelegramID : </td><td><input type="text" readonly="readonly" name="telgmDcsnID" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- 클래스명  : </td><td><input type="text" readonly="readonly" name="telgmDcsnClsName" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- 전문코드  : </td><td><input type="text" readonly="readonly" name="telgmDcsnMsgCd" style="width:100%;border:0px"/></td>
									</tr>
								</table>
							</td>
							<td class="detail_title">단계수행정보</td>
							<td>
								<table width="100%">
									<tr>
										<td>- TelegramID : </td><td><input type="text" readonly="readonly" name="thisStgeTelgmID" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- 클래스명  : </td><td><input type="text" readonly="readonly" name="thisStgeClsName" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- 전문코드  : </td><td><input type="text" readonly="readonly" name="thisStgeMsgCd" style="width:100%;border:0px"/></td>
									</tr>
								</table>
							</td>
							<td class="detail_title">전문필드정보</td>
							<td>
								<table width="100%">
									<tr>
										<td>- 전문종별코드 값 : </td><td><input type="text" readonly="readonly" name="telgmPertypCdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- 거래구분코드 값 : </td><td><input type="text" readonly="readonly" name="telgmDstcdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- 업무관리코드 값 : </td><td><input type="text" readonly="readonly" name="telgmMgtCdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- 응답코드 값  : </td><td><input type="text" readonly="readonly" name="rspnsCdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td class="detail_title">거래구분</td><td><input type="text" readonly="readonly" name="bjobMsgDstcd" style="width:100%"/></td>
							<td class="detail_title">거래파일명</td><td><input type="text" readonly="readonly" name="sndrcvFileName" style="width:100%"/></td>
							<td class="detail_title">저장된파일명</td><td><input type="text" readonly="readonly" name="bkupSndrcvFileName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">파일경로</td><td><input type="text" readonly="readonly" name="rqstRecvFileStorgDirName" style="width:100%"/></td>
							<td class="detail_title">단계처리시간</td><td><input type="text" readonly="readonly" name="thisStgeStartHMS" style="width:100%"/></td>
							<td class="detail_title">단계상태</td>
							<td><select name="thisStgePrcssRsultCd" style="width:100%">
									<option value=""></option>
									<option value="Q">수행대기</option>
									<option value="S">진행중</option>
									<option value="T">정상종료</option>
									<option value="E">비정상종료</option>
									<option value="C">사용자중지</option>
									<option value="N">파일없음</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="detail_title">장애내용</td><td colspan=5><textarea  name="eAIObstclOccurCausCtnt" readonly="readonly"   style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">전문헤더</td><td colspan=5><textarea  name="bjobTelgmHdr"readonly="readonly"   style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">전문바디</td><td colspan=5><textarea  name="bjobTelgmTbody" readonly="readonly"  style="width:100%;height:100%"></textarea></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	</div>
	</body>
</html>