<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
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
var isPop = "${param.pop}";
var isDetail = false;
var lastSelIdx;
var lastrow;
var url      ='<c:url value="/onl/admin/rule/layoutMan.json" />';
var url_view ='<c:url value="/onl/admin/rule/layoutMan.view" />';
var roleString	= "<%=SessionManager.getRoleIdString(request)%>";
var returnUrl = getReturnUrlForReturn();
function init(key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=eaiBzwkDstcd]")).setData(json.bizList).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("LOUTPTRNNAME","LOUTPTRNDESC").setObj($("select[name=loutPtrnName]")).setData(json.typeList).setFormat(codeName3OptionFormat).rendering();
			if(typeof callback === 'function') {
				callback(key);
			}			
		},
		error:function(e){
			alert(e.responseText);
		}
	});


}
function detail(key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL', loutName : key},
		success:function(json){
			var data = json.detail;
			$("input[name=loutName]").attr('readonly',true);
			
			$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
				var name = $(this).attr("name");
				var tag  = $(this).prop("tagName").toLowerCase();
				$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
			});
			$("#grid")[0].addJSONData(json);
			$("#tree")[0].addJSONData(json);

			var TOTAL = {};
			
			var ids = $("#tree").jqGrid('getDataIDs');
			
			for (var i =0; i< ids.length; i++){
				var rowId = ids[i];
				//var rowData = $('#tree').jqGrid('getRowData', rowId);
				
				var parent = $('#tree').jqGrid('getCell', ids[i],'parent');
				var cnt = parseInt($('#tree').jqGrid('getCell', ids[i],'LOUTITEMLENCNT'));
				if(TOTAL[parent] == "undefined" || isNaN(TOTAL[parent]) ) TOTAL[parent] = "0";
				
				TOTAL[parent] = parseInt(TOTAL[parent]) + cnt + "" ;										
				
			}
			for (var i =0; i< ids.length; i++){
				var rowId = ids[i];
				//var rowData = $('#tree').jqGrid('getRowData', rowId);
				
				var occurTimes = $('#tree').jqGrid('getCell', rowId,'LOUTITEMMAXOCCURNOITM'); //rowData.LOUTITEMMAXOCCURNOITM;
				var refInfo = $('#tree').jqGrid('getCell', rowId,'LOUTITEMREFINFO2');	//rowData.LOUTITEMREFINFO2;
				var datatype = $('#tree').jqGrid('getCell', rowId,'LOUTITEMPTRNIDDESC');	//rowData.LOUTITEMPTRNIDDESC;
				var id = $('#tree').jqGrid('getCell', rowId,'id'); 	//rowData.id;
				
				if( datatype == "UNKNOWN" ){
					switch(Number(occurTimes)){
						case 0 : break;
						case 1: break;
						case -1:
							occurTimes = $('#tree').jqGrid('getCell', ids[i-1],'LOUTITEMMAXOCCURNOITM');
							TOTAL[id] = TOTAL[id]+ "*" +refInfo;
							 break;
						default : 
							occurTimes = occurTimes; 	//rowData.LOUTITEMMAXOCCURNOITM;
							TOTAL[id] = TOTAL[id]+ "*" +occurTimes;
							break;					
					}				
				
				}
			
			}
			var totalData="";
			var totVal1 = 0;
			var totVal2 = "";
			for (var index in TOTAL){
				if(TOTAL[index].indexOf("*") == -1 )
					totVal1 = totVal1 + parseInt(TOTAL[index]);
				else
					totVal2 = (totVal2==""?"":(totVal2+"+"))+ TOTAL[index];		
			}
			totalData = totVal1+ (totVal2==""?"":(" + "+totVal2));			

			$('#dataTotalLen').text(totalData);
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
$(document).ready(function() {	
	
	var key ="${param.loutName}";
	if (key != "" && key !="null"){
		isDetail = true;
		//set to Layout Selector
		var layouts = key.split(",");
		var size = layouts.length;
		var str = "";
		for(var i=0; i<size; i++){
			str += "<option value="+layouts[i]+">"+layouts[i]+"</option>";
			//$("#dialog_confirm").append("<option value ="+layouts[i]+">"+layouts[i]+"</option>");
		}
		$("select[name=loutName]").append(str);
		key = $("select[name=loutName] option:first").val();
	}
	
	init(key,detail);
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ '전문레이아웃변환매핑코드',
		             'IF서비스코드',
		             'IF서비스설명',
		             'SRC/TGT'
		              ],
		colModel : [ { name : 'CNVSNNAME'       , align : 'center' , width:'100'},
		             { name : 'EAISVCNAME'      , align : 'center' , width:'100'},
		             { name : 'EAISVCDESC'      , align : 'left'   },
		             { name : 'SOURCRSULTDSTCD' , align : 'left'   , width:'80'}

		              ],
		jsonReader : {
	    	root : "rows2",
			repeatitems : false
		},
		rowNum : 10000,
		autoheight : true,
		height : "80",
		autowidth : true,
		viewrecords : true,
		ondblClickRow : function(rowId) {
		}
	});
	$('#tree').jqGrid({
	    datatype:'json',
	    loadui: "disable",
	    mtype: 'POST',
	    colNames: ["번호","항목명(영문)","항목설명","최대발생건수","참조정보","테이타타입","테이터길이","소수점길이","레이아웃명","ID","PARENT"],
	    colModel: [
	        {name: "LOUTITEMSERNO"          , width:"30"},
	        {name: "LOUTITEMNAME"           , width:"250"},
	        {name: "LOUTITEMDESC"                      },
	        {name: "LOUTITEMMAXOCCURNOITM"  , width:"60"},
	        {name: "LOUTITEMREFINFO2"       , width:"150"},
	        
	        {name: "LOUTITEMPTRNIDDESC" , width:"60"},
	        {name: "LOUTITEMLENCNT"         , width:"60"},
	        {name: "DECPTLENCNT"            , width:"60"},
	        
	        {name: "LOUTNAME"              ,hidden:true },
   	    	{name: "id"             ,hidden:true},
	    	{name: "parent"         ,hidden:true }
	      
	        
			],
	    treeGrid: true,
	    treeGridModel: "adjacency",
	    ExpandColumn: "LOUTITEMNAME",
	    height:"400",
	    rowNum: 10000,
	    autowidth : true,
	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    },
	    loadComplete:function (d){
	    },	
	    gridComplete:function(){
	    	$(this).jqGrid('hideCol','cb');
	    
	    },
  		onCellSelect:function(rowid,iCol,content,event){
			//console.log(rowid+","+iCol);

		},    
		ondblClickRow : function(rowId) {
		   /*
			var rowData = $(this).getRowData(rowId); 
            var key = rowData['LOUTNAME'];
            var url = '<c:url value="/onl/admin/rule/layoutMan.view" />';
            url = url + '?cmd=DETAIL_ITEM';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//검색값
			url = url + '&' + getSearchUrl();
            //key값
            url = url + '&loutName='+key;
            url = url + '&loutItemName='+key;
            url = url + '&loutItemSerno='+key;
    		goNav(url);	
    		*/			
		},
 		onSelectRow: function(rowid,status){
 			//before에서 false라서 호출안됨
 			var sel = $(this).jqGrid('getGridParam', 'selarrrow');
 			alert(sel);
 		},
		beforeSelectRow: function(id,e){
			var row = $("#" + id);
			var curSelIdx = $("#tree").getInd(id)-1;
			if(e.shiftKey){
			
				var rows = $("#tree .jqgrow");
				var selmin =0;
				var selmax =0;
				
				if(!lastSelIdx)
					lastSelIdx = 0;
				if(lastSelIdx > curSelIdx){
					selmin = curSelIdx;
					selmax = lastSelIdx;
					
				}else{
					selmin = lastSelIdx;
					selmax = curSelIdx;
				}
				for(i =0; i < rows.length; i++){
					if(i >= selmin && i <= selmax){
						$(rows[i]).addClass("ui-state-highlight").attr("aria-selected","true");
						
					}else{
						$(rows[i]).removeClass("ui-state-highlight").attr("aria-selected","false");
					}
				}
			
				//데이터 길이 계산!		
				var selLen	=0;	
				var ar = new Array();
				$("#tree tr[aria-selected=true]").each(function(){
					var id = $(this).attr('id');
					try{
						selLen += parseInt($('#tree').jqGrid('getCell', id,'LOUTITEMLENCNT'));
					}catch(Exception){
						
					}finally{

					}
				});
				$('#selLen').text(selLen);
			
			}else{
				$("#tree tr[aria-selected=true]").each(function(){
					$(this).removeClass("ui-state-highlight").attr("aria-selected","false");

				});
				
				row.addClass("ui-state-highlight").attr("aria-selected","true");
				lastSelIdx = curSelIdx;
				$('#selLen').text("0");
			
			}
			return false;
		
		} // handle multi select
	});	
	
	
	$("#btn_modify").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		if (isDetail){
			postData.push({ name: "cmd" , value:"UPDATE"});
		}else{
			postData.push({ name: "cmd" , value:"INSERT"});
		}
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("저장 되었습니다.");
				goNav(returnUrl);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("#btn_delete").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"DELETE"});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("삭제 되었습니다.");
				goNav(returnUrl);//LIST로 이동

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_close").click(function(){
			window.close();
		
	});

	
	$("select[name=loutName]").change(function(){
		var key = $(this).val();
		detail(key);
	});
	
	$("#btn_excel").click(function(event) {
        event.stopPropagation(); // Do not propagate the event.
        // Create an object that will manage to download the file.
        var target = "excelDown" ; // iframe의 name
		gridToExcelSubmit1(url,target,"LIST_GRID_TO_EXCEL",$("#tree"),$("#ajaxForm"),$("select[name=loutName]").val());
		return false;
			
	});
	buttonControl(isDetail);
	//titleControl(isDetail);
	


	$("input, select").prop('disabled','disabled');
	$("select[name=loutName] ").prop('disabled','');
});
 
