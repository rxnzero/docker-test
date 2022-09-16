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

<script language="javascript" >
var url      = '<c:url value="/onl/transaction/online/transactionStatus.json" />';
var url_view = '<c:url value="/onl/transaction/online/transactionStatus.view" />';
var recentYn="N";
var stop = false;
var selectName = "searchEaiBzwkDstcd";	// selectBox Name
function w2GridToExcelSubmit(url,cmd,gridObj,formObject,fileName,merge){
	
	var postData = formObject.serializeArray();	
	postData.push({
		name : "cmd",
		value : cmd
	});
	//fileName 필수값 아님
	if (fileName != undefined){
		postData.push({
			name : "fileName",
			value : encodeURI(fileName)
		});	
	}
	
	//grid data
	var data = gridObj.records;
	var gridData = new Array();
	var records= new Array();
	for ( var i = 0; i < data.length; i++) {
		records[i] = new Object();
		records[i]['P100'] = data[i]['P100'].toString();
		records[i]['P200'] = data[i]['P200'].toString();
		records[i]['P300'] = data[i]['P300'].toString();
		records[i]['P400'] = data[i]['P400'].toString();
		records[i]['E100'] = data[i]['E100'].toString();
		records[i]['E200'] = data[i]['E200'].toString();
		records[i]['E300'] = data[i]['E300'].toString();
		records[i]['E400'] = data[i]['E400'].toString();
		records[i]['E900'] = data[i]['E900'].toString();
		records[i]['E9300'] = data[i]['E9300'].toString();
		records[i]['E9400'] = data[i]['E9400'].toString();
		records[i]['E9900'] = data[i]['E9900'].toString();

		records[i]['BIZNAME'] = data[i]['BIZNAME'];
		records[i]['SVCCODE'] = data[i]['SVCCODE'];
		records[i]['INSTNAME'] = data[i]['INSTNAME'];
		records[i]['SVCNAME'] = encodeURI(data[i]['SVCNAME']);
		records[i]['AVGEAI'] = data[i]['AVGEAI'].toString();
		records[i]['AVGPSV'] = data[i]['AVGPSV'].toString();
		records[i]['AVGTOTAL'] = data[i]['AVGTOTAL'].toString();
		gridData.push(records[i]);
	}

	postData.push({
		name : "gridData",
		value : JSON.stringify(gridData)
	});
	
			
	//grid titles

	var colM = gridObj.columns;
	var headers      = new Array();
	var headerTitles = new Array(); 
	for(var i=0;i<colM.length;i++){
		if (colM[i].hidden){
		}else{
			headers.push(encodeURI(colM[i].field));
			headerTitles.push(encodeURI(colM[i].caption));
		}
	}
	postData.push({
		name : "header",
		value : JSON.stringify(headers)
	});		
	postData.push({
		name : "headerTitle",
		value : JSON.stringify(headerTitles)
	});	
	if (merge != undefined){
		postData.push({
			name : "merge",
			value : JSON.stringify(merge)
		});	
	}
	
	
	var form="<form action='"+url+"' method='post' target='excelDown'>";
	$.each(postData,function(_,obj){
		form +="<input type='hidden' name='"+obj.name+"' value='"+obj.value+"'/>";
	});
	form += "</form>";
	$(form).appendTo("body").submit().remove();
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
function detail(){
	w2ui['myGrid'].clear();

	var postData = getSearchForJqgrid("cmd","DETAIL"); 
	postData['totalCount']=0;
	postData['page']=1;
	postData['rows']=1;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:postData,
		success:function(json){
			var data = json;
			var records = data.rows;
			var cnt = 1;
			//grid에서 recid가 반드시 필요.
			for(var idx in records){
				//insert recid
				records[idx]['recid'] = parseInt(idx)+1;
			}
			var total = parseInt(data.records);
			//add records
			w2ui['myGrid'].total = total;
			//data count
			w2ui['myGrid'].records = records;
			//add summary
			
			var summary = data.summary;
			//변환
			summary.AVGEAI   = String((summary.AVGEAI/total).toFixed(3));
			summary.AVGPSV   = String((summary.AVGPSV/total).toFixed(3));
			summary.AVGTOTAL = String((summary.AVGTOTAL/total).toFixed(3));
			//추가데이터
			summary.recid = 99999;
			summary.BIZNAME =" 합 계";
			summary.SVCCODE ="";
			summary.INSTNAME ="";
			summary.summary = true;

			w2ui['myGrid'].summary[0]=summary;
			//summary.summary = true;
			w2ui['myGrid'].refresh();
		},
	    error:function(xhr,status,error){
	    	alert(JSON.parse(xhr.responseText).errorMsg);
	    	//clearInterval(timer);
	    }
	});
	
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
	};
