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
var isDetail=false;
function isValid(){
	if($('input[name=cronExp]').val() == ""){
		alert("<%= localeMessage.getString("scheduler.checkRequired1") %>");
		return false;
	}else if($('input[name=jobClassName]').val() == ""){
		alert("<%= localeMessage.getString("scheduler.checkRequired2") %>");
		return false;
	}else if($('input[name=adptrName]').val() == ""){
		alert("<%= localeMessage.getString("combo.checkRequiredUsed") %>");
		return false;
	}else if($("select[name=useYn]").val() != "Y"){
		if($("select[name=chkStatus]").val() == "Y"){
			$("select[name=chkStatus]").val("N");
		}
	}
	
	var r = $("input[name^=cron]").each(function(){
		var val = $(this).val();
		
		if(val =="")
			return false;
	});
	if( r == false) return false;
	return true;
}
function isValidGrid(){
	if($('input[name=addDataKey]').val() == ""){
		alert("<%= localeMessage.getString("scheduler.checkRequired3") %>");
		return false;
	}else if($('input[name=addDataValue]').val() == ""){
		alert("<%= localeMessage.getString("scheduler.checkRequired4") %>");
		return false;
	}
	//중복체크
	var data = $("#grid").getRowData();
	for ( var i = 0; i < data.length; i++) {
		if (data[i]['DATAKEY'] == $('input[name=addDataKey]').val() ){
			alert("<%= localeMessage.getString("scheduler.checkRequired5") %>");
		    return false;
		}
	}
	
	return true;
}

function makeCronExp(){
	var sec = $("input[name=cronSec]").val();
	var min = $("input[name=cronMin]").val();
	var hour = $("input[name=cronHour]").val();
	var day = $("input[name=cronDay]").val();
	
	var cronExp = sec + " " + min+ " " +hour+ " " +day+ " * ?";
	$("input[name=cronExp]").val(cronExp);
	

}


function unformatterFunction(cellvalue, options, rowObject){
	return "";
}

function formatterFunction(cellvalue, options, rowObject){
	var rowId = options["rowId"];
	var dataKey    = options["colModel"]["DATAKEY"];
	var dataValue  = options["colModel"]["DATAVALUE"];
	return "<img id='btn_pop_delete' name='img_"+rowId+"' src='<c:url value="/images/bt/pop_delete.gif"/>' />";
}

