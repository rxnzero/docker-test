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
<link rel="stylesheet" type="text/css" media="screen" href="<c:url value="/css/w2ui-1.4.3.css"/>" />
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" src="<c:url value="/js/w2ui-1.4.3.js"/>"></script>

<jsp:include page="/jsp/common/include/jqplotCss.jsp"/>
<jsp:include page="/jsp/common/include/jqplotScript.jsp"/>


<script language="javascript" >
var url      ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameDailyMan.json" />';
var url_view ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameDailyMan.view" />';

var plotChart1;			// jqplot 저장 (chart1).
var plotChart2;			// jqplot 저장 (chart2).

function detail(){
	w2ui['myGrid'].clear();
	var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
	postData['totalCount']=0;
	postData['page']=1;
	postData['rows']=1;

	$.ajax({  
		type : "POST",
		url:url,
		dataType:"JSON",
		data:postData,
		success:function(json){
			var data = json;
			var records = data.rows;
			
			var summary = new Object();
			summary.recid ="";
			for(var i=1;i<=31;i++){
				summary["DDTRSMTNOITM"+i] =0;
				summary["DDERRNOITM"+i] =0;
			}
			
			for(var idx in records){
				//insert recid
				records[idx]['recid'] = parseInt(idx)+1;
				for(var i=1;i<=31;i++){
					summary["DDTRSMTNOITM"+i] = summary["DDTRSMTNOITM"+i] + records[idx]["DDTRSMTNOITM"+i] ;
					summary["DDERRNOITM"+i]   = summary["DDERRNOITM"+i]   + records[idx]["DDERRNOITM"+i];
				}				
				
			}
			w2ui['myGrid'].total = data.records;
			w2ui['myGrid'].records = records;

			w2ui['myGrid'].summary.push(summary);
			// End 합계 셋팅.
			w2ui['myGrid'].refresh();				

			if(plotChart1 == undefined || plotChart1 == null)
			{
				var rowsData	= data.rows;
				// 차트 생성.
				plotChart1 = jqLineChart('chart1',rowsData, 31, 'DDTRSMTNOITM', "전송건수");
				plotChart2 = jqLineChart('chart2',rowsData, 31, 'DDERRNOITM', "오류건수");

	 			// Summary CSS 설정.
				$(".ui-jqgrid-ftable tr:first").children("td").css("background-color", "#D4F4FA");	// td 배경색
				$(".ui-jqgrid-ftable tr:first").css("height", "30px");								// tr 높이
				$(".ui-jqgrid-ftable tr:first").css("font-size", "10pt");							// tr 글자 크기
				$(".ui-jqgrid-ftable td:eq(2)").css("text-align", "center");						// td 글자 정렬
			}	
			
		},
    	error:function(xhr,status,error){
    		alert(JSON.parse(xhr.responseText).errorMsg);
    	}
	});
}

