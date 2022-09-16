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
var url      = '<c:url value="/onl/transaction/online/transactionStatus.json" />';
var url_view = '<c:url value="/onl/transaction/online/transactionStatus.view" />';
var timer;
var recentYn="N";
var selectName = "searchEaiBzwkDstcd";	// selectBox Name
function list(recentYn){
	var postData = getSearchForJqgrid("cmd","DETAIL"); //jqgrid에서는 object 로
	postData["recentYn"] = recentYn;
	$("#grid").setGridParam({ url:url,postData: postData }).trigger("reloadGrid");
}
	
function thousandsSeparator(record, ind, col_ind){
	var n = record[this.columns[col_ind].field];
	n = n.toString();
	while(true){
		var n2= n.replace(/(\d)(\d{3})($|,|\.)/g,'$1,$2$3');
		if (n==n2) break;
		n=n2;
	}
	return n;
}
function init(callback,recentYn) {
	$.ajax({
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_DETAIL_COMBO'},
		success:function(json){
			new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=searchEaiBzwkDstcd]")).setNoValueInclude(true).setNoValue("","전체").setData(json.bizList).setFormat(codeName3OptionFormat).rendering();
			
			
			$("select[name=searchEaiBzwkDstcd]").val("${param.searchEaiBzwkDstcd}");
			
			setSearchable(selectName);	// 콤보에 searchable 설정
			
			if (typeof callback === 'function') {
				callback(recentYn);
			}

		},
		error:function(e){
			alert(e.responseText);
		}
	});
	
}
$(document).ready(function() {	
	//var gridPostData = getSearchForJqgrid("cmd", "LIST"); //jqgrid에서는 object 로 
	init(list,"N");
	$('#grid').jqGrid({
		datatype : "json",
		mtype : 'POST',
		colNames : [ 
		             '업무구분코드',
		             '업무구분명',
		             '서비스코드',
		             '100',
		             '200',
		             '300',
		             '400',
		             '100',
		             '200',
		             '300',
		             '400',
		             '900',
		             '300',
		             '400',
		             '900',
		             'IF',
		             '수동',
		             '총',
		             '서비스설명'
		              ],
		colModel : [ 
		             { name : 'BIZCODE'    , hidden : true },
		             { name : 'BIZNAME'    , align : 'left'    },
		             { name : 'SVCCODE'    , align : 'center'	, width: '148'    },
		             { name : 'P100'       , align : 'center'   , width:'50'	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'  },
		             { name : 'P200'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'P300'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'P400'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
                                           
		             { name : 'E100'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E200'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E300'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E400'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E900'       , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},

		             { name : 'E9300'      , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E9400'      , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},
		             { name : 'E9900'      , align : 'center'   , width:'50'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'sum'},

		             { name : 'AVGEAI'     , align : 'center'   , width:'46'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'avg'},
		             { name : 'AVGPSV'     , align : 'center'   , width:'46'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'avg'},
		             { name : 'AVGTOTAL'   , align : 'center'   , width:'46'  	,formatter:'integer',formatoptions:{thousandsSeparator:","},summaryType:'avg'},
		             
		             { name : 'SVCNAME'    , align : 'center'   , width:'200'}

		              ],
		jsonReader : {
			repeatitems : false
		},
		footerrow:true,
		userDataOnFooter:true,
		rowNum: 10000,
		height : 480,
		viewrecords : true,
		gridview: true,
		frozen:true,
		gridComplete:function (d){
			var colModel = $(this).getGridParam("colModel");
			for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
			}
		
		},			
	    loadComplete:function (d){
	    	var rowCnt = $('#grid').getGridParam("reccount");
	    	var colModel = $(this).getGridParam("colModel");
	    	for(var i = 0 ; i< colModel.length; i++){
				$(this).setColProp(colModel[i].name, {sortable : false});
				var propName = colModel[i].name;
				var summaryType = colModel[i].summaryType;
				var Total = $('#grid').jqGrid('getCol',propName,false,'sum');
				if(summaryType =='avg'){
					if(rowCnt == 0) {
						Total = 0;
					}else{
	    				Total = (Total/rowCnt).toFixed(3);		//avg를 바로 쓰면 row 수가 +1 되어 계산됨.
					}
	    		}
	    		eval("$('#grid').jqGrid('footerData','set',{BIZNAME:'합계', "+propName+":Total});");
	    	}
			
			$(".ui-jqgrid-ftable tr:first").children("td").css("background-color", "#D4F4FA");	// td 배경색
			$(".ui-jqgrid-ftable tr:first").css("height", "30px");								// tr 높이
			$(".ui-jqgrid-ftable tr:first").css("font-size", "10pt");							// tr 글자 크기
			$(".ui-jqgrid-ftable td:eq(1)").css("text-align", "center");						// td 글자 정렬	    	

			$(".ui-jqgrid-ftable").css('position','fixed');					// 소계 하단에 고정
			$(".ui-jqgrid-ftable").css('bottom','0');
			
	    },
	    loadError:function(xhr,status,error){
	    	//alert(error);
	    	//clearInterval(timer);
	    }	
		
	});
	$("#grid").jqGrid('setGroupHeaders', {
  		useColSpanStyle: true, 
  		groupHeaders:[
			{startColumnName: 'P100', numberOfColumns: 4, titleText: '전문구간별 처리건수'},
			{startColumnName: 'E100', numberOfColumns: 5, titleText: '전문구간별 에러건수'},
			{startColumnName: 'E9300', numberOfColumns: 3, titleText: '타임 아웃'},
			{startColumnName: 'AVGEAI', numberOfColumns: 3, titleText: '평균처리시간(초)'}
  		]
	});
	
	$("#btn_10min").click(function(){
		recentYn ="Y";
		list(recentYn);
	});
	$("#btn_detail").click(function(){
	    var args = new Object();
	    args['userId'] = $("input[name=userId]").val();
	    
	    var url2 = url_view;
	    url2 += "?cmd=POPUP";
	    showModal(url2,args,470,740);
	});	
	$("#btn_initialize").click(function(){
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'INITIALIZE',recentYn:recentYn},
			success:function(json){
				alert("성공하였습니다.");
			},
			error:function(e){
				alert(e.responseText);
			}
		});		
		
	});	
	$("#btn_download").click(function(event) {
		 event.stopPropagation(); // Do not propagate the event.
         // Create an object that will manage to download the file.
         var merge = new Array();
         merge.push(makeMerge("IF","0","0","0","2"));
         merge.push(makeMerge("전문구간별 처리건수","0","0","3","6"));
         merge.push(makeMerge("전문구간별 에러건수","0","0","7","11"));
         merge.push(makeMerge("타임아웃","0","0","12","14"));
         merge.push(makeMerge("평균처리시간(초)","0","0","15","17"));
         merge.push(makeMerge("서비스설명","0","0","0","18"));
           
		gridToExcelSubmit(url,"LIST_GRID_TO_EXCEL",$("#grid"),$("#ajaxForm"),"전문별 거래현황",merge);
		return false;
	});	
	$("#btn_search").click(function(){
		list(recentYn);
	});	
	buttonControl();
	
	
	window.onload=function(){
		list(recentYn);
	}
	 timer = setInterval(function(){
		list(recentYn);
	},5000);
	 
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
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
					<img src="<c:url value="/img/btn_10min.png"/>" alt="" id="btn_10min" level="W" />
					<img src="<c:url value="/img/btn_detail.png"/>" alt="" id="btn_detail" level="R" />
					<img src="<c:url value="/img/btn_initialize.png"/>" alt="" id="btn_initialize" level="W" />
					<img src="<c:url value="/img/btn_download.png"/>" alt="" id="btn_download" level="W"/>
				</div>
				<div class="title">전문별 거래현황(일누적)<span class="tooltip">100=요청수신 200=요청송신 300=응답수신 400=응답송신 900=IF내부에러</span></div>
				<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">업무구분명</th>
							<td>
									<!-- searchable은 select-style 적용하면 안됨  -->
									<select name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}">	
									</select>
									
		
							</td>
							<th style="width:180px;">IF서비스코드필터(콤마구분)</th>
							<td>
								<div style="position: relative; width: 100%;">
									<input type="text" name="searchFilter" value="${param.searchFilter}">									
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

