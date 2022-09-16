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
    var lastsel2;

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


function gridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
		loadonce: true,
		rowNum: 10000,
		editurl : "clientArray",
		colNames:['������Ƽ��',
                  '������Ƽ����',
                  '������Ƽ��'
                  ],
		colModel:[
				{ name : 'PRPTYNAME' , align:'left' },
				{ name : 'PRPTYDESC' , align:'left' },
				{ name : 'PRPTY2VAL' , align:'left', editable : true }
				],
        jsonReader: {
             repeatitems:false
        },	   
        loadComplete : function () {

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
        	return 'stop';	//���� ����
        },    
	    height: '300',
		autowidth: true,
		viewrecords: true
	});
	
	
	resizeJqGridWidth('grid','title','1000');	
}
function init(url,key){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=bjobBzwkDstcd]")).setData(json.bjobBzwkDstcd).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=groupCoCd]")).setData(json.groupCoCd).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=sysCd]")).setNoValueInclude(true).setNoValue('','����').setData(json.sysCd).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=uapplCd]")).setNoValueInclude(true).setNoValue('   ','����').setData(json.uapplCd).rendering();
			debugger;
			if ( isDetail ){
			    detail(url, key);
			}else{
				$.ajax({
					type : "POST",
					url:url,
					dataType:"json",
					data:{ cmd: 'LIST_PROP',
						   bjobBzwkDstcd : $("select[name=bjobBzwkDstcd]").val()
		            },
		            success:function(json){
		            	$("#grid")[0].addJSONData(json);
		            	$("input[name=prptyGroupName]").val("TelegramInfo{" + detail["BJOBBZWKDSTCD"] + "_" + detail["BJOBTRANDSTCDNAME"] + "}");
						$("input[name=thisMsgChrgIDs]").val(' ');
						$("input[name=intfID]").val(' ');
						$("input[name=msgPrcssPrity]").val('999');
						
		            },
		            error:function(e){
		                alert(e.responseText);
		            }
		         });
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function detail(url,key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{ cmd: 'DETAIL',
		       bjobMsgDstcd : key
		    },
		success:function(json){
			var data = json;
			var detail = json.detail;
			
			//adapterType
			$("select[name=bjobBzwkDstcd]").attr('disabled',true);
			$("input[name=bjobTranDstcdName]").attr('readonly',true);
			$("input,select").each(function(){
				var name = $(this).attr('name').toUpperCase();
				$(this).val(detail[name]);
			});
			
			//Prop 
			$("#grid")[0].addJSONData(data);
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}

var submitData = {};

$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var url ='<c:url value="/bap/admin/work/messageProcMan.json" />';
	var key ="${param.bjobMsgDstcd}";
	$("input[name*=Size]").inputmask('decimal',{groupSeparator:',',digits:0,autoGroup:true,prefix:'',rightAlign:false,autoUnmask:true,removeMaskOnSubmit:true});
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	
	gridRendering();

	init(url,key);
	

	$("#btn_modify").click(function(){
		debugger;
		if (!isValid())return;
		if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
			$("#grid").saveRow(lastsel2,false,"clientArray");
		}
	
	
		var data     = $("#grid").getRowData();
		var gridData = new Array();
		for (var i = 0; i <data.length; i++) {
			gridData.push(data[i]);
		}
	
		//����θ� form���� ����
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "gridData" , value:JSON.stringify(gridData)});
		postData.push({ name: "bjobBzwkDstcd" , value: $("select[name=bjobBzwkDstcd]").val()});
		postData.push({ name: "prptyGroupName" , value:"TelegramInfo{" + $("select[name=bjobBzwkDstcd]").val() + "_" + $("input[name=bjobTranDstcdName]").val() + "}"});
		postData.push({ name: "prptyGroupDesc" , value:$("select[name=bjobBzwkDstcd]").val()+"��ġ �۾��� [" +$("input[name=bjobTranDstcdName]").val() +  "]�޽�����  �ۼ��� ������ ������Ƽ ����"});
        		
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

	$("select[name=bjobBzwkDstcd]").change(function(){
		$.ajax({  
		    type : "POST",
		    url:url,
		    dataType:"json",
		    data:{ cmd: 'LIST_PROP',
		           bjobBzwkDstcd : $(this).val()
		         },
		    success:function(json){
		        $("#grid")[0].addJSONData(json);
		    }
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
				<div class="title">�ۼ��� ����</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- ����-->
						<tr>
							<th style="width:180px;">���������ڵ�</th>
							<td><div class="select-style"><select name="bjobBzwkDstcd">
								</select></div>
							</td>
						</tr>
						<tr>
							<th>BATCH�۾��޽��������ڵ�</th><td><input type="text" maxlength="40" name="bjobTranDstcdName" /> </td>
						</tr>
						<tr>
							<th>BATCH�۾��޽������и�</th><td><input type="text" name="bjobMsgDsticName" /> </td>
						</tr>
						<tr>
							<th>BATCH�۾��������ũ��</th><td><input type="text" name="bjobTelgmHdrSize" /> </td>
						</tr>
						<tr>
							<th>BATCH�۾�����������ũ��</th><td><input type="text" name="bjobTelgmRecSize" /> </td>
						</tr>
						<tr>
							<th>BATCH�۾�����Ʈ���Ϸ�ũ��</th><td><input type="text" name="bjobTelgmTrailSize" /> </td>
						</tr>
						<tr>
							<th>���ϼ۽Ż�뿩��</th>
							<td><div class="select-style"><select name="fileSendUseYn">
								<option value="1">���</option>
								<option value="0">������</option>
								</select></div>
							</td>
						</tr>
						<tr>
							<th>���ϼ��Ż�뿩��</th>
							<td><div class="select-style"><select name="fileRecvUseYn">
								<option value="1">���</option>
								<option value="0">������</option>
								</select></div>
							</td>
						</tr>
						<tr>
							<th>�۾�ó�� �켱����</th><td><input type="text" name="msgPrcssPrity" /> </td>
						</tr>
						<tr>
							<th>����ý��� CODE</th>
							<td><div class="select-style"><select name="sysCd"></select></div>
							</td>
						</tr>
						<tr>
							<th>APPLICATION CODE</th>
							<td><div class="select-style"><select name="uapplCd"></select></div>
							</td>
						</tr>
						<tr>
							<th>�׷�籸��</th>
							<td><div class="select-style"><select name="groupCoCd"></select></div>
							</td>
						</tr>
						<tr>
							<th>���ϸ� ����</th>
							<td><div class="select-style"><select name="sndrcvFileName">
								<option value=" ">������</option>
								<option value="yyyy">YYYY</option>
								<option value="yyyyMM">YYYYMM</option>
								<option value="MMdd">MMDD</option>
								<option value="yyyyMMdd">YYYYMMDD</option>
								<option value="001">�Ϸù�ȣ</option>
								<option value="yyyy_001">YYYY_�Ϸù�ȣ</option>
								<option value="yyyyMM_001">YYYYMM_�Ϸù�ȣ</option>
								<option value="MMdd_001">MMDD_�Ϸù�ȣ</option>
								<option value="yyyyMMdd_001">YYYYMMDD_�Ϸù�ȣ</option>
								</select></div>
							</td>
						</tr>
						<tr> <!-- hidden="hidden" -->
							<th>���ϴ����</th><td><input type="text" name="thisMsgChrgIDs" /> </td>
						</tr>
						<tr>
							<th>���Ž� �˸�����</th>
							<td>
								<div class="select-style"><select name="recvNotiUseYn">
									<option value="1">���</option>
									<option value="0">������</option>
								</select></div>
							</td>
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
						<!-- 
						<tr>
							<th>prptyGroupName</th><td><input name="prptyGroupName" /> </td>
						</tr>
						 -->
						<tr hidden="hidden">
							<th>intfID</th><td><input type="text" name="intfID" /> </td>
						</tr>
						<tr hidden="hidden">
							<th>bjobMsgDstcd</th><td><input type="text" name="bjobMsgDstcd" /> </td>
						</tr>
						
					</table>
				</form>

				
				<div class="table_row_title">������Ƽ ����</div>					
				<!-- grid -->
				<table id="grid" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>