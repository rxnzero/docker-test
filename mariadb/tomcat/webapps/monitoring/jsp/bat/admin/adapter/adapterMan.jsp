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

var url      = '<c:url value="/bat/admin/adapter/adapterMan.json" />';
var url_view = '<c:url value="/bat/admin/adapter/adapterMan.view" />';

	function init( callback ) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
				//$("select[name=searchEaiBzwkDstcd]").searchable();
				setSearchable('searchEaiBzwkDstcd');
				putSelectFromParam();
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
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
	}

$(document).ready(function() {	

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['업무그룹명',
                  '어댑터코드',
                  '어댑터명',
                  '어댑터설명',
                  '유형',
                  //'JNDI',
                  '송수신구분'
                  ],
		colModel:[
				{ name : 'BZWKDSTICNAME'  , align:'left'   },
				{ name : 'ADPTRCD'        , align:'left'   },
				{ name : 'ADPTRBZWKNAME'  , align:'left'   },
				{ name : 'ADPTRDESC'      , align:'left'   },
				{ name : 'ADPTRKINDSTR'   , align:'center' },
				//{ name : 'JNDIDATASOURCE' , align:'center' },
				{ name : 'SNDRCVKINDSTR'  , align:'center' }],
        jsonReader: {
             repeatitems:false
        },	          
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : '${rmsDefaultRowNum}',
	    autoheight: true,
	    height: $("#container").height(),
		autowidth: true,
		viewrecords: true,
		rowList : eval('[${rmsDefaultRowList}]'),
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var adptrCd = rowData['ADPTRCD'];
            var url = '<c:url value="/bat/admin/adapter/adapterMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//검색값
            url = url + '&'+getSearchUrl();
            //key값
            url = url + '&adptrCd='+adptrCd;
            goNav(url);
        }		
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bat/admin/adapter/adapterMan.view"/>';
		url = url + '?cmd=DETAIL';
		url = url + '&page='+$("#grid").getGridParam("page");
		url = url + '&returnUrl='+getReturnUrl();
        url = url + '&menuId='+'${param.menuId}';
		//검색값
        url = url + '&'+getSearchUrl();

        goNav(url);
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
	buttonControl();
	init( detail);

	
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png" />" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />				
				</div>
				<div class="title">어댑터 관리<span class="tooltip">EAI 배치 시스템에서 사용하는 어댑터 목록</span></div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:100px;">업무구분명</th>
							<td>
								
								<select name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
								</select>

							</td>
							<th style="width:100px;">유형</th>
							<td>
								<div class="select-style">
									<select name="searchAdptrKind" value="${param.searchAdptrKind}">
										<option value="">전체</option>
										<option value="1">DB</option>
										<option value="2">FILE</option>									
									</select>
								</div><!-- end.select-style -->	
							</td>
							<th style="width:100px;">구분</th>
							<td>
								<div class="select-style">
									<select name="searchSndRcvKind" value="${param.searchSndRcvKind}">
										<option value="">전체</option>
										<option value="1">송신측</option>
										<option value="2">수신측</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
							<th style="width:100px;">인터페이스ID</th>
							<td>
								<input type="text" name="searchIntfId" value="${param.searchIntfId}">
							</td>
						</tr>
						<tr>
							<th style="width:100px;">어댑터(명/코드)</th>
							<td>
								<input type="text" name="searchAdptrBzwkName" value="${param.searchAdptrBzwkName}">
							</td>
							<th style="width:100px;">FTP IP</th>
							<td>
								<input type="text" name="searchFtpIp" value="${param.searchFtpIp}">
							</td>
							<th style="width:100px;">FTP ID</th>
							<td>
								<input type="text" name="searchFtpId" value="${param.searchFtpId}">
							</td>
							<th style="width:100px;">JNDI</th>
							<td>
								<input type="text" name="searchJndi" value="${param.searchJndi}">
							</td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>
</html>