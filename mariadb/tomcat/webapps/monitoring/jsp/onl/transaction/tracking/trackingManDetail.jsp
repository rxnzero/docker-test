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
			data:{cmd: 'DETAIL', eaiSvcSerno : eaiSvcSerno, logPrcssSerno:logPrcssSerno,eaiBzwkDstcd:eaiBzwkDstcd,msgDpstYMS:msgDpstYMS },
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
   
         //key��
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
			<div class="title">�αװ˻� �󼼺���</div>
			
			<form id="ajaxForm">
				<div class="table_row_title">���� ����</div>
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">���������ڵ�</th>
						<td style="width:30%;"><input type="text" name="eaiBzwkDstcd" readonly="readonly"/> </td>
						<th style="width:20%;">�޽��������Ͻ�</th>
						<td style="width:30%;"><input type="text" name="msgDpstYMS" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>IF�����ڵ�</td><td><input type="text" name="eaiSvcName" readonly="readonly"/> </td>
						<th>�޽���ó���Ͻ�</td><td><input type="text" name="msgPrcssYMS" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>EAI���� ����</td><td colspan="3"><input type="text" name="eaiSvcDesc" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>����������ȣ</td><td><input type="text" name="keyMgtMsgCtnt" readonly="readonly"/> </td>
						<th>�α�ó���Ϸù�ȣ</td><td><input type="text" name="logPrcssSerno" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>IF�����Ϸù�ȣ</td><td><input type="text" name="eaiSvcSerno" readonly="readonly"/> </td>
						<th>IF�����ν��Ͻ���</td><td><input type="text" name="eaiSevrInstncName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>GUID</td><td><input type="text" name="guid" readonly="readonly"/> </td>
						<th>���񽺽ð�����</td><td><input type="text" name="svcHMSEonot" readonly="readonly"/> </td>
					</tr>
				</table>				
				<div id="container-1">
					<ul class="tabs">
						<li class="active" rel="tab1">����������</li>
						<li rel="tab2">�����</li>
						<li rel="tab3">�����</li>
						<li rel="tab4">�޽�����</li>
						<li rel="tab5">����</li>					
					</ul>
					<div class="tab_container">
						<div id="tab1" class="tab_content" >
							<table id="grid" ></table>
							<div style="margin:15px 0;">
							<table><tr><td>
							<span id="sp_bzwkData">[����������]</span></td>
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
							<div style="margin-bottom:15px;">[��������]</div>
							<table class="table_row" cellspacing="0">								
								<tr>
									<th style="width:20%;">IF�����ڵ�</th>
									<td style="width:80%;"><input type="text" name="eaiErrCd"/></td>
								</tr>
								<tr>
									<td colspan="2"><textarea rows="" cols="" name="eaiErrCtnt" style="width: 100%;height:205px"></textarea></td>
								</tr>
							</table>
						</div><!-- end#tab5 -->															
					</div><!-- end.tab_container -->
				</div><!-- end.container-1 -->
				<div class="table_row_title">�⵿(INBOUND)</div>			
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">���񽺵����뱸���ڵ�</th>
						<td style="width:30%;"><input type="text" name="svcMotivUseDstcd" readonly="readonly"/> </td>
						<th style="width:20%;">�⵿�ý��۾���;����׷��</th>
						<td style="width:30%;"><input type="text" name="gstatSysAdptrBzwkGroupName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>�帧��������ø�</td><td><input type="text" name="flowCtrlRoutName" readonly="readonly"/> </td>
						<th>ǥ�ظ޽�����뿩��</td><td><input type="text" name="stndMsgUseYn" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>����ó�����и�</td><td><input type="text" name="svcPrcssDsticName" readonly="readonly"/> </td>
						<th>�������÷��α׿���</td><td><input type="text" name="svcBfClmnLogYn" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>����ó����ȣ</td><td><input type="text" name="svcPrcssNo" readonly="readonly"/> </td>
						<th>���ձ��и�</td><td><input type="text" name="intgraDsticName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>�⵿���񽺱��и�</td><td><input type="text" name="gstatSvcDsticName" readonly="readonly"/> </td>
						<th>����޽���ID��</td><td><input type="text" name="prsntMsgIdName" readonly="readonly"/> </td>
					</tr>
				</table>	
				<div class="table_row_title">����(OUTBOUND)</div>	
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">�����������̽����и�</th>
						<td style="width:30%;"><input type="text" name="psvIntfacDsticName" readonly="readonly"/> </td>
						<th style="width:20%;">�����ý��۾���;����׷��</th>
						<td style="width:30%;"><input type="text" name="psvSysAdptrBzwkGroupName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>�ƿ��ٿ�����ø�</th><td><input type="text" name="outbndRoutName" readonly="readonly"/> </td>
						<th>Ÿ�Ӿƿ���</th><td><input type="text" name="toutVal" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>�����ý��ۼ��񽺱��и�</th><td><input type="text" name="psvSysSvcDsticName" readonly="readonly"/> </td>
						<th>���������ý��۸�</th><td><input type="text" name="psvBzwkSysName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>���信���ʵ��</th><td><input type="text" name="rspnsErrFldName" readonly="readonly"/> </td>
						<th>�����ý���ID��</th><td><input type="text" name="psvSysIdName" readonly="readonly"/> </td>
					</tr>
				</table>	
				<div class="table_row_title">��ȭ(MAPPING)</div>	
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">��û ���ο���</th>
						<td style="width:30%;"><input type="text" name="chngYn" readonly="readonly"/> </td>
						<th style="width:20%;">��û �������̾ƿ������ڵ�</th>
						<td style="width:30%;"><input type="text" name="chngMsgIdName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>���� ���ο���</th><td><input type="text" name="bascRspnsChngYn" readonly="readonly"/> </td>
						<th>���� �������̾ƿ������ڵ�</td><td><input type="text" name="bascRspnsChngMsgIdName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>�������� ���ο���</th><td><input type="text" name="errRspnsChngYn" readonly="readonly"/> </td>
						<th>���� �������̾ƿ������ڵ�</td><td><input type="text" name="errRspnsChngMsgIdName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>��û �������̾ƿ��ڵ�</th><td><input type="text" name="inptMsgIDName" readonly="readonly"/> </td>
						<th>��������޽����񱳳���</th><td><input type="text" name="errRspnsMsgCmprCtnt" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>�⺻����޽����񱳳���</th><td><input type="text" name="bascRspnsMsgCmprCtnt" readonly="readonly"/> </td>
						<th>��ֱغ�����</th><td><input type="text" name="flovrYn" readonly="readonly"/> </td>
					</tr>
				</table>	
				<div class="table_row_title">��Ÿ����</div>				
				<table class="table_row" cellspacing="0" >
					<tr>
						<th style="width:20%;">���信���ڵ��</th>
						<td style="width:30%;"><input type="text" name="rspnsErrcdName" readonly="readonly"/> </td>
						<th style="width:20%;">�����α׷�����ȣ</th>
						<td style="width:30%;"><input type="text" name="sevrLogLvelNo" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>���񽺷α׷�����ȣ</th><td><input type="text" name="svcLogLvelNo" readonly="readonly"/> </td>
						<th>����EAI���񽺸�</th><td><input type="text" name="errEAISvcName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>��û������ȯID��</th><td><input type="text" name="dmndErrChngIDName" readonly="readonly"/> </td>
						<th>��û�����ʵ��</th><td><input type="text" name="dmndErrFldName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>���������ȯID��</th><td><input type="text" name="rspnsErrChngIdName" readonly="readonly"/> </td>
						<th>��������ó����ȣ</th><td><input type="text" name="nextSvcPrcssNo" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>�����׷��</th><td><input type="text" name="sevrGroupName" readonly="readonly"/> </td>
						<th>���󼭺�ó����</th><td><input type="text" name="cmpenSvcPrcssName" readonly="readonly"/> </td>
					</tr>
					<tr>
						<th>��������Ű1����</th><td><input type="text" name="trackAsisKey1Ctnt" readonly="readonly"/> </td>
						<th>��������Ű2����</th><td><input type="text" name="trackAsisKey2Ctnt" readonly="readonly"/> </td>
					</tr>			
				</table>
			</form>			
		</div><!-- end.popup_box -->
	</body>
</html>

