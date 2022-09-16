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

function getHoldyDstcd ( holdyDstcdName ){
    if ( holdyDstcdName == '������' ) {
        return '1';
    } else if( holdyDstcdName == '�ӽð�����' ) {	
        return '2';
    } else if( holdyDstcdName == '��������' ) {	
        return '3';
    }

}
$(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/schedule/holidayMan.json" />',
		postData : gridPostData,
		colNames:['��������',
                  '���� ����',
                  '����'
                  ],
		colModel:[
				{ name : 'HOLDYYMD'   , align:'center', width: '30px',	sortable:false  },
				{ name : 'HOLDYDSTCD' , align:'center', width: '30px' ,
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '������';
                              } else if( cellvalue == '2' )  {	
                                  return '�ӽð�����';
                              } else if( cellvalue == '3' )  {
                                  return '��������';
                              } else {
                                  return cellvalue;
                              }
                          }
				 },
				{ name : 'EVNTSCHDRHOLDYCTNT'  , align:'left'  }
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
            var holdyYmd = rowData['HOLDYYMD'];
            var holdyDstcd = rowData['HOLDYDSTCD'];
            var evntSchdrHoldyCtnt = rowData['EVNTSCHDRHOLDYCTNT'];
            var url = '<c:url value="/bap/admin/schedule/holidayMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//�˻���
            url = url + '&'+getSearchUrl();
            //key��
            url = url + '&holdyYmd='+holdyYmd;
            url = url + '&holdyDstcd='+ getHoldyDstcd(holdyDstcd);
            url = url + '&evntSchdrHoldyCtnt='+ (evntSchdrHoldyCtnt);
            url = url + '&end=Yes';
            goNav(encodeURI(url));
        }		
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/schedule/holidayMan.view"/>';
		url = url + '?cmd=DETAIL';
		url = url + '&page='+$("#grid").getGridParam("page");
		url = url + '&returnUrl='+getReturnUrl();
        url = url + '&menuId='+'${param.menuId}';
		//�˻���
        url = url + '&'+getSearchUrl();

        goNav(url);
	});
	
	$("input[name^=like]").keydown(function(key){
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
				<div class="title">���� ����<span class="tooltip">�ϰ����� �ý��ۿ��� ���� �ϴ� ���� ����� ��ȸ�մϴ�</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:150px;">���� ����</th><td><input type="text" name="likeHoldyYmd" maxlength="8" value="${param.searchHoldyYmd}"></td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>	
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>