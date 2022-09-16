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
var url      ='<c:url value="/onl/admin/adapter/adapterChangeMan.json" />';
var url_view ='<c:url value="/onl/admin/adapter/adapterChangeMan.view" />';

function init(callback){
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=eaiBzwkDstcd]")).setData(json.bizList).setNoValueInclude(true).setFormat(codeName3OptionFormat).rendering();
				//$("select[name=eaiBzwkDstcd]").searchable();
				setSearchable('eaiBzwkDstcd');
				if (typeof callback === 'function') {
					callback();
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
}
function detail(){
	
}
$(document).ready(function() {	
	init( detail);
	$("#btn_sync").click(function(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd : 'UPDATE_CHANGE',eaiBzwkDstcd : $('select[name=eaiBzwkDstcd]').val(),channel :$('select[name=channel]').val(),simYn :$("input[name=simYn]:checked").val()  },
			success:function(json){
				alert(json.message);
			},
			error:function(e){
				alert(e.responseText);
			}
		}); 		
	
	});
	$("select[name=eaiBzwkDstcd]").change(function(){
		//sub combo
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd : 'LIST_DYNAMIC_COMBO',eaiBzwkDstcd : $('select[name=eaiBzwkDstcd]').val()},
			success:function(json){
				$("select[name=channel] option").remove();
				new makeOptions("CHANNEL","CHANNEL").setObj($("select[name=channel]")).setData(json.list).rendering();
			},
			error:function(e){
				alert(e.responseText);
			}
		}); 		
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
					<img src="<c:url value="/img/btn_sync.png"/>" alt="" id="btn_sync" level="R" />
				</div>
				<div class="title">어댑터 전환 관리</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">업무구분명</th>
							<td>
								<div style="position: relative; width: 100%;">
									
										<select name="eaiBzwkDstcd" value="">
										</select>
																		
								</div>
							</td>
						</tr>
						<tr>
							<th style="width:180px;">채널구분명</th>
							<td>
								<div class="select-style">
									<select name="channel" value="${param.channel}">
									</select>
								</div>	
							</td>
						</tr>
						<tr>
							<th style="width:180px;">모드선택</th>
							<td>
								<input type="radio" value="Y" name="simYn" id="sub2_3_4_1"><label for="sub2_3_4_1">시뮬레이터</label>
								<input type="radio" value="N" name="simYn" id="sub2_3_4_2"><label for="sub2_3_4_2">테스트</label>
							</td>
						</tr>
					</tbody>
				</table>
				
				<!-- <table id="grid" ></table>
				<div id="pager"></div> -->
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

