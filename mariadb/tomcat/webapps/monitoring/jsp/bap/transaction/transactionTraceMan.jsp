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

	var url      = '<c:url value="/bap/transaction/transactionTraceMan.json" />';
	var url_view = '<c:url value="/bap/transaction/transactionTraceMan.view" />';

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
				new makeOptions("CODE","NAME").setObj($("select[name=searchBjobBzwkDstcd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.bjobBzwkDstcd).rendering();
				$("select[name=searchEaiBzwkDstcd]").searchable();
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
	
	function resend(bjobDmndMsgID, bjobDmndSubMsgID, fileTrsmtLogID, sndRecvFileName){
	    
	    if ( confirm( "해당 건을 재 전송 하시겠습니까?" ) != true ){
    	    return;
    	}
    	
    	var postData = new Array();
    	postData.push({ name: "cmd"       , value:"TRANSACTION_RESEND"});
    	postData.push({ name: "bjobDmndMsgID"    , value:bjobDmndMsgID});
    	postData.push({ name: "bjobDmndSubMsgID" , value:bjobDmndSubMsgID});
    	postData.push({ name: "fileTrsmtLogID"   , value:fileTrsmtLogID});
    	postData.push({ name: "sndRecvFileName"  , value:sndRecvFileName});
    	$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				debugger;
				$("#grid").trigger("reloadGrid");
				alert( args.result );
			},
			error:function(e){
				alert(e.responseText);
			}
		});
    }

