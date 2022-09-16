<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
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
var roleId = window.dialogArguments["roleId"];

function isValid(){

	return true;
}
function unformatterFunction(cellvalue, options, rowObject){
    return $('input:checkbox', rowObject).is(':checked') ? "true" : "false";
    
}

function formatterFunction(cellvalue, options, rowObject){
	var rowId = options["rowId"];
	var name  = options["colModel"]["name"];
	
	if (cellvalue == "true"){
		return "<input type ='checkbox' id ='chk"+name + rowId + "' checked='checked' />";
	}else if (cellvalue == "false"){
        return "<input type ='checkbox' id ='chk"+name + rowId + "' />";     
	}else{
		return "";
	}
}


$(document).ready(function() {	
	$('#tree').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/common/acl/role/roleMan.json" />',
		postData : { cmd : 'LIST_TREE',roleId : roleId},
		colNames:['id',
		          'MENUID',
                  'PRIORMENUID',
                  'SORTORDER',
                  'MENUNAME',
                  '<input type="checkbox" id="chkRead"  />Read',
                  '<input type="checkbox" id="chkWrite" />R/W'
                  ],
		colModel:[
				{ name : 'id'          , hidden:true, key :true  },
				{ name : 'MENUID'      , hidden:true  },
				{ name : 'PRIORMENUID' , hidden:true  },
				{ name : 'SORTORDER'   , hidden:true  },
				{ name : 'MENUNAME'    , align:'left' ,width:300},
				{ name : 'READ'        , align:'center',width:70 ,unformat: unformatterFunction, formatter: formatterFunction  },
				{ name : 'WRITE'       , align:'center',width:80 ,unformat: unformatterFunction, formatter: formatterFunction}
		],
	    treeGrid: true,
		treeIcons : {
			plus: "ui-icon-circlesmall-plus",
			minus: "ui-icon-circlesmall-minus",
			leaf : "ui-icon-document"
		},
		cmTemplate: {
			sortable: false,	
		},
	    treeGridModel: "adjacency",
	    ExpandColumn: "MENUNAME",
	    height:"500",
	    width:"445",
	    rowNum: 10000,
	    treeIcons: {leaf:'ui-icon-document-b'},
	    jsonReader: {
	        repeatitems: false
	    },
	    loadComplete:function (d){
	    },	    
		ondblClickRow: function(rowId) {
        },		
		onSelectRow: function(rowId) {
       }
       
	    
	});

	$("#chkRead").click(function(e){
	   e = e || event;/* get IE event ( not passed ) */
	   e.stopPropagation ? e.stopPropagation() : e.cancelBubble = false;
	   $("input[id*=chkREAD]").prop("checked",$(this).is(":checked"));
		
	});
	$("#chkWrite").click(function(e){
		   e = e || event;/* get IE event ( not passed ) */
		   e.stopPropagation ? e.stopPropagation() : e.cancelBubble = false;
		   $("input[id*=chkWRITE]").prop('checked', $(this).is(":checked"));
		   
			
		});	
	$("#btn_modify").click(function(){
		if (!isValid()){
			return;
		}
		var url ='<c:url value="/common/acl/role/roleMan.json" />';
		
		
	    var data = $("#tree").getRowData();
		var gridData                = new Array();
		
		
		for (var i = 0; i <data.length; i++) {
			if (data[i]['level'] != "3") continue;
			gridData.push($("#tree").jqGrid('getRowData', data[i]['id']));
		}
		
		var postData = new Array();
		postData.push({ name: "cmd"      , value:"TRANSACTION_ROLE_MENU"});
		postData.push({ name: "roleId"   , value:roleId});
		postData.push({ name: "gridData" , value:JSON.stringify(gridData)});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("<%= localeMessage.getString("common.saveMsg") %>");
				$("#btn_close").trigger("click");
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("#btn_close").click(function(){
		window.close();
	});
	
	buttonControl();
	
});
 
</script>
</head>
	<body>
		<div class="popup_box">
			<div class="search_wrap">
				<img id="btn_modify" src="<c:url value="/img/btn_modify.png"/>" level="W">
				<img id="btn_close" src="<c:url value="/img/btn_close.png"/>" level="R">
			</div>
			<div class="title"><%= localeMessage.getString("rolePop.title") %></div>
			<table id="tree" ></table>
		</div><!-- end.popup_box -->
	</body>
</html>

