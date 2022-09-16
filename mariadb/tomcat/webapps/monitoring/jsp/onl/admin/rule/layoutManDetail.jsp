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
		}
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
	$("#btn_previous").click(function(){
		if(isPop == "true")
			window.close();
		else
			goNav(returnUrl);//LIST로 이동
		
	});
	$("#btn_initialize").click(function(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZE',loutName:$("input[name=loutName]").val()},
			success:function(json){
				alert(json.message);
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
		
	});		
$("#btn_excel").click(function(event) {
        event.stopPropagation(); // Do not propagate the event.
        // Create an object that will manage to download the file.
        var target = "excelDown" ; // iframe의 name
		gridToExcelSubmit(url,"LIST_GRID_TO_EXCEL",$("#tree"),$("#ajaxForm"),$("input[name=loutName]").val());
		return false;
			
	});
	buttonControl(isDetail);
	//titleControl(isDetail);
	
	setBtnHide(roleString, "admin", "btn_initialize");
	
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
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" status="DETAIL" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>					
				</div>
				<div class="title">레이아웃 상세</div>	
				
				<form id="ajaxForm">					
					<div class="table_row_title">전문레이아웃 정보</div>						
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">전문레이아웃 코드</th>
							<td width="80%" colspan="3"><input type="text" name="loutName"/> </td>
						</tr>
						<tr>
							<th>전문레이아웃 유형명</th>
							<td><div class="select-style"><select name="loutPtrnName"></select></div></td>
							<th style="width:20%;">업무구분명</th>
							<td><div class="select-style"><select name="eaiBzwkDstcd"></select></div></td>
						</tr>
						<tr >
							<th>인터페이스ID명</th>
							<td colspan="3"><input type="text" name="sysIntfacName"></input></td>
						</tr>
					</table>						
					<div class="table_row_title">전문레이아웃 영향도 <span style="font-size:12px;">=> 현재 전문레이아웃을 사용하고 있는 매핑정보를 표시합니다.</span></div> 
					<table id="grid"></table>
					<div style="margin-top:15px;">	
						<div class="table_row_title" style="display:inline-block;">전문레이아웃 항목 정보</div> <img id="btn_excel" src="<c:url value="/img/btn_excel.png"/>" level="W" status="DETAIL"/>
					</div>	
					<table id="tree"></table>				
					<table class="table_row" cellspacing="0" style="margin-top:15px;">
						<tr>
							<th style="width:20%;">데이터 총길이</th>
							<td id="dataTotalLen" >	</td>		
						</tr>
					</table>								
				</form>
	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

