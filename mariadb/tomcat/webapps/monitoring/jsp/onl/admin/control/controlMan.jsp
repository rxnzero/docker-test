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
			new makeOptions("CODE","NAME").setObj($("select[name=searchEaiBzwkDstcd]")).setData(json.bizList).setNoValueInclude(true).setNoValue("A", "��ü").setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=searchControlSelectType]")).setData(json.controlSelectList).setFormat(codeName3OptionFormat).rendering();
			
			setSearchable(selectName);	// �޺��� searchable ����
			
			if(typeof callback === 'function') {
				callback(key);
			}			
		},
		error:function(e){
			alert(e.responseText);
		}
	});
	
}

// üũ�� grid Cell�� �ִ� EAISVCNAME���� �迭�� ����.
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
				  '��ȣ',
                  '���������ڵ�',
                  '�������и�',
                  '�����ڵ�',
                  '�����ڵ弳��',
                  '����'
                  ],
		colModel:[
// 				{ name : 'CHK', editable:true, edittype: 'checkbox', editoptions:{ value:"True:False" }, formatter: "checkbox", formatoptions: {disabled: false}, index:"CHK",width:'25' ,sortable:false },
				{ name : 'ROWNUM'        , align:'center',index:"id",width:'15'	,sortable:false },
				{ name : 'EAIBZWKDSTCD'  , align:'left',width:'25' },
				{ name : 'BZWKDSTICNAME' , align:'left',width:'70' },
				{ name : 'EAISVCNAME'    , align:'left',width:'55' },
				{ name : 'EAISVCDESC'    , align:'left' },
				{ name : 'STATUS'        , align:'center',width:'15', cellattr:function(rowId, tv, rowObject, cm, rdata){if(rowObject.STATUS == "����") return 'style="color:red"'}}
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
				$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)		
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
			alert("�ŷ����� �ڵ带 �Է��ϼ���.");
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
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ url:url,postData: postData ,page : "1" }).trigger("reloadGrid");
	});


	// ���� ���
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
			alert("��ȸ�� �����Ͱ� �����ϴ�.");
			return false;
		}
		
		if(chkList.length == 0)
		{
			alert("�����ڵ带 �����Ͽ� �ֽʽÿ�.");
			return false;
		}

		
		var r = confirm("������� �Ͻðڽ��ϱ�?");
		if (r == false){
			chkList = null;
			return false;
		}
		
		postData = getSearchForJqgrid("cmd","INSERT"); //jqgrid������ object �� 
		postData["arrEaiSvcName"] = chkList;
		
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("��� �Ǿ����ϴ�.");
				chkList = null;
				$("#btn_search").click();
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	
	// ���� ����
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
			alert("��ȸ�� �����Ͱ� �����ϴ�.");
			return false;
		}
		
		if(chkList.length == 0)
		{
			alert("�����ڵ带 �����Ͽ� �ֽʽÿ�.");
			return false;
		}
		
		var r = confirm("��������� ���� �Ͻðڽ��ϱ�?");
		if (r == false){
			return false;
		}
		postData = getSearchForJqgrid("cmd","DELETE"); //jqgrid������ object ��  
		postData["arrEaiSvcName"] = chkList;
		
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("���� �Ǿ����ϴ�.");
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
			//check�Ǿ� ������
 			var r = confirm("��ü���� �Ͻðڽ��ϱ�?"+"("+cnt+"��)");
 			if (r == false){
 				return false;
 			}
		}else{
 			var r = confirm("��ü�������� �Ͻðڽ��ϱ�?"+"("+cnt+"��)");
 			if (r == false){
 				return false;
 			}
		}
		
		$("input[type=checkbox][name*=jqg_grid_]").each(function(){
			$(this).prop("checked",check);
		});
		
	});
	$("input[name=allAdd]").click(function(e){
		var r = confirm("�ý��� ��ü �ŷ��� �����˴ϴ�.\n��ü��� �Ͻðڽ��ϱ�?");
		if (r == false){
			return false;
		}
		var postData = getSearchForJqgrid("cmd","INSERT_CONTROL_ALL"); //jqgrid������ object �� 
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("��ü��� �Ǿ����ϴ�.");
				$("#btn_search").click();
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
	
	});	
	
	
	$("input[name=allDelete]").click(function(e){
		var r = confirm("�ý��� ��ü �ŷ��� �����˴ϴ�.\n��ü���� �Ͻðڽ��ϱ�?");
		if (r == false){
			return false;
		}
		
		var postData = getSearchForJqgrid("cmd","DELETE_CONTROL_ALL"); //jqgrid������ object �� 
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				$("#grid").jqGrid("clearGridData");
				alert("��ü������� �Ǿ����ϴ�.");
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
				<div class="title">�ŷ�����</div>
				<div style="margin-bottom:15px;">
					<input type="button" name="allAdd" class="btn_img btn_allAdd">
					<input type="button" name="allDelete" class="btn_img btn_allDelete">
				</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">����</th>
							<td colspan="3">
								<div class="select-style">	
									<select name="searchControlType">
									</select>
								</div>
							</td>							
						</tr>	
						<tr>
							<th style="width:180px;">���/Ÿ��</th>
							<td>
								<div class="select-style">	
									<select name="searchIo">
									</select>
								</div>
							</td>
							<th style="width:180px;">�󼼾��������ڵ�</th>
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
							<th style="width:180px;">��������</th>
							<td>
								<div class="select-style">	
									<select name="searchControlSelectType">
									</select>
								</div>
							</td>		
							<th style="width:180px;">�����ڵ�</th>
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

