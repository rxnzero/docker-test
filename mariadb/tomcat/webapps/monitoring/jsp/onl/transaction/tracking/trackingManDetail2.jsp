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

	// �������� ���ʿ� 0���� ä��� �Լ� (ǥ������ ����� �������� 8�ڸ� ���� ����)
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
	
	// ���ڿ� Byte ��� �Լ� (ǥ������ ��ü ���� üũ)
	function getBytes(str) {
		var orgVal = str;
		var bytes =0;
		
		for( var k=0;k < orgVal.length;k++) {
			var tmp = orgVal.charAt(k);
			var b=0;
			if(escape(tmp).length > 4) {
				b=2;
			} else if( tmp != '\r' ) {  // �������� \r�� �ν����� ����
				b=1;
			}
			bytes += b;
		}
		
		return bytes;
	}
	
	// ǥ������ ���� �Լ�
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
				
				//������ �������� ���̵���
				if($("textarea[name=eaiErrCtnt]").val().trim() != ""){
					 $("ul.tabs li[rel=tab5]").click();
				}
				
				$("#grid")[0].addJSONData(json);	//�����ͺ�
				$("#grid1")[0].addJSONData(json);	//�����
				$("#grid2")[0].addJSONData(json);	//�����
				$("#grid3")[0].addJSONData(json);	//�޽�����
				
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
	$('#grid').jqGrid({	//�����ͺ�
		datatype : "json",
		mtype : 'POST',
		colNames : [ '����',
		             '�ʵ��',
		             '�ѱ۸�',
		             '������',
		             '�����ͱ���'
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
	$('#grid1').jqGrid({	//�����
		datatype : "json",
		mtype : 'POST',
		colNames : [ '����',
		             '�ʵ��',
		             '�ѱ۸�',
		             '������',
		             '�����ͱ���'
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
	$('#grid2').jqGrid({	//�����
		datatype : "json",
		mtype : 'POST',
		colNames : [ '����',
		             '�ʵ��',
		             '�ѱ۸�',
		             '������',
		             '�����ͱ���'
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
	$('#grid3').jqGrid({	//�޽���
		datatype : "json",
		mtype : 'POST',
		colNames : [ '����',
		             '�ʵ��',
		             '�ѱ۸�',
		             '������',
		             '�����ͱ���'
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
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">�αװ˻� �󼼺���</p>
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
	[���� ����]
		</td>
	</tr>	
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">���������ڵ�</td><td width="30%"><input type="text" name="eaiBzwkDstcd" style="width:100%" readonly="readonly"/> </td>
				<td width="20%" class="detail_title">�޽��������Ͻ�</td><td width="30%"><input type="text" name="msgDpstYMS" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">IF�����ڵ�</td><td><input type="text" name="eaiSvcName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">�޽���ó���Ͻ�</td><td><input type="text" name="msgPrcssYMS" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">EAI���� ����</td><td colspan="3"><input type="text" name="eaiSvcDesc" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">����������ȣ</td><td><input type="text" name="keyMgtMsgCtnt" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">�α�ó���Ϸù�ȣ</td><td><input type="text" name="logPrcssSerno" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">IF�����Ϸù�ȣ</td><td><input type="text" name="eaiSvcSerno" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">IF�����ν��Ͻ���</td><td><input type="text" name="eaiSevrInstncName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">GUID</td><td><input type="text" name="guid" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">���񽺽ð�����</td><td><input type="text" name="svcHMSEonot" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>
	<tr>
		<td>
			<div id="container-1" style="width:780px;height:300px">
				<ul class="tabs">
					<li class="active" rel="tab1">����������</li>
					<li rel="tab2">�����</li>
					<li rel="tab3">�����</li>
					<li rel="tab4">�޽�����</li>
					<li rel="tab5">����</li>
					
				</ul>
				<div class="tab_container" style="width:100%;">
					<div id="tab1" class="tab_content" >
						<table id="grid" ></table>
						<table class="table_detail" width="100%" height="205px" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
							<tr>
								<td colspan="2" ><span id="sp_bzwkData">[����������]</span><img id="btn_xml" src="<c:url value="/images/bt/bt_show_xml.gif"/>" class="button_postion" style="display:none" />
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
						<td colspan="2">[��������]</td>
							</tr>
							<tr>
								<td width="15%" class="detail_title">IF�����ڵ�</td>
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
		[�⵿(INBOUND)]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">���񽺵����뱸���ڵ�</td><td width="30%"><input type="text" name="svcMotivUseDstcd" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">�⵿�ý��۾���;����׷��</td><td width="25%"><input type="text" name="gstatSysAdptrBzwkGroupName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">�帧��������ø�</td><td><input type="text" name="flowCtrlRoutName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">ǥ�ظ޽�����뿩��</td><td><input type="text" name="stndMsgUseYn" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">����ó�����и�</td><td><input type="text" name="svcPrcssDsticName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">�������÷��α׿���</td><td><input type="text" name="svcBfClmnLogYn" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">����ó����ȣ</td><td><input type="text" name="svcPrcssNo" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">���ձ��и�</td><td><input type="text" name="intgraDsticName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">�⵿���񽺱��и�</td><td><input type="text" name="gstatSvcDsticName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">����޽���ID��</td><td><input type="text" name="prsntMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>		
	<tr>
		<td>
		[����(OUTBOUND)]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">�����������̽����и�</td><td width="30%"><input type="text" name="psvIntfacDsticName" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">�����ý��۾���;����׷��</td><td width="25%"><input type="text" name="psvSysAdptrBzwkGroupName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">�ƿ��ٿ�����ø�</td><td><input type="text" name="outbndRoutName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">Ÿ�Ӿƿ���</td><td><input type="text" name="toutVal" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">�����ý��ۼ��񽺱��и�</td><td><input type="text" name="psvSysSvcDsticName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">���������ý��۸�</td><td><input type="text" name="psvBzwkSysName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">���信���ʵ��</td><td><input type="text" name="rspnsErrFldName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">�����ý���ID��</td><td><input type="text" name="psvSysIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>		
	<tr>
		<td>
		[��ȭ(MAPPING)]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">��û ���ο���</td><td width="30%"><input type="text" name="chngYn" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">��û �������̾ƿ������ڵ�</td><td width="25%"><input type="text" name="chngMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">���� ���ο���</td><td><input type="text" name="bascRspnsChngYn" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">���� �������̾ƿ������ڵ�</td><td><input type="text" name="bascRspnsChngMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">�������� ���ο���</td><td><input type="text" name="errRspnsChngYn" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">���� �������̾ƿ������ڵ�</td><td><input type="text" name="errRspnsChngMsgIdName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">��û �������̾ƿ��ڵ�</td><td><input type="text" name="inptMsgIDName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">��������޽����񱳳���</td><td><input type="text" name="errRspnsMsgCmprCtnt" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">�⺻����޽����񱳳���</td><td><input type="text" name="bascRspnsMsgCmprCtnt" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">��ֱغ�����</td><td><input type="text" name="flovrYn" style="width:100%" readonly="readonly"/> </td>
			</tr>
		</table>	
		</td>
	</tr>		
	<tr>
		<td>
		[��Ÿ����]
		</td>
	</tr>
	<tr>
		<td>
		<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
			<tr>
				<td width="20%" class="detail_title">���信���ڵ��</td><td width="30%"><input type="text" name="rspnsErrcdName" style="width:100%" readonly="readonly"/> </td>
				<td width="25%" class="detail_title">�����α׷�����ȣ</td><td width="25%"><input type="text" name="sevrLogLvelNo" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">���񽺷α׷�����ȣ</td><td><input type="text" name="svcLogLvelNo" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">����EAI���񽺸�</td><td><input type="text" name="errEAISvcName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">��û������ȯID��</td><td><input type="text" name="dmndErrChngIDName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">��û�����ʵ��</td><td><input type="text" name="dmndErrFldName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">���������ȯID��</td><td><input type="text" name="rspnsErrChngIdName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">��������ó����ȣ</td><td><input type="text" name="nextSvcPrcssNo" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">�����׷��</td><td><input type="text" name="sevrGroupName" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">���󼭺�ó����</td><td><input type="text" name="cmpenSvcPrcssName" style="width:100%" readonly="readonly"/> </td>
			</tr>
			<tr>
				<td class="detail_title">��������Ű1����</td><td><input type="text" name="trackAsisKey1Ctnt" style="width:100%" readonly="readonly"/> </td>
				<td class="detail_title">��������Ű2����</td><td><input type="text" name="trackAsisKey2Ctnt" style="width:100%" readonly="readonly"/> </td>
			</tr>			
		</table>	
		</td>
	</tr>		
	</table>

	</form>
	
	</body>
</html>

