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
<jsp:include page="/jsp/common/include/css.jsp" />
<jsp:include page="/jsp/common/include/script.jsp" />

<script language="javascript">
var url      = '<c:url value="/onl/admin/rule/transformFuncMan.json" />';
var url_view = '<c:url value="/onl/admin/rule/transformFuncMan.view" />';
var select_CNVSNFUNTNRETUNPTRNIDNAME = new Array();
	var isDetail = false;
	var lastsel2;
	function isValid() {
		if ($('input[name=prptyGroupDesc]').val() == "") {
			alert("프라퍼티 그룹 설명을 입력하여 주십시요.");
			return false;
		}

		return true;
	}
	function isValidGrid() {
		if ($('input[name=prptyName]').val() == "") {
			alert("프러퍼티 키를 입력하여 주십시요.");
			return false;
		} else if ($('input[name=prpty2Val]').val() == "") {
			alert("프러퍼티 값 입력하여 주십시요.");
			return false;
		}
		//중복체크
		if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
			$("#grid").saveRow(lastsel2,false,"clientArray");
		}
		var data = $("#grid").getRowData();
		for ( var i = 0; i < data.length; i++) {
			if (data[i]['PRPTYNAME'] == $('input[name=prptyName]').val()) {
				alert("증복된 프라퍼티키가 존재합니다. 확인하여주십시요.");
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
		return "<img id='btn_pop_delete' name='img_"+rowId+"' />";
	}
	function gridRendering() {
		$('#grid').jqGrid({
			datatype:"local",
			loadonce: true,
			rowNum: 10000,
			editurl : "clientArray",
			colNames : [ 'cnvsnFuntnName','일련번호', '파라미터명', '변환함수파라미터유형','변환함수파라미터설명' ],
			colModel : [ 
						 { name : 'CNVSNFUNTNNAME'           , hidden:true },
						 { name : 'CNVSNFUNTNPARMSERNO'      , align : 'center' ,key:true},
			             { name : 'CNVSNFUNTNPARMNAME'       , align : 'left', editable : true },
			             { name : 'CNVSNFUNTNPARMPTRNIDNAME' , align : 'center',editable:true, edittype:'select',editoptions:select_CNVSNFUNTNRETUNPTRNIDNAME, formatter:"select"/*, unformat : unformatterFunction, formatter : formatterFunction */}, 
			             { name : 'CNVSNFUNTNPARMDESC'       , align : 'left', editable : true }],
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

		resizeJqGridWidth('grid', 'title', '1000');
	}
	function init( key, callback) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=cnvsnFuntnRetunPtrnIdName]")).setData(json.returnTypeList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=cnvsnFuntnPtrnIdName]")).setData(json.typeList).setFormat(codeName3OptionFormat).rendering();
			select_CNVSNFUNTNRETUNPTRNIDNAME['value'] = ": ;"+getGridSelectText("CODE","NAME",json.returnTypeList);
			
			gridRendering();
			if (typeof callback === 'function') {
				callback(key);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});	
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
				cnvsnFuntnName : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				$("input[name=cnvsnFuntnName]").attr('readonly', true);
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					if(detail != null)
					$(tag+"[name="+name+"]").val(detail[name.toUpperCase()]);
				});				
				
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
		var key = "${param.cnvsnFuntnName}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		

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
					alert("저장 되었습니다.");
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
					alert("삭제 되었습니다.");
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
		$("#btn_new").click(function() {
			var rows = $("#grid")[0].rows;
			var index = Number($(rows[rows.length-1]).attr("id"));
			if (isNaN(index)) index=0;
			var data = new Object();
		    var rowid = index + 1;
			data['CNVSNFUNTNNAME']      = $("input[name=cnvsnFuntnName]").val();
			data['CNVSNFUNTNPARMSERNO'] = rowid;
			$("#grid").jqGrid('addRow', {
	           rowID : rowid,          
	           initdata : data,
	           position :"last",    //first, last
	           useDefValues : false,
	           useFormatter : false,
	           addRowParams : {extraparam:{}}
			});	
			$("#grid").saveRow(rowid,false,"clientArray");
		});
		$("#btn_delete2").click(function() {
		    var rowId = $("#grid").jqGrid('getGridParam', 'selrow');
			if (isNull(rowId)){
				alert('삭제할 데이터를 선택해 주세요.!');
				return ;
			}
			
			$("#grid").jqGrid('delRowData',rowId);
			
			var old = new Array();
		 	var ids = $("#grid").getDataIDs();
			for(var i=0;i<ids.length;i++ ){ //남은 갯수
				old[i] = $("#grid").getRowData(ids[i]);
			}
			$("#grid").jqGrid('clearGridData'); //전체삭제
			for(var i=0;i<old.length;i++ ){ //재정렬할 갯수
				old[i].id = i+1;
				old[i].CNVSNFUNTNPARMSERNO = i+1;
				$("#grid").addRowData(old[i].id,old[i]);
			}
			$("#grid").jqGrid('resetSelection');

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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">변환 함수</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">변환함수명</th>
							<td><input type="text" name="cnvsnFuntnName" />
							</td>
						</tr>
						<tr>
							<th>변환함수반환유형ID</th>
							<td><div class="select-style"><div class="select-style"><select name="cnvsnFuntnRetunPtrnIdName" /></div></td>
						</tr>
						<tr>
							<th>변환함수유형ID</th>
							<td><div class="select-style"><div class="select-style"><select name="cnvsnFuntnPtrnIdName" /></div></td>
						</tr>
						<tr>
							<th>변환함수생성클래스</th>
							<td><input type="text" name="cnvsnFuntnClsName" />
							</td>
						</tr>			
						<tr>
							<th>레이아웃유형설명</th>
							<td><textarea type="text" name="cnvsnFuntnDesc" ></textarea>
							</td>
						</tr>			
					</table>
				</form>
				
				<div style="position:relative; margin-bottom:15px;">
					<div class="table_row_title">변환함수 파라미터 정보</div>
					<div style="position:absolute; right:0; top:0;">			    
						<img id="btn_new"    src="<c:url value="/img/btn_new.png" />"    level="W" status="DETAIL,NEW" class="btn_img" />
						<img id="btn_delete2" src="<c:url value="/img/btn_delete.png"/>" level="W" status="DETAIL,NEW" class="btn_img" />
					</div>
				</div>
				
				<!-- grid -->
				<table id="grid"></table>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>