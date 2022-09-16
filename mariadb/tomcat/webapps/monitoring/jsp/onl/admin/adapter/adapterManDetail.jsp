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

var selectName = "EAIBZWKDSTCD";	// selectBox Name
var prptyDomain =[];		//도메인 정보를 전역변수로 선언함
var isDetail = false;
var lastRadioVal = {};		//라디오박스의 최종값 저장(네임:값)
function isValid(){
	if($('input[name=ADPTRBZWKGROUPNAME]').val() == ""){
		alert("어댑터 그룹명을 입력하여 주십시요.");
		return false;
	}
	
	if($('select[name=ADPTRCD]').val() == ""){
		alert("어댑터 유형을 선택하여 주십시요.");
		return false;
	}
	
	return true;
}
function localSave(){
	var key =$("input[name=ADPTRBZWKNAME]").val();
	//객체 생성
	var save ={};
	$("#adapter input,#adapter select").not('select[name=ADAPTERLIST]').each(function(){
		var name = $(this).attr('name').toUpperCase();
		save[name] = $(this).val();
	});
	var fullData = $("#grid").getRowData();
	//getRowData 하면 select html 그대로 들어가기 때문에 추가함
	for(var i=0;i<fullData.length;i++){
		var keyName = fullData[i].PRPTYGROUPNAME+"_"+fullData[i].PRPTYNAME;
		keyName = keyName.replace(/[.\{\}]/g,'');								//Name은 . 또는 {} 포함안되므로 치환
		var domainType = fullData[i].DOMAINTYPE;
		if(fullData[i].DOMAINTYPE != null && fullData[i].DOMAINTYPE != "" ){
			if(domainType.toUpperCase() == "SELECT"){
				fullData[i]["PRPTY2VAL"]= $("select[name="+keyName+"] option:selected").val();
			}else if(domainType.toUpperCase() == "RADIO"){
				fullData[i]["PRPTY2VAL"]= $("input:radio[name="+keyName+"]:checked").val();
			} else if(domainType.toUpperCase() == "CHECK"){
				fullData[i]["PRPTY2VAL"]= $("input:checkbox[name="+keyName+"]:checked").val();
			}
			
		}else{
				fullData[i]["PRPTY2VAL"]=fullData[i]["PRPTY2VAL"].replace(/&nbsp;/g,' ');
		}
		fullData[i]["PRPTYGROUPNAME"]=$("input[name=PRPTYGROUPNAME]").val();
		
	}
	save["rows"]=fullData;	
	submitData[key]=save;	
}
function init(key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=EAIBZWKDSTCD]")).setFormat(codeName3OptionFormat).setData(json.bizRows).rendering();				// 업무구분코드
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRCD]")).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.adapterTypeRows).rendering();	// 어댑터 유형
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRMSGDSTCD]")).setFormat(codeName3OptionFormat).setData(json.msgTypeRows).rendering();			// 메시지타입
			new makeOptions("CODE","NAME").setObj($("select[name=EAISEVRINSTNCNAME]")).setData(json.instanceRows).rendering();										// 서버인스턴스명
			
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRIODSTCD]")).setData(json.adptrIoDstcdRows).setFormat(codeName3OptionFormat).rendering();		// IN/OUT 구분
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRMSGPTRNCD]")).setData(json.adptrMsgPtrnCdRows).setFormat(codeName3OptionFormat).rendering();	// 표준/비표준 구분
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRUSEYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();				// 어댑터 사용구분
			new makeOptions("CODE","NAME").setObj($("select[name=SNDRCVHMSLOGYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			// 송수신 로그여부
			new makeOptions("CODE","NAME").setObj($("select[name=SPCFCLUUSEYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();				// 특정LU 사용여부
			new makeOptions("CODE","NAME").setObj($("select[name=REALTIMEBZWKYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			// 24시 업무여부
			new makeOptions("CODE","NAME").setObj($("select[name=SESSIONYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			    // session사용여부
			new makeOptions("CODE","NAME").setObj($("select[name=TARGETADAPTERYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			// targetAdapter 사용여부
				
			if(key == "")
			{
				$("input[name=REFCLSNAME]").val(json.refClsName);	// 어댑터 신규 입력할 때 참조 클래스명 default setting.
				setSearchable(selectName);	// 콤보에 searchable 설정
			}
			
			
			if(typeof callback === 'function') {
				callback(key);
    		}
				
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}
function detail(key){
	if (!isDetail) return ;
	
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL'
		    , ADPTRBZWKGROUPNAME : key
		    },
		success:function(json){
			var detail = json.detail;
			var adapters = json.detail.adapters;
			var prop = json.detail.adapters[0];
			prptyDomain = json.dInfo;
						//도메인 정보
		
			//adapterGroup
			$("input[name=ADPTRBZWKGROUPNAME]").attr('readonly',true);
			
			$("#detail input,#detail select").each(function(){
				var name = $(this).attr('name').toUpperCase();
				$(this).val(detail[name]);
			});
			//adapter
			if (adapters.length > 0){
				$("#adapter input,#adapter select").not('select[name=ADAPTERLIST]').each(function(){
					var name = $(this).attr('name').toUpperCase();
					$(this).val(adapters[0][name]);
				});
				//addoption
				new makeOptions("PRPTYGROUPNAME","PRPTYGROUPNAME").setObj($("select[name=ADAPTERLIST]")).setData(adapters).rendering();
				for(var i=0;i<adapters.length;i++){
					submitData[adapters[i]["PRPTYGROUPNAME"]]=adapters[i];
				}
			}
			//prop 
			$("#grid")[0].addJSONData(prop);
			
			setSearchable(selectName);	// 콤보에 searchable 설정
		},
		error:function(e){
			alert(e.responseText);
		}
	});


}

function mltplFormatter (cellvalue, options,rowObject){


 	if(rowObject.DMNKND != null && rowObject.DMNKND != "" && rowObject.DOMAINTYPE != null){	
 		if(rowObject.DOMAINTYPE.toUpperCase() == "SELECT"){
			return setSelectCombo(rowObject);
		}else if(rowObject.DOMAINTYPE.toUpperCase() == "RADIO"){
			var val= setRadio(rowObject);
			return val;
		}else if(rowObject.DOMAINTYPE.toUpperCase() == "CHECK"){
			return setCheckbox(rowObject);
		}else{
			return cellvalue;
		}
	}else{ 
		if(cellvalue === undefined || cellvalue == null){
			return '';	 
		}
		cellvalue = cellvalue.replace(/[ ]/g,'&nbsp;');
		return cellvalue;
	}
	//return '<pre>'+cellvalue + '</pre>';
}

function mltplUnFormatter (cellvalue, options,rowObject){
	var name = (rowObject.PRPTYGROUPNAME==null?"":rowObject.PRPTYGROUPNAME)+"_"+rowObject.PRPTYNAME;
	name = name.replace(/[.\{\}]/g,''); 									//name 에는 . {} 못들어가서 제거
	if(rowObject.DMNKND != null && rowObject.DMNKND != "" && rowObject.DOMAINTYPE != null){
 		if(rowObject.DOMAINTYPE.toUpperCase() == "SELECT"){
			return $("select[name="+name+"] option:selected").val();
		}else if(rowObject.DOMAINTYPE.toUpperCase() == "RADIO"){
			//return setRadio(rowObject);
		}else if(rowObject.DOMAINTYPE.toUpperCase() == "CHECK"){
			//return setCheckbox(rowObject);
		}else{
			return cellvalue;
		}	
		
	}
	else{
		return cellvalue.replace(/&nbsp;/g,' ');
	}	
}

function setSelectCombo(rows){
	var domainName = rows.DMNKND;
	var value = rows.PRPTY2VAL;
	var result="";

	var data = prptyDomain[domainName].data;
	if(data == null || data.length == 0){  
		console.log("도메인명 : "+domainName +" 코드 조회 안됨"); 
				
	} 
	var name = (rows.PRPTYGROUPNAME==null?"":rows.PRPTYGROUPNAME)+"_"+rows.PRPTYNAME;
	name = name.replace(/[.\{\}]/g,'');
	result='<select name="'+name+'" style="width:100%">';
	//result += '<option value=""></option>';
	for(var idx=0;idx < data.length; idx++){
		if(data[idx].CODE == value)
			result += '<option value="'+ data[idx].CODE+'" selected>'+data[idx].NAME +'</option>';
		else
			result += '<option value="'+ data[idx].CODE+'">'+data[idx].NAME +'</option>';
	}

	result +='</select>';	

	return result;
}
function setRadio(rows){
	var domainName = rows.DMNKND;
	var value = rows.PRPTY2VAL;
	var result="";

	var data = prptyDomain[domainName].data;
	if(data == null || data.length == 0){  
		console.log("도메인명 : "+domainName +" 코드 조회 안됨"); 
	} 
	var name = (rows.PRPTYGROUPNAME==null?"":rows.PRPTYGROUPNAME)+"_"+rows.PRPTYNAME;
	name = name.replace(/[.\{\}]/g,'');

	for(var idx=0;idx < data.length; idx++){
		if(data[idx].CODE == value){
			result += '<input type="radio" name="'+name+'" value="'+ data[idx].CODE+'"  checked>'+data[idx].NAME+" ";
			lastRadioVal[name] = value;
		}else{
			result += '<input type="radio" name="'+name+'" value="'+ data[idx].CODE+'" >'+data[idx].NAME+" ";
		}
	}

	return result;
}

function setCheckbox(rows){

	var domainName = rows.DMNKND;
	var value = rows.PRPTY2VAL;
	var result="";
	
	var data = prptyDomain[domainName].data;
	if(data == null || data.length == 0){  
		console.log("도메인명 : "+domainName +" 코드 조회 안됨"); 
	} 
	var name = (rows.PRPTYGROUPNAME==null?"":rows.PRPTYGROUPNAME)+"_"+rows.PRPTYNAME;
	name = name.replace(/[.\{\}]/g,'');

	
	for(var idx=0;idx < data.length; idx++){
		if(data[idx].CODE == value)
			result += '<input type="checkbox" name="'+name+'" value="'+ data[idx].CODE+'" checked>'+data[idx].NAME+" ";
		else
			result += '<input type="checkbox" name="'+name+'" value="'+ data[idx].CODE+'">'+data[idx].NAME+" ";
	}

	return result;
}
//도메인 타입이 null이면 조건체크 중에 에러 발생해서 공백으로 치환
function nullFormatter(cellvalue, options, rowData){
	if(cellvalue === undefined || cellvalue == null || cellvalue ==='NULL'){
		cellvalue='';
	}
	return cellvalue;
}
function gridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
	    editurl : "clientArray",
		loadonce: true,
		rowNum: 10000,
		autoencode:false,
		colNames:['프라퍼티그룹명',
                  '프라퍼티명',
                  '프라퍼티값',
                  '도메인명',
                  '입력도메인'
                  ],
		colModel:[
				{ name : 'PRPTYGROUPNAME' , align:'left' , hidden: true },
				{ name : 'PRPTYNAME'      , align:'left'  },
				{ name : 'PRPTY2VAL'      , align:'left' , title:false, editable: true, formatter:mltplFormatter, unformatter:mltplUnFormatter},
				{ name : 'DMNKND'	  	  ,hidden:true},
				{ name : 'DOMAINTYPE'	  ,hidden:true, formatter:nullFormatter}
				],
        jsonReader: {
             repeatitems:false
        },	   
        loadComplete : function (data) {
		
        },
        gridComplete : function(){
			//라디오 버튼의 해제 기능
			$(":radio").unbind("click");
			$("input[type=radio]").bind('click',function(){
				var name = $(this).attr('name');	
				var lastVal = lastRadioVal[name];
				if(lastVal == $(this).val()){
					$(this).attr('checked',false);
					lastRadioVal[name]= ''; 
				}else{
					lastRadioVal[name]= $(this).val();
				}     
								
			});  
        },
	    onSelectRow: function(rowid,status){
	    	var rowData = $(this).getRowData(rowid);
	    	var domainName = rowData.DMNKND;
	    	var domainType = rowData.DOMAINTYPE;
	    	if(domainType.toUpperCase() == 'SELECT' || domainType.toUpperCase() == 'CHECK' || domainType.toUpperCase() == 'RADIO') return;

	    	if (lastsel2 !=undefined){
	            if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
	        	  $("#grid").saveRow(lastsel2,false,"clientArray");
				}
	    	}
	    	
	        $('#grid').restoreRow(lastsel2);       
	        $('#grid').editRow(rowid,true);
	       
	       //도메인 지정
	        if(domainName != null && domainName != "" && prptyDomain[domainName] != null)
	        	$("input[name=PRPTY2VAL]").inputmask(prptyDomain[domainName]["info"].DOMAINVAL,{'autoUnmask':true});
	        	
	        var val = $('input[name=PRPTY2VAL]').val();
	        $('input[name=PRPTY2VAL]').val(val.replace(/&nbsp;/g,' '));	//Html Text --> Inputbox Text : &nbsp --> ' '	   
	        lastsel2=rowid;
	    },        
        onSortCol : function(){
        	return 'stop';	//정렬 방지
        },         
	    height: '300',
		autowidth: true,
		viewrecords: true
	});	
	resizeJqGridWidth('grid','content_middle','1000');
}

var submitData = {};
var lastsel2;
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();

	$("img,select[name=ADAPTERLIST]").click(function(){
		if($("#grid tr#" + lastsel2).attr("editable") == 1){ //editable=1 means row in edit mode
          $("#grid").saveRow(lastsel2,false,"clientArray");
		}
	});
	
	var key ="${param.adptrBzwkGroupName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}
	gridRendering();	
	init(key,detail);

	$("#btn_modify").click(function(){
		if (!isValid())return;
	
		// 수정 할 때만 confirm 실행.
		if(isDetail)
		{
			var r = confirm("어댑터 정보가 즉시 적용됩니다.\n저장 하시겠습니까?");
			if (r == false) return;
		}
		
		//공통부만 form으로 구성
		var postData = $('#ajaxForm').serializeArray();
		
		postData.push({ name: "ADAPTERDATA" , value:JSON.stringify(submitData)});
		
		if (isDetail){
			postData.push({ name: "cmd" , value:"UPDATE"});
		}else{
			postData.push({ name: "cmd" , value:"INSERT"});
		}
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				if(args.status=="error"){
					alert("동기화중 오류입니다.\n확인하여 주십시요.\n"+args.message);
				}else{
					alert("저장 되었습니다.");
					goNav(returnUrl);//LIST로 이동
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("#btn_clone").click(function(){
		var newAdapterGroupName = $("input[name=NEWADPTRBZWKGROUPNAME]");	// 복제할 어댑터 그룹명
		if (!isValid())return;
		
		// 복제할 어댑터 그룹명이 입력되었는지 체크.
		if(newAdapterGroupName.val() == "")
		{
			alert("복제할 어댑터 그룹명을 입력하여 주십시요.");
			newAdapterGroupName.focus();
			return;
		}
	
		//공통부만 form으로 구성
		var postData = $('#ajaxForm').serializeArray();
		
		postData.push({ name: "ADAPTERDATA" , value:JSON.stringify(submitData)});
		postData.push({ name: "cmd" , value:"CLONE"});
		postData.push({ name: "NEWADPTRBZWKGROUPNAME" , value:$("input[name=NEWADPTRBZWKGROUPNAME]").val() });
		
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("복제 되었습니다.");
				goNav(returnUrl);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_delete").click(function(){
		var postData = $('#ajaxForm').serializeArray();
		postData.push({ name: "cmd" , value:"DELETE"});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				if(args.status=="error"){
					alert("동기화중 오류입니다.\n확인하여 주십시요.\n"+args.message);
				}else{
					alert("삭제 되었습니다.");
					goNav(returnUrl);//LIST로 이동
				}			
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});
	$("input[name=ADPTRBZWKNAME]").keyup(function(key){
		$("input[name=PRPTYGROUPNAME]").val($(this).val());
		$("input[name=PRPTYGROUPDESC]").val("어댑터 프라퍼티 : "+$(this).val());
	});

	$("select[name=ADAPTERLIST]").change(function(){
		if (!($(this).val() == null || $(this).val() == undefined || $(this).val() == "")){
			var adapter = submitData[$(this).val()];
			$("#adapter input,#adapter select").not('select[name=ADAPTERLIST]').each(function(){
				var name = $(this).attr('name').toUpperCase();
				$(this).val(adapter[name]);
			});
			$("#grid")[0].addJSONData(adapter);		
		}else{
			$("#adapter input,#adapter select").not('select[name=ADAPTERLIST]').each(function(){
				$(this).val("");
			});
			var ids = $("#grid").getDataIDs();
			for(var i=0;i<ids.length;i++){
				$("#grid").jqGrid('setCell',ids[i],'PRPTY2VAL',null);
			}

		}
	});
	$("#btn_pop_new").click(function(){
		// 어댑터명 입력 확인
		if($("input[name=ADPTRBZWKNAME]").val() == ""){
			alert("어댑터 명을 입력하여 주십시요.");
			return;
		}
		// 어댑터 리스트 중복 체크
		var isDuplication = false;
		$("select[name=ADAPTERLIST] option").each(function(){
			if ($(this).val() == $("input[name=ADPTRBZWKNAME]").val()){
				isDuplication = true;
			}
		});
		if (isDuplication){
			alert("중복된 어댑터 명이 존재합니다.확인하여 주십시요.");
			return;
		}
		//어댑터 목록 추가
		var key = $("input[name=ADPTRBZWKNAME]").val();
		var str = new makeOptions("CODE","NAME").setData(key,key).getOption();
		$("select[name=ADAPTERLIST]").append(str);
		$("select[name=ADAPTERLIST]").val(key);
		submitData[key]=""; 
		localSave();
		alert("어댑터 [ "+ $("input[name=ADPTRBZWKNAME]").val() +" ] 생성되었습니다.");
	});
	$("#btn_pop_modify").click(function(){
		//
		var isDuplication = false;
		$("select[name=ADAPTERLIST] option").each(function(){
			if ($(this).val() == $("input[name=ADPTRBZWKNAME]").val()){
				isDuplication = true;
			}
		});
		if (!isDuplication){
			alert("어댑터명이 존재 하지 않습니다.확인하여 주십시요.");
			return;
		}
		localSave();
		alert("어댑터 [ "+ $("input[name=ADPTRBZWKNAME]").val() +" ] 수정되었습니다.");
	});	
	$("#btn_pop_delete").click(function(){
		//
		var isDuplication = false;
		$("select[name=ADAPTERLIST] option").each(function(){
			if ($(this).val() == $("input[name=ADPTRBZWKNAME]").val()){
				isDuplication = true;
			}
		});
		if (!isDuplication){
			alert("삭제할 어댑터 명이 존재 하지 않습니다.확인하여 주십시요.");
			return;
		}
		//어댑터 목록 삭제
		var key = $("input[name=ADPTRBZWKNAME]").val();
		$("select[name=ADAPTERLIST] option[value='"+key+"']").remove();
		delete submitData[key];
		$("select[name=ADAPTERLIST]").trigger("change");
		alert("어댑터 [ "+ key +" ] 삭제되었습니다.");
		
	});	
	$("#btn_pop_initialize").click(function(){
		//data 초기화
		$("#adapter input,#adapter select").not('select[name=ADAPTERLIST]').each(function(){
			$(this).val("");
		});
		var ids = $("#grid").getDataIDs();
		for(var i=0;i<ids.length;i++){
			$("#grid").jqGrid('setCell',ids[i],'PRPTY2VAL',null);
		}
	});
	$("select[name=ADPTRCD],select[name=ADPTRIODSTCD]").change(function(){
		if ($('select[name=ADPTRCD]').val()=="") return;
		if ($('select[name=ADPTRIODSTCD]').val()=="") return;
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_PROP'
			     , ADPTRCD : $('select[name=ADPTRCD]').val()
			     , ADPTRIODSTCD : $('select[name=ADPTRIODSTCD]').val()
			},
			success:function(json){
			
				prptyDomain = json.dInfo;
				//$("#grid").trigger("reloadGrid");
				$("#grid")[0].addJSONData(json);
				
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	buttonControl(isDetail);
	titleControl(isDetail);
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

					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>				
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>
				</div>
				<div class="title">어댑터</div>						
				
				<form id="ajaxForm">
					<div class="table_row_title">어댑터 그룹정보</div>
					<table id="detail" class="table_row"  cellspacing="0"  >
						<tr>
							<td colspan="4">
								<input type="text" name="NEWADPTRBZWKGROUPNAME" style="width:200px;"> 
								<img id="btn_clone" src="<c:url value="/img/btn_clone.png" />" class="btn_img"/>							
							</td>
						</tr>
					</table>	
					<table id="detail" class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:180px;">어댑터 그룹명</th>
							<td ><input type="text" name="ADPTRBZWKGROUPNAME"/> </td>
							<th style="width:180px;">업무구분코드</th>
							<td >
								<div class="select-style">
									<select name="EAIBZWKDSTCD"></select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>표준/비표준</th>
							<td >
								<div class="select-style">
								<select name="ADPTRMSGPTRNCD"/>
								</div>
							</td>
							<th>어댑터 사용구분</th>
							<td >
								<div class="select-style">
								<select name="ADPTRUSEYN"/>
								</div>
							</td>
						</tr>
						<tr>
							<th>송수신 로그여부</th>
							<td >
								<div class="select-style">
								<select name="SNDRCVHMSLOGYN"/>
								</div>
							</td>
							<th>IN/OUT 구분</th>
							<td >
								<div class="select-style">
								<select name="ADPTRIODSTCD"/>
								</div>
							</td>
						</tr>
						<tr>
							<th>어댑터 유형</th>
							<td >
								<div class="select-style">
								<select name="ADPTRCD"/> 
								</div>
							</td>
							<th>메시지타입</th>
							<td >
								<div class="select-style">
								<select name="ADPTRMSGDSTCD"/> 
								</div>
							</td>
						</tr>
						<tr>
							<th>참조 클래스명</th><td colspan="3"><input type="text" name="REFCLSNAME"/> </td>
						</tr>
						<tr>
							<th>어댑터 그룹설명</th><td colspan="3"><input type="text" name="ADPTRBZWKGROUPDESC"/> </td>
						</tr>
						<tr>
							<th>특정LU 사용여부</th>
							<td >
								<div class="select-style">
								<select name="SPCFCLUUSEYN"/>
								</div>
							</td>
							<th>대외기관 코드</th>
							<td ><input type="text" name="OSIDINSTINO"/> </td>
						</tr>
						<tr>
							<th>24시 업무여부</th>
							<td >
								<div class="select-style">
								<select name="REALTIMEBZWKYN"/>
								</div>
							</td>
							<th>그룹코드</th><td ><input type="text" name="REALTIMEGROUPNAME"/> </td>
						</tr>
						<tr>
							<th>대외텔러번호</th><td colspan="3"><input type="text" name="USEREMPID"/> </td>
						</tr>
						<tr>
							<th>필터 클래스</th>
							<td ><input type="text" name="FILTERCLASS"/></td>
							<th>에러 EAISvcCode</th>
							<td ><input type="text" name="ERROREAISVCNAME"/> </td>
						</tr>
						<tr>
							<th>에러 레이아웃명</th>
							<td ><input type="text" name="ERRORLAYOUTNAME"/></td>
							<th>에러 값</th>
							<td ><input type="text" name="ERRORVALUE"/> </td>
						</tr>
						<tr>
							<th>SESSION사용여부</th>
							<td >
								<div class="select-style">
								<select name="SESSIONYN"/>
								</div>
							</td>
							<th>타겟어댑터사용여부</th>
							<td >
								<div class="select-style">
								<select name="TARGETADAPTERYN"/>
								</div>
							</td>
						</tr>
					</table>
					</form>
					<div class="table_row_title">어댑터 정보</div>
					<!-- 어댑터-->
					<table id="adapter" class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:180px;">어댑터 리스트</th>
							<td colspan="3">
								<div class="select-style" style="display:inline-block; width:calc(100% - 250px);">
								<select name="ADAPTERLIST"></select> 
								</div>
								 <img id="btn_pop_new" src="<c:url value="/img/btn_pop_new.png" />" class="btn_img" />
								 <img id="btn_pop_modify" src="<c:url value="/img/btn_pop_modify.png" />" class="btn_img" />
								 <img id="btn_pop_delete" src="<c:url value="/img/btn_pop_delete.png" />" class="btn_img" />
								 <img id="btn_pop_initialize" src="<c:url value="/img/btn_pop_initialize.png" />" class="btn_img" /> 
							</td>
						</tr>
						<tr>
							<th>어댑터 이름</th><td ><input type="text" name="ADPTRBZWKNAME"/> </td>
							<th style="width:180px;">서버인스턴스명</th>
							<td >
								<div class="select-style">
								<select name="EAISEVRINSTNCNAME"></select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>리스너 클래스명</th><td colspan="3"><input type="text" name="LSTNERCLSNAME"/> </td>
						</tr>
						<tr>
							<th>테스터 클래스명</th><td colspan="3"><input type="text" name="TESTCLSNAME"/> </td>
						</tr>
						<tr>
							<th>어댑터 설명</th><td colspan="3"><input type="text" name="ADPTRDESC"/> </td>
						</tr>
						<tr style="display:none" >
							<th>프라퍼티 그룹 명</th><td colspan="3"><input type="text" name="PRPTYGROUPNAME"/> </td>
						</tr>
						<tr style="display:none" >
							<th>프라퍼티 그룹설명</th><td colspan="3"><input type="text" name="PRPTYGROUPDESC"/> </td>
						</tr>
					</table>
					<div class="table_row_title">프라퍼티 정보</div>
					
					<!-- grid -->
					<table id="grid" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

