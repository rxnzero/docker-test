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

	var url      = '<c:url value="/bat/transaction/error/errorMonitorMan.json" />';
	//var url_view = '<c:url value="/bat/transaction/interface/interfaceMonitorMan.view" />';
	//var url_view = '<c:url value="/bat/transaction/message/messageMonitorMan.view" />';

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
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setNoValueInclude(true).setNoValue('','��ü').setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
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
	
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
	}

$(document).ready(function() {	

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['UUID',
		          '�����׷�',
                  '�������̽�ID',
                  '�������̽���',
                  '��������',
                  '�ۼ��� ����',
                  '�����߻��ð�',
                  '�ý�������',
                  '������ڵ�',
                  '������ڵ��Ϸù�ȣ',
                  '�����޽���'
                  ],
		colModel:[
		        { name : 'BJOBDMNDMSGID'     , align : 'left'   , hidden:true },
				{ name : 'WORKGRPCD'  , align:'center' ,width:40   },
				{ name : 'INTFID'     , align:'center' ,width:60   },
				{ name : 'INTFNAME'   , align:'left'    },
				{ name : 'ERRGUBUN'   , align:'center' ,width:40  ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '<span style="color:blue">�۽�����</span>';
                                 } else if ( cellvalue == '2' ) {
				                 	return '<span style="color:red">�۽�����</span>';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				
				},
				{ name : 'SNDRCVKIND'  , align:'center' ,width:50  ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '�۽���';
                                 } else if ( cellvalue == '2' ) {
				                 	return '������';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				
				},
				{ name : 'ERRREGDATE'  , align:'center' ,width:'80' , formatter: timeStampFormat },
				{ name : 'SYSTEMKIND'       , align:'center',width:40 ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return 'DB';
                                 } else if ( cellvalue == '2' ) {
				                 	return '����';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				},
				{ name : 'ADPTRCD'         , align:'right', width:50 },
				{ name : 'ADPTRCDSEQ'         , align:'right', width:50 },
				{ name : 'ERRMSG'  }
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
// 		ondblClickRow: function(rowId) {
// 			var rowData = $(this).getRowData(rowId); 
//             var bjobDmndMsgID = rowData['BJOBDMNDMSGID'];
//             //alert('bjobDmndMsgID-->' + bjobDmndMsgID);
//             if ( bjobDmndMsgID.trim() == '' ) return;
//             var url2 = url_view;
//             url2 = url2 + '?cmd=DETAIL';
//             url2 = url2 + '&page='+$(this).getGridParam("page");
//             url2 = url2 + '&returnUrl='+getReturnUrl();
//             url2 = url2 + '&menuId='+'${param.menuId}';
// 			//�˻���
//             url2 = url2 + '&'+getSearchUrl();
//             //key��
//             url2 = url2 + '&bjobDmndMsgID='+bjobDmndMsgID;
//             goNav(url2);
//         },
		rowList : eval('[${rmsDefaultRowList}]'),
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
				<div class="title">���� ����͸�</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:120px;">�������и�</th>
							<td>
								<div style="position: relative; width: 100%;">
									<div class="select-style">
										<select name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
											<option value="">��ü</option>
											<option value="AUD">(AUD)AUDIT</option>
											<option value="BBO">(BBO)������������</option>
										</select>
									</div><!-- end.select-style -->		
								</div>
							</td>
							<th style="width:120px;">�ۼ��ű���</th>
							<td>
								<div class="select-style">
									<select name="searchSndRcvKind" value="${param.searchSndRcvKind}">
										<option value="">��ü</option>
										<option value="1">�۽���</option>
										<option value="2">������</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
							<th style="width:120px;">�ý�������</th>
							<td>
								<div class="select-style">
									<select name="searchSystemKind" value="${param.searchSystemKind}">
										<option value="">��ü</option>
										<option value="1">DB</option>
										<option value="2">FILE</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th style="width:120px;">��������</th>
							<td><input type="text" name="searchInterfaceNm" value="${param.searchInterfaceNm}"></td>
							<th style="width:120px;">��¥ �˻�</th>
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