</script>
<style>
#btn_excel {

cursor:pointer
}
</style>
</head>
	<body>
	<!-- path -->
	<div class="container">
		<div class="right full">
			<p class="nav"></p>
		</div>
	</div>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">레이아웃</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	
	<!-- button -->
	<table width="100%" height="35px" >
	<tr>
		<td align="right">
			<!-- img id="btn_delete" level="W" status="DETAIL" />
			<img id="btn_modify" src="<c:url value="/images/bt/bt_modify.gif"/>" level="W" status="DETAIL,NEW"/-->
			
			<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>"     level="R" status="DETAIL,NEW"/>
		</td>
	</tr>
	</table>	
	<!-- detail -->
	<form id="ajaxForm">
	<table border="0" cellpadding="1" cellspacing="0" bordercolor="#000000" width="100%">
		<tr>
			<td>
		[전문레이아웃 정보]
			</td>
		</tr>
		<tr>
			<td>
			<table class="table_detail" width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" >
				<tr>
					<td width="20%" class="detail_title">전문레이아웃 코드</td><td width="80%" colspan="3"><select name="loutName" style="width:100%"/> </td>
				</tr>
				<tr>
					<td class="detail_title">전문레이아웃 유형명</td><td><select name="loutPtrnName" style="width:100%"></select></td>
					<td class="detail_title">업무구분명</td><td><select name="eaiBzwkDstcd" style="width:100%"></select></td>
				</tr>
				<tr >
					<td class="detail_title" >인터페이스ID명</td><td colspan="3"><input type="text" name="sysIntfacName" style="width:100%;"></input></td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td>
		[전문레이아웃 영향도] => 현재 전문레이아웃을 사용하고 있는 매핑정보를 표시합니다.
			</td>
		</tr>
		<tr height="100px">
			<td>
			 <table id="grid"></table>
			</td>
		</tr>
		<tr>
			<td>
		[전문레이아웃 항목 정보]
		<img id="btn_excel" src="<c:url value="/images/bt/bt_excel.gif"/>" level="W" status="DETAIL"/>
			</td>
		</tr>	
		<tr>
			<td>
			<table id="tree"></table>
			</td>
		</tr>
		<tr>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#000000" style="table-layout:fixed;word-break:break-all;">
				<tr >
				<td width="20%" class="detail_title" >데이터 총길이</td><td width="60%"  id="dataTotalLen" ></td>	
				<td width="10%" class="detail_title" >선택 길이</td><td width="10%" id="selLen" ></td>	
				</tr>
			</table>	
		</tr>	
		
	</table>

	
	
	
	</form>
	<iframe name=excelDown width=0 height=0></iframe>
	</body>
</html>

