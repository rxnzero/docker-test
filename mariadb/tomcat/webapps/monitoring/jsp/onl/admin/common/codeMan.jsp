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

<style>
	.img_pointer{
		cursor:pointer;
	}
</style>

<script language="javascript" >

	var url			='<c:url value="/onl/admin/common/codeMan.json" />';
	var url_view	='<c:url value="/onl/admin/common/codeMan.view" />';
	var modify_rowID = 1;
	var scrollPosition = 0;

	function treeGrid_reload(codeGroup)
	{
		var postData	= {cmd : "LIST_TREE", page : "1", searchCodeGroup : codeGroup};
		$("#tree").setGridParam({ postData: postData}).trigger("reloadGrid");

	}

	// Start �ʱ�ȭ(jquery ready)
	$(document).ready(function(){
		$("input[name=searchName]").focus();

		var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��

		$('#grid').jqGrid({
			datatype:"json",
			mtype: 'POST',
			url: url,
			postData : gridPostData,
			colNames:[
						'<%= localeMessage.getString("code.codeGroup") %>'
					 ,	'<%= localeMessage.getString("code.codeGroupDesc") %>'
					 ,	'CHILDCNT'
					 ],
			colModel:[
						{ name : 'CDGROUP'		, align:'left', width: "360"	,sortable:false}
					,	{ name : 'CDGROUPDESC'	, align:'left', width: "370"}
					,	{ name : 'CHILDCNT'		, hidden:true}
					 ],
	        jsonReader: {
	             repeatitems:false
	        },
			rowNum : 10000,
		    height: "500",
			viewrecords: true,
			gridComplete:function (d){
				var colModel = $(this).getGridParam("colModel");
				for(var i = 0 ; i< colModel.length; i++){
					$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)
				}

			},
			loadComplete:function (d){		// JqGrid ��ȸ �� �ѹ��� ����. (ȭ�� �ʱ� ���� ���.)
				var rowCnt = $("#grid").getGridParam("reccount");

				if(rowCnt > 0)
				{
					$("#grid").jqGrid('setSelection', modify_rowID, true);
					$(".ui-jqgrid-bdiv").scrollTop(scrollPosition);

					// �ʱ�ȭ
					modify_rowID = 1;
					scrollPosition = 0;

					var treeRowCnt = $("#tree").getGridParam("reccount");
					var rowId		= $("#grid").getGridParam("selrow");

					// Tree Grid ����.
					searchTree(rowId);

					// ��ȸ�� �����͸� Form�� �����ϴ� �Լ�.
					setFormGrid("grid", rowId);

					/* Start [����], [����] �Ϸ� �� ����ȸ ���� �� Tree Grid List�� ���� ��ħ �մϴ�. */
					if(treeRowCnt == 0)
					{
						var row			= $("#grid").getRowData(rowId);
						var cdGroup		= row["CDGROUP"];
						treeGrid_reload(row["CDGROUP"]);
					}
					/* End [����], [����] �Ϸ� �� ����ȸ ���� �� Tree Grid List�� ���� ��ħ �մϴ�. */
				}
				else
				{
					treeGrid_reload("");
				}
			},
	       	onCellSelect: function(rowId, index, contents, event){
	       		var cdGroup		= $("#grid").jqGrid("getCell", rowId, "CDGROUP");
	       		treeGrid_reload(cdGroup);

	       		// ���� ������ ����.
	       		setFormGrid("grid", rowId);
	       	}
		});

		/* Start ��ư �̺�Ʈ */
		//------ Start Grid Button ------
		// �űԹ�ư Ŭ�� �̺�Ʈ
		$("#btn_newGrid").click(function(){

			var rowId	= $("#grid").getGridParam("selrow");

			if (isNull(rowId)){
				alert("<%= localeMessage.getString("code.checkRequierd1") %>");
				return ;
			}

			var row			= $("#grid").getRowData(rowId);
			var cdGroup		= row["CDGROUP"];
			var cdGroupDesc	= row["CDGROUPDESC"];

			var args = new Object();
			args["cdGroup"]		= cdGroup;
			args["cdGroupDesc"]	= cdGroupDesc;

			var url2 = url_view;
			url2 += "?cmd=GROUP POPUP";
			var ret = showModal(url2,args,540,400, function(arg){
				var args = null;
		        if(arg == null || arg == undefined ) {//chrome
		            args = this.dialogArguments;
		            args.returnValue = this.returnValue;
		        } else {//ie
		            args = arg;
		        }

		        if( !args || !args.returnValue ) {return;}
		        else {
		        	if(args.returnValue != "" ) $("#btn_search").click();
		        }

			});
		});

		// ������ư Ŭ�� �̺�Ʈ
		$("#btn_modifyGrid").click(function(){

			var rowId = $('#grid').getGridParam( "selrow" );

			if (isNull(rowId)){
				alert("<%= localeMessage.getString("code.checkRequierd1") %>");
				return ;
			}
			if(!isValidGrid()){
				return;
			}

			var r = confirm("<%= localeMessage.getString("common.checkSave") %>");
 			if (r == false){
 				return;
 			}

			var postData = $('#ajaxFormGrid').serializeArray();
			postData.push({ name: "cmd" , value:"UPDATE_GROUP"});
			$.ajax({
				type : "POST",
				url:url,
				data:postData,
				success:function(args){
					alert("<%= localeMessage.getString("common.saveMsg") %>");

					// ������ row ��ġ ����.
					modify_rowID = rowId;
					scrollPosition = $(".ui-jqgrid-bdiv").scrollTop();

					$('#grid').jqGrid('clearGridData');
					$("#btn_search").click();//����ȸ
				},
				error:function(e){
					alert(e.responseText);
				}
			});
		});

		// ������ư Ŭ�� �̺�Ʈ
		$("#btn_deleteGrid").click(function(){
			var rowId = $('#grid').getGridParam( "selrow" );

			if (isNull(rowId)){
				alert("<%= localeMessage.getString("code.checkRequierd1") %>");
				return ;
			}

		 	var row			= $('#grid').getRowData( rowId );
		 	var childCnt	= row.CHILDCNT;

		 	if(childCnt == 0)
		 	{
		 		var r = confirm("<%= localeMessage.getString("common.checkDelete") %>");
	 			if (r == false){
	 				return;
	 			}
		 	}
		 	else
		 	{
			 	var r = confirm("<%= localeMessage.getString("code.checkMsg1") %>");
	 			if (r == false){
	 				return;
	 			}
		 	}

			var postData = new Array();
			postData.push({ name: "cmd" , value:"DELETE_GROUP"});
			postData.push({ name: "cdGroup" , value:$("input[name=cdGroup]").val()});
			postData.push({ name: "childCnt" , value:childCnt});

			postData.push();
			$.ajax({
				type : "POST",
				url:url,
				data:postData,
				success:function(args){
					alert("<%= localeMessage.getString("common.deleteMsg") %>");
					$('#tree').jqGrid('clearGridData');
					$("#btn_search").click();//����ȸ
				},
				error:function(e){
					alert(e.responseText);
				}
			});
		});
		//------ End Grid Button ------

		//------ Start Tree Grid Button ------
		// �űԹ�ư Ŭ�� �̺�Ʈ
		$("#btn_newTree").click(function(){

			var rowIdGrid	= $("#grid").getGridParam("selrow");
			var rowIdTree	= $("#tree").getGridParam("selrow");

			if (isNull(rowIdGrid)){
				alert("<%= localeMessage.getString("code.checkRequierd1") %>");
				return ;
			}

			if (isNull(rowIdTree)){
				alert("<%= localeMessage.getString("code.checkRequierd1") %>");
				return ;
			}

			var rowGrid		= $("#grid").getRowData(rowIdGrid);
			var rowTree		= $("#tree").getRowData(rowIdTree);

			var level		= rowTree["level"];
			var codeGroup	= rowGrid["CDGROUP"];
			var code		= rowTree["CODE"];
			var parentCode	= rowTree["PARENTCODE"];
			var seq			= rowTree["SEQ"];

			var args = new Object();
			args["level"]		= level;
			args["codeGroup"]	= codeGroup;
			args["code"]		= code;
			// args["parentCode"]	= parentCode;
			// 2 depth �̻� ���� �ʴ´�. (�������� �ƴ� )
            args["parentCode"]  = "";
			args["seq"]			= seq;

			var url2 = url_view;
			url2 += "?cmd=POPUP";
			var ret = showModal(url2,args,540,400, function(arg){
				var args = null;
		        if(arg == null || arg == undefined ) {//chrome
		            args = this.dialogArguments;
		            args.returnValue = this.returnValue;
		        } else {//ie
		            args = arg;
		        }

		        if( !args || !args.returnValue ) {return;}
		        else {

		        	var ret = args.returnValue;
		        	if(ret == "true")
					{
						$('#tree').jqGrid('clearGridData');
						var cdGroup		= rowGrid["CDGROUP"];

						treeGrid_reload(cdGroup);
					}
		        }

			});

		});

		// ������ư Ŭ�� �̺�Ʈ
		$("#btn_modifyTree").click(function(){

			var rowId = $('#tree').getGridParam( "selrow" );
			var row = $('#tree').getRowData( rowId );

			if (isNull(rowId)){
				alert("<%= localeMessage.getString("code.checkRequierd1") %>");
				return ;
			}
			if(!isValidTree()){
				return;
			}

			var r = confirm("<%= localeMessage.getString("common.checkSave") %>");
 			if (r == false){
 				return;
 			}

			var postData = $('#ajaxFormTree').serializeArray();
			postData.push({ name: "cmd" , value:"UPDATE"});
			$.ajax({
				type : "POST",
				url:url,
				data:postData,
				success:function(args){
					alert("<%= localeMessage.getString("common.saveMsg") %>");
					$('#tree').jqGrid('clearGridData');
					var cdGroup		= row["CDGROUP"];
					treeGrid_reload(cdGroup);
				},
				error:function(e){
					alert(e.responseText);
				}
			});
		});

		// ������ư Ŭ�� �̺�Ʈ
		$("#btn_deleteTree").click(function(){
			var rowId = $('#tree').getGridParam( "selrow" );

			if (isNull(rowId)){
				alert("<%= localeMessage.getString("code.checkRequierd1") %>");
				return ;
			}

		 	var row = $('#tree').getRowData( rowId );

		 	var ids = $('#tree').getDataIDs();
		 	var index = $('#tree').getInd(rowId);

		 	if (ids.length > Number(index) ){

		 		//check
			 	var childlevel = $('#tree').jqGrid('getCell',ids[Number(index)],'level');
		 		if (row["level"] > 0 && row["level"]< childlevel){//child ����
		 			var r = confirm("<%= localeMessage.getString("code.checkMsg1") %>");
		 			if (r == false){
		 				return;
		 			}
		 			else
		 			{
		 				$('#tree').jqGrid('resetSelection');
		 			}
		 		}
		 		else
		 		{
		 			var r = confirm("<%= localeMessage.getString("common.checkDelete") %>");
		 			if (r == false){
		 				return;
		 			}
		 		}
		 	}
		 	else
	 		{
	 			var r = confirm("<%= localeMessage.getString("common.checkDelete") %>");
	 			if (r == false){
	 				return;
	 			}
	 		}

			var postData = new Array();
			postData.push({ name: "cmd" , value:"DELETE"});
			postData.push(
							{ name: "codeGroup" , value:$("input[name=codeGroup]").val()}
						,	{ name : "code", value: $("input[name=code]").val()}
						,	{ name : "level", value: row["level"]}
						);
			$.ajax({
				type : "POST",
				url:url,
				data:postData,
				success:function(args){
					alert("<%= localeMessage.getString("common.deleteMsg") %>");
					$('#tree').jqGrid('clearGridData');
					var cdGroup		= row["CDGROUP"];
					treeGrid_reload(cdGroup);
				},
				error:function(e){
					alert(e.responseText);
				}
			});
		});

		//------ End Tree Grid Button ------


		// �˻���ư Ŭ�� �̺�Ʈ
		$("#btn_search").click(function(){
			$('#tree').jqGrid('clearGridData');
			var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��
			$("#grid").setGridParam({ postData: postData}).trigger("reloadGrid");
		});

		/* End ��ư �̺�Ʈ */

		// ���� Ű �̺�Ʈ
		$("input[name^=search]").keydown(function(key){
			if (key.keyCode == 13){
				$("#btn_search").click();
			}
		});

		buttonControl();

		resizeJqGridWidth('grid','gridList','1000');
		resizeJqGridWidth('tree','treeList','1000');
	});
	// End �ʱ�ȭ(jquery ready)

	function isValidGrid(){

		if($('input[name=cdGroup]').val() == "")
		{
			alert("<%= localeMessage.getString("code.checkRequierd1") %>");
			$('input[name=cdGroup]').focus();
			return false;
		}

		return true;
	}


	function isValidTree(){
		var rowId	= $("#tree").getGridParam("selrow");

		var row		= $("#tree").getRowData(rowId);
		var level	= row['level'];

		if($('input[name=codeGroup]').val() == "")
		{
			alert("<%= localeMessage.getString("code.checkRequierd1") %>");
			$('input[name=codeGroup]').focus();
			return false;
		}
		else if(level > 0 && $('input[name=code]').val() == "")
		{
			alert("<%= localeMessage.getString("code.checkRequierd2") %>");
			$('input[name=code]').focus();
			return false;
		}
		else if(level > 0 && $('input[name=codeName]').val() == "")
		{
			alert("<%= localeMessage.getString("code.checkRequierd3") %>");
			$("input[name=codeName]").focus();
			return false;
		}

		return true;
	}


	// ��ȸ�� �����͸� Form�� �����ϴ� �Լ�.
	function setFormGrid(gridId, rowId)
	{
		var data = $("#" + gridId).getRowData(rowId);

		$("#ajaxFormGrid input[type!=radio],#ajaxFormGrid select,#ajaxFormGrid textarea").each(function(){
			var name = $(this).attr("name");
			var tag  = $(this).prop("tagName").toLowerCase();

			$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
		});
	}

	// Ʈ�� �׸��� �Լ�.
	function searchTree(rowId)
	{
		var rowData	= $("#grid").getRowData(rowId);
		var cdGroup	= rowData["CDGROUP"];

		$('#tree').jqGrid({
			datatype:"json",
			mtype: 'POST',
			url: url,
			postData : {cmd : "LIST_TREE", searchCodeGroup : cdGroup},

			colNames:['CODEGROUP'
					, '<%= localeMessage.getString("code.code") %>'
					, '<%= localeMessage.getString("code.codeName") %>'
					, '<%= localeMessage.getString("combo.useYn") %>'
					, '<%= localeMessage.getString("code.order") %>'
					, 'PARENTCODE'
					, 'USEYNNAME'
			],
			colModel:[{ name : 'CODEGROUP'		, hidden:true	,sortable:false }
					, { name : 'CODE'			, align:'left', key:true, width: "305"  }
					, { name : 'CODENAME'		, align:'left', width: "305"  }
					, { name : 'USEYNNAME'		, align:'center'  }
					, { name : 'SEQ'			, align:'center'  }
					, { name : 'PARENTCODE'		, hidden:true  }
					, { name : 'USEYN'			, hidden:true  }
			],
	        treeGrid: true,
	        treeIcons: {
	        	plus: "ui-icon-circlesmall-plus",
				minus: "ui-icon-circlesmall-minus",
				leaf : "ui-icon-document"
	        },
	        treeGridModel: "adjacency",
	        ExpandColumn: "CODE",
	        height: "500",
// 	        autowidth: true,
	        width: 'auto',
// 	        shrinkToFit: true,
		    rowNum : 10000,
		    treeIcons: {leaf:'ui-icon-document-b'},
		    jsonReader: {
	             repeatitems:false
	        },
			gridComplete:function (d){
				var colModel = $(this).getGridParam("colModel");
				for(var i = 0 ; i< colModel.length; i++){
					$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)
				}
			},
			loadComplete:function (d){
				var rowCnt = $("#tree").getGridParam("reccount");

				if(rowCnt > 0)
				{
					var searchName = $("input[name=searchName]").val();

					if(searchName != "")
					{
						// �˻������� �����Ͱ� ������ �ش� row ����.
						$("#tree").jqGrid('setSelection', searchName, true);
					}
					else
					{
						// �˻������� ���� ������ ù��° row ����.
						$("#tree").jqGrid('setSelection', $("#tree").getDataIDs()[0], true);
					}
				}
				else
				{
					// Tree Grid�� �����Ͱ� ���� �� ������ �ʱ�ȭ.
					$("#ajaxFormTree input[type!=radio],#ajaxFormTree select,#ajaxFormTree textarea").each(function(){
						var name = $(this).attr("name");
						var tag  = $(this).prop("tagName").toLowerCase();
						$(tag+"[name="+name+"]").val("");
					});

					$("select[name=useYn]").val("N");
				}

				resizeJqGridWidth('tree','treeList','1000');
			},
			onSelectRow: function(rowId) {
				var data = $(this).getRowData(rowId);

	 			// Tree Grid ������ ����.
				$("#ajaxFormTree input[type!=radio],#ajaxFormTree select,#ajaxFormTree textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();

					// Tree Grid ������ �ʱ�ȭ.
					$(tag+"[name="+name+"]").val("");
					//$("select[name=useYn]").val("N");

					// Tree Grid�� ���õ� Row�� Level�� ���� �� ���� ����.
					if(data['level'] > 0)
					{
						$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);

						// codeName readOnly ó��
						if(name == "codeName")
							$(tag+"[name="+name+"]").attr("readonly", false);

						$(".dynamic").show();
					}
					else
					{
						if(name != "code")
							$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);

						$(".dynamic").hide();
					}
				});
	       	}

		});
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
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title"><%= localeMessage.getString("code.title") %></div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("code.search") %></th>
							<td>
								<input type="text" name="searchName" value="">
							</td>
						</tr>
					</tbody>
				</table>

				<div style="font-size:0;">
					<div style="display:inline-block; width:calc(50% - 20px); vertical-align:top;">
						<div style="text-align:right; font-size:12px;">
							<img id="btn_newGrid" src="<c:url value="/img/btn_new.png" />" level="W" class="btn_img" />
							<img id="btn_modifyGrid" src="<c:url value="/img/btn_modify.png"/>" level="W" "class="btn_img" />
							<img id="btn_deleteGrid" src="<c:url value="/img/btn_delete.png"/>" level="W" "class="btn_img" />
						</div>
						<div id="gridList" style="margin-top:10px;">
							<table id="grid"></table>
						</div>
						<form id="ajaxFormGrid" style="margin-top:10px;">
							<table class="table_row" cellspacing=0;>
								<tbody>
									<tr>
										<th style="width:120px;"><%= localeMessage.getString("code.codeGroup") %></th>
										<td>
											<input type="text" name="cdGroup" readonly="readonly">
										</td>
									</tr>
									<tr>
										<th style="width:120px;"><%= localeMessage.getString("code.codeGroupDesc") %></th>
										<td>
											<input type="text" name="cdGroupDesc">
										</td>
									</tr>
								</tbody>
							</table>
						</form>
					</div>

					<div style="display:inline-block; width:40px;"></div>

					<div style="display:inline-block; width:calc(50% - 20px); vertical-align:top;">
						<div style="text-align:right; font-size:12px;">
							<img id="btn_newTree" src="<c:url value="/img/btn_new.png"/>" level="W" class="btn_img" />
							<img id="btn_modifyTree" src="<c:url value="/img/btn_modify.png" />" level="W" class="btn_img" />
							<img id="btn_deleteTree" src="<c:url value="/img/btn_delete.png" />"level="W" class="btn_img" />
						</div>
						<div id="treeList" style="margin-top:10px;">
							<table id="tree"></table>
							<div id="pager"></div>
						</div>
						<form id="ajaxFormTree" style="margin-top:10px;">
							<table class="table_row" cellspacing=0;>
								<tbody>
									<tr>
										<th style="width:120px;"><%= localeMessage.getString("code.codeGroup") %></th>
										<td>
											<input type="text" name="codeGroup" readonly="readonly">
										</td>
									</tr>
									<tr>
										<th style="width:120px;"><%= localeMessage.getString("code.code") %></th>
										<td>
											<input type="text" name="code" readonly="readonly">
										</td>
									</tr>
									<tr>
										<th style="width:120px;"><%= localeMessage.getString("code.codeName") %></th>
										<td>
											<input type="text" name="codeName" readonly="readonly">
										</td>
									</tr>
									<tr class="dynamic">
									<td class="detail_title"><%= localeMessage.getString("combo.useYn") %></td>
									<td >
										<select name="useYn" style="width:100%">
											<option value="Y"><%= localeMessage.getString("combo.usey") %></option>
											<option value="N"><%= localeMessage.getString("combo.usen") %></option>
										</select>
									</td>
								</tr>
								<tr class="dynamic">
									<td class="detail_title"><%= localeMessage.getString("code.order") %></td>
									<td >
										<select name="seq" style="width:100%">
											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
											<option value="13">13</option>
											<option value="14">14</option>
											<option value="15">15</option>
											<option value="16">16</option>
											<option value="17">17</option>
											<option value="18">18</option>
											<option value="19">19</option>
											<option value="20">20</option>
										</select>
									</td>
								</tr>
								</tbody>
							</table>
						</form>
					</div>
				</div>


			</div><!-- end content_middle -->
		</div><!-- end right_box -->
	</body>
</html>

