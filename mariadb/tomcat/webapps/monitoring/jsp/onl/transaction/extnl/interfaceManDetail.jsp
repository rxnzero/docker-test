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
	var isDetail = false;
	
	var selectName = "eaiBzwkDstcd";	// selectBox Name
	
	function getAdapters(obj,adptrIoDstcd,type){
		var postData = [];
		if ($("input[name=eaiTranName]").val()=="")return;
		if ($("select[name=eaiBzwkDstcd]").val()=="")return;
		if (adptrIoDstcd =="IN"){
		 	queryType ="1";
		}else{
		 	queryType ="3";
		}
		
		
		var eaiTranName = $("input[name=eaiTranName]").val();
		postData.push({name:"cmd",value:"LIST_ADAPTER_COMBO"});
		postData.push({name:"adptrIoDstcd",value:adptrIoDstcd});
		postData.push({name:"queryType",value:queryType});
		postData.push({name:"chnlCd",value:eaiTranName.substring(0,3)});
		postData.push({name:"chnlCd2",value:eaiTranName.substring(eaiTranName.length-3,eaiTranName.length)});
		postData.push({name:"eaiBzwkDstcd",value:$("select[name=eaiBzwkDstcd]").val()});
		if (type !=undefined){
			postData.push({name:"asyncDstcd",value:type});
		}
		obj.find('option').remove();
	
		$.ajax({
			type : "POST",
			url:'<c:url value="/onl/transaction/extnl/interfaceMan.json" />',
			dataType:"json",
			async:false,
			data:postData,
			success:function(json){
				new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj(obj).setFormat(codeName3OptionFormat).setNoValueInclude(true).setData(json.adapter).setAttr("std","ADPTRMSGPTRNCD").rendering();
			},
			error:function(e){
				alert(e.responseText);
			}
		});	
	}	
	function adapterChange(){
		var value = $("select[name=svcMotivUseDstcd]").val();
		var reqRes = $("select[name=splizDmndDstcd]").val();
		$("select[name=toAdapter]").attr('disabled',false);
		if (value=="SYNC"){
			$("tr[name=tr_extAdapter]").hide();
			getAdapters($("select[name=fromAdapter]"),"IN","Sy");
			getAdapters($("select[name=toAdapter]"),"OU","Sy");
		}else if (value=="ASYN"){
			$("tr[name=tr_extAdapter]").hide();
			getAdapters($("select[name=fromAdapter]"),"IN","As");
			getAdapters($("select[name=toAdapter]"),"OU","As");
		}else if (value=="ASYN_SYNC"){
			$("tr[name=tr_extAdapter]").show();
			getAdapters($("select[name=fromAdapter]"),"IN","As");
			getAdapters($("select[name=toAdapter]"),"OU","Sy");
			getAdapters($("select[name=extAdapter]"),"OU","As");
		}	
		
		else if (value=="SYNC_ASYN"){
			$("tr[name=tr_extAdapter]").hide();
			if(reqRes != "R"){
				getAdapters($("select[name=fromAdapter]"),"IN","Sy");
				getAdapters($("select[name=toAdapter]"),"OU","As");
			}else{
				getAdapters($("select[name=fromAdapter]"),"IN","As");
				$("select[name=toAdapter]").attr('disabled',true);
			}
			
		}
				
	}
	function init(url,key,callback){
			$.ajax({
				type : "POST",
				url:url,
				dataType:"json",
				data:{cmd: 'LIST_DETAIL_COMBO'},
				success:function(json){
					new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=eaiBzwkDstcd]")).setData(json.bizList).setFormat(codeName3OptionFormat).rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=io]")).setNoValueInclude(true).setData(json.ioList).setFormat(codeName3OptionFormat).rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=splizDmndDstcd]")).setNoValueInclude(true).setData(json.reqResList).setFormat(codeName3OptionFormat).rendering();
					new makeOptions("CODE","NAME").setObj($("select[name=svcMotivUseDstcd]")).setNoValueInclude(true).setData(json.syncAsyncList).rendering();
					
					if(key == "") setSearchable(selectName);	// �޺��� searchable ����
					
					if (typeof callback === 'function') {
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
			data:{cmd: 'DETAIL', eaiSvcName : key},
			success:function(json){
				var data = json;
				$("input[name=eaiSvcName]").attr('readonly',true);
				$("#ajaxForm input,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				$("select[name=eaiBzwkDstcd]"            ).val(data["EAIBZWKDSTCD"]);//���������ڵ�
				$("select[name=io]"                      ).val(data["IO"]);//��Ÿ�߱���
				$("select[name=splizDmndDstcd]"          ).val(data["SPLIZDMNDDSTCD"]);//������û����
				$("select[name=stndTelgmWtinExtnlDstcd]" ).val(data["STNDTELGMWTINEXTNLDSTCD"]);//���ܺα���
				$("select[name=svcMotivUseDstcd]"        ).val(data["SVCMOTIVUSEDSTCD"]);//�ۼ��Ź������
				adapterChange();
				$("select[name=fromAdapter]"             ).val(data["FROMADAPTER"]);//fromAdapter
				$("select[name=toAdapter]"               ).val(data["TOADAPTER"]);//toAdapter
				$("select[name=extAdapter]"              ).val(data["EXTADAPTER"]);//extAdapter
				
				$("select[name=occurDstcd]"              ).val(data["OCCURDSTCD"]);//extAdapter
				$("select[name=transKind]"              ).val(data["TRANSKIND"]);//extAdapter
				
				setSearchable(selectName);	// �޺��� searchable ����
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	function makeEaiSvcName(){
		var eaiTranName = $("input[name=eaiTranName]").val();
		if (eaiTranName == "") return;
		
		var io = $("select[name=io]").val();
		if (io == "") return;
		var reqRes = $("select[name=splizDmndDstcd]").val();
		if (reqRes == "") return;
		var inout = "";
		if("EAI"==sessionStorage["serviceType"]){
			if (io=="I"){ //��� 
				inout ="1"; 
			}else{
				inout ="2";
			}
		}else{
			if(reqRes=="S" && io=="O"){ //��߿�û
				inout = "2";
			}else if (reqRes=="R" && io=="O"){ //�������
				inout = "1";
			}else if (reqRes=="S" && io=="I"){ //Ÿ������
				inout = "1";
			}else if (reqRes=="R" && io=="I"){ //Ÿ������
				inout = "2";
			}
		}
		$("input[name=stndTelgmWtinExtnlDstcd]").val(inout);
		$("input[name=eaiSvcName]").val(eaiTranName.trim()+reqRes+inout);
		
		
	}
	function isValid(){
		if ($('select[name=eaiBzwkDstcd]').val()==""){
			alert("���������� �����Ͽ� �ֽʽÿ�.");
			return false;
		}
		if ($('input[name=eaiTranName]').val()==""){
			alert("�������̽�ID�� �Է��Ͽ� �ֽʽÿ�.");
			return false;
		}
		if ($('input[name=eaiSvcDesc]').val()==""){
			alert("�������̽�ID������ �Է��Ͽ� �ֽʽÿ�.");
			return false;
		}
		if ($('select[name=io]').val()==""){
			alert("��Ÿ�߱����� �����Ͽ� �ֽʽÿ�.");
			return false;
		}
		if ($('select[name=splizDmndDstcd]').val()==""){
			alert("������û������ �����Ͽ� �ֽʽÿ�.");
			return false;
		}
		if ($('select[name=svcMotivUseDstcd]').val()==""){
			alert("�ۼ��Ź���� �����Ͽ� �ֽʽÿ�.");
			return false;
		}
		
		if (($('select[name=bzwkFldName1]').val()!="" || $('select[name=bzwkFldName12').val()!="")&&$('select[name=layoutMappingName]').val()==""){
			alert("�������������ʵ带 �����ϱ� ���ؼ��� ���̾ƿ������� �Է��Ͽ� �ֽʽÿ�.");
			return false;
		}
		$("input[name^=msgFldStartSituVal],input[name^=msgFldLen]").each(function(){
			var value = $(this).val();
			if (isNaN(parseInt(value))){
				alert("�����������ʵ� �׸��� ���� Ÿ���� �ƴմϴ�.("+$(this).attr("name")+")");
				return false;
			}
		});		
		if ($('select[name=fromAdapter]').val()=="" ){
			alert("�ŷ��帧(INBOUND)����͸� �����Ͽ� �ֽʽÿ�.");
			return false;
		}
		if ($('select[name=toAdapter]').val()=="" ){
			if($('select[name=svcMotivUseDstcd]').val() !="SYNC_ASYN" || $("select[name=splizDmndDstcd] :selected").val() != "R" || sessionStorage["serviceType"] != "EAI"){
				
				alert("�ŷ��帧(OUTBOUND)����͸� �����Ͽ� �ֽʽÿ�.");
				return false;
			
			}
			
		}

		if ($('select[name=extAdapter]').val()=="" && $('select[name=svcMotivUseDstcd]').val()=="ASYN_SYNC" ){
			alert("�ŷ��帧(ASYN-SYNC)����͸� �����Ͽ� �ֽʽÿ�.");
			return false;
		}
		if ($("select[name=fromAdapter] option:selected").attr("std") == "K"){
			//ǥ���ϰ��
			if($("input[name=serviceId]").val() !=""){
				alert("����ID�� ���� �ϼž� �˴ϴ�.");
				return false;
			}
		}else{
			if($("input[name=serviceId]").val().trim() ==""){				
				if($("select[name=splizDmndDstcd]").val() == "R" ){	
					var ret = confirm("����ID�� �Էµ��� �ʾҽ��ϴ�. \n�������� ó���ϸ� ��û�� ����ID�� �����մϴ�. \n����Ͻðڽ��ϱ�?");
					if(ret){
						$("input[name=serviceId]").val(" ");	
					}else{
						alert("����ID�� �Է� �ϼž� �˴ϴ�.");
						return false;
					}
				}else{
					alert("����ID�� �Է� �ϼž� �˴ϴ�.");
					return false;
				}
				
			}	

		}
		
		return true;
	}
$(document).ready(function() {	
	var returnUrl = getReturnUrlForReturn();
	var url ='<c:url value="/onl/transaction/extnl/interfaceMan.json" />';
	var key ="${param.eaiSvcName}";
	if (key != "" && key !="null"){
		isDetail = true;
	}	
	init(url,key,detail);
	
	
	$("#btn_modify").click(function(){
		if (!isValid())return;
		
		
		//��������Ű control
		if ($("select[name=fromAdapter] option:selected").attr("std") == "K"){
			//ǥ���ϰ�� ��������Ű �����Ǿ�� ��
			$("input[name=bzwkSvcKeyName]").val("");
		}else{
			//ǥ���� �ƴҰ�� ��������Ű ���õǾ�� ��
			$("input[name=bzwkSvcKeyName]").val($("input[name=eaiTranName]").val());
		}
	
		var postData = $('#ajaxForm').serializeArray();
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
				alert("���� �Ǿ����ϴ�.");
				goNav(returnUrl);//LIST�� �̵�
			},
			error:function(xhr, status, errorMsg){
				alert(JSON.parse(xhr.responseText).errorMsg);
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
				alert("���� �Ǿ����ϴ�.");
				goNav(returnUrl);//LIST�� �̵�

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_previous").click(function(){
		goNav(returnUrl);//LIST�� �̵�
	});
	
	$("input[name=eaiTranName]").keyup(function(key){
		//$("input[name=bzwkSvcKeyName]").val($("input[name=eaiTranName]").val())
		makeEaiSvcName();
	});
	$("select[name=io]").change(function(){
		makeEaiSvcName();
	});
	$("select[name=splizDmndDstcd]").change(function(){
		makeEaiSvcName();
	});
	$("select[name=svcMotivUseDstcd]").change(function(){
		adapterChange();
	});
	$("select[name=eaiBzwkDstcd]").change(function(){
		adapterChange();
	});	
	$("input[name=interfaceId]").blur(function(){
		adapterChange();
	});	
	$("input[name=layoutMappingName]").dblclick(function(){
		var layoutName = $(this).val();
		if($.trim(layoutName) =="") return;

		 var args = new Object();

		var url = '<c:url value="/onl/admin/rule/layoutMan.view" />';
		url += "?cmd=DETAILPOPUP";
        url += '&loutName='+layoutName;
        url += '&pop=true';
	    
	    showModal(url,args,1200,800); 
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" level="W" status="DETAIL"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" level="W" status="DETAIL,NEW" />				
					<img src="<c:url value="/img/btn_previous.png"/>" alt="" id="btn_previous" level="R" status="DETAIL,NEW"/>					
				</div>
				<div class="title">�������̽�ID</div>				
				
				<table id="grid" ></table>
				<div id="pager"></div>
				
				<!-- detail -->
				<form id="ajaxForm">				
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">IF�����ڵ�</th>
							<td style="width:80%;"><input type="text" name="eaiSvcName" readonly="readonly"/></td>
						</tr>
					</table>	
					
					<div class="table_row_title">[�⺻ ����]</div>
					
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">��������</th>
							<td style="width:80%;">
								<div style="position: relative; width: 100%;">
									<div class="select-style">
										<select type="text" name="eaiBzwkDstcd">
										</select>
									</div><!-- end.select-style -->										
								</div>	
							</td>
						</tr>
						<tr><th>�������̽�ID</th><td><input type="text" name="eaiTranName"/></td></tr>
						<tr><th>�������̽�ID����</th><td><input type="text" name="eaiSvcDesc"/></td></tr>
						<tr>
							<th>��Ÿ�߱���</th>
							<td>
								<div class="select-style">
									<select type="text" name="io">
									</select>
								</div><!-- end.select-style -->			
							</td>
						</tr>
						<tr>
							<th>������û����</th>
							<td>
								<div class="select-style">
									<select type="text" name="splizDmndDstcd" style="width:100%">
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr style="display:none"><th>���ܺα���</th><td><input type="text" name="stndTelgmWtinExtnlDstcd"/></td></tr>
					</table>	
					
					<div class="table_row_title">[�߰� ����]</div>
					
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">�ۼ��Ź��</th>
							<td style="width:80%;">
								<div class="select-style">
									<select name="svcMotivUseDstcd">
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr style="display:none">
							<th>��������Ű</th><td><input type="text" name="bzwkSvcKeyName" readonly="readonly"/></td>
						</tr>
						<tr><th>����ID</th><td><input type="text" name="serviceId"/></td></tr>
						<!--tr><th>���伭��ID</th><td><input type="text" name="returnSerivceId"/></td></tr-->
						<tr><th>���̾ƿ�����</th><td><input type="text" name="layoutMappingName"/></td></tr>
						<tr><th>�������������ʵ�1</th><td><input type="text" name="bzwkFldName1"></td></tr>
						<tr><th>�������������ʵ�2</th><td><input type="text" name="bzwkFldName2"></td></tr>
						<tr><th>�����������ʵ�1</th><td><input type="text" name="msgFldStartSituVal1" size="3" value="0" style="width:100px; border:1px solid #ebebec;">,<input type="text" name="msgFldLen1" size="3" value="0" style="width:100px; border:1px solid #ebebec;"></td></tr>
						<tr><th>�����������ʵ�2</th><td><input type="text" name="msgFldStartSituVal2" size="3" value="0" style="width:100px; border:1px solid #ebebec;">,<input type="text" name="msgFldLen2" size="3" value="0" style="width:100px; border:1px solid #ebebec;"></td></tr>
						<tr><th>REST OPTION</th><td><input type="text" name="restOption"/></td></tr>
					</table>	
					
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">�ŷ��帧����(INBOUND)</th>
							<td style="width:80%;">
								<div class="select-style">
									<select type="text" name="fromAdapter"></select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th>�ŷ��帧����(OUTBOUND)</th>
							<td>
								<div class="select-style">
									<select name="toAdapter"/></select>
								</div><!-- end.select-style -->	
							</td>
						</tr>
						<tr name="tr_extAdapter" style="display:none">
							<th>�ŷ��帧����(ASYNC-SYNC)</th>
							<td>
								<div class="select-style">
									<select name="extAdapter"/></select>
								</div><!-- end.select-style -->	
							</td>
						</tr>
					</table>	
					
				
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:20%;">�����͹߻�����</th>
							<td style="width:80%;" colspan="3">
								<div class="select-style">
									<select type="text" name="occurDstcd">
										<option value="REALTIME">[REALTIME] ����</option>							
									</select>
								</div><!-- end.select-style -->		
							</td>
						</tr>
						<tr>
							<th>��������</th>
							<td colspan=3>
								<div class="select-style">
									<select type="text" name="transKind">
										<option value="">���þ���</option>
										<option value="REQRES">[REQ&RES] ��û�ý��ۿ��� Ÿ�ٽý��ۿ� ���� ��û �� ������ ��ٸ��� ����</option>
										<option value="REQ">[REQ] ��û�ý��ۿ��� Ÿ�ٽý��ۿ� ���� ��û �� ������ ��ٸ��� �ʴ� ����]</option>
										<option value="RES">[RES] Ÿ�ٽý��ۿ��� ��õ�ý������� ���� ��û�� ���� ���� ����</option>
										<option value="ETC">[ETC] ��Ÿ</option>
									</select>
								</div><!-- end.select-style -->	
							</td>
						</tr>
						<tr>
							<th>�����ֱ�( ex)��1ȸ, ����)</th>
							<td colspan=3><input type="text" name="transFreq"> </td>
						</tr>
						<tr>
							<th>1ȸũ��( ex) 3KB ��)</th>
							<td  colspan=3><input type="text" name="sizeOnce"> </td>
						</tr>
						<tr>
							<th>ó���ð�����( ex) 13��~14�� )</th>
							<td colspan=3><input type="text" name="procTerm"> </td>
						</tr>			
						<tr>
							<th>��û�����</th>
							<td style="width:30%;"><input type="text" name="reqChgr"> </td>
							<th>��û����� ��ȭ��ȣ</th>
							<td style="width:30%;"><input type="text" name="reqChgrTlno"></td>
						</tr>
						<tr>
							<th>��������</th>
							<td><input type="text" name="resChgr"/></td>
							<th>�������� ��ȭ��ȣ</th>
							<td><input type="text" name="resChgrTlno"/></td>
						</tr>
						<tr>
							<th>���</th>
							<td colspan=3><input type="text" name="rmk"> </td>
						</tr>
						
					</table>	
					
				
					<table class="table_row" cellspacing="0" style="display:none">
						<tr><th>���ߴ����</th><td><input type="text" name="devUser" size="10"/><input type="text" name="devUserName" size="10"/><img src="<c:url value="/images/role_search.gif"/>" name="searchDev" /> </td></tr>
						<tr><th>��������</th><td><input type="text" name="bankUser" size="10"/><input type="text" name="bankUserName" size="10"/><img src="<c:url value="/images/role_search.gif"/>" name="searchBank" /> </td></tr>
					</table>	
					
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>

