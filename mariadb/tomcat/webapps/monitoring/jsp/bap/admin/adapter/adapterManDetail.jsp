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
	
	var url = '<c:url value="/bap/admin/adapter/adapterMan.json" />';
	
	var isDetail = false;
	var lastsel2;
	function isValid() {
		if ($('input[name=prptyGroupDesc]').val() == "") {
			alert("������Ƽ �׷� ������ �Է��Ͽ� �ֽʽÿ�.");
			return false;
		}

		return true;
	}
	function isValidGrid() {
		if ($('input[name=prptyName]').val() == "") {
			alert("������Ƽ Ű�� �Է��Ͽ� �ֽʽÿ�.");
			return false;
		} else if ($('input[name=prpty2Val]').val() == "") {
			alert("������Ƽ �� �Է��Ͽ� �ֽʽÿ�.");
			return false;
		}
		//�ߺ�üũ
		if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
			$("#grid").saveRow(lastsel2,false,"clientArray");
		}
		var data = $("#grid").getRowData();
		for ( var i = 0; i < data.length; i++) {
			if (data[i]['PRPTYNAME'] == $('input[name=prptyName]').val()) {
				alert("������ ������ƼŰ�� �����մϴ�. Ȯ���Ͽ��ֽʽÿ�.");
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
			autoencode : true,
			editurl : "clientArray",
			colNames : [ '������Ƽ Ű', '������Ƽ ��' ],
			colModel : [ { name : 'PRPTYNAME' , align : 'left'},
			             { name : 'PRPTY2VAL'      , align:'left' , title:false, editable: true}],
			jsonReader : {
				repeatitems : false
			},
			loadComplete : function() {
			},
	        onSortCol : function(){
	        	return 'stop';	//���� ����
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
			
			height : '350',
			autowidth : true,
			//autoheight : true,
			viewrecords : true
		});

		resizeJqGridWidth('grid', 'content_middle', '1000');
	}
	function init(key, callback) {
		if (typeof callback === 'function') {
			callback(key);
		}
	}
	function detail(key) {

		if (!isDetail){
			var prptNames = [ 'adapter.group.name' ,
			                  'bound.usage'        ,  
			                  'default.session'    ,  
			                  'll.field.index'     ,  
			                  'll.field.length'    ,  
			                  'max.connection'     ,  
			                  'max.session'        ,  
			                  'session.timeout'    ,  
			                  'socket.type'        ,  
			                  'trace.level'        ,  
			                  'timeout'            ,  
			                  'reponse.rule.code'  ,  
			                  'response.olny'      ,  
			                  'use.polling'        ];
			var prptValus = [ ''        ,
			                  'INBOUND' ,
			                  '1'       ,
			                  '0'       ,
			                  '4'       ,
			                  '1'       ,
			                  '1'       ,
			                  '20'      ,
			                  'SERVER'  ,
			                  '0'       ,
			                  '30'      ,
			                  ' '       ,
			                  'N'       ,
			                  'N'       ];
			                  
			                  
			for ( var inx=0; inx < prptNames.length; inx++){
				var  newData = new Object();
				newData.id = inx+1;
				newData.PRPTYNAME = prptNames[inx];
				newData.PRPTY2VAL = prptValus[inx];
				$("#grid").addRowData(newData.id,newData);
			}
			return;
		}
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				adptrBzwkGroupName : key
			},
			success : function(json) {
				var data = json;
				var detail = json.detail;
				$("input[name=adptrBzwkGroupName]").attr('readonly', true);
				$("input,select").each(function(){
					var name = $(this).attr('name').toUpperCase();
					$(this).val(detail[name]);
				});
				$("#grid")[0].addJSONData(data);
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.adptrBzwkGroupName}";

		if (key != "" && key != "null") {
			isDetail = true;
		}

		gridRendering();

		init(key, detail);

		$("#btn_modify").click(function() {
			if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
				$("#grid").saveRow(lastsel2,false,"clientArray");
			}
			var data = $("#grid").getRowData();
			var gridData = new Array();
			for ( var i = 0; i < data.length; i++) {
				gridData.push(data[i]);
			}

			//����θ� form���� ����
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
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
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
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST�� �̵�
		});
		$("#btn_pop_input").click(function() {
			if (!isValidGrid()) {
				return;
			}
			var data = new Object();
			data["PRPTYNAME"] = $("input[name=prptyName]").val();
			data["PRPTY2VAL"] = $("input[name=prpty2Val]").val();

			var rows = $("#grid")[0].rows;
			var index = Number($(rows[rows.length - 1]).attr("id"));
			if (isNaN(index))
				index = 0;
			var rowid = index + 1;
			$("#grid").jqGrid('addRow', {
				rowID : rowid,
				initdata : data,
				position : "last", //first, last
				useDefValues : false,
				useFormatter : false,
				addRowParams : {
					extraparam : {}
				}
			});
			$("#" + $('#grid').jqGrid('getGridParam', 'selrow')).focus();
			$("img[name=img_" + rowid + "]").click(function() {
				var name = $(this).attr("name");
				var rowId = name.split("_")[1];
				$('#grid').jqGrid('delRowData', rowId);
			});

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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">

					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>				
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">�����</div>						
				
				<form id="ajaxForm">
					<div class="table_row_title">�ϰ����� �����</div>
	
					<table id="detail" class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:180px;">����� �׷��</th>
							<td ><input type="text" name="adptrBzwkGroupName"/> </td>
						</tr>
						<tr>
							<th style="width:180px;">����� ����</th>
							<td >
								<div class="select-style">
									<select name="adptrCd" style="width:100%" >
									<option value="SOC">SocketAdapter</option>
									</select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>����� �׷켳��</th>
							<td ><input type="text" name="adptrBzwkGroupDesc"/> </td>
						</tr>
						<tr>
							<th>����� ��� ����</th>
							<td >
								<div class="select-style">
								<select name="adptrUseYn" style="width:100%" >
									<option value="1">���</option>
									<option value="0">������</option>
								</select> 
								</div>
							</td>
						</tr>

					</table>
					
					<table id="adapter" class="table_row"  cellspacing="0"  >					
						<tr>
							<th style="width:180px;">����� �̸�</th>
							<td ><input type="text" name="adptrBzwkName"/> </td>
						</tr>
						<tr>
							<th>������ Ŭ������</th>
							<td >
								<div class="select-style">
								<select name="lstnerClsName" style="width:100%" >
									<option value="com.eactive.eai.adapter.socket.SocketAdapterListener">com.eactive.eai.adapter.socket.SocketAdapterListener</option>
								</select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>����� �����</th>
							<td ><input type="text" name="adptrDesc"/> </td>
						</tr>
						<tr>
							<th>������Ƽ�׷��</th>
							<td ><input type="text" name="prptyGroupName"/> </td>
						</tr>
						<tr>
							<th>������Ƽ�׷� ����</th>
							<td ><input type="text" name="prptyGroupDesc"/> </td>
						</tr>						
					</table>
					</form>
					
					<!-- grid -->
					<table id="grid" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>