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
var url      = '<c:url value="/onl/transaction/online/transactionStatus.json" />';
var userId = window.dialogArguments["userId"];

function isValid(){

	return true;
}
function unformatterFunction(cellvalue, options, rowObject){
	var str = $('input:checkbox', rowObject).attr('checked');
	if (str=="checked"){
		return "true";
	}else{
		return "false";
	}

}

function formatterFunction(cellvalue, options, rowObject){
	var rowId = options["rowId"];
	var name  = options["colModel"]["name"];
// 	debugger;
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
		postData : { cmd : 'LIST_USER_BIZ' , userId : userId
		},
		colNames:['<input type="checkbox" id="chkCheck" checked="checked" />',
		          '업무구분코드',
	              '업무구분명'
	    ],
		colModel:[
			    { name : 'CHK'           , align:'center' , unformat: unformatterFunction, formatter: formatterFunction},
				{ name : 'EAIBZWKDSTCD'  , align:'left'   , key :true },
				{ name : 'BZWKDSTICNAME' , align:'left'   }
		],
		cmTemplate: {
			sortable: false,	
		},
        jsonReader: {
            repeatitems:false
        },	   
        rowNum: 10000,
	    height: '670',
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
// 			 console.log("EAIBZWKDSTCD=" + $("input[id=chkCHK"+data[i]['EAIBZWKDSTCD']+"]").prop("checked"))
			 var ischecked = $("input[id=chkCHK"+data[i]['EAIBZWKDSTCD']+"]").prop("checked");			 
			if (ischecked==false){
				continue;
			}
			gridData.push($("#grid").jqGrid('getRowData', data[i]['EAIBZWKDSTCD']));
		}
		
		
		var postData = new Array();
		postData.push({ name: "cmd"      , value:"TRANSACTION_USER_BIZ"});
		postData.push({ name: "userId"   , value:userId});
		postData.push({ name: "gridData" , value:JSON.stringify(gridData)});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("저장 되었습니다.");
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
	
// 	buttonControl();
	
});
 
</script>
</head>
	<body>
		<div class="popup_box">
			<div class="search_wrap">
				<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" />
				<img src="<c:url value="/img/btn_close.png"/>" alt="" id="btn_close" level="R" />						
			</div>
			<div class="title">업무구분선택</div>
			
			<table id="grid" ></table>
			<div id="pager"></div>
			
		</div><!-- end.popup_box -->
	</body>
</html>

