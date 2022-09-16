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
var url = '<c:url value="/common/acl/user/userMan.json" />';
var userId = window.dialogArguments["userId"];

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
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : { cmd : 'LIST_USER_ROLE' , userId : userId
		},
		colNames:['<input type="checkbox" id="chkCheck"  />',
		          '<%= localeMessage.getString("role.id") %>',
	              '<%= localeMessage.getString("role.name") %>',
	              '<%= localeMessage.getString("role.description") %>'
	    ],
		colModel:[
			    { name : 'CHK'      , align:'center' ,unformat: unformatterFunction, formatter: formatterFunction},
				{ name : 'ROLEID'   , align:'left'  ,key :true },
				{ name : 'ROLENAME' , align:'left'  },
				{ name : 'ROLEDESC' , align:'left'  }
		],
		cmTemplate: {
			sortable: false,	
		},
        jsonReader: {
            repeatitems:false
        },	 
        rowNum: 10000,  
	    height: '500',
		autowidth: true,
		viewrecords: true,
		ondblClickRow: function(rowId) {
           
       }	
       
	    
	});
	$("#chkCheck").click(function(e){
	   e = e || event;/* get IE event ( not passed ) */
	   e.stopPropagation ? e.stopPropagation() : e.cancelBubble = false;
	   $("input[id*=chkCHK]").prop("checked",$(this).is(":checked"));
		
	});

	$("#btn_modify").click(function(){
		if (!isValid()){
			return;
		}
	    var data = $("#grid").getRowData();
		var gridData                = new Array();
		
		for (var i = 0; i <data.length; i++) {
			if (data[i]['CHK'] == "false") continue;
			gridData.push($("#grid").jqGrid('getRowData', data[i]['ROLEID']));
		}
		
		
		var postData = new Array();
		postData.push({ name: "cmd"      , value:"TRANSACTION_USER_ROLE"});
		postData.push({ name: "userId"   , value:userId});
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

	
	<!-- button -->
	<table  width="95%" height="35px"  align="center">
	<tr>
		<td align="left" height="25px"><p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>"><%= localeMessage.getString("userPop.title") %></p></td>
		<td align="right">
			<img id="btn_modify" src="<c:url value="/images/bt/bt_modify.gif"/>" level="W"/>
			<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>"  level="R"/>
		</td>
	</tr>
	</table>	
	<!-- line -->
	<div class="container" id="line">
		<div class="left full title_line "> </div>
	</div>	
	<!-- grid -->
	<table id="grid" ></table>
	<div id="pager"></div>	
	</body>
</html>

