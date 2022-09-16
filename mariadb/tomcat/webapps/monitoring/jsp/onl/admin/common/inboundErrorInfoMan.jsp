<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
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
var url      = '<c:url value="/onl/admin/common/inboundErrorInfoMan.json" />';
var url_view = '<c:url value="/onl/admin/common/inboundErrorInfoMan.view" />';
var selectName = "searchAdptrBzwkGroupName";	// selectBox Name

function init(callback) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_COMBO'},
		success:function(json){
			new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=searchAdptrBzwkGroupName]")).setNoValueInclude(true).setNoValue("", "전체").setData(json.adapterList).setFormat(codeName3OptionFormat).rendering();
			putSelectFromParam();
			setSearchable(selectName);	// 콤보에 searchable 설정
			
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
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$("#grid").setGridParam({ url:url,postData: postData ,datatype:'json' }).trigger("reloadGrid");
}
function search(){
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$("#grid").setGridParam({ url:url,postData: postData ,datatype:'json',page:1 }).trigger("reloadGrid");
}
$(document).ready(function() {	

	$("input[name=searchStartDate],input[name=searchEndDate]").inputmask({ alias: "datetime",autoUnmask: true, inputFormat : "yyyy-mm-dd",outputFormat : "yyyymmdd" });
	if ($("input[name=searchStartDate]").val()=="" || $("input[name=searchStartDate]").val()==null || $("input[name=searchStartDate]").val()==undefined || $("input[name=searchStartDate]").val()=="yyyymmdd"){
		$("input[name=searchStartDate]").val(getBeforeDay(7));
	}
	if ($("input[name=searchEndDate]").val()=="" || $("input[name=searchEndDate]").val()==null || $("input[name=searchEndDate]").val()==undefined || $("input[name=searchEndDate]").val()=="yyyymmdd"){
		$("input[name=searchEndDate]").val(getToday());
	}
	init(detail);
	$('#grid').jqGrid({
		datatype:"local",
		mtype: 'POST',
		//url: url,
		//postData : gridPostData,
		colNames:['<%= localeMessage.getString("inboundError.serno") %>',
                  '<%= localeMessage.getString("inboundError.adapter") %>',
                  '<%= localeMessage.getString("inboundError.errorCode") %>',
                  '<%= localeMessage.getString("inboundError.occurhms") %>',
                  '<%= localeMessage.getString("inboundError.instncName") %>'
                  ],
		colModel:[
				{ name : 'EAISVCSERNO'        , align:'left', sortable:false  },
				{ name : 'ADPTRBZWKGROUPNAME' , align:'left'  },
				{ name : 'EAIERRCD'           , align:'left'  },
				{ name : 'ERROCCURHMS'        , align:'left'  },
				{ name : 'EAISEVRINSTNCNAME'  , align:'left'  }
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
		loadComplete:function (d){
		},
  		
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//검색값
            url2 += '&'+getSearchUrl();
            
            //key값
            url2 += '&eaiSvcSerno='+rowData['EAISVCSERNO'];
            goNav(url2);
        },
 		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},	       
        loadError: function(xhr, status, error){
        	alert(JSON.parse(xhr.responseText).errorMsg);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','10000');

	$("#btn_search").click(function(){
		search();
	});
	
	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			search();
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
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
				</div>
				<div class="title"><%= localeMessage.getString("inboundError.title") %></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:130px;"><%= localeMessage.getString("inboundError.search1") %></th>
							<td>
								<input type="text" name="searchStartDate" value="${param.searchStartDate}" size="10" style="width:100px; border:1px solid #ebebec;">~
								<input type="text" name="searchEndDate" value="${param.searchEndDate}" size="10" style="width:100px; border:1px solid #ebebec;">
							</td>
							<th style="width:130px;"><%= localeMessage.getString("inboundError.adapter") %></th>
							<td colspan="3">
								<div style="position: relative; width: 100%;">
									<div class="select-style">	
										<select name="searchAdptrBzwkGroupName" value="${param.searchAdptrBzwkGroupName}">
										</select>	
									</div><!-- end.select-style -->	
								</div>
							</td>
						</tr>
						<tr>
							<th style="width:130px;"><%= localeMessage.getString("inboundError.instncName") %></th>
							<td><input type="text" name="searchEaiSevrInstncName" value="${param.searchEaiSevrInstncName}"></td>
							<th style="width:130px;"><%= localeMessage.getString("inboundError.errorCode") %></th>
							<td><input type="text" name="searchEaiErrCd" value="${param.searchEaiErrCd}"></td>
							<th style="width:130px;"><%= localeMessage.getString("inboundError.serno") %></th>
							<td><input type="text" name="searchEaiSvcSerno" value="${param.searchEaiSvcSerno}"></td>
						</tr>
					</tbody>
				</table>
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

