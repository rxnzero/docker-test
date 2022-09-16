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
    var eaiBzwkDstcd   = window.dialogArguments["eaiBzwkDstcd"];
    var msgDpstYMS     = window.dialogArguments["msgDpstYMS"];
    var eaiSvcSerno    = window.dialogArguments["eaiSvcSerno"];
    var logPrcssSerno  = window.dialogArguments["logPrcssSerno"];

	var eaiMsg		   = "";
    //var eaiBzwkDstcd   = "${param.eaiBzwkDstcd}";
   // var msgDpstYMS     = "${param.msgDpstYMS}";
    //var eaiSvcSerno    = "${param.eaiSvcSerno}";
   	//var logPrcssSerno  = "${param.logPrcssSerno}";
   //alert("eaiBzwkDstcd="+eaiBzwkDstcd+","+"msgDpstYMS="+msgDpstYMS+","+"eaiSvcSerno="+eaiSvcSerno+","+"logPrcssSerno="+logPrcssSerno+",");

	// 데이터의 왼쪽에 0으로 채우는 함수 (표준전문 헤더의 전문길이 8자리 포맷 지정)
	function lpad(str, len, chr)
	{
		var max = 0;
		
		if(!str || !chr || str.length >= len)
		{
			return str;
		}
		
		max = len-str.length;
		for(var i = 0; i < max; i++)
		{
			str = chr + str;
		}
		
		return str;
	}
	
	// 문자열 Byte 계산 함수 (표준전문 전체 길이 체크)
	function getBytes(str) {
		var orgVal = str;
		var bytes =0;
		
		for( var k=0;k < orgVal.length;k++) {
			var tmp = orgVal.charAt(k);
			var b=0;
			if(escape(tmp).length > 4) {
				b=2;
			} else if( tmp != '\r' ) {  // 리눅스는 \r를 인식하지 못함
				b=1;
			}
			bytes += b;
		}
		
		return bytes;
	}
	
	// 표준전문 생성 함수
	function getMsg(msgHeader, msgCommon, msgMsg, msgDataheader, msgBzwkdatactnt)
	{
		var tempEaiMsg = "";
		
		if(msgMsg == null)
		{
			tempEaiMsg = msgHeader + msgCommon + msgDataheader + msgBzwkdatactnt + "@@";
		}
		else
		{
			tempEaiMsg = msgHeader + msgCommon + msgMsg + msgDataheader + msgBzwkdatactnt + "@@";
		}
		
		return tempEaiMsg;
	}
	
	function detail(url){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL', eaiSvcSerno : eaiSvcSerno, logPrcssSerno:logPrcssSerno,eaiBzwkDstcd:eaiBzwkDstcd,msgDpstYMS:msgDpstYMS },
			success:function(json){
				var data = json;
				$("#ajaxForm input,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					if (name == null || name==undefined || name=="") return;
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
					
				});
				
				//에러시 에러탭이 보이도록
				if($("textarea[name=eaiErrCtnt]").val().trim() != ""){
					 $("ul.tabs li[rel=tab5]").click();
				}
				
				$("#grid")[0].addJSONData(json);	//데이터부
				$("#grid1")[0].addJSONData(json);	//헤더부
				$("#grid2")[0].addJSONData(json);	//공통부
				$("#grid3")[0].addJSONData(json);	//메시지부
				
				if(json.xmlDataYn =="Y"){
					$("#btn_xml").show();
				}
				else {
					$("#btn_xml").hide();
				}
								
				var header				= data["HEADER"];
				var common				= data["COMMON"];
				var msg					= data["MSG"];
				var dataheader			= data["DATAHEADER"];
				var bzwkdatactnt		= data["BZWKDATACTNT"];
				
				var headerLen			= 0;
				var headerBody			= "";
				var tempEaiMsgByteLen	= 0;
				var tempEaiMsg			= "";
				
				tempEaiMsg = getMsg(header, common, msg, dataheader, bzwkdatactnt);
				tempEaiMsgByteLen = getBytes(tempEaiMsg);
				
				headerLen	= parseInt(header.substr(0, 8), 10);
				headerBody	= header.substr(8);
				
				if(headerLen == tempEaiMsgByteLen)
				{
					eaiMsg = tempEaiMsg;
				}
				else
				{
					headerLen	= tempEaiMsgByteLen.toString();
					header		= lpad(headerLen, 8, '0') + headerBody;
					eaiMsg		= getMsg(header, common, msg, dataheader, bzwkdatactnt);
				}
				
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	function copy(obj){
        var sel = obj.jqGrid('getGridParam', 'selrow');
		var colmodel = obj.jqGrid('getGridParam',"colModel");

		data = "";
		for (var col = 1 ;col < colmodel.length;col++){
			if(!colmodel[col].hidden ){
				data += obj.jqGrid('getCell',sel,colmodel[col].name)+"	";
			}
		}
		data +="\n";
		window.clipboardData.setData("Text",data);
	}	

$(document).ready(function() {	
	var url ='<c:url value="/onl/transaction/tracking/trackingMan.json" />';
	detail(url);	
	$('#grid').jqGrid({	//데이터부
		datatype : "json",
		mtype : 'POST',
		colNames : [ '순번',
		             '필드명',
		             '한글명',
		             '데이터',
		             '데이터길이'
		              ],
		colModel : [ { name : 'index'     , align : 'center' , width:'60' },
		             { name : 'fieldName' , align : 'left'   , width:'200' },
		             { name : 'korName'   , align : 'left'   },
		             { name : 'data'      , align : 'left'   , width:'226'},
		             { name : 'dataLen'   , align : 'center' , width:'80' }
		              ],
		jsonReader : {
			repeatitems : false,
			root : "dataRows"
		},
		rowNum: 10000,
		height : "50px",
		autowidth : true,
		viewrecords : true
		
	});
	$('#grid1').jqGrid({	//헤더부
		datatype : "json",
		mtype : 'POST',
		colNames : [ '순번',
		             '필드명',
		             '한글명',
		             '데이터',
		             '데이터길이'
		              ],
		colModel : [ { name : 'index'     , align : 'center' , width:'60' },
		             { name : 'fieldName' , align : 'left'   , width:'200' },
		             { name : 'korName'   , align : 'left'   },
		             { name : 'data'      , align : 'left'   , width:'226'},
		             { name : 'dataLen'   , align : 'center' , width:'80' }
		              ],
		jsonReader : {
			repeatitems : false,
			root : "hdrRows"
		},
		rowNum: 10000,
		height : "255px",
		autowidth : true,
		viewrecords : true
		
	});
	$('#grid2').jqGrid({	//공통부
		datatype : "json",
		mtype : 'POST',
		colNames : [ '순번',
		             '필드명',
		             '한글명',
		             '데이터',
		             '데이터길이'
		              ],
		colModel : [ { name : 'index'     , align : 'center' , width:'60' },
		             { name : 'fieldName' , align : 'left'   , width:'200' },
		             { name : 'korName'   , align : 'left'   },
		             { name : 'data'      , align : 'left'   , width:'226'},
		             { name : 'dataLen'   , align : 'center' , width:'80' }
		              ],
		jsonReader : {
			repeatitems : false,
			root : "comRows"
		},
		rowNum: 10000,
		height : "255px",
		autowidth : true,
		viewrecords : true
		
	});
	$('#grid3').jqGrid({	//메시지
		datatype : "json",
		mtype : 'POST',
		colNames : [ '순번',
		             '필드명',
		             '한글명',
		             '데이터',
		             '데이터길이'
		              ],
		colModel : [ { name : 'index'     , align : 'center' , width:'60' },
		             { name : 'fieldName' , align : 'left'   , width:'200' },
		             { name : 'korName'   , align : 'left'   },
		             { name : 'data'      , align : 'left'   , width:'226'},
		             { name : 'dataLen'   , align : 'center' , width:'80' }
		              ],
		jsonReader : {
			repeatitems : false,
			root : "msgRows"
		},
		rowNum: 10000,
		height : "255px",
		autowidth : true,
		viewrecords : true
		
	});
	
	
	$("#grid,#grid1,#grid2,#grid3").keydown(function(e){
		if(e.ctrlKey && e.keyCode ==67){
			copy($(this));
		} 
	});
	resizeJqGridWidth('grid','tab1','780');
	resizeJqGridWidth('grid1','tab2','780');
	resizeJqGridWidth('grid2','tab3','780');
	resizeJqGridWidth('grid3','tab4','780');
    $(".tab_content").hide();
    $(".tab_content:first").show();

    $("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("active");
        $(this).addClass("active");
        $(".tab_content").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).show();
    });	

	$("#btn_close").click(function(){
		window.close();
	});
	$("#btn_xml").click(function(){
		var url = '<c:url value="/onl/transaction/tracking/trackingMan.json" />';
		url += "?cmd=DETAIL_XML";
		url += '&eaiSvcSerno='   +$("input[name=eaiSvcSerno]").val();
		url += '&msgDpstYMS='    +$("input[name=msgDpstYMS]").val();
		url += '&eaiBzwkDstcd='  +$("input[name=eaiBzwkDstcd]").val();
		url += '&logPrcssSerno=' +$("input[name=logPrcssSerno]").val();
		var showXml = windowOpen(url,"showXML",700,600);
		showXml.focus();
	});
	
	$("#btn_ebcdic").click(function(){
		var url = '<c:url value="/onl/transaction/tracking/trackingMan.json" />';
		url += "?cmd=DETAIL_EBCDIC";
		url += '&eaiSvcSerno='   +$("input[name=eaiSvcSerno]").val();
		url += '&msgDpstYMS='    +$("input[name=msgDpstYMS]").val();
		url += '&eaiBzwkDstcd='  +$("input[name=eaiBzwkDstcd]").val();
		url += '&logPrcssSerno=' +$("input[name=logPrcssSerno]").val();
		var showXml = windowOpen(url,"showMessage",700,600);
		showXml.focus();
	});
	
	$("input[name=inptMsgIDName]").dblclick(function(){
		var layoutName = $(this).val();
		if($.trim(layoutName) =="") return;

		 var args = new Object();

		var url = '<c:url value="/onl/admin/rule/layoutMan.view" />';
		url += "?cmd=DETAILPOPUP";
        url += '&loutName='+layoutName;
        url += '&pop=true';
	    
	    showModal(url,args,1200,800); 
	});
	$("input[name=chngMsgIdName], input[name=bascRspnsChngMsgIdName],input[name=errRspnsChngMsgIdName]").dblclick(function(){
		var name = $(this).attr('name');
		if($.trim(name) =="") return;
		
		var args = new Object();
    	
   		var eaiSvcName 	= $("input[name=eaiSvcName]").val();
		var cnvsnName 	= $(this).val();
		//args['cnvsnDesc'] = $("input[name=cnvsnName_"+gbn+"]").val();
   	
        
        var url='<c:url value="/onl/transaction/tracking/trackingMan.view"/>';
        url += '?cmd=TRANSFORMPOPUP';
   
         //key값
        url += '&cnvsnName='+cnvsnName;
        url += '&eaiSvcName='+eaiSvcName;

	    var ret = showModal(url,args,1600,900);
		
	

	});
	$("input[name=msgDpstYMS],input[name=msgPrcssYMS]").inputmask("9999-99-99 99:99:99.999",{'autoUnmask':true});
	
	$("#sp_bzwkData").dblclick(function(){
		window.clipboardData.setData("Text", eaiMsg);
	});

});

 
</script>
<style>
.dialog_confirm{
	
/* 	position : absolute; */
	left:0px;
	top: 0px;
	width:100%;
	height:100%;
	text-align:center;
	z-index:1000;
}
</style>
</head>
	<body>
		<div class="popup_box">
			<div class="search_wrap">
				<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" />
			</div>
			<div class="title">로그검색 상세보기</div>
			
			<form id="ajaxForm">
				<div class="table_row_title">공통 정보</div>
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">업무구분코드</th>
						<td style="width:30%;"><input type="text" name="eaiBzwkDstcd" readonly="readonly"/> </td>
						<th style="width:20%;">메시지수신일시</th>
						<td style="width:30%;"><input type="text" name="msgDpstYMS" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>IF서비스코드</td><td><input type="text" name="eaiSvcName" readonly="readonly"/> </td>
						<th>메시지처리일시</td><td><input type="text" name="msgPrcssYMS" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>EAI서비스 설명</td><td colspan="3"><input type="text" name="eaiSvcDesc" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>전문고유번호</td><td><input type="text" name="keyMgtMsgCtnt" readonly="readonly"/> </td>
						<th>로그처리일련번호</td><td><input type="text" name="logPrcssSerno" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>IF서비스일련번호</td><td><input type="text" name="eaiSvcSerno" readonly="readonly"/> </td>
						<th>IF서비스인스턴스명</td><td><input type="text" name="eaiSevrInstncName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>GUID</td><td><input type="text" name="guid" readonly="readonly"/> </td>
						<th>서비스시각유무</td><td><input type="text" name="svcHMSEonot" readonly="readonly"/> </td>
					</tr>
				</table>				
				<div id="container-1">
					<ul class="tabs">
						<li class="active" rel="tab1">업무데이터</li>
						<li rel="tab2">헤더부</li>
						<li rel="tab3">공통부</li>
						<li rel="tab4">메시지부</li>
						<li rel="tab5">에러</li>					
					</ul>
					<div class="tab_container">
						<div id="tab1" class="tab_content" >
							<table id="grid" ></table>
							<div style="margin:15px 0;">
							<table><tr><td>
							<span id="sp_bzwkData">[업무데이터]</span></td>
							<td>&nbsp;&nbsp;<img id="btn_xml" src="<c:url value="/img/btn_show_xml.png" />" class="btn_img" /></td>
							</tr></table>
