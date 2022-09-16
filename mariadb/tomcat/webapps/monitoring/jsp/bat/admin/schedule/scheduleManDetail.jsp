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

    var url      = '<c:url value="/bat/admin/schedule/scheduleMan.json" />';
    var url_view = '<c:url value="/bat/admin/schedule/scheduleMan.view" />';
	var isDetail = false;

	function unformatterFunction(cellvalue, options, rowObject) {
		return "";
	}

	function formatterFunction(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		return "<img id='btn_pop_delete' name='img_"+rowId+"' src=<c:url value='/images/bt/pop_delete.gif' /> />";
	}

	function gridRendering() {
		$('#grid').jqGrid({
			datatype : "json",
			mtype : 'POST',
			colNames : [ '인터페이스ID',
			             '인터페이스명',
			             '삭제여부'],
			colModel : [ { name : 'INTFID'     , align : 'center'},
			             { name : 'INTFNAME'   , align : 'left'},
			             { name : 'DELETEYN'    , align : 'center', unformat : unformatterFunction, formatter : formatterFunction }],
			jsonReader : {
				repeatitems : false
			},
			loadComplete : function() {
			},
			ondblClickRow: function(rowId) {
				var rowData = $(this).getRowData(rowId); 
            	var intfId    = rowData['INTFID'];
				var url2 = '<c:url value="/bat/admin/interface/interfaceMan.view" />' + "?cmd=DETAIL";
				url2 = url2 + '&page='+'${param.page}';
            	url2 = url2 + '&returnUrl='+getReturnUrl();
            	url2 = url2 + '&menuId='+'${param.menuId}';
				//key값
            	url2 = url2 + '&intfId='+intfId;
				url2 = url2 + '&returnUrl='+getReturnUrl();
				goNav(url2);
			},
			
			height : '200',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});


		resizeJqGridWidth('grid', 'title', '1000');
	}
	function init(key, callback) {
		$("input[name=bjobMsgScheID]").css({'background-color' : '#e5e5e5'});
		$("input[name=bjobMsgScheID]").attr("readonly",true);
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=workGrpCd]")).setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
				//$("select[name=workGrpCd]").searchable();
				setSearchable('workGrpCd');
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

		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				bjobMsgScheID : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				debugger;
				$("select[name=workGrpCd]").attr("disabled",true);
				$("select[name=workGrpCd]").css({'background-color' : '#e5e5e5'});
				$("select[name=batchType]").attr("disabled",true);
				$("select[name=batchType]").css({'background-color' : '#e5e5e5'});
				$("select[name=scheKind]").attr("disabled",true);
				$("select[name=scheKind]").css({'background-color' : '#e5e5e5'});
				
				
				
				$("input[name=intfId]").css({'background-color' : '#e5e5e5'});
				$("select[name=adptrKind]").css({'background-color' : '#e5e5e5'});
				$("input,select").each(function(){
					var name = $(this).attr('name');
					//.toUpperCase();
					if ( name != null )
						$(this).val(detail[name.toUpperCase()]);
				});
				$("#grid")[0].addJSONData(data);
				$("img[name*=img]").click(function() {
					var name = $(this).attr("name");
					var rowId = name.split("_")[1];
					$('#grid').jqGrid('delRowData', rowId);
				});
				

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.bjobMsgScheID}";
		
		$("input[name=sndrcvStartHMS]").inputmask("99:99",{'autoUnmask':true});
		$("input[name=sndrcvEndHMS]").inputmask("99:99",{'autoUnmask':true});
		$("input[name=dayCycleTime]").inputmask("99:99",{'autoUnmask':true});
		
		if (key != "" && key != "null") {
			isDetail = true;
		}

		gridRendering();

		init(key, detail);

		$("#btn_modify").click(function() {
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
		$("#btn_pop_input").click(function() {
		    var workGrpCd = $("select[name=workGrpCd]").val();
			var batchType = $("select[name=batchType]").val();
			var url2 = url_view;
			url2 = url2 + "?cmd=SELECTINTERFACE";
			var args = new Object();
		    args['workGrpCd']  = workGrpCd;
		    args['batchType']  = batchType;

			var ret = showModal(url2,args,800,600, function(arg){
				var args = null;
			    if(arg == null || arg == undefined ) {//chrome
			        args = this.dialogArguments;
			        args.returnValue = this.returnValue;
			    } else {//ie
			        args = arg;
			    }
			    
			    if( !args || !args.returnValue ) return;
			    
			    var ret = args.returnValue;
			    
				if(ret == undefined) return;
				$("select[name=workGrpCd]").val(ret[0]);
				$("select[name=batchType]").val(ret[1]);
				batchType = $("select[name=batchType]").val();
				if ( batchType == 'DD' || batchType == 'DF' ){
					$("select[name=scheKind]").val('T');
				}else{
					$("select[name=scheKind]").val('F');
				}
				for ( var i=2; i<ret.length;i++){
					var data = new Object();
					data["INTFID"]   = ret[i++];
					data["INTFNAME"] = ret[i];
					
					var exist = false;
					var griddata = $("#grid").getRowData();
					for ( var j = 0; j < griddata.length; j++) {
						if (griddata[j]['INTFID'] == data["INTFID"]) {
							exist = true;
							break;
						}
					}
					
					if ( exist )
						continue;
					
					var rows = $("#grid")[0].rows;
					var index = Number($(rows[rows.length - 1]).attr("id"));
					if (isNaN(index))
						index = 0;
					var rowid = index + 1;
					$("#grid").jqGrid('addRow', {
						rowID : rowid,
						initdata : data,
						position : "last", //first, last
						useDefValues : false,
						useFormatter : false,
						addRowParams : {
							extraparam : {}
						}	
					});
					$("img[name=img_" + rowid + "]").click(function() {
						var name = $(this).attr("name");
						var rowId = name.split("_")[1];
						$('#grid').jqGrid('delRowData', rowId);
					});
				}
			});
			
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">스케쥴</div>						
				
				<!-- detail -->
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th>스케쥴ID</th>
							<td style="width:30%;"><input type="text" name="bjobMsgScheID" readonly="readonly"></td>
							<th>업무구분명</th>
							<td style="width:30%;">
								<div style="position: relative; width: 100%;">
									<div class="select-style">
										<select name="workGrpCd" ></select>
									</div><!-- end.select-style -->		
								</div>	
							</td>
						</tr>
						<tr><th>배치거래유형</th>
							<td style="width:30%;">
								<div class="select-style">
									<select name="batchType" >
										<option value="FF">FILE2FILE</option>
										<option value="DF">DB2FILE</option>
										<option value="DD">DB2DB</option>
										<option value="FD">FILE2DB</option>
									</select>
								</div><!-- end.select-style -->			
							</td>
							<th>스케쥴 구분</th>
							<td style="width:30%;">
								<div class="select-style">
									<select name="scheKind" >
										<option value="T">타이머</option>
										<option value="F">폴링</option>
									</select>
								</div><!-- end.select-style -->			
							</td>
						</tr>
						<tr><th>스케쥴상세</th><td colspan="3"><input type="text" name="thisMsgScheDesc"></td></tr>
						<tr><th>기동시작</th><td><input type="text" name="sndrcvStartHMS"></td>
							<th>기동종료</th><td><input type="text" name="sndrcvEndHMS"></td>
						</tr>
						<tr>
							<th>반복주기</th><td><input type="text" name="dayCycleTime"></td>
							<th>사용 여부</th>
							<td style="width:30%;">
								<div class="select-style">
									<select name="thisMsgUseYn" >
										<option value="1">사용</option>
										<option value="0">사용안함</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
					</table>
				</form>
				
				<div style="margin-bottom:15px; text-align:right;">
					<img id="btn_pop_input"	src="<c:url value="/img/btn_pop_input.png"/>" level="W" status="DETAIL,NEW"  class="btn_img" /> 
				</div>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>