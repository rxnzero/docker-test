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

	function init( callback ) {
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_INIT_COMBO'},
			success:function(json){
				new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setNoValueInclude(true).setNoValue('','��ü').setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
				//$("select[name=searchEaiBzwkDstcd]").searchable();
				setSearchable('searchEaiBzwkDstcd');
				putSelectFromParam();
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

	function dateFormater(cellvalue, options, rowObject){
		if (cellvalue==null|| cellvalue==undefined) return "";
		if (cellvalue.trim().length !=4) return "";
		var display = "";
		display=display+cellvalue.substr(0,2)+":";
		display=display+cellvalue.substr(2,2);
	
		return display;
	}	

$(document).ready(function() {	

	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['�����׷�',
                  '��ġ����',
                  '������ID',
                  '��������',
                  '�⵿���',
                  '�⵿����',
                  '�⵿����',
                  '�ݺ�����',
                  '��뿩��'
                  ],
		colModel:[
				{ name : 'WORKGRPCD'  , align:'center' ,width:50   },
				{ name : 'BATCHTYPE'  , align:'center' ,width:50  ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == 'DD' ) {
				                 	return 'DB2DB';
                                 } else if ( cellvalue == 'DF' ) {
				                 	return 'DB2FILE';
                                 } else if ( cellvalue == 'FD' ) {
				                 	return 'FILE2DB';
                                 } else if ( cellvalue == 'FF' ) {
				                 	return 'FILE2FILE';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				
				},
				{ name : 'BJOBMSGSCHEID'  , align:'center' ,width:65  },
				{ name : 'THISMSGSCHEDESC', align:'left'   },
				{ name : 'SCHEKIND'       , align:'center',width:50 ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == 'T' ) {
				                 	return 'Ÿ�̸�';
                                 } else if ( cellvalue == 'F' ) {
				                 	return '����';
                                 } else {
                                  	return cellvalue;
                                 }
                              }
				},
				{ name : 'SNDRCVSTARTHMS'  , align:'center', width:50 , formatter: dateFormater },
				{ name : 'SNDRCVENDHMS'    , align:'center', width:50 , formatter: dateFormater },
				{ name : 'DAYCYCLETIME'    , align:'center', width:50 , formatter: dateFormater },
				{ name : 'THISMSGUSEYN'    , align:'center' ,width:50 ,
				  formatter: function (cellvalue) {
				                 if ( cellvalue == '1' ) {
				                 	return '���';
                                 } else {
                                  	return '<span style="color:red">������</span>';
                                 }
                              }
				}],
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
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var bjobMsgScheID = rowData['BJOBMSGSCHEID'];
            var url2 = url_view;
            url2 = url2 + '?cmd=DETAIL';
            url2 = url2 + '&page='+$(this).getGridParam("page");
            url2 = url2 + '&returnUrl='+getReturnUrl();
            url2 = url2 + '&menuId='+'${param.menuId}';
			//�˻���
            url2 = url2 + '&'+getSearchUrl();
            //key��
            url2 = url2 + '&bjobMsgScheID='+bjobMsgScheID;
            goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','title','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 = url2 + '?cmd=DETAIL';
		url2 = url2 + '&page=1';
		url2 = url2 + '&returnUrl='+getReturnUrl();
        url2 = url2 + '&menuId='+'${param.menuId}';
		//�˻���
        url2 = url2 + '&'+getSearchUrl();

        goNav(url2);
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
	buttonControl();
	init( detail);

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
				<div class="title">��ġ ������ ����<span class="tooltip">EAI ��ġ �ý��ۿ��� ����ϴ� �۾� ������ ���</span></div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:100px;">�������и�</th>
							<td>
								<div style="position: relative; width: 100%;">
									
										<select name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">
										</select>
									
								</div>
							</td>
							<th style="width:100px;">��ġ�ŷ�����</th>
							<td>
								<div class="select-style">
									<select name="searchBatchType" value="${param.searchBatchType}">
										<option value="">��ü</option>
										<option value="FF">FILE2FILE</option>
										<option value="DF">DB2FILE</option>
										<option value="DD">DB2DB</option>
										<option value="FD">FILE2DB</option>
									</select>
								</div><!-- end.select-style -->		
							</td>
							<th style="width:100px;">��������</th>
							<td>
								<input type="text" name="searchThisMsgScheDesc" value="${param.searchThisMsgScheDesc}">
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