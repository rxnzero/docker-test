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
	var isDetail = false;
	function isValid() {
		if ($('input[name=bjobBzwkDstcd]').val() == "") {
			alert("업무그룹코드를 입력하여 주십시요.");
			return false;
		} else if ($('input[name=bjobBzwkName]').val() == "") {
			alert("업무그룹명를 입력하여 주십시요.");
			return false;
		}

		return true;
	}
	function isValidGrid() {
		if ($('input[name=msgMetaDstcd]').val() == "") {
			alert("메타구분코드를 입력하여 주십시요.");
			return false;
		} else if ($('input[name=msgDesc]').val() == "") {
			alert("메타 설명을 입력하여 주십시요.");
			return false;
		}
		return true;
	}
	function swapRow(prerow, nextrow){
		var rowid = nextrow;
		var preRowid = prerow;

		var rowData = $("#grid").jqGrid('getRowData',rowid);
		rowData['MSGCLMNSEQ'] = rowData['MSGCLMNSEQ']-1;
		var preRowData = $("#grid").jqGrid('getRowData',preRowid);
		preRowData['MSGCLMNSEQ'] = Number(preRowData['MSGCLMNSEQ'])+1;

		$('#grid').jqGrid('setRowData',rowid, preRowData);
		$('#grid').jqGrid('setRowData',preRowid, rowData);


		$("#grid").jqGrid('sortGrid','MSGCLMNSEQ',true);
		$("#grid").trigger('reloadGrid');

	}

	function imgUpunformatter(cellvalue, options, rowObject) {
		return "";
	}

	function imgDownunformatter(cellvalue, options, rowObject) {
		return "";
	}

	function imgUpformatter(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		var url = 'src=<c:url value="/img/btn_grid_up.png" />';
		return "<img id='btn_move_up' name='img_up_"+rowId+"' "+url+ " class='btn_img' />";
	}

	function imgDownformatter(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		var url = 'src=<c:url value="/img/btn_grid_down.png" />';
		return "<img id='btn_move_down' name='img_down_"+rowId+"' "+url+ " class='btn_img' />";
	}
	function unformatterFunction(cellvalue, options, rowObject) {
		return "";
	}

	function formatterFunction(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		var url = 'src=<c:url value="/img/btn_grid_delete.png" />';
		return "<img id='btn_pop_delete' name='img_del_"+rowId+"' "+url+ " class='btn_img'  />";
	}

	function gridRendering() {
		$('#grid').jqGrid(
				{
					datatype : "local",
					loadonce : true,
					rowNum : 10000,
					colNames : [ '메시지항목구분명', '메시지컬럼명', '메시지컬럼순서', '속성유형코드',
							'메시지컬럼값', '▲', '▼', '삭제' ],
					colModel : [
								{	name : 'MSGITEMDSTICNAME',	align : 'left'	, sortable:false},
								{	name : 'MSGCLMNNAME',		align : 'left'	, sortable:false},
								{	name : 'MSGCLMNSEQ',		align : 'left'	, sorttype:'integer', sortable:false},
								{	name : 'MSGCLMNATTRIPTRNCD',align : 'left'	, sortable:false},
								{	name : 'MSGCLMNVAL',		align : 'left'	, sortable:false},
								{	name : 'MOVEUP',			align : 'center',  sortable:false,	width : '50',unformat : imgUpunformatter,formatter : imgUpformatter},
								{	name : 'MOVEDOWN',			align : 'center'	, sortable:false,	width : '50',	unformat : imgDownunformatter,	formatter : imgDownformatter},
								{	name : 'DELETEYN',			align : 'center'	, sortable:false,	width : '50',	unformat : unformatterFunction,	formatter : formatterFunction}
								],
					jsonReader : {
						repeatitems : false
					},
					loadComplete : function() {
						$("img[name^=img_del]").click(function() {
							var name = $(this).attr("name");
							var rowId = name.split("_")[2];
							var rows = $('#grid').jqGrid('getGridParam','reccount');
							debugger;
							for ( var i = Number(rowId)+1 ; i <= rows; i ++){
								var newVal = $('#grid').jqGrid('getCell',i,'MSGCLMNSEQ');
								newVal = Number(newVal)-1;
								$('#grid').jqGrid('setCell',i,'MSGCLMNSEQ',newVal);
							}

							$('#grid').jqGrid('delRowData', rowId);
							$('#grid').trigger('reloadGrid');
						});

						$("img[name^=img_up]").click(function() {
							var name = $(this).attr("name");
							var rowid = name.split("_")[2];
							if(rowid==1) return;

							var preRowid = String(Number(rowid)-1);
							swapRow(preRowid,rowid);
							$('#grid').jqGrid('setSelection', preRowid);

						});

						$("img[name^=img_down]").click(function() {
							var name = $(this).attr("name");
							var rowid = name.split("_")[2];
							var rows = $('#grid').jqGrid('getGridParam','reccount');
							if( rowid==rows.toString()) return;
							var nextRowid = String(Number(rowid)+1);
							swapRow(rowid, nextRowid);
							$('#grid').jqGrid('setSelection', nextRowid);
						});

					},
					gridComplete : function() {

					},
					onSelectRow : function(rowid, status){

					},
					afterInsertRow : function (rowid, data){
						$("img[name='img_del_"+rowid+"']").click(function() {
							var name = $(this).attr("name");
							var rowId = name.split("_")[2];
							var rows = $('#grid').jqGrid('getGridParam','reccount');
							debugger;
							for ( var i = Number(rowId)+1 ; i <= rows; i ++){
								var newVal = $('#grid').jqGrid('getCell',i,'MSGCLMNSEQ');
								newVal = Number(newVal)-1;
								$('#grid').jqGrid('setCell',i,'MSGCLMNSEQ',newVal);
							}

							$('#grid').jqGrid('delRowData', rowId);
							$('#grid').trigger('reloadGrid');
						});

						$("img[name=img_up_"+rowid+"]").click(function() {

							if(rowid==1) return;

							var preRowid = String(Number(rowid)-1);
							swapRow(preRowid,rowid);
							$('#grid').jqGrid('setSelection', preRowid);

						});

						$("img[name=img_down_"+rowid+"]").click(function() {
							var rows = $('#grid').jqGrid('getGridParam','reccount');
							if( rowid==rows.toString()) return;
							var nextRowid = String(Number(rowid)+1);
							swapRow(rowid, nextRowid);
							$('#grid').jqGrid('setSelection', nextRowid);
						});
					},
					height : '300',
					autowidth : true,
					viewrecords : true
				});

		resizeJqGridWidth('grid', 'content_middle', '1000');
	}
	function init(url, key, callback) {
		if (typeof callback === 'function') {
			callback(url, key);
		}
	}
	function detail(url, key) {
		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				msgMetaDstcd : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				var list = json.list;
				//adapterType
				$("input[name=msgMetaDstcd]").attr('readonly', true);
				$("input,select").each(function() {
					var name = $(this).attr('name').toUpperCase();
					$(this).val(detail[name]);
				});
				//Prop
				$("#grid").setGridParam({
					dataType : "local",
					data : list
				}).trigger("reloadGrid");

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var url = '<c:url value="/bap/admin/message/messageMetaMan.json" />';
		var key = "${param.key}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		gridRendering();

		init(url, key, detail);
		$("#grid").jqGrid('setGroupHeaders', {
	  		useColSpanStyle: true,
	  		groupHeaders:[
				{startColumnName: 'MSGITEMDSTICNAME', numberOfColumns: 5, titleText: '메시지항목 ITEM 리스트'},
				{startColumnName: 'MOVEUP', numberOfColumns: 3, titleText: '이동'}
	  		]
		});
		$("#btn_modify").click(function() {
			if (!isValid())
				return;

			var data = $("#grid").getRowData();
			var gridData = new Array();
			for (var i = 0; i < data.length; i++) {
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
				success : function(args) {
					alert("저장 되었습니다.");
					//if (!isDetail)
					goNav(returnUrl);//LIST로 이동
					//$("#grid").trigger("reloadGrid");//LIST로 이동
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
			if (!isValidGrid()) {
				return;
			}

			var args = new Object();
	    	args['check'] = "";

		    var url = '<c:url value="/bap/admin/message/messageMetaMan.view" />';
		    url = url + "?cmd=POPUP";
		    var ret = showModal(url,args,1020,678, function(arg){
		    	var args = null;
			    if(arg == null || arg == undefined ) {//chrome
			        args = this.dialogArguments;
			        args.returnValue = this.returnValue;
			    } else {//ie
			        args = arg;
			    }

			    if( !args || !args.returnValue ) return;
				var data = new Object();
				data = args.returnValue;

				var rows = $("#grid")[0].rows;
				var index = Number($(rows[rows.length - 1]).attr("id"));
				if (isNaN(index))
					index = 0;
				var rowid = index + 1;

				data["MSGCLMNSEQ"] = rowid;
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

		    });
		});
		$("#" + $('#grid').jqGrid('getGridParam', 'selrow')).focus();

		$("#btn_pop_initialize").click(function(){

			$("#grid").jqGrid('clearGridData');

		});


		buttonControl(isDetail);
		titleControl(isDetail);
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
				<div class="title">메시지메타</div>

				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:200px;">메시지 메타구분코드</th>
							<td><input type="text" name="msgMetaDstcd" />
							</td>
						</tr>
						<tr>
							<th>메시지 설명</th>
							<td><input type="text" name="msgDesc" />
							</td>
						</tr>
						<tr>
							<th>당메시지 사용여부 *</th>
							<td><div class="select-style"><select name="thisMsgUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
							</select></div></td>
						</tr>
					</table>
				</form>

				<div style="margin-bottom:15px; text-align:right;">
					<img id="btn_pop_input"	src="<c:url value="/img/btn_input.png"/>" level="W"	status="DETAIL,NEW"  class="btn_img" />
					<img id="btn_pop_initialize" src="<c:url value="/img/btn_initialize.png"/>"" level="W"	status="DETAIL,NEW" class="btn_img" />
				</div>
				<!-- grid -->
				<table id="grid"></table>



			</div><!-- end content_middle -->
		</div><!-- end right_box -->
	</body>
</html>

