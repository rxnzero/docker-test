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
var url      = '<c:url value="/onl/transaction/extnl/interfaceMan.json" />';
var url_view = '<c:url value="/onl/transaction/extnl/interfaceMan.view" />';

var selectName = "searchEaiBzwkDstcd";	// selectBox Name

	function init( callback) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setNoValueInclude(true).setNoValue("","��ü").setData(json.bizList).setFormat(codeName3OptionFormat).rendering();
				
				setSearchable(selectName);	// �޺��� searchable ����

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
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
	}
	
	function search(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ url:url,postData: postData ,page:1 }).trigger("reloadGrid");
	}
	function ioFormatter(cellvalue,options,rowObject){
		var serviceType = sessionStorage["serviceType"];
		if(cellvalue == "I"){
			if(serviceType == "EAI") return "���";
			else if(serviceType =="FEP") return "Ÿ��";
		}else if(cellvalue =="O"){
			if(serviceType == "EAI") return "Ÿ��";
			else if(serviceType=="FEP") return "���";	

		}

	}
$(document).ready(function() {	
	init( detail);
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		//url : url,
		//postData : gridPostData,
		colNames : [ '��������',
		             'IF�����ڵ�',
		             '�������̽�ID����',
		             '�������̽�ID',
		             '��Ÿ�߱���',
		             '������û����',
		             '���ܺα���',
		             '��û',
		             '����',
		             '�����',
		             '������',
		             'DEVUSER',
		             'BANKUSER',
		              ],
		colModel : [ { name : 'EAIBZWKDSTCD'            , align : 'center' , width:'40'	,sortable:false},
		             { name : 'EAISVCNAME'              , align : 'left'   , width:'100'},
		             { name : 'EAISVCDESC'              , align : 'left'   },
		             { name : 'EAITRANNAME'             , align : 'left'   , width:'150'},
		             { name : 'IO'                      , align : 'center' , width:'50' , formatter:ioFormatter},
		             { name : 'SPLIZDMNDDSTCD'          , align : 'center' , width:'50' , edittype:'select',editoptions:{value:"S:��û;R:����"}, formatter:"select"},
		             { name : 'STNDTELGMWTINEXTNLDSTCD' , align : 'center' , width:'50' , edittype:'select',editoptions:{value:"1:����;2:�ܺ�"}, formatter:"select"},
		             { name : 'FROMNAME'                , align : 'center' , width:'40' },
		             { name : 'TONAME'                  , align : 'center' , width:'40' },
		             { name : 'CREATEBY'                , align : 'center' , width:'60' },
		             { name : 'UPDATEBY'                , align : 'center' , width:'60' },
		             { name : 'DEVUSERNAME'             , hidden:true },
		             { name : 'BANKUSERNAME'            , hidden:true } ],
		jsonReader : {
			repeatitems : false
		},
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : '${rmsDefaultRowNum}',
		autoheight : true,
		height : $("#container").height(),
		autowidth : true,
		viewrecords : true,
		rowList : eval('[${rmsDefaultRowList}]'),
		loadComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}
		},		
		ondblClickRow : function(rowId) {
			var rowData = $(this).getRowData(rowId);
			var key = rowData['EAISVCNAME'];
			var url2 = url_view;
			url2 += '?cmd=DETAIL';
			url2 += '&page=' + $(this).getGridParam("page");
			url2 += '&returnUrl=' + getReturnUrl();
			url2 += '&menuId=' + '${param.menuId}';
			//�˻���
			url2 += '&' + getSearchUrl();
			//key��
			url2 += '&eaiSvcName=' + key;
			goNav(url2);
		}
	});
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		search();
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=DETAIL';
		url2 += '&page='+$("#grid").getGridParam("page");
		url2 += '&returnUrl='+getReturnUrl();
        url2 += '&menuId='+'${param.menuId}';
		//�˻���
        url2 += '&'+getSearchUrl();
		//key��
        url2 += '&eaiSvcName=';
		
        goNav(url2);
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
		<div class="right_box">
			<div class="content_top">
				<ul class="path">
					<li><a href="#">${rmsMenuPath}</a></li>					
				</ul>						
			</div><!-- end content_top -->
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />				
				</div>
				<div class="title">�������̽�ID ����</div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">�������и�</th>
							<td>
								
									
										<select name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
										</select>
											
								
							</td>
							<th style="width:180px;">IF�����ڵ�</th>
							<td>
								<input type="text" name="searchEaiSvcName" value="${param.searchEaiSvcName}">
							</td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

