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

 $(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/message/flowStepMan.json" />',
		postData : gridPostData,
		colNames:[
					'ó�������ڵ�',
					'�ܰ豸���ڵ�',
					'�ܰ�������',
					'�帧������Ʈ��',
					'����Ŭ����ID',
					'������������'

                  ],
                  
		colModel:[
				{ name : 'BJOBBZWKPRCSSDSTCD'  	, align:'left'		,width:40	,sortable:false  },
				{ name : 'BJOBSTGEDSTCD'          , align:'left'	,width:40  },
				{ name : 'BJOBSTGEPTRNNAME'          , align:'left'	,width:40  },
				{ name : 'BJOBFLOWCMPONAME'          , align:'left'	,width:40  },
				{ name : 'TELGMCLSID'          , align:'left'	,width:40  },
				{ name : 'UNITTELGMLEN'          , align:'left'	,width:40  },

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
            var key = rowData['BJOBBZWKPRCSSDSTCD'];
            var key2 = rowData['BJOBSTGEDSTCD'];
            var url = '<c:url value="/bap/admin/message/flowStepMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//�˻���
            url = url + '&'+getSearchUrl();
            //key��
            url = url + '&key='+key;
            url = url + '&key2='+key2;
            goNav(url);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
	    var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/message/flowStepMan.view"/>';
		url = url + '?cmd=DETAIL';
		url = url + '&page='+$("#grid").getGridParam("page");
		url = url + '&returnUrl='+getReturnUrl();
        url = url + '&menuId='+'${param.menuId}';
		//�˻���
        url = url + '&'+getSearchUrl();
		
        goNav(url);
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
				<div class="title">�帧�ܰ� ����Ʈ<span class="tooltip">�帧�ܰ� ����Ʈ�� �����մϴ�</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:150px;">����ó�������ڵ�</th>
							<td><input type="text" name="searchBjobBzwkPrcssDstcd" value="${param.searchBjobBzwkPrcssDstcd}"></td>
							<th style="width:150px;">�ܰ豸���ڵ�</th>
							<td><input type="text" name="searchBjobStgeDstcd" value="${param.searchBjobStgeDstcd}"></td>
							<th style="width:150px;">�帧������Ʈ��</th>
							<td><input type="text" name="searchBjobFlowCmpoName" value="${param.searchBjobFlowCmpoName}"></td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>	
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>