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
var popData = window.dialogArguments['data'];
var isPopup = window.dialogArguments['ispop'];

function isValid(){


}
function disorder(val){
		if( val == "RECV"){
			$("input[name=telgmPtrnDstcd]").val(' ').prop('disabled',true).css('background-color','gray');
			$("input[name=telgmDtalsOperCd]").val(' ').prop('disabled',true).css('background-color','gray');
			$("input[name=bjobCmnTelgmTranCd]").val(' ').prop('disabled',true).css('background-color','gray');

			$("input[name=cndnTelgmPtrnCd]").prop('disabled',false).css('background-color','white');
			$("input[name=cndnTelgmMgtCd]").prop('disabled',false).css('background-color','white');
			$("input[name=cndnTranClsfiCd]").prop('disabled',false).css('background-color','white');				
		}else if(val == "SEND") {
			$("input[name=telgmPtrnDstcd]").prop('disabled',false).css('background-color','white');
			$("input[name=telgmDtalsOperCd]").prop('disabled',false).css('background-color','white');
			$("input[name=bjobCmnTelgmTranCd]").prop('disabled',false).css('background-color','white');	
		
			$("input[name=cndnTelgmPtrnCd]").val(' ').prop('disabled',true).css('background-color','gray');
			$("input[name=cndnTelgmMgtCd]").val(' ').prop('disabled',true).css('background-color','gray');
			$("input[name=cndnTranClsfiCd]").val(' ').prop('disabled',true).css('background-color','gray');		
		}	


}
function init(url,key,callback){
	$("input[name=bjobBzwkPrcssDstcd]").val(key);
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_POP_COMBO',
			  bjobBzwkPrcssDstcd : key},
		success:function(json){
			new makeOptions("BJOBSTGEDSTCD","BJOBSTGEDSTCD").setObj($("select[name=bjobStgeDstcd]")).setNoValueInclude(true).setData(json.stgeDstcdList).rendering();
			new makeOptions("BJOBSTGEDSTCD","BJOBSTGEDSTCD").setObj($("select[name=nextStgeDstcdName]")).setNoValueInclude(true).setData(json.stgeDstcdList).rendering();
			disorder("SEND");
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
	if (!isPopup)return;
	
	var data = popData;
			
			$("input[name=bjobBzwkPrcssDstcd]").attr('readonly',true);
			$("select[name=bjobStgeDstcd]").attr('readonly',true);
			$("input,select").each(function(){
				var name = $(this).attr('name').toUpperCase();
				if ( name != null )
				$(this).val(data[name]);
				//alert(name + "|" + data[name] + "|");
			});
			disorder($("select[name=bjobStgePtrnName]").val());

} 
 $(document).ready(function() {	
 	var url ='<c:url value="/bap/admin/message/flowRuleMan.json" />';
 	var key = popData['BJOBBZWKPRCSSDSTCD'];
	
/* 	if (popData != "" && popData !="null"){
		isPopup = true;
	}	 */
	
	init(url,key,detail);
	
	$("select[name=bjobStgeDstcd]").focus();
	
	$("#btn_close").click(function(){
		window.close();
	});
	$("#btn_modify").click(function(){
		var retData = new Object();
		$("input").each(function(){
			var name = $(this).attr('name').toUpperCase();
			var value =$(this).val();
			if ( name != null )
			if (value != '')
				retData[name]=value;
			else{
				console.log["blank : " +name];	
				retData[name]=" ";
				
			}
		});	
		$("select").each(function(){
			var name = $(this).attr('name').toUpperCase();
			var value =$(this).find("option:selected").val();
			if ( name != null )
			if (value != '' )
				retData[name]=value;
			else
				retData[name]=" ";
		});				
		window.returnValue = retData;
		
		$("#btn_close").trigger("click");
	});	
	
	$("select[name=bjobStgePtrnName]").change(function(){
		
		var val = $(this).val();
		disorder(val);
	});
	
	
	//buttonControl();
	
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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
				<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" />
				<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" />
				</div>
				<div class="title">메시지항목 선택</div>						
				
				<form id="ajaxForm">					
					<table class="search_condition" cellspacing="0">
						<tr>
							<th style="width:200px;">BATCH작업업무구분코드</th>
							<td><input type="text" name="bjobBzwkPrcssDstcd"></td>       
						</tr>
					</table>						
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:200px;">BATCH작업단계구분코드</th>
							<td><div class="select-style"><select type="text" name="bjobStgeDstcd"></select></div></td>
							<th style="width:200px;">다음단계구분코드명</th>
							<td><div class="select-style"><select type="text" name="nextStgeDstcdName"></select></div></td>
						</tr>
						<tr>
							<th style="width:200px;">BATCH작업단계유형명</th>
							<td>
							<div class="select-style"><select type="text" name="bjobStgePtrnName">
								<option value="SEND">SEND</option>
								<option value="RECV">RECV</option>
								<option value="END">END</option>
								<option value="EEND">EEND</option>
							</select></div>
							</td>
						   <th style="width:200px;">전문유형구분코드</th><td><input type="text" name="telgmPtrnDstcd"></td>
						</tr>
						<tr>
							<th style="width:200px;">전문세부운영코드</th><td><input type="text" name="telgmDtalsOperCd"></td>
							<th style="width:200px;">BATCH작업공통전문거래코드</th><td><input type="text" name="bjobCmnTelgmTranCd"></td>
						</tr>	
						<tr>
							<th style="width:200px;">타임아웃값</th><td><input type="text" name="toutVal" value='0'></td>
							<th style="width:200px;">BATCH작업반복횟수</th><td><input type="text" name="bjobIterNotms" value='0'></td>
						</tr>
						<tr>
							<th style="width:200px;">전문클래스ID</th><td><input type="text" name="telgmClsID"></td>
							<th style="width:200px;">조건항목결정내용</th><td><input type="text" name="cndnItemDcsnCtnt"></td>
						</tr>		
						<tr>
							<th style="width:200px;">조건전문유형코드</th><td><input type="text" name="cndnTelgmPtrnCd"></td>
							<th style="width:200px;">조건전문관리코드</th><td><input type="text" name="cndnTelgmMgtCd"></td>
						</tr>	
						<tr>
							<th style="width:200px;">조건거래분류코드</th><td><input type="text" name="cndnTranClsfiCd"></td>
							<th style="width:200px;">조건응답코드</th><td><input type="text" name="cndnRspnsCd"></td>
						</tr>	
						<tr>
							<th style="width:200px;">BATCH작업단계변동조건설명</th><td colspan="3"><input type="text" name="bjobStgeFlxblCndnDesc"></td>
						</tr>			    
					</table>					
				</form>	
				
				<!-- tree -->
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>