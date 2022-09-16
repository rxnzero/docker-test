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
<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" >
var url      = '<c:url value="/onl/admin/service/addFailoverMan.json" />';
var url_view = '<c:url value="/onl/admin/service/addFailoverMan.view" />';
var arrGridData = new Array();
var submitData = {};
var unEnrolled = [];
var enrolled	= [];
// 업무코드 List Count 조회
function getRowArray()
{
	var chkList			= new Array();
	var rowIdx			= 0;
	var arrIdx			= 0;

	var fullData = $("#targetGrid").getRowData();
	//getRowData 하면 select html 그대로 들어가기 때문에 추가함
	for(var i=0;i<fullData.length;i++){
		chkList[i] = fullData[i]["CHNNLNM"];
	}

	return chkList;
}
function init()
{

}

function isGridValid(gridName)
{
	var gridCnt	= 0;

	gridCnt = $(gridName).jqGrid("getGridParam", "selarrrow").length;
	if(gridCnt <= 0)
	{
		alert("선택된채널이 없습니다.");
		return false;
	}

	return true;
}
function loadSrcGrid(){

	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	postData["searchEnrolledYN"] = "N";

	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data: postData,
		success:function(json){
			var data = json;

			$("#grid")[0].addJSONData(data);
			var fullData = $("#targetGrid").getRowData();
			//getRowData 하면 select html 그대로 들어가기 때문에 추가함
			for(var i=0;i<fullData.length;i++){
				unEnrolled[i] = fullData[i]["CHNNLNM"];
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}
function loadTgtGrid(){
	//var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	postData = new Object();
	postData["cmd"] = "LIST";
	postData["searchChnnl"] = "";
	postData["searchEnrolledYN"] = "Y";
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:postData,
		success:function(json){
			var data = json;
			$("#targetGrid")[0].addJSONData(data);

			var fullData = $("#targetGrid").getRowData();
			//getRowData 하면 select html 그대로 들어가기 때문에 추가함
			for(var i=0;i<fullData.length;i++){
				enrolled[i] = fullData[i]["CHNNLNM"];
			}
			var searchName = $("input[name=searchChnnl]").val();
			$("#targetGrid").jqGrid('setSelection', searchName, true);

		},
		error:function(e){
			alert(e.responseText);
		}
	});

}


function srcGridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
		mtype: 'POST',
		colNames:['미등록 채널명 '

                  ],
		colModel:[
				{ name : 'CHNNLNM'
					, align : 'left'
					, width : 100
					, sortable : false
				}
				],
        jsonReader: {
             repeatitems:false
        },
	    autoheight: true,
	    height: $("#container").height(),
	    height: 430,
		//autowidth: true,
		viewrecords: true,
		gridview: true,						// jqGrid의 성능 향상 - treeGrid, subGrid, afterInsertRow event의 경우 제외.
		scroll: true,						// 스크롤 사용여부 설정.(default: false)
		rowNum : 10000,						// Grid에 표시될 레코드 수 설정 (-1은 조회된 데이터 전부 그리드에 셋팅).
		multiselect : true,

		loadComplete:function (d){

		},
		gridComplete:function (d){
			$("input[name=unEnrolledCnt]").val($("#grid").getGridParam("reccount"));
		},
	});
}

