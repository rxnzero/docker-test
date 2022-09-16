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
var prptyDomain =[];		//������ ������ ���������� ������
var isDetail = false;
var lastRadioVal = {};		//�����ڽ��� ������ ����(����:��)
function isValid(){
	if($('input[name=ADPTRBZWKGROUPNAME]').val() == ""){
		alert("����� �׷���� �Է��Ͽ� �ֽʽÿ�.");
		return false;
	}
	
	if($('select[name=ADPTRCD]').val() == ""){
		alert("����� ������ �����Ͽ� �ֽʽÿ�.");
		return false;
	}
	
	return true;
}
function localSave(){
	var key =$("input[name=ADPTRBZWKNAME]").val();
	//��ü ����
	var save ={};
	$("#adapter input,#adapter select").not('select[name=ADAPTERLIST]').each(function(){
		var name = $(this).attr('name').toUpperCase();
		save[name] = $(this).val();
	});
	var fullData = $("#grid").getRowData();
	//getRowData �ϸ� select html �״�� ���� ������ �߰���
	for(var i=0;i<fullData.length;i++){
		var keyName = fullData[i].PRPTYGROUPNAME+"_"+fullData[i].PRPTYNAME;
		keyName = keyName.replace(/[.\{\}]/g,'');								//Name�� . �Ǵ� {} ���ԾȵǹǷ� ġȯ
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
			new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=EAIBZWKDSTCD]")).setFormat(codeName3OptionFormat).setData(json.bizRows).rendering();				// ���������ڵ�
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRCD]")).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.adapterTypeRows).rendering();	// ����� ����
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRMSGDSTCD]")).setFormat(codeName3OptionFormat).setData(json.msgTypeRows).rendering();			// �޽���Ÿ��
			new makeOptions("CODE","NAME").setObj($("select[name=EAISEVRINSTNCNAME]")).setData(json.instanceRows).rendering();										// �����ν��Ͻ���
			
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRIODSTCD]")).setData(json.adptrIoDstcdRows).setFormat(codeName3OptionFormat).rendering();		// IN/OUT ����
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRMSGPTRNCD]")).setData(json.adptrMsgPtrnCdRows).setFormat(codeName3OptionFormat).rendering();	// ǥ��/��ǥ�� ����
			new makeOptions("CODE","NAME").setObj($("select[name=ADPTRUSEYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();				// ����� ��뱸��
			new makeOptions("CODE","NAME").setObj($("select[name=SNDRCVHMSLOGYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			// �ۼ��� �α׿���
			new makeOptions("CODE","NAME").setObj($("select[name=SPCFCLUUSEYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();				// Ư��LU ��뿩��
			new makeOptions("CODE","NAME").setObj($("select[name=REALTIMEBZWKYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			// 24�� ��������
			new makeOptions("CODE","NAME").setObj($("select[name=SESSIONYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			    // session��뿩��
			new makeOptions("CODE","NAME").setObj($("select[name=TARGETADAPTERYN]")).setData(json.useYnRows).setFormat(codeName3OptionFormat).rendering();			// targetAdapter ��뿩��
				
			if(key == "")
			{
				$("input[name=REFCLSNAME]").val(json.refClsName);	// ����� �ű� �Է��� �� ���� Ŭ������ default setting.
				setSearchable(selectName);	// �޺��� searchable ����
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
						//������ ����
		
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
			
			setSearchable(selectName);	// �޺��� searchable ����
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
	name = name.replace(/[.\{\}]/g,''); 									//name ���� . {} ������ ����
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
		console.log("�����θ� : "+domainName +" �ڵ� ��ȸ �ȵ�"); 
				
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
		console.log("�����θ� : "+domainName +" �ڵ� ��ȸ �ȵ�"); 
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
		console.log("�����θ� : "+domainName +" �ڵ� ��ȸ �ȵ�"); 
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
//������ Ÿ���� null�̸� ����üũ �߿� ���� �߻��ؼ� �������� ġȯ
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
		colNames:['������Ƽ�׷��',
                  '������Ƽ��',
                  '������Ƽ��',
                  '�����θ�',
                  '�Էµ�����'
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
			//���� ��ư�� ���� ���
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
	       
	       //������ ����
	        if(domainName != null && domainName != "" && prptyDomain[domainName] != null)
	        	$("input[name=PRPTY2VAL]").inputmask(prptyDomain[domainName]["info"].DOMAINVAL,{'autoUnmask':true});
	        	
	        var val = $('input[name=PRPTY2VAL]').val();
	        $('input[name=PRPTY2VAL]').val(val.replace(/&nbsp;/g,' '));	//Html Text --> Inputbox Text : &nbsp --> ' '	   
	        lastsel2=rowid;
	    },        
        onSortCol : function(){
        	return 'stop';	//���� ����
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
	
		// ���� �� ���� confirm ����.
		if(isDetail)
		{
			var r = confirm("����� ������ ��� ����˴ϴ�.\n���� �Ͻðڽ��ϱ�?");
			if (r == false) return;
		}
		
		//����θ� form���� ����
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
					alert("����ȭ�� �����Դϴ�.\nȮ���Ͽ� �ֽʽÿ�.\n"+args.message);
				}else{
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});
	$("#btn_clone").click(function(){
		var newAdapterGroupName = $("input[name=NEWADPTRBZWKGROUPNAME]");	// ������ ����� �׷��
		if (!isValid())return;
		
		// ������ ����� �׷���� �ԷµǾ����� üũ.
		if(newAdapterGroupName.val() == "")
		{
			alert("������ ����� �׷���� �Է��Ͽ� �ֽʽÿ�.");
			newAdapterGroupName.focus();
			return;
		}
	
		//����θ� form���� ����
		var postData = $('#ajaxForm').serializeArray();
		
		postData.push({ name: "ADAPTERDATA" , value:JSON.stringify(submitData)});
		postData.push({ name: "cmd" , value:"CLONE"});
		postData.push({ name: "NEWADPTRBZWKGROUPNAME" , value:$("input[name=NEWADPTRBZWKGROUPNAME]").val() });
		
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("���� �Ǿ����ϴ�.");
				goNav(returnUrl);//LIST�� �̵�
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
					alert("����ȭ�� �����Դϴ�.\nȮ���Ͽ� �ֽʽÿ�.\n"+args.message);
				}else{
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
				}			
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST�� �̵�
	});
	$("input[name=ADPTRBZWKNAME]").keyup(function(key){
		$("input[name=PRPTYGROUPNAME]").val($(this).val());
		$("input[name=PRPTYGROUPDESC]").val("����� ������Ƽ : "+$(this).val());
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
		// ����͸� �Է� Ȯ��
		if($("input[name=ADPTRBZWKNAME]").val() == ""){
			alert("����� ���� �Է��Ͽ� �ֽʽÿ�.");
			return;
		}
		// ����� ����Ʈ �ߺ� üũ
		var isDuplication = false;
		$("select[name=ADAPTERLIST] option").each(function(){
			if ($(this).val() == $("input[name=ADPTRBZWKNAME]").val()){
				isDuplication = true;
			}
		});
		if (isDuplication){
			alert("�ߺ��� ����� ���� �����մϴ�.Ȯ���Ͽ� �ֽʽÿ�.");
			return;
		}
		//����� ��� �߰�
		var key = $("input[name=ADPTRBZWKNAME]").val();
		var str = new makeOptions("CODE","NAME").setData(key,key).getOption();
		$("select[name=ADAPTERLIST]").append(str);
		$("select[name=ADAPTERLIST]").val(key);
		submitData[key]=""; 
		localSave();
		alert("����� [ "+ $("input[name=ADPTRBZWKNAME]").val() +" ] �����Ǿ����ϴ�.");
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
			alert("����͸��� ���� ���� �ʽ��ϴ�.Ȯ���Ͽ� �ֽʽÿ�.");
			return;
		}
		localSave();
		alert("����� [ "+ $("input[name=ADPTRBZWKNAME]").val() +" ] �����Ǿ����ϴ�.");
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
			alert("������ ����� ���� ���� ���� �ʽ��ϴ�.Ȯ���Ͽ� �ֽʽÿ�.");
			return;
		}
		//����� ��� ����
		var key = $("input[name=ADPTRBZWKNAME]").val();
		$("select[name=ADAPTERLIST] option[value='"+key+"']").remove();
		delete submitData[key];
		$("select[name=ADAPTERLIST]").trigger("change");
		alert("����� [ "+ key +" ] �����Ǿ����ϴ�.");
		
	});	
	$("#btn_pop_initialize").click(function(){
		//data �ʱ�ȭ
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
				<div class="title">�����</div>						
				
				<form id="ajaxForm">
					<div class="table_row_title">����� �׷�����</div>
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
							<th style="width:180px;">����� �׷��</th>
							<td ><input type="text" name="ADPTRBZWKGROUPNAME"/> </td>
							<th style="width:180px;">���������ڵ�</th>
							<td >
								<div class="select-style">
									<select name="EAIBZWKDSTCD"></select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>ǥ��/��ǥ��</th>
							<td >
								<div class="select-style">
								<select name="ADPTRMSGPTRNCD"/>
								</div>
							</td>
							<th>����� ��뱸��</th>
							<td >
								<div class="select-style">
								<select name="ADPTRUSEYN"/>
								</div>
							</td>
						</tr>
						<tr>
							<th>�ۼ��� �α׿���</th>
							<td >
								<div class="select-style">
								<select name="SNDRCVHMSLOGYN"/>
								</div>
							</td>
							<th>IN/OUT ����</th>
							<td >
								<div class="select-style">
								<select name="ADPTRIODSTCD"/>
								</div>
							</td>
						</tr>
						<tr>
							<th>����� ����</th>
							<td >
								<div class="select-style">
								<select name="ADPTRCD"/> 
								</div>
							</td>
							<th>�޽���Ÿ��</th>
							<td >
								<div class="select-style">
								<select name="ADPTRMSGDSTCD"/> 
								</div>
							</td>
						</tr>
						<tr>
							<th>���� Ŭ������</th><td colspan="3"><input type="text" name="REFCLSNAME"/> </td>
						</tr>
						<tr>
							<th>����� �׷켳��</th><td colspan="3"><input type="text" name="ADPTRBZWKGROUPDESC"/> </td>
						</tr>
						<tr>
							<th>Ư��LU ��뿩��</th>
							<td >
								<div class="select-style">
								<select name="SPCFCLUUSEYN"/>
								</div>
							</td>
							<th>��ܱ�� �ڵ�</th>
							<td ><input type="text" name="OSIDINSTINO"/> </td>
						</tr>
						<tr>
							<th>24�� ��������</th>
							<td >
								<div class="select-style">
								<select name="REALTIMEBZWKYN"/>
								</div>
							</td>
							<th>�׷��ڵ�</th><td ><input type="text" name="REALTIMEGROUPNAME"/> </td>
						</tr>
						<tr>
							<th>����ڷ���ȣ</th><td colspan="3"><input type="text" name="USEREMPID"/> </td>
						</tr>
						<tr>
							<th>���� Ŭ����</th>
							<td ><input type="text" name="FILTERCLASS"/></td>
							<th>���� EAISvcCode</th>
							<td ><input type="text" name="ERROREAISVCNAME"/> </td>
						</tr>
						<tr>
							<th>���� ���̾ƿ���</th>
							<td ><input type="text" name="ERRORLAYOUTNAME"/></td>
							<th>���� ��</th>
							<td ><input type="text" name="ERRORVALUE"/> </td>
						</tr>
						<tr>
							<th>SESSION��뿩��</th>
							<td >
								<div class="select-style">
								<select name="SESSIONYN"/>
								</div>
							</td>
							<th>Ÿ�پ���ͻ�뿩��</th>
							<td >
								<div class="select-style">
								<select name="TARGETADAPTERYN"/>
								</div>
							</td>
						</tr>
					</table>
					</form>
					<div class="table_row_title">����� ����</div>
					<!-- �����-->
					<table id="adapter" class="table_row"  cellspacing="0"  >
						<tr>
							<th style="width:180px;">����� ����Ʈ</th>
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
							<th>����� �̸�</th><td ><input type="text" name="ADPTRBZWKNAME"/> </td>
							<th style="width:180px;">�����ν��Ͻ���</th>
							<td >
								<div class="select-style">
								<select name="EAISEVRINSTNCNAME"></select> 
								</div>
							</td>
						</tr>
						<tr>
							<th>������ Ŭ������</th><td colspan="3"><input type="text" name="LSTNERCLSNAME"/> </td>
						</tr>
						<tr>
							<th>�׽��� Ŭ������</th><td colspan="3"><input type="text" name="TESTCLSNAME"/> </td>
						</tr>
						<tr>
							<th>����� ����</th><td colspan="3"><input type="text" name="ADPTRDESC"/> </td>
						</tr>
						<tr style="display:none" >
							<th>������Ƽ �׷� ��</th><td colspan="3"><input type="text" name="PRPTYGROUPNAME"/> </td>
						</tr>
						<tr style="display:none" >
							<th>������Ƽ �׷켳��</th><td colspan="3"><input type="text" name="PRPTYGROUPDESC"/> </td>
						</tr>
					</table>
					<div class="table_row_title">������Ƽ ����</div>
					
					<!-- grid -->
					<table id="grid" ></table>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

