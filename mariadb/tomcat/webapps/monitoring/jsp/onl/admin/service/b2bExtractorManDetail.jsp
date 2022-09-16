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
var url      = '<c:url value="/onl/admin/service/b2bExtractorMan.json" />';
var url_view = '<c:url value="/onl/admin/service/b2bExtractorMan.view" />';

	var isDetail = false;
	function isValid() {

		var eaiSvcName = $('input[name=eaiSvcName]'); 
		if ( eaiSvcName.val() == "") {
			alert("IF서비스코드명을 입력하여 주십시요.");
			eaiSvcName.focus();
			return false;
		}
		var svcPrcssNo = $('input[name=svcPrcssNo]'); 
		if ( svcPrcssNo.val() == "") {
			alert("처리번호를 입력하여 주십시요.");
			svcPrcssNo.focus();
			return false;
		}		

		return true;
	}

	function detail( key,key2) {

		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				eaiSvcName : key,
				svcPrcssNo : key2
			},
			success : function(json) {
				var data = json;
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				
				$("input[name=svcPrcssNo]").attr("readonly", true);

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.eaiSvcName}";
		var key2 = "${param.svcPrcssNo}";

		if (key != "" && key != "null") {
			$(".cls_btn_td").remove();
			$(".cls_eaiSvcName_input_td").attr({"colspan":"2", "width":"100%"});
			$(".cls_eaiSvcName_table").attr("width", "100%");
			
			$("input[name=eaiSvcName]").attr("readOnly", true);
			$("input[name=eaiSvcName]").css({"background-color":"#E6E6E6"});
			$("input[name=svcPrcssNo]").css("background-color", "#E6E6E6");
				
			isDetail = true;
		}
		if(!isDetail){
			$("input[name=svcRoutClsName]").val("com.eactive.eai.flowcontrol.action.");
			$("input[name=adptrRoutClsName]").val("com.eactive.eai.flowcontrol.action.");
			
		}
		detail(key,key2);

		$("#btn_modify").click(function() {
			if (!isValid()){
				return;
			}
		
			//공통부만 form으로 구성
			var postData = $('#ajaxForm').serializeArray();

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
					alert("저장 되었습니다.");
					goNav(returnUrl);//LIST로 이동
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
					alert("삭제 되었습니다.");
					goNav(returnUrl);//LIST로 이동

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST로 이동
		});
		$("#btn_initialize").click(function(){
			$.ajax({  
				type : "POST",
				url:url,
				dataType:"json",
				data:{cmd: 'INITIALIZE',eaiSvcName:$("input[name=eaiSvcName]").val()},
				success:function(json){
					alert("성공하였습니다.");
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
		    var interfaceUrl='<c:url value="/onl/transaction/extnl/interfaceMan.view"/>';
		    interfaceUrl = interfaceUrl + "?cmd=POPUP";
		    var ret = showModal(interfaceUrl,args,1000,600, function(arg){
		    	var args = null;
		        if(arg == null || arg == undefined ) {//chrome
		            args = this.dialogArguments;
		            args.returnValue = this.returnValue;
		        } else {//ie
		            args = arg;
		        }
		        
		        if( !args || !args.returnValue || !args.returnValue.key ) return;
		       	var ret = args.returnValue;
		       	key = ret['key'];
				
				$("input[name=eaiSvcName]").val(key);
				$("input[name=eaiSvcDesc]").val(ret['eaiSvcDesc']);
		    });
			
			
		});
		
		$("input[name=eaiSvcName]").keydown(function(key){
			if (key.keyCode == 13){
				$("#btn_search").click();
			}
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">라우팅 필드추출 정보<span class="tooltip">라우팅 B2B기관정보 상세관리를 위한 기관정보 추출이나 기관의 특정 포트에 매핑해서 데이터 전송을 위한 데이터 추출 정보 리스트</span></div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:190px;">IF서비스코드</th>
							<td>
								<input type="text" name="eaiSvcName" style="width:calc(100% - 70px);"> 
								<img id="btn_search" src="<c:url value="/img/btn_pop_search.png"/>" class="btn_img" />					
							</td>
						</tr>
						<tr>
							<th>IF 서비스설명</th>
							<td><input type="text" name="eaiSvcDesc" readOnly></td>
						</tr>
						<tr>
							<th>IF서비스 처리번호</th>
							<td><input type="text" name="svcPrcssNo" value="1" ></td>
						</tr>
						<tr>
							<th>기관코드추출 CLASS</th>
							<td><input type="text" name="svcRoutClsName" /></td>
						</tr>
						<tr>
							<th>어댑터라우팅추출 CLASS</th>
							<td><input type="text" name="adptrRoutClsName" /></td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>