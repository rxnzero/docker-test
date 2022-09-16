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
var srcGroup;
var tgtGroup;
var srcGrid ;
var tgtGrid ;
var url ='<c:url value="/onl/admin/rule/transformMan.json" />';

var returnUrl = getReturnUrlForReturn();
var roleString	= "<%=SessionManager.getRoleIdString(request)%>";


function getSourceResult(cnvsnName){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd : 'LIST_TRANSFORM_SOURCE_RESULT', cnvsnName : cnvsnName},
		success:function(json){
			var data = json.rows;
			if(data.length == 0){
				alert("데이터 없음");
				return;
			}
			var src = null;
			var tgt = null;;
			for ( var i = 0; i < data.length; i++) {
				if (data[i]['SOURCRSULTDSTCD'] == 'SRC_LAYOUT' ){
					src = data[i]['LOUTNAME'];
					$("input[name=srcLayout]").val(src);
				}else if (data[i]['SOURCRSULTDSTCD'] == 'TGT_LAYOUT' ){
					tgt = data[i]['LOUTNAME'];
					$("input[name=tgtLayout]").val(tgt);
				}
			}
			if (src !=null){
				srcGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_LAYOUT_ITEM', loutName: src } }).trigger("reloadGrid");
			}
			if (tgt !=null){
				tgtGrid.setGridParam( {url :url ,postData: { cmd : 'LIST_TRANSFORM_ITEM', loutName: tgt ,cnvsnName : cnvsnName} }).trigger("reloadGrid");
			}
			
		},
		error:function(e){
			alert(e.responseText);
		}
	}); 	
}


