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
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value="/css/w2ui-1.4.3.css"/>" />
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" src="<c:url value="/js/w2ui-1.4.3.js"/>"></script>
<script language="javascript" >
	var url      = '<c:url value="/onl/transaction/tracking/trackingMan.json" />';
	var url_view = '<c:url value="/onl/transaction/tracking/trackingMan.view" />';

	var last = new Object();
	
	var selectName = "searchEaiBzwkDstcd";	// selectBox Name
	
	function isValidGuid()
	{
		var guid = $("input[name=searchGuid]").val();
		
		if(guid != "")
		{
			if(guid.length != 33)
			{
				alert("GUID는 33자리만 입력 할 수 있습니다.");
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
		var tm = right("0" + now.getHours(), 2);
		tm += right("0" + now.getMinutes(), 2);
		return tm + '60';
	}
	function init( callback) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"JSON",
			data:{cmd: 'LIST_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setNoValueInclude(true).setNoValue("","전체").setData(json.bizList).setFormat(codeName3OptionFormat).rendering();
				new makeOptions("CODE","NAME").setObj($("select[name=searchLogPrcssSerno]")).setNoValueInclude(true).setNoValue("","전체").setData(json.logPrcssSernoList).rendering();
				
				setSearchable(selectName);	// 콤보에 searchable 설정
				
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
		w2ui['myGrid'].clear();
		//$("#grid").clearGridData();		// 이전 데이터 삭제.
		var start = $("input[name=searchStartYYYYMMDD]").val()+$("input[name=searchStartHHMM]").val();
		var end = $("input[name=searchEndYYYYMMDD]").val()+$("input[name=searchEndHHMM]").val();
		$("input[name=searchStartTime]").val(start);
		$("input[name=searchEndTime]").val(end);
		
		// guid로 검색 할 때 자리수 체크.
		if(!isValidGuid()) return;
		
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		postData['totalCount']=0;
		postData['page']=1;
		postData['rows']=1;

		$.ajax({  
			type : "POST",
			url:url,
			dataType:"JSON",
			data:postData,
			success:function(json){
				var data = json;
				var records = data.rows;
				var cnt = 1;
				for(var idx in records){
					//insert recid
					records[idx]['recid'] = parseInt(idx)+1;
				}
				w2ui['myGrid'].total = data.records;
				w2ui['myGrid'].records = records;
				
				
				var rec = w2ui['myGrid'].records;
				for(var idx in rec){
					var val = rec[idx].ERRYN;
					if(val =="Y"){
						rec[idx].style = 'background-color:#FFCC99';
					}else{
					rec[idx].style = 'background-color: #FFFFFF';
					}
				} 
				w2ui['myGrid'].refresh();
			},
	    	error:function(xhr,status,error){
	    		alert(JSON.parse(xhr.responseText).errorMsg);
	    	}
		});
	}
function w2GridToExcelSubmit(url,cmd,gridObj,formObject,fileName,merge){
	
	var postData = formObject.serializeArray();	
	postData.push({
		name : "cmd",
		value : cmd
	});
	//fileName 필수값 아님
	if (fileName != undefined){
		postData.push({
			name : "fileName",
			value : fileName
		});	
	}
	
	//grid data
	var data = gridObj.records;
	var gridData = new Array();
	for ( var i = 0; i < data.length; i++) {
		gridData.push(data[i]);
	}

	postData.push({
		name : "gridData",
		value : JSON.stringify(gridData)
	});
	
			
	//grid titles

	var colM = gridObj.columns;
	var headers      = new Array();
	var headerTitles = new Array(); 
	for(var i=0;i<colM.length;i++){
		if (colM[i].hidden){
		}else{
			headers.push(colM[i].field);
			headerTitles.push(colM[i].caption);
		}
	}
	postData.push({
		name : "header",
		value : JSON.stringify(headers)
	});		
	postData.push({
		name : "headerTitle",
		value : JSON.stringify(headerTitles)
	});	
	if (merge != undefined){
		postData.push({
			name : "merge",
			value : JSON.stringify(merge)
		});	
	}
	
	
	var form="<form action='"+url+"' method='post' target='excelDown'>";
	$.each(postData,function(_,obj){
		form +="<input type='hidden' name='"+obj.name+"' value='"+obj.value+"'/>";
	});
	form += "</form>";
	$(form).appendTo("body").submit().remove();
}
function getDateFormat(record, ind, col_ind){
	var n = record[this.columns[col_ind].field];
	n = n.toString();
	
	if ( n == null || n.length < 12 )
		return '';
	return n.substr(0,4) + '-' +
	       n.substr(4,2) + '-' +
	       n.substr(6,2) + ' ' +
	       n.substr(8,2) + ':' +
	       n.substr(10,2) + ':' +
	       n.substr(12,2) ;
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
	$('#myGrid').w2grid({ 
	    name   : 'myGrid', 
	    datatype:'JSON',
	    method:'POST',
	    multiSelect : false,
	    autoLoad:false,
	    show :{ 
	    	emptyRecords:false
	    },
	    columns: [          

             { field : 'EAISVCSERNO'       	, size: '0px'},
             { field : 'LOGPRCSSSERNO'  	, size: '0px'},
             { field : 'EAIBZWKDSTCD'     	, size: '0px'},
             { field : 'MSGDPSTYMS'    	    , size: '0px'},
             { field : 'ERRYN'         		, size: '0px'},
             { field : 'EAISVCSERNO_TMP'    	,caption: 'IF서비스일련번호', size: '140px' ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7'},
             { field : 'KEYMGTMSGCTNT'      	,caption: '전문추적관리필드' , size: '240px' ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7'},
             { field : 'LOGPRCSSSERNO_TMP'      ,caption: 'seq'        , size: '50px'  ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7'},
             { field : 'SRVCID'             	,caption: '서비스ID'     , size: '120px' ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7'},
             { field : 'EAISVCNAME'        	 	,caption: 'IF서비스코드'   , size: '170px' ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7'},
             { field : 'EAISVCDESC'         	,caption: 'IF서비스설명'   , size: '250px' ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7'},
             { field : 'TRACKASISKEY1CTNT'   , size: '0px'},
             { field : 'TRACKASISKEY2CTNT'   , size: '0px'},
             { field : 'EAIBZWKDSTCD_TMP'    ,size: '60px', caption: '업무명',style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7'},
             { field : 'MSGDPSTYMS_TMP'     , size: '150px',caption: '수신일시' ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7',render : getDateFormat	 },
             { field : 'MSGPRCSSYMS'       	,caption: '처리일시', size: '150px' ,style:' border-bottom:1px solid #79b7e7; border-top:1px solid #79b7e7',render : getDateFormat  }
	    ]
	    ,mergeRows:[0]
	    ,onLoad:function(event){
	    }
		,onClick:function(event){
		}
		,onDblClick:function(event){
			var recid = event.recid;

		    var args = new Object();
		    args['eaiBzwkDstcd']  	= 	this.getCellValue(recid-1, 2, false); //rowData['EAIBZWKDSTCD'];
		    args['msgDpstYMS']    	= 	this.getCellValue(recid-1, 3, false); //rowData['MSGDPSTYMS'];
		    args['logPrcssSerno'] 	= 	this.getCellValue(recid-1, 1, false); //rowData['LOGPRCSSSERNO'];
		    args['eaiSvcSerno']   	= 	this.getCellValue(recid-1, 0, false); //rowData['EAISVCSERNO'];
		    
		    var url2 = '<c:url value="/onl/transaction/tracking/trackingMan.view"/>';
		    url2 = url2 + "?cmd=DETAIL";
		    showModal(url2,args,810,1218,undefined,"scroll:yes;");

			
		}
		,onKeydown:function(event){
			
		}
	});
	
	w2ui['myGrid'].hideColumn('EAISVCSERNO','LOGPRCSSSERNO','EAIBZWKDSTCD','MSGDPSTYMS','ERRYN','TRACKASISKEY1CTNT','TRACKASISKEY2CTNT');

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
	});
	/*
	$("#btn_download").click(function(event) {
           event.stopPropagation(); // Do not propagate the event.
           // Create an object that will manage to download the file.
		w2GridToExcelSubmit(url,"LIST_GRID_TO_EXCEL",w2ui['myGrid'],$("#ajaxForm"),"거래 로그 목록");
		return false;
	});
	*/			
	
	buttonControl();
	
});
 
</script>
</head>
	<body>
	<!-- path -->
	<div class="container">
		<div class="right full">
			<p class="nav">${rmsMenuPath}</p>
		</div>
	</div>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">로그검색 관리</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	

	<!-- button -->
	<table  width="100%" height="35px"  >
	<tr>
		<td align="left">
		<table width="100%">
		<tr>
			<td class="search_td_title" width="70px">업무구분명</td><td><select type="text" name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}" style="width:100%"></select></td>
			<td class="search_td_title" width="110px">메시지수신시간</td><td width="335px"><input type="text" name="searchStartYYYYMMDD" value="" size="10" ><input type="text" name="searchStartHHMM" value="" size="8" >~<input type="text" name="searchEndYYYYMMDD" value="" size="10" readonly="readonly"><input type="text" name="searchEndHHMM" value="" size="8" ><input type="hidden" name="searchStartTime" ><input type="hidden" name="searchEndTime" ></td>
			<td class="search_td_title" width="100px">IF서비스코드</td><td><input type="text" name="searchEaiSvcName" value="${param.searchEaiSvcName}" style="width:100%"></td>
		</tr>
		<tr>
			<td class="search_td_title" >GUID</td><td><input type="text" name="searchGuid" value="${param.searchGuid}" style="width:100%"/></td>
			<td class="search_td_title" >IF서비스일련번호</td><td><input type="text" name="searchEaiSvcSerno" value="${param.searchEaiSvcSerno}" style="width:100%"></td>
			<td class="search_td_title" >전문추적관리필드</td><td><input type="text" name="searchKeyMgtMsgCtnt" value="${param.searchKeyMgtMsgCtnt}" style="width:100%"></td>
		</tr>
		<tr>
			<td class="search_td_title" >seq</td><td><select name="searchLogPrcssSerno" value="${param.searchLogPrcssSerno}" style="width:100%"></select></td>
			<td class="search_td_title" >추적보조키1</td><td><input type="text" name="searchTrackAsisKey1Ctnt" value="${param.searchTrackAsisKey1Ctnt}" style="width:100%"></td>
			<td class="search_td_title" >추적보조키2</td><td><input type="text" name="searchTrackAsisKey2Ctnt" value="${param.searchTrackAsisKey2Ctnt}" style="width:100%"></td>
		</tr>
		</table>
		</td>
		<td align="right" width="220px">
			<input type="radio" name="searchErrorYn" value="N" checked="checked">전체로그<input type="radio" name="searchErrorYn" value="Y" >에러로그
			<img id="btn_search"    src="<c:url value="/images/bt/bt_search.gif"/>"    level="R"/>
			<!-- img id="btn_download"  src="<c:url value="/images/bt/bt_download.gif"/>"  level="W"/-->
		</td>
	</tr>
	</table>	
	
	<!-- grid -->
	<div id="myGrid" style="width:100%;height: 530px"></div>
	</body>
</html>

