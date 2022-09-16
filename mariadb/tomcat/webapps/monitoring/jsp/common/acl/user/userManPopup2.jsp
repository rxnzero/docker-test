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
<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" >
var url ='<c:url value="/common/acl/user/userMan.json" />';
var userId = window.dialogArguments["userId"];
var arrGridData = new Array();

// �����ڵ� List Count ��ȸ
function init()
{
	$.ajax({
		type : "POST",
		url:url,
		data:{ cmd:"LIST_BIZ_COUNT"},
		success:function(json){
			$("input[name=totalCnt]").val(json.bizCount);
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

// �����ڵ带 �߰� �� ���� �� �� validation üũ
function isGridValid(gridName)
{
	var gridCnt	= 0;

	gridCnt = $(gridName).jqGrid("getGridParam", "selarrrow").length;
	if(gridCnt <= 0)
	{
		alert("<%= localeMessage.getString("userPop.checkRequierd1") %>");
		return false;
	}

	return true;
}

// ��� �׸��� Reload.
function targetGridReload(){
	var postData = getSearchForJqgrid("cmd","LIST_USER_BIZ"); //jqgrid������ object ��
	postData["userId"] = userId;
	postData["targetGridYn"] = "Y";
	$("#targetGrid").setGridParam({ postData: postData ,page : "1"  }).trigger("reloadGrid");
}

// ��� �׸��� ��ȸ
function targetGrid()
{
	var gridPostData = getSearchForJqgrid("cmd","LIST_USER_BIZ"); //jqgrid������ object ��
	gridPostData["userId"] = userId;
	gridPostData["targetGridYn"] = "Y";

	$('#targetGrid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		loadui: "disable",
		postData : gridPostData,
		colNames:['<%= localeMessage.getString("unifbwk.bizCode") %> ',
                  '<%= localeMessage.getString("unifbwk.bizName") %>',
                  'CHK'
                  ],
		colModel:[
				{ name : 'BIZCODE'   , align:'left'		,key:true	,sortable:false  },
				{ name : 'BIZNAME'   , align:'left'  },
				{ name : 'CHK'   , hidden:true  }
				],
        jsonReader: {
             repeatitems:false
        },
	    autoheight: true,
	    height: $("#container").height(),
	    height: 430,
		autowidth: true,
		viewrecords: true,
		gridview: true,						// jqGrid�� ���� ��� - treeGrid, subGrid, afterInsertRow event�� ��� ����.
		scroll: true,						// ��ũ�� ��뿩�� ����.(default: false)
		rowNum : 10000,						// Grid�� ǥ�õ� ���ڵ� �� ���� (-1�� ��ȸ�� ������ ���� �׸��忡 ����).
		multiselect : true,

		loadComplete:function (d){
			var targetGridCnt	= $("#targetGrid").getGridParam("reccount");
			var colModel = $(this).getGridParam("colModel");

			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}

			arrGridData = $("#targetGrid").getRowData();

			// ����� �����ڵ� List Count
			$("input[name=selectCnt]").val(targetGridCnt);

			// �˻������� �����Ͱ� ������ �ش� row ����.
			var searchName = $("input[name=searchBzwkName]").val().split(",");
			for(var idx in searchName){
				var val = searchName[idx];
				$("#targetGrid").jqGrid('setSelection', val, true);
			}
		},
		gridComplete:function (d){
			$("input[name=selectCnt]").val($("#targetGrid").getGridParam("reccount"));
		},
		onSelectRow: function(rowId){
			// ���õ� row�� �̵�
			$("#"+$("#targetGrid").jqGrid("getGridParam", "selrow")).focus();
		}
	});
}

// ����
function modify(modifyType, grid)
{
	var gridData = new Array();

	if(modifyType == "add")
	{
		gridData = grid;
	}

	if(modifyType == "delete")
	{
		var data = $(grid).getRowData();
		for ( var i = 0; i < data.length; i++) {
			gridData.push(data[i]);
		}
	}

	$.ajax({
		type : "POST",
		url:url,
		data:{ cmd:"TRANSACTION_USER_BIZ"
			 , userId:userId
			 , gridData:JSON.stringify(gridData)

		},
		success:function(){
			alert("<%= localeMessage.getString("common.saveMsg") %>");

			// �˻��� �ʱ�ȭ
			$("input[name=searchBzwkName]").val("").focus();

			$("#btn_search").click();
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

$(document).ready(function() {
	// �����ڵ� List Count
	init();

	// ��ü �����ڵ� ��ȸ
	var gridPostData = getSearchForJqgrid("cmd","LIST_USER_BIZ"); //jqgrid������ object ��
	gridPostData["userId"] = userId;

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['<%= localeMessage.getString("unifbwk.bizCode") %> ',
                  '<%= localeMessage.getString("unifbwk.bizName") %>',
                  'CHK',
                  'CNT'
                  ],
		colModel:[
				{ name : 'BIZCODE'   , align:'left'	,sortable:false  },
				{ name : 'BIZNAME'   , align:'left'  },
				{ name : 'CHK'   , align:'left' ,hidden:true },
				{ name : 'CNT'   , align:'left' ,hidden:true }
				],
        jsonReader: {
             repeatitems:false
        },
	    autoheight: true,
	    height: $("#container").height(),
	    height: 430,
		autowidth: true,
		viewrecords: true,
		gridview: true,						// jqGrid�� ���� ��� - treeGrid, subGrid, afterInsertRow event�� ��� ����.
		scroll: true,						// ��ũ�� ��뿩�� ����.(default: false)
		rowNum : 10000,						// Grid�� ǥ�õ� ���ڵ� �� ���� (-1�� ��ȸ�� ������ ���� �׸��忡 ����).
		multiselect : true,

		loadComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}

		},
		gridComplete:function (d){
			targetGridReload();
		},
	});

	// target Grid
	targetGrid();

	$("#btn_close").click(function(){
		window.close();
	});

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST_USER_BIZ"); //jqgrid������ object ��
		postData["userId"] = userId;
		$("#grid").setGridParam({ postData: postData ,page : "1"  }).trigger("reloadGrid");
	});

	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});

	// ��ȸ�� �׸��忡�� ��� �׸���� �����ڵ� �߰�.
	$("input[name=add]").click(function(){

		if(!isGridValid("#grid")) return;

	 	var selRowIds = $("#grid").jqGrid("getGridParam", "selarrrow");

		for(var i=0;i<selRowIds.length;i++){
		    $("#grid").jqGrid("setCell", selRowIds[i], "CHK", "true");
		    arrGridData.push($("#grid").getRowData(selRowIds[i]));
		}

		modify("add", arrGridData);

	});

	// ���׸��忡�� ���õ� �����ڵ� ����
	$("input[name=remove]").click(function(){
		if(!isGridValid("#targetGrid")) return;

		var targetGrid			= $("#targetGrid");
		var selTargetGridIds	= targetGrid.jqGrid("getGridParam", "selarrrow");

		for(var i=0;i<selTargetGridIds.length;i++){
		    $("#targetGrid").jqGrid("setCell", selTargetGridIds[i], "CHK", "false");
		}

		modify("delete", "#targetGrid");

	});


	buttonControl();

});