function gridRendering(){
	$('#grid').jqGrid({
		datatype:"local",
		loadonce: true,
		rowNum: 10000,
		colNames:['<%= localeMessage.getString("scheduler.job") %>',
                  'DATA KEY',
                  'DATA VALUE',
                  'DELETE YN'
                  ],
		colModel:[
				{ name : 'JOBNAME'   , align:'left' ,width:'40' },
				{ name : 'DATAKEY'   , align:'left' ,width:'270' },
				{ name : 'DATAVALUE' , align:'left'  },
				{ name : 'DELETEYN'  , align:'left' ,width:'50' ,unformat: unformatterFunction, formatter: formatterFunction}
				],
        jsonReader: {
             repeatitems:false
        },	   
        loadComplete : function () {

        },
        onSortCol : function(){
        	return 'stop';	//정렬 방지
        },        
	    height: '300',
		autowidth: true,
		viewrecords: true
	});
	
	
	resizeJqGridWidth('grid','title','1000');	
}
function init(url,key,callback){
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'LIST_INIT_COMBO'},
		success:function(json){
			new makeOptions("CODE","NAME").setObj($("select[name=useYn]")).setData(json.useYnTypeRows).setFormat(codeName3OptionFormat).rendering();
			new makeOptions("CODE","NAME").setObj($("select[name=instanceName]")).setData(json.instanceList).rendering();
			
			if(typeof callback === 'function') {
				callback(url,key);
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
function detail(url,key){
	if (!isDetail)return;
	$.ajax({  
		type : "POST",
		url:url,
		dataType:"json",
		data:{cmd: 'DETAIL'
		    , jobName : key
		    },
		success:function(json){
			var data = json;
			var detail = json.detail;
			//adapterType
			$("input[name=jobName]").attr('readonly',true);
			$("input[name=jobName]").val(detail['JOBNAME']);
			$("input[name=jobDesc]").val(detail['JOBDESC']);
			$("input[name=cronExp]").val(detail['CRONEXP']);
			$("input[name=jobClassName]").val(detail['JOBCLASSNAME']);
			$("select[name=useYn]").val(detail['USEYN']);
			$("select[name=instanceName]").val(detail['INSTANCENAME']);
			$("select[name=chkStatus]").val(detail['CHKSTATUS']);
			if($("input[name=cronExp]").val() != ""){
				var val = $("input[name=cronExp]").val();
				var cron = val.split(" ");
				
				$("input[name=cronSec]").val(cron[0]);
				$("input[name=cronMin]").val(cron[1]);
				$("input[name=cronHour]").val(cron[2]);
				$("input[name=cronDay]").val(cron[3]);
				$("input[name=cronMon]").val(cron[4]);
				
			}
			
			
			//jobItem 
			$("#grid")[0].addJSONData(data);
        	$("img[name*=img]").click(function(){
				var name = $(this).attr("name");
				var rowId =name.split("_")[1];
				$('#grid').jqGrid('delRowData',rowId);
			});				
			
		},
		error:function(e){
			alert(e.responseText);
		}
	});

}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var url ='<c:url value="/common/scheduler/schedulerMan.json" />';
	var key ="${param.jobName}";
	
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	
	gridRendering();

	init(url,key,detail);
	

	$("#btn_modify").click(function(){
		if (!isValid())return;
	
	
		var data     = $("#grid").getRowData();
		var gridData = new Array();
		for (var i = 0; i <data.length; i++) {
			gridData.push(data[i]);
		}
	
	
		//공통부만 form으로 구성
		var postData = $('#ajaxForm').serializeArray();
		
		postData.push({ name: "gridData" , value:JSON.stringify(gridData)});
		
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
				alert("<%= localeMessage.getString("common.saveMsg") %>");
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
				alert("<%= localeMessage.getString("common.deleteMsg") %>");
				goNav(returnUrl);//LIST로 이동

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST로 이동
	});
	$("#btn_pop_input").click(function(){
		if (!isValidGrid()){
			return;
		}
	
		var data = new Object();
		data["JOBNAME"]=$("input[name=jobName]").val(); 
		data["DATAKEY"]=$("input[name=addDataKey]").val(); 
		data["DATAVALUE"]=$("input[name=addDataValue]").val(); 
	
		var rows = $("#grid")[0].rows;
		var index = Number($(rows[rows.length-1]).attr("id"));
		if (isNaN(index)) index=0;
	    var rowid = index + 1;
		$("#grid").jqGrid('addRow', {
           rowID : rowid,          
           initdata : data,
           position :"last",    //first, last
           useDefValues : false,
           useFormatter : false,
           addRowParams : {extraparam:{}}
		});
		$("#"+$('#grid').jqGrid('getGridParam','selrow')).focus();
		$("img[name=img_"+rowid+"]").click(function(){
			var name = $(this).attr("name");
			var rowId =name.split("_")[1];
			$('#grid').jqGrid('delRowData',rowId);
		});	
		
	});
	
	$("input[name^=cron]").keyup(function(){
		var name = $(this).attr('name');
		if(name == "cronExp")	return;
		
		makeCronExp();
		
	
	});
	$("select[name=useYn]").change(function(){
		var val = $(this).val();
		if(val == "N"){
			$("select[name=chkStatus]").val("N");
		}
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
			<div class="content_middle" id="title">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>	
				</div>
				<div class="title"><%= localeMessage.getString("schedulerDetail.title") %></div>	
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<!-- 공통-->
						<tr>
							<th style="width:180px;"><%= localeMessage.getString("scheduler.job") %></th><td ><input type="text" name="jobName" /> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("scheduler.desc") %></th><td ><input type="text" name="jobDesc" /> </td>
						</tr>		
						<tr>
							<th rowspan="2"><%= localeMessage.getString("scheduler.cron") %></th><td style="border-bottom:1px solid #ebebec;"><input type="text" name="cronExp" /> </td>
						</tr>
						<tr>
							<td>	
								<input type="text" name="cronMon" style="width:25px" /> <%= localeMessage.getString("common.month") %>, 
								<input type="text" name="cronDay" style="width:25px" /> <%= localeMessage.getString("common.day") %>, 
								<input type="text" name="cronHour" style="width:25px"/> <%= localeMessage.getString("common.time") %>, 
								<input type="text" name="cronMin" style="width:25px" /> <%= localeMessage.getString("common.min") %>, 
								<input type="text" name="cronSec" style="width:25px" /> <%= localeMessage.getString("common.sec") %>
								<span style="display:inline-block; margin-left:20px; color:red;"><%= localeMessage.getString("scheduler.cronDesc") %></span>
							</td>
						</tr>		
						<tr>
							<th><%= localeMessage.getString("scheduler.class") %></th><td ><input type="text" name="jobClassName" /> </td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("combo.useYn") %></th>
							<td ><div class="select-style"><select name="useYn" /></div></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("scheduler.instance") %></th>
							<td><div class="select-style"><select name="instanceName"></div></td>
						</tr>
						<tr>
							<th><%= localeMessage.getString("scheduler.status") %></th>
							<td>
								<div class="select-style">
									<select name="chkStatus">
									<option value="N"><%= localeMessage.getString("combo.usen") %></option>
									<option value="Y"><%= localeMessage.getString("combo.usey") %></option>
									<option value="E"><%= localeMessage.getString("scheduler.error") %></option>				
									</select>
								</div>	
							</td>
						</tr>		
					</table>
				</form>
					
				<table class="table_row" cellspacing="0">
					<tr>
						<th style="width:180px;"><%= localeMessage.getString("scheduler.key") %></th>
						<td>
							<input type="text"  name="addDataKey" style="width:calc(100% - 70px);" /> 
							<img id="btn_pop_input" src="<c:url value="/img/btn_pop_input.png"/>" class="btn_img" />
						</td>
					</tr>
					<tr>
						<th><%= localeMessage.getString("scheduler.value") %></th>
						<td ><input type="text"  name="addDataValue" /></td>
					</tr>
				</table>
				<!-- grid -->
				<table id="grid" ></table>
					
	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

