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

<jsp:include page="/jsp/common/include/jqplotScript.jsp"/>


<script language="javascript" >
var url      ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameMonthlyMan.json" />';
var url_view ='<c:url value="/onl/statistics/eaisvcname/eaiSvcNameMonthlyMan.view" />';

var plotChart1;			// jqplot 저장 (chart1)
var plotChart2;			// jqplot 저장 (chart2)

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
			for(var i=1;i<=12;i++){
				summary["MNTRSMTNOITM"+i] =0;
				summary["MNERRNOITM"+i] =0;
			}
			
			for(var idx in records){
				//insert recid
				records[idx]['recid'] = parseInt(idx)+1;
				for(var i=1;i<=12;i++){
					summary["MNTRSMTNOITM"+i] = summary["MNTRSMTNOITM"+i] + records[idx]["MNTRSMTNOITM"+i] ;
					summary["MNERRNOITM"+i]   = summary["MNERRNOITM"+i]   + records[idx]["MNERRNOITM"+i];
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
				plotChart1 = jqLineChart('chart1',rowsData, 12, 'MNTRSMTNOITM', "전송건수");
				plotChart2 = jqLineChart('chart2',rowsData, 12, 'MNERRNOITM', "오류건수");

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

	$("input[name=searchStart],input[name=searchEnd]").inputmask("9999",{'autoUnmask':true});
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
	    	{span : 2, caption:'11'},{span : 2, caption:'12'}
	    ],	    
		columns:[
	        { field : 'recid'           , type:'number' ,size:'50px'  , caption:""         , style:'text-align:right'},
	        { field : 'EAISVCNAME'      , type:'text'   ,size:'150px' , caption:"업무코드"  },
	        { field : 'EAISVCDESC'      , type:'text'   ,size:'190px' , caption:"업무명"   },
	        { field : 'MNTRSMTNOITM1'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM1'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM2'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM2'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM3'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM3'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM4'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM4'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM5'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM5'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM6'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM6'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM7'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM7'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM8'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM8'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM9'   , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM9'     , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM10'  , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM10'    , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM11'  , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM11'    , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNTRSMTNOITM12'  , type:'number' ,size:'60px'  , caption:"전송"     , style:'text-align:right' , render:thousandsSeparator },
	        { field : 'MNERRNOITM12'    , type:'number' ,size:'60px'  , caption:"오류"     , style:'text-align:right' , render:thousandsSeparator }
        ],
		summary:[
	    	{ recid : "", EAISVCNAME:"합 계", EAISVCDESC:"", 
              MNTRSMTNOITM1:"0", MNERRNOITM1:"0", MNTRSMTNOITM2:"0", MNERRNOITM2:"0", MNTRSMTNOITM3:"0", MNERRNOITM3:"0", MNTRSMTNOITM4:"0", MNERRNOITM4:"0", MNTRSMTNOITM5:"0", MNERRNOITM5:"0", 
              MNTRSMTNOITM6:"0", MNERRNOITM6:"0", MNTRSMTNOITM7:"0", MNERRNOITM7:"0", MNTRSMTNOITM8:"0", MNERRNOITM8:"0", MNTRSMTNOITM9:"0", MNERRNOITM9:"0", MNTRSMTNOITM10:"0", MNERRNOITM10:"0", 
              MNTRSMTNOITM11:"0", MNERRNOITM11:"0", MNTRSMTNOITM12:"0", MNERRNOITM12:"0"
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
			plotChart1 = jqLineChart('chart1',data, 12,'MNTRSMTNOITM', "전송건수");
			plotChart2 = jqLineChart('chart2',data, 12,'MNERRNOITM', "오류건수");
        }
	});
	detail();
	
	$("#btn_search").click(function(){
		var postData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로
		
		if(!isFromToDate(postData.searchStart, postData.searchEnd))
		{
			alert("입력한 날짜를 확인하여주십시요.\n"
				 + "시작일 : " + setDateFormat(postData.searchStart) + "\n"
				 + "종료일 : " + setDateFormat(postData.searchEnd));
			return;
		}
	
		if(plotChart1 != undefined)
		{
			plotChart1.destroy();
			plotChart2.destroy();
		}
		
		plotChart1 = null;
		plotChart2 = null;
		
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
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">서비스별 월별 거래현황</p>
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

