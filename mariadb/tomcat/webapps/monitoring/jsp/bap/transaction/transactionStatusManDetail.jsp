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
			return '����';
		}else if ( cellvalue == 'Q' ) {
			return '������';
		}else if ( cellvalue == 'C' ) {
			return '���������';
		}else if ( cellvalue == 'N' ) {
			return '���Ͼ���';
		}else if ( cellvalue == 'S' ) {
			return '<span style="color:blue">������</span>';
		}else if ( cellvalue == 'E' ) {
			return '<span style="color:red">����������</span>';
		}
		return "";
	}


	function getSubLayerName (cellvalue){
		if ( cellvalue == 'UI' ){
			return '����ȭ��';
		}else if ( cellvalue == 'FE' ) {
			return '�����̺�Ʈ'                  ;         
		}else if ( cellvalue == 'SS' ) {
			return '���ϼ���'                    ;         
		}else if ( cellvalue == 'SQ' ) {
			return '�����췯(���)'              ;         
		}else if ( cellvalue == 'SP' ) {
			return '�����췯(����)'              ;         
		}else if ( cellvalue == 'FC' ) {
			return '�÷ο���Ʈ�ѷ�'              ;         
		}else if ( cellvalue == 'ST' ) {
			return 'F/C ���� �ܰ�'               ;         
		}else if ( cellvalue == 'FI' ) {
			return 'F/C ����������ȯ �ܰ�'       ;         
		}else if ( cellvalue == 'DS' ) {
			return 'F/C Data �ۼ��� �ܰ�'        ;         
		}else if ( cellvalue == 'MI' ) {
			return 'F/C ���������ȯ �ܰ�'       ;         
		}else if ( cellvalue == 'MS' ) {
			return 'F/C ��� �ۼ��� �ܰ�'        ;         
		}else if ( cellvalue == 'UE' ) {
			return 'F/C ������������ �ܰ�'       ;         
		}else if ( cellvalue == 'AE' ) {
			return 'F/C ���������� �ܰ�'         ;         
		}else if ( cellvalue == 'EX' ) {
			return 'F/C ���� �ܰ�'               ;         
		}else if ( cellvalue == 'LT' ) {
			return 'F/C �ý���ȸ������Ȯ�� �ܰ�' ;         
		}else if ( cellvalue == 'SE' ) {
			return 'F/C �ý�������뺸 �ܰ�'     ;         
		}else if ( cellvalue == 'SR' ) {
			return 'F/C �ý������ȸ���뺸 �ܰ�' ;         
		}else if ( cellvalue == 'CK' ) {
			return 'F/C �䱸�۽� �׽�Ʈ�����ܰ�' ;         
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
		             '���ϸ�',
		             '�ڷ�Ǽ�',
		             '����ũ��',
		             '���ϻ���',
		             '���Ͻ��۽ð�',
		             '��������ð�',
		             '�۾�����',
		             '�ŷ�����',
		             '���ϰ��',
		             '�������ϸ�',
		             '��ֹ߻�����'
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
		             'ó���ܰ�',
                     '�帧��Ģ',
                     '�帧�ܰ�',
                     '�帧�ܰ輳��',
                     '�帧��ȣ',
                     '�帧����',
                     '�����ڵ�',
                     '�����ڵ�',
                     '�ܰ����',
                     '�ܰ���۽ð�',
                     '�ܰ�����ð�',
                     '�۾�����',
                     '�ŷ������ڵ�',
                     '���ϸ�',
		             '��ֹ߻�����'
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
		goNav(returnUrl);//LIST�� �̵�
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
				<div class="title">�ŷ��α׻�</div>						

	<!-- detail -->
	<form id="detailForm">
	<div class="container">
		<div class="left full" >
			<p class="comment" >�� �ŷ� �⺻ ����</p>
		</div>
	</div>
	<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
		<tr>
			<td class="detail_title">UUID</td><td><input type="text" readonly="readonly" name="bjobDmndMsgID" style="width:100%"/></td>
			<td class="detail_title">��ܱ��</td><td><input type="text" readonly="readonly" name="osidInstiName" style="width:100%"/></td>
			<td class="detail_title">��õ�Ƚ��</td><td><input type="text" readonly="readonly" name="telgmReTralCnt" style="width:100%"/></td>
			<td class="detail_title">��ܱ��IP</td><td><input type="text" readonly="readonly" name="lnkgIPInfoName" style="width:100%"/></td>
		</tr>
		<tr>
			<td class="detail_title">SUB_UUID</td><td><input type="text" readonly="readonly" name="bjobDmndSubMsgID" style="width:100%"/></td>
			<td class="detail_title">�ŷ�ó���ð�</td><td><input type="text" readonly="readonly" name="tranStartHMS" style="width:100%"/></td>
			<td class="detail_title">�帧��Ģ�ڵ�</td><td><input type="text" readonly="readonly" name="flowRuleCd" style="width:100%"/></td>
			<td class="detail_title">�޽����۽���</td><td><input type="text" readonly="readonly" name="msgSndrID" style="width:100%"/></td>
		</tr>
		<tr>
			<td class="detail_title">�۾�����</td>
			<td><select name="bjobPtrnDstcd" style="width:100%">
			        <option value="AR">�������</option>
					<option value="AS">����۽�</option>
					<option value="RS">�䱸�۽�</option>
					<option value="RR">�䱸����</option>
				</select>
			</td>
			<td class="detail_title">�۾�����</td>
			<td><select name="tranPrcssDstcd" style="width:100%">
			        <option value=""></option>
			        <option value="Q">������</option>
					<option value="S">������</option>
					<option value="T">��������</option>
					<option value="E">����������</option>
					<option value="C">���������</option>
					<option value="N">���Ͼ���</option>
				</select>
			</td>
			<td class="detail_title">��������</td><td><input type="text" readonly="readonly" name="bjobBzwkDstcd" style="width:100%"/></td>
			<td class="detail_title">�޽��������ð�</td><td><input type="text" readonly="readonly" name="bjobDmndMsgCretnHMS" style="width:100%"/></td>
		</tr>
	</table>
	</form>
	<div id="container-1" >
		<ul class="tabs">
			<li class="active" rel="tabFile">�� �ŷ� ���� ����</li>
			<li rel="tabStage">�� �ŷ� ó���ܰ� ����Ʈ</li>
		</ul>
		<div class="tab_container" style="width:100%">
			<div id="tabFile" class="tab_content">
				<form id="fileForm">
					<table id="gridFile" ></table>
					<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
						<tr>
							<td class="detail_title">�ŷ�����</td><td><input type="text" readonly="readonly" name="bjobMsgDstcd" style="width:100%"/></td>
							<td class="detail_title">����ũ��</td><td><input type="text" readonly="readonly" name="sndrcvFileSize" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">�ŷ����ϸ�</td><td><input type="text" readonly="readonly" name="sndrcvFileName" style="width:100%"/></td>
							<td class="detail_title">��������ϸ�</td><td><input type="text" readonly="readonly" name="bkupSndrcvFileName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">���ϰ��</td><td><input type="text" readonly="readonly" name="rqstRecvFileStorgDirName" style="width:100%"/></td>
							<td class="detail_title">����ó���ð�</td><td><input type="text" readonly="readonly" name="fileTrsmtStartHMS" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">�������ۻ���</td>
							<td><select name="thisStgePrcssRsultCd" style="width:100%">
									<option value=""></option>
									<option value="Q">������</option>
									<option value="S">������</option>
									<option value="T">��������</option>
									<option value="E">����������</option>
									<option value="C">���������</option>
									<option value="N">���Ͼ���</option>
								</select>
							</td>
							<td class="detail_title">���ϴ����</td><td><input type="text" readonly="readonly" name="thisMsgChrgIDs" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">üũ���ϳ���</td><td colspan=3><input type="text" readonly="readonly" name="hdrInfoName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">��ֳ���</td><td colspan=3><textarea  name="eAIObstclOccurCausCtnt" readonly="readonly" style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">���� ��� ����</td><td colspan=3><textarea  name="bjobFileHdrCtnt" readonly="readonly"  style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">���� Ʈ���Ϸ� ����</td><td colspan=3><textarea  name="bjobFileTrailCtnt" readonly="readonly" style="width:100%;height:100%"></textarea></td>
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
							<td class="detail_title">ó���ܰ�</td>
							<td><select name="prcssStgeDstcd" style="width:100%">
							    	<option value=" ">                   </option>
							    	<option value="UI">����ȭ��                   </option>
							    	<option value="FE">�����̺�Ʈ                 </option>
							    	<option value="SS">���ϼ���                   </option>
							    	<option value="SQ">�����췯(���)             </option>
							    	<option value="SP">�����췯(����)             </option>
							    	<option value="FC">�÷ο���Ʈ�ѷ�             </option>
							    	<option value="ST">F/C ���� �ܰ�              </option>
							    	<option value="FI">F/C ����������ȯ �ܰ�      </option>
							    	<option value="DS">F/C Data �ۼ��� �ܰ�       </option>
							    	<option value="MI">F/C ���������ȯ �ܰ�      </option>
							    	<option value="MS">F/C ��� �ۼ��� �ܰ�       </option>
							    	<option value="UE">F/C ������������ �ܰ�      </option>
							    	<option value="AE">F/C ���������� �ܰ�        </option>
							    	<option value="EX">F/C ���� �ܰ�              </option>
							    	<option value="LT">F/C �ý���ȸ������Ȯ�� �ܰ�</option>
							    	<option value="SE">F/C �ý�������뺸 �ܰ�    </option>
							    	<option value="SR">F/C �ý������ȸ���뺸 �ܰ�</option>
							    	<option value="CK">F/C �䱸�۽� �׽�Ʈ�����ܰ�</option>
							    </select>
							</td>
							<td class="detail_title">�帧��Ģ�ڵ�</td><td><input type="text" readonly="readonly" name="bjobRuleCd" style="width:100%"/></td>
							<td class="detail_title">�帧�ܰ��ڵ�</td><td><input type="text" readonly="readonly" name="bjobStgeCd" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">�ܰ�����ȣ</td><td><input type="text" readonly="readonly" name="bjobNodeCasNo" style="width:100%"/></td>
							<td class="detail_title">FlowŬ������</td><td><input type="text" readonly="readonly" name="bjobFlowCmpoClsName" style="width:100%"/></td>
							<td class="detail_title">�ܰ�����</td><td><input type="text" readonly="readonly" name="bjobStgePtrnName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">����������������<br>(RECV��)</td>
							<td>
								<table width="100%">
									<tr>
										<td>- TelegramID : </td><td><input type="text" readonly="readonly" name="telgmDcsnID" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- Ŭ������  : </td><td><input type="text" readonly="readonly" name="telgmDcsnClsName" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- �����ڵ�  : </td><td><input type="text" readonly="readonly" name="telgmDcsnMsgCd" style="width:100%;border:0px"/></td>
									</tr>
								</table>
							</td>
							<td class="detail_title">�ܰ��������</td>
							<td>
								<table width="100%">
									<tr>
										<td>- TelegramID : </td><td><input type="text" readonly="readonly" name="thisStgeTelgmID" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- Ŭ������  : </td><td><input type="text" readonly="readonly" name="thisStgeClsName" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- �����ڵ�  : </td><td><input type="text" readonly="readonly" name="thisStgeMsgCd" style="width:100%;border:0px"/></td>
									</tr>
								</table>
							</td>
							<td class="detail_title">�����ʵ�����</td>
							<td>
								<table width="100%">
									<tr>
										<td>- ���������ڵ� �� : </td><td><input type="text" readonly="readonly" name="telgmPertypCdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- �ŷ������ڵ� �� : </td><td><input type="text" readonly="readonly" name="telgmDstcdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- ���������ڵ� �� : </td><td><input type="text" readonly="readonly" name="telgmMgtCdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
									<tr>
										<td>- �����ڵ� ��  : </td><td><input type="text" readonly="readonly" name="rspnsCdValCtnt" style="width:100%;border:0px"/></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td class="detail_title">�ŷ�����</td><td><input type="text" readonly="readonly" name="bjobMsgDstcd" style="width:100%"/></td>
							<td class="detail_title">�ŷ����ϸ�</td><td><input type="text" readonly="readonly" name="sndrcvFileName" style="width:100%"/></td>
							<td class="detail_title">��������ϸ�</td><td><input type="text" readonly="readonly" name="bkupSndrcvFileName" style="width:100%"/></td>
						</tr>
						<tr>
							<td class="detail_title">���ϰ��</td><td><input type="text" readonly="readonly" name="rqstRecvFileStorgDirName" style="width:100%"/></td>
							<td class="detail_title">�ܰ�ó���ð�</td><td><input type="text" readonly="readonly" name="thisStgeStartHMS" style="width:100%"/></td>
							<td class="detail_title">�ܰ����</td>
							<td><select name="thisStgePrcssRsultCd" style="width:100%">
									<option value=""></option>
									<option value="Q">������</option>
									<option value="S">������</option>
									<option value="T">��������</option>
									<option value="E">����������</option>
									<option value="C">���������</option>
									<option value="N">���Ͼ���</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="detail_title">��ֳ���</td><td colspan=5><textarea  name="eAIObstclOccurCausCtnt" readonly="readonly"   style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">�������</td><td colspan=5><textarea  name="bjobTelgmHdr"readonly="readonly"   style="width:100%;height:100%"></textarea></td>
						</tr>
						<tr>
							<td class="detail_title">�����ٵ�</td><td colspan=5><textarea  name="bjobTelgmTbody" readonly="readonly"  style="width:100%;height:100%"></textarea></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	</div>
	</body>
</html>