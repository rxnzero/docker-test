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
var url      = '<c:url value="/onl/admin/service/addQueueMan.json" />';
var url_view = '<c:url value="/onl/admin/service/addQueueMan.view" />';
var nodeNo =  new Array();		
var queueNo =  new Array();		
var isDetail=false;
var lastsel2;

function isValid(){

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

function gridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
		loadonce: true,
		rowNum: 10000,
		editurl : "clientArray",
		colNames:[
					'채널명',
					'구분',
					'노드번호',
					'큐번호'
                  ],
		colModel:[
				{ name : 'CHNNL'   			, align:'center'	,sortable:false  },
				{ name : 'GUBUN'             , align:'center' },
				{ name : 'NODENO'           , align:'center', editable:true, edittype:'select', formatter:'select'  },
				{ name : 'QUEUENO'          , align:'center' , editable:true, edittype:'select', formatter:'select' }
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
	
	
	resizeJqGridWidth('grid','title','1000');	
}
function init(key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			new makeOptions("CHNNL","CHNNL").setObj($("select[name=chnnl]")).setData(json.listChnnl).rendering();
			
			setSearchable("chnnl");
			nodeNo['value']     = ": ;"+getGridSelectText("CODE","NAME",json.listNode);
			queueNo['value']     = ": ;"+getGridSelectText("CODE","NAME",json.listQueue);
			$("#grid").setColProp('NODENO',{editoptions:nodeNo,editable:true,edittype:'select',formatter:'select'});
			$("#grid").setColProp('QUEUENO',{editoptions:queueNo,editable:true,edittype:'select',formatter:'select'});
			
			if(!isDetail){
				//초기 데이터 만들기
				var temp = ["S1","S2","R1","R2"];
				var initArray = new Array();
				for(var i =0; i <4 ; i++){
					var initData =	new Object();
					initData.CHNNL			= "";	
					initData.GUBUN		= temp[i];	
					initData.NODENO		= "";	
					initData.QUEUENO	 	= "";					
					$("#grid").jqGrid('addRow', { 
			           initdata : initData,
			           position :"last",    //first, last
			           useDefValues : false,
			           useFormatter : false,
			           addRowParams : {extraparam:{}}
					});	
				}
				$("#grid").jqGrid("resetSelection");		
			}
			
			
			
			
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
		    , chnnl : key
		    },
		success:function(json){
			var data = json;
			$("select[name=chnnl]").val(key);
			$("select[name=chnnl]").attr('disabled',true);
			$("#grid")[0].addJSONData(data);
			
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var key ="${param.chnnl}";
	
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	
	gridRendering();

	init(key,detail);
	$("select[name=chnnl]").val("");

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
		postData.push({ name: "cmd" , value:"DELETE"},{name:"chnnl", value:$("select[name=chnnl] option:selected").val()});
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
	$("select[name=chnnl]").change(function(){
		var name = $(this).val();
		var rows = $("#grid").jqGrid("getDataIDs");
		for(var i =0; i < rows.length; i++){
			$("#grid").setRowData(rows[i],{CHNNL:name});
		}
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
				<div class="title">채널 별 큐정보</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:20%;">채널명</th>
							<td ><div class="select-style"><select type="text" name="chnnl"></select></div> </td>
						</tr>

					</table>
				</form>
				
				<!-- grid -->
				<table id="grid" ></table>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

