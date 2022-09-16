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
/* 	if($('input[name=key]').val().trim() == ""){
		alert("기관코드를 입력하여 주십시요.");
		return false;
	}else if($('input[name=kikwanName]').val() == ""){
		alert("기관명를 입력하여 주십시요.");
		return false;
	} */
	
	return true;
}
function isValidGrid(){
	return true;
}


function unformatterFunction(cellvalue, options, rowObject){
	return "";
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
		    , MsgItemDsticName : key
		    },
		success:function(json){
			var data = json;
			var detail = json.list;
			//adapterType
			$("input[name=msgItemDsticName]").attr('readonly',true);
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
	var url ='<c:url value="/bap/admin/message/messageItemMan.json" />';
	var key ="${param.key}";
	
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	
	//gridRendering();

	init(url,key,detail);
	

	$("#btn_modify").click(function(){
		if (!isValid())return;

		//공통부만 form으로 구성
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
				<div class="title">메시지항목</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:200px;">메시지 항목 구분명</th><td><input type="text" name="msgItemDsticName" /> </td>
						</tr>
						<tr>
							<th>메시지 컬럼명</th><td><input type="text" name="msgClmnName" /> </td>
						</tr>
						<tr>
							<th>메시지컬럼 속성유형코드 *</th>
							<td>
								<div class="select-style"><select name="msgClmnAttriPtrnCd">
									<option value="AA">AA</option>
									<option value="AN">AN</option>
									<option value="NN">NN</option>
								</select></div>
							</td>
						</tr>
						<tr>
							<th>메시지 컬럼값</th><td><input type="text" name="msgClmnVal" /> </td>
						</tr>				
						<tr>
							<th>당메시지 컬럼 사용여부 *</th>
							<td>
								<div class="select-style"><select name="thisMsgClmnUseYn">
									<option value="1">사용</option>
									<option value="0">사용안함</option>
								</select></div>
							</td>
						</tr>
					</table>
				</form>

				<!-- grid -->
				<table id="grid" ></table>
					
					
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

