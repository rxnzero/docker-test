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

var mapGroupCoCd;

function init(url){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
		    mapGroupCoCd = json.groupCoCd;
		    var l = [];
			new makeOptions("CODE","NAME").setObj($("select[name=searchGroupCoCd]")).setData(json.groupCoCd).rendering();
			for(var i=0;i<json.groupCoCd.length;i++){
				l.push(""+json.groupCoCd[i]["CODE"]+":"+json.groupCoCd[i]["NAME"]);
			}
			//debugger;
			mapGroupCoCd = l.join(";");
			list(url);
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function list(url){
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/bap/admin/schedule/scheduleMan.json" />',
		postData : gridPostData,
		colNames:['스케쥴ID',
                  '업무구분명',
                  '그룹사구분',
                  '대외기관명',
                  '작업메시지구분명',
                  '거래구분명',
                  '시작시각',
                  '종료시각',
                  '송수신여부',
                  '사용여부'
                  ],
		colModel:[
				{ name : 'BJOBMSGSCHEID'     , align:'left', hidden:true  },
				{ name : 'BJOBBZWKNAME'      , align:'left'  },
				{ name : 'GROUPCOCD'         , align:'center', width:50 , editoptions:{value:mapGroupCoCd}, formatter:"select"  },
				{ name : 'OSIDINSTINAME'     , align:'left'  },
				{ name : 'BJOBMSGDSTICNAME'  , align:'left'  , width:250},
				{ name : 'BJOBTRANDSTCDNAME' , align:'left'  , width:70},
				{ name : 'SNDRCVSTARTHMS'    , align:'center', width:50 , formatter: dateFormater  },
				{ name : 'SNDRCVENDHMS'      , align:'center', width:50 , formatter: dateFormater  },
				{ name : 'BJOBPTRNDSTCD'     , align:'center', width:50 , editoptions:{value:"RS:송신;RR:수신"}, formatter:"select"  },
				{ name : 'THISMSGUSEYN'      , align:'center', width:50 ,
				          formatter: function (cellvalue) {
				              if ( cellvalue == '1' ) {
				                  return '사용';
                              } else {
                                  return '<span style="color:red">사용안함</span>';
                              }
                          }
				 }
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
				$(this).setColProp(colModel[i].name, {sortable : false});	//그리드 헤더 화살표 삭제(정렬X)		
			}
		
		},			
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var bJobMsgScheId = rowData['BJOBMSGSCHEID'].trim();
            var url = '<c:url value="/bap/admin/schedule/scheduleMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
	    	url = url + '&returnUrl='+getReturnUrl();
            url = url + '&bJobMsgScheId='+bJobMsgScheId;
            url = url + '&'+getSearchUrl();
		    //검색값
            goNav(url);
        }
	});
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

	resizeJqGridWidth('grid','title','1000');
	var url ='<c:url value="/bap/admin/schedule/scheduleMan.json" />';
	init(url);

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({url:url, postData: postData, page:"1" }).trigger("reloadGrid");
	});
	$("#btn_new").click(function(){
		var url = '<c:url value="/bap/admin/schedule/scheduleMan.view"/>';
		url = url + '?cmd=DETAIL';
		url = url + '&page='+$("#grid").getGridParam("page");
		url = url + '&returnUrl='+getReturnUrl();
        url = url + '&menuId='+'${param.menuId}';
		//검색값
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title">스케쥴 관리<span class="tooltip">일괄 전송 파일을 송수신 하는 스케쥴을 관리 하는 화면입니다</span></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:150px;">업무명</th>
							<td><input type="text" name="searchBjobBzwkName" value="${param.searchBjobBzwkName}"></td>
							<th style="width:150px;">대외기관명</th>
							<td><input type="text" name="searchOsidInstiName" value="${param.searchOsidInstiName}"></td>
							<th style="width:150px;">메시지구분명</th>
							<td><input type="text" name="searchBjobMsgDsticName" value="${param.searchBjobMsgDsticName}"></td>
						</tr>
						<tr>
							<th style="width:150px;">거래구분명</th>
							<td><input type="text" name="searchBjobTranDstcdName" value="${param.searchBjobTranDstcdName}"></td>
							<th style="width:150px;">송수신구분</th>
							<td>
							<div class="select-style"><select name="searchBjobPtrnDstcd" value="${param.searchBjobPtrnDstcd}">
								<option value="">전체</option>
								<option value="RS">송신</option>
								<option value="RR">수신</option>
							</select></div>
							</td>
							<th style="width:150px;">그룹사구분</th>
							<td><div class="select-style"><select name="searchGroupCoCd" value="${param.searchGroupCoCd}">
								<option value="">전체</option>
							</select></div></td>
						</tr>
					</tbody>
				</table>
				<table id="grid" ></table>
				<div id="pager"></div>	
				
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

