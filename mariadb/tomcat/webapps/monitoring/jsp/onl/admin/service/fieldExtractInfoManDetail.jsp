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
var url      = '<c:url value="/onl/admin/service/fieldExtractInfoMan.json" />';
var url_view = '<c:url value="/onl/admin/service/fieldExtractInfoMan.view" />';

	var isDetail = false;
	function isValid() {

		var eaiSvcName = $('input[name=eaiSvcName]'); 
		if ( eaiSvcName.val() == "") {
			alert("IF서비스코드를 입력하여 주십시요.");
			eaiSvcName.focus();
			return false;
		}

		return true;
	}

	function init( key,key2, callback) {
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{	cmd: 'LIST_DETAIL_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=etractDstcd]")).setData(json.exrClassTypeList).setFormat(codeName3OptionFormat).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=msgDstcd]")).setData(json.msgTypeList).setFormat(codeName3OptionFormat).rendering();
				
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
				eaiSvcName : key,
				etractDstcd : key2
				
			},
			success : function(json) {
				var data = json.detailList;
				var ref  = json.refList;
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					if ($(tag+"[name="+name+"]").length == 1){
						if (!$.isNull(data[0][name.toUpperCase()])){
							$(tag+"[name="+name+"]").val(data[0][name.toUpperCase()]);
						}
					}
				});
				$("#ajaxForm input[type=text]").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					
					if ($(tag+"[name="+name+"]").length > 1){
						$(tag+"[name="+name+"]").each(function(index){
							if (data.length > index ){
								$(tag+"[name="+name+"]").eq(index).val(data[index][name.toUpperCase()]);
							}
						});
					}
					
				});
				if (!$.isNull(ref[0]) && !$.isNull(ref[0]["REFMSGIDNAME"])){
					$("input[name=loutName]").val(ref[0]["REFMSGIDNAME"]);
					$("input[name=loutDesc]").val(ref[0]["LOUTDESC"]);
				}
				$("input[name=loutName]").change();
				
				//셋팅후 disable해야됨
				$("select[name=etractDstcd] option").not(":selected").remove();
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.eaiSvcName}";
		var key2 = "${param.etractDstcd}";

		if (key != "" && key != "null") {
			$(".cls_btn_td, .cls_loutName_btn_td").remove();
			$(".cls_eaiSvcName_input_td, .cls_loutName_input_td").attr({"colspan":"2", "width":"100%"});
			$(".cls_eaiSvcName_table, .cls_loutName_table").attr("width", "100%");
			
			$("input[name=eaiSvcName],[name=loutName]").attr("readOnly", true);
			$("input[name=eaiSvcName],[name=loutName]").css({"background-color":"#E6E6E6", "width":"100%"});
			
			isDetail = true;
		}

		init(key,key2, detail);
		$('#tree').jqGrid({
		    datatype:'json',
		    loadui: "disable",
		    mtype: 'POST',
		    colNames: ["번호","항목명(영문)","항목설명","최대발생건수","참조정보","테이타타입","테이터길이","소수점길이","레이아웃명","path"],
		    colModel: [
		        {name: "LOUTITEMSERNO"          , width:"30"},
		        {name: "LOUTITEMNAME"           , width:"250"},
		        {name: "LOUTITEMDESC"                      },
		        {name: "LOUTITEMMAXOCCURNOITM"  },
		        {name: "LOUTITEMREFINFO2"       },
		        
		        {name: "LOUTITEMPTRNIDDESC" , width:"60"},
		        {name: "LOUTITEMLENCNT"         , width:"60"},
		        {name: "DECPTLENCNT"            , width:"60"},
		        
		        {name: "LOUTNAME"               , hidden:true},
		        {name: "LOUTITEMPATH"           , hidden:true}
		        
				],
		    treeGrid: true,
		    treeGridModel: "adjacency",
		    ExpandColumn: "LOUTITEMNAME",
		    height:"350",
		    rowNum: 10000,
		    autowidth : true,
		    treeIcons: {leaf:'ui-icon-document-b'},
		    jsonReader: {
		        repeatitems: false
		    },
		    loadComplete:function (d){
		    },	    
			onSelectRow : function(rowId) {
				var rowData = $(this).getRowData(rowId); 
				$("input[name=selName]").each(function(index){
					if ($("input[name=selName]").eq(index).is(":checked")){
						var value = rowData["LOUTITEMPATH"].replace(rowData["LOUTNAME"]+".","");
						$("input[name=bzwkFldName]").eq(index).val(value);
					}
				});
				
			
			}
		});			

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
		$("input[name=loutName]").change(function(){
			var postData = getSearchForJqgrid("cmd","DETAIL_LAYOUT"); //jqgrid에서는 object 로
			postData["loutName"] = $("input[name=loutName]").val();
			$("#tree").setGridParam({ url:url,postData: postData ,datatype:'json' }).trigger("reloadGrid");
		});
		
		$("input[name=selName]").click(function() {
			if ($(this).is(":checked")){
				$("input[name=selName]").removeAttr("checked");
				$(this).prop("checked",true);
			}else{
				$("input[name=selName]").removeAttr("checked");
			}
		});
		$("#btn_initialize").click(function(){
			$.ajax({  
				type : "POST",
				url:url,
				dataType:"json",
				data:{cmd: 'INITIALIZE',eaiSvcName : $("input[name=eaiSvcName]").val()},
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
				
				searchLayout();
		    });
			
			if( ret == null) return;
			
			key = ret['key'];
			
			$("input[name=eaiSvcName]").val(key);
			$("input[name=eaiSvcDesc]").val(ret['eaiSvcDesc']);
			
			searchLayout();
		});
		$("#btn_search_loutName").click(function(){
			var key = "";
			var args = new Object();
	    	args['loutName'] = $('input[name=loutName]').val();
		    var layoutUrl='<c:url value="/onl/admin/rule/layoutMan.view"/>';
		    layoutUrl = layoutUrl + "?cmd=POPUP";
		    var ret = showModal(layoutUrl,args,1020,708,function(arg){
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
				
				$("input[name=loutName]").val(key);
				$("input[name=loutDesc]").val(ret['loutDesc']);
				
				$("input[name=loutName]").change();
		    });
		});
		
		$("input[name=eaiSvcName],[name=loutName]").keydown(function(key){
			if (key.keyCode == 13){
				if($(this).attr("name") == "eaiSvcName") $("#btn_search").click();
				if($(this).attr("name") == "loutName") $("#btn_search_loutName").click();
			}
		});
		
		buttonControl(isDetail);
		titleControl(isDetail);
	});
	
	function searchLayout()
	{
		var postData = $('#ajaxForm').serializeArray();
		postData.push({
			name : "cmd",
			value : "LIST_REF"
		});
		$.ajax({
			type : "POST",
			url : url,
			data : postData,
			success : function(json) {
				var ref = json.refList;
				
				if (!$.isNull(ref[0]) && !$.isNull(ref[0]["REFMSGIDNAME"])){
					$("input[name=loutName]").val(ref[0]["REFMSGIDNAME"]);
					$("input[name=loutDesc]").val(ref[0]["LOUTDESC"]);
				}
				$("input[name=loutName]").change();
			},
			error : function(e) {
				alert(e.responseText);
			}
		});
	}
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
				<div class="title">필드 추출정보</div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:150px;">IF서비스코드</th>
							<td colspan="5">
								<input type="text" name="eaiSvcName" style="width:calc(100% - 70px);"> 
								<img id="btn_search" src="<c:url value="/img/btn_pop_search.png" />" class="btn_img" />
							</td>
						</tr>
						<tr>
							<th>IF 서비스설명</th>
							<td colspan="5">
								<input type="text" name="eaiSvcDesc" readOnly>
							</td>
						</tr>
						<tr>
							<th>추출구분</th>
							<td colspan="5">
								<div class="select-style">
								<select name="etractDstcd" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>메시지유형</th>
							<td colspan="5">
								<div class="select-style">
								<select name="msgDstcd" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th><label for="sub4_3_2_detail_1">업무필드명1</label> <input type="checkbox" name="selName" id="sub4_3_2_detail_1"/> </th>
							<td>
								<input type="text" name="bzwkFldName" />
							</td>
							<th style="width:80px;">시작값</th>
							<td style="width:80px;">
								<input type="text" name="msgFldStartSituVal" value=0 />
							</td>
							<th style="width:80px;">길이</th>
							<td  width="80px">
								<input type="text" name="msgFldLen" value=0  />
							</td>
						</tr>
						<tr>
							<th><label for="sub4_3_2_detail_2">업무필드명2</label> <input type="checkbox" name="selName" id="sub4_3_2_detail_2" /></th>
							<td>
								<input type="text" name="bzwkFldName" />
							</td>
							<th style="width:80px;">시작값</th>
							<td style="width:80px;">
								<input type="text" name="msgFldStartSituVal" value=0  />
							</td>
							<th style="width:80px;">길이</th>
							<td style="width:80px;">
								<input type="text" name="msgFldLen" value=0  />
							</td>
						</tr>
						<tr>
							<th><label for="sub4_3_2_detail_3">업무필드명3</label> <input type="checkbox" name="selName" id="sub4_3_2_detail_3" /></th>
							<td>
								<input type="text" name="bzwkFldName" />
							</td>
							<th style="width:80px;">시작값</th>
							<td style="width:80px;">
								<input type="text" name="msgFldStartSituVal" value=0  />
							</td>
							<th style="width:80px;">길이</th>
							<td style="width:80px;">
								<input type="text" name="msgFldLen" value=0  />
							</td>
						</tr>
					</table>
				</form>
				
				<div class="table_row_title">업무필드명에 체크를 한 후 하단의 그리드에서 항목을 클릭하면 경로명이 자동 입력 됩니다.</div>
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:150px;">레이아웃명</th>
						<td>
							<input type="text" name="loutName" style="width:calc(100% - 70px);"> 
							<img id="btn_search_loutName" src="<c:url value="/img/btn_pop_search.png" />" class="btn_img" />				
						</td>
					</tr>
					<tr>
						<th>레이아웃설명</th>
						<td colspan="5">
							<input type="text" name="loutDesc" readOnly>
						</td>
					</tr>
				</table>
				<!-- grid -->
				<table id="tree" ></table>				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>