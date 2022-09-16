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
<jsp:include page="/jsp/common/include/css.jsp" />
<jsp:include page="/jsp/common/include/script.jsp" />

<script language="javascript">

	var url      = '<c:url value="/bat/transaction/message/messageMonitorMan.json" />';
	var url_view = '<c:url value="/bat/transaction/message/messageMonitorMan.view" />';

	function gridRendering() {
		$('#gridDB').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '�ۼ��ű���',
			             '�����Ű',
			             '������Ϸù�ȣ',
			             'SQL��',
			             'SQL��',
			             'ó������'],
			colModel : [ { name : 'SNDRCVKIND'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '�۽���';
                                 } else if ( cellvalue == '2' ) {
				                 	return '������';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'ADPTRCD'     , align : 'left', width:'80'},
			             { name : 'ADPTRCDSEQ'  , align : 'center', width:'80'},
			             { name : 'SQLNAME'     , align : 'left', width:'180'},
			             { name : 'SQLNAMEDESC' , align : 'left', width:'400'},
			             { name : 'SELECTUNITCNT' , align : 'right' ,formatter:'integer'}],
			jsonReader : {
				root : "listDB",
				repeatitems : false
			},
			loadComplete : function() {
			},
			ondblClickRow: function(rowId) {
				var rowData = $(this).getRowData(rowId); 
            	var adptrCd    = rowData['ADPTRCD'];
				var adptrCdSeq = rowData['ADPTRCDSEQ'];
				var url2 = '<c:url value="/bat/admin/adapter/adapterMan.view" />' + "?cmd=SUBDB";
				url2 = url2 + '&page='+'${param.page}';
            	url2 = url2 + '&returnUrl='+getReturnUrl();
            	url2 = url2 + '&menuId='+'${param.menuId}';
				//key��
            	url2 = url2 + '&adptrCd='+adptrCd;
            	url2 = url2 + '&adptrCdSeq='+adptrCdSeq;
            	url2 = url2 + '&bjobDmndMsgID=' + "${param.bjobDmndMsgID}";
				url2 = url2 + '&'+getSearchUrl();
				url2 = url2 + '&'+getSearchUrlForReturn();
				goNav(url2);
			},
			
			height : '100',
			autowidth : true,
			viewrecords : true
		});

		$('#gridFile').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '�ۼ��ű���',
			             '�����Ű',
			             '������Ϸù�ȣ',
			             '���Ͼ���͸�',
			             '���Ͼ���ͻ�',
			             'ȣ��ƮIP'],
			colModel : [ { name : 'SNDRCVKIND'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '�۽���';
                                 } else if ( cellvalue == '2' ) {
				                 	return '������';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'ADPTRCD'     , align : 'left', width:'80'},
			             { name : 'ADPTRCDSEQ'  , align : 'center', width:'80'},
			             { name : 'FTPNAME'     , align : 'left', width:'180'},
			             { name : 'FTPNAMEDESC' , align : 'left', width:'400'},
			             { name : 'FTPHOSTNAME' , align : 'left', width:'100'}],
			jsonReader : {
				root : "listFile",
				repeatitems : false
			},
			loadComplete : function() {
			},
			ondblClickRow: function(rowId) {
				var rowData = $(this).getRowData(rowId); 
            	var adptrCd    = rowData['ADPTRCD'];
				var adptrCdSeq = rowData['ADPTRCDSEQ'];
				var url2 = '<c:url value="/bat/admin/adapter/adapterMan.view" />' + "?cmd=SUBFILE";
				url2 = url2 + '&page='+'${param.page}';
            	url2 = url2 + '&returnUrl='+getReturnUrl();
            	url2 = url2 + '&menuId='+'${param.menuId}';
				//key��
            	url2 = url2 + '&adptrCd='+adptrCd;
            	url2 = url2 + '&adptrCdSeq='+adptrCdSeq;
            	url2 = url2 + '&bjobDmndMsgID=' + "${param.bjobDmndMsgID}";
				url2 = url2 + '&'+getSearchUrlForReturn();
				goNav(url2);
			},
			
			height : '100',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});

		$('#gridDBlog').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '���ۻ���',
			             '�ۼ��ű���',
			             '�����Ű',
			             '������Ϸù�ȣ',
			             '���۽��۽ð�',
			             '���۽��۽ð�',
			             '���Ǽ�',
			             'ó���Ǽ�',
			             '�����޼���'],
			colModel : [ { name : 'TRANSSTATUSCD'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == 'S' ) {
				                 	return '<span style="color:green">������</span>';
				                 }else if ( cellvalue == 'C' ) {
				                 	return '<span style="color:blue">���ۿϷ�</span>';
				                 }else if ( cellvalue == 'F' ) {
				                 	return '<span style="color:red">���۽���</span>';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'SNDRCVKIND'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '�۽���';
                                 } else if ( cellvalue == '2' ) {
				                 	return '������';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'ADPTRCD'     , align : 'left', width:'80'},
			             { name : 'ADPTRCDSEQ'  , align : 'center', width:'80'},
			             { name : 'DBTRSMTSTARTHMS' , align : 'center', width:'120' , formatter: timeStampFormat },
			             { name : 'DBTRSMTENDHMS'   , align : 'center', width:'120' , formatter: timeStampFormat },
			             { name : 'ORGCNT' , align : 'right'	,formatter:'integer'},
			             { name : 'INSERTCNT' , align : 'right'	,formatter:'integer', width:'180'},
			             { name : 'ERRMSGCD', align : 'left'}],
			jsonReader : {
				root : "listDBLog",
				repeatitems : false
			},
			loadComplete : function() {
			},
			
			height : '100',
			autowidth : true,
			viewrecords : true
		});

		$('#gridFilelog').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '���ۻ���',
			             '�ۼ��ű���',
			             '�����Ű',
			             '������Ϸù�ȣ',
			             '���۽��۽ð�',
			             '���۽��۽ð�',
			             '���������ϸ�',
			             'EAI���ϸ�',
			             '���ϻ�����',
			             '�����޼���'],
			colModel : [ { name : 'TRANSSTATUSCD'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == 'S' ) {
				                 	return '<span style="color:green">������</span>';
				                 }else if ( cellvalue == 'C' ) {
				                 	return '<span style="color:blue">���ۿϷ�</span>';
				                 }else if ( cellvalue == 'F' ) {
				                 	return '<span style="color:red">���۽���</span>';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'SNDRCVKIND'  , align : 'left',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '�۽���';
                                 } else if ( cellvalue == '2' ) {
				                 	return '������';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'ADPTRCD'     , align : 'left', width:'80'},
			             { name : 'ADPTRCDSEQ'  , align : 'center', width:'80'},
			             { name : 'FILETRSMTSTARTHMS' , align : 'center', width:'120' , formatter: timeStampFormat },
			             { name : 'FILETRSMTENDHMS'   , align : 'center', width:'120' , formatter: timeStampFormat },
			             { name : 'RMTTRSMTFULLNAME'     , align : 'left', width:'400'},
			             { name : 'EAITRSMTFULLNAME'     , align : 'left', width:'80'},
			             { name : 'FILETRSMTSIZECTNT'    , align : 'right', width:'80'},
			             { name : 'ERRMSGCD', align : 'left', width:'370'}],
			jsonReader : {
				root : "listFileLog",
				repeatitems : false
			},
			loadComplete : function() {
			},
			height : '100',
			autowidth : true,
			viewrecords : true
		});

		resizeJqGridWidth('gridDB', 'content_middle', '1000');
		resizeJqGridWidth('gridFile', 'content_middle', '1000');
		resizeJqGridWidth('gridDBlog', 'content_middle', '1000');
		resizeJqGridWidth('gridFilelog', 'content_middle', '1000');
	}
	function init(key, callback) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=workGrpCd]")).setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
				$("select[name=workGrpCd]").searchable();
				if (typeof callback === 'function') {
					callback(key);
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}

	function detail(key) {

		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				bjobDmndMsgID : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				debugger;
				$("input,select").each(function(){
					var name = $(this).attr('name');
					if ( name != null )
						$(this).val(detail[name.toUpperCase()]);
				});
				var batchType = $("select[name=batchType]").val();

				$("#gridDB")[0].addJSONData(data);
				$("#gridFile")[0].addJSONData(data);
				$("#gridDBlog")[0].addJSONData(data);
				$("#gridFilelog")[0].addJSONData(data);

				if ( batchType == 'DD'){
					$("#formDB").show();
					$("#formDBlog").show();
					$("#formFile").hide();
					$("#formFilelog").hide();
				}else if (batchType == 'DF' || batchType == 'FD') {
					$("#formDB").show();
					$("#formDBlog").show();
					$("#formFile").show();
					$("#formFilelog").show();
				}else if (batchType == 'FF'){
					$("#formFile").show();
					$("#formFilelog").show();
					$("#formDB").hide();
					$("#formDBlog").hide();
				}

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.bjobDmndMsgID}";
		
		$("input[name*=Date][name!=checkBaseDate]").inputmask("9999-99-99 99:99:99.999",{'autoUnmask':false});
		$("input[name*=Cnt]").inputmask('decimal',{groupSeparator:',',digits:0,autoGroup:true,prefix:'',rightAlign:false,autoUnmask:true,removeMaskOnSubmit:true});
		$("input").each(function(){
			$(this).attr("readonly",true);
		});
		$("select").each(function(){
			$(this).attr("disabled",true);
			$(this).css({'background-color' : '#ffffff'});
		});
		
		gridRendering();

		init(key, detail);

		$("#btn_operate").click(function() {
		    if ( confirm( //"* FEP ����           : "+ serverName +"\n"+
                          //"* ��������           : "+ processName + "\n"+
                          //"* ��ܱ��           : "+ organName +"\n"+
                          //"* FEP IP:Port        : "+ localIpPort + "\n"+
                          "������ �Ͻðڽ��ϱ�?") != true ){
                return;
            }
		    
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "cmd",
				value : "LIST_REQUEST"
			});
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("������ �۾��� ���� �Ͽ����ϴ�.\r\n" + args.message);
					goNav(returnUrl);//LIST�� �̵�

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});

		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST�� �̵�
		});


