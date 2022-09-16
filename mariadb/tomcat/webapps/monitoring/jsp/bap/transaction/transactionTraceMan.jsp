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
				new makeOptions("CODE","NAME").setObj($("select[name=searchBjobBzwkDstcd]")).setNoValueInclude(true).setNoValue('','��ü').setData(json.bjobBzwkDstcd).rendering();
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
	
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
	}
	
	function resend(bjobDmndMsgID, bjobDmndSubMsgID, fileTrsmtLogID, sndRecvFileName){
	    
	    if ( confirm( "�ش� ���� �� ���� �Ͻðڽ��ϱ�?" ) != true ){
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
		          '���۷α�ID',
		          '�����ӿ�����',
                  '��������',
                  '�����',
                  '���ϸ�',
                  '����',
                  '���۽ð�',
                  '����ð�',
                  '�ۼ��ű���',
                  '����ũ��',
                  '������',
                  '��ֳ���'
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
				                 	return '<span style="color:red">����</span>';
                                 } else if ( cellvalue == 'T' ) {
				                 	return '<span style="color:blue">���ۼ���</span>';
                                 } else if ( cellvalue == 'S' ) {
				                 	return '<span style="color:green">������</span>';
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
				                 	return '�۽�';
                                 } else if ( cellvalue == 'R' ) {
				                 	return '����';
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
			//�˻���
            url2 = url2 + '&'+getSearchUrl();
            //key��
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
        		if ( sndRcv == '�۽�' || fileTrsmtLogID.trim() != '' ){
        			var be = "<input style='height:22px;width:60px;' type='button' value='������' onclick=\"resend('"+bjobDmndMsgID+"','"+bjobDmndSubMsgID+"','"+fileTrsmtLogID+"','"+sndRecvFileName+"');\" />";
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
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
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
				<div class="title">�ŷ� ����</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:100px;">�����ӿ�����</th>
							<td>
								<div class="select-style">	
									<select name="searchFrameWorkGb" value="${param.searchFrameWorkGb}">
										<option value="2">��ü</option>
										<option value="0">����</option>
										<option value="1">���</option>
									</select>
								</div><!-- end.select-style -->									
							</td>	
							<th style="width:100px;">�������и�</th>
							<td>
								<div class="select-style">
									<select name="searchBjobBzwkDstcd" value="${param.searchBjobBzwkDstcd}">
									</select>
								</div>
							</td>
							<th style="width:100px;">�ۼ��ű���</th>
							<td>
								<div class="select-style">
									<select name="searchSndRcv" value="${param.searchSndRcv}">
										<option value="A">��ü</option>
										<option value="S">�۽�</option>
										<option value="R">����</option>
									</select>
								</div>
							</td>
							<th style="width:100px;">����</th>
							<td>
								<div class="select-style">
									<select name="searchThisStgePrcssRsultCd" value="${param.searchThisStgePrcssRsultCd}">
										<option value="">��ü</option>
										<option value="T">����</option>
										<option value="E">����</option>
										<option value="S">������</option>
									</select>
								</div>
							</td>							
						</tr>						
						<tr>							
							<th style="width:100px;">���ϸ�</th>
							<td>
								<input type="text" name="searchSndrcvFileName" value="${param.searchSndrcvFileName}">
							</td>
							<th style="width:100px;">�����</th>
							<td>
								<input type="text" name="searchOsidInstiName" value="${param.searchOsidInstiName}">
							</td>
							<th style="width:100px;">�ŷ��Ⱓ</th>
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