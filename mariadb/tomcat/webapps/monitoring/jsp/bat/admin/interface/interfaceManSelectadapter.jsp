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

	var url      = '<c:url value="/bat/admin/interface/interfaceMan.json" />';
	var url_view = '<c:url value="/bat/admin/interface/interfaceMan.view" />';
	var workGrpCd= window.dialogArguments["workGrpCd"];
	var adptrKind= window.dialogArguments["adptrKind"];
	//alert( 'adptrKind-->' + adptrKind);

	function init( callback ) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
				$("select[name=searchEaiBzwkDstcd]").val(workGrpCd);
				$("input[name=searchAdptrKind]").val(adptrKind);
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
		var postData = getSearchForJqgrid("cmd","LIST_ADAPTER"); //jqgrid에서는 object 로
		$("#grid").setGridParam({ url:url, postData: postData }).trigger("reloadGrid");
	}

$(document).ready(function() {	

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['업무그룹명',
	              '어댑터코드',
	              'Seq',
	              '인터페이스ID',
	              '어댑터명',
	              '어댑터설명',
	              '유형',
	              '구분'
	    ],
		colModel:[
				{ name : 'BZWKDSTICNAME'   , align:'left'},
				{ name : 'ADPTRCD' , align:'left'  },
				{ name : 'ADPTRCDSEQ' , align:'left'  },
				{ name : 'INTFID' , align:'left'  },
				{ name : 'SQLNAME' , align:'left'  },
				{ name : 'SQLNAMEDESC' , align:'left'  },
				{ name : 'ADPTRKIND' , align:'left' ,
							formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return 'DB';
                                 } else if ( cellvalue == '2' ) {
				                 	return 'FILE';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				 },
				{ name : 'SNDRCVKIND' , align:'left' ,
											formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return 'DB';
                                 } else if ( cellvalue == '2' ) {
				                 	return 'FILE';
                                 } else {
                                  	return cellvalue;
                                 } }
				 }
		],
                  
        jsonReader: {
            repeatitems:false
        },	          
		pager : $('#pager'),
		
		rowNum : '${rmsDefaultRowNum}',
	    autoheight: true,
	    height: $("#container").height(),
		autowidth: true,
		viewrecords: true,
		rowList : eval('[${rmsDefaultRowList}]'),
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId);
			var rtn = new Array(); 
			rtn.push(rowData['ADPTRCD']); 
			rtn.push(rowData['ADPTRCDSEQ']);
			window.returnValue = rtn;
		    window.close();
        }		
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		detail();
		//var postData = getSearchForJqgrid("cmd","LIST_ADAPTER"); //jqgrid에서는 object 로 
		//$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
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
			<div class="content_middle">
				<div class="search_wrap">
					<img id="btn_search" src="<c:url value="/img/btn_search.png"/>" level="R"/>
				</div>
				<div class="title">어댑터 목록 조회</div>
				<div class="table_cmt">검색된 어댑터를 확인하고 더블클릭 하세요.</div>	
				<table class="search_condition" cellspacing="0">
					<tr>
						<th style="width:20%;">업무구분명</th>
						<td style="width:30%;">
							<div class="select-style">
								<select name="searchEaiBzwkDstcd" style="width:100%"></select>
							</div>	
						</td>
						<th style="width:20%;">어댑터명</th>
						<td>
							<input type="text" name="searchAdptrName" value="${param.searchAdptrName}">
							<input type="hidden" name="searchAdptrKind" >
							<input type="hidden" name="searchSndRcvKind" value="1" >							
						</td>
					</tr>
				</table>				
				<!-- grid -->
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>