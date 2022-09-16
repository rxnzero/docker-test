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
			colNames : [ '송수신구분',
			             '어댑터키',
			             '어댑터일련번호',
			             'SQL명',
			             'SQL상세',
			             '처리단위'],
			colModel : [ { name : 'SNDRCVKIND'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '송신측';
                                 } else if ( cellvalue == '2' ) {
				                 	return '수신측';
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
				//key값
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
			colNames : [ '송수신구분',
			             '어댑터키',
			             '어댑터일련번호',
			             '파일어댑터명',
			             '파일어댑터상세',
			             '호스트IP'],
			colModel : [ { name : 'SNDRCVKIND'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '송신측';
                                 } else if ( cellvalue == '2' ) {
				                 	return '수신측';
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
				//key값
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
			colNames : [ '전송상태',
			             '송수신구분',
			             '어댑터키',
			             '어댑터일련번호',
			             '전송시작시각',
			             '전송시작시각',
			             '대상건수',
			             '처리건수',
			             '에러메세지'],
			colModel : [ { name : 'TRANSSTATUSCD'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == 'S' ) {
				                 	return '<span style="color:green">전송중</span>';
				                 }else if ( cellvalue == 'C' ) {
				                 	return '<span style="color:blue">전송완료</span>';
				                 }else if ( cellvalue == 'F' ) {
				                 	return '<span style="color:red">전송실패</span>';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'SNDRCVKIND'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '송신측';
                                 } else if ( cellvalue == '2' ) {
				                 	return '수신측';
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
			colNames : [ '전송상태',
			             '송수신구분',
			             '어댑터키',
			             '어댑터일련번호',
			             '전송시작시각',
			             '전송시작시각',
			             '원격지파일명',
			             'EAI파일명',
			             '파일사이즈',
			             '에러메세지'],
			colModel : [ { name : 'TRANSSTATUSCD'  , align : 'center',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == 'S' ) {
				                 	return '<span style="color:green">전송중</span>';
				                 }else if ( cellvalue == 'C' ) {
				                 	return '<span style="color:blue">전송완료</span>';
				                 }else if ( cellvalue == 'F' ) {
				                 	return '<span style="color:red">전송실패</span>';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
			             },
			             { name : 'SNDRCVKIND'  , align : 'left',
							  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '송신측';
                                 } else if ( cellvalue == '2' ) {
				                 	return '수신측';
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
		    if ( confirm( //"* FEP 서버           : "+ serverName +"\n"+
                          //"* 업무구분           : "+ processName + "\n"+
                          //"* 대외기관           : "+ organName +"\n"+
                          //"* FEP IP:Port        : "+ localIpPort + "\n"+
                          "재전송 하시겠습니까?") != true ){
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
					alert("재전송 작업을 실행 하였습니다.\r\n" + args.message);
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
				<div class="title">메시지 별 모니터링</div>
				<form id="ajaxForm">
					<table id="detail" class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:180px;">업무구분명</th>
							<td style="min-width:180px; max-width:300px;"><div class="select-style" ><select name="workGrpCd"></select></div> </td>
							<th style="width:180px;">작업메시지</th>
							<td style="min-width:300px; max-width:500px;"><input type="text" name="bjobDmndMsgID"/>
							</td>
						</tr>
						<tr>
							<th>배치거래유형</th>
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
							<th>작업메시지요청일시</th>
							<td ><input type="text" name="msgRegDate"/></td>
						</tr>
						<tr>
							<th>상태</th>
							<td >
								<div class="select-style">
								<select name="ErrYn">
									<option value="1">에러</option>
									<option value="2">중지</option>
									<option value="C">정상</option>
									<option value="N">전송중</option>
								</select>
								</div>
							</td>
							<th>기동구분</th>
							<td >
								<div class="select-style">
								<select name="ADPTRCD">
									<option value="T">타이머</option>
									<option value="F">폴링</option>
									<option value="E">이벤트호출</option>
									<option value="U">화면조작</option>
								</select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>인터페이스 ID</th>
							<td ><input type="text" name="intfId"/></td>
							<th>인터페이스 명</th>
							<td ><input type="text" name="intfName"/></td>
						</tr>
						<tr>
							<th>대상건수</th><td><input type="text" name="sndLineCnt"/> </td>
							<th>처리건수</th><td><input type="text" name="rcvLineCnt"/> </td>
						</tr>
						<tr>
							<th>체크건수</th><td><input type="text" name="checkRowCnt"/> </td>
							<th>파라미터(파일명)</th><td><input type="text" name="checkParam"/> </td>
						</tr>
						<tr>
							<th>송신시작일</th><td><input type="text" name="sndStartDate"/> </td>
							<th>송신완료일</th><td><input type="text" name="sndEndDate"/> </td>
						</tr>
						<tr>
							<th>수신시작일시</th><td><input type="text" name="rcvStartDate"/> </td>
							<th>수신완료일시</th><td><input type="text" name="rcvEndDate"/> </td>
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