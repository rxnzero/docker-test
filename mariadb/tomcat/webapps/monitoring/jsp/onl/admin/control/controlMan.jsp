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
var url      = '<c:url value="/onl/admin/control/controlMan.json" />';
var url_view = '<c:url value="/onl/admin/control/controlMan.view" />';
// var startTime;

var selectName = "searchEaiBzwkDstcd";	// selectBox Name

function init() {
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=searchControlType]")).setData(json.controlList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=searchIo]")).setData(json.ioList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=searchEaiBzwkDstcd]")).setData(json.bizList).setNoValueInclude(true).setNoValue("A", "전체").setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=searchControlSelectType]")).setData(json.controlSelectList).setFormat(codeName3OptionFormat).rendering();
			
			setSearchable(selectName);	// 콤보에 searchable 설정
			
			if(typeof callback === 'function') {
				callback(key);
			}			
		},
		error:function(e){
			alert(e.responseText);
		}
	});
	
}

// 체크된 grid Cell에 있는 EAISVCNAME값을 배열에 저장.
function getRowArray()
{
	var chkList			= new Array();
	var rowIdx			= 0;
	var arrIdx			= 0;
	
	$("input[type=checkbox][name*=jqg_grid_]").each(function(idx){
	
		if($(this).is(":checked"))
		{
			rowIdx = idx+1;
			chkList[arrIdx] = $("#grid").jqGrid("getCell", rowIdx, "EAISVCNAME");
			
			arrIdx++;
		}
	});
	
	return chkList;
}

