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
var url      = '<c:url value="/onl/admin/service/fieldExtractInfoMan.json" />';
var url_view = '<c:url value="/onl/admin/service/fieldExtractInfoMan.view" />';

var select_ETRACTDSTCD     = new Array();

function init(callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			select_ETRACTDSTCD['value'] = getGridSelectText("CODE","NAME",json.exrClassTypeList);
			gridRendering();
			if(typeof callback === 'function') {
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
	$("#grid").setGridParam({ url:url,postData: postData ,datatype:'json' }).trigger("reloadGrid");

}
function gridRendering(){
	$('#grid').jqGrid({
		datatype:'local',
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['IF�����ڵ�',
                  '���ⱸ��',
                  '����',
                  '�޽�������',
                  '�����ʵ��'
                  ],
		colModel:[
				{ name : 'EAISVCNAME'  , align:'left'	,sortable:false },
				{ name : 'ETRACTDSTCD' , align:'left' , edittype:'select',editoptions:select_ETRACTDSTCD, formatter:"select"},
				{ name : 'FLDPRCSSNO'  , align:'left' },
				{ name : 'MSGDSTCD'    , align:'left' },
				{ name : 'BZWKFLDNAME' , align:'left' }
				],
        jsonReader: {
             repeatitems:false
        },	          
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : '${rmsDefaultRowNum}',
	    autoheight: true,
	    height: $("#container").height(),
		autowidth: true,
		viewrecords: true,
		rowList : eval('[${rmsDefaultRowList}]'),
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)		
			}
		
		},			
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var key = rowData['EAISVCNAME'];
            var key2 = rowData['ETRACTDSTCD'];
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//�˻���
            url2 += '&'+getSearchUrl();
            //key��
            url2 += '&eaiSvcName='+key;
            url2 += '&etractDstcd='+key2;
            goNav(url2);
        },
	});
}
$(document).ready(function() {
	
	resizeJqGridWidth('grid','title','1000');
	init(detail);	

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=DETAIL';
		url2 += '&page='+$("#grid").getGridParam("page");
		url2 += '&returnUrl='+getReturnUrl();
        url2 += '&menuId='+'${param.menuId}';
		//�˻���
        url2 += '&'+getSearchUrl();

        goNav(url2);
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
		$("#btn_initialize").click(function(){
			$.ajax({  
				type : "POST",
				url:url,
				dataType:"json",
				data:{cmd: 'INITIALIZES'},
				success:function(json){
					alert(json.message);
				},
				error:function(e){
					alert(e.responseText);
				}
			});		
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
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" />
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">�ʵ� �������� ����</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
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