<%-- 							<img id="btn_ebcdic" src="<c:url value="/img/btn_detail.png" />" class="btn_img" /> --%>
							</div>
							<table class="table_row" cellspacing="0">												
								<tr>
									<td><textarea rows="" cols="" name="bzwkDataCtnt" style="width: 100%;height:125px"></textarea></td>
								</tr>
							</table>
						</div><!-- end#tab1 -->
						<div id="tab2" class="tab_content">
							<table id="grid1" ></table>
						</div><!-- end#tab2 -->
						<div id="tab3" class="tab_content">
							<table id="grid2" ></table>
						</div><!-- end#tab3 -->
						<div id="tab4" class="tab_content">
							<table id="grid3" ></table>
						</div><!-- end#tab4 -->
						<div id="tab5" class="tab_content">
							<div style="margin-bottom:15px;">[에러정보]</div>
							<table class="table_row" cellspacing="0">								
								<tr>
									<th style="width:20%;">IF에러코드</th>
									<td style="width:80%;"><input type="text" name="eaiErrCd"/></td>
								</tr>
								<tr>
									<td colspan="2"><textarea rows="" cols="" name="eaiErrCtnt" style="width: 100%;height:205px"></textarea></td>
								</tr>
							</table>
						</div><!-- end#tab5 -->															
					</div><!-- end.tab_container -->
				</div><!-- end.container-1 -->
				<div class="table_row_title">기동(INBOUND)</div>			
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">서비스동기사용구분코드</th>
						<td style="width:30%;"><input type="text" name="svcMotivUseDstcd" readonly="readonly"/> </td>
						<th style="width:20%;">기동시스템어댑터업무그룹명</th>
						<td style="width:30%;"><input type="text" name="gstatSysAdptrBzwkGroupName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>흐름통제라우팅명</td><td><input type="text" name="flowCtrlRoutName" readonly="readonly"/> </td>
						<th>표준메시지사용여부</td><td><input type="text" name="stndMsgUseYn" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>서비스처리구분명</td><td><input type="text" name="svcPrcssDsticName" readonly="readonly"/> </td>
						<th>서비스전컬럼로그여부</td><td><input type="text" name="svcBfClmnLogYn" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>서비스처리번호</td><td><input type="text" name="svcPrcssNo" readonly="readonly"/> </td>
						<th>통합구분명</td><td><input type="text" name="intgraDsticName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>기동서비스구분명</td><td><input type="text" name="gstatSvcDsticName" readonly="readonly"/> </td>
						<th>현재메시지ID명</td><td><input type="text" name="prsntMsgIdName" readonly="readonly"/> </td>
					</tr>
				</table>	
				<div class="table_row_title">수동(OUTBOUND)</div>	
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">수동인터페이스구분명</th>
						<td style="width:30%;"><input type="text" name="psvIntfacDsticName" readonly="readonly"/> </td>
						<th style="width:20%;">수동시스템어댑터업무그룹명</th>
						<td style="width:30%;"><input type="text" name="psvSysAdptrBzwkGroupName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>아웃바운드라우팅명</th><td><input type="text" name="outbndRoutName" readonly="readonly"/> </td>
						<th>타임아웃값</th><td><input type="text" name="toutVal" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>수동시스템서비스구분명</th><td><input type="text" name="psvSysSvcDsticName" readonly="readonly"/> </td>
						<th>수동업무시스템명</th><td><input type="text" name="psvBzwkSysName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>응답에러필드명</th><td><input type="text" name="rspnsErrFldName" readonly="readonly"/> </td>
						<th>수동시스템ID명</th><td><input type="text" name="psvSysIdName" readonly="readonly"/> </td>
					</tr>
				</table>	
				<div class="table_row_title">변화(MAPPING)</div>	
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">요청 매핑여부</th>
						<td style="width:30%;"><input type="text" name="chngYn" readonly="readonly"/> </td>
						<th style="width:20%;">요청 전문레이아웃매핑코드</th>
						<td style="width:30%;"><input type="text" name="chngMsgIdName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>응답 매핑여부</th><td><input type="text" name="bascRspnsChngYn" readonly="readonly"/> </td>
						<th>응답 전문레이아웃매핑코드</td><td><input type="text" name="bascRspnsChngMsgIdName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>오류응답 매핑여부</th><td><input type="text" name="errRspnsChngYn" readonly="readonly"/> </td>
						<th>오류 전문레이아웃매핑코드</td><td><input type="text" name="errRspnsChngMsgIdName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>요청 전문레이아웃코드</th><td><input type="text" name="inptMsgIDName" readonly="readonly"/> </td>
						<th>오류응답메시지비교내용</th><td><input type="text" name="errRspnsMsgCmprCtnt" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>기본응답메시지비교내용</th><td><input type="text" name="bascRspnsMsgCmprCtnt" readonly="readonly"/> </td>
						<th>장애극복여부</th><td><input type="text" name="flovrYn" readonly="readonly"/> </td>
					</tr>
				</table>	
				<div class="table_row_title">기타정보</div>				
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">응답에러코드명</th>
						<td style="width:30%;"><input type="text" name="rspnsErrcdName" readonly="readonly"/> </td>
						<th style="width:20%;">서버로그레벨번호</th>
						<td style="width:30%;"><input type="text" name="sevrLogLvelNo" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>서비스로그레벨번호</th><td><input type="text" name="svcLogLvelNo" readonly="readonly"/> </td>
						<th>오류EAI서비스명</th><td><input type="text" name="errEAISvcName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>요청오류변환ID명</th><td><input type="text" name="dmndErrChngIDName" readonly="readonly"/> </td>
						<th>요청에러필드명</th><td><input type="text" name="dmndErrFldName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>응답오류변환ID명</th><td><input type="text" name="rspnsErrChngIdName" readonly="readonly"/> </td>
						<th>다음서비스처리번호</th><td><input type="text" name="nextSvcPrcssNo" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>서버그룹명</th><td><input type="text" name="sevrGroupName" readonly="readonly"/> </td>
						<th>보상서비스처리명</th><td><input type="text" name="cmpenSvcPrcssName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>추적보조키1내용</th><td><input type="text" name="trackAsisKey1Ctnt" readonly="readonly"/> </td>
						<th>추적보조키2내용</th><td><input type="text" name="trackAsisKey2Ctnt" readonly="readonly"/> </td>
					</tr>			
				</table>
			</form>			
		</div><!-- end.popup_box -->
	</body>
</html>