$(document).ready(function() {	
	init( detail);
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['UUID',
		          'SUBUUID',
		          '전송로그ID',
		          '프레임웍구분',
                  '업무구분',
                  '기관명',
                  '파일명',
                  '상태',
                  '시작시간',
                  '종료시간',
                  '송수신구분',
                  '파일크기',
                  '재전송',
                  '장애내용'
                  ],
		colModel:[
		        { name : 'BJOBDMNDMSGID'         , align : 'left'   , hidden:true },
		        { name : 'BJOBDMNDSUBMSGID'      , align : 'left'   , hidden:true },
		        { name : 'FILETRSMTLOGID'        , align : 'left'   , hidden:true },
				{ name : 'FRAMEWORKGB'           , align : 'center' , width:40   },
				{ name : 'BJOBBZWKNAME'          , align : 'left'   , width:60   },
				{ name : 'OSIDINSTINAME'         , align : 'left'   , width:60   },
				{ name : 'SNDRCVFILENAME'        , align : 'left'   , width:60   },
				{ name : 'THISSTGEPRCSSRSULTCD'  , align : 'center' , width:40  ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == 'E' ) {
				                 	return '<span style="color:red">에러</span>';
                                 } else if ( cellvalue == 'T' ) {
				                 	return '<span style="color:blue">전송성공</span>';
                                 } else if ( cellvalue == 'S' ) {
				                 	return '<span style="color:green">전송중</span>';
                                 } else {
                                  	return '';
                                 }
                              }
				
				},
				{ name : 'FILETRSMTSTARTHMS'  , align:'center' , width:'80' , formatter: timeStampFormat },
				{ name : 'FILETRSMTENDHMS'    , align:'center' , width:'80' , formatter: timeStampFormat },
				{ name : 'SNDRCV'             , align:'center' , width:40   ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == 'S' ) {
				                 	return '송신';
                                 } else if ( cellvalue == 'R' ) {
				                 	return '수신';
                                 } else {
                                  	return '';
                                 }
                              }
				},
				{ name : 'SNDRCVFILESIZE'          , align:'right', width:50 },
				{ name : 'RESEND'          , align:'center', width:50 },
				{ name : 'EAIOBSTCLOCCURCAUSCTNT'  , align:'left' }
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
            var bjobDmndMsgID = rowData['BJOBDMNDMSGID'];
            var bjobDmndSubMsgID = rowData['BJOBDMNDSUBMSGID'];
            //alert('bjobDmndMsgID-->' + bjobDmndMsgID);
            if ( bjobDmndMsgID.trim() == '' ) return;
            var url2 = '<c:url value="/bap/transaction/transactionStatusMan.view" />';
            url2 = url2 + '?cmd=DETAIL';
            url2 = url2 + '&page='+$(this).getGridParam("page");
            url2 = url2 + '&returnUrl='+getReturnUrl();
            url2 = url2 + '&menuId='+'${param.menuId}';
			//검색값
            url2 = url2 + '&'+getSearchUrl();
            //key값
            url2 = url2 + '&bjobDmndMsgID='+bjobDmndMsgID;
            url2 = url2 + "&bjobDmndSubMsgID=" + bjobDmndSubMsgID;
            goNav(url2);
        },
		loadComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},	        
        gridComplete: function(){
        	debugger;
        	var ids = $(this).getDataIDs();
        	for(var i=0;i<ids.length;i++){
        		var cl = ids[i];
        		var rowData = $(this).getRowData(cl); 
        		var bjobDmndMsgID = rowData['BJOBDMNDMSGID'];
        		var bjobDmndSubMsgID = rowData['BJOBDMNDSUBMSGID'];
        		var fileTrsmtLogID = rowData['FILETRSMTLOGID'];
        		var sndRecvFileName = rowData['SNDRCVFILENAME'];
        		var sndRcv = rowData['SNDRCV'];
        		if ( sndRcv == '송신' || fileTrsmtLogID.trim() != '' ){
        			var be = "<input style='height:22px;width:60px;' type='button' value='재전송' onclick=\"resend('"+bjobDmndMsgID+"','"+bjobDmndSubMsgID+"','"+fileTrsmtLogID+"','"+sndRecvFileName+"');\" />";
        			$(this).setRowData(ids[i],{RESEND:be});
        		}
        	} 
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
				<div class="title">거래 추적</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:100px;">프레임웍구분</th>
							<td>
								<div class="select-style">	
									<select name="searchFrameWorkGb" value="${param.searchFrameWorkGb}">
										<option value="2">전체</option>
										<option value="0">내부</option>
										<option value="1">대외</option>
									</select>
								</div><!-- end.select-style -->									
							</td>	
							<th style="width:100px;">업무구분명</th>
							<td>
								<div class="select-style">
									<select name="searchBjobBzwkDstcd" value="${param.searchBjobBzwkDstcd}">
									</select>
								</div>
							</td>
							<th style="width:100px;">송수신구분</th>
							<td>
								<div class="select-style">
									<select name="searchSndRcv" value="${param.searchSndRcv}">
										<option value="A">전체</option>
										<option value="S">송신</option>
										<option value="R">수신</option>
									</select>
								</div>
							</td>
							<th style="width:100px;">상태</th>
							<td>
								<div class="select-style">
									<select name="searchThisStgePrcssRsultCd" value="${param.searchThisStgePrcssRsultCd}">
										<option value="">전체</option>
										<option value="T">정상</option>
										<option value="E">에러</option>
										<option value="S">전송중</option>
									</select>
								</div>
							</td>							
						</tr>						
						<tr>							
							<th style="width:100px;">파일명</th>
							<td>
								<input type="text" name="searchSndrcvFileName" value="${param.searchSndrcvFileName}">
							</td>
							<th style="width:100px;">기관명</th>
							<td>
								<input type="text" name="searchOsidInstiName" value="${param.searchOsidInstiName}">
							</td>
							<th style="width:100px;">거래기간</th>
							<td colspan="3">
								<input type="text" name="searchStartYYYYMMDD" maxlength="10" value="" size="10" style="width:80px;">
								<input type="text" name="searchStartHHMM" maxlength="8" value="" size="8" style="width:80px;"> ~
								<input type="text" name="searchEndYYYYMMDD" maxlength="10" value="" size="10" style="width:80px;">
								<input type="text" name="searchEndHHMM" maxlength="8" value="" size="8" style="width:80px;">
								<input type="hidden" name="searchStartTime" value="20170201000000">
								<input type="hidden" name="searchEndTime" value="20170201235959">
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