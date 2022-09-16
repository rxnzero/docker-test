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
		alert("작업업무처리구분코드를 입력하여 주십시요.");
		return false;
	}else if($('input[name=bjobStgeDstcd]').val().trim() == ""){
		alert("작업단계구분코드를 입력하여 주십시요.");
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
				<div class="title">흐름단계</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:200px;">BATCH작업업무처리구분코드</th><td><input type="text" name="bjobBzwkPrcssDstcd" /> </td>
						</tr>
						<tr>
							<th>BATCH작업단계구분코드</th><td><input type="text" name="bjobStgeDstcd"> </td>
						</tr>
						<tr>
							<th>BATCH작업단계유형명</th>
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
							<th>BATCH작업흐름컴포넌트명</th><td><input type="text" name="bjobFlowCmpoName"></td>
						</tr>	
						<tr>
							<th>전문클래스ID</th><td><div class="select-style"><select type="text" name="telgmClsID"></select></div> </td>
						</tr>	
						<tr>
							<th>단위전문길이</th><td><input type="text" name="unitTelgmLen"></td>
						</tr>	
						<tr>
							<th>BATCH작업노드설명</th><td><input type="text" name="bjobNodeDesc"></td>
						</tr>			
					</table>
				</form>

				<!-- grid -->
				<table id="grid" ></table>
				

	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

