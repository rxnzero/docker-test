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
var url      ='<c:url value="/onl/admin/common/comDomainMan.json" />';
var url_view ='<c:url value="/onl/admin/common/comDomainMan.view" />';



$(document).ready(function() {	
	

	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
 		url: url,
 		postData : gridPostData,
		colNames:['<%= localeMessage.getString("domain.name") %>',
                  '<%= localeMessage.getString("domain.type") %>',
                  '<%= localeMessage.getString("domain.option") %>',
                  '<%= localeMessage.getString("domain.value") %>',

                  ],
		colModel:[
				{ name : 'DOMAINNM' , align:'left'  },
				{ name : 'DOMAINTYPE' , align:'left'  },
				{ name : 'DOMAINOPTION'      , align:'left'  },
				{ name : 'DOMAINVAL'     , align:'left', hidden:true  },
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
			//$(this).setGridParam({datatype:'local'});
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
            url2 += '&domainNM='+rowData['DOMAINNM'];
            goNav(url2);
            
        }
 
            		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=DETAIL';
		url2 += '&page='+$("#grid").getGridParam("page");
		url2 += '&returnUrl='+getReturnUrl();
        url2 += '&menuId='+'${param.menuId}';
		//검색값
        url2 += '&'+getSearchUrl();
		
        goNav(url2);
	});

	$("input[name^=search]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});
	$("#btn_search").click(function(){
		$("#grid").setGridParam({ postData: { searchDomainNM: $('input[name=searchDomainNM]').val()} }).trigger("reloadGrid");
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
				<div class="title"><%= localeMessage.getString("domain.title") %></div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("domain.search") %></th>
							<td>
								<input type="text" name="searchDomainNM" value="${param.searchDomainNM}">
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