$(document).ready(function() {

	$("input[name=searchStart],input[name=searchEnd]").inputmask("9999-99",{'autoUnmask':true});
	$("input[name=searchStart],input[name=searchEnd]").each(function(){
		if ($(this).val() == undefined || $(this).val() == null || $(this).val() == ""){
			$(this).val(getToday());
		}
	});
	function thousandsSeparator(record, ind, col_ind){
		var n = record[this.columns[col_ind].field];
		n = n.toString();
		while(true){
			var n2= n.replace(/(\d)(\d{3})($|,|\.)/g,'$1,$2$3');
			if (n==n2) break;
			n=n2;
		}
		return n;
	};
	$('#myGrid').w2grid({
	    name   : 'myGrid', 
	    datatype:'JSON',
	    method:'POST',
	    multiSelect : false,
	    autoLoad:false,
	    show :{
	    	emptyRecords:false
	    },
	    columnGroups : [
	    	{span : 1, master:true},
	    	{span : 1, master:true},
	    	{span : 1, master:true},
	    	{span : 2, caption:'1'},{span : 2, caption:'2'},{span : 2, caption:'3'},{span : 2, caption:'4'},{span : 2, caption:'5'},
	    	{span : 2, caption:'6'},{span : 2, caption:'7'},{span : 2, caption:'8'},{span : 2, caption:'9'},{span : 2, caption:'10'},
	    	{span : 2, caption:'11'},{span : 2, caption:'12'},{span : 2, caption:'13'},{span : 2, caption:'14'},{span : 2, caption:'15'},
	    	{span : 2, caption:'16'},{span : 2, caption:'17'},{span : 2, caption:'18'},{span : 2, caption:'19'},{span : 2, caption:'20'},
	    	{span : 2, caption:'21'},{span : 2, caption:'22'},{span : 2, caption:'23'},{span : 2, caption:'24'},{span : 2, caption:'25'},
	    	{span : 2, caption:'26'},{span : 2, caption:'27'},{span : 2, caption:'28'},{span : 2, caption:'29'},{span : 2, caption:'30'},
	    	{span : 2, caption:'31'}
	    ],
		columns:[
	        { field : 'recid'           , type:'number'   ,size:'50px'  ,caption:""  ,style :'text-align:right' },
	        { field : 'EAISVCNAME'      , type:'text'     ,size:'200px' ,caption:"업무코드"},
	        { field : 'EAISVCDESC'      , type:'text'     ,size:'200px' ,caption:"업무명"},
	        { field : 'DDTRSMTNOITM1'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM1'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM2'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM2'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM3'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM3'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM4'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM4'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM5'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM5'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM6'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM6'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM7'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM7'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM8'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM8'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM9'   , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM9'     , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM10'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM10'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM11'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM11'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM12'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM12'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM13'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM13'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM14'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM14'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM15'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM15'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM16'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM16'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM17'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM17'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM18'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM18'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM19'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM19'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM20'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM20'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM21'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM21'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM22'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM22'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM23'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM23'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM24'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM24'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM25'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM25'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM26'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM26'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM27'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM27'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM28'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM28'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM29'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM29'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM30'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM30'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDTRSMTNOITM31'  , type:'number'   ,size:'60px'  ,caption:"전송" ,style :'text-align:right' , render:thousandsSeparator },
	        { field : 'DDERRNOITM31'    , type:'number'   ,size:'60px'  ,caption:"오류" ,style :'text-align:right' , render:thousandsSeparator }
				],
		summary:[
	    	{ recid : "", EAISVCNAME:"합 계", EAISVCDESC:"", 
              DDTRSMTNOITM1:"0", DDERRNOITM1:"0", DDTRSMTNOITM2:"0", DDERRNOITM2:"0", DDTRSMTNOITM3:"0", DDERRNOITM3:"0", DDTRSMTNOITM4:"0", DDERRNOITM4:"0", DDTRSMTNOITM5:"0", DDERRNOITM5:"0", 
              DDTRSMTNOITM6:"0", DDERRNOITM6:"0", DDTRSMTNOITM7:"0", DDERRNOITM7:"0", DDTRSMTNOITM8:"0", DDERRNOITM8:"0", DDTRSMTNOITM9:"0", DDERRNOITM9:"0", DDTRSMTNOITM10:"0", DDERRNOITM10:"0", 
              DDTRSMTNOITM11:"0", DDERRNOITM11:"0", DDTRSMTNOITM12:"0", DDERRNOITM12:"0", DDTRSMTNOITM13:"0", DDERRNOITM13:"0", DDTRSMTNOITM14:"0", DDERRNOITM14:"0", DDTRSMTNOITM15:"0", DDERRNOITM15:"0", 
              DDTRSMTNOITM16:"0", DDERRNOITM16:"0", DDTRSMTNOITM17:"0", DDERRNOITM17:"0", DDTRSMTNOITM18:"0", DDERRNOITM18:"0", DDTRSMTNOITM19:"0", DDERRNOITM19:"0", DDTRSMTNOITM20:"0", DDERRNOITM20:"0", 
              DDTRSMTNOITM21:"0", DDERRNOITM21:"0", DDTRSMTNOITM22:"0", DDERRNOITM22:"0", DDTRSMTNOITM23:"0", DDERRNOITM23:"0", DDTRSMTNOITM24:"0", DDERRNOITM24:"0", DDTRSMTNOITM25:"0", DDERRNOITM25:"0", 
              DDTRSMTNOITM26:"0", DDERRNOITM26:"0", DDTRSMTNOITM27:"0", DDERRNOITM27:"0", DDTRSMTNOITM28:"0", DDERRNOITM28:"0", DDTRSMTNOITM29:"0", DDERRNOITM29:"0", DDTRSMTNOITM30:"0", DDERRNOITM30:"0", 
              DDTRSMTNOITM31:"0", DDERRNOITM31:"0"
	    	}
		], 				

		onDblClick: function(event) {
		    var recid = event.recid;
		    
		    var records = this.get(recid);
		    var data =[];

			if(plotChart1 != undefined)
			{
				// 차트 삭제
				plotChart1.destroy();
				plotChart2.destroy();
			}
			
			// 차트 생성.
			data[0]=records;
			plotChart1 = jqLineChart('chart1', data, 31, 'DDTRSMTNOITM', "전송건수");
			plotChart2 = jqLineChart('chart2', data, 31, 'DDERRNOITM', "오류건수");
        }
	});
    detail();
	
	
	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
		
		if(!isFromToDate(postData.searchStart, postData.searchEnd, "yymm"))
		{
			alert("입력한 날짜를 확인하여주십시요.\n"
				 + "시작일 : " + setDateFormat(postData.searchStart) + "\n"
				 + "종료일 : " + setDateFormat(postData.searchEnd));
			return;
		}
		
		if(plotChart1 != undefined)
		{
			// 차트 삭제
			plotChart1.destroy();
			plotChart2.destroy();
		}
		
		plotChart1 = null;
		plotChart2 = null;
		
		// grid 조회
		detail();
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
	<!-- path -->
	<div class="container">
		<div class="right full">
			<p class="nav">${rmsMenuPath}</p>
		</div>
	</div>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">서비스별 일별 거래현황</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	
	
	<!-- button -->
	<table  width="100%" height="35px"  >
	<tr>
		<td align="left">
		<table width="100%">
			<tr>
				<td class="search_td_title" width="120px">업무명</td>
				<td>
					<input type='text' name="searchEaiBzwkDstcd" value="${param.searchEaiBzwkDstcd}" style="width:100%"/>
				</td>
				<td class="search_td_title" width="120px">기간</td>
				<td>
					<input type='text' name="searchStart" value="${param.searchStart}" style="width:80px">~
					<input type='text' name="searchEnd" value="${param.searchEnd}" style="width:80px">
				</td>
			</tr>
		</table>
		</td>
		<td align="right" width="120px">
			<img id="btn_search" src="<c:url value="/images/bt/bt_search.gif"/>" level="R"/>
		</td>
	</tr>
	</table>
	<br>
	<table width="100%">
		<tr width="100%">
			<td width="2%">&nbsp;</td>
			<td width="47%"><div id="chart1"></div></td>
			<td width="4%">&nbsp;</td>
			<td width="47%"><div id="chart2"></div></td>
		</tr>
		<tr width="100%">
			<td colspan=4>&nbsp;</td>
		</tr>
		<tr width="100%">
			<td colspan=4>&nbsp;</td>
		</tr>
	</table>

	<!-- grid -->
	<div id="myGrid" style="width:100%;height:260px"></div>
	</body>
</html>

