<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
%>

<%

%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>

<script language="javascript" >
var $ = jQuery.noConflict();
var bzwkDstCd = "";

var returnUrl = getReturnUrlForReturn();
function init(url){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_EAISVCNAME_COMBO'},
		success:function(json){
			var cnvsnTypeData	= json.cnvsnTypeRows;
			new makeOptions("CODE","NAME").setObj($("select[name=cnvsnType]")).setData(cnvsnTypeData).setFormat(codeName3OptionFormat).rendering();
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
$(document).ready(function() {	
	$("input[name=eaiSvcName]").focus();
	var url ='<c:url value="/onl/admin/rule/transformMan.json" />';
	init(url);
	
	$("#btn_modify").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"INSERT"});
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
	
	$("#btn_search").click(function(){
		var key = "";
		var args = new Object();
    	args['eaiSvcName'] = $('input[name=eaiSvcName]').val();
	    var url='<c:url value="/onl/transaction/extnl/interfaceMan.view"/>';
	    url = url + "?cmd=POPUP";
	    var ret = showModal(url,args,1020,630, function(arg){
	    	var args = null;
	        if(arg == null || arg == undefined ) {//chrome
	            args = this.dialogArguments;
	            args.returnValue = this.returnValue;
	        } else {//ie
	            args = arg;
	        }
	        
	        if( !args || !args.returnValue ) return;
	        
	        var ret = args.returnValue;
	        
			key = ret['key'];
			
			$("input[name=eaiSvcName]").val(key);
			$("input[name=eaiSvcDesc]").val(ret['eaiSvcDesc']);
			bzwkDstCd = ret['eaiBzwkDstCd'];
			
			$("input[name=eaiSvcName]").change();
	    });
	});

	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});	
	$("input[name=eaiSvcName],select[name=cnvsnType]").change(function(){
		var str = "TRANSFORM_"+bzwkDstCd+"_"+$("input[name=eaiSvcName]").val()+"_"+$("select[name=cnvsnType]").val();
		$("input[name=cnvsnName]").val(str);
		
		var str2 = $("input[name=eaiSvcDesc]").val();
		$("textarea[name=cnvsnDesc]").val(str2);
		
	});	
	
	$("input[name=eaiSvcName]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
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
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">전문레이아웃변환매핑 신규<span class="tooltip">전문레이아웃변환매핑을 신규 등록하는 화면입니다. Excel 파일등록을 원하시면 왼쪽 메뉴 [전문레이아웃변환매핑 등록] 을 클릭하세요</span></div>				
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
				<!-- detail -->
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:25%;">IF 서비스코드</th>
							<td>
								<input type="text" name="eaiSvcName" style="width:calc(100% - 60px);"><img id="btn_search" src="<c:url value="/img/btn_pop_search.png" />" level="R" class="btn_img" />
									
							</td>
						</tr>
						<tr>
							<th>IF 서비스설명</th>
							<td>
								<input type="text" name="eaiSvcDesc" readOnly>
							</td>
						</tr>
						<tr>
							<th>전문레이아웃 변환매핑 유형</th>
							<td>
								<div class="select-style">
									<select name="cnvsnType" />
								</div>	
							</td>
						</tr>
						<tr>
							<th>전문레이아웃 변환매핑 코드</th>
							<td><input type="text"  name="cnvsnName" readonly="readonly"/></td>
						</tr>
						<tr height="100px">
							<th>변환 설명</th><td><textarea  name="cnvsnDesc" style="width:100%;height:100px"></textarea></td>
						</tr>
					</table>
					</form>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

