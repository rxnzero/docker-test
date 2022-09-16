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

function init(url){
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=displayYn]")).setData(json.displayYnRows).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=useYn]")).setData(json.useYnTypeRows).setFormat(codeName3OptionFormat).rendering();

		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function isValid(){
	if($('input[name=menuId]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd1") %>");
		return false;
	}else if($('input[name=menuName]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd2") %>");
		return false;
	}else if($('input[name=parentMenuId]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd3") %>");
		return false;
	}else if($('textarea[name=menuUrl]').val() == ""){
		alert("<%= localeMessage.getString("menu.checkRequierd4") %>");
		return false;
	}
    var pmenu = $('input[name=parentMenuId]').val();
    var menuId = $('input[name=menuId]').val();
	var index = 0;
	for(index=pmenu.length;  index > 0 ; index--){
		if ( 0 != pmenu.substr(index-1,1)){
            break;
		}
	}
	if (pmenu.substr(0,index) != menuId.substr(0,index)){
		/*var r = confirm("상위메뉴ID 의 유효값("+pmenu.substr(0,index) +")과 메뉴ID("+menuId.substr(0,index)+") 의 유효값이\n"
						+"일치 하지 않습니다.\n"
						+ "그래도 저장 하시겠습니까?");
		*/
        var r = confirm(replaceMsg("<%=localeMessage.getString("menu.checkMsg1")%>", pmenu.substr(0,index),menuId.substr(0,index)));
		if (r == false) return false;
	}

	return true;
}
$(document).ready(function() {
	var gridPostData = getSearchForJqgrid("cmd","LIST_TREE"); //jqgrid에서는 object 로
	var url = '<c:url value="/common/acl/menu/menuMan.json" />';

	init(url);

	$('#tree').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['MENUID',
                  'PARENTMENUID',
                  'SORTORDER',
                  'MENUNAME',
                  'MENUURL',
                  'MENUIMAGE',
                  'DISPLAYYN',
                  'USEYN',
                  'APPPATH',
                  'DISPLAYYNNM',
                  'USEYNNM',
                  'APPCODE'
                  ],
		colModel:[
				{ name : 'MENUID'      , hidden:true,key :true 	 },
				{ name : 'PARENTMENUID', hidden:true  },
				{ name : 'SORTORDER'   , hidden:true  },
				{ name : 'MENUNAME'    , align:'left',width:300 ,sortable:false},
				{ name : 'MENUURL'     , hidden:true  },
				{ name : 'MENUIMAGE'   , hidden:true  },
				{ name : 'DISPLAYYN'   , hidden:true  },
				{ name : 'USEYN'       , hidden:true  },
				{ name : 'APPPATH'     , hidden:true  },
				{ name : 'DISPLAYYNNM' , hidden:true  },
				{ name : 'USEYNNM'     , hidden:true  },
				{ name : 'APPCODE'     , hidden:true  }
		],
	    treeGrid: true,
		treeIcons : {
			plus: "ui-icon-circlesmall-plus",
			minus: "ui-icon-circlesmall-minus",
			leaf : "ui-icon-document"
		},
	    treeGridModel: "adjacency",
	    ExpandColumn: "MENUNAME",
	    height:"500",
	    width:"320",
	    rowNum: 10000,
	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    },
	    loadComplete:function (d){
	    	$("#tree").jqGrid('setSelection', $("#tree").getDataIDs()[0], true);

	    },
		ondblClickRow: function(rowId) {
        },
		onSelectRow: function(rowId) {
			var data = $(this).getRowData(rowId);

			$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			});


			if (data['level'] != 3){
				$(".dynamic").hide();
			}else{
				$(".dynamic").show();
			}

       }

	});


	//resizeJqGridWidth('tree','leftbody','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST_TREE"); //jqgrid에서는 object 로
		$("#tree").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var rowId = $('#tree').getGridParam( "selrow" );
		if (isNull(rowId)){
			alert("<%= localeMessage.getString("menu.checkRequierd5") %>");
			return ;
		}
	 	var row = $('#tree').getRowData( rowId );
	 	var level = Number(row["level"]) + 1;
	    if (level > 3 ){
	        alert("<%= localeMessage.getString("menu.checkMsg3") %>");
			return ;
		}
	    var args = new Object();
	    args['level'] = level;
	    args['parentMenuId'] = row['MENUID'];
	    var url2 = '<c:url value="/common/acl/menu/menuMan.view"/>';
	    url2 = url2 + "?cmd=POPUP";
	    showModal(url2,args,540,400,function(){$("#btn_search").click();/*재조회*/});

	});
	$("#btn_delete").click(function(){
		var rowId = $('#tree').getGridParam( "selrow" );
		if (isNull(rowId)){
			alert("<%= localeMessage.getString("menu.checkRequierd5") %>");
			return ;
		}
		$('#tree').jqGrid('resetSelection');

	 	var row = $('#tree').getRowData( rowId );

	 	var ids = $('#tree').getDataIDs();
	 	var index = $('#tree').getInd(rowId);

	 	if (ids.length > Number(index) ){
	 		//check
		 	var childlevel = $('#tree').jqGrid('getCell',ids[Number(index)],'level');
	 		if (row["level"]< childlevel){//child 존재
	 			var r = confirm("<%= localeMessage.getString("menu.checkMsg2") %>");
	 			if (r == false){
	 				return;
	 			}
	 		}
	 	}

		var postData = new Array();
		postData.push({ name: "cmd" , value:"DELETE"});
		postData.push({ name: "menuId" , value:$("input[name=menuId]").val()});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("<%= localeMessage.getString("common.deleteMsg") %>");
				$('#tree').jqGrid('resetSelection');
				$("#btn_search").click();//재조회
			},
			error:function(e){
				alert(e.responseText);
			}
		});

	});
	$("#btn_modify").click(function(){
		var rowId = $('#tree').getGridParam( "selrow" );
		if (isNull(rowId)){
			alert("<%= localeMessage.getString("menu.checkRequierd5") %>");
			return ;
		}
		if(!isValid()){
			return;
		}
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"UPDATE"});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("<%= localeMessage.getString("common.saveMsg") %>");
				$('#tree').jqGrid('resetSelection');
				$("#btn_search").click();//재조회
			},
			error:function(e){
				alert(e.responseText);
			}
		});

	});


	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});

	buttonControl();



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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" />
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W""/>
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title"><%= localeMessage.getString("menu.title") %></div>

				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("menu.search") %></th>
							<td><input type="text" name="searchName" value=""></td>
						</tr>
					</tbody>
				</table>

				<div style="font-size:0;">
					<div style="display:inline-block; width:400px; vertical-align:top;">
						<table id="tree" ></table>
						<div id="pager"></div>
					</div>
					<div style="display:inline-block; width:10px;">
					</div>
					<div style="display:inline-block; width:calc(100% - 430px); vertical-align:top;">
						<form id="ajaxForm">
							<table class="table_row" cellspacing="0">
								<tr>
									<th style="width:120px;"><%= localeMessage.getString("menu.id") %></th>
									<td ><input type="text" name="menuId" readonly="readonly"/> </td>
								</tr>
								<tr>
									<th><%= localeMessage.getString("menu.name") %></th>
									<td ><input type="text" name="menuName"/> </td>
								</tr>

								<tr>
									<th><%= localeMessage.getString("menu.parent") %></th>
									<td ><input type="text" name="parentMenuId" readonly="readonly"/> </td>
								</tr>
								<tr>
									<th><%= localeMessage.getString("menu.img") %></th>
									<td ><input type="text" name="menuImage"/> </td>
								</tr>
								<tr>
									<th><%= localeMessage.getString("menu.display") %></th>
									<td>
										<div class="select-style">
											<select type="text" name="displayYn" />
										</div>
									</td>
								</tr>
								<tr>
									<th><%= localeMessage.getString("combo.useYn") %></th>
									<td>
										<div class="select-style">
											<select type="text" name="useYn" />
										</div>
									</td>
								</tr>
								<tr>
									<th><%= localeMessage.getString("menu.order") %></th>
									<td >
										<div class="select-style">
											<select name="sortOrder">
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
											</select>
										</div>
									</td>
								</tr>
								<tr style="height:100px;">
									<th><%= localeMessage.getString("menu.url") %><div style="color:red;"><%= localeMessage.getString("menu.checkMsg4") %></div></th>
									<td><textarea  name="menuUrl" style="width:100%;height:100px"></textarea></td>
								</tr>
								<tr>
									<th><%= localeMessage.getString("menu.appCode") %></th>
									<td>
										<div class="select-style">
											<select name="appCode">
												<option value="ONL"><%= localeMessage.getString("menu.onl") %></option>
												<option value="BAT"><%= localeMessage.getString("menu.bat") %></option>
												<option value="BAP"><%= localeMessage.getString("menu.bap") %></option>
											</select>
										</div>
									</td>
								</tr>
							</table>
						</form>
					</div>
				</div>


			</div><!-- end content_middle -->
		</div><!-- end right_box -->
	</body>
</html>

