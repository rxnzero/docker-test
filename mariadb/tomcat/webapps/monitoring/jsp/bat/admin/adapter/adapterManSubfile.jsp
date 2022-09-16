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
	var lastsel2;

	function unformatterFunction(cellvalue, options, rowObject) {
		return "";
	}

	function formatterFunction(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		return "<img id='btn_pop_delete' name='img_"+rowId+"' src=<c:url value='/images/bt/pop_delete.gif' /> />";
	}

	function gridRendering() {
		$('#grid').jqGrid({
			datatype:"local",
			loadonce: true,
			rowNum: 10000,
			editurl : "clientArray",
			colNames : [ '번호',
			             '항목명(한글)',
			             '항목명(영문)',
			             '데이터타입',
			             '길이',
			             '삭제'],
			colModel : [ { name : 'ORDERSEQ'   , align : 'left'},
			             { name : 'COLDESC'    , align : 'left',editable : true},
			             { name : 'COLDESCENG' , align : 'left',editable : true},
			             { name : 'COLTYPE'    , align : 'center',editable : true, edittype:'select',editoptions:{value:"1:varchar;2:number"}, formatter:"select"},
			             { name : 'COLSIZE'    , align : 'left',editable : true},
			             { name : 'DELETEYN'    , align : 'center', unformat : unformatterFunction, formatter : formatterFunction }],
			jsonReader : {
				repeatitems : false
			},
			loadComplete : function() {
			},
			onSelectRow: function(rowid,status){
	    		if (lastsel2 !=undefined){
	        	    if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
	        		  $("#grid").saveRow(lastsel2,false,"clientArray");
					}
	    		}
	        	$('#grid').restoreRow(lastsel2);
	        	$('#grid').editRow(rowid,true);
	        	lastsel2=rowid;
			},
	        onSortCol : function(){
	        	return 'stop';	//정렬 방지
	        },   
			height : '200',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});

		resizeJqGridWidth('grid', 'title', '1000');
	}
	
	function init(key1, key2, callback){
		$.ajax({
			type: "POST",
			url : url,
			dataType: "json",
			data:{cmd: 'LIST_SUBFILE_INIT_COMBO'},
			success: function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=checkName]")).setNoValueInclude(true).setNoValue("","").setData(json.listChkFileExt).rendering();		// 체크파일확장자 목록
				
	    		if(typeof callback === "function"){
	    			callback(key1, key2);
	    		}
			},
			error: function(e){
				alert("error");
			}
		});
	}

	function detail(key1, key2) {

		$("input[name=adptrCd]").css({'background-color' : '#e5e5e5'});
		$("input[name=adptrCdSeq]").css({'background-color' : '#e5e5e5'});
		if (!isDetail){
			// port Default 설정.
			$("input[name=rmtSevrFTPPortNoName]").val("20021");
			if ( key1.substring(5,7) == 'IN'){
				$("input[name=ftpStoreFilePattern]").val(".*");
			}
			return;
		}
			
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAILFILE',
				adptrCd : key1,
				adptrCdSeq : key2,
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				debugger;
				$("select[name=workGrpCd]").attr("disabled",true);
				$("select[name=sndRcvKind]").attr("disabled",true);
				$("select[name=adptrKind]").attr("disabled",true);
				$("select[name=workGrpCd]").css({'background-color' : '#e5e5e5'});
				$("select[name=sndRcvKind]").css({'background-color' : '#e5e5e5'});
				$("select[name=adptrKind]").css({'background-color' : '#e5e5e5'});
				$("input,select,textarea").each(function(){
					var name = $(this).attr('name');
					//.toUpperCase();
					if ( name != null )
						$(this).val(detail[name.toUpperCase()]);
				});
				$("#grid")[0].addJSONData(data);
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var key1 = "${param.adptrCd}";
		var key2 = "${param.adptrCdSeq}";
		var returnUrl = '${param.returnUrl}';
		
		returnUrl = returnUrl + '?cmd='+'DETAIL';
		returnUrl = returnUrl + '&page='+'${param.page}';
		returnUrl = returnUrl + '&menuId='+'${param.menuId}';
		//검색조건
		returnUrl = returnUrl + '&'+ getSearchUrlForReturn();
		returnUrl = returnUrl + '&adptrCd=' + key1;
		returnUrl = returnUrl + '&intfId='+'${param.intfId}';
		returnUrl = returnUrl + '&bjobDmndMsgID='+'${param.bjobDmndMsgID}';
		

		if (key2 != "" && key2 != "null") {
			isDetail = true;
		}

		gridRendering();

		init(key1, key2, detail);

		$("#btn_modify").click(function() {
			if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
				$("#grid").saveRow(lastsel2,false,"clientArray");
			}
			var data = $("#grid").getRowData();
			var gridData = new Array();
			for ( var i = 0; i < data.length; i++) {
				gridData.push(data[i]);
			}
			
			//공통부만 form으로 구성
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "gridData",
				value : JSON.stringify(gridData)
			});


			if (isDetail) {
				postData.push({
					name : "cmd",
					value : "UPDATEFILE"
				});
			} else {
				postData.push({
					name : "cmd",
					value : "INSERTFILE"
				});
			}
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(json) {
					alert("저장 되었습니다.");
					goNav(returnUrl);
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
				value : "DELETEFILE"
			});
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("삭제 되었습니다.");
					goNav(returnUrl);
					

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);
		});
		$("#btn_pop_input").click(function() {
			var rows = $("#grid")[0].rows;
			var index = Number($(rows[rows.length-1]).attr("id"));
			if (isNaN(index)) index=0;
		    var rowid = index + 1;
			var data = new Object();
			data['ORDERSEQ'] = rowid;
			$("#grid").jqGrid('addRow', {
	           rowID : rowid,          
	           initdata : data,
	           position :"last",    //first, last
	           useDefValues : false,
	           useFormatter : false,
	           addRowParams : {extraparam:{}}
			});	
			//$("#grid").saveRow(rowid,false,"clientArray");
			$("img[name=img_" + rowid + "]").click(function() {
				var name = $(this).attr("name");
				var rowId = name.split("_")[1];
				$('#grid').jqGrid('delRowData', rowId);
				debugger;
				var dataRow = $("#grid").getRowData();
				for(var i=0;i<dataRow.length;i++){
					dataRow[i]['ORDERSEQ'] = i+1;
					$("#grid").saveRow(i,false,"clientArray");
				}
			});
		});
		

		buttonControl(key2);
		titleControl(key2);
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
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">파일 어댑터 수정</div>		
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:180px;">어댑터 코드</th>
							<td><input type="text" name="adptrCd" value="${param.adptrCd}" readonly="readonly"></td>
							<th style="width:180px;">어댑터 코드 일련번호</th>
							<td><input type="text" name="adptrCdSeq" value="${param.adptrCdSeq}" readonly="readonly"></td>
						</tr>
						<tr><th style="width:180px;">FTP 명</th><td colspan="3"><input type="text" name="ftpName" />	</td></tr>
						<tr><th style="width:180px;">FTP 설명</th><td colspan="3"><input type="text" name="ftpNameDesc" />	</td></tr>
						<tr><th style="width:180px;">인터페이스ID</th><td ><input type="text" name="intfId" />	</td>
							<th style="width:180px;">구분 여부</th>
							<td><div class="select-style"><select name="ftpType" >
									<option value="FTP">FTP</option>
									<option value="SFTP">SFTP</option>
									<option value="EZGATOR">EZGATOR</option>
								</select></div>
							</td>
						<tr><th style="width:180px;">호스트 IP</th><td ><input type="text" name="ftpHostname" />	</td>
							<th style="width:180px;">Port</th><td ><input type="text" name="rmtSevrFTPPortNoName" />	</td></tr>
						<tr><th style="width:180px;">사용자ID</th><td ><input type="text" name="rmtSevrFTPUID" />	</td>
							<th style="width:180px;">비밀번호</th><td ><input type="text" name="rmtSevrFTPUserPwdName" />	</td></tr>
						<tr><th style="width:180px;">디렉토리</th><td colspan="3"><input type="text" name="ftpArchiveDir" />	</td></tr>
						<tr><th style="width:180px;">백업디렉토리</th><td colspan="3"><input type="text" name="ftpBackupDir" />	</td></tr>
						<tr><th style="width:180px;">체크파일디렉토리</th><td colspan="3"><input type="text" name="ftpCheckDir" />	</td></tr>
						<tr><th style="width:180px;">파일명패턴</th><td colspan="3"><input type="text" name="ftpStoreFilePattern" />	</td></tr>
						<tr><th style="width:180px;">수신후처리옵션</td>
							<td><div class="select-style"><select name="nextOption" >
									<option value=""></option>
									<option value="1">체크파일생성</option>
									<option value="2">체크파일생성안함</option>
								</select></div>
							</td>
							<th style="width:180px;">체크파일확장자</td>
							<td ><div class="select-style"><select name="checkName" >
								</select></div>
							</td></tr>
						<tr><th style="width:180px;">구분자(수신파일)</th><td ><input type="text" name="sectionVal" />	</td>
							<th style="width:180px;">전문레이아웃코드</th><td><input type="text" name="layoutKey" />	</td></tr>
						
					</table>
				</form>
				<br />
				<!-- button -->
				<div style="margin-bottom:15px; text-align:right;">	
					<img id="btn_pop_input" level="W" status="DETAIL" src="<c:url value="/img/btn_input.png" />" class="btn_img" />
				</div>
				
				<!-- grid -->
				<table id="grid" ></table>			
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>