</script>
</head>
	<body>
		<!-- button -->
		<table  width="95%" height="35px"  align="center">
		<tr>
			<td align="left" height="25px"><p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>"><%= localeMessage.getString("userPop2.title") %></p></td>
			<td align="right">

			</td>
		</tr>
		</table>
		<!-- line -->
		<div class="container" id="line">
			<div class="left full title_line "> </div>
		</div>
		<!-- button -->
		<table  width="98%" height="35px" style="margin-left:10px;" >
			<tr>
				<td align="left">
					<table width="65%">
						<tr>
							<td class="search_td_title" width="150px"><%= localeMessage.getString("unifbwk.bizCode") %></td>
							<td><input type="text" name="searchBzwkName" value="${param.searchBzwkName}" style="width:100%"></td>
							<td><img id="btn_search" src="<c:url value="/images/bt/bt_search.gif"/>"     level="R"/></td>
						</tr>
					</table>
				</td>
				<td align="right" width="200px">
					<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>"  level="R"/>
				</td>
			</tr>
		</table>
		<table  width="99%">
			<tr>
				<td align="right" style="padding-right: 5px;">
					 <input name="selectCnt" readOnly style="border-style:solid;border-width:0" size='5' value ="" />/<input name="totalCnt" readOnly style="border-style:solid;border-width:0" size='3' value ="" />
				</td>
			</tr>
		</table>
		<!-- grid -->
		<table width="98%" style="margin-left:10px;">
			<tr>
				<td width="50%">
					<div id="grid_div"><table id="grid" ></table></div>
				</td>
				<td>
					<input type=button name="add" value=">" style="width:40px"/><br><br>
					<input type=button name="remove" value="<" style="width:40px"/><br><br>
				</td>
				<td width="50%">
					<div id="targetGrid_div"><table id="targetGrid" ></table></div>
				</td>
			</tr>
		</table>
	</body>
</html>

