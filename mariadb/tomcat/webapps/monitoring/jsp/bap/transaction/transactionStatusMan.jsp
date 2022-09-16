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

	function statusFormat (cellvalue){
		if ( cellvalue == 'T' ){
			return '정상';
		}else if ( cellvalue == 'Q' ) {
			return '수행대기';
		}else if ( cellvalue == 'C' ) {
			return '사용자중지';
		}else if ( cellvalue == 'N' ) {
			return '파일없음';
		}else if ( cellvalue == 'S' ) {
			return '<span style="color:blue">진행중</span>';
		}else if ( cellvalue == 'E' ) {
			return '<span style="color:red">비정상종료</span>';
		}
		return "";
	}

	function sendRecvFormat (cellvalue){
		if ( cellvalue == 'S' ){
			return '송신';
		}else if ( cellvalue == 'R' ){
			return '수신';
		}
		return cellvalue;
	}
	
	function init(url, callback) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=searchBjobBzwkDstcd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.bjobBzwkDstcd).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=searchGroupCoCd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.groupCoCd).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=searchOsidInstiDstcd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.osidInstiDstcd).rendering();
				putSelectFromParam();
				if (typeof callback === 'function') {
					callback(url);
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
		
	}
	function detail(url){
        var activeTab = $("ul.tabs li.active").attr("rel");
		var start = $("input[name=searchStartYYYYMMDD]").val().replace("-","")+$("input[name=searchStartHHMM]").val().replace(":","");
		var end = $("input[name=searchEndYYYYMMDD]").val().replace("-","")+$("input[name=searchEndHHMM]").val().replace(":","");
		
		$("input[name=searchStartTime]").val(start);
		$("input[name=searchEndTime]").val(end);
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
		postData["activeTab"] = activeTab;
		var searchGb = $("select[name=searchGb]").val();
		var searchText = $("input[name=searchText]").val();
		if ( searchGb == 'FILE'){
			postData["searchSndrcvFileName"] = searchText;
		}else if ( searchGb == 'UUID'){
			postData["searchBjobDmndMsgID"] = searchText;
		}else if ( searchGb == 'SUBUUID'){
			postData["searchBbjobDmndSubMsgID"] = searchText;
		}
        if ( activeTab == 'tabE'){
			$("#gridE").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
        }else if ( activeTab == 'tabF'){
			$("#gridF").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
        }else if ( activeTab == 'tabQ'){
			$("#gridQ").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
        }else if ( activeTab == 'tabS'){
			$("#gridS").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
        }else if ( activeTab == 'tabA'){
			$("#gridA").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
        }
	}
	
	