// 		buttonControl(key);
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
			<div class="content_middle" id="content_middle" >
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_operate.png"/>" alt="" id="btn_operate" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">�޽��� �� ����͸�</div>
				<form id="ajaxForm">
					<table id="detail" class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:180px;">�������и�</th>
							<td style="min-width:180px; max-width:300px;"><div class="select-style" ><select name="workGrpCd"></select></div> </td>
							<th style="width:180px;">�۾��޽���</th>
							<td style="min-width:300px; max-width:500px;"><input type="text" name="bjobDmndMsgID"/>
							</td>
						</tr>
						<tr>
							<th>��ġ�ŷ�����</th>
							<td >
								<div class="select-style">
								<select name="batchType">
								<option value="FF">FILE2FILE</option>
									<option value="DF">DB2FILE</option>
									<option value="DD">DB2DB</option>
									<option value="FD">FILE2DB</option>
								</select>								
								</div>
							</td>
							<th>�۾��޽�����û�Ͻ�</th>
							<td ><input type="text" name="msgRegDate"/></td>
						</tr>
						<tr>
							<th>����</th>
							<td >
								<div class="select-style">
								<select name="ErrYn">
									<option value="1">����</option>
									<option value="2">����</option>
									<option value="C">����</option>
									<option value="N">������</option>
								</select>
								</div>
							</td>
							<th>�⵿����</th>
							<td >
								<div class="select-style">
								<select name="ADPTRCD">
									<option value="T">Ÿ�̸�</option>
									<option value="F">����</option>
									<option value="E">�̺�Ʈȣ��</option>
									<option value="U">ȭ������</option>
								</select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>�������̽� ID</th>
							<td ><input type="text" name="intfId"/></td>
							<th>�������̽� ��</th>
							<td ><input type="text" name="intfName"/></td>
						</tr>
						<tr>
							<th>���Ǽ�</th><td><input type="text" name="sndLineCnt"/> </td>
							<th>ó���Ǽ�</th><td><input type="text" name="rcvLineCnt"/> </td>
						</tr>
						<tr>
							<th>üũ�Ǽ�</th><td><input type="text" name="checkRowCnt"/> </td>
							<th>�Ķ����(���ϸ�)</th><td><input type="text" name="checkParam"/> </td>
						</tr>
						<tr>
							<th>�۽Ž�����</th><td><input type="text" name="sndStartDate"/> </td>
							<th>�۽ſϷ���</th><td><input type="text" name="sndEndDate"/> </td>
						</tr>
						<tr>
							<th>���Ž����Ͻ�</th><td><input type="text" name="rcvStartDate"/> </td>
							<th>���ſϷ��Ͻ�</th><td><input type="text" name="rcvEndDate"/> </td>
						</tr>												
					</table>
					</form>
					<br />
					<!-- grid -->
					<form id="formDB" hidden="hidden">
						<table id="gridDB" ></table>
					</form>
					<form id="formFile" hidden="hidden">
						<table id="gridFile"></table>
					</form>
					<form id="formDBlog" hidden="hidden">
						<table id="gridDBlog" ></table>
					</form>
					<form id="formFilelog" hidden="hidden">
						<table id="gridFilelog"></table>
					</form>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>