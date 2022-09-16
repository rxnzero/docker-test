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
 	if($('input[name=bjobBzwkPrcssDstcd]').val().trim() == ""){
		alert("�۾�����ó�������ڵ带 �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('input[name=bjobStgeDstcd]').val().trim() == ""){
		alert("�۾��ܰ豸���ڵ带 �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}
		
	return true;
}

function unformatterFunction(cellvalue, options, rowObject){
	return "";
}

function init(url,key,key2,callback){
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			new makeOptions("CODE","CODE").setObj($("select[name=telgmClsID]")).setNoValueInclude(true).setData(json.clsIDList).rendering();
			
			if (typeof callback === 'function') {
				callback(url,key,key2);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function detail(url,key,key2){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL'
		    , key : key
		    , key2 : key2
		    },
		success:function(json){
			var data = json;
			var detail = json.list;
			//adapterType
			$("input[name=bjobBzwkPrcssDstcd]").attr('readonly',true);
			$("input[name=bjobStgeDstcd]").attr('readonly',true);
			$("input,select").each(function(){
				var name = $(this).attr('name').toUpperCase();
				if ( name != null )
				$(this).val(detail[name]);
			});
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var url ='<c:url value="/bap/admin/message/flowStepMan.json" />';
	var key ="${param.key}";
	var key2 ="${param.key2}";
	
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	

	init(url,key,key2,detail);
	

	$("#btn_modify").click(function(){
		if (!isValid())return;

		//����θ� form���� ����
		var postData = $('#ajaxForm').serializeArray();

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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">�帧�ܰ�</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- ����-->
						<tr>
							<th style="width:200px;">BATCH�۾�����ó�������ڵ�</th><td><input type="text" name="bjobBzwkPrcssDstcd" /> </td>
						</tr>
						<tr>
							<th>BATCH�۾��ܰ豸���ڵ�</th><td><input type="text" name="bjobStgeDstcd"> </td>
						</tr>
						<tr>
							<th>BATCH�۾��ܰ�������</th>
							<td>
								<div class="select-style"><select type="text" name="bjobStgePtrnName">
									<option value="SEND">SEND</option>
									<option value="RECV">RECV</option>
									<option value="END">END</option>
									<option value="EEND">EEND</option>
								</select></div>
							 </td>
						</tr>		
						<tr>
							<th>BATCH�۾��帧������Ʈ��</th><td><input type="text" name="bjobFlowCmpoName"></td>
						</tr>	
						<tr>
							<th>����Ŭ����ID</th><td><div class="select-style"><select type="text" name="telgmClsID"></select></div> </td>
						</tr>	
						<tr>
							<th>������������</th><td><input type="text" name="unitTelgmLen"></td>
						</tr>	
						<tr>
							<th>BATCH�۾���弳��</th><td><input type="text" name="bjobNodeDesc"></td>
						</tr>			
					</table>
				</form>

				<!-- grid -->
				<table id="grid" ></table>
				

	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

