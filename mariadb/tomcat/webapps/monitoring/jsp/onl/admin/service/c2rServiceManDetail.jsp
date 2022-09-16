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
var url      = '<c:url value="/onl/admin/service/c2rServiceMan.json" />';
var url_view = '<c:url value="/onl/admin/service/c2rServiceMan.view" />';

var selectName = "psvSysBzwkDstcd,outbndRoutName,psvSysAdptrBzwkGroupName";	// selectBox Name

	var isDetail = false;
	function isValid() {

		var extnlInstiIdnfiName = $('input[name=extnlInstiIdnfiName]'); 
		if ( extnlInstiIdnfiName.val() == "") {
			alert("기관코드을 입력하여 주십시요.");
			extnlInstiIdnfiName.focus();
			return false;
		}
		var svcPrcssNo = $('select[name=svcPrcssNo]'); 
		if ( svcPrcssNo.val() == "") {
			alert("서비스 처리순서를 입력하여 주십시요.");
			svcPrcssNo.focus();
			return false;
		}		

		return true;
	}
	function isValidClone() {

		var extnlInstiIdnfiName = $('input[name=newExtnlInstiIdnfiName]'); 
		if ( extnlInstiIdnfiName.val() == "") {
			alert("기관코드을 입력하여 주십시요.");
			extnlInstiIdnfiName.focus();
			return false;
		}
		var svcPrcssNo = $('select[name=newSvcPrcssNo]'); 
		if ( svcPrcssNo.val() == "") {
			alert("서비스 처리순서를 입력하여 주십시요.");
			svcPrcssNo.focus();
			return false;
		}	

		return true;
	}	

	function init( key,key2, callback) {
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_DETAIL_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=psvIntfacDsticName]" )).setData(json.psvItfTypeRows        ).rendering();//수동 인터페이스 유형	             		
				new makeOptions("CODE","NAME").setObj($("select[name=psvSysBzwkDstcd]"    )).setData(json.bizRows               ).setFormat(codeName3OptionFormat).rendering();//수동업무구분        		
				new makeOptions("CODE","NAME").setObj($("select[name=psvSysIdName]"       )).setData(json.psvIdRows             ).rendering();//수동시스템ID        		
				new makeOptions("CODE","NAME").setObj($("select[name=flovrYn]"            )).setData(json.failOverClsRows       ).setFormat(codeName3OptionFormat).rendering();//FailOver여부           		
				new makeOptions("CODE","NAME").setObj($("select[name=chngEonot]"          )).setData(json.cnvExistNotRows       ).setFormat(codeName3OptionFormat).rendering();//변환유무             		
				new makeOptions("CODE","NAME").setObj($("select[name=bascRspnsChngEonot]" )).setData(json.bsRspCnvExistNotRows  ).setFormat(codeName3OptionFormat).rendering();//기본응답변환유무             		
				new makeOptions("CODE","NAME").setObj($("select[name=errRspnsChngEonot]"  )).setData(json.errRspCnvExistNotRows ).setFormat(codeName3OptionFormat).rendering();//오류응답변환유무             		
				new makeOptions("CODE","NAME").setObj($("select[name=outbndRoutName]"     )).setData(json.outBoundRoutingRows   ).rendering();//Outbound라우팅명             		
				new makeOptions("CODE","NAME").setObj($("select[name=supplDelYn]"         )).setData(json.addDelYnRows          ).setFormat(codeName3OptionFormat).rendering();//추가삭제여부             		
				new makeOptions("CODE","NAME").setObj($("select[name=hdrCtrlDstcd]"       )).setData(json.hdrCtlCdRows          ).setFormat(codeName3OptionFormat).rendering();//헤더제어구분코드             		
				new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=psvSysAdptrBzwkGroupName]")).setFormat(codeName3OptionFormat).setData(json.ouAdapterRows).rendering();//수동시스템인터페이스유형
				
				new makeOptions("CODE","NAME").setObj($("select[name=newSvcPrcssNo]"      )).setData(json.svcPrcssNo          	).rendering();//서비스 처리 순서
				new makeOptions("CODE","NAME").setObj($("select[name=svcPrcssNo]"         )).setData(json.svcPrcssNo          	).rendering();//서비스 처리 순서          
				
				if(key == "") setSearchable(selectName);	// 콤보에 searchable 설정
				
				if(typeof callback === 'function') {
					callback(key,key2);
	    		}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	
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
				extnlInstiIdnfiName : key,
				svcPrcssNo : key2
			},
			success : function(json) {
				debugger;
				var data = json;
				$("input[name=extnlInstiIdnfiName]").attr('readonly', true);
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				$("select[name=svcPrcssNo] option").not(":selected").remove();

				setSearchable(selectName);	// 콤보에 searchable 설정
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.extnlInstiIdnfiName}";
		var key2 = "${param.svcPrcssNo}";

		if (key != "" && key != "null") {
			isDetail = true;
		}
		init(key,key2, detail);

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
				data:{cmd: 'INITIALIZE',extnlInstiIdnfiName:$("input[name=extnlInstiIdnfiName]").val()},
				success:function(json){
					alert("성공하였습니다.");
				},
				error:function(e){
					alert(e.responseText);
				}
			});		
		});		
		$("#btn_clone").click(function() {
			if (!isValidClone()){
				return;
			}
		
			//공통부만 form으로 구성
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "cmd",
				value : "CLONE"
			});
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
				<div class="title">라우팅 C2R 기관 정보</div>	
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:150px;">기관 코드</th>
							<td colspan="3"><input type="text" name="extnlInstiIdnfiName"/> </td>							
						</tr>
						<tr>
							<th style="width:150px;">서비스처리 순서</th>
							<td>
								<div class="select-style"><select name="svcPrcssNo" /></div>
							</td>
							<th style="width:150px;">수동인터페이스유형</th>
							<td>
								<div class="select-style"><select name="psvIntfacDsticName"/></div> 
							</td>
						</tr>
						<tr>
							<th>수동업무구분</th>
							<td>
								<div class="select-style"><select name="psvSysBzwkDstcd"/></div> 
							</td>
							<th>수동시스템ID</th>
							<td>
								<div class="select-style"><select name="psvSysIdName"/></div> 
							</td>
						</tr>
						<tr>
							<th>수동시스템서비스코드</th><td><input type="text" name="psvSysSvcDsticName"/> </td>
							<th>수동시스템인터페이스유형</th>
							<td>
								<div class="select-style"><select name="psvSysAdptrBzwkGroupName"/></div> 
							</td>
						</tr>
						<tr>
							<th>FailOver여부</th>
							<td>
								<div class="select-style"><select name="flovrYn"/></div>
							</td>
							<th>변환유무</th>
							<td>
								<div class="select-style"><select name="chngEonot"/></div> 
							</td>
						</tr>
						<tr>
							<th>변환메시지ID</th><td colspan="3"><input type="text" name="chngMsgIdName"/> </td>
						</tr>
						<tr>
							<th>기본응답메시지비교값</th><td><input type="text" name="bascRspnsMsgCmprCtnt"/> </td>
							<th>기본응답변환유무</th>
							<td>
								<div class="select-style"><select name="bascRspnsChngEonot"/></div>
							</td>
						</tr>
						<tr>
							<th>기본응답변환메시지ID</th><td colspan="3"><input type="text" name="bascRspnsChngMsgIdName"/> </td>
							
						</tr>
						<tr>
							<th>오류응답메시지비교값</th><td><input type="text" name="errRspnsMsgCmprCtnt"/> </td>
							<th>오류응답변환유무</th>
							<td>
								<div class="select-style"><select name="errRspnsChngEonot"/></div>
							</td>
						</tr>
						<tr>
							<th>오류응답변환메시지ID</th><td colspan="3"><input type="text" name="errRspnsChngMsgIdName"/> </td>							
						</tr>
						<tr>
							<th>다음서비스처리순서</th><td><input type="text" name="nextSvcPrcssNo"  value="0"/> </td>
							<th>Outbound라우팅명</th>
							<td>
								<div class="select-style"><select name="outbndRoutName"/></div>
							</td>
						</tr>
						<tr>
							<th>타임아웃값</th><td><input type="text" name="toutVal" value="0"/> </td>
							<th>보상서비스처리코드</th><td><input type="text" name="cmpenSvcPrcssDsticName"/> </td>
						</tr>
						<tr>
							<th>추가삭제여부</th>
							<td>
								<div class="select-style"><select name="supplDelYn"/></div>
							</td>
							<th>헤더제어구분코드</th>
							<td>
								<div class="select-style"><select name="hdrCtrlDstcd"/></div>
							</td>
						</tr>
						<tr>
							<th>참고클래스명</th><td colspan="3"><input type="text" name="hdrRefClsName"/> </td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>