function setTgtCell(){
	var rowId = tgtGrid.getGridParam( "selrow" );
	tgtGrid.jqGrid('setCell',rowId,'CNVSNRSULTITEMPATHNAME',$('textarea[name=CNVSNRSULTITEMPATHNAME]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNCMDNAME',$('textarea[name=CNVSNCMDNAME]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMBASCVAL',$('input[name=CNVSNITEMBASCVAL]').val() == "" ? null : $('input[name=CNVSNITEMBASCVAL]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMSERNO',$('input[name=CNVSNITEMSERNO]').val());	
}
$(document).ready(function() {	
	//combo
	$("input, select").attr('readonly',true);
	
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd : 'LIST_INIT_COMBO',eaiSvcName: '${param.eaiSvcName}'},
		success:function(json){
			//function combo
			new makeOptions("CODE","NAME").setObj($("select[name=functionCombo]")).setData(json.functionRows).setFormat(codeName3OptionFormat).setNoValueInclude(true).rendering();
			//layout combo
			new makeOptions("CODE","NAME").setObj($("select[name=cnvsnTypeCombo]")).setData(json.cnvsnType).setFormat(codeName3OptionFormat).setAttr("disabled", "disabled").rendering();
			
			$("input[name=eaiSvcName]").val("${param.eaiSvcName}");
			$("input[name=cnvsnName]").val("${param.cnvsnName}");
			
			getSourceResult("${param.cnvsnName}");
		
		},
		error:function(e){
			alert(e.responseText);
		}
	}); 

	
	
	
	
	srcGrid = $("#sourceLayout");
	srcGrid.jqGrid({
		//url: '<c:url value="/onl/admin/rule/transformMan.json" />',
		//postData : { cmd : 'LAYOUT_ITEM', loutName: 'LAC_BBSA311_CBSS'},			    
	    datatype:'json',
	    loadui: "disable",
	    mtype: 'POST',
	    colNames: ["id","원천 항목명","원천 항목명","번호","노드타입","항목타입","LOUTITEMNODEPTRNIDNAME","LOUTITEMPTRNIDNAME","LOUTITEMPATH","LOUTNAME","LOUTITEMMAXOCCURNOITM","LOUTITEMREFINFO2"],
	    colModel: [
	        {name: "id"                     , hidden:true,key:true},
	        {name: "LOUTITEMNAME"           , width:"250"},
	        {name: "LOUTITEMDESC"                      },
	        {name: "LOUTITEMSERNO"          , width:"30"},
	        {name: "LOUTITEMNODEPTRNIDDESC" , width:"60"},
	        {name: "LOUTITEMPTRNIDDESC"     , width:"80"},
	        {name: "LOUTITEMNODEPTRNIDNAME" , hidden:true},
	        {name: "LOUTITEMPTRNIDNAME"     , hidden:true},
	        {name: "LOUTITEMPATH"           , hidden:true},
	        {name: "LOUTNAME"               , hidden:true},
	        {name: "LOUTITEMMAXOCCURNOITM"  , hidden:true},
	        {name: "LOUTITEMREFINFO2"       , hidden:true}
	        
			],
	    treeGrid: true,
	    treeGridModel: "adjacency",
	    ExpandColumn: "LOUTITEMNAME",
	    height:"500",
	    //direction:"rtl",
	    //autowidth: true,
	    rowNum: 10000,
	    //autowidth: true,

	    //ExpandColClick: true,
	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    },
	    loadComplete:function (d){
	    	var data = d.rows;
			srcGroup = new Object();
			for ( var i = 0; i < data.length; i++) {
				//if (data[i]["LOUTITEMREFINFO2"] == null) continue;
				if (data[i]["LOUTITEMPATH"].length > 0 
					&& (data[i]["LOUTITEMNODEPTRNIDNAME"] == "2202")
					&& (data[i]["LOUTITEMMAXOCCURNOITM"] > 1
							|| ( data[i]["LOUTITEMREFINFO2"] != null && data[i]["LOUTITEMREFINFO2"].trim().length > 1 )
	             )
					)  {
					srcGroup[data[i]["LOUTITEMPATH"]]= data[i]["LOUTITEMPATH"];
					}
			}

	    },	    

	});
	tgtGrid = $("#targetLayout");
	tgtGrid.jqGrid({
		//url: '<c:url value="/onl/admin/rule/transformMan.json" />',
		//postData : { cmd : 'LAYOUT_ITEM', loutName: 'LAC_BBSA311_ORGS'},			    
	    datatype:'json',
	    loadui: "disable",
	    mtype: 'POST',
	    colNames: ["id","타겟 항목명","타겟 항목명","번호","노드타입","항목타입","LOUTITEMNODEPTRNIDNAME","LOUTITEMPTRNIDNAME","LOUTITEMPATH","LOUTNAME","CNVSNNAME","CNVSNRSULTITEMPATHNAME" ,"변환 명령","CNVSNITEMBASCVAL","CNVSNITEMSERNO"
	              ],
	    colModel: [
	        {name: "id"                     , hidden:true,key:true},
	        {name: "LOUTITEMNAME"           , width:"250" },
	        {name: "LOUTITEMDESC"            },
	        {name: "LOUTITEMSERNO"          , width:"30" },
	        {name: "LOUTITEMNODEPTRNIDDESC" , width:"60" },
	        {name: "LOUTITEMPTRNIDDESC"     , width:"80" },
	        {name: "LOUTITEMNODEPTRNIDNAME" , hidden:true},
	        {name: "LOUTITEMPTRNIDNAME"     , hidden:true},
	        {name: "LOUTITEMPATH"           , hidden:true},
	        {name: "LOUTNAME"               , hidden:true},

	        {name: "CNVSNNAME"              , hidden:true}, //변환 명
	        {name: "CNVSNRSULTITEMPATHNAME" , hidden:true}, //타겟 항목명
	        {name: "CNVSNCMDNAME"           , width:"400"}, //변환 명령
	        {name: "CNVSNITEMBASCVAL"       , hidden:true}, //기본값
	        {name: "CNVSNITEMSERNO"         , hidden:true}  //매핑순서
	    ],
	    treeGrid: true,
		treeIcons : {
			plus: "ui-icon-circlesmall-plus",
			minus: "ui-icon-circlesmall-minus",
			leaf : "ui-icon-document"
		},		    
	    treeGridModel: "adjacency",
	    ExpandColumn: "LOUTITEMNAME",
	    height:"500",
	    //autowidth: true,
	    rowNum: 10000,
	    //ExpandColClick: true,
	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    },
	    loadComplete:function (d){
	    	var data = d.rows;
				tgtGroup = new Object();
				for ( var i = 0; i < data.length; i++) {
						if (data[i]["LOUTITEMPATH"].length > 0 
							&& (data[i]["LOUTITEMNODEPTRNIDNAME"] == "2202")
							&& (data[i]["LOUTITEMMAXOCCURNOITM"] > 1
							        || ( data[i]["LOUTITEMREFINFO2"] != null && data[i]["LOUTITEMREFINFO2"].trim().length > 1 )
			           )
						)  {
							tgtGroup[data[i]["LOUTITEMPATH"]]= data[i]["LOUTITEMPATH"];
						}
				}
				
	    },	    
		onSelectRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
			$('textarea[name=CNVSNRSULTITEMPATHNAME]').val(rowData['CNVSNRSULTITEMPATHNAME']);//
			$('textarea[name=CNVSNCMDNAME]').val(rowData['CNVSNCMDNAME']);
			$('input[name=CNVSNITEMBASCVAL]').val(rowData['CNVSNITEMBASCVAL']);
			$('input[name=CNVSNITEMSERNO]').val(rowData['CNVSNITEMSERNO']);
       }
	});
	resizeJqGridWidth('sourceLayout','sourceLayoutTd','1000');		
	resizeJqGridWidth('targetLayout','targetLayoutTd','1000');
	
	$("input[name=srcLayout],[name=tgtLayout]").dblclick(function(){
		var layoutName = $(this).val();
		if($.trim(layoutName) =="") return;

		 var args = new Object();

		var url = '<c:url value="/onl/admin/rule/layoutMan.view" />';
		url += "?cmd=DETAILPOPUP";
        url += '&loutName='+layoutName;
        url += '&pop=true';
	    
	    showModal(url,args,1200,800); 
	});		
	

	$("textarea[name=CNVSNRSULTITEMPATHNAME],textarea[name=CNVSNCMDNAME],input[name=CNVSNITEMBASCVAL],input[name=CNVSNITEMSERNO]").blur(function(){
		var rowId = tgtGrid.getGridParam( "selrow" );
		if (isNull(rowId)) return;
		setTgtCell();
		
	});	
	$("#btn_close").click(function(){
		window.close();
	});
	
	$("#btn_excel_src").click(function(event) {
		var url      ='<c:url value="/onl/admin/rule/layoutMan.json" />';
        event.stopPropagation(); // Do not propagate the event.
        // Create an object that will manage to download the file.
        var target = "excelDown" ; // iframe의 name
		gridToExcelSubmit1(url,target,"LIST_GRID_TO_EXCEL",srcGrid,$("#ajaxForm"),$("input[name=srcLayout]").val());
		return false;
			
	});	
	$("#btn_excel_tgt").click(function(event) {
		var url      ='<c:url value="/onl/admin/rule/layoutMan.json" />';
        event.stopPropagation(); // Do not propagate the event.
        // Create an object that will manage to download the file.
        var target = "excelDown" ; // iframe의 name
		gridToExcelSubmit1(url,target,"LIST_GRID_TO_EXCEL",tgtGrid,$("#ajaxForm"),$("input[name=tgtLayout]").val());
		return false;
			
	});	
	buttonControl(true);
	setBtnHide(roleString, "admin", "btn_initialize");

});
	 
	</script>
	<style>
	#btn_excel_src {cursor:pointer}
	#btn_excel_tgt {cursor:pointer}
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
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">전문레이아웃변환매핑</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	
	<!-- comment -->
	<div class="container">
		<div class="left full" >
			<p class="comment" >전문레이아웃 변환 매핑엔진의 매핑규칙을 조회하는 화면입니다.</p>
		</div>
	</div>
	
	<!-- button -->
	<table  width="100%" height="35px"  >
	<tr>
		<td colspan="4" align="right">
			<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>"         level="R" status="DETAIL,NEW"/>
		</td>
	</tr>
	<tr>
		<td align="left" class="search_td_title" width="170px">IF서비스코드[명]</td>
		<td align="left"><input name="eaiSvcName" style="width:100%;height:25px;"></td>		
		
	</tr>
	<tr>
		<td align="left" class="search_td_title">전문레이아웃변환매핑 코드</td>
		<td><input name="cnvsnName" style="width:100%;height:25px;" ></td>
		<td align="left" class="search_td_title" width="180px">전문레이아웃 변환 매핑 유형</td>
		<td><select name="cnvsnTypeCombo" style="width:100%;height:25px;" /></td>
	</tr>

	</table>
	<table>
	<tr height=10px><td></td></tr>
	</table>	
		<!-- tree -->
		<table border="0" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed;" >
			<tr width="100%">
				<td width="42%">
				<table width=100%>
					<tr>
						<td class="search_td_title" width="35px">원천<img id="btn_excel_src" src="<c:url value="/images/bt/bt_excel.gif"/>" level="W" status="DETAIL"/></td>
						<td width="70%" heigh="25px"><input name="srcLayout" style="width:100%;" ></td>
	
					</tr>
				</table>
				<td width="4%"></td>
				<td width="58%">
				<table width=100%>
					<tr>
						<td class="search_td_title" width="35px">타겟<img id="btn_excel_tgt" src="<c:url value="/images/bt/bt_excel.gif"/>" level="W" status="DETAIL"/></td>
						<td width="70%" heigh="25px"><input name="tgtLayout" style="width:100%;"></td>				
					</tr>
				</table>
				</td>
			</tr>
			<!-- tree 시작-->
			<tr width="100%">
				<td width="38%" id="sourceLayoutTd">
					<table id="sourceLayout"></table>
    			<div id="sourcePage"></div>
				</td>
				<td width="4%" align="center">
	
				</td>
				<td width="58%" id="targetLayoutTd">
					<table id="targetLayout"></table>
    			<div id="targetPage"></div>
				</td>
			</tr>
			<!-- tree 끝-->
			
		</table>
<iframe name=excelDown width=0 height=0></iframe>		
	</body>
</html>

