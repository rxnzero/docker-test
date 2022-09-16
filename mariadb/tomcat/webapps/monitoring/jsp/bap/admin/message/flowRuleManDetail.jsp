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
		if ($('input[name=bjobBzwkPrcssDstcd]').val() == "") {
			alert("����ó�������ڵ带 �Է��Ͽ� �ֽʽÿ�.");
			return false;
		} else if ($('input[name=flowRulePtrnDesc]').val() == "") {
			alert("�帧��Ģ���������� �Է��Ͽ� �ֽʽÿ�.");
			return false;
		}

		return true;
	}
	function isValidGrid() {
		if ($('input[name=bjobBzwkPrcssDstcd]').val() == "") {
			alert("����ó�������ڵ带 �Է��Ͽ� �ֽʽÿ�.");
			return false;
		} else if ($('input[name=flowRulePtrnDesc]').val() == "") {
			alert("�帧��Ģ���������� �Է��Ͽ� �ֽʽÿ�.");
			return false;
		}

		return true;
	}
	function reloadGridWithScrollPosition(){

		//scroll ��ġ ����
		var scrollPosition = $('#grid').closest(".ui-jqgrid-bdiv").scrollTop();
		$("#grid").trigger('reloadGrid');

		//scroll ��ġ ����
		$('#grid').closest(".ui-jqgrid-bdiv").scrollTop(scrollPosition);

	}
	function swapRow(prerow, nextrow){
		var rowid = nextrow;
		var preRowid = prerow;

		var rowData = $("#grid").jqGrid('getRowData',rowid);
		var newVal = "000"+(rowData['BJOBSTGESERNO']-1);
		newVal = newVal.substring(newVal.length,newVal.length-3);
		rowData['BJOBSTGESERNO'] = newVal;

		var preRowData = $("#grid").jqGrid('getRowData',preRowid);
		var preNewVal = "000"+(Number(preRowData['BJOBSTGESERNO'])+1);
		preNewVal = preNewVal.substring(preNewVal.length, preNewVal.length-3);
		preRowData['BJOBSTGESERNO'] = preNewVal;

		$('#grid').jqGrid('setRowData',rowid, preRowData);
		$('#grid').jqGrid('setRowData',preRowid, rowData);

		$("#grid").jqGrid('sortGrid','BJOBSTGESERNO',true);
		reloadGridWithScrollPosition();


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
		return "<img id='btn_move_down' name='img_down_"+rowId+"' "+url+ " class='btn_img'/>";
	}
	function unformatterFunction(cellvalue, options, rowObject) {
		return "";
	}

	function formatterFunction(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		var url = 'src=<c:url value="/img/btn_grid_delete.png" />';
		return "<img id='btn_pop_delete' name='img_del_"+rowId+"' "+url+ " class='btn_img'/>";
	}

	function gridRendering() {
		$('#grid').jqGrid(
				{
					datatype : "local",
					loadonce : true,
					rowNum : 10000,
					colNames : [ 'ó�������ڵ�', '�Ϸù�ȣ', '�����ڵ�', '������', '�������Ǽ���',
							'��������', '���ο�ڵ�','BATCH�۾����������ŷ��ڵ�','Ÿ�Ӿƿ���','�۾��ݺ�Ƚ��',
							'�����׸��������','ó���켱','����Ŭ����ID','�������������ڵ�','�������������ڵ�',
							'���ǰŷ��з��ڵ�', '���������ڵ�', '�����ܰ豸���ڵ��' , '��', '��','����'],
					colModel : [
							{ name : 'BJOBBZWKPRCSSDSTCD'	, align : 'left', hidden:true	, sortable:false},
							{ name : 'BJOBSTGESERNO'		, align : 'left'	, sortable:false},
							{ name : 'BJOBSTGEDSTCD'		, align : 'left'	, sortable:false},
							{ name : 'BJOBSTGEPTRNNAME'		, align : 'left'	, sortable:false},
							{ name : 'BJOBSTGEFLXBLCNDNDESC'	, align : 'left'	, sortable:false},
								{ name : 'TELGMPTRNDSTCD'		, align : 'left'	, sortable:false},
								{ name : 'TELGMDTALSOPERCD'		, align : 'left'	, sortable:false},
								{ name : 'BJOBCMNTELGMTRANCD'	, align : 'left'	, sortable:false},
								{ name : 'TOUTVAL'				, align : 'left'	, sortable:false},
								{ name : 'BJOBITERNOTMS'		, align : 'left'	, sortable:false},
								{ name : 'CNDNITEMDCSNCTNT'		, align : 'left'	, sortable:false},
								{ name : 'TRANPRCSSPRITY'		, align : 'left'	, sortable:false},
								{ name : 'TELGMCLSID'			, align : 'left'	, sortable:false},
								{ name : 'CNDNTELGMPTRNCD'		, align : 'left'	, sortable:false},
								{ name : 'CNDNTELGMMGTCD'		, align : 'left'	, sortable:false},
								{ name : 'CNDNTRANCLSFICD'		, align : 'left'	, sortable:false},
								{ name : 'CNDNRSPNSCD'			, align : 'left'	, sortable:false},
								{ name : 'NEXTSTGEDSTCDNAME'	, align : 'left'	, sortable:false},
								{	name : 'MOVEUP',			align : 'center',  sortable:false,	width : '50',unformat : imgUpunformatter,formatter : imgUpformatter},
								{	name : 'MOVEDOWN',			align : 'center'	, sortable:false,	width : '50',	unformat : imgDownunformatter,	formatter : imgDownformatter},
								{	name : 'DELETEYN',			align : 'center'	, sortable:false,	width : '50',	unformat : unformatterFunction,	formatter : formatterFunction}

								],
					jsonReader : {
						repeatitems : false
					},
					loadComplete : function() {
						$("img[name^=img_del]").click(function() {
							//alert(rowid);
 							var name = $(this).attr("name");
							var rowId = name.split("_")[2];
							var rows = $('#grid').jqGrid('getGridParam','reccount');

							for ( var i = Number(rowId)+1 ; i <= rows; i ++){
								var newVal = $('#grid').jqGrid('getCell',i,'BJOBSTGESERNO');
								newVal = "000"+(Number(newVal)-1);
								newVal = newVal.substring(newVal.length,newVal.length-3);
								$('#grid').jqGrid('setCell',i,'BJOBSTGESERNO',newVal);
							}

							$('#grid').jqGrid('delRowData', rowId);
							reloadGridWithScrollPosition();
							//$('#grid').trigger('reloadGrid');

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
							//alert(rowid);
 							var name = $(this).attr("name");
							var rowId = name.split("_")[2];
							var rows = $('#grid').jqGrid('getGridParam','reccount');

							for ( var i = Number(rowId)+1 ; i <= rows; i ++){
								var newVal = $('#grid').jqGrid('getCell',i,'BJOBSTGESERNO');
								newVal = "000"+(Number(newVal)-1);
								newVal = newVal.substring(newVal.length,newVal.length-3);
								$('#grid').jqGrid('setCell',i,'BJOBSTGESERNO',newVal);
							}

							$('#grid').jqGrid('delRowData', rowId);
							reloadGridWithScrollPosition();
							//$('#grid').trigger('reloadGrid');

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
					ondblClickRow: function(rowId) {
							if (!isValidGrid()) {
								return;
							}

							var args = new Object();
					    	args['data'] = $("#grid").jqGrid('getRowData',rowId);
					    	args['ispop'] = true;
					    	args['rowId'] = rowId;
						    var url = '<c:url value="/bap/admin/message/flowRuleMan.view" />';
						    url = url + "?cmd=POPUP";
						    var result = showModal(url,args,1000,600, function(arg){
						    	var args = null;
							    if(arg == null || arg == undefined ) {//chrome
							        args = this.dialogArguments;
							        args.returnValue = this.returnValue;
							    } else {//ie
							        args = arg;
							    }

							    if( !args || !args.returnValue ) return;

							    var ret = args.returnValue;
							    if(ret) {
							    	$("#grid").jqGrid('setRowData', rowId,ret);
							    }
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
				key : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				var list = json.list;
				//adapterType
				$("input[name=bjobBzwkPrcssDstcd]").attr('readonly', true);
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
		var url = '<c:url value="/bap/admin/message/flowRuleMan.json" />';
		var key = "${param.key}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		gridRendering();

		init(url, key, detail);

		$("#grid").jqGrid('setGroupHeaders', {
	  		useColSpanStyle: true,
	  		groupHeaders:[
				{startColumnName: 'BJOBSTGESERNO', numberOfColumns: 4, titleText: 'BATCH�۾��ܰ�'},
				{startColumnName: 'TELGMPTRNDSTCD', numberOfColumns: 13, titleText: ''}
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

			//����θ� form���� ����
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
					alert("���� �Ǿ����ϴ�.");
					if (!isDetail)
						goNav(returnUrl);//LIST�� �̵�
					$("#grid").trigger("reloadGrid");//LIST�� �̵�
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
	 		if (!isValidGrid()) {
				return;
			}

			var args = new Object();
			var value = $("input[name=bjobBzwkPrcssDstcd]").val();
	    	args['data'] = {BJOBBZWKPRCSSDSTCD:value};
	    	args['ispop'] = false;
		    var url = '<c:url value="/bap/admin/message/flowRuleMan.view" />';
		    url = url + "?cmd=POPUP";
		    var ret = showModal(url,args,1000,600, function(arg){
		    	var args = null;
			    if(arg == null || arg == undefined ) {//chrome
			        args = this.dialogArguments;
			        args.returnValue = this.returnValue;
			    } else {//ie
			        args = arg;
			    }

		    	if( !args || !args.returnValue) return;
				var data = new Object();
				data = args.returnValue;

				var rows = $("#grid")[0].rows;
				var index = Number($(rows[rows.length - 1]).attr("id"));
				if (isNaN(index))
					index = 0;
				var rowid = index + 1;
				var serno = "000"+rowid;


				data["BJOBSTGESERNO"] = ("000"+rowid).substring(serno.length, serno.length-3);
				data["TRANPRCSSPRITY"] ='1';

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
				<div class="title">�޽����帧��Ģ</div>

				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- ����-->
						<tr>
							<th style="width:200px;">BATCH�۾�����ó�������ڵ�</th>
							<td><input type="text" name="bjobBzwkPrcssDstcd" />
							</td>
						</tr>
						<tr>
							<th>�帧��Ģ ���� ����</th>
							<td><input type="text" name="flowRulePtrnDesc" />
							</td>
						</tr>
					</table>
				</form>

				<div style="margin-bottom:15px; text-align:right;">
					<img id="btn_pop_input"	src="<c:url value="/img/btn_pop_input.png"/>" level="W" status="DETAIL,NEW"  class="btn_img" />
					<img id="btn_pop_initialize" src="<c:url value="/img/btn_pop_initialize.png"/>" level="W"	status="DETAIL,NEW" class="btn_img" />
				</div>
				<!-- grid -->
				<table id="grid"></table>



			</div><!-- end content_middle -->
		</div><!-- end right_box -->
	</body>
</html>

