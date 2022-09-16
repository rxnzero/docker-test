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
var url      ='<c:url value="/onl/admin/adapter/messageKeyMan.json" />';
var url_view ='<c:url value="/onl/admin/adapter/messageKeyMan.view" />';

var selectName = "adptrBzwkGroupName";	// selectBox Name

var isDetail = false;
function buildJsonArray(){
	var jsonArr = [];
    var jsonArrIndex = 0;
	for(var i=0;i<9;i++){
		var rowData = {fldPrcssNo:"",bzwkFldName:"",clsName:"",msgFldStartSituVal:"",msgFldLen:"",nomalPrcssCtnt:""};
		for(var key in rowData){
			var value = $("input[name="+key+"]").eq(i).val();
			rowData[key] = value;
			if (!value) {
				continue;
            }
		}	
		if( rowData.bzwkFldName.trim()=="") break;  
		
		jsonArr[jsonArrIndex] = rowData;
		jsonArrIndex++;
		
	}   
	return jsonArr; 
}	

function isValid(){
	if($('select[name=adptrBzwkGroupName]').val() == ""){
		alert("����͸��� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('select[name=msgDstcd]').val() == ""){
		alert("�޽��������� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('select[name=ioDstcd]').val() == ""){
		alert("�����ɱ����� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}

	for(var i=0;i<9;i++){
		var value = $("input[name=bzwkFldName]").eq(i).val();
		if (value.length>0){
			if (isNaN(parseInt($("input[name=msgFldStartSituVal]").eq(i).val()))){
				alert("�ʵ������ġ"+Number(i+1)+"�� ���� Ȯ���Ͽ��ֽʽÿ�.");
				return false;
			}
			if (isNaN(parseInt($("input[name=msgFldLen]").eq(i).val()))){
				alert("�ʵ����"+Number(i+1)+"�� ���� Ȯ���Ͽ��ֽʽÿ�.");
				return false;
			}
		}
	}

	
	return true;
}
function init(key){
	
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			//adptrBzwkGroupName combo
			new makeOptions("CODE","NAME").setObj($("select[name=adptrBzwkGroupName]")).setFormat(codeName3OptionFormat).setData(json.adapterRows).rendering();
			//msgDstcd combo
			new makeOptions("CODE","NAME").setObj($("select[name=msgDstcd]")).setFormat(codeName3OptionFormat).setData(json.msgTypeRows).rendering();
			//ioDstcd combo
			new makeOptions("CODE","NAME").setObj($("select[name=ioDstcd]")).setFormat(codeName3OptionFormat).setData(json.exrTypeRows).rendering();
			
			setSearchable(selectName);	// �޺��� searchable ����
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();	
	
	var key ="${param.adptrBzwkGroupName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	init(key);
	
	$("#btn_modify").click(function(){
		if (!isValid())return;
	
		//����θ� form���� ����
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "adptrBzwkGroupName" , value:$("select[name=adptrBzwkGroupName]").val()});
		postData.push({ name: "gridData" , value:JSON.stringify(buildJsonArray())});
		
		postData.push({ name: "cmd" , value:"INSERT"});
		
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
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title">�޽��� Ű</div>	
				<!-- ����-->	
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">		
						<tr>
							<th style="width:150px;">����͸�</th>
							<td colspan="3"><select name="adptrBzwkGroupName"/> </td>
						</tr>
						<tr>
							<th style="width:150px;">�޽�������</th>
							<td><div class="select-style"><select type="text"  name="msgDstcd"/></div></td>
							<th style="width:150px;">�����ɱ���</th>
							<td><div class="select-style"><select type="text"  name="ioDstcd"/></div>
							<input type="hidden" name="groupInorNo" />
							</td>
							
						</tr>		
					</table>
				</form>
						<!-- ���� -->
				<c:forEach var="i" begin="1" end="9">
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:150px;background-color:#c5c5c5">�����ʵ��<c:out value="${i}"/></th>
						<td  colspan="3"><input type="hidden" name="fldPrcssNo" value="<c:out value="${i}"/>" />
						<input type="text" name="bzwkFldName"/></td>
					</tr>
					<tr>
						<th>Ŭ������<c:out value="${i}"/></th>
						<td  colspan="3"><input type="text" name="clsName"/></td>
					</tr>
					<tr>
						<th>�ʵ������ġ<c:out value="${i}"/></th>
						<td><input type="text"  name="msgFldStartSituVal"/></td>
						<th>�ʵ����<c:out value="${i}"/></th>
						<td><input type="text"  name="msgFldLen"/></td>
					</tr>
					<tr>
						<th>����<c:out value="${i}"/></th>
						<td  colspan="3"><input type="text" name="nomalPrcssCtnt"/></td>
					</tr>	
					</c:forEach>			
				</table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

