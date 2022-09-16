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

	var url      = '<c:url value="/bat/transaction/message/messageMonitorMan.json" />';
	var url_view = '<c:url value="/bat/transaction/message/messageMonitorMan.view" />';

	function init( callback ) {
		$("input[name=searchStartYYYYMMDD],input[name=searchEndYYYYMMDD]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
		$("input[name=searchStartHHMM],input[name=searchEndHHMM]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM:ss",outputFormat : "HHMMss"  });
	
		var searchStartYYYYMMDD = "${param.searchStartYYYYMMDD}";
	    var searchEndYYYYMMDD   = "${param.searchEndYYYYMMDD}";
	    var searchStartHHMM     = "${param.searchStartHHMM}";
	    var searchEndHHMM       = "${param.searchEndHHMM}";
        
	    if ( searchStartYYYYMMDD == null || searchStartYYYYMMDD == ''){
	    	$("input[name=searchStartYYYYMMDD]").val(getToday());
	    }
	    
	    if ( searchEndYYYYMMDD == null || searchEndYYYYMMDD == ''){
	    	$("input[name=searchEndYYYYMMDD]").val(getToday());
	    }
	    
	    if ( searchStartHHMM == null || searchStartHHMM == ''){
	    	$("input[name=searchStartHHMM]").val('000000');
	    }
	    
	    if ( searchEndHHMM == null || searchEndHHMM == ''){
	    	$("input[name=searchEndHHMM]").val('235959');
	    }
		
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
		var start = $("input[name=searchStartYYYYMMDD]").val().replace("-","")+$("input[name=searchStartHHMM]").val().replace(":","");
		var end = $("input[name=searchEndYYYYMMDD]").val().replace("-","")+$("input[name=searchEndHHMM]").val().replace(":","");
		$("input[name=searchStartTime]").val(start);
		$("input[name=searchEndTime]").val(end);
	
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
	}

$(document).ready(function() {	

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['UUID',
		          '업무그룹',
                  '인터페이스ID',
                  '인터페이스명',
                  '상태',
                  '배치유형',
                  '시작시간',
                  '종료시간',
                  '기동방법',
                  '대상건수',
                  '처리건수',
                  '파일크기',
                  '파일건수'
                  ],
		colModel:[
		        { name : 'BJOBDMNDMSGID'     , align : 'left'   , hidden:true },
				{ name : 'WORKGRPCD'  , align:'center' ,width:40   },
				{ name : 'INTFID'     , align:'center' ,width:60   },
				{ name : 'INTFNAME'   , align:'left'    },
				{ name : 'ERRYN'  , align:'center' ,width:40  ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '<span style="color:red">에러</span>';
                                 } else if ( cellvalue == '2' ) {
				                 	return '중지';
                                 } else if ( cellvalue == 'C' ) {
				                 	return '<span style="color:blue">전송성공</span>';
                                 } else if ( cellvalue == 'N' ) {
				                 	return '<span style="color:green">전송중</span>';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				
				},
				{ name : 'BATCHTYPE'  , align:'center' ,width:50  ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == 'DD' ) {
				                 	return 'DB2DB';
                                 } else if ( cellvalue == 'DF' ) {
				                 	return 'DB2FILE';
                                 } else if ( cellvalue == 'FD' ) {
				                 	return 'FILE2DB';
                                 } else if ( cellvalue == 'FF' ) {
				                 	return 'FILE2FILE';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				
				},
				{ name : 'SNDSTARTDATE'  , align:'center' ,width:'80' , formatter: timeStampFormat },
				{ name : 'INTFIDENDDATE' , align:'center' ,width:'80' , formatter: timeStampFormat },
				{ name : 'SCHEKIND'       , align:'center',width:40 ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == 'T' ) {
				                 	return '타이머';
                                 } else if ( cellvalue == 'F' ) {
				                 	return '폴링';
                                 } else if ( cellvalue == 'E' ) {
				                 	return '이벤트호출';
                                 } else if ( cellvalue == 'U' ) {
				                 	return '화면조작';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				},
				{ name : 'SNDLINECNT'         , align:'right', width:50 ,formatter:'integer'},
				{ name : 'RCVLINECNT'         , align:'right', width:50 ,formatter:'integer'},
				{ name : 'FILETRSMTSIZECTNT'  , align:'right', width:50 ,formatter:function(cellVal, options, rowObject){
																						return cellVal == "" || cellVal == null ? "0" : cellVal;
																					}},
				{ name : 'CHECKROWCNT'        , align:'right', width:50 ,formatter:'integer'}
				],
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
		gridview: true,
		rowList : eval('[${rmsDefaultRowList}]'),
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var bjobDmndMsgID = rowData['BJOBDMNDMSGID'];
            var url2 = url_view;
            url2 = url2 + '?cmd=DETAIL';
            url2 = url2 + '&page='+$(this).getGridParam("page");
            url2 = url2 + '&returnUrl='+getReturnUrl();
            url2 = url2 + '&menuId='+'${param.menuId}';
			//검색값
            url2 = url2 + '&'+getSearchUrl();
            //key값
            url2 = url2 + '&bjobDmndMsgID='+bjobDmndMsgID;
            goNav(url2);
        }
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		var start = $("input[name=searchStartYYYYMMDD]").val().replace("-","")+$("input[name=searchStartHHMM]").val().replace(":","");
		var end = $("input[name=searchEndYYYYMMDD]").val().replace("-","")+$("input[name=searchEndHHMM]").val().replace(":","");
		$("input[name=searchStartTime]").val(start);
		$("input[name=searchEndTime]").val(end);
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />					
				</div>
				<div class="title">메시지별 모니터링</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:120px;">업무구분명</th>
							<td>
								<div style="position: relative; width: 100%;">
										<select name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
										</select>	
								</div>
							</td>
							<th style="width:120px;">배치거래유형</th>
							<td>
								<div class="select-style">
									<select name="searchBatchType" value="${param.searchBatchType}">
										<option value="">전체</option>
										<option value="FF">FILE2FILE</option>
										<option value="DF">DB2FILE</option>
										<option value="DD">DB2DB</option>
										<option value="FD">FILE2DB</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
							<th style="width:120px;">상태</th>
							<td>
								<div class="select-style">
									<select name="searchErrorVal" value="${param.searchErrorVal}">
										<option value="">전체</option>
										<option value="1">에러</option>
										<option value="2">중지</option>
										<option value="C">정상</option>
										<option value="N">전송중</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th style="width:120px;">인터페이스(ID,명)</th>
							<td><input type="text" name="searchInterfaceNm" value="${param.searchInterfaceNm}"></td>
							<th style="width:120px;">거래기간</th>
							<td colspan="3">
								<input type="text" name="searchStartYYYYMMDD" maxlength="10" value="${param.searchStartYYYYMMDD}" size="10" style="width:100px;">
								<input type="text" name="searchStartHHMM" maxlength="8" value="${param.searchStartHHMM}" size="8" style="width:100px;"> ~
								<input type="text" name="searchEndYYYYMMDD" maxlength="10" value="${param.searchEndYYYYMMDD}" size="10" style="width:100px;">
								<input type="text" name="searchEndHHMM" maxlength="8" value="${param.searchEndHHMM}" size="8" style="width:100px;">
								<input type="hidden" name="searchStartTime" value="20170125000000" style="width:100px;">
								<input type="hidden" name="searchEndTime" value="20170125235959" style="width:100px;">
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