$( document ).ready(function() {
	init(detail,"N");
	$('#myGrid').w2grid({ 
	    name   : 'myGrid', 
	    datatype:'json',
	    method:'POST',
	    //url : url,
	    //data : postData,
	    show :{ emptyRecords:false
	    },
	    columnGroups : [
	    	{span : 3, caption:'IF'},
	    	{span : 4, caption:'전문구간별 처리건수'},
	    	{span : 5, caption:'전문구간별 에러건수'},
	    	{span : 3, caption:'타임아웃'},
	    	{span : 3, caption:'평균처리시간'},
	    	{span : 1, caption:'서비스설명',master:true}
	    ],
 
	    columns: [          
		             
		             { field : 'BIZNAME'    	, type:'text'	, caption : '업무구분명' , size: '120px'    },
		             { field : 'SVCCODE'    	, type:'text'	, caption : '서비스코드' , size: '148px'    },
		             { field : 'INSTNAME'  	    , type:'text'	, caption : '인스턴스명' , size: '90px'     },
		             
		             { field : 'P100'       		,type:'text'	,caption : '100'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator },
		             { field : 'P200'       		,type:'text'	,caption : '200'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator  },
		             { field : 'P300'       		,type:'text'	,caption : '300'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator   },
		             { field : 'P400'       		,type:'text'	,caption : '400'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator  },
                                           
		             { field : 'E100'       		,type:'text'	,caption : '100'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator  },
		             { field : 'E200'       		,type:'text'	,caption : '200'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator   },
		             { field : 'E300'      		    ,type:'text'	,caption : '300'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator  },
		             { field : 'E400'       		,type:'text'	,caption : '400'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator   },
		             { field : 'E900'       		,type:'text'	,caption : '900'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator   },

		             { field : 'E9300'      		,type:'text'	,caption : '300'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator   },
		             { field : 'E9400'      		,type:'text'	,caption : '400'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator  },
		             { field : 'E9900'      		,type:'text'	,caption : '900'  , size: '50px' ,style:'text-align:right', render:thousandsSeparator   },

		             { field : 'AVGEAI'     	    ,type:'text'	,caption : 'IF'	  , size: '50px' ,style:'text-align:right' },
		             { field : 'AVGPSV'     	    ,type:'text'	,caption : '수동'	  , size: '50px' ,style:'text-align:right' },
		             { field : 'AVGTOTAL'   	    ,type:'text'	,caption : '총'	  , size: '50px' ,style:'text-align:right' },
		             
		             { field : 'SVCNAME'    	    ,type:'text'	,caption : '서비스설명' 	, size: '200px'}

	    ]
	    
		,summary:[
	    	{ recid : 99999, BIZNAME:"합 계", SVCCODE:"", INSTNAME:"", P100:"0", P200:"0", P300:"0", P400:"0",
	    		 E100:"0", E200:"0", E300:"0", E400:"0", E900:"0", E9300:"0", E9400:"0", E9900:"0", AVGEAI:"0.000", AVGPSV:"0.00", AVGTOTAL:"0.000", SVCNAME:" "}
		] 
			
	});
	//w2ui['myGrid'].hideColumn('BIZCODE');

	$("#btn_10min").click(function(){
		recentYn="Y";
		detail(recentYn);
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
	$("#btn_stop").click(function(){
		detail(false);
		if(stop){
		$("#btn_stop").attr('src','<c:url value="/images/bt/bt_stop.gif"/>');
		 stop = false;
		
		}else{	
		$("#btn_stop").attr('src','<c:url value="/images/bt/bt_stop.gif"/>');
		 stop = true;
		
		} 
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
           merge.push(makeMerge("서비스설명","0","1","18","18"));
           
		w2GridToExcelSubmit(url,"LIST_GRID_TO_EXCEL",w2ui['myGrid'],$("#ajaxForm"),"전문별 거래현황",merge);
		return false;
	});	
	$("#btn_search").click(function(){
		detail(false);
	});	
	buttonControl();
	/*
 	timer = setInterval(function(){
		if(stop) return;
		detail(recentYn);
	},5000);
	*/

});

 
</script>
</head>
	
</body>
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
				<div id="myGrid"  style="width:100%;height:400px" ></div>
			
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>