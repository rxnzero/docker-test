<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
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
<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" >
var srcGroup;
var tgtGroup;
var srcGrid ;
var tgtGrid ;
var url ='<c:url value="/onl/admin/rule/transformMan.json" />';
//var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json"/>';
var srcLayout = window.dialogArguments["loutSrc"];
var tgtLayout = window.dialogArguments["loutTgt"];
var eaiSvcName = window.dialogArguments["eaiSvcName"];
var cnvsnName = window.dialogArguments["cnvsnName"];

var roleString	= "<%=SessionManager.getRoleIdString(request)%>";

var selectName = "functionCombo";	// selectBox Name

function getSourceResult(cnvsnName){

	//$("input[name=selectSrcLayout]").click();
	srcGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM', loutName: srcLayout ,cnvsnName : cnvsnName} }).trigger("reloadGrid");
	//srcGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM', loutName: srcLayout } }).trigger("reloadGrid");
	//tgtGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM', loutName: tgtLayout } }).trigger("reloadGrid");
	//tgtGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_TRANSFORM_ITEM', loutName: tgtLayout ,cnvsnName : cnvsnName} }).trigger("reloadGrid");

	 $.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd : 'LIST_TRANSFORM_ITEM', loutName: tgtLayout ,cnvsnName : cnvsnName},
		success:function(json){

			//srcGrid.dsetGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM', loutName: srcLayout } }).trigger("reloadGrid");


			var data = json.rows;
			if (data == null){
				dtgtGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM',loutName:tgtLayout ,cnvsnName : cnvsnName} }).trigger("reloadGrid");
			}else
				tgtGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_TRANSFORM_ITEM',loutName:tgtLayout ,cnvsnName : cnvsnName} }).trigger("reloadGrid");

		},
		error:function(e){
			alert(e.responseText);
		}
	});

}

function addGroupTag(group,data){
	var result = data;
	var datas = data.split(".");
    var comp = datas[0];
    var arr = new Array();

	for(var i=1;i<datas.length;i++){
		comp = comp +"." +datas[i];
		if (group[comp] != undefined){
			//값이 있음
			arr.push(comp);
		}
	}
	for(var i=arr.length;i > 0;i--){
		var a =  arr.pop();
		result = result.substr(0,result.indexOf(a)+a.length) + "[*]"+ result.substring(result.indexOf(a)+a.length);
	}

	return result;
}

