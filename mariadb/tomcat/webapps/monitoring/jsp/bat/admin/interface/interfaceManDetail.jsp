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

	var url      = '<c:url value="/bat/admin/interface/interfaceMan.json" />';
	var url_view = '<c:url value="/bat/admin/interface/interfaceMan.view" />';
	var isDetail = false;

	function gridRendering() {
		$('#gridDB').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '어댑터키',
			             '어댑터일련번호',
			             'SQL명',
			             'SQL상세',
			             '처리단위'],
			colModel : [ { name : 'ADPTRCD'     , align : 'left'},
			             { name : 'ADPTRCDSEQ'  , align : 'left'},
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
				var url2 = '<c:url value="/bat/admin/adapter/adapterMan.view" />' + "?cmd=SUBDB";
				url2 = url2 + '&page='+'${param.page}';
            	url2 = url2 + '&returnUrl='+getReturnUrl();
            	url2 = url2 + '&menuId='+'${param.menuId}';
				//key값
            	url2 = url2 + '&adptrCd='+adptrCd;
            	url2 = url2 + '&adptrCdSeq='+adptrCdSeq;
            	url2 = url2 + '&intfId=' + "${param.intfId}";
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
			colNames : [ '어댑터키',
			             '어댑터일련번호',
			             '파일어댑터명',
			             '파일어댑터상세',
			             '호스트IP'],
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
				var url2 = '<c:url value="/bat/admin/adapter/adapterMan.view" />' + "?cmd=SUBFILE";
				url2 = url2 + '&page='+'${param.page}';
            	url2 = url2 + '&returnUrl='+getReturnUrl();
            	url2 = url2 + '&menuId='+'${param.menuId}';
				//key값
            	url2 = url2 + '&adptrCd='+adptrCd;
            	url2 = url2 + '&adptrCdSeq='+adptrCdSeq;
            	url2 = url2 + '&intfId=' + "${param.intfId}";
				url2 = url2 + '&returnUrl='+getReturnUrl();
				goNav(url2);
			},
			
			height : '200',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});

		resizeJqGridWidth('gridDB', 'title', '1000');
		resizeJqGridWidth('gridFile', 'title', '1000');
	}
	function init(key, callback) {
		//$("input[name=intfId]").css({'background-color' : '#e5e5e5'});
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=workGrpCd]")).setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
				//$("select[name=workGrpCd]").searchable();
				setSearchable("workGrpCd");
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

		// popup 이후에 key가 안넘어 온 경우
	//	if (key != "" && key != "null") {
	//		key = "${param.adptrCd}";
	//	}

		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				intfId : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				$("select[name=workGrpCd]").attr("disabled",true);
				$("select[name=workGrpCd]").css({'background-color' : '#e5e5e5'});
				$("input[name=intfId]").attr('readonly', true);
				$("input[name=intfId]").css({'background-color' : '#e5e5e5'});
				$("select[name=batchType]").attr("disabled",true);
				$("input,select").each(function(){
					var name = $(this).attr('name');
					//.toUpperCase();
					if ( name != null )
						$(this).val(detail[name.toUpperCase()]);
				});
				$("#gridDB")[0].addJSONData(data);
				$("#gridFile")[0].addJSONData(data);
				var batchType = $("select[name=batchType]").val();
				if ( batchType == 'DD' || batchType == 'FD'){
					$("#formDB").show();
					$("#formFile").hide();
					resizeJqGridWidth('gridDB', 'title', '1000');
				}else{
					$("#formFile").show();
					$("#formDB").hide();
					resizeJqGridWidth('gridFile', 'title', '1000');
				}

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.intfId}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		gridRendering();

		init(key, detail);

		$("#btn_modify").click(function() {
			//공통부만 form으로 구성
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
					alert("저장 되었습니다.");
					goNav(returnUrl);//LIST로 이동
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
					alert("삭제 되었습니다.");
					goNav(returnUrl);//LIST로 이동

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST로 이동
		});
		$("#btn_pop_search").click(function() {
		
			var batchType = $("select[name=batchType]").val();
			var adptrKind = '1';
			if ( batchType == 'FD' || batchType == 'FF'){
				adptrKind = '2';
			}
			var url2 = url_view;
			url2 = url2 + "?cmd=SELECTADAPTER";
			var args = new Object();
		    args['workGrpCd']  = $("select[name=workGrpCd]").val();
		    args['adptrKind']  = adptrKind;

			var result = showModal(url2,args,800,600,popupAfter);

		});
		$("#btn_pop_detail").click(function() {
			var adptrCd = $("input[name=sndAdptrCd]").val();
			var adptrCdSeq = $("input[name=sndAdptrCdSeq]").val();
			if (adptrCd.length ==0){
				alert("adptrCd is null");
			}
			if (adptrCdSeq.length==0){
				alert("adptrCdSeq is null")
			}
			var url2 = '<c:url value="/bat/admin/adapter/adapterMan.view" />';
			if ( adptrCd.substr(3,2) == 'DB'){
				url2 = url2 + "?cmd=SUBDB";
			}else{
				url2 = url2 + "?cmd=SUBFILE";
			}
			url2 = url2 + '&page='+'${param.page}';
            url2 = url2 + '&returnUrl='+getReturnUrl();
            url2 = url2 + '&menuId='+'${param.menuId}';
			//key값
            url2 = url2 + '&adptrCd='+adptrCd;
            url2 = url2 + '&adptrCdSeq='+adptrCdSeq;
            url2 = url2 + '&intfId=' + "${param.intfId}";
			url2 = url2 + '&returnUrl='+getReturnUrl();
			goNav(url2);
		});
		

		buttonControl(key);
		titleControl(key);
	});
	function popupAfter(arg) {
		debugger;
	    var args = null;
	    
	    if(arg == null || arg == undefined ) {//chrome
	    	args = this.dialogArguments;
	    	args.returnValue = this.returnValue;
	    } else {//ie
	    	args = arg;
	    }
	    var result = args.returnValue;
		if( result.length == 2 ) {
			$("input[name=sndAdptrCd]").val(result[0]);
			$("input[name=sndAdptrCdSeq]").val(result[1]);
		}

	}
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
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">인터페이스</div>				
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
				<!-- detail -->
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:15%;">인터페이스ID</th>
							<td style="width:35%;"><input type="text" name="intfId" /></td>
							<th style="width:15%;">업무구분명</th>
							<td style="width:35%;">
								<div style="position: relative; width: 100%;">
									<div class="select-style">
										<select name="workGrpCd"></select>
									</div><!-- end.select-style -->			
								</div>	
							</td>
						</tr>
						<tr>
							<th style="width:15%;">인터페이스명</th>
							<td colspan="3"><input type="text" name="intfName"></td>
						</tr>
						<tr>
							<th style="width:15%;">배치거래유형</th>
							<td style="width:35%;">
								<div class="select-style">
									<select name="batchType">
										<option value="FF">FILE2FILE</option>
										<option value="DF">DB2FILE</option>
										<option value="DD">DB2DB</option>
										<option value="FD">FILE2DB</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
							<th style="width:15%;">송신어댑터</th>
							<td style="width:35%;">
								<input type="text" name="sndAdptrCd" style="width:150px;">
								<input type="text" name="sndAdptrCdSeq" style="width:50px;">
								<img id="btn_pop_detail" level="R" status="DETAIL,NEW" src="<c:url value="/img/btn_pop_detail.png"/>" class="btn_img" />
								<img id="btn_pop_search" level="W" status="DETAIL,NEW" src="<c:url value="/img/btn_pop_search.png"/>" class="btn_img" />
							</td>
						</tr>
						<tr>
							<th style="width:15%;">사용 여부</th>
							<td style="width:35%;">
								<div class="select-style">
									<select name="delYn">
										<option value="1">사용</option>
										<option value="0">사용안함</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
							<th style="width:15%;">쉘 호출 허용 여부</th>
							<td style="width:35%;">
								<div class="select-style">
									<select name="eventCallVal">
										<option value="1">허용</option>
										<option value="0">허용안함</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th>1회 크기</th><td><input type="text" name="sizeOnce"> </td>
							<th>처리시간구간</th><td><input type="text" name="procTerm"></td>
						</tr>
						<tr>
							<th>요청담당자</th><td><input type="text" name="reqChgr"> </td>
							<th>요청담당자 전화번호</th><td><input type="text" name="reqChgrTlno"></td>
						</tr>
						<tr>
							<th>응답담당자</th><td ><input type="text" name="resChgr"/></td>
							<th>응답담당자 전화번호</th><td ><input type="text" name="resChgrTlno"/></td>
						</tr>
						<tr>
							<th>비 고</th>
							<td colspan="3"><input type="text" name="intfDesc"></td>
						</tr>
					</table>
				</form>
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