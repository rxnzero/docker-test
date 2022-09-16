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
	var url      = '<c:url value="/onl/admin/service/hostHeaderMan.json" />';
	var url_view = '<c:url value="/onl/admin/service/hostHeaderMan.view" />';

	function init( callback) {

		if (typeof callback === 'function') {
			callback();
		}

		
	}
	function detail(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ url:url,postData: postData, page:1 }).trigger("reloadGrid");
	}

	$(document).ready(function() {	
		var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		
		$('#grid').jqGrid({
			datatype:"json",
			mtype: 'POST',
			url: url,
			postData : gridPostData,
			colNames:['기관 어댑터 업무코드',
	                  'TRANCODE',
	                  'STARTBIT',
	                  'SYSMODE',
	                  'SYSTYPE',
	                  'SYSSEND',
	                  'SYSRECV',
	                  'UBMUGIGN',
	                  'UBMUSEQ'
	                  ],
			colModel:[
					{ name : 'EAIBZWKDSTCD'	, align:'left'	, sortable:false		},
					{ name : 'TRANCODE'	, align:'center'		},
					{ name : 'STARTBIT'	, align:'center'		},
					{ name : 'SYSMODE'		, align:'center'	},
					{ name : 'SYSTYPE'	, align:'center'	},
					{ name : 'SYSSEND'	, align:'center'	},
					{ name : 'SYSRECV'	, align:'center'	},
					{ name : 'UBMUGIGN'	, align:'center'	},
					{ name : 'UBMUSEQ'	, align:'center'	}
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
			loadComplete:function (d){
				var colModel = $(this).getGridParam("colModel");
				for(var i = 0 ; i< colModel.length; i++){
					$(this).setColProp(colModel[i].name, {sortable : false});			
				}
	
			},			
			ondblClickRow: function(rowId) {
				var rowData = $(this).getRowData(rowId); 
	            var key = rowData['EAIBZWKDSTCD'];
	            var url2 = url_view;
	            url2 += '?cmd=DETAIL';
	            url2 += '&page='+$(this).getGridParam("page");
	            url2 += '&returnUrl='+getReturnUrl();
	            url2 += '&menuId='+'${param.menuId}';
				//검색값
	            url2 += '&'+getSearchUrl();
	            //key값
	            url2 += '&eaiBizCode='+key;

	            goNav(url2);
	            
	        }		
		});
		
		
		resizeJqGridWidth('grid','content_middle','1000');
	
		$("#btn_search").click(function(){
			var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
			$("#grid").setGridParam({ url:url,postData: postData ,page:1 }).trigger("reloadGrid");
		});
		$("#btn_new").click(function(){
			var url2 = url_view;
			url2 += '?cmd=DETAIL';
			url2 += '&page='+$("#grid").getGridParam("page");
			url2 += '&returnUrl='+getReturnUrl();
	        url2 += '&menuId='+'${param.menuId}';
			//검색값
// 	        url2 += '&bzwkSvcKeyName=';
			
	        goNav(url2);
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
				<div class="title">Host Header Default값 관리</div>
				
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">기관 어댑터 업무코드</th>
							<td>
								<input type="text" name="searchBizCode" value="${param.searchBizCode}">
							</td>
							<th style="width:180px;">기관코드</th>
							<td>
								<input type="text" name="searchUbmugign" value="${param.searchUbmugign}">
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

