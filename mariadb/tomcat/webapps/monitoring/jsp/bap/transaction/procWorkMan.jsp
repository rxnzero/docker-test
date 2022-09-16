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

var url		= '<c:url value="/bap/transaction/procWorkMan.json" />';
var urlView	= '<c:url value="/bap/transaction/procWorkMan.view" />';

function zeroToStr(str){
	if(str == 0)
		return "";
	else
		return str;
}

function init(callback) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=searchBjobBzwkDstcd]")).setNoValueInclude(true).setNoValue('','��ü').setData(json.bjobBzwkDstcd).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=searchOsidInstiDstcd]")).setNoValueInclude(true).setNoValue('','��ü').setData(json.osidInstiDstcd).rendering();
			
			if (typeof callback === 'function') {
				callback();
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

function list()
{   
	// �ۼ��� ���� �ð�
	var start1	= zeroToStr($("input[name=searchStartYYYYMMDD1]").val() + $("input[name=searchStartHHMM1]").val());
	var end1	= zeroToStr($("input[name=searchEndYYYYMMDD1]").val() + $("input[name=searchEndHHMM1]").val());
	
	// �ۼ��� ����ð�
	var start2	= zeroToStr($("input[name=searchStartYYYYMMDD2]").val() + $("input[name=searchStartHHMM2]").val());
	var end2	= zeroToStr($("input[name=searchEndYYYYMMDD2]").val() + $("input[name=searchEndHHMM2]").val());

	// �ۼ��� ���۽ð�
	$("input[name=searchStartTime1]").val(start1);
	$("input[name=searchEndTime1]").val(end1);

	// �ۼ��� ����ð�
	$("input[name=searchStartTime2]").val(start2);
	$("input[name=searchEndTime2]").val(end2);
	
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$("#grid").setGridParam({ url:url, postData: postData ,page : "1" }).trigger("reloadGrid");
}

$(document).ready(function() {
	// �ۼ��� ����, ����ð� ����.
	$("input[name=searchStartYYYYMMDD1],input[name=searchEndYYYYMMDD1],input[name=searchStartYYYYMMDD2],input[name=searchEndYYYYMMDD2]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
	$("input[name=searchStartHHMM1],input[name=searchEndHHMM1],input[name=searchStartHHMM2],input[name=searchEndHHMM2]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "HH:MM:ss",outputFormat : "HHMMss"  });
	
	$("input[name=searchStartYYYYMMDD1],input[name=searchEndYYYYMMDD1],input[name=searchStartYYYYMMDD2],input[name=searchEndYYYYMMDD2]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "yyyymmdd"){
			$(this).val(getToday());
		}
	});
	
	$("input[name=searchStartHHMM1],input[name=searchStartHHMM2]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "HHMMss"){
			$(this).val('000000');
		}
	});
	
	$("input[name=searchEndHHMM1],input[name=searchEndHHMM2]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == "" || $(this).val() == "HHMMss"){
			$(this).val('235959');
		}
	});
	// End �ۼ��� ����, ����ð� ����.
	
	// grid ����.
//     var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid������ object �� 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
// 		url: url,
// 		postData : gridPostData,
		colNames:['UUID',
		          'SUBUUID',
		          '���������ڵ�',
                  '�������и�',
                  '��ܱ�� �����ڵ�',
                  
                  '��ܱ����',
                  '�ۼ��� ���� ���丮��',
                  '�ۼ��� ���ϸ�',
                  '�۾��޽��� ����ID',
                  '�޽���ó�� �켱����',
                  
                  '�ۼ��� ���۽ð�',
                  '�ۼ��� ����ð�',
                  '�۾���û �޽���<br>�����ð�',
                  '������'
                  ],
		colModel:[
				{ name : 'BJOBDMNDMSGID'		, align:'left'	, hidden:true },
		        { name : 'BJOBDMNDSUBMSGID'		, align:'left'	, hidden:true },
				{ name : 'BJOBBZWKDSTCD'		, align:'left'	,sortable:false  },
				{ name : 'BJOBBZWKDSTCDNAME'	, align:'left'  },
				{ name : 'OSIDINSTIDSTCD'		, align:'left'  },
				
				{ name : 'OSIDINSTIDSTCDNAME'	, align:'left'  },
				{ name : 'SNDRCVFILEDIRNAME'	, align:'left'	, hidden:true  },
				{ name : 'SNDRCVFILENAME'		, align:'left'	, },
				{ name : 'BJOBMSGSCHEID'		, align:'left'	, hidden:true  },
				{ name : 'MSGPRCSSPRITY'		, align:'right'  },
				
				{ name : 'SNDRCVSTARTHMS'		, align:'center' , formatter: timeStampFormat  },
				{ name : 'SNDRCVENDHMS'			, align:'center' , formatter: timeStampFormat  },
				{ name : 'BJOBDMNDMSGCRETNHMS'	, align:'center' , formatter: timeStampFormat  },
				{ name : 'THISMSGAMNDHMS'		, align:'center' , formatter: timeStampFormat	, hidden:true  }
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
		gridview: true,
		rowList : eval('[${rmsDefaultRowList}]'),
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});	//�׸��� ��� ȭ��ǥ ����(����X)		
			}
		
			$(".ui-jqgrid-labels").css("height", "20px");						// grid header ����
			$("#jqgh_grid_BJOBDMNDMSGCRETNHMS").css("height", "auto");			// grid header cell ����
			$("#jqgh_grid_BJOBDMNDMSGCRETNHMS").css("margin-bottom", "5px");	// grid header cell �ܺο���
		},			
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var bjobMsgScheID		= rowData['BJOBMSGSCHEID'];
            var bjobDmndSubMsgID	= rowData['BJOBDMNDSUBMSGID'];
            
            var url = urlView;
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//�˻���
            url = url + '&'+getSearchUrl();
            //key��
            url = url + '&bjobMsgScheID='+bjobMsgScheID;
            url = url + '&bjobDmndSubMsgID='+bjobDmndSubMsgID;
            goNav(url);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');
	
	$("#btn_search").click(function(){
		list();
	});
	
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	
	buttonControl();
	init(list);
	
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
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">�����۾� ����</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">���������ڵ�</th>
							<td>
								<div class="select-style">	
									<select type="text" name="searchBjobBzwkDstcd" value="${param.searchBjobBzwkDstcd}">
									</select>
								</div><!-- end.select-style -->									
							</td>	
						</tr>
						<tr>	
							<th style="width:180px;">��ܱ�� �����ڵ�</th>
							<td>
								<div class="select-style">
									<select type="text" name="searchOsidInstiDstcd" value="${param.searchOsidInstiDstcd}">
									</select>
								</div>
							</td>
						</tr>
						<tr>	
							<th style="width:180px;">�ۼ������ϸ�</th>
							<td>
								<input type="text" name="searchSndrcvFileName" value="${param.searchSndrcvFileName}">
							</td>
						</tr>														
						<tr>							
							<th style="width:180px;">�ۼ��� ���� �ð�</th>
							<td>
								<input type="text" name="searchStartYYYYMMDD1" maxlength="10" value="" size="10" style="width:80px;">
								<input type="text" name="searchStartHHMM1" maxlength="8" value="" size="8" style="width:80px;"> ~
								<input type="text" name="searchEndYYYYMMDD1" maxlength="10" value="" size="10" style="width:80px;">
								<input type="text" name="searchEndHHMM1" maxlength="8" value="" size="8" style="width:80px;">
								<input type="hidden" name="searchStartTime1" value="20170201000000">
								<input type="hidden" name="searchEndTime1" value="20170201235959">
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

