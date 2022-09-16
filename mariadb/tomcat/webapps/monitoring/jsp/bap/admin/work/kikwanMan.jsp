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

function list(url){
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object ��
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/work/kikwanMan.json" />',
		postData : gridPostData,
		colNames:['����ڵ�',
                  '�����',
                  '�ý���IP',
                  '��ȣȭIP',
                  '��뿩��',
                  //'�����ID',
                  //'��Ͻð�',
                  //'������ID',
                  //'�����ð�'
                  ],
		colModel:[
				{ name : 'KIKWANCD'     	 , align:'left' ,width:40	,sortable:false  },
				{ name : 'KIKWANNAME'   	 , align:'center' ,width:40  },
				{ name : 'SYSIP'      		 , align:'center' ,width:40  },
				{ name : 'ENCIP'      		 , align:'center' ,width:40  },
				{ name : 'THISMSGUSEYN'  , align:'center' ,width:40   ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '0' ) {
				                 	return '<span style="color:red">������</span>';
                                 } else if ( cellvalue == '1' ) {
				                 	return '���';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				}				
				//{ name : 'ThisMsgRegsntI'    , align:'left' 	, hidden:true },
				//{ name : 'ThisMsgRegiHMS'    , align:'left' 	, hidden:true },
				//{ name : 'ThisMsgAmndrID'    , align:'left' 	, hidden:true},
				//{ name : 'ThisMsgAmndHMS'    , align:'left' 	, hidden:true },
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
            var kikwanCd = rowData['KIKWANCD'].trim();
            var url = '<c:url value="/bap/admin/work/kikwanMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
            url = url + '&kikwanCd='+kikwanCd;
		    //�˻���
		    url = url + '&'+getSearchUrl();
            goNav(url);
        }
	});
}

$(document).ready(function() {	

	resizeJqGridWidth('grid','title','1000');
	var url ='<c:url value="/bap/admin/work/kikwanMan.json" />';
	list(url);

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({url:url, postData: postData, page:"1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/work/kikwanMan.view"/>';
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title">FTManager�������<span class="tooltip">�ϰ� ���� ������ �ۼ��� ���� ���� �ڵ带 ���� �ϴ� ȭ���Դϴ�</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">����ڵ�</th>
							<td><input type="text" name="searchKikwanCd" value="${param.searchKikwanCd}"></td>
							<th style="width:180px;">�����</th>
							<td><input type="text" name="searchKikwanName" value="${param.searchKikwanName}"></td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