$(document).ready(function() {	
	$("input[name=searchStartYYYYMMDD],input[name=searchEndYYYYMMDD]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
	$("input[name=searchStartHHMM],input[name=searchEndHHMM]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM:ss",outputFormat : "HHMMss"  });

	var url = '<c:url value="/bap/transaction/transactionStatusMan.json" />';
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
	
	init(url, detail);
	
	$("select[name=searchBjobBzwkDstcd]").change(function(){
		$.ajax({  
		    type : "POST",
		    url:url,
		    dataType:"json",
		    data:{ cmd: 'LIST_ORGN_COMBO',
		           bjobBzwkDstcd : $(this).val()
		         },
		    success:function(json){
		    	$("select[name=searchOsidInstiDstcd] option").remove();
		    	new makeOptions("CODE","NAME").setObj($("select[name=searchOsidInstiDstcd]")).setNoValueInclude(true).setNoValue('','전체').setData(json.osidInstiDstcd).rendering();
		    }
		});
	});
	$(".tab_content").hide();
    $(".tab_content:last").show();
	
 	$("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("active");
        $(this).addClass("active");
        $(".tab_content").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).show();
        detail(url);
    });	 
	
	$('#gridE').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 'UUID',
		             'SUBUUID',
		             '업무명',
		             '대외기관',
		             '그룹사구분',
		             '메시지구분코드',
		             '작업유형',
		             '파일명',
		             '자료건수',
		             '파일크기',
		             '전송상태',
		             '시작예정',
		             '종료예정',
		             '거래시작시각',
		             '거래종료시각',
		             '지연시간'
		              ],
		colModel : [ { name : 'BJOBDMNDMSGID'     , align : 'left'   , hidden:true },
		             { name : 'BJOBDMNDSUBMSGID'  , align : 'left'   , hidden:true },
		             { name : 'BJOBBZWKNAME'      , align : 'left'   , width:'200' },
		             { name : 'OSIDINSTINAME'     , align : 'left'   , width:'200' },
		             { name : 'GROUPCOCD'         , align : 'left'   , width:'146' , hidden:true },
		             { name : 'BJOBTRANDSTCDNAME' , align : 'left'   , width:'100' },
		             { name : 'SENDRECVYN'        , align : 'center' , width:'70' , formatter: sendRecvFormat},
		             { name : 'SNDRCVFILENAME'    , align : 'left'   , width:'200' },
		             { name : 'SNDRCVRECCNT'      , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'SNDRCVFILESIZE'    , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'TRANPRCSSDSTCD'    , align : 'center' , width:'70' , formatter: statusFormat },
		             { name : 'SNDRCVSTARTHMS'    , align : 'center' , width:'70' , formatter: timeFormat },
		             { name : 'SNDRCVENDHMS'      , align : 'center' , width:'70' , formatter: timeFormat },
		             { name : 'TRANSTARTHMS'      , align : 'center' , width:'159' , formatter: timeStampFormat },
		             { name : 'TRANENDHMS'        , align : 'center' , width:'159' , formatter: timeStampFormat },
		             { name : 'DELAYTIME'         , align : 'center' , width:'70' , formatter: timeFormat }
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		//autoheight : true,
		height : 600, //$("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
		    var args = new Object();
		    args['eaiBzwkDstcd']  = rowData['EAIBZWKDSTCD'];
		    args['msgDpstYMS']    = rowData['MSGDPSTYMS'];
		    args['logPrcssSerno'] = rowData['LOGPRCSSSERNO'];
		    args['eaiSvcSerno']   = rowData['EAISVCSERNO'];
		    
		    /* var url2 = '<c:url value="/onl/transaction/tracking/trackingMan.view"/>';
		    url2 = url2 + "?cmd=DETAIL";
		    showModal(url2,args,810,1218); */
		    
		    var url2 = '<c:url value="/bap/transaction/transactionStatusMan.view" />';
		    url2 = url2 + "?cmd=DETAIL";
            url2 = url2 + '&menuId='+'${param.menuId}';
	    	url2 = url2 + '&returnUrl='+getReturnUrl();
	    	url2 = url2 + '&' + getSearchUrl();
		    url2 = url2 + "&bjobDmndMsgID="    + rowData['BJOBDMNDMSGID'];
		    url2 = url2 + "&bjobDmndSubMsgID=" + rowData['BJOBDMNDSUBMSGID'];
		    goNav(url2);

		    //url2 = url2 + "&eaiBzwkDstcd="  +rowData['EAIBZWKDSTCD'];
		    //url2 = url2 + "&msgDpstYMS="    +rowData['MSGDPSTYMS'];
		    //url2 = url2 + "&logPrcssSerno=" +rowData['LOGPRCSSSERNO'];
		    //url2 = url2 + "&eaiSvcSerno="   +rowData['EAISVCSERNO'];
		    //goNav(url2);
		},
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},			
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    }	
	});

	$('#gridF').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 'UUID',
		             'SUBUUID',
		             '업무명',
		             '대외기관',
		             '그룹사구분',
		             '메시지구분코드',
		             '작업유형',
		             '전송상태',
		             '시작예정',
		             '종료예정'
		              ],
		colModel : [ { name : 'BJOBDMNDMSGID'     , align : 'left'   , hidden:true },
		             { name : 'BJOBDMNDSUBMSGID'  , align : 'left'   , hidden:true },
		             { name : 'BJOBBZWKNAME'      , align : 'left'   , width:'200' },
		             { name : 'OSIDINSTINAME'     , align : 'left'   , width:'200' },
		             { name : 'GROUPCOCD'         , align : 'left'   , width:'146' , hidden:true },
		             { name : 'BJOBTRANDSTCDNAME' , align : 'left'   , width:'100' },
		             { name : 'SENDRECVYN'        , align : 'center' , width:'70' , formatter: sendRecvFormat},
		             { name : 'TRANPRCSSDSTCD'    , align : 'center' , width:'70' , formatter: statusFormat },
		             { name : 'SNDRCVSTARTHMS'    , align : 'center' , width:'70' , formatter: timeFormat },
		             { name : 'SNDRCVENDHMS'      , align : 'center' , width:'70' , formatter: timeFormat }
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		//autoheight : true,
		height : 600, //$("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
		    var args = new Object();
		    args['eaiBzwkDstcd']  = rowData['EAIBZWKDSTCD'];
		    args['msgDpstYMS']    = rowData['MSGDPSTYMS'];
		    args['logPrcssSerno'] = rowData['LOGPRCSSSERNO'];
		    args['eaiSvcSerno']   = rowData['EAISVCSERNO'];
		    
		    /* var url2 = '<c:url value="/onl/transaction/tracking/trackingMan.view"/>';
		    url2 = url2 + "?cmd=DETAIL";
		    showModal(url2,args,810,1218); */
		    
		    var url2 = '<c:url value="/bap/transaction/transactionStatusMan.view" />';
		    url2 = url2 + "?cmd=DETAIL";
            url2 = url2 + '&menuId='+'${param.menuId}';
	    	url2 = url2 + '&returnUrl='+getReturnUrl();
	    	url2 = url2 + '&' + getSearchUrl();
		    url2 = url2 + "&bjobDmndMsgID="    + rowData['BJOBDMNDMSGID'];
		    url2 = url2 + "&bjobDmndSubMsgID=" + rowData['BJOBDMNDSUBMSGID'];
		    goNav(url2);

		    //url2 = url2 + "&eaiBzwkDstcd="  +rowData['EAIBZWKDSTCD'];
		    //url2 = url2 + "&msgDpstYMS="    +rowData['MSGDPSTYMS'];
		    //url2 = url2 + "&logPrcssSerno=" +rowData['LOGPRCSSSERNO'];
		    //url2 = url2 + "&eaiSvcSerno="   +rowData['EAISVCSERNO'];
		    //goNav(url2);
		},
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},			
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    }	
	});

	$('#gridQ').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 'UUID',
		             'SUBUUID',
		             '업무명',
		             '대외기관',
		             '메시지구분코드',
		             '작업유형',
		             '전송상태',
		             '시작예정',
		             '종료예정',
		             '메시지생성시각'
		              ],
		colModel : [ { name : 'BJOBDMNDMSGID'     , align : 'left'   , hidden:true },
		             { name : 'BJOBDMNDSUBMSGID'  , align : 'left'   , hidden:true },
		             { name : 'BJOBBZWKNAME'      , align : 'left'   , width:'200' },
		             { name : 'OSIDINSTINAME'     , align : 'left'   , width:'200' },
		             { name : 'BJOBTRANDSTCDNAME' , align : 'left'   , width:'100' },
		             { name : 'SENDRECVYN'        , align : 'center' , width:'70' , formatter: sendRecvFormat},
		             { name : 'TRANPRCSSDSTCD'    , align : 'center' , width:'70' , formatter: statusFormat },
		             { name : 'SNDRCVSTARTHMS'    , align : 'center' , width:'70', formatter: timeFormat},
		             { name : 'SNDRCVENDHMS'      , align : 'center' , width:'70', formatter: timeFormat},
		             { name : 'BJOBDMNDMSGCRETNHMS', align : 'center' , width:'159', formatter: timeStampFormat }
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		//autoheight : true,
		height : 600, //$("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
		    var args = new Object();
		    args['eaiBzwkDstcd']  = rowData['EAIBZWKDSTCD'];
		    args['msgDpstYMS']    = rowData['MSGDPSTYMS'];
		    args['logPrcssSerno'] = rowData['LOGPRCSSSERNO'];
		    args['eaiSvcSerno']   = rowData['EAISVCSERNO'];
		    
		    /* var url2 = '<c:url value="/onl/transaction/tracking/trackingMan.view"/>';
		    url2 = url2 + "?cmd=DETAIL";
		    showModal(url2,args,810,1218); */
		    
		    var url2 = '<c:url value="/bap/transaction/transactionStatusMan.view" />';
		    url2 = url2 + "?cmd=DETAIL";
            url2 = url2 + '&menuId='+'${param.menuId}';
	    	url2 = url2 + '&returnUrl='+getReturnUrl();
	    	url2 = url2 + '&' + getSearchUrl();
		    url2 = url2 + "&bjobDmndMsgID="    + rowData['BJOBDMNDMSGID'];
		    url2 = url2 + "&bjobDmndSubMsgID=" + rowData['BJOBDMNDSUBMSGID'];
		    goNav(url2);

		    //url2 = url2 + "&eaiBzwkDstcd="  +rowData['EAIBZWKDSTCD'];
		    //url2 = url2 + "&msgDpstYMS="    +rowData['MSGDPSTYMS'];
		    //url2 = url2 + "&logPrcssSerno=" +rowData['LOGPRCSSSERNO'];
		    //url2 = url2 + "&eaiSvcSerno="   +rowData['EAISVCSERNO'];
		    //goNav(url2);
		},
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},			
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    }	
		
	});
	
	$('#gridS').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 'UUID',
		             'SUBUUID',
		             '업무명',
		             '대외기관',
		             '메시지구분코드',
		             '작업유형',
		             '파일명',
		             '파일크기',
		             '진행율(%)',
		             '진행크기',
		             '전송상태',
		             '시작예정',
		             '종료예정',
		             '거래시작시각',
		             '거래종료시각'
		              ],
		colModel : [ { name : 'BJOBDMNDMSGID'     , align : 'left'   , hidden:true },
		             { name : 'BJOBDMNDSUBMSGID'  , align : 'left'   , hidden:true },
		             { name : 'BJOBBZWKNAME'      , align : 'left'   , width:'200' },
		             { name : 'OSIDINSTINAME'     , align : 'left'   , width:'200' },
		             { name : 'BJOBTRANDSTCDNAME' , align : 'left'   , width:'100' },
		             { name : 'SENDRECVYN'        , align : 'center' , width:'70' , formatter: sendRecvFormat},
		             { name : 'SNDRCVFILENAME'    , align : 'left'   , width:'200' },
		             { name : 'SNDRCVFILESIZE'    , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'RATE'              , align : 'right'  , width:'70'  },
		             { name : 'CURRENTFILESIZE'    , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'TRANPRCSSDSTCD'    , align : 'center' , width:'70' , formatter: statusFormat },
		             { name : 'SNDRCVSTARTHMS'    , align : 'center' , width:'70', formatter: timeFormat},
		             { name : 'SNDRCVENDHMS'      , align : 'center' , width:'70', formatter: timeFormat},
		             { name : 'TRANSTARTHMS'      , align : 'center' , width:'159', formatter: timeStampFormat },
		             { name : 'TRANENDHMS'        , align : 'center' , width:'159', formatter: timeStampFormat }
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		//autoheight : true,
		height : 600, //$("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
		    var args = new Object();
		    args['eaiBzwkDstcd']  = rowData['EAIBZWKDSTCD'];
		    args['msgDpstYMS']    = rowData['MSGDPSTYMS'];
		    args['logPrcssSerno'] = rowData['LOGPRCSSSERNO'];
		    args['eaiSvcSerno']   = rowData['EAISVCSERNO'];
		    
		    /* var url2 = '<c:url value="/onl/transaction/tracking/trackingMan.view"/>';
		    url2 = url2 + "?cmd=DETAIL";
		    showModal(url2,args,810,1218); */
		    var url2 = '<c:url value="/bap/transaction/transactionStatusMan.view" />';
		    url2 = url2 + "?cmd=DETAIL";
            url2 = url2 + '&menuId='+'${param.menuId}';
	    	url2 = url2 + '&returnUrl='+getReturnUrl();
	    	url2 = url2 + '&' + getSearchUrl();
		    url2 = url2 + "&bjobDmndMsgID="    + rowData['BJOBDMNDMSGID'];
		    url2 = url2 + "&bjobDmndSubMsgID=" + rowData['BJOBDMNDSUBMSGID'];
		    goNav(url2);

		    //url2 = url2 + "&eaiBzwkDstcd="  +rowData['EAIBZWKDSTCD'];
		    //url2 = url2 + "&msgDpstYMS="    +rowData['MSGDPSTYMS'];
		    //url2 = url2 + "&logPrcssSerno=" +rowData['LOGPRCSSSERNO'];
		    //url2 = url2 + "&eaiSvcSerno="   +rowData['EAISVCSERNO'];
		    //goNav(url2);
		},
		//그리드 헤더 화살표 삭제(정렬X)
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},			
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    }	
		
	});
	
	$('#gridA').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 'UUID',
		             'SUBUUID',
		             '업무명',
		             '대외기관',
		             '그룹사구분',
		             '스케쥴',
		             '메시지구분코드',
		             '작업유형',
		             '파일명',
		             '자료건수',
		             '파일크기',
		             '전송상태',
		             '시작예정',
		             '종료예정',
		             '거래시작시각',
		             '거래종료시각'
		              ],
		colModel : [ { name : 'BJOBDMNDMSGID'     , align : 'left'   , hidden:true },
		             { name : 'BJOBDMNDSUBMSGID'  , align : 'left'   , hidden:true },
		             { name : 'BJOBBZWKNAME'      , align : 'left'   , width:'200' },
		             { name : 'OSIDINSTINAME'     , align : 'left'   , width:'200' },
		             { name : 'GROUPCOCD'         , align : 'left'   , width:'146' , hidden:true },
		             { name : 'BJOBMSGSCHEID'     , align : 'left'   , width:'100' },
		             { name : 'BJOBTRANDSTCDNAME' , align : 'left'   , width:'100' },
		             { name : 'SENDRECVYN'        , align : 'center' , width:'70' , formatter: sendRecvFormat},
		             { name : 'SNDRCVFILENAME'    , align : 'left'   , width:'200' },
		             { name : 'SNDRCVRECCNT'      , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'SNDRCVFILESIZE'    , align : 'right'  , width:'70' , formatter: 'integer' },
		             { name : 'TRANPRCSSDSTCD'    , align : 'center' , width:'70' , formatter: statusFormat },
		             { name : 'SNDRCVSTARTHMS'    , align : 'center' , width:'70', formatter: timeFormat},
		             { name : 'SNDRCVENDHMS'      , align : 'center' , width:'70', formatter: timeFormat},
		             { name : 'TRANSTARTHMS'      , align : 'center' , width:'159', formatter: timeStampFormat },
		             { name : 'TRANENDHMS'        , align : 'center' , width:'159', formatter: timeStampFormat }
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		//autoheight : true,
		height : 600, //$("#container").height(),
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
		    var args = new Object();
		    args['bjobDmndMsgID']    = rowData['BJOBDMNDMSGID'];
		    args['bjobDmndSubMsgID'] = rowData['BJOBDMNDSUBMSGID'];
		    if ( args['bjobDmndMsgID'] == null || args['bjobDmndMsgID'] == ''  || args['bjobDmndSubMsgID'] == null || args['bjobDmndSubMsgID'] == ''){
		    	alert ('거래처리 로그가 없어 조회할 수 없습니다.');
		    	return;
		    }
		    
		    var url2 = '<c:url value="/bap/transaction/transactionStatusMan.view" />';
		    url2 = url2 + "?cmd=DETAIL";
            url2 = url2 + '&menuId='+'${param.menuId}';
	    	url2 = url2 + '&returnUrl='+getReturnUrl();
	    	url2 = url2 + '&' + getSearchUrl();
		    url2 = url2 + "&bjobDmndMsgID="    + rowData['BJOBDMNDMSGID'];
		    url2 = url2 + "&bjobDmndSubMsgID=" + rowData['BJOBDMNDSUBMSGID'];
		    goNav(url2);
		},
		//그리드 헤더 화살표 삭제(정렬X)
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},		
	    loadComplete:function (d){
	    	//$("#grid").tuiTableRowSpan("0");
	    }	
		
	});
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		detail();
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">일괄전송 현황 조회</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:100px;">업무구분명</th>
							<td style="width:200px;">
								<div class="select-style">	
									<select type="text" name="searchBjobBzwkDstcd" value="${param.searchBjobBzwkDstcd}">
									</select>
								</div><!-- end.select-style -->									
							</td>	
							<th style="width:100px;">작업유형</th>
							<td>
								<div class="select-style">
									<select type="text" name="searchProcessType" value="${param.searchProcessType}">
										<option value="">전체</option>
										<option value="S">송신</option>
										<option value="R">수신</option>
									</select>
								</div>
							</td>
							<th style="width:100px;">상태</th>
							<td>
								<div class="select-style">
									<select type="text" name="searchStatus" value="${param.searchStatus}">
										<option value="A">전체</option>
										<option value="L">지연</option>
										<option value="F">미도래</option>
										<option value="Q">큐대기</option>
										<option value="S">진행중</option>
										<option value="T">정상종료</option>
										<option value="E">비정상종료</option>
										<option value="C">사용자중지</option>
										<option value="N">파일없음</option>
									</select>
								</div>
							</td>							
						</tr>						
						<tr>							
							<th style="width:100px;">대외기관명</th>
							<td>
								<div class="select-style">
									<select type="text" name="searchOsidInstiDstcd" value="${param.searchOsidInstiDstcd}">
									</select>
								</div>
							</td>
							<th style="width:100px;">거래기간</th>
							<td>
								<input type="text" name="searchStartYYYYMMDD" maxlength="10" value="${param.searchStartYYYYMMDD}" size="10" style="width:80px;">
								<input type="text" name="searchStartHHMM" maxlength="8" value="${param.searchStartHHMM}" size="8" style="width:80px;"> ~
								<input type="text" name="searchEndYYYYMMDD" maxlength="10" value="${param.searchEndYYYYMMDD}" size="10" style="width:80px;">
								<input type="text" name="searchEndHHMM" maxlength="8" value="${param.searchEndHHMM}" size="8" style="width:80px;">
								<input type="hidden" name="searchStartTime" value="20170201000000">
								<input type="hidden" name="searchEndTime" value="20170201235959">
							</td>
							<th style="width:100px;">검색구분</th>
							<td>
								<div class="select-style" style="display:inline-block; width:100px;">
									<select type="text" name="searchGb" value="${param.searchGb}">
										<option value="FILE">파일명</option>
										<option value="UUID">UUID</option>
										<option value="SUBUUID">SUBUUID</option>
									</select>
								</div>	
								<input type="text" name="searchText" value="${param.searchText}" style="width:100px">
							</td>
						</tr>
					</tbody>
				</table>
				
				<div id="container-1" >
					<ul class="tabs">
						<li rel="tabE">비정상:지연+에러</li>
						<li rel="tabF">미도래</li>
						<li rel="tabQ">큐대기</li>
						<li rel="tabS">진행중</li>
						<li class="active" rel="tabA">전송현황</li>
					</ul>
					<div class="tab_container">
						<div id="tabE" class="tab_content">
							<table id="gridE" ></table>
						</div>
						<div id="tabF" class="tab_content">
							<table id="gridF" ></table>
						</div>
						<div id="tabQ" class="tab_content">
							<table id="gridQ" ></table>
						</div>
						<div id="tabS" class="tab_content">
							<table id="gridS" ></table>
						</div>
						<div id="tabA" class="tab_content">
							<table id="gridA" ></table>
						</div>
					</div>					
				</div>			
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

