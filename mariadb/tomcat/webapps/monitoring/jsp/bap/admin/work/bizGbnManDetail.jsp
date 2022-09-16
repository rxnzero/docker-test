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

    var isDetail = false;
function isValid(){
	if($('input[name=bjobBzwkDstcd]').val() == ""){
		alert("업무그룹코드를 입력하여 주십시요.");
		return false;
	}else if($('input[name=bjobBzwkName]').val() == ""){
		alert("업무그룹명를 입력하여 주십시요.");
		return false;
	}
	
	return true;
}
function isValidGrid(){
	if($('select[name=addPrptyTypDstcd]').val() == ""){
		alert("프라퍼티구분코드를 선택하여 주십시요.");
		return false;
	}else if($('input[name=addPrptyName]').val() == ""){
		alert("프라퍼티명을 입력하여 주십시요.");
		return false;
	}else if($('input[name=addPrptyDesc]').val() == ""){
		alert("프라퍼티 설명을 입력하여 주십시요.");
		return false;
	}
	//중복체크
	var data = $("#grid").getRowData();
	for ( var i = 0; i < data.length; i++) {
		if (data[i]['PRPTYTYPDSTCD'] == $('select[name=addPrptyTypDstcd]').val()
		    && data[i]['PRPTYNAME'] == $('input[name=addPrptyName]').val()
		    ){
			alert("증복된 프라퍼티명이 존재합니다. 확인하여주십시요.");
		    return false;
		}
	}
	
	return true;
}


function unformatterFunction(cellvalue, options, rowObject){
	return "";
}

function formatterFunction(cellvalue, options, rowObject){
	var rowId = options["rowId"];
	var url = 'src=<c:url value="/images/bt/pop_delete.gif" />';
	//var adptrIoDstCd    = options["colModel"]["ADPTRIODSTCD"];
	//var adptrPrptyName  = options["colModel"]["ADPTRPRPTYNAME"];
	return "<img id='btn_pop_delete' name='img_"+rowId+"' "+url+ " />";
}

function gridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
		loadonce: true,
		rowNum: 10000,
		colNames:['프라퍼티타입',
                  '프라퍼티명',
                  '프라퍼티설명',
                  '삭제여부'
                  ],
		colModel:[
				{ name : 'PRPTYTYPDSTCD'   , align:'center' ,
				          formatter: function (cellvalue) {
				              if ( cellvalue == 'O' ) {
				                  return '기관';
                              } else if (cellvalue == 'F') {
                                  return '파일';
                              } else {
                                  return cellvalue;
                              }
                          },
				          unformat: function (cellvalue) {
				              if ( cellvalue == '기관' ) {
				                  return 'O';
                              } else if (cellvalue == '파일') {
                                  return 'F';
                              } else {
                                  return cellvalue;
                              }
                          }
				 },
				{ name : 'PRPTYNAME' , align:'left' },
				{ name : 'PRPTYDESC' , align:'left'  },
				{ name : 'DELETEYN'  , align:'center' ,unformat: unformatterFunction, formatter: formatterFunction}
				],
        jsonReader: {
             repeatitems:false
        },	   
        loadComplete : function () {

        },
        onSortCol : function(){
        	return 'stop';	//정렬 방지
        },        
	    height: '300',
		autowidth: true,
		viewrecords: true
	});
	
	
	resizeJqGridWidth('grid','title','1000');	
}
function init(url,key,callback){
	if(typeof callback === 'function') {
		callback(url,key);
	}
}
function detail(url,key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL'
		    , bjobBzwkDstcd : key
		    },
		success:function(json){
			var data = json;
			var detail = json.detail;
			//adapterType
			$("input[name=bjobBzwkDstcd]").attr('readonly',true);
			$("input,select").each(function(){
				var name = $(this).attr('name').toUpperCase();
				$(this).val(detail[name]);
			});
			//Prop 
			$("#grid")[0].addJSONData(data);
        	$("img[name*=img]").click(function(){
				var name = $(this).attr("name");
				var rowId =name.split("_")[1];
				$('#grid').jqGrid('delRowData',rowId);
			});				
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var url ='<c:url value="/bap/admin/work/bizGbnMan.json" />';
	var key ="${param.bjobBzwkDstcd}";
	
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	
	gridRendering();

	init(url,key,detail);
	

	$("#btn_modify").click(function(){
		if (!isValid())return;
	
	
		var data     = $("#grid").getRowData();
		var gridData = new Array();
		for (var i = 0; i <data.length; i++) {
			gridData.push(data[i]);
		}
	
	
		//공통부만 form으로 구성
		var postData = $('#ajaxForm').serializeArray();
		
		postData.push({ name: "gridData" , value:JSON.stringify(gridData)});
		
		if (isDetail){
			postData.push({ name: "cmd" , value:"UPDATE"});
		}else{
			postData.push({ name: "cmd" , value:"INSERT"});
		}
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("저장 되었습니다.");
				goNav(returnUrl);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("#btn_delete").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"DELETE"});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("삭제 되었습니다.");
				goNav(returnUrl);//LIST로 이동

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});
	$("#btn_pop_input").click(function(){
		if (!isValidGrid()){
			return;
		}
	
		var data = new Object();
		data["PRPTYTYPDSTCD"]=$("select[name=addPrptyTypDstcd]").val(); 
		data["PRPTYNAME"]=$("input[name=addPrptyName]").val(); 
		data["PRPTYDESC"]=$("input[name=addPrptyDesc]").val(); 
	
		var rows = $("#grid")[0].rows;
		var index = Number($(rows[rows.length-1]).attr("id"));
		if (isNaN(index)) index=0;
	    var rowid = index + 1;
		$("#grid").jqGrid('addRow', {
           rowID : rowid,          
           initdata : data,
           position :"last",    //first, last
           useDefValues : false,
           useFormatter : false,
           addRowParams : {extraparam:{}}
		});
		$("#"+$('#grid').jqGrid('getGridParam','selrow')).focus();
		$("img[name=img_"+rowid+"]").click(function(){
			var name = $(this).attr("name");
			var rowId =name.split("_")[1];
			$('#grid').jqGrid('delRowData',rowId);
		});	
		
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">업무구분코드</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:180px;">업무구분코드</th><td><input type="text" name="bjobBzwkDstcd" /> </td>
						</tr>
						<tr>
							<th>업무구분명</th><td><input type="text" name="bjobBzwkName" /> </td>
						</tr>
						<tr>
							<th>당메시지 사용여부 *</th>
							<td>
								<div class="select-style"><select name="thisMsgUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div>
							</td>
						</tr>
					</table>
				</form>
				
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:180px;">프라퍼티 타입</th>
						<td>
							<div class="select-style"><select name="addPrptyTypDstcd" >
								<option value="F">파일</option>
								<option value="O">기관</option>
							</select></div>
						</td>
						<th style="width:180px;">프라퍼티명</th>
						<td><input type="text"  name="addPrptyName"/></td>
						<td style="width:60px;" rowspan="2" ><img id="btn_pop_input" src="<c:url value="/img/btn_pop_input.png" />" class="btn_img" /></td>
					</tr>
					<tr>
						<th>프라퍼티 설명</td><td colspan="3"><input type="text"  name="addPrptyDesc" /></td>
					</tr>
				</table>
				<!-- grid -->
				<table id="grid" ></table>
	
	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

