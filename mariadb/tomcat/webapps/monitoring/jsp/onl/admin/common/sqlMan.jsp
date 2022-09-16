<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
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
var url ='<c:url value="/onl/admin/common/sqlMan.json" />';

var returnUrl = getReturnUrlForReturn();
var roleString	= "<%=SessionManager.getRoleIdString(request)%>";

var selectName = "functionCombo";	// selectBox Name

function getSourceResult(cnvsnName){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd : 'LIST_TRANSFORM_SOURCE_RESULT', cnvsnName : cnvsnName},
		success:function(json){
			var data = json.rows;
			var src = null;
			var tgt = null;;
			var srcDesc = null;
			var tgtDesc = null;
			for ( var i = 0; i < data.length; i++) {
				if (data[i]['SOURCRSULTDSTCD'] == 'SRC_LAYOUT' ){
					src = data[i]['LOUTNAME'];
					srcDesc = data[i]['LOUTDESC'];
					$("input[name=srcLayout]").val(src);
					$("input[name=srcLayoutDesc]").val(srcDesc);
				}else if (data[i]['SOURCRSULTDSTCD'] == 'TGT_LAYOUT' ){
					tgt = data[i]['LOUTNAME'];
					tgtDesc = data[i]['LOUTDESC'];
					$("input[name=tgtLayout]").val(tgt);
					$("input[name=tgtLayoutDesc]").val(tgtDesc);
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

function addGroupTag(group,data){
	var result = data;
	var datas = data.split(".");
    var comp = datas[0];
    var arr = new Array();

	for(var i=1;i<datas.length;i++){
		comp = comp +"." +datas[i];
		if (group[comp] != undefined){
			//값이 있음
			arr.push(comp);
		}
	}
	for(var i=arr.length;i > 0;i--){
		var a =  arr.pop();
		result = result.substr(0,result.indexOf(a)+a.length) + "[*]"+ result.substring(result.indexOf(a)+a.length);
	}

	return result;
}

function setTgtCell(){
	var rowId = tgtGrid.getGridParam( "selrow" );
	tgtGrid.jqGrid('setCell',rowId,'CNVSNRSULTITEMPATHNAME',$('textarea[name=CNVSNRSULTITEMPATHNAME]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNCMDNAME',$('textarea[name=CNVSNCMDNAME]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMBASCVAL',$('input[name=CNVSNITEMBASCVAL]').val() == "" ? null : $('input[name=CNVSNITEMBASCVAL]').val());
	tgtGrid.jqGrid('setCell',rowId,'CNVSNITEMSERNO',$('input[name=CNVSNITEMSERNO]').val());	
}
function detail(key)
{
	//sub combo
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd : 'LIST_TRANSFORM4EAISVCNAME_COMBO',eaiSvcName : key},
		success:function(json){				
			$("select[name=transformForEaiSvcNameCombo]").html('');

			//transform combo 
			new makeOptions("CODE","NAME").setObj($("select[name=transformForEaiSvcNameCombo]")).setData(json.rows).setFormat(codeName3OptionFormat).setAttr("desc","NAME").rendering();
			
			//첫번째 select 가 선택되야 됨
			$("select[name=transformForEaiSvcNameCombo]").first().change();
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

//var layoutArgs = new Object(); //임시 주석처리sh

function isValidSrc() {
	var isJndiName = $(':radio[name="isJndiname"]:checked').val();
	var jndiName = $('input[name="jndiname"]').val();
	var driver = $('input[name="driver"]').val();
	var jdbcUrl = $('input[name="jdbcUrl"]').val();
	var username = $('input[name="username"]').val();
	var password = $('input[name="password"]').val();
	var schema = $('input[name="schema"]').val();
	
	if(isJndiName === 'true') {
		if(isEmpty(jndiName)) {
			alert('원천 Connection의 JndiName을 입력하여 주십시요.');
			return false;
		}
	} else {
		if(isEmpty(driver)) {
			alert('원천 Connection의 Jdbc driver를 입력하여 주십시요.');
			return false;
		}
		if(isEmpty(jdbcUrl)) {
			alert('원천 Connection의 url을 입력하여 주십시요.');
			return false;
		}
		if(isEmpty(username)) {
			alert('원천 Connection의 사용자명을 입력하여 주십시요.');
			return false;
		}
		if(isEmpty(password)) {
			alert('원천 Connection의 비밀번호를 입력하여 주십시요.');
			return false;
		}
	}
	if(isEmpty(schema)) {
		alert('원천 Connection의 스키마를 입력하여 주십시요.');
		return false;
	}
	return true;
}

function isValidTarget() {
	var isJndiName = $(':radio[name="tg_isJndiname"]:checked').val();
	var jndiName = $('input[name="tg_jndiname"]').val();
	var driver = $('input[name="tg_driver"]').val();
	var jdbcUrl = $('input[name="tg_jdbcUrl"]').val();
	var username = $('input[name="tg_username"]').val();
	var password = $('input[name="tg_password"]').val();
	var schema = $('input[name="tg_schema"]').val();
	
	if(isJndiName === 'true') {
		if(isEmpty(jndiName)) {
			alert('타겟 Connection의 JndiName을 입력하여 주십시요.');
			return false;
		}
	} else {
		if(isEmpty(driver)) {
			alert('타겟 Connection의 Jdbc driver를 입력하여 주십시요.');
			return false;
		}
		if(isEmpty(jdbcUrl)) {
			alert('타겟 Connection의 url을 입력하여 주십시요.');
			return false;
		}
		if(isEmpty(username)) {
			alert('타겟 Connection의 사용자명을 입력하여 주십시요.');
			return false;
		}
		if(isEmpty(password)) {
			alert('타겟 Connection의 비밀번호를 입력하여 주십시요.');
			return false;
		}
	}
	if(isEmpty(schema)) {
		alert('타겟 Connection의 스키마를 입력하여 주십시요.');
		return false;
	}
	return true;
}

function getPostData() {
	var isJndiname = $(':radio[name="isJndiname"]:checked').val();
	var jndiname = $('input[name="jndiname"]').val();
	var driver = $('input[name="driver"]').val();
	var jdbcUrl = $('input[name="jdbcUrl"]').val();
	var username = $('input[name="username"]').val();
	var password = $('input[name="password"]').val();
	var schema = $('input[name="schema"]').val();
	var postData = {};
	postData["cmd"] = "LIST";
	postData["isJndiname"] = isJndiname;
	postData["jndiname"] = isEmpty(jndiname) ? "" : jndiname;
	postData["driver"] = isEmpty(driver) ? "" : driver;
	postData["jdbcUrl"] = isEmpty(jdbcUrl) ? "" : jdbcUrl;
	postData["username"] = isEmpty(username) ? "" : username;
	postData["password"] = isEmpty(password) ? "" : password;
	postData["schema"] = schema;
	
	return postData;
}

function tableListPop(tableName, schemaName, tableDesc, gridObj, args)
{
	var urlPopup='<c:url value="/onl/admin/common/sqlMan.view"/>';
    urlPopup = urlPopup + "?cmd=POPUP";

    var result = showModal(urlPopup,args,800,708, function(arg){
    	var rtnArgs = null;
        if(arg == null || arg == undefined ) {//chrome
            rtnArgs = this.dialogArguments;
            rtnArgs.returnValue = this.returnValue;
        } else {//ie
            rtnArgs = arg;
        }
        
        if( !rtnArgs || !rtnArgs.returnValue ) return;
        
        var result = rtnArgs.returnValue;
        
        if( result ) {
        	$("input[name=" + tableName + "]").val(result.tableName);
        	$("input[name=" + schemaName + "]").val(result.schema);
        	$("input[name=" + tableDesc + "]").val(result.tableDesc);
        	
        	var postData = getPostData();
        	postData["tablename"] = result.tableName;
        	
        	gridObj.setGridParam( {url :url ,postData: postData }).trigger("reloadGrid");
        }
    	
    });
}

function unformattercheckFunction(cellvalue, options, rowObject){
	var str = $('input:checkbox', rowObject).attr('checked');
	if (str=="checked"){
		return "true";
	}else{
		return "false";
	}
}

function formattercheckFunction(cellvalue, options, rowObject){
	var rowId = options["rowId"];
	var name  = options["colModel"]["name"];
	var gridName = $(this)[0].id;
	if(gridName === 'sourceTable') name = 'src'+name;
	else name = 'tg' + name;
	if (cellvalue == "true"){
		return "<input type ='checkbox' id ='chk"+name + rowId + "' checked='checked' />";
	}else if (cellvalue == "false"){
        return "<input type ='checkbox' id ='chk"+name + rowId + "' />";     
	}else{
		return "";
	}
}

function formatterinputFunction(cellvalue, options, rowObject){
	var rowId = options["rowId"];
	var name  = options["colModel"]["name"];
	var gridName = $(this)[0].id;
	if(gridName === 'sourceTable') name = 'src'+name;
	else name = 'tg' + name;
	return "<input type ='text' id ='input"+name + rowId + "' style='padding:0px;width:100px;'/>";
}

$(document).ready(function() {	
	resizeContentWidth("content_middle");

	srcGrid = $("#sourceTable");
	srcGrid.jqGrid({
	    datatype:'json',
	    loadui: "disable",
	    mtype: 'POST',
	    colNames: ["id","컬럼명","컬럼설명","데이터타입","컬럼크기","NULL허용", "Key", "Mark"],
	    colModel: [
	        {name: "id"				, hidden:true, key:true},
	        {name: "column_name"	, width:"150"},
	        {name: "remarks"		, width:"80"},
	        {name: "type_name"		, width:"80"},
	        {name: "column_size"	, width:"70"},
	        {name: "is_nullable"	, width:"70"},
	        {name: "key"			, width:"40", align:'center' , unformat: unformattercheckFunction, formatter: formattercheckFunction},
	        {name: "mark"			, width:"40", align:'center' , unformat: unformattercheckFunction, formatter: formattercheckFunction}
			],
	    treeGrid: true,
	    treeGridModel: "adjacency",
	    ExpandColumn: "column_name",
	    height:"230",
	    rowNum: 10000,

	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    }
	});
	tgtGrid = $("#targetTable");
	tgtGrid.jqGrid({
	    datatype:'json',
	    loadui: "disable",
	    mtype: 'POST',
	    colNames: ["id","컬럼명","컬럼설명","데이터타입","컬럼크기","NULL허용", "Key", "원천 컬럼명", "디폴트"],
	    colModel: [
	        {name: "id"				, hidden:true, key:true},
	        {name: "column_name"	, width:"150"},
	        {name: "remarks"		, width:"80"},
	        {name: "type_name"		, width:"80"},
	        {name: "column_size"	, width:"70"},
	        {name: "is_nullable"	, width:"70"},
	        {name: "key"			, width:"40", align:'center' , unformat: unformattercheckFunction, formatter: formattercheckFunction},
	        {name: "src_column_name", width:"150"},
	        {name: "default"	, width:"100", formatter: formatterinputFunction}
	    ],
	    treeGrid: true,
		treeIcons : {
			plus: "ui-icon-circlesmall-plus",
			minus: "ui-icon-circlesmall-minus",
			leaf : "ui-icon-document"
		},		    
	    treeGridModel: "adjacency",
	    ExpandColumn: "column_name",
	    height:"230",
	    rowNum: 10000,
	    jsonReader: {
	        repeatitems: false
	    }
	});
	
	$("#btn_searchSrcTable").click(function(){
		// check validation
		if(!isValidSrc()) return;
		
		var args = new Object();
		var isJndiName = $(':radio[name="isJndiname"]:checked').val();
		args['isJndiName'] = isJndiName;
		args['schema'] = $('input[name="schema"]').val();
		if(isJndiName === 'true') {
			args['jndiname'] = $('input[name="jndiname"]').val();
		} else {
			args['driver'] = $('input[name="driver"]').val();
			args['jdbcUrl'] = $('input[name="jdbcUrl"]').val();
			args['username'] = $('input[name="username"]').val();
			args['password'] = $('input[name="password"]').val();
		}
		tableListPop("srcTable", "srcResultSchema", "srcTableDesc", srcGrid, args);
	});
	$("#btn_searchTgtTable").click(function(){
		// check validation
		if(!isValidTarget()) return;
		
		var args = new Object();
		var isJndiName = $(':radio[name="tg_isJndiname"]:checked').val();
		args['isJndiName'] = isJndiName;
		args['schema'] = $('input[name="tg_schema"]').val();
		if(isJndiName === 'true') {
			args['jndiname'] = $('input[name="tg_jndiname"]').val();
		} else {
			args['driver'] = $('input[name="tg_driver"]').val();
			args['jdbcUrl'] = $('input[name="tg_jdbcUrl"]').val();
			args['username'] = $('input[name="tg_username"]').val();
			args['password'] = $('input[name="tg_password"]').val();
		}
		tableListPop("tgtTable", "tgResultSchema", "tgtTableDesc", tgtGrid, args);
	});
	$("#btn_make_sql").click(function(){
		var targetData = tgtGrid.getRowData();
	 	if (targetData == null || targetData.length == 0) {alert("타겟컬럼이 존재하지 않습니다.");return;}
	 	
	 	// source key & Mark check 여부
	 	var sourceData = srcGrid.getRowData();
	 	var src_keys = new Array();
	 	var src_marks = new Array();
	 	var src_chkkey = "";
	 	var src_chkmark = "";
	 	for ( var i = 0; i < sourceData.length; i++) {
	 		src_chkkey = "chksrckey"+i;
	 		src_chkmark = "chksrcmark"+i;
	 		if($('input[id="'+src_chkkey+'"]').is(":checked")) src_keys.push(sourceData[i]['column_name']);
	 		if($('input[id="'+src_chkmark+'"]').is(":checked")) src_marks.push(sourceData[i]['column_name']);
		}
		
		if(src_keys == null || src_keys.length == 0) {alert("원천 Table의 Key를 선택하세요.");return;}
	 	if(src_marks == null || src_marks.length == 0) {alert("원천 Table의 Mark를 선택하세요.");return;}
	 	if(src_marks.length > 1) {alert("원천 Table의 Mark를 하나만 선택하세요.");return;}
	 	
	 	// targert key & Mark check 여부
	 	var tg_keys = new Array();
	 	var tg_chkkey = "";
	 	var tg_default = "";
	 	
		//for select sql of source table
		var select_columns = "";
		
		//taget table insert sql
		var tg_insert_columns = "";
		var tg_insert_data = "";
		
		//taget table update sql
		var tg_update_columns = "";
		
	 	for ( var i = 0; i < targetData.length; i++) {
	 		tg_chkkey = "chktgkey"+i;
	 		tg_default = "inputtgdefault"+i;
	 		if($('input[id="'+tg_chkkey+'"]').is(":checked")) tg_keys.push(targetData[i]['column_name']);
	 		
	 		//for select sql of source table
	 		if(!isEmpty(targetData[i]['src_column_name']))
				select_columns += targetData[i]['src_column_name']+",";
	 		
	 		// for insert sql of target table
			if(!isEmpty(targetData[i]['src_column_name']) || targetData[i]['is_nullable'] === 'NO' 
				|| (targetData[i]['is_nullable'] === 'YES' && !isEmpty($('input[id="'+tg_default+'"]').val()))) {
				tg_insert_columns += targetData[i]['column_name'] + ",";
				if(!isEmpty(targetData[i]['src_column_name'])) {	// 원천 컬럼명이 있으면
					tg_insert_data += "#"+"{" + targetData[i]['src_column_name'] +"},";
				} else {											// 원천 컬럼명이 없으면
					if(isEmpty($('input[id="'+tg_default+'"]').val())) {
						var msg = "타겟 Table의 컬럼 [" + targetData[i]['column_name'] + "]은 NULL을 허용하지 않습니다.\n원천 컬럼명이나 디폴트값을 설정하세요.";
						alert(msg);
						return;
					}
					tg_insert_data += "'"+ $('input[id="'+tg_default+'"]').val() +"',";
				}
			}
			
			// for update sql of target table
			if(!isEmpty(targetData[i]['src_column_name'])) {
				tg_update_columns += targetData[i]['column_name'] + "=#"+"{" + targetData[i]['src_column_name'] +"},";
			}
			if(!isEmpty($('input[id="'+tg_default+'"]').val())) {
				tg_update_columns += targetData[i]['column_name'] + "='" + $('input[id="'+tg_default+'"]').val() +"',";
			}
		}

		if(tg_keys == null || tg_keys.length == 0) {alert("타겟 Table의 Key를 선택하세요.");return;}
		
		// for insert sql of target table
		tg_insert_columns = tg_insert_columns.substring(0, tg_insert_columns.length-1);
		tg_insert_data = tg_insert_data.substring(0, tg_insert_data.length-1);
		// for update sql of target table
		tg_update_columns = tg_update_columns.substring(0, tg_update_columns.length-1);
	 	
		if(isEmpty(select_columns)) {alert("타겟 Table에 맵핑된 원천 컬럼이 존재하지 않습니다.");return;}
		select_columns = select_columns.substring(0, select_columns.length-1);
		
		var src_sql_select = "SELECT " + select_columns + " FROM " + $('input[name="srcResultSchema"]').val() + "." + $('input[name="srcTable"]').val()
			+ " WHERE " + src_marks[0] + " = 'N' OR " + src_marks[0] + " IS NULL";
		$('textarea[name="src_sql_select"]').val(src_sql_select);
		
		var src_sql_update = "UPDATE " + $('input[name="srcResultSchema"]').val() + "." + $('input[name="srcTable"]').val()
				+ " SET " + src_marks[0] + " = 'Y' "
				+ " WHERE " + src_keys[0] + " = #" + "{" + src_keys[0] + "} ";
		if(src_keys.length > 1) {
			for(var i=1; i<src_keys.length; i++) {
				src_sql_update += "AND " + src_keys[i] + " = #" + "{" + src_keys[i] + "} ";
			}
		}
		$('textarea[name="src_sql_update"]').val(src_sql_update);
			
		var tg_insert_sql = "INSERT INTO " + $('input[name="tgResultSchema"]').val() + "." + $('input[name="tgtTable"]').val() + " ("
			+ tg_insert_columns + ") VALUES (" + tg_insert_data + ")";
			
		if(!isEmpty(tg_insert_sql)) $('textarea[name="tg_sql_insert"]').val(tg_insert_sql);
		
		var tg_update_sql = "UPDATE " + $('input[name="tgResultSchema"]').val() + "." + $('input[name="tgtTable"]').val() 
			+ " SET " + tg_update_columns
			+ " WHERE " + tg_keys[0] + " = #" + "{" + tg_keys[0] + "} ";
		if(tg_keys.length > 1) {
			for(var i=1; i<tg_keys.length; i++) {
				tg_update_sql += "AND " + tg_keys[i] + " = #" + "{" + tg_keys[i] + "} ";
			}
		}
		if(!isEmpty(tg_update_sql)) $('textarea[name="tg_sql_update"]').val(tg_update_sql);
	});
	
	$("input[name=auto]").click(function(){
	    var sourceData = srcGrid.getRowData();
	    var targetData = tgtGrid.getRowData();
	 	if (sourceData == null || sourceData.length == 0) {alert("소스컬럼이 존재하지 않습니다.");return;}
	 	if (targetData == null || targetData.length == 0) {alert("타겟컬럼이 존재하지 않습니다.");return;}

		for ( var i = 0; i < sourceData.length; i++) {
			for (var j = 0; j <targetData.length; j++) {
				if (targetData[j]['column_name'] == sourceData[i]['column_name']) {
					var rowId = targetData[j]['id'];
					tgtGrid.jqGrid('setCell',rowId,'src_column_name',sourceData[i]['column_name']);
					break;
				}
			}
		}
	});
	
	$("input[name=add]").click(function(){
		var srcRowId = srcGrid.getGridParam( "selrow" );
	 	var tgtRowId = tgtGrid.getGridParam( "selrow" );
	 	if (srcRowId == null) {alert("소스컬럼을 선택하여 주십시요.");return;}
	 	if (tgtRowId == null) {alert("타겟컬럼을 선택하여 주십시요.");return;}
	 	
	 	//field 여부 판단
	 	var sourceRow = srcGrid.getRowData( srcRowId );
	 	var targetRow = tgtGrid.getRowData( tgtRowId );

	 	tgtGrid.jqGrid('setCell',tgtRowId,'src_column_name',sourceRow["column_name"]);
	    tgtGrid.jqGrid('setSelection', tgtRowId, true);
	});
	
	$("input[name=addAll]").click(function(){
	 	//grid data
	    var sourceData = srcGrid.getRowData();
	    var targetData = tgtGrid.getRowData();
	 	if (sourceData == null || sourceData.length == 0) {alert("소스컬럼이 존재하지 않습니다.");return;}
	 	if (targetData == null || targetData.length == 0) {alert("타겟컬럼이 존재하지 않습니다.");return;}

		for ( var i = 0; i < targetData.length; i++) {
			if (sourceData.length == i) break;
			var rowId = targetData[i]['id'];
			tgtGrid.jqGrid('setCell',rowId,'src_column_name',sourceData[i]['column_name']);
	 	}
	});
	
	$("input[name=remove]").click(function(){
	 	var tgtRowId = tgtGrid.getGridParam( "selrow" );
	 	if (tgtRowId == null) {alert("타겟컬럼을 선택하여 주십시요.");return;}
	 	tgtGrid.jqGrid('setCell',tgtRowId,'src_column_name',null);
	    tgtGrid.jqGrid('setSelection', tgtRowId, true);
	 	
	});	
	$("input[name=removeAll]").click(function(){
		//grid data
		var targetData = tgtGrid.getRowData();
	 	if (targetData == null) {alert("타겟컬럼이 존재하지 않습니다.");return;}

		for ( var i = 0; i < targetData.length; i++) {
			var rowId = targetData[i]['id'];
			tgtGrid.jqGrid('setCell',rowId,'src_column_name',null);
	 	}
	});	
	
	$('input[name="isJndiname"]').change(function(){
		if($(':radio[name="isJndiname"]:checked').val() === 'true') {
			$("input[name='jndiname']").removeAttr('readonly');
			$("input[name='driver']").attr('readonly', true);
			$("input[name='jdbcUrl']").attr('readonly', true);
			$("input[name='username']").attr('readonly', true);
			$("input[name='password']").attr('readonly', true);
		} else {
			$("input[name='jndiname']").attr('readonly', true);
			$("input[name='driver']").removeAttr('readonly');
			$("input[name='jdbcUrl']").removeAttr('readonly');
			$("input[name='username']").removeAttr('readonly');
			$("input[name='password']").removeAttr('readonly');
		}
	});
	
	$('input[name="tg_isJndiname"]').change(function(){
		if($(':radio[name="tg_isJndiname"]:checked').val() === 'true') {
			$("input[name='tg_jndiname']").removeAttr('readonly');
			$("input[name='tg_driver']").attr('readonly', true);
			$("input[name='tg_jdbcUrl']").attr('readonly', true);
			$("input[name='tg_username']").attr('readonly', true);
			$("input[name='tg_password']").attr('readonly', true);
		} else {
			$("input[name='tg_jndiname']").attr('readonly', true);
			$("input[name='tg_driver']").removeAttr('readonly');
			$("input[name='tg_jdbcUrl']").removeAttr('readonly');
			$("input[name='tg_username']").removeAttr('readonly');
			$("input[name='tg_password']").removeAttr('readonly');
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
				<div class="title"><%= localeMessage.getString("sqlMan.title") %></div>
				<!-- tree -->
				<table style="width:100%;">
				<tr>					
					<td style="width:40%; vertical-align:top;">
						<table class="table_row" cellspacing="0">
							<tr>			
								<th style="text-align: center;height: 30px; border-right:1px solid #a3a9b1;" colspan='2'>원천 Connection</th>				
							</tr>
							<tr>
								<th style="width:130px;">Connection Type</th>
								<td>
									<input type="radio" name="isJndiname" value="true" id="isJndinameTrue" checked><label for="isJndinameTrue">JndiName</label>
									<input type="radio" name="isJndiname" value="false" id="isJndinameFalse"><label for="isJndinameFalse">Jdbc driver</label>
								</td>								
							</tr>
							<tr>
								<th>JndiName</th>
								<td>
									<input type="text" name="jndiname" value="java:/comp/env/jdbc/dsCHN_fep"/>
								</td>								
							</tr>
							<tr>
								<th>Jdbc driver</th>
								<td>
									<input type="text" name="driver" readonly="readonly" value="org.postgresql.Driver"/>
								</td>								
							</tr>
							<tr>
								<th>url</th>
								<td>
									<input type="text" name="jdbcUrl" readonly="readonly" value="jdbc:postgresql://localhost:5432/tk_fepdev"/>
								</td>								
							</tr>
							<tr>
								<th>사용자명</th>
								<td>
									<input type="text" name="username" readonly="readonly" value="tk_fepdev"/>
								</td>								
							</tr>
							<tr>
								<th>비밀번호</th>
								<td>
									<input type="text" name="password" readonly="readonly" value="tk_fepdev"/>
								</td>								
							</tr>
							<tr>
								<th>스키마</th>
								<td>
									<input type="text" name="schema" value="tk_fepdev"/>
								</td>								
							</tr>
						</table>
						
						<table class="table_row" cellspacing="0">
							<tr>
								<th style="width:130px;">원천 Table</th>
								<td>
									<input type="hidden" name="srcResultSchema">
									<input type="text" name="srcTable" style="width:calc(100% - 70px)" readonly="readonly">
									<img id="btn_searchSrcTable" src="<c:url value="/img/btn_pop_search.png"/>" level="R" class="btn_img" />
								</td>								
							</tr>
							<tr>
								<th>원천 Table 설명</th>
								<td>
									<input type="text" name="srcTableDesc" readOnly>
								</td>
							</tr>
						</table>
						<div id="sourceTableTd" style="margin-bottom:15px;max-height:260px; overflow-y:auto;">
							<table id="sourceTable"></table>
							<div id="sourcePage"></div>
						</div>
						<div style="margin-bottom:5px;height:25px;">
							<img id="btn_make_sql" src="<c:url value="/img/btn_pop_operate.png" />"level="R" class="btn_img" />
						</div>
						<table class="table_row" cellspacing="0">
							<tr height="75px">
								<th style="width:130px;">원천 TABLE SELECT</th>
								<td><textarea  name="src_sql_select" style="width:100%; height:90%;"></textarea></td>
							</tr>
							<tr height="75px">
								<th style="width:130px;">원천 TABLE UPDATE</th>
								<td><textarea  name="src_sql_update" style="width:100%; height:90%;"></textarea></td>
							</tr>
						</table>
					</td>
					<td style="text-align:center;">
						<input type=button name="auto" class="btn_img btn_auto" /><br><br>
						<input type=button name="add" class="btn_img btn_add"/><br><br>
						<input type=button name="addAll" class="btn_img btn_addAll"/><br><br>
						<input type=button name="remove" class="btn_img btn_remove"/><br><br>
						<input type=button name="removeAll" class="btn_img btn_removeAll"/>
					</td>
					<td style="width:40%; vertical-align:top;">
						<table class="table_row" cellspacing="0">
							<tr>			
								<th style="text-align: center;height: 30px; border-right:1px solid #a3a9b1;" colspan='2'>타겟 Connection</th>				
							</tr>
							<tr>
								<th style="width:130px;">Connection Type</th>
								<td>
									<input type="radio" name="tg_isJndiname" value="true" id="tg_isJndinameTrue" checked><label for="tg_isJndinameTrue">JndiName</label>
									<input type="radio" name="tg_isJndiname" value="false" id="tg_isJndinameFalse"><label for="tg_isJndinameFalse">Jdbc driver</label>
								</td>								
							</tr>
							<tr>
								<th>JndiName</th>
								<td>
									<input type="text" name="tg_jndiname" value="java:/comp/env/jdbc/dsCHN_fep"/>
								</td>								
							</tr>
							<tr>
								<th>Jdbc driver</th>
								<td>
									<input type="text" name="tg_driver" readonly="readonly"/>
								</td>								
							</tr>
							<tr>
								<th>url</th>
								<td>
									<input type="text" name="tg_jdbcUrl" readonly="readonly"/>
								</td>								
							</tr>
							<tr>
								<th>사용자명</th>
								<td>
									<input type="text" name="tg_username" readonly="readonly"/>
								</td>								
							</tr>
							<tr>
								<th>비밀번호</th>
								<td>
									<input type="text" name="tg_password" readonly="readonly"/>
								</td>								
							</tr>
							<tr>
								<th>스키마</th>
								<td>
									<input type="text" name="tg_schema" value="tk_fepdev"/>
								</td>								
							</tr>
						</table>
						
						<table class="table_row" cellspacing="0">
							<tr>
								<th style="width:130px;">타겟 Table</th>
								<td>
									<input type="hidden" name="tgResultSchema">
									<input type="text" name="tgtTable" style="width:calc(100% - 70px)" readonly="readonly">
									<img id="btn_searchTgtTable" src="<c:url value="/img/btn_pop_search.png" />"level="R" class="btn_img" />
								</td>								
							</tr>
							<tr>
								<th>타겟 Table 설명</th>
								<td>
									<input type="text" name="tgtTableDesc" readOnly>									
								</td>
							</tr>
						</table>
						<div id="targetTableTd" style="margin-bottom:15px;max-height:260px; overflow-y:auto;">
							<table id="targetTable"></table>
							<div id="targetPage"></div>
						</div>
						<div style="margin-bottom:5px;height:25px;">
						</div>
						<table class="table_row" cellspacing="0">
							<tr height="75px">
								<th style="width:130px;">타겟 TABLE INSERT</th>
								<td><textarea  name="tg_sql_insert" style="width:100%; height:90%;"></textarea></td>
							</tr>
							<tr height="75px">
								<th style="width:130px;">타겟 TABLE UPDATE</th>
								<td><textarea  name="tg_sql_update" style="width:100%; height:90%;"></textarea></td>
							</tr>
						</table>
					</td>
				</tr>	
				</table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