function setTgtCell(){
	var rowId = tgtGrid.getGridParam( "selrow" );
	tgtGrid.jqGrid('setCell',rowId,'CNVSNRSULTITEMPATHNAME',$('textarea[name=CNVSNRSULTITEMPATHNAME]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNCMDNAME',$('textarea[name=CNVSNCMDNAME]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMBASCVAL',$('input[name=CNVSNITEMBASCVAL]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMSERNO',$('input[name=CNVSNITEMSERNO]').val());
}
$(document).ready(function() {


	//$("input[name=eaiSvcName]").val(eaiSvcName);
	$("input[name=srcLayout]").val(srcLayout);
	$("input[name=tgtLayout]").val(tgtLayout);
	$("input[name=transformForEaiSvcName]").val(cnvsnName);

	//$("select[name=cnvsnTypeCombo]").val(cnvsnName.substring(cnvsnName.lastIndexOf("_")+1));
	//combo

	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd : 'LIST_INIT_COMBO',eaiSvcName: eaiSvcName},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=functionCombo]")).setData(json.functionRows).setFormat(codeName3OptionFormat).rendering();

			$("input[name=cnvsnDesc]").val(json.transformRows[0].NAME);
			getSourceResult(cnvsnName);
		},
		error:function(e){
			alert(e.responseText);
		}
	});


	srcGrid = $("#sourceLayout");
	srcGrid.jqGrid({
	    datatype:'json',
	    loadui: "disable",
	    mtype: 'POST',

	    colNames: ["id","원천 항목명","원천 항목명","번호","노드타입","항목타입","LOUTITEMNODEPTRNIDNAME","LOUTITEMPTRNIDNAME","LOUTITEMPATH","LOUTNAME","LOUTITEMMAXOCCURNOITM","LOUTITEMREFINFO2"],
	    colModel: [
	        {name: "id"                     , hidden:true,key:true},
	        {name: "LOUTITEMNAME"           , width:"250"},
	        {name: "LOUTITEMDESC"                      },
	        {name: "LOUTITEMSERNO"          , width:"30"},
	        {name: "LOUTITEMNODEPTRNIDDESC" , width:"60"},
	        {name: "LOUTITEMPTRNIDDESC"     , width:"80"},
	        {name: "LOUTITEMNODEPTRNIDNAME" , hidden:true},
	        {name: "LOUTITEMPTRNIDNAME"     , hidden:true},
	        {name: "LOUTITEMPATH"           , hidden:true},
	        {name: "LOUTNAME"               , hidden:true},
	        {name: "LOUTITEMMAXOCCURNOITM"  , hidden:true},
	        {name: "LOUTITEMREFINFO2"       , hidden:true}

			],
	    treeGrid: true,
	    treeGridModel: "adjacency",
	    ExpandColumn: "LOUTITEMNAME",
	    height:"440",
	    rowNum: 10000,
	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    },
	    loadComplete:function (d){
	    	var data = d.rows;
			srcGroup = new Object();
			for ( var i = 0; i < data.length; i++) {
				if (data[i]["LOUTITEMPATH"].length > 0
					&& (data[i]["LOUTITEMNODEPTRNIDNAME"] == "2202")
					&& (data[i]["LOUTITEMMAXOCCURNOITM"] > 1
						        || ( data[i]["LOUTITEMREFINFO2"] != null && data[i]["LOUTITEMREFINFO2"].trim().length > 1 )
	             )
					)  {
					srcGroup[data[i]["LOUTITEMPATH"]]= data[i]["LOUTITEMPATH"];

					}
			}

			//select box 에 추가
			$("select[name=cnvsnCmdCombo]").html("");
			for ( var i = 0; i < data.length; i++) {
				if (data[i]['LOUTITEMNODEPTRNIDNAME'] != "2203") continue;
				var str = new makeOptions("CODE","NAME").setData(addGroupTag(srcGroup,data[i]['LOUTITEMPATH']),addGroupTag(srcGroup,data[i]['LOUTITEMDESC'])).setFormat(codeName3OptionFormat).getOption();

				$("select[name=cnvsnCmdCombo]").append(str);
			}
	    },
		onSelectRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);

			$('select[name=cnvsnCmdCombo]').val(addGroupTag(srcGroup,rowData['LOUTITEMPATH']));
       }
	});
	tgtGrid = $("#targetLayout");
	tgtGrid.jqGrid({
		//url: '<c:url value="/onl/admin/rule/transformMan.json" />',
		//postData : { cmd : 'LAYOUT_ITEM', loutName: 'LAC_BBSA311_ORGS'},
	    datatype:'json',
	    loadui: "disable",
	    mtype: 'POST',
	    colNames: ["id","타겟 항목명","타겟 항목명","번호","노드타입","항목타입","LOUTITEMNODEPTRNIDNAME","LOUTITEMPTRNIDNAME","LOUTITEMPATH","LOUTNAME","CNVSNNAME","CNVSNRSULTITEMPATHNAME" ,"변환 명령","CNVSNITEMBASCVAL","CNVSNITEMSERNO"
	              ],
	    colModel: [
	        {name: "id"                     , hidden:true,key:true},
	        {name: "LOUTITEMNAME"           , width:"250" },
	        {name: "LOUTITEMDESC"            },
	        {name: "LOUTITEMSERNO"          , width:"30" },
	        {name: "LOUTITEMNODEPTRNIDDESC" , width:"60" },
	        {name: "LOUTITEMPTRNIDDESC"     , width:"80" },
	        {name: "LOUTITEMNODEPTRNIDNAME" , hidden:true},
	        {name: "LOUTITEMPTRNIDNAME"     , hidden:true},
	        {name: "LOUTITEMPATH"           , hidden:true},
	        {name: "LOUTNAME"               , hidden:true},

	        {name: "CNVSNNAME"              , hidden:true}, //변환 명
	        {name: "CNVSNRSULTITEMPATHNAME" , hidden:true}, //타겟 항목명
	        {name: "CNVSNCMDNAME"           , width:"400"}, //변환 명령
	        {name: "CNVSNITEMBASCVAL"       , hidden:true}, //기본값
	        {name: "CNVSNITEMSERNO"         , hidden:true}  //매핑순서
	    ],
	    treeGrid: true,
		treeIcons : {
			plus: "ui-icon-circlesmall-plus",
			minus: "ui-icon-circlesmall-minus",
			leaf : "ui-icon-document"
		},
	    treeGridModel: "adjacency",
	    ExpandColumn: "LOUTITEMNAME",
	    height:"440",
	    //autowidth: true,
	    rowNum: 10000,
	    //ExpandColClick: true,
	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    },
	    loadComplete:function (d){
	    	var data = d.rows;
				tgtGroup = new Object();
				for ( var i = 0; i < data.length; i++) {
						if (data[i]["LOUTITEMPATH"].length > 0
							&& (data[i]["LOUTITEMNODEPTRNIDNAME"] == "2202")
							&& (data[i]["LOUTITEMMAXOCCURNOITM"] > 1
							        || ( data[i]["LOUTITEMREFINFO2"] != null && data[i]["LOUTITEMREFINFO2"].trim().length > 1 )
			           			)
						)  {
							tgtGroup[data[i]["LOUTITEMPATH"]]= data[i]["LOUTITEMPATH"];
						}
				}

	    },
		onSelectRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
			$('textarea[name=CNVSNRSULTITEMPATHNAME]').val(rowData['CNVSNRSULTITEMPATHNAME']);//
			$('textarea[name=CNVSNCMDNAME]').val(rowData['CNVSNCMDNAME']);
			$('input[name=CNVSNITEMBASCVAL]').val(rowData['CNVSNITEMBASCVAL']);
			$('input[name=CNVSNITEMSERNO]').val(rowData['CNVSNITEMSERNO']);
       }
	});


	resizeJqGridWidth('sourceLayout','sourceLayoutTd','1000');
	resizeJqGridWidth('targetLayout','targetLayoutTd','1000');

	$("input[name=auto]").click(function(){
	    var sourceData = srcGrid.getRowData();
	    var targetData = tgtGrid.getRowData();

		var selectValue = "";
		var targetValue = "";
		for ( var i = 0; i < sourceData.length; i++) {
			if (sourceData[i]['LOUTITEMNODEPTRNIDNAME'] != "2203") continue;
			selectValue = (sourceData[i]['LOUTITEMPATH']).substr(sourceData[i]['LOUTNAME'].length+1);
			for (var j = 0; j <targetData.length; j++) {
				if (targetData[j]['LOUTITEMNODEPTRNIDNAME'] != "2203") continue;
				targetValue = (targetData[j]['LOUTITEMPATH']).substr(targetData[j]['LOUTNAME'].length+1);
				if (targetValue == selectValue ) {
					var data = sourceData[i]['LOUTITEMPATH'];
					var tgtRowId = targetData[j]['id'];
					tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNCMDNAME',addGroupTag(srcGroup,data));
					tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNRSULTITEMPATHNAME',addGroupTag(tgtGroup,targetData[j]['LOUTITEMPATH']));
					tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNITEMSERNO',targetData[j]['LOUTITEMSERNO']);
					break;
				}
			}
		}
	});

	$("input[name=add]").click(function(){

	 	var srcRowId = srcGrid.getGridParam( "selrow" );
	 	var tgtRowId = tgtGrid.getGridParam( "selrow" );
	 	if (srcRowId == null) {alert("소스레이아웃을 선택하여 주십시요.");return;}
	 	if (tgtRowId == null) {alert("타겟레이아웃을 선택하여 주십시요.");return;}

	 	//field 여부 판단
	 	var sourceRow = srcGrid.getRowData( srcRowId );
	 	var targetRow = tgtGrid.getRowData( tgtRowId );
	 	if (sourceRow["LOUTITEMNODEPTRNIDNAME"] == '2203' && targetRow["LOUTITEMNODEPTRNIDNAME"] == '2203' ){
	 		;
	 	}else{
	 		alert("Field만 선택 가능합니다.");
	 		return ;
		}
	 	tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNCMDNAME',addGroupTag(srcGroup,sourceRow["LOUTITEMPATH"]));
	 	tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNRSULTITEMPATHNAME',addGroupTag(tgtGroup,targetRow["LOUTITEMPATH"]));
		tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNITEMSERNO',targetRow['LOUTITEMSERNO']);

	 	tgtGrid.jqGrid('setSelection', tgtRowId, true);
	});
	$("input[name=addAll]").click(function(){
	 	var srcRowId = srcGrid.getGridParam( "selrow" );
	 	var tgtRowId = tgtGrid.getGridParam( "selrow" );
	 	if (srcRowId == null) {alert("소스레이아웃을 선택하여 주십시요.");return;}
	 	if (tgtRowId == null) {alert("타겟레이아웃을 선택하여 주십시요.");return;}


	 	//field 여부 판단
	 	var sourceRow = srcGrid.getRowData( srcRowId );
	 	var targetRow = tgtGrid.getRowData( tgtRowId );
	 	if (sourceRow["LOUTITEMNODEPTRNIDNAME"] == '2203' && targetRow["LOUTITEMNODEPTRNIDNAME"] == '2203' ){
	 		;
	 	}else{
	 		alert("Field만 선택 가능합니다.");
	 		return ;
		}
	 	//grid data
	    var sourceData = srcGrid.getRowData();
	    var targetData = tgtGrid.getRowData();


	 	//grid index
		var srcIndex = srcGrid.jqGrid('getInd',srcRowId);
		var tgtIndex = tgtGrid.jqGrid('getInd',tgtRowId);


	 	var selectValue = "";
		var targetValue = "";
		var j=tgtIndex-1-1;
		for ( var i = srcIndex-1; i < sourceData.length; i++) {
			if (sourceData[i]['LOUTITEMNODEPTRNIDNAME'] != "2203") continue;
			j++;
			while (targetData.length -1 >= j &&targetData[j]["LOUTITEMNODEPTRNIDNAME"] != "2203"){
				j++;
			}
			if (targetData.length -1 < j) break;
			var rowId = targetData[j]['id'];
			tgtGrid.jqGrid('setCell',rowId,'CNVSNCMDNAME',addGroupTag(srcGroup,sourceData[i]['LOUTITEMPATH']));
			tgtGrid.jqGrid('setCell',rowId,'CNVSNRSULTITEMPATHNAME',addGroupTag(tgtGroup,targetData[j]['LOUTITEMPATH']));
			tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMSERNO',targetData[j]['LOUTITEMSERNO']);

	 	}
	 	tgtGrid.jqGrid('setSelection', tgtRowId, true);
	});
	$("input[name=remove]").click(function(){
	 	var tgtRowId = tgtGrid.getGridParam( "selrow" );
	 	if (tgtRowId == null) {alert("타겟레이아웃을 선택하여 주십시요.");return;}
	 	tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNCMDNAME',null);
	 	tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNRSULTITEMPATHNAME',null);
	 	tgtGrid.jqGrid('setCell',tgtRowId,'CNVSNITEMSERNO',null);
	 	tgtGrid.jqGrid('setSelection', tgtRowId, true);

	});
	$("input[name=removeAll]").click(function(){
	 	var tgtRowId = tgtGrid.getGridParam( "selrow" );
	 	if (tgtRowId == null) {alert("타겟레이아웃을 선택하여 주십시요.");return;}
		//grid data
		var targetData = tgtGrid.getRowData();
		//grid index
		var tgtIndex = tgtGrid.jqGrid('getInd',tgtRowId);

		for ( var i = tgtIndex-1; i < targetData.length; i++) {
			var rowId = targetData[i]['id'];
			tgtGrid.jqGrid('setCell',rowId,'CNVSNCMDNAME',null);
			tgtGrid.jqGrid('setCell',rowId,'CNVSNRSULTITEMPATHNAME',null);
		 	tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMSERNO',null);

	 	}
	 	tgtGrid.jqGrid('setSelection', tgtRowId, true);

	});

	$("textarea[name=CNVSNRSULTITEMPATHNAME],textarea[name=CNVSNCMDNAME],input[name=CNVSNITEMBASCVAL],input[name=CNVSNITEMSERNO]").blur(function(){
		var rowId = tgtGrid.getGridParam( "selrow" );
		if (isNull(rowId)) return;
		setTgtCell();

	});

	$("input[name=selectSrcLayout]").click(function(){
		srcGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM', loutName: srcLayout } }).trigger("reloadGrid");
	});
	$("input[name=selectTgtLayout]").click(function(){
		tgtGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM', loutName: $("input[name=tgtLayout]").val() } }).trigger("reloadGrid");
	});
	$("#btn_cancel").click(function(){
		//goNav(returnUrl);//LIST로 이동
	});
	$("#btn_modify").click(function(){

	    // valid


	    var targetData = tgtGrid.getRowData();
		var gridData   = new Array();


		for (var i = 0; i <targetData.length; i++) {
			if (targetData[i]['LOUTITEMNODEPTRNIDNAME'] != "2203") continue;
			if (targetData[i]['CNVSNCMDNAME']==null
					|| targetData[i]['CNVSNCMDNAME']== undefined
					|| targetData[i]['CNVSNCMDNAME'].trim() ==""
					) continue;

			gridData.push(tgtGrid.jqGrid('getRowData', targetData[i]['id']));

		}
		var postData = [];
		postData.push({ name: "cmd"           , value:"MAPPING"});
		postData.push({ name: "cnvsnName"     , value:$("input[name=transformForEaiSvcName]").val()});
		postData.push({ name: "cnvsnDesc"	  , value:$("input[name=cnvsnDesc]").val()});
		postData.push({ name: "eaiSvcName"	  , value:eaiSvcName	});
		//postData.push({ name: "srcLayout"	  , value: srcLayout});
		//postData.push({ name: "tgtLayout"	  , value : tgtLayout});

		postData.push({ name: "gridData"      , value:JSON.stringify(gridData)});

		$.ajax({
			type : "POST",
			url:'<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />',
			data:postData,
			success:function(args){
				alert("저장 되었습니다.");
				getSourceResult($("input[name=transformForEaiSvcName]").val());
				//goNav(returnUrl);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});

	$("#btn_delete").click(function(){
		var postData = [];

		postData.push({ name: "cmd"       , value:"UNMAPPING"});
		postData.push({ name: "cnvsnName", value:$("input[name=transformForEaiSvcName]").val()});
		postData.push({ name :"eaiSvcName", value:eaiSvcName});
		$.ajax({
			type : "POST",
			url:'<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />',
			data:postData,
			success:function(args){
				alert("삭제 되었습니다.");
				getSourceResult($("input[name=transformForEaiSvcName]").val());
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("input[name=addCmd]").click(function(){
		var rowId = tgtGrid.getGridParam( "selrow" );
		if (isNull(rowId)){
			alert("타겟 그리드의 행이 선택안되어 있습니다.");
			return;
		}
		rowId = srcGrid.getGridParam( "selrow" );
		if (isNull(rowId)){
			alert("소스 그리드의 행이 선택안되어 있습니다.");
			return;
		}

		$('textarea[name=CNVSNCMDNAME]').val($('select[name=functionCombo]').val() +"("+ $('select[name=cnvsnCmdCombo]').val()+")");
		setTgtCell();
	});

	$("#btn_initialize").click(function(){
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZE',cnvsnName:$("select[name=transformForEaiSvcNameCombo]").val()},
			success:function(json){
				alert(json.message);
			},
			error:function(e){
				alert(e.responseText);
			}
		});

	});

	$("#btn_close").click(function(){
		window.close();
	});
	buttonControl();
	setBtnHide(roleString, "admin", "btn_initialize");

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
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />
					<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">전문레이아웃변환매핑 수정<span class="tooltip">전문레이아웃 변환 매핑엔진의 매핑규칙을 조회하는 화면입니다</span></div>

	<table class="search_condition" cellspacing="0">
<!-- 		<tr> -->
<!-- 			<th style="width:180px;">IF 서비스코드</th> -->
<!-- 			<td colspan="3"> -->
<!-- 				<input type="text" name="eaiSvcName" value="BOP0810000000008R1" style="width:calc(100% - 220px);"> -->
<%-- 				<img id="btn_search" src="<c:url value="/img/btn_pop_search.png"/>" level="R" class="btn_img" /> --%>
<!-- 				<input type="checkbox" name="chk_eaiSvcName" id="sub2_4_3_modify_1"><label for="sub2_4_3_modify_1">IF 서비스코드 강제지정</label>		 -->
<!-- 			</td> -->
<!-- 		</tr> -->
<!-- 		<tr> -->
<!-- 			<th>IF 서비스설명</th> -->
<!-- 			<td colspan="3"> -->
<!-- 				<input type="text" name="eaiSvcDesc" value="한국은행-신한은회선시험응답" readonly="readonly"> -->
<!-- 			</td> -->
<!-- 		</tr> -->
		<tr>
			<th width="200px">전문레이아웃변환매핑 코드</th>
			<td>
				<input type="text" name="transformForEaiSvcName" readonly>
			</td>
<!-- 			<th style="width:180px">전문레이아웃 변환매핑 유형</th> -->
<!-- 			<td> -->
<!-- 				<div class="select-style"> -->
<!-- 					<select name="cnvsnTypeCombo"> 									 -->
<!-- 					</select> -->
<!-- 				</div>	 -->
<!-- 			</td> -->
		</tr>
		<tr>
			<th>변환설명</th>
			<td><input type="text" name="cnvsnDesc" readonly></td>
		</tr>
	</table>

	<!-- tree -->
	<table border="0" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed;" >
	<tr>
		<td style="width:600px; vertical-align:top;">
			<table class="table_row" cellspacing="0">
				<tr>
					<th style="width:130px;">원천 전문레이아웃</th>
					<td>
						<input type="text" name="srcLayout" style="width:calc(100% - 130px)" readOnly>
<%-- 									<img id="btn_searchSrcLout" src="<c:url value="/img/btn_pop_search.png"/>" level="R" class="btn_img" /> --%>
					</td>
				</tr>
<!-- 							<tr> -->
<!-- 								<th>원천 전문레이아웃설명</th> -->
<!-- 								<td> -->
<!-- 									<input type="text" name="srcLayoutDesc" readOnly> -->
<!-- 								</td> -->
<!-- 							</tr> -->
			</table>
			<div id="sourceLayoutTd" style="margin-bottom:15px;">
				<table id="sourceLayout"></table>
				<div id="sourcePage"></div>
			</div>
			<table class="table_row" cellspacing="0">
				<tr>
					<th style="width:130px;">변환명령</th>
					<td>
						<div class="select-style" style="display:inline-block; width:calc((100% - 130px)*0.3);">
							<select name="functionCombo" style="width:120%;"></select>
						</div>
						<div class="select-style" style="display:inline-block; width:calc((100% - 130px)*0.7);">
							<select name="cnvsnCmdCombo"></select>
						</div>
						<input type="button" name="addCmd" class="btn_img btn_pop_add" />
					</td>
				</tr>
				<tr height="50px">
					<td colspan=2><textarea  name="CNVSNCMDNAME"></textarea></td>
				</tr>
				<tr>
					<th>기본값</th><td><input type="text" name="CNVSNITEMBASCVAL"/></td>
				</tr>
			</table>
		</td>
		<td style="width:100px; text-align:center;">
			<input type=button name="auto" class="btn_img btn_auto" /><br><br>
			<input type=button name="add" class="btn_img btn_add"/><br><br>
			<input type=button name="addAll" class="btn_img btn_addAll"/><br><br>
			<input type=button name="remove" class="btn_img btn_remove"/><br><br>
			<input type=button name="removeAll" class="btn_img btn_removeAll"/>
		</td>
		<td style="vertical-align:top;">
			<table class="table_row" cellspacing="0">
				<tr>
					<th style="width:130px;">타겟 전문레이아웃</th>
					<td>
						<input type="text" name="tgtLayout" style="width:calc(100% - 130px)" readOnly>
<%-- 									<img id="btn_searchTgtLout" src="<c:url value="/img/btn_pop_search.png" />"level="R" class="btn_img" /> --%>
					</td>
				</tr>
<!-- 							<tr> -->
<!-- 								<th>타겟 전문레이아웃 설명</th> -->
<!-- 								<td> -->
<!-- 									<input type="text" name="tgtLayoutDesc" readOnly>									 -->
<!-- 								</td> -->
<!-- 							</tr> -->
			</table>
			<div id="targetLayoutTd" style="margin-bottom:15px;">
				<table id="targetLayout"></table>
				<div id="targetPage"></div>
			</div>
			<table class="table_row" cellspacing="0">
				<tr height="75px">
					<th style="width:130px;">타겟항목명</th>
					<td><textarea  name="CNVSNRSULTITEMPATHNAME"></textarea></td>
				</tr>
				<tr>
					<th>매핑순서</th>
					<td><input type="text"  name="CNVSNITEMSERNO"/></td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->
	</body>
</html>