function tgtGridRendering(){
//var tgtPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	//tgtPostData["searchEnrolledYN"] = "Y";

	$('#targetGrid').jqGrid({
		datatype:"local",
		mtype: 'POST',
		loadui: "disable",
		colNames:['등록 채널명 '

                  ],
		colModel:[
				{ name : 'CHNNLNM'
					, align : 'left'
					, key : true
					, width : 100
					, sortable : false
				}
				],
        jsonReader: {
             repeatitems:false
        },
	    autoheight: true,
	    height: $("#container").height(),
	    height: 430,
		//autowidth: true,
		viewrecords: true,
		gridview: true,						// jqGrid의 성능 향상 - treeGrid, subGrid, afterInsertRow event의 경우 제외.
		scroll: true,						// 스크롤 사용여부 설정.(default: false)
		rowNum : 10000,						// Grid에 표시될 레코드 수 설정 (-1은 조회된 데이터 전부 그리드에 셋팅).
		multiselect : true,

		loadComplete:function (d){

		},
		gridComplete:function (d){
			$("input[name=enrolledCnt]").val($("#targetGrid").getGridParam("reccount"));
		},
		onSelectRow: function(rowId){
		}
	});

}
$(document).ready(function() {
	// 업무코드 List Count
	init();

	//등록안된 리스트
	srcGridRendering();
	tgtGridRendering();

	loadSrcGrid();
	loadTgtGrid();



	// target Grid


	$("#btn_close").click(function(){
		window.close();
	});

	$("#btn_search").click(function(){
		$("#grid").clearGridData();
		$("#targetGrid").clearGridData();
		loadSrcGrid();
		loadTgtGrid();

	});

	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});


	$("input[name=add]").click(function(){

		if(!isGridValid("#grid")) return;

	 	var selRowIds = $("#grid").jqGrid("getGridParam", "selarrrow");
		var addData = new Array();
		for(var i=selRowIds.length -1; i>= 0;i--){
		    addData[i] =$("#grid").getRowData(selRowIds[i]);
		    $("#grid").jqGrid('delRowData',selRowIds[i]);

		}

	    $("#targetGrid").jqGrid('addRow', {
		           initdata : addData,
		           position :"last",    //first, last
		           useDefValues : false,
		           useFormatter : false,
		           addRowParams : {extraparam:{}}
		});


	});


	$("input[name=remove]").click(function(){
		if(!isGridValid("#targetGrid")) return;

	 	var selRowIds = $("#targetGrid").jqGrid("getGridParam", "selarrrow");
		var addData = new Array();
		for(var i=selRowIds.length -1; i>= 0;i--){
		    addData[i] =$("#targetGrid").getRowData(selRowIds[i]);
		    $("#targetGrid").jqGrid('delRowData',selRowIds[i]);

		}

	    $("#grid").jqGrid('addRow', {
		           initdata : addData,
		           position :"last",    //first, last
		           useDefValues : false,
		           useFormatter : false,
		           addRowParams : {extraparam:{}}
		});


	});
	$("#btn_modify").click(function(e){
		var chkList;
		var arrEaiSvcName	= new Array();
		var idx				= 0;
		var postData;
		var rowCnt			= $("#grid").getGridParam("reccount");

		chkList = getRowArray();

		//postData = getSearchForJqgrid("cmd","UPDATE_PRPTY"); //jqgrid에서는 object 로
		postData = new Object();
		postData["cmd"] = "UPDATE_PRPTY";
			postData["prpty2Val"] = chkList.join(";");

		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("등록 되었습니다.");
				chkList = null;
				$("#btn_search").click();
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});

	resizeJqGridWidth('grid','src','500');
	resizeJqGridWidth('targetGrid','tgt','500');
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
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">Failover 프로퍼티 관리</div>

				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">채널명</th>
							<td>
								<input type="text" name="searchChnnl" value="">
							</td>
						</tr>
					</tbody>
				</table>
				<table style="width:70%;">
					<tr>
						<td style="width:500px; text-align:right;">
							총 ( <input type="text" name="unEnrolledCnt" readOnly style="border:0;" size='3' value ="" />) 건
						</td>
						<td style="width:100px;"></td>
						<td style="width:500px; text-align:right;">
							총 ( <input type="text" name="enrolledCnt" readOnly style="border:0;" size='3' value ="" />) 건
						</td>
					</tr>
				</table>
				<!-- grid -->
				<table style="width:70%;">
					<tr>
						<td style="width:500px; text-align:center;">
							<div id="grid_div" style="display:inline-block;">
								<table id="grid" ></table>
							</div>
						</td>
						<td style="width:100px; text-align:center;">
							<input type=button name="add" class="btn_img btn_add" ><br><br>
							<input type=button name="remove" class="btn_img btn_remove" >
						</td>
						<td style="width:500px; text-align:center;">
							<div id="targetGrid_div" style="display:inline-block;">
								<table id="targetGrid" ></table>
							</div>
						</td>
					</tr>
				</table>


			</div><!-- end content_middle -->
		</div><!-- end right_box -->
	</body>
</html>

