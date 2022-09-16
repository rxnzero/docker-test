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
                  ],
		colModel:[
				{ name : 'id'          , hidden:true, key :true  },
				{ name : 'MENUID'      , hidden:true  },
				{ name : 'PRIORMENUID' , hidden:true  },
				{ name : 'SORTORDER'   , hidden:true  },
				{ name : 'MENUNAME'    , align:'left' ,width:300}
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
			var rowData = $(this).getRowData(rowId); 
			window.returnValue = rowData['id'];
			$("#btn_close").trigger("click");
			
        },		
		onSelectRow: function(rowId) {
       }
       
	    
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
			<img id="btn_modify" src="<c:url value="/img/btn_modify.png"/>" level="W"/>
			<img id="btn_close" src="<c:url value="/img/btn_close.png"/>"  level="R"/>
		</div>
		<div class="title"><%= localeMessage.getString("rolePop2.title") %></div>
		<!-- tree -->
		<table id="tree" ></table>
	</div>
	</body>
</html>