$(document).ready(function() {
	init();	
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		colNames:[
// 				  '<input type="checkbox" name="allCheckBox" onclick="allCheck(event)">',
				  '번호',
                  '업무구분코드',
                  '업무구분명',
                  '통제코드',
                  '통제코드설명',
                  '상태'
                  ],
		colModel:[
// 				{ name : 'CHK', editable:true, edittype: 'checkbox', editoptions:{ value:"True:False" }, formatter: "checkbox", formatoptions: {disabled: false}, index:"CHK",width:'25' ,sortable:false },
				{ name : 'ROWNUM'        , align:'center',index:"id",width:'15'	,sortable:false },
				{ name : 'EAIBZWKDSTCD'  , align:'left',width:'25' },
				{ name : 'BZWKDSTICNAME' , align:'left',width:'70' },
				{ name : 'EAISVCNAME'    , align:'left',width:'55' },
				{ name : 'EAISVCDESC'    , align:'left' },
				{ name : 'STATUS'        , align:'center',width:'15', cellattr:function(rowId, tv, rowObject, cm, rdata){if(rowObject.STATUS == "통제") return 'style="color:red"'}}
				],
        jsonReader: {
             repeatitems:false,
             total: "total"
        },	          
		rowNum : 10000,
	    //autoheight: true,
	    width: 1090,
	    height: 500,
// 		autowidth: true,
// 		viewrecords: true,
		multiselect : true,
		//loadonce:true,
		gridview:true,
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//그리드 헤더 화살표 삭제(정렬X)		
			}
		
		},			
		ondblClickRow: function(rowId) {
        },
        loadComplete:function(){
//       		var endTime = new Date().getTime();
//       		var resultTime = endTime - startTime;
// 			console.log("resultTime : " + resultTime);
        }
	});
	
	$("#btn_search").click(function(){
		$("#grid").jqGrid("clearGridData");
		if($("input[name=searchCode]").val().length == 0){
			alert("거래통제 코드를 입력하세요.");
			return;
		}
		if ($("select[name=searchControlType]").val() =="S"){
			$("#grid").jqGrid("showCol","EAIBZWKDSTCD");
			$("#grid").jqGrid("showCol","BZWKDSTICNAME");
		}else{
			$("#grid").jqGrid("hideCol","EAIBZWKDSTCD");
			$("#grid").jqGrid("hideCol","BZWKDSTICNAME");
		}
// 		startTime = new Date().getTime();
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ url:url,postData: postData ,page : "1" }).trigger("reloadGrid");
	});


	// 통제 등록
	$("#btn_modify").click(function(e){
// 		var chkList			= $("#grid").getGridParam("selarrrow");
		var chkList;
		var arrEaiSvcName	= new Array();
		var idx				= 0;
		var postData;
		var rowCnt			= $("#grid").getGridParam("reccount");
		
		chkList = getRowArray();
		
		if(rowCnt <= 0)
		{
			alert("조회된 데이터가 없습니다.");
			return false;
		}
		
		if(chkList.length == 0)
		{
			alert("통제코드를 선택하여 주십시요.");
			return false;
		}

		
		var r = confirm("통제등록 하시겠습니까?");
		if (r == false){
			chkList = null;
			return false;
		}
		
		postData = getSearchForJqgrid("cmd","INSERT"); //jqgrid에서는 object 로 
		postData["arrEaiSvcName"] = chkList;
		
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("등록 되었습니다.");
				chkList = null;
				$("#btn_search").click();
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	
	// 통제 해제
	$("#btn_delete").click(function(e){
// 		var chkList			= $("#grid").getGridParam("selarrrow");
		var chkList;
		var arrEaiSvcName	= new Array();
		var idx				= 0;
		var postData;
		var rowCnt			= $("#grid").getGridParam("reccount");

		chkList = getRowArray();
		
		if(rowCnt <= 0)
		{
			alert("조회된 데이터가 없습니다.");
			return false;
		}
		
		if(chkList.length == 0)
		{
			alert("통제코드를 선택하여 주십시요.");
			return false;
		}
		
		var r = confirm("통제등록을 해제 하시겠습니까?");
		if (r == false){
			return false;
		}
		postData = getSearchForJqgrid("cmd","DELETE"); //jqgrid에서는 object 로  
		postData["arrEaiSvcName"] = chkList;
		
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("해제 되었습니다.");
				chkList = null;
				$("#btn_search").click();
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	
	$("input[name*=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
	$("select[name=searchControlType]").change(function(){
		$("#service").hide();
		if ($(this).val() =="S"){
			$("#service").show();
		}
	});

	$("#cb_grid").unbind("click");
	
	$("#cb_grid").click(function(e){
		var cnt = $("#grid").getGridParam("reccount");
		var check = $(this).is(":checked");
		
		if ($(this).is(":checked")){
			//check되어 있으면
 			var r = confirm("전체선택 하시겠습니까?"+"("+cnt+"건)");
 			if (r == false){
 				return false;
 			}
		}else{
 			var r = confirm("전체선택해제 하시겠습니까?"+"("+cnt+"건)");
 			if (r == false){
 				return false;
 			}
		}
		
		$("input[type=checkbox][name*=jqg_grid_]").each(function(){
			$(this).prop("checked",check);
		});
		
	});
	$("input[name=allAdd]").click(function(e){
		var r = confirm("시스템 전체 거래가 통제됩니다.\n전체등록 하시겠습니까?");
		if (r == false){
			return false;
		}
		var postData = getSearchForJqgrid("cmd","INSERT_CONTROL_ALL"); //jqgrid에서는 object 로 
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("전체등록 되었습니다.");
				$("#btn_search").click();
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
	
	});	
	
	
	$("input[name=allDelete]").click(function(e){
		var r = confirm("시스템 전체 거래가 해제됩니다.\n전체해제 하시겠습니까?");
		if (r == false){
			return false;
		}
		
		var postData = getSearchForJqgrid("cmd","DELETE_CONTROL_ALL"); //jqgrid에서는 object 로 
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("전체등록해제 되었습니다.");
				$("#btn_search").click();
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
	
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
					<img id="btn_modify" src="<c:url value="/img/btn_regist.png"/>" level="W">
					<img id="btn_delete" src="<c:url value="/img/btn_release.png"/>" level="W">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title">거래통제</div>
				<div style="margin-bottom:15px;">
					<input type="button" name="allAdd" class="btn_img btn_allAdd">
					<input type="button" name="allDelete" class="btn_img btn_allDelete">
				</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">구분</th>
							<td colspan="3">
								<div class="select-style">	
									<select name="searchControlType">
									</select>
								</div>
							</td>							
						</tr>	
						<tr>
							<th style="width:180px;">당발/타발</th>
							<td>
								<div class="select-style">	
									<select name="searchIo">
									</select>
								</div>
							</td>
							<th style="width:180px;">상세업무구분코드</th>
							<td>
								<div style="position: relative;">
									<div class="select-style">	
										<select name="searchEaiBzwkDstcd">
										</select>
									</div>
								</div>								
							</td>	
						</tr>
						<tr>
							<th style="width:180px;">통제선택</th>
							<td>
								<div class="select-style">	
									<select name="searchControlSelectType">
									</select>
								</div>
							</td>		
							<th style="width:180px;">통제코드</th>
							<td>
								<input type="text" name="searchCode">
							</td>	
						</tr>	
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

