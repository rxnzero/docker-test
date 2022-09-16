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
var selectName ="eaiBzwkDstcd";
    var isDetail = false;
function isValid(){
 	if($('input[name=eaiBzwkDstcd]').val().trim() == ""){
		alert("���� ���и� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}else if($('input[name=instanceCode]').val() == ""){
		alert("�ν��Ͻ� �ڵ���� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}
	
	return true;
}
function isValidGrid(){
	return true;
}


function unformatterFunction(cellvalue, options, rowObject){
	return "";
}

function init(url,key,callback){
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			// �����ڵ尡 ��ϵǾ����� ���� �����͵� �־... �ϴ��� input���� ����
			//new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=eaiBzwkDstcd]")).setData(json.bizList).setFormat(codeName3OptionFormat).rendering();

			if(key == "") setSearchable(selectName);	// �޺��� searchable ����
			
			if (typeof callback === 'function') {
				callback(url,key);
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
		data:{cmd: 'DETAIL'
		    , eaiBzwkDstcd : key
		    },
		success:function(json){
			var data = json;
			var detail = json.list;
			//adapterType
			$("input[name=eaiBzwkDstcd]").attr('readonly',true);
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
	var url ='<c:url value="/onl/admin/service/bzwkToServiceMan.json" />';
	var key ="${param.key}";
	
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	
	//gridRendering();

	init(url,key,detail);
	

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
				<div class="title">�޽����׸�</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- ����-->
						<tr>
							<th style="width:20%;">���� ���и�</th>
							<td ><input type="text" name="eaiBzwkDstcd" /> </td>
						</tr>
						<tr>
							<th>�ν��Ͻ� �ڵ��</th>
							<td ><input type="text" name="instanceCode" /> </td>
						</tr>						
					</table>
				</form>

				<!-- grid -->
				<table id="grid" ></table>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

