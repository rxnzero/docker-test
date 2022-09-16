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
   
    var eaiBzwkDstcd   = null;
    var msgDpstYMS     = null;
    var eaiSvcSerno    = null;
    var logPrcssSerno  = null;
    var serviceType    = null;
    var guid 		   = null;
	//alert(window.dialogArguments.length); 
	debugger;
	if(window.dialogArguments != null && window.dialogArguments != undefined){
		eaiBzwkDstcd   = window.dialogArguments["eaiBzwkDstcd"];
		msgDpstYMS     = window.dialogArguments["msgDpstYMS"];
		eaiSvcSerno    = window.dialogArguments["eaiSvcSerno"];
		logPrcssSerno  = window.dialogArguments["logPrcssSerno"];
		serviceType  = window.dialogArguments["serviceType"];
		if(serviceType != null && serviceType != undefined){
			sessionStorage["serviceType"] = serviceType;
		}
	}else{
		eaiBzwkDstcd   = "${param.eaiBzwkDstcd}";
		msgDpstYMS     = "${param.msgDpstYMS}";
		eaiSvcSerno    = "${param.eaiSvcSerno}";
		logPrcssSerno  = "${param.logPrcssSerno}";
		serviceType		="${param.serviceType}";
		searchDate 	   = "${param.searchDate}";
		guid 		   = "${param.guid}";
		sessionStorage["serviceType"] = serviceType;
		
		//alert(sessionStorage["serviceType"]);
		//alert("eaiBzwkDstcd="+eaiBzwkDstcd+","+"msgDpstYMS="+msgDpstYMS+","+"eaiSvcSerno="+eaiSvcSerno+","+"logPrcssSerno="+logPrcssSerno+",");
	}
	var eaiMsg		   = "";

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
			data:{cmd: 'DETAIL',serviceType:serviceType,guid:guid,searchDate:searchDate, eaiSvcSerno : eaiSvcSerno, logPrcssSerno:logPrcssSerno,eaiBzwkDstcd:eaiBzwkDstcd,msgDpstYMS:msgDpstYMS },
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
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
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
	resizeJqGridWidth('grid','container-1','800');
	resizeJqGridWidth('grid1','container-1','800');
	resizeJqGridWidth('grid2','container-1','800');
	resizeJqGridWidth('grid3','container-1','800');
    $(".tab_content").hide();
    $(".tab_content:first").show();

    $("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("active").css("color", "#333");
        $(this).addClass("active").css("color", "darkred");
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
	
	$("input[name=msgDpstYMS],input[name=msgPrcssYMS]").inputmask("9999-99-99 99:99:99.999",{'autoUnmask':true});
	
	$("#sp_bzwkData").dblclick(function(){
		window.clipboardData.setData("Text", eaiMsg);
	});

});

 
</script>
</head>
	<body>

	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">로그검색 상세보기</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	

	<!-- button -->
	<table width="790px" height="35px" >
	<tr>
		<td align="right">
			<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>" />
		</td>
	</tr>
	</table>	
	<!-- detail -->
	<form id="ajaxForm">
	<table width="790px" border="0" cellpadding="0" cellspacing="0" bordercolor="#000000">
	<tr>
		<td>
	[공통 정보]
		</td>
	</tr>	
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">업무구분코드</td><td width="30%"><input type="text" name="eaiBzwkDstcd" style="width:100%" readonly="readonly"/> </td>
				<td width="20%" class="detail_title">메시지수신일시</td><td width="30%"><input type="text" name="msgDpstYMS" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">IF서비스코드</td><td><input type="text" name="eaiSvcName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">메시지처리일시</td><td><input type="text" name="msgPrcssYMS" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">EAI서비스 설명</td><td colspan="3"><input type="text" name="eaiSvcDesc" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">전문고유번호</td><td><input type="text" name="keyMgtMsgCtnt" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">로그처리일련번호</td><td><input type="text" name="logPrcssSerno" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">IF서비스일련번호</td><td><input type="text" name="eaiSvcSerno" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">IF서비스인스턴스명</td><td><input type="text" name="eaiSevrInstncName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">GUID</td><td><input type="text" name="guid" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">서비스시각유무</td><td><input type="text" name="svcHMSEonot" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>
	<tr>
		<td>
			<div id="container-1" style="width:780px;height:300px">
				<ul class="tabs">
					<li class="active" rel="tab1">업무데이터</li>
					<li rel="tab2">헤더부</li>
					<li rel="tab3">공통부</li>
					<li rel="tab4">메시지부</li>
					<li rel="tab5">에러</li>
					
				</ul>
				<div class="tab_container" style="width:100%;">
					<div id="tab1" class="tab_content" >
						<table id="grid" ></table>
						<table class="table_detail" width="100%" height="205px" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
							<tr>
								<td colspan="2" ><span id="sp_bzwkData">[업무데이터]</span><img id="btn_xml" src="<c:url value="/images/bt/bt_show_xml.gif"/>" class="button_postion" style="display:none" />
								<img id="btn_ebcdic" src="<c:url value="/images/bt/bt_detail.gif"/>" class="button_postion" style="display:none" /></td>
							</tr>				
							<tr>
								<td colspan="2"><textarea rows="" cols="" name="bzwkDataCtnt" style="width: 100%;height:175px"></textarea></td>
							</tr>
						</table>
					</div>
					<div id="tab2" class="tab_content">
						<table id="grid1" ></table>
					</div>
					<div id="tab3" class="tab_content">
						<table id="grid2" ></table>
					</div>
					<div id="tab4" class="tab_content">
						<table id="grid3" ></table>
					</div>
					<div id="tab5" class="tab_content">
						<table class="table_detail" width="100%" height="260px" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">	
						<tr>
						<td colspan="2">[에러정보]</td>
							</tr>
							<tr>
								<td width="15%" class="detail_title">IF에러코드</td>
								<td width="85%" ><input type="text" name="eaiErrCd" style="width:100%"/></td>
							</tr>
							<tr>
								<td width="100%" colspan="2"><textarea rows="" cols="" name="eaiErrCtnt" style="width: 100%;height:236px"></textarea></td>
							</tr>
						</table>
					</div>
															
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td>
		[기동(INBOUND)]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">서비스동기사용구분코드</td><td width="30%"><input type="text" name="svcMotivUseDstcd" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">기동시스템어댑터업무그룹명</td><td width="25%"><input type="text" name="gstatSysAdptrBzwkGroupName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">흐름통제라우팅명</td><td><input type="text" name="flowCtrlRoutName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">표준메시지사용여부</td><td><input type="text" name="stndMsgUseYn" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">서비스처리구분명</td><td><input type="text" name="svcPrcssDsticName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">서비스전컬럼로그여부</td><td><input type="text" name="svcBfClmnLogYn" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">서비스처리번호</td><td><input type="text" name="svcPrcssNo" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">통합구분명</td><td><input type="text" name="intgraDsticName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">기동서비스구분명</td><td><input type="text" name="gstatSvcDsticName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">현재메시지ID명</td><td><input type="text" name="prsntMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>		
	<tr>
		<td>
		[수동(OUTBOUND)]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">수동인터페이스구분명</td><td width="30%"><input type="text" name="psvIntfacDsticName" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">수동시스템어댑터업무그룹명</td><td width="25%"><input type="text" name="psvSysAdptrBzwkGroupName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">아웃바운드라우팅명</td><td><input type="text" name="outbndRoutName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">타임아웃값</td><td><input type="text" name="toutVal" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">수동시스템서비스구분명</td><td><input type="text" name="psvSysSvcDsticName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">수동업무시스템명</td><td><input type="text" name="psvBzwkSysName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">응답에러필드명</td><td><input type="text" name="rspnsErrFldName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">수동시스템ID명</td><td><input type="text" name="psvSysIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>		
	<tr>
		<td>
		[변화(MAPPING)]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">요청 매핑여부</td><td width="30%"><input type="text" name="chngYn" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">요청 전문레이아웃매핑코드</td><td width="25%"><input type="text" name="chngMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">응답 매핑여부</td><td><input type="text" name="bascRspnsChngYn" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">응답 전문레이아웃매핑코드</td><td><input type="text" name="bascRspnsChngMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">오류응답 매핑여부</td><td><input type="text" name="errRspnsChngYn" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">오류 전문레이아웃매핑코드</td><td><input type="text" name="errRspnsChngMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">요청 전문레이아웃코드</td><td><input type="text" name="inptMsgIDName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">오류응답메시지비교내용</td><td><input type="text" name="errRspnsMsgCmprCtnt" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">기본응답메시지비교내용</td><td><input type="text" name="bascRspnsMsgCmprCtnt" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">장애극복여부</td><td><input type="text" name="flovrYn" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>		
	<tr>
		<td>
		[기타정보]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">응답에러코드명</td><td width="30%"><input type="text" name="rspnsErrcdName" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">서버로그레벨번호</td><td width="25%"><input type="text" name="sevrLogLvelNo" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">서비스로그레벨번호</td><td><input type="text" name="svcLogLvelNo" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">오류EAI서비스명</td><td><input type="text" name="errEAISvcName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">요청오류변환ID명</td><td><input type="text" name="dmndErrChngIDName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">요청에러필드명</td><td><input type="text" name="dmndErrFldName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">응답오류변환ID명</td><td><input type="text" name="rspnsErrChngIdName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">다음서비스처리번호</td><td><input type="text" name="nextSvcPrcssNo" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">서버그룹명</td><td><input type="text" name="sevrGroupName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">보상서비스처리명</td><td><input type="text" name="cmpenSvcPrcssName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">추적보조키1내용</td><td><input type="text" name="trackAsisKey1Ctnt" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">추적보조키2내용</td><td><input type="text" name="trackAsisKey2Ctnt" style="width:100%" readonly="readonly"/> </td>
			</tr>			
		</table>	
		</td>
	</tr>		
	</table>

	</form>
	
	</body>
</html>

