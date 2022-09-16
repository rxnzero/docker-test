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
		alert("�����׷��ڵ带 �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('input[name=bjobBzwkName]').val() == ""){
		alert("�����׷�� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}
	
	return true;
}
function isValidGrid(){
	if($('select[name=addPrptyTypDstcd]').val() == ""){
		alert("������Ƽ�����ڵ带 �����Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('input[name=addPrptyName]').val() == ""){
		alert("������Ƽ���� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('input[name=addPrptyDesc]').val() == ""){
		alert("������Ƽ ������ �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}
	//�ߺ�üũ
	var data = $("#grid").getRowData();
	for ( var i = 0; i < data.length; i++) {
		if (data[i]['PRPTYTYPDSTCD'] == $('select[name=addPrptyTypDstcd]').val()
		    && data[i]['PRPTYNAME'] == $('input[name=addPrptyName]').val()
		    ){
			alert("������ ������Ƽ���� �����մϴ�. Ȯ���Ͽ��ֽʽÿ�.");
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
		colNames:['������ƼŸ��',
                  '������Ƽ��',
                  '������Ƽ����',
                  '��������'
                  ],
		colModel:[
				{ name : 'PRPTYTYPDSTCD'   , align:'center' ,
				          formatter: function (cellvalue) {
				              if ( cellvalue == 'O' ) {
				                  return '���';
                              } else if (cellvalue == 'F') {
                                  return '����';
                              } else {
                                  return cellvalue;
                              }
                          },
				          unformat: function (cellvalue) {
				              if ( cellvalue == '���' ) {
				                  return 'O';
                              } else if (cellvalue == '����') {
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
        	return 'stop';	//���� ����
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
	
	
		//����θ� form���� ����
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
				alert("���� �Ǿ����ϴ�.");
				goNav(returnUrl);//LIST�� �̵�
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
				alert("���� �Ǿ����ϴ�.");
				goNav(returnUrl);//LIST�� �̵�

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST�� �̵�
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
				<div class="title">���������ڵ�</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- ����-->
						<tr>
							<th style="width:180px;">���������ڵ�</th><td><input type="text" name="bjobBzwkDstcd" /> </td>
						</tr>
						<tr>
							<th>�������и�</th><td><input type="text" name="bjobBzwkName" /> </td>
						</tr>
						<tr>
							<th>��޽��� ��뿩�� *</th>
							<td>
								<div class="select-style"><select name="thisMsgUseYn">
									<option value="1">���</option>
									<option value="0">������</option>
								</select></div>
							</td>
						</tr>
					</table>
				</form>
				
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:180px;">������Ƽ Ÿ��</th>
						<td>
							<div class="select-style"><select name="addPrptyTypDstcd" >
								<option value="F">����</option>
								<option value="O">���</option>
							</select></div>
						</td>
						<th style="width:180px;">������Ƽ��</th>
						<td><input type="text"  name="addPrptyName"/></td>
						<td style="width:60px;" rowspan="2" ><img id="btn_pop_input" src="<c:url value="/img/btn_pop_input.png" />" class="btn_img" /></td>
					</tr>
					<tr>
						<th>������Ƽ ����</td><td colspan="3"><input type="text"  name="addPrptyDesc" /></td>
					</tr>
				</table>
				<!-- grid -->
				<table id="grid" ></table>
	
	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

