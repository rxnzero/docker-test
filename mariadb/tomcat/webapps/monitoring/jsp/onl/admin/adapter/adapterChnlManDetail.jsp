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
	var url = '<c:url value="/onl/admin/adapter/adapterChnlMan.json" />';
	var url_view = '<c:url value="/onl/admin/adapter/adapterChnlMan.view" />';

	var selectName = "EAIBZWKDSTCD"; // selectBox Name

	var isDetail = false;
	function isValid() {
		if ($('input[name=adptrBzwkGroupName]').val() == "") {
			alert("어댑터 그룹명을 입력하여 주십시요.");
			return false;
		}
		if ($('select[name=sndrcvLnkDvcd]').val() == "") {
			alert("어댑터 유형을 선택하여 주십시요.");
			return false;
		}
		if ($('input[name=otsdChnlDvcd]').val() == "") {
			alert("어댑터 채널구분코드를 입력하여 주십시요.");
			return false;
		}
		return true;
	}

	function init(key, callback) {
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'LIST_INIT_COMBO'
			},
			success : function(json) {
				if (typeof callback === 'function') {
					callback(key);
				}

			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	function detail(key) {
		if (!isDetail)
			return;

		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				adptrBzwkGroupName : key
			},
			success : function(json) {
				var detail = json.detail;

				//adapterGroup
				$("input[name=ADPTRBZWKGROUPNAME]").attr('readonly', true);

				$("#detail input,#detail select").each(function() {
					var name = $(this).attr('name').toUpperCase();
					$(this).val(detail[name]);
				});
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}

	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();

		var key = "${param.adptrBzwkGroupName}";
		if (key != "" && key != "null") {
			isDetail = true;
		}
		detail(key);

		$("#btn_modify").click(function() {
			if (!isValid())
				return;

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
					alert(args.result);
					goNav(returnUrl);//LIST로 이동
				},
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
			
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
					alert(args.result);
					goNav(returnUrl);//LIST로 이동

				},
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
			}
			});
		});
		$("#btn_initialize").click(function() {
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "cmd",
				value : "RELOAD"
			});
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("RELOAD 되었습니다.");
					//goNav(returnUrl);//LIST로 이동

				},
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
			}
			});
		});		
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST로 이동
		});
		$("#btn_search").click(function() {
			var args = new Object();
			var key = $("input[name=adptrBzwkGroupName]").val();
			var url1 = url_view;
			url1 += "?cmd=POPUP";
		    url1 += "?adptrBzwkGroupName="+key;
		    var ret = showModal(url1,args,1200,800, function(arg){
		    	var args = null;
		        if(arg == null || arg == undefined ) {//chrome
		            args = this.dialogArguments;
		            args.returnValue = this.returnValue;
		        } else {//ie
		            args = arg;
		        }
		        
		        if( !args || !args.returnValue ) return;
		        
		        var ret = args.returnValue;
		        
		        if( ret == null) return;	
				var retVal = ret['key'];	
				if(retVal == null || retVal=="") return; 
				
				$("input[name=adptrBzwkGroupName]").val(retVal);
				
		    });
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
				<div class="title">어댑터</div>						
				
				<form id="ajaxForm">
					<table id="detail" class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:180px;">어댑터 그룹명</th>
							<td>
								<input type="text" name="adptrBzwkGroupName" style="width:calc(100% - 70px);" /> 
								<img id="btn_search" src="<c:url value="/img/btn_pop_search.png"/>" level="W" status="NEW" class="btn_img" />
							</td>
						</tr>
						<tr>
							<th>서비스타입</th>
							<td>
								<div class="select-style">
								<select name="serviceTypeName" ><option value="FEP">FEP</option><option value="EAI">EAI</option></select>
								</div>
							</td>
						</tr>
						<tr>
							<th>채널구분코드</th>
							<td><input type="text"  name="otsdChnlDvcd" /></td>
						</tr>
						<tr>
							<th>기관코드</th>
							<td><input type="text" name="otsdChnlInstCd" /></td>
						</tr>
						<tr>
							<th>업체코드</th>
							<td><input type="text" name="osdchCoId"/></td>
						</tr>
						<tr>
							<th>송수신구분</th>
							<td>
								<div class="select-style">
								<select name="sndrcvLnkDvcd">
									<option value="2">IN</option>
									<option value="1">OU</option>
									<option value="3">IO</option>
								</select>	
								</div>
							</td>
						</tr>
					</table>
				</form>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

