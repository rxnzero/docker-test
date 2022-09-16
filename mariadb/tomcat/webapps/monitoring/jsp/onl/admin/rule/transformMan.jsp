<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="com.eactive.eai.rms.common.login.SessionManager"%>
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
var url      = '<c:url value="/onl/admin/rule/transformMan.json" />';
var url_view = '<c:url value="/onl/admin/rule/transformMan.view" />';
var roleString	= "<%=SessionManager.getRoleIdString(request)%>";

function dateFormater(cellvalue, options, rowObject){
	if (cellvalue==null|| cellvalue==undefined) return "";
	if (cellvalue.trim().length !=14) return "";
	var display = "";
	display=display+cellvalue.substr(0,4)+"-";
	display=display+cellvalue.substr(4,2)+"-";
	display=display+cellvalue.substr(6,2)+" ";

	display=display+cellvalue.substr(8,2)+":";
	display=display+cellvalue.substr(10,2)+":";
	display=display+cellvalue.substr(12,2);
	
	return display;
}	


$(document).ready(function() {	
	$('#grid').jqGrid({
		datatype:"json",
		mtype: 'POST',
		url: url,
		postData : { cmd : 'LIST'
			       , searchBizCode   : $('input[name=searchBizCode]').val()
			       , searchCnvsnName : $('input[name=searchCnvsnName]').val()
			       , searchCnvsnDesc : $('input[name=searchCnvsnDesc]').val()
			       
		},
		colNames:['업무구분코드',
                  '전문레이아웃 변환 매핑 코드',
                  '전문레이아웃 변환 매핑 설명',
                  'IF서비스코드',
                  'IF서비스설명',
                  '수정일자'
                  ],
		colModel:[
				{ name : 'EAIBZWKDSTCD' , align:'left' ,sortable:false },
				{ name : 'CNVSNNAME'    , align:'left'  },
				{ name : 'CNVSNDESC'    , align:'left'  },
				{ name : 'EAISVCNAME'   , align:'left'  },
				{ name : 'EAISVCDESC'   , align:'left'  },
				{ name : 'LASTAMNDHMS'  , align:'left'  , formatter: dateFormater }
				],
        jsonReader: {
             repeatitems:false
        },	          
		pager : $('#pager'),
		page : '${param.page}',
		rowNum : '${rmsDefaultRowNum}',
	//	height : '500',
	    autoheight: true,
	    height: $("#container").height(),
		autowidth: true,
		viewrecords: true,
		//toppager: true,
		rowList : eval('[${rmsDefaultRowList}]'),
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});			
			}
		
		},			
		ondblClickRow: function(rowId) {
			var rowData = $(this).getRowData(rowId); 
            var cnvsnName = rowData['CNVSNNAME'];
            var eaiSvcName = rowData['EAISVCNAME'];
            var eaiSvcDesc = rowData['EAISVCDESC'];
            var cnvsnDesc = rowData['CNVSNDESC'];
            var url2 = url_view;
            url2 += '?cmd=DETAIL';
            url2 += '&page='+$(this).getGridParam("page");
            url2 += '&returnUrl='+getReturnUrl();
            url2 += '&menuId='+'${param.menuId}';
			//검색값
            url2 += '&' + getSearchUrl();
			
            //key값
            url2 += '&cnvsnName='+cnvsnName;
            url2 += '&eaiSvcName='+eaiSvcName;
            url2 += '&eaiSvcDesc='+eaiSvcDesc;
            url2 += '&cnvsnDesc='+cnvsnDesc;
    		goNav(url2);
        }		
	});
	
	
	resizeJqGridWidth('grid','content_middle','1000');

	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$("#grid").setGridParam({ postData: postData ,page : "1"  }).trigger("reloadGrid");

	});
	$("#btn_new").click(function(){
		var url2 = url_view;
		url2 += '?cmd=NEW';
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
	$("#btn_initialize").click(function(){
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZES'},
			success:function(json){
				alert(json.message);
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
		
	});		
	
	buttonControl();
	setBtnHide(roleString, "admin", "btn_initialize");
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
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" />
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />				
				</div>
				<div class="title">전문레이아웃 변환 매핑<span class="tooltip">전문레이아웃 변환 매핑엔진의 매핑규칙을 조회하는 화면입니다.</span></div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">업무구분 코드</th>
							<td>
								<input type="text" name="searchBizCode" value="${param.searchBizCode}">
							</td>
							<th style="width:180px;">전문레이아웃 변환매핑 코드</th>
							<td>
								<input type="text" name="searchCnvsnName" value="${param.searchCnvsnName}">
							</td>
						</tr>
						<tr>
							<th style="width:180px;">전문레이아웃 변환 매핑 설명</th>
							<td colspan="3">
								<input type="text" name="searchCnvsnDesc" value="${param.searchCnvsnDesc}">
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

