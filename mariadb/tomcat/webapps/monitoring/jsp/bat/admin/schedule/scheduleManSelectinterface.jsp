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

	var url      = '<c:url value="/bat/admin/schedule/scheduleMan.json" />';
	var url_view = '<c:url value="/bat/admin/schedule/scheduleMan.view" />';
	var workGrpCd= window.dialogArguments["workGrpCd"];
	var batchType= window.dialogArguments["batchType"];

	function init( callback ) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
				$("select[name=searchEaiBzwkDstcd]").val(workGrpCd);
				$("select[name=searchBatchType]").val(batchType);
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
		var postData = getSearchForJqgrid("cmd","LIST_INTERFACE"); //jqgrid������ object ��
		$("#grid").setGridParam({ url:url, postData: postData }).trigger("reloadGrid");
	}

$(document).ready(function() {	

	init( detail);
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['�������̽�ID',
	              '�������̽���',
	              '��뿩��'
	    ],
		colModel:[
				{ name : 'INTFID'   , align:'left'},
				{ name : 'INTFNAME' , align:'left'},
				{ name : 'DELYN'    , align:'center',
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '���';
                                 } else {
                                  	return '<span style="color:red">������</span>';
                                 }
                              }
				}
		],
                  
        jsonReader: {
            repeatitems:false
        },	          
		pager : $('#pager'),
		
		rowNum : '${rmsDefaultRowNum}',
	    autoheight: true,
	    height: $("#container").height(),
		autowidth: true,
		viewrecords: true,
		multiselect : true,
		rowList : eval('[${rmsDefaultRowList}]'),
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		detail();
	});
	
	$("#btn_close").click(function(){
		window.close();
	});

	$("#btn_insert").click(function(){

	    var data = $("#grid").getRowData();
	    if ( data.length < 1 ){
	    	alert('�߰��� �������̽��� ��ȸ�� �ּ���.!');
			return ;
	    }

	    var sel = $("#grid").jqGrid('getGridParam', 'selarrrow');
		if( sel.length < 1 ) {
			alert('�߰��� �������̽��� üũ�� �ּ���.!');
			return ;
		}
		
		var rtn = new Array();
		rtn.push($("select[name=searchEaiBzwkDstcd]").val());
		rtn.push($("select[name=searchBatchType]").val());
		for ( var i=0; i<sel.length;i++){
			rtn.push( data[sel[i]-1]['INTFID'] );
			rtn.push( data[sel[i]-1]['INTFNAME'] );
		}
		
		window.returnValue = rtn;
		window.close();
	});

	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
	buttonControl();
	
});
 
</script>
</head>
	<body>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">�������̽� ��� ��ȸ</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	
	<!-- comment -->
	<div class="container">
		<div class="left full" >
			<p class="comment" >�˻��� �������̽� ��ϸ� �����ϼ���.</p>
		</div>
	</div>
	
	<!-- button -->
	<table  width="100%" height="35px"  >
	<tr>
		<td align="left">
		<table width="100%">
		<tr>
			<td class="search_td_title" width="100px">�������и�</td>
			<td width="100px">
				<select name="searchEaiBzwkDstcd" style="width:100%"></select>
			</td>
			<td class="search_td_title" width="100px">��ġ�ŷ�����</td>
			<td width="100px">
				<select name="searchBatchType" style="width:100%">
					<option value="FF">FILE2FILE</option>
					<option value="DF">DB2FILE</option>
					<option value="DD">DB2DB</option>
					<option value="FD">FILE2DB</option>
				</select>
			</td>
		</tr>
		</table>
		</td>
		<td align="right" width="200px">
			<img id="btn_search" src="<c:url value="/images/bt/bt_search.gif"/>" level="R"/>
			<img id="btn_insert" src="<c:url value="/images/bt/bt_insert.gif"/>" level="R"/>
			<img id="btn_close" src="<c:url value="/images/bt/bt_close.gif"/>" level="R"/>
		</td>
	</tr>
	</table>	
	<!-- grid -->
	<table id="grid" ></table>
	<div id="pager"></div>
	</body>
</html>