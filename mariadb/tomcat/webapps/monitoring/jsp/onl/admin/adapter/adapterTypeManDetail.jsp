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
var url      = '<c:url value="/onl/admin/adapter/adapterTypeMan.json" />';
var url_view = '<c:url value="/onl/admin/adapter/adapterTypeMan.view" />';

var isDetail=false;
var lastsel2;
var domainName = new Array();			//도메인 콤보박스
function isValid(){
	if($('input[name=adptrCd]').val() == ""){
		alert("어댑터 유형을 선택하여 주십시요.");
		return false;
	}else if($('input[name=adptrName]').val() == ""){
		alert("어댑터 유형명을 입력하여 주십시요.");
		return false;
	}
	
	return true;
}
function isValidGrid(){
	if($('select[name=addAdptrIoDstCd]').val() == ""){
		alert("어댑터 입출력구분코드를 선택하여 주십시요.");
		return false;
	}else if($('input[name=addAdptrPrptyName]').val() == ""){
		alert("어댑터 프라퍼티명을 입력하여 주십시요.");
		return false;
	}else if($('input[name=addAdptrPrptyDesc]').val() == ""){
		alert("어댑터프라퍼티 설명을 입력하여 주십시요.");
		return false;
	}
	//중복체크
	var data = $("#grid").getRowData();
	for ( var i = 0; i < data.length; i++) {
		if (data[i]['ADPTRIODSTCD'] == $('select[name=addAdptrIoDstCd]').val()
		    && data[i]['ADPTRPRPTYNAME'] == $('input[name=addAdptrPrptyName]').val()
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
	var adptrIoDstCd    = options["colModel"]["ADPTRIODSTCD"];
	var adptrPrptyName  = options["colModel"]["ADPTRPRPTYNAME"];
	return "<img id='btn_pop_delete' name='img_"+rowId+"' src=<c:url value='/images/bt/pop_delete.gif' /> />";
}

function gridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
		loadonce: true,
		rowNum: 10000,
		editurl : "clientArray",
		//cellEdit: true,
		//cellsubmit : 'clientArray',
		colNames:['IO ',
                  '프라퍼티명',
                  '프라퍼티설명',
                  '도메인명',
                  '삭제여부'
                  ],
		colModel:[
				{ name : 'ADPTRIODSTCD'   , align:'left' ,width:'40' },
				{ name : 'ADPTRPRPTYNAME' , align:'left' ,width:'200' },
				{ name : 'ADPTRPRPTYDESC' , align:'left'  },
				{ name : 'DMNKND' 		  , align:'left' ,width:'60', editable : true, edittype:'select', formatter:'select'},
				{ name : 'DELETEYN'       , align:'center' ,width:'50' ,unformat: unformatterFunction, formatter: formatterFunction}
				],
        jsonReader: {
             repeatitems:false
        },	   
        loadComplete : function () {
			
        },
        gridComplete : function(){
       		 //$(this).setColProp('DMNKND',{editoptions:domainName});
        },
        onSortCol : function(){
        	return 'stop';	//정렬 방지
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
	    height: '500',
		autowidth: true,
		viewrecords: true
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');	
}
function init(key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=addAdptrIoDstCd]")).setData(json.adptrIoDstcdRows).setFormat(codeName3OptionFormat).rendering();
			
			domainName['value']     = ": ;"+getGridSelectText("CODE","CODE",json.domainName);
			$("#grid").setColProp('DMNKND',{editoptions:domainName,editable:true,edittype:'select',formatter:'select'});
			if(typeof callback === 'function') {
				callback(key);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});


	
}
function detail(key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL'
		    , adptrCd : key
		    },
		success:function(json){
			var data = json;
			var detail = json.detail;
			//adapterType
			$("input[name=adptrCd]").attr('readonly',true);
			$("input[name=adptrCd]").val(detail['ADPTRCD']);
			$("input[name=adptrName]").val(detail['ADPTRNAME']);
			//adapterTypeProp 
			
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
	var key ="${param.adptrCd}";
	
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	
	gridRendering();

	init(key,detail);
	

	$("#btn_modify").click(function(){
		if (lastsel2 !=undefined){
			if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
				$("#grid").saveRow(lastsel2,false,"clientArray");
			}		
		}
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
		data["ADPTRIODSTCD"]=$("select[name=addAdptrIoDstCd]").val(); 
		data["ADPTRPRPTYNAME"]=$("input[name=addAdptrPrptyName]").val(); 
		data["ADPTRPRPTYDESC"]=$("input[name=addAdptrPrptyDesc]").val(); 
	
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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">어댑터 유형</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:180px;">어댑터유형</th>
							<td ><input type="text" name="adptrCd" /> </td>
						</tr>
						<tr>
							<th>어댑터유형명</th><td ><input type="text" name="adptrName" /> </td>
						</tr>
					</table>
				</form>
				
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:180px;">어댑터 입출력구분코드</th>
						<td>
							<div class="select-style">
							<select name="addAdptrIoDstCd" />
							</div>
						</td>
						<th style="width:180px;">어댑터프라퍼티명</th>
						<td><input type="text"  name="addAdptrPrptyName"/></td>
						<td style="width:60px" rowspan="2" ><img id="btn_pop_input" src="<c:url value="/img/btn_pop_input.png"/>" class="btn_img" /></td>
					</tr>
					<tr>
						<th>어댑터프라퍼티 설명</th>
						<td colspan="3"><input type="text"  name="addAdptrPrptyDesc" /></td>
					</tr>
				</table>
				<!-- grid -->
				<table id="grid" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

