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

$(document).ready(function() {	
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: '<c:url value="/common/acl/role/roleMan.json" />',
		postData : gridPostData,
		colNames:['<%= localeMessage.getString("role.id") %>',
                  '<%= localeMessage.getString("role.name") %>',
                  '<%= localeMessage.getString("combo.useYn") %>',
                  '<%= localeMessage.getString("role.description") %>'
                  ],
		colModel:[
				{ name : 'ROLEID'   , align:'left'	,sortable:false  },
				{ name : 'ROLENAME' , align:'left'  },
				{ name : 'USEYN'    , align:'left'  },
				{ name : 'ROLEDESC' , align:'left'  }
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
            var roleId = rowData['ROLEID'];
            var url = '<c:url value="/common/acl/role/roleMan.view" />';
            url = url + '?cmd=DETAIL';
            url = url + '&page='+$(this).getGridParam("page");
            url = url + '&returnUrl='+getReturnUrl();
            url = url + '&menuId='+'${param.menuId}';
			//검색값
            url = url + '&'+getSearchUrl();
            //key값
            url = url + '&roleId='+roleId;
            goNav(url);
            
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1" }).trigger("reloadGrid");

	});
	
	$("#btn_new").click(function(){
		var url = '<c:url value="/common/acl/role/roleMan.view"/>';
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
			<div class="content_middle" id="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title"><%= localeMessage.getString("role.title") %></div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("role.id") %></th>
							<td><input type="text" name="searchRoleId" value="${param.searchRoleId}"></td>
							<th style="width:180px;"><%= localeMessage.getString("role.name") %></th>
							<td><input type="text" name="searchRoleName" value="${param.searchRoleName}"></td>
						</tr>
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("combo.useYn") %></th>
							<td colspan="3">
								<div class="select-style">
									<select name="searchUseYn">
										<option value=""><%= localeMessage.getString("combo.all") %></option>
										<option value="Y"><%= localeMessage.getString("combo.usey") %></option>
										<option value="N"><%= localeMessage.getString("combo.usen") %></option>
									</select>
								</div>	
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

