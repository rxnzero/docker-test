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
	var url      = '<c:url value="/onl/transaction/tracking/trackingMan.json" />';
	var url_view = '<c:url value="/onl/transaction/tracking/trackingMan.view" />';
	
	var selectName = "searchEaiBzwkDstcd";	// selectBox Name

	function isValidGuid()
	{
		var guid = $("input[name=searchGuid]").val();
		
		if(guid != "")
		{
			if(guid.length != 33)
			{
				alert("GUID�� 33�ڸ��� �Է� �� �� �ֽ��ϴ�.");
				$("input[name=searchGuid]").focus();
				return false;
			}
		}
		
		return true;
	}

	function getStartTime(){
		var now = new Date();
		var tm = right("0" + now.getHours(), 2);
		tm += right("0" + now.getMinutes(), 2);

		tm = (Math.floor(tm.substr(0, 2)) * 60) + Math.floor(right(tm, 2)) - 5;
		tm = right("0" + parseInt(tm/60), 2) + right("0" + tm%60, 2);
		return tm + '00';	
	}
	function getEndTime(){
		var now = new Date();
		now.setSeconds(now.getSeconds()+50)
		var tm = right("0" + now.getHours(), 2);
		tm += right("0" + now.getMinutes(), 2);
		tm += right("0" + now.getSeconds(), 2)
		return tm;
	}
	function init( callback) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setNoValueInclude(true).setNoValue("","��ü").setData(json.bizList).setFormat(codeName3OptionFormat).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=searchLogPrcssSerno]")).setNoValueInclude(true).setNoValue("","��ü").setData(json.logPrcssSernoList).rendering();
				
				setSearchable(selectName);	// �޺��� searchable ����
				
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
		$("#grid").clearGridData();		// ���� ������ ����.
		var start = $("input[name=searchStartYYYYMMDD]").val()+$("input[name=searchStartHHMM]").val();
		var end = $("input[name=searchEndYYYYMMDD]").val()+$("input[name=searchEndHHMM]").val();
		$("input[name=searchStartTime]").val(start);
		$("input[name=searchEndTime]").val(end);
		
		// guid�� �˻� �� �� �ڸ��� üũ.
		if(!isValidGuid()) return;
		
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ url:url,postData: postData ,datatype:'json' }).trigger("reloadGrid");
	}

