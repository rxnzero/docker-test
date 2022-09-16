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

var url			= '<c:url value="/bap/admin/schedule/procPeriodMan.json" />';
var url_view	= '<c:url value="/bap/admin/schedule/procPeriodMan.view"/>';
var select_sndRcvTyp     = new Array();

function init(){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL_INIT_COMBO'},
		success:function(json){
			list();
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function list(){
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['�ŷ�ó�� �ֱ�ID',
				  '������',
                  '��ܱ����',
                  '��ġ�۾������ڵ�',
                  '��ġ�۾� �޽��� ���и�',
                  '�ۼ�������',
                  '�ۼ��Ž��۽ð�',
                  '�ۼ�������ð�',
                  '�ۼ����ֱ�Ÿ��'
                  ],
		colModel:[
				{ name : 'BJOBMSGSCHEID'		, align : 'center',hidden:true},
				{ name : 'BJOBBZWKNAME'			, align : 'left'},
				{ name : 'OSIDINSTINAME'		, align : 'left'},
				{ name : 'BJOBTRANDSTCDNAME'	, align : 'left'},
				{ name : 'BJOBMSGDSTICNAME'		, align : 'left'},
				{ name : 'SENDRECVYN'			, align : 'center', editable : false , edittype:'select',editoptions:{value:" : ;S:�۽�;R:����"}, formatter:"select"},
				{ name : 'SNDRCVSTARTHMS'		, align : 'center', formatter: timeFormat},
				{ name : 'SNDRCVENDHMS'			, align : 'center', formatter: timeFormat},
				{ name : 'SNDRCVCYCLTYPNAME'	, align : 'left', editable : false , edittype:'select',editoptions:select_sndRcvTyp, formatter:"select"}
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
            var bJobMsgScheId = rowData['BJOBMSGSCHEID'].trim();
            var detailUrl = url_view;
            detailUrl = detailUrl + '?cmd=DETAIL';
            detailUrl = detailUrl + '&page='+$(this).getGridParam("page");
            detailUrl = detailUrl + '&returnUrl='+getReturnUrl();
            detailUrl = detailUrl + '&menuId='+'${param.menuId}';
	    	detailUrl = detailUrl + '&returnUrl='+getReturnUrl();
            detailUrl = detailUrl + '&bJobMsgScheId='+bJobMsgScheId;
            detailUrl = detailUrl + '&'+getSearchUrl();
		    //�˻���
            goNav(detailUrl);
        }
	});
}

$(document).ready(function() {
	// �׸��� - �ۼ��� �ֱ�Ÿ�� ����
	select_sndRcvTyp['value'] = ": ;C1:�Ϲݺ�;C2:���ݺ�;C3:�� ������ �ݺ�;C4:�ֹݺ�;C5:���� ������ �ݺ�;C6:�� ���� �ݺ�;C7:�� ������ �ݺ�";
	
	resizeJqGridWidth('grid','title','1000');
	
	init();

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({url:url, postData: postData, page:"1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var returnUrl = url_view;
		returnUrl = returnUrl + '?cmd=DETAIL';
		returnUrl = returnUrl + '&page='+$("#grid").getGridParam("page");
		returnUrl = returnUrl + '&returnUrl='+getReturnUrl();
        returnUrl = returnUrl + '&menuId='+'${param.menuId}';
		//�˻���
        returnUrl = returnUrl + '&'+getSearchUrl();

        goNav(returnUrl);
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">�ŷ�ó�� �ֱ� ����<span class="tooltip">�ϰ� ���� ������ �ŷ�ó�� �ֱ� ����� ��ȸ�ϴ� ȭ���Դϴ�</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:150px;">������</th>
							<td><input type="text" name="searchBjobBzwkName" value="${param.searchBjobBzwkName}"></td>
							<th style="width:150px;">��ܱ����</th>
							<td><input type="text" name="searchOsidInstiName" value="${param.searchOsidInstiName}"></td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>	
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

