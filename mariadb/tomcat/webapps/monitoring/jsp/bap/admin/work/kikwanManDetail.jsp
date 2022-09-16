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
	if($('input[name=kikwanCd]').val().trim() == ""){
		alert("기관코드를 입력하여 주십시요.");
		return false;
	}else if($('input[name=kikwanName]').val() == ""){
		alert("기관명를 입력하여 주십시요.");
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

function formatterFunction(cellvalue, options, rowObject){
	var rowId = options["rowId"];
	var url = 'src=<c:url value="/images/bt/pop_delete.gif" />';
	//var adptrIoDstCd    = options["colModel"]["ADPTRIODSTCD"];
	//var adptrPrptyName  = options["colModel"]["ADPTRPRPTYNAME"];
	return "<img id='btn_pop_delete' name='img_"+rowId+"' "+url+ " />";
}


function init(url,key,callback){
	if (!isDetail){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'DETAIL'
			    , kikwanCd : key
			    },
			success:function(json){
				var data = json;
				var detail = json.list;
				//adapterType
				$("input[name=kikwanCd]").val(detail["AUTOCD"]);		
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	
	}
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
		    , kikwanCd : key
		    },
		success:function(json){
			var data = json;
			var detail = json.list;
			//adapterType
			$("input[name=kikwanCd]").attr('readonly',true);
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
	var url ='<c:url value="/bap/admin/work/kikwanMan.json" />';
	var key ="${param.kikwanCd}";
	
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
				<div class="title">FTManager기관관리</div>						
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:180px;">기관코드</th><td><input type="text" name="kikwanCd" /> </td>
						</tr>
						<tr>
							<th>기관명</th><td><input type="text" name="kikwanName" /> </td>
						</tr>
						<tr>
							<th>시스템IP</th><td><input type="text" name="SysIp" /> </td>
						</tr>
						<tr>
							<th>암호화IP</th><td><input type="text" name="EncIp" /> </td>
						</tr>				
						<tr>
							<th>당메시지 사용여부 *</th>
							<td>
								<div class="select-style"><select name="thisMsgUseYn">
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