$(document).ready(function() {	
	$("input[name=searchStartYYYYMMDD],input[name=searchEndYYYYMMDD]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
	$("input[name=searchStartHHMM],input[name=searchEndHHMM]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM:ss",outputFormat : "HHMMss"  });
	
	$("input[name=searchStartYYYYMMDD],input[name=searchEndYYYYMMDD]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "yyyymmdd"){
			$(this).val(getToday());
		}
	});
	$("input[name=searchStartHHMM]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "HHMMss"){
			$(this).val(getStartTime());
		}
	});
	$("input[name=searchEndHHMM]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "HHMMss"){
			$(this).val(getEndTime());
		}
	});

	init( detail);
	var gridHeight = $(window).height()-340;
	$('#grid').jqGrid({
		datatype : "local",
		mtype : 'POST',
		colNames : [ 'EAISVCSERNO',
		             'LOGPRCSSSERNO',
		             'EAIBZWKDSTCD',
		             'MSGDPSTYMS',
		             '��������',
		             'IF�����Ϸù�ȣ',
		             '�������������ʵ�',
		             'seq',
		             '����ID',
		             'IF�����ڵ�',
		             'IF���񽺼���',
		             '��������Ű1',
		             '��������Ű2',
		             '������',
		             '�����Ͻ�',
		             'ó���Ͻ�'
		              ],
		colModel : [ 
		             { name : 'EAISVCSERNO'        , hidden:true },
		             { name : 'LOGPRCSSSERNO'      , hidden:true },
		             { name : 'EAIBZWKDSTCD'       , hidden:true },
		             { name : 'MSGDPSTYMS'         , hidden:true },
		             { name : 'ERRYN'         		, hidden:true },
		             { name : 'EAISVCSERNO_TMP'    , align : 'left'   , width:'100' },
		             { name : 'KEYMGTMSGCTNT'      , align : 'left'   , width:'240' },
		             { name : 'LOGPRCSSSERNO_TMP'  , align : 'left'   , width:'30'  },
		             { name : 'SRVCID'             , align : 'left'   , width:'120'  },
		             { name : 'EAISVCNAME'         , align : 'left'   , width:'170' },
		             { name : 'EAISVCDESC'         , align : 'left'   , width:'250' },
		             { name : 'TRACKASISKEY1CTNT'  , hidden:true, align : 'center' , width:'70' },
		             { name : 'TRACKASISKEY2CTNT'  , hidden:true, align : 'center' , width:'70' },
		             { name : 'EAIBZWKDSTCD_TMP'   , align : 'center' , width:'40'  },
		             { name : 'MSGDPSTYMS_TMP'     , align : 'center' , width:'125' , formatter: timeStampFormat },
		             { name : 'MSGPRCSSYMS'        , align : 'center' , width:'125' , formatter: timeStampFormat }
		              ],
		jsonReader : {
			repeatitems : false
		},
		rowNum: 10000,
		height : gridHeight,
		viewrecords : true,
		gridview: true,
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
		    var args = new Object();
		    args['eaiBzwkDstcd']  = rowData['EAIBZWKDSTCD'];
		    args['msgDpstYMS']    = rowData['MSGDPSTYMS'];
		    args['logPrcssSerno'] = rowData['LOGPRCSSSERNO'];
		    args['eaiSvcSerno']   = rowData['EAISVCSERNO'];
		    
		    var url2 = '<c:url value="/onl/transaction/tracking/trackingMan.view"/>';
		    url2 = url2 + "?cmd=DETAIL";
		    
		    //showModal(url2,args,810,1218,undefined,"scroll:yes;");
		    var modalWidth=+$(window).width() - 80;
		    var modalHeight=+$(window).height() - 5;
		    showModal(url2, args, modalWidth, modalHeight, undefined, "scroll:yes;");

		    //url2 = url2 + "&eaiBzwkDstcd="  +rowData['EAIBZWKDSTCD'];
		    //url2 = url2 + "&msgDpstYMS="    +rowData['MSGDPSTYMS'];
		    //url2 = url2 + "&logPrcssSerno=" +rowData['LOGPRCSSSERNO'];
		    //url2 = url2 + "&eaiSvcSerno="   +rowData['EAISVCSERNO'];
		    //goNav(url2);
		},
		gridComplete:function (d){
		// ��� ȭ��ǥ ���ֱ�
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},			
	    loadComplete:function (d){
	    	$("#grid").tuiTableRowSpan("5");
	    	
	    	//���� �� ���� ǥ��
	    	var rows = $(this).getDataIDs();
	    	for( var i= 0; i < rows.length; i++){
	    		var val = $("#grid").getCell(rows[i],'ERRYN');
	    		if(val =="Y"){
	    			$("#"+rows[i]).find("td").css("background-color","#FFCC99");
	    		}
	    	}
	    },
        loadError: function(xhr, status, error){
        	$("#grid").clearGridData();
        	alert(JSON.parse(xhr.responseText).errorMsg);
        }		
		
	});
	
	resizeJqGridWidth('grid', 'content_middle', '1500');
	
	$("#btn_search").click(function(){
		detail();
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	$("input[name=searchStartYYYYMMDD]").keyup(function(e){
		$("input[name=searchEndYYYYMMDD]").val($(this).val());
	})
	
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
				<div class="title">�αװ˻� ����</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th width="130px">�޽������Žð�</th>
							<td colspan="3">
								<input type="text" name="searchStartYYYYMMDD" value="" size="10" style="width:100px; border:1px solid #ebebec;">
								<input type="text" name="searchStartHHMM" value="" size="8" style="width:100px; border:1px solid #ebebec;">
								~
								<input type="text" name="searchEndYYYYMMDD" value="" size="10" readonly="readonly" style="width:100px; border:1px solid #ebebec;">
								<input type="text" name="searchEndHHMM" value="" size="8" style="width:100px; border:1px solid #ebebec;">
								<input type="hidden" name="searchStartTime" value="20170119162400">
								<input type="hidden" name="searchEndTime" value="20170119162906">
							</td>
							<th width="130px">GUID</th>
							<td><input type="text" name="searchGuid" value=""></td>							
						</tr>
						<tr>
							<th width="130px">�������и�</th>
							<td>
								<div style="position: relative; width: 100%;">
									
										<select type="text" name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
										</select>	
									
								</div>
							</td>	
							<th width="130px">IF�����ڵ�</th>
							<td><input type="text" name="searchEaiSvcName" value="${param.searchEaiSvcName}"></td>
							<th width="130px">�������������ʵ�</th>
							<td><input type="text" name="searchKeyMgtMsgCtnt" value="${param.searchKeyMgtMsgCtnt}"></td>							
						</tr>
						<tr>
							<th width="130px">IF�����Ϸù�ȣ</th>
							<td colspan="3"><input type="text" name="searchEaiSvcSerno" value="${param.searchEaiSvcSerno}"></td>	
							<th width="130px">seq</th>
							<td>
								<div class="select-style">
									<select name="searchLogPrcssSerno" value="${param.searchLogPrcssSerno}">									
									</select>
								</div><!-- end.select-style -->		
							</td>							
						</tr>
						<tr>							
							<th width="130px">��������Ű1</th>
							<td><input type="text" name="searchTrackAsisKey1Ctnt" value="${param.searchTrackAsisKey1Ctnt}"></td>
							<th width="130px">��������Ű2</th>
							<td><input type="text" name="searchTrackAsisKey2Ctnt" value="${param.searchTrackAsisKey2Ctnt}"></td>
							<th width="130px">�α�Ÿ��</th>
							<td>
								<input type="radio" name="searchErrorYn" value="N" checked="checked" id="sub2_2_1_1"><label for="sub2_2_1_1">��ü�α�</label>
								<input type="radio" name="searchErrorYn" value="Y" id="sub2_2_1_2"><label for="sub2_2_1_2">�����α�</label>
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

