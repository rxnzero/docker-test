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
var url      = '<c:url value="/onl/admin/service/b2bAdapterMapMan.json" />';
var url_view = '<c:url value="/onl/admin/service/b2bAdapterMapMan.view" />';

var selectName = "psvSysAdptrBzwkGroupName,extnlInstiIdnfiName";	// selectBox Name

	var isDetail = false;
	function isValid() {
		var result = true;
		
		$("[required=true]").each(function(){
			if (!isValidCheck($(this))){
				result = false;
				return result;
			}
		});
		
		return result;
	}

	function init( key,key2,key3,key4, callback) {
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_DETAIL_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=eaiSevrInstncName]")).setNoValueInclude(true).setData(json.instanceList).rendering();
				new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=psvSysAdptrBzwkGroupName]")).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.ouAdapterList).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=extnlInstiIdnfiName]")).setNoValueInclude(true).setData(json.extList).rendering();
				
				if(key == "") setSearchable(selectName);	// 콤보에 searchable 설정
				
				if(typeof callback === 'function') {
					callback(key,key2,key3,key4);
	    		}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	
	}
	function detail( key,key2,key3,key4) {

		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				eaiSevrInstncName      : key,
				eaiSvcName             : key2,
				extnlInstiIdnfiName    : key3,
				dmndDtalsBzwkDsticName : key4
			},
			success : function(json) {
				var data = json;
				$("select[name=eaiSevrInstncName]").attr('readonly', true);
				$("select[name=extnlInstiIdnfiName]").attr('readonly', true);
				$("input[name=dmndDtalsBzwkDsticName]").attr('readonly', true);
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				$("select[name=eaiSevrInstncName] option").not(":selected").remove();
				$("select[name=extnlInstiIdnfiName] option").not(":selected").remove();
				
				$("select[name=psvSysAdptrBzwkGroupName]").change();//sync로 변경
				$("select[name=adptrBzwkName").val(data["ADPTRBZWKNAME"]);
				
				selectName = "psvSysAdptrBzwkGroupName";	// selectBox Name
				// 콤보에 searchable 설정
				setSearchable(selectName);
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.eaiSevrInstncName}";
		var key2 = "${param.eaiSvcName}";
		var key3 = "${param.extnlInstiIdnfiName}";
		var key4 = "${param.dmndDtalsBzwkDsticName}";

		if (key != "" && key != "null") {
			$(".cls_btn_td").remove();
			$(".cls_eaiSvcName_input_td").attr({"colspan":"2", "width":"100%"});
			$(".cls_eaiSvcName_table").attr("width", "100%");
			
			$("input[name=eaiSvcName]").attr("readOnly", true);
			$("input[name=eaiSvcName]").css({"background-color":"#E6E6E6"});
			$("input[name=dmndDtalsBzwkDsticName]").css("background-color", "#E6E6E6");
			
			isDetail = true;
		}
		init(key,key2,key3,key4, detail);

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
			var postData = $('#ajaxForm').serializeArray();
			postData.push({name:"cmd", value:"INITIALIZE"});
		
			$.ajax({  
				type : "POST",
				url:url,
				dataType:"json",
				data: postData,
				success:function(json){
					alert("성공하였습니다.");
				},
				error:function(e){
					alert(e.responseText);
				}
			});		
		});			
		$("select[name=psvSysAdptrBzwkGroupName]").change(function(){
			$.ajax({  
				type : "POST",
				url:url,
				dataType:"json",
				async:false,
				data:{cmd: 'LIST_DYNAMIC_COMBO',psvSysAdptrBzwkGroupName:$("select[name=psvSysAdptrBzwkGroupName]").val()},
				success:function(json){
					$("select[name=adptrBzwkName] option").remove();
					new makeOptions("ADPTRBZWKNAME","ADPTRBZWKNAME").setObj($("select[name=adptrBzwkName]")).setNoValueInclude(true).setNoValue("DEFAULT", "DEFAULT").setData(json.ouAdapterList).rendering();
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
		    var ret = showModal(interfaceUrl,args,1020,678, function(arg){
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
				<div class="title">라우팅 특정 포트 매핑</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:190px;">IF서버인스턴스명</th>
							<td><div class="select-style"><select type="text" name="eaiSevrInstncName" required=true desc="IF서버인스턴스명" ></select></div></td>
						</tr>
						<tr>
							<th>IF서비스코드</th>
							<td>
								<input type="text" name="eaiSvcName" style="width:calc(100% - 70px);"> 
								<img id="btn_search" src="<c:url value="/img/btn_pop_search.png" />" class="btn_img" />								
							</td>
						</tr>
						<tr>
							<th>IF 서비스설명</th>
							<td><input type="text" name="eaiSvcDesc" readOnly></td>
						</tr>
						<tr>
							<th>기관코드</th>
							<td><div class="select-style"><select name="extnlInstiIdnfiName" required=true desc="기관코드"></select></div></td>
						</tr>
						<tr>
							<th>세부업무구분명</th>
							<td><input type="text" name="dmndDtalsBzwkDsticName" required=true desc="세부업무구분명"/></td>
						</tr>
						<tr>
							<th>어댑터업무그룹명</th>
							<td><div class="select-style"><select name="psvSysAdptrBzwkGroupName" ></select></div></td>
						</tr>
						<tr>
							<th>어댑터업무이름</th>
							<td><div class="select-style"><select name="adptrBzwkName" ></select></div></td>
						</tr>			
					</table>
				</form> 
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>