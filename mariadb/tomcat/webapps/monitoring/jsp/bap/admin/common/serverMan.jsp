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
var $Grid ={};

$(document).ready(function() {	
	$Grid = $('#grid');
	$Grid.jqGrid({
		url: '<c:url value="/bap/admin/common/serverMan.json" />',
		postData : { cmd : 'LIST' },		
		datatype:"json",
		colNames:['���� �ν��Ͻ���',
                  '���� ������',
                  '���� ��Ʈ',
                  '��ֱغ�������',
                  'ȣ��Ʈ��'
                  ],
		colModel:[
				{ name : 'EAISEVRINSTNCNAME',   align:'left'	,sortable:false  },
				{ name : 'EAISEVRIP',           align:'left'  },
				{ name : 'SEVRLSNPORTNAME',     align:'left'  },
				{ name : 'FLOVRSEVRNAME',       align:'left'  },
				{ name : 'HOSTNAME',            align:'left'  }
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
		rowList : eval('[${rmsDefaultRowList}]'),
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)		
			}
		
		},			
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var eaiSevrInstncName = rowData['EAISEVRINSTNCNAME'];
            var url = '<c:url value="/bap/admin/common/serverMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//�˻���
            //
            //key��
            url = url + '&eaiSevrInstncName='+eaiSevrInstncName;
            goNav(url);
            
        }
	});
	
	resizeJqGridWidth('grid','title','1000');
	
	$("#btn_search").click(function(){
		$("#grid").trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/common/serverMan.view"/>';
		url = url + '?cmd=DETAIL';
		url = url + '&page=1';
		url = url + '&returnUrl='+getReturnUrl();
        url = url + '&menuId='+'${param.menuId}';
		//�˻���
        url = url + '&searchMsg=';
		
        goNav(url);
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">�ϰ����� ���� ����<span class="tooltip">�ϰ����� ���� ������ ��ȸ�ϴ� ȭ���Դϴ�. �ϰ����� ������ ����ȭ�� ���� �߿��� �ڷ��Դϴ�</span></div>
				
				<table id="grid" ></table>
				<div id="pager"></div>				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>
