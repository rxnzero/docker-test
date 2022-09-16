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
var url      = '<c:url value="/onl/admin/service/jmsQueueMan.json" />';
var url_view = '<c:url value="/onl/admin/service/jmsQueueMan.view" />';
$(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : gridPostData,
		colNames:['ť��',
                  '������',
                  '�ν��Ͻ�',
                  '��뿩���ڵ�',
                  '�뵵�ڵ�',
                  '��뿩��',
                  '�뵵',
                  '���������ڵ�',
                  'ť�������γ���'
                  ],
		colModel:[
				{ name : 'NONSYNCZTRANQUENAME'	, align:'left'	,sortable:false  },
				{ name : 'QUEBZWKCTNT'			, align:'left'  },
				{ name : 'SEVRINSTNCNAME'		, align:'left'  },
				{ name : 'QUEUSEYN'				, hidden:true	},
				{ name : 'QUEUSAGDSTCD'			, hidden:true 	},
				{ name : 'QUEUSEYNNAME'			, align:'center'  },
				{ name : 'QUEUSAGDSTNAME'		, align:'center'  },
				{ name : 'BZWKDSTCD'			, align:'center'  },
				{ name : 'QUEBZWKDTALSCTNT'		, align:'left'  }
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
		loadComplete:function (d){
		},
        loadError: function (jqXHR, textStatus, errorThrown) {
        	alert('HTTP status code: ' + jqXHR.status + '\n' +
              'textStatus: ' + textStatus + '\n' +
              'errorThrown: ' + errorThrown);
        	alert('HTTP message body (jqXHR.responseText): ' + '\n' + jqXHR.responseText);
    	},		
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//�˻���
            url2 += '&'+getSearchUrl();
            //key��
            url2 += '&nonSynczTranQueName='+rowData['NONSYNCZTRANQUENAME'];
            goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

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
	//�˻���  enter��  ��ȸ
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
				<div class="title">�񵿱� ť ����<span class="tooltip">�񵿱� �ŷ��� ���� ���Ǵ� ť�� �����ϴ� ȭ���Դϴ�</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">ť��</th>
							<td>
								<input type="text" name="searchNonSynczTranQueName" value="${param.searchNonSynczTranQueName}">
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

