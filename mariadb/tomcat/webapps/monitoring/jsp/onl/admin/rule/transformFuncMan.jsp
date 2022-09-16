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
var url      = '<c:url value="/onl/admin/rule/transformFuncMan.json" />';
var url_view = '<c:url value="/onl/admin/rule/transformFuncMan.view" />';
var select_CNVSNFUNTNRETUNPTRNIDNAME = new Array();
var select_CNVSNFUNTNPTRNIDNAME      = new Array();

function init( callback) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_COMBO'},
		success:function(json){
			
			select_CNVSNFUNTNRETUNPTRNIDNAME['value'] = ": ;"+getGridSelectText("CODE","NAME",json.returnTypeList);
			select_CNVSNFUNTNPTRNIDNAME['value']      = ": ;"+getGridSelectText("CODE","NAME",json.typeList);

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
    var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['��ȯ�Լ���',
                  '��ȯ�Լ���ȯ������',
                  '��ȯ�Լ� Ŭ������',
                  '��ȯ�Լ� ����ID'
                  ],
		colModel:[
				{ name : 'CNVSNFUNTNNAME'            , align:'left'	,sortable:false  },
				{ name : 'CNVSNFUNTNRETUNPTRNIDNAME' , align:'left'  , edittype:'select',editoptions:select_CNVSNFUNTNRETUNPTRNIDNAME, formatter:"select"},
				{ name : 'CNVSNFUNTNCLSNAME'         , align:'left'  },
				{ name : 'CNVSNFUNTNPTRNIDNAME'      , align:'left'  , edittype:'select',editoptions:select_CNVSNFUNTNPTRNIDNAME, formatter:"select"}
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
            var key = rowData['CNVSNFUNTNNAME'];
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//�˻���
            url2 += '&'+getSearchUrl();
            //key��
            url2 += '&cnvsnFuntnName='+key;
            goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');	
}

$(document).ready(function() {	
    init(detail);



	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ postData: postData ,page : "1"  }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=DETAIL';
		url2 += '&page=1';
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
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" />
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />		
				</div>
				<div class="title">��ȯ�Լ� ����<span class="tooltip">��ȯ������ ��ȯ�Լ��� ��ȸ�ϴ� ȭ���Դϴ�. ��ȯ�������� �޽��� ��ȯ�� ����ϰԵ� �Լ��� ��Ÿ���ϴ�</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">��ȯ�Լ���</th>
							<td>
								<input type="text" name="searchCnvsnFuntnName" value="${param.searchCnvsnFuntnName}">
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

