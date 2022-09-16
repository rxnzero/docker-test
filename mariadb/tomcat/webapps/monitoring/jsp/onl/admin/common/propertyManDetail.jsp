<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
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
var url      = '<c:url value="/onl/admin/common/propertyMan.json" />';
var url_view = '<c:url value="/onl/admin/common/propertyMan.view" />';
	var isDetail = false;
	var lastsel2;
	function isValid() {
		if ($('input[name=prptyGroupDesc]').val() == "") {
			alert("<%= localeMessage.getString("propertyDetail.checkRequired1") %>");
			return false;
		}

		return true;
	}
	function isValidGrid() {
		if ($('input[name=prptyName]').val() == "") {
			alert("<%= localeMessage.getString("propertyDetail.checkRequired2") %>");
			return false;
		} else if ($('input[name=prpty2Val]').val() == "") {
			alert("<%= localeMessage.getString("propertyDetail.checkRequired3") %>");
			return false;
		}
		//중복체크
		if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
			$("#grid").saveRow(lastsel2,false,"clientArray");
		}
		var data = $("#grid").getRowData();
		for ( var i = 0; i < data.length; i++) {
			if (data[i]['PRPTYNAME'] == $('input[name=prptyName]').val()) {
				alert("<%= localeMessage.getString("propertyDetail.checkDuplicate") %>");
				return false;
			}
		}

		return true;
	}
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
			colNames : [ '<%= localeMessage.getString("propertyDetail.propertyKey") %>', '<%= localeMessage.getString("propertyDetail.propertyValue") %>', '<%= localeMessage.getString("propertyDetail.delYn") %>' ],
			colModel : [ { name : 'PRPTYNAME' , align : 'left', editable : true },
			             { name : 'PRPTY2VAL' , align : 'left', editable : true },
			             { name : 'DELETEYN'  , align : 'center', unformat : unformatterFunction, formatter : formatterFunction } ],
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
			height : '500',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});

		resizeJqGridWidth('grid', 'content_middle', '1000');
	}
	function init( key, callback) {
		if (typeof callback === 'function') {
			callback( key);
		}
	}
	function detail( key) {

		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				prptyGroupName : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				$("input[name=prptyGroupName]").attr('readonly', true);
				$("input[name=prptyGroupName]").val(detail['PRPTYGROUPNAME']);
				$("input[name=prptyGroupDesc]").val(detail['PRPTYGROUPDESC']);
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
		var key = "${param.prptyGroupName}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		gridRendering();

		init( key, detail);

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
					alert("<%= localeMessage.getString("common.saveMsg") %>");
					goNav(returnUrl);//LIST로 이동
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
					alert("<%= localeMessage.getString("common.deleteMsg") %>");
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
			var data = new Object();
			data["PRPTYNAME"] = $("input[name=prptyName]").val();
			data["PRPTY2VAL"] = $("input[name=prpty2Val]").val();

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
			$("#" + $('#grid').jqGrid('getGridParam', 'selrow')).focus();
			$("img[name=img_" + rowid + "]").click(function() {
				var name = $(this).attr("name");
				var rowId = name.split("_")[1];
				$('#grid').jqGrid('delRowData', rowId);
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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title"><%= localeMessage.getString("propertyDetail.title") %></div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;"><%= localeMessage.getString("property.propertyGroupName") %> *</th>
							<td><input type="text" name="prptyGroupName"/></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("property.propertyGroupDesc") %></th>
							<td><input type="text" name="prptyGroupDesc"/></td>
						</tr>
					</table>
				</form>
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:20%;"><%= localeMessage.getString("propertyDetail.propertyKey") %></th>
						<td><input type="text" name="prptyName" style="width:calc(100% - 85px);" /><img src="<c:url value="/img/btn_pop_input.png"/>" id="btn_pop_input" /></td>						
					</tr>
					<tr>
						<th><%= localeMessage.getString("propertyDetail.propertyValue") %></th>
						<td><input type="text" name="prpty2Val"/></td>
					</tr>
				</table>
				<!-- grid -->
				<table id="grid"></table>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>