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
var url      ='<c:url value="/onl/admin/adapter/adapterMan.json" />';
var url_view ='<c:url value="/onl/admin/adapter/adapterMan.view" />';

function init(callback) {
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_SEARCH_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=searchAdptrIoDstCd]")).setNoValueInclude(true).setNoValue("", "전체").setData(json.adptrIoDstcdRows).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=searchAdptrMsgPtrnCd]")).setNoValueInclude(true).setNoValue("", "전체").setData(json.adptrMsgPtrnCdRows).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=searchAdptrUseYn]")).setNoValueInclude(true).setNoValue("", "전체").setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();
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


function list(_page)
{   
	var page = "${param.page}";
	if(_page == "1") page = "1";
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	
	postData["sortName"] ='${param.sortName}';
    postData["sortOrder"]="${param.sortOrder}";
	$("#grid").setGridParam({ url:url, postData: postData ,sortName:'${param.sortName}', sortOrder:"${param.sortOrder}",page : page }).trigger("reloadGrid");
}

$(document).ready(function() {		
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
    gridPostData["sortName"] ='${param.sortName}';
    gridPostData["sortOrder"]='${param.sortOrder}';
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
// 		url: url,
// 		postData : gridPostData,
		colNames:['어댑터그룹명 ',
                  '어댑터그룹설명',
                  '입출력구분',
                  '표준/비표준',
                  '업무구분',
                  '어댑터유형',
                  '사용구분'
                  ],
		colModel:[
				{ name : 'ADPTRBZWKGROUPNAME' , align:'left'  },
				{ name : 'ADPTRBZWKGROUPDESC' , align:'left'  },
				{ name : 'ADPTRIODSTCD'      , align:'left'  },
				{ name : 'ADPTRMSGPTRNCD'     , align:'left'  },
				{ name : 'EAIBZWKDSTCD'       , align:'left'  },
				{ name : 'ADPTRCD'            , align:'left'  },
				{ name : 'ADPTRUSEYN'         , align:'left'  }
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
		sortname : '${param.sortName}',
		sortorder : '${param.sortOrder}',
		rowList : eval('[${rmsDefaultRowList}]'),
		loadComplete:function (d){
			//$(this).setGridParam({datatype:'local'});
		},
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
        	url2 += '&sortName='+$("#grid").getGridParam("sortname");
        	url2 += '&sortOrder='+$("#grid").getGridParam("sortorder");            
			//검색값
            url2 += '&'+getSearchUrl();
            
            //key값
            url2 += '&adptrBzwkGroupName='+rowData['ADPTRBZWKGROUPNAME'];
            goNav(url2);
            
        },
        onSortCol :function(sidx,colnum,sort_order){
          	var gridPostData = getSearchForJqgrid("cmd","LIST");
          	var sortorder="";
          	if( sort_order == "") 
          		sortorder ='asc';
          	else
          		sortorder = sort_order;
          	gridPostData["sortName"] =sidx;
        	gridPostData["sortOrder"]=sortorder;
        	$("#grid").setGridParam({ url:url, postData: gridPostData, sortname:sidx, sortorder:sortorder, page:"1"}).trigger("reloadGrid");	 
        	 
        	
        }
            		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		list("1");
	});
	$("#btn_new").click(function(){
		var url2 = '<c:url value="/onl/admin/adapter/adapterMan.view"/>';
		url2 += '?cmd=DETAIL';
		url2 += '&page='+$("#grid").getGridParam("page");
		url2 += '&returnUrl='+getReturnUrl();
        url2 += '&menuId='+'${param.menuId}';
        url2 += '&sortName='+$("#grid").getGridParam("sortname");
        url2 += '&sortOrder='+$("#grid").getGridParam("sortorder");
		//검색값
        url2 += '&'+getSearchUrl();
		
        goNav(url2);
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
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />		

				</div>
				<div class="title">어댑터 관리</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:80px;">I/O구분</th>
							<td>
								<div class="select-style">
									<select name="searchAdptrIoDstCd" value="${param.searchAdptrIoDstCd}">										
									</select>
								</div>
							</td>
							<th style="width:80px;">표준여부</th>
							<td>
								<div class="select-style">
									<select name="searchAdptrMsgPtrnCd" value="${param.searchAdptrMsgPtrnCd}">
									</select>
								</div>	
							</td>
							<th style="width:80px;">사용구분</th>
							<td>
								<div class="select-style">
									<select name="searchAdptrUseYn" value="${param.searchAdptrUseYn}">
									</select>
								</div>		
							</td>
						</tr>
						<tr>
							<th style="width:80px;">그룹명</th>
							<td><input type="text" name="searchAdptrBzwkGroupName" value="${param.searchAdptrBzwkGroupName}"></td>
							<th style="width:80px;">그룹설명</th>
							<td colspan="3"><input type="text" name="searchAdptrBzwkGroupDesc" value="${param.searchAdptrBzwkGroupDesc}"></td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

