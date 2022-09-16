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

	var url      = '<c:url value="/bat/admin/adapter/adapterMan.json" />';
	var url_view = '<c:url value="/bat/admin/adapter/adapterMan.view" />';
	var isDetail = false;

	function gridRendering() {
		$('#gridDB').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '�����Ű',
			             '������Ϸù�ȣ',
			             'SQL��',
			             'SQL��',
			             'ó������'],
			colModel : [ { name : 'ADPTRCD'     , align : 'left'},
			             { name : 'ADPTRCDSEQ'  , align : 'right'},
			             { name : 'SQLNAME'     , align : 'left'},
			             { name : 'SQLNAMEDESC' , align : 'left'},
			             { name : 'SELECTUNITCNT' , align : 'right'}],
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
				var url2 = url_view + "?cmd=SUBDB";
				url2 = url2 + '&page='+'${param.page}';
            	url2 = url2 + '&returnUrl='+getReturnUrl();
            	url2 = url2 + '&menuId='+'${param.menuId}';
				//key��
            	url2 = url2 + '&adptrCd='+adptrCd;
            	url2 = url2 + '&adptrCdSeq='+adptrCdSeq;
				url2 = url2 + '&returnUrl='+getReturnUrl();
				goNav(url2);
			},
			
			height : '200',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});

		$('#gridFile').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '�����Ű',
			             '������Ϸù�ȣ',
			             '���Ͼ���͸�',
			             '���Ͼ���ͻ�',
			             'ȣ��ƮIP'],
			colModel : [ { name : 'ADPTRCD'     , align : 'left'},
			             { name : 'ADPTRCDSEQ'  , align : 'left'},
			             { name : 'FTPNAME'     , align : 'left'},
			             { name : 'FTPNAMEDESC' , align : 'left'},
			             { name : 'FTPHOSTNAME' , align : 'left'}],
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
				var url2 = url_view + "?cmd=SUBFILE";
				url2 = url2 + '&page='+'${param.page}';
            	url2 = url2 + '&returnUrl='+getReturnUrl();
            	url2 = url2 + '&menuId='+'${param.menuId}';
				//key��
            	url2 = url2 + '&adptrCd='+adptrCd;
            	url2 = url2 + '&adptrCdSeq='+adptrCdSeq;
				url2 = url2 + '&returnUrl='+getReturnUrl();
				goNav(url2);
			},
			
			height : '200',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});

		resizeJqGridWidth('gridDB', 'content_middle', '1000');
		resizeJqGridWidth('gridFile', 'content_middle', '1000');
	}
	function init(key, callback) {
		$("input[name=adptrCd]").css({'background-color' : '#e5e5e5'});
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

		if (!isDetail)
			return;

		// popup ���Ŀ� key�� �ȳѾ� �� ���
	//	if (key != "" && key != "null") {
	//		key = "${param.adptrCd}";
	//	}

		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				adptrCd : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				debugger;
				$("select[name=workGrpCd]").attr("disabled",true);
				$("select[name=sndRcvKind]").attr("disabled",true);
				$("select[name=adptrKind]").attr("disabled",true);
				//$("select[name=workGrpCd]").css({'background-color' : '#e5e5e5'});
				//$("select[name=sndRcvKind]").css({'background-color' : '#e5e5e5'});
				//$("select[name=adptrKind]").css({'background-color' : '#e5e5e5'});
				$("input,select").each(function(){
					var name = $(this).attr('name');
					//.toUpperCase();
					if ( name != null )
						$(this).val(detail[name.toUpperCase()]);
				});
				$("#gridDB")[0].addJSONData(data);
				$("#gridFile")[0].addJSONData(data);
				var adptrKind = $("select[name=adptrKind]").val();
				if ( adptrKind == '1' ){
					$("#formDB").show();
					$("#formFile").hide();
				}else{
					$("#formDB").hide();
					$("#formFile").show();
				}
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.adptrCd}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		gridRendering();

		init(key, detail);

		$("#btn_modify").click(function() {
			//����θ� form���� ����
			var postData = $('#ajaxForm').serializeArray();

			if (isDetail) {
				postData.push({
					name : "cmd",
					value : "UPDATE"
				});
			} else {
				postData.push({
					name : "cmd",
					value : "INSERT"
				});
			}
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(json) {
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
					//isDetail = true;
					//var key = json.adptrCd;
					//detail(key);
					//buttonControl(key);
				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_delete").click(function() {
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "cmd",
				value : "DELETE"
			});
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("���� �Ǿ����ϴ�.");
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
		$("#btn_pop_input").click(function() {
			var url2 = url_view;
			
			
			var adptrKind = $("select[name=adptrKind]").val();
			if ( adptrKind == '1' ){
				url2 = url2 + "?cmd=SUBDB";
			}else{
				url2 = url2 + "?cmd=SUBFILE";
			}
			url2 = url2 + '&page='+'${param.page}';
            url2 = url2 + '&returnUrl='+getReturnUrl();
            url2 = url2 + '&menuId='+'${param.menuId}';
			//�˻���
            url2 = url2 + '&'+getSearchUrl();
            //key��
            url2 = url2 + '&adptrCd='+$("input[name=adptrCd]").val();
			
			url2 = url2 + '&returnUrl='+getReturnUrl();
			goNav(url2);
			//showModal(url2,args,800,600,detail,'scroll:yes;resizable:yes;');
		});

		buttonControl(key);
		titleControl(key);
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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">�����<span class="tooltip" >ǥ��ȭ�� IF�ý��� ���� �����ڵ带 �߰��մϴ�.</span></div>				
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
				<!-- detail -->
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">�������и�</th>
							<td>
								<div class="select-style">
									<select name="workGrpCd">
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th>�ۼ��Žý��۱���</th>
							<td>
								<div class="select-style">
									<select name="sndRcvKind">
										<option value="1">�۽���</option>
										<option value="2">������</option>
									</select>
								</div><!-- end.select-style -->			
							</td>
						</tr>
						<tr>
							<th>����� ���� ����</th>
							<td>
								<div class="select-style">
									<select name="adptrKind">
										<option value="1">DB</option>
										<option value="2">FILE</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr><th>����� �ڵ�</th><td><input type="text" name="adptrCd" readonly="readonly"></td></tr>
						<tr><th>����͸�</th><td><input type="text" name="adptrBzwkName" />	</td></tr>
						<tr><th>����ͼ���</th><td><input type="text" name="adptrDesc" />	</td></tr>
						<tr><th>JNDI</th><td><input type="text" name="jndiDatasource" />	</td></tr>
						<tr><th>���ڵ�</th><td><input type="text" name="enc1" />	</td></tr>
					</table>
				</form>
				<!-- button -->
				<div style="margin-bottom:15px; text-align:right;">	
					<img id="btn_pop_input" level="W" status="DETAIL" src="<c:url value="/img/btn_input.png" />" class="btn_img" />
				</div>				
				<!-- grid -->
				<form id="formDB" hidden="hidden">
					<table id="gridDB" ></table>
				</form>
				<form id="formFile" hidden="hidden">
					<table id="gridFile"></table>
				</form>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>