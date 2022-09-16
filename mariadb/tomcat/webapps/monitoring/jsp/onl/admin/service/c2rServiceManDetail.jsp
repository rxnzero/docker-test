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
<jsp:include page="/jsp/common/include/css.jsp" />
<jsp:include page="/jsp/common/include/script.jsp" />

<script language="javascript">
var url      = '<c:url value="/onl/admin/service/c2rServiceMan.json" />';
var url_view = '<c:url value="/onl/admin/service/c2rServiceMan.view" />';

var selectName = "psvSysBzwkDstcd,outbndRoutName,psvSysAdptrBzwkGroupName";	// selectBox Name

	var isDetail = false;
	function isValid() {

		var extnlInstiIdnfiName = $('input[name=extnlInstiIdnfiName]'); 
		if ( extnlInstiIdnfiName.val() == "") {
			alert("����ڵ��� �Է��Ͽ� �ֽʽÿ�.");
			extnlInstiIdnfiName.focus();
			return false;
		}
		var svcPrcssNo = $('select[name=svcPrcssNo]'); 
		if ( svcPrcssNo.val() == "") {
			alert("���� ó�������� �Է��Ͽ� �ֽʽÿ�.");
			svcPrcssNo.focus();
			return false;
		}		

		return true;
	}
	function isValidClone() {

		var extnlInstiIdnfiName = $('input[name=newExtnlInstiIdnfiName]'); 
		if ( extnlInstiIdnfiName.val() == "") {
			alert("����ڵ��� �Է��Ͽ� �ֽʽÿ�.");
			extnlInstiIdnfiName.focus();
			return false;
		}
		var svcPrcssNo = $('select[name=newSvcPrcssNo]'); 
		if ( svcPrcssNo.val() == "") {
			alert("���� ó�������� �Է��Ͽ� �ֽʽÿ�.");
			svcPrcssNo.focus();
			return false;
		}	

		return true;
	}	

	function init( key,key2, callback) {
		$.ajax({  
			type : "POST",
			url:url,
			dataType:"json",
			data:{cmd: 'LIST_DETAIL_COMBO'},
			success:function(json){
				new makeOptions("CODE","NAME").setObj($("select[name=psvIntfacDsticName]" )).setData(json.psvItfTypeRows        ).rendering();//���� �������̽� ����	             		
				new makeOptions("CODE","NAME").setObj($("select[name=psvSysBzwkDstcd]"    )).setData(json.bizRows               ).setFormat(codeName3OptionFormat).rendering();//������������        		
				new makeOptions("CODE","NAME").setObj($("select[name=psvSysIdName]"       )).setData(json.psvIdRows             ).rendering();//�����ý���ID        		
				new makeOptions("CODE","NAME").setObj($("select[name=flovrYn]"            )).setData(json.failOverClsRows       ).setFormat(codeName3OptionFormat).rendering();//FailOver����           		
				new makeOptions("CODE","NAME").setObj($("select[name=chngEonot]"          )).setData(json.cnvExistNotRows       ).setFormat(codeName3OptionFormat).rendering();//��ȯ����             		
				new makeOptions("CODE","NAME").setObj($("select[name=bascRspnsChngEonot]" )).setData(json.bsRspCnvExistNotRows  ).setFormat(codeName3OptionFormat).rendering();//�⺻���亯ȯ����             		
				new makeOptions("CODE","NAME").setObj($("select[name=errRspnsChngEonot]"  )).setData(json.errRspCnvExistNotRows ).setFormat(codeName3OptionFormat).rendering();//�������亯ȯ����             		
				new makeOptions("CODE","NAME").setObj($("select[name=outbndRoutName]"     )).setData(json.outBoundRoutingRows   ).rendering();//Outbound����ø�             		
				new makeOptions("CODE","NAME").setObj($("select[name=supplDelYn]"         )).setData(json.addDelYnRows          ).setFormat(codeName3OptionFormat).rendering();//�߰���������             		
				new makeOptions("CODE","NAME").setObj($("select[name=hdrCtrlDstcd]"       )).setData(json.hdrCtlCdRows          ).setFormat(codeName3OptionFormat).rendering();//���������ڵ�             		
				new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj($("select[name=psvSysAdptrBzwkGroupName]")).setFormat(codeName3OptionFormat).setData(json.ouAdapterRows).rendering();//�����ý����������̽�����
				
				new makeOptions("CODE","NAME").setObj($("select[name=newSvcPrcssNo]"      )).setData(json.svcPrcssNo          	).rendering();//���� ó�� ����
				new makeOptions("CODE","NAME").setObj($("select[name=svcPrcssNo]"         )).setData(json.svcPrcssNo          	).rendering();//���� ó�� ����          
				
				if(key == "") setSearchable(selectName);	// �޺��� searchable ����
				
				if(typeof callback === 'function') {
					callback(key,key2);
	    		}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	
	}
	function detail( key,key2) {

		if (!isDetail)
			return;
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'DETAIL',
				extnlInstiIdnfiName : key,
				svcPrcssNo : key2
			},
			success : function(json) {
				debugger;
				var data = json;
				$("input[name=extnlInstiIdnfiName]").attr('readonly', true);
				
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
				$("select[name=svcPrcssNo] option").not(":selected").remove();

				setSearchable(selectName);	// �޺��� searchable ����
			},
			error : function(e) {
				alert(e.responseText);
			}
		});

	}
	$(document).ready(function() {
		var returnUrl = getReturnUrlForReturn();
		var key = "${param.extnlInstiIdnfiName}";
		var key2 = "${param.svcPrcssNo}";

		if (key != "" && key != "null") {
			isDetail = true;
		}
		init(key,key2, detail);

		$("#btn_modify").click(function() {
			if (!isValid()){
				return;
			}
		
			//����θ� form���� ����
			var postData = $('#ajaxForm').serializeArray();

			if (isDetail) {
				postData.push({
					name : "cmd",
					value : "UPDATE"
				});
			} else {
				postData.push({
					name : "cmd",
					value : "INSERT"
				});
			}
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_delete").click(function() {
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "cmd",
				value : "DELETE"
			});
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�

				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});
		$("#btn_previous").click(function() {
			goNav(returnUrl);//LIST�� �̵�
		});
		$("#btn_initialize").click(function(){
			$.ajax({  
				type : "POST",
				url:url,
				dataType:"json",
				data:{cmd: 'INITIALIZE',extnlInstiIdnfiName:$("input[name=extnlInstiIdnfiName]").val()},
				success:function(json){
					alert("�����Ͽ����ϴ�.");
				},
				error:function(e){
					alert(e.responseText);
				}
			});		
		});		
		$("#btn_clone").click(function() {
			if (!isValidClone()){
				return;
			}
		
			//����θ� form���� ����
			var postData = $('#ajaxForm').serializeArray();
			postData.push({
				name : "cmd",
				value : "CLONE"
			});
			$.ajax({
				type : "POST",
				url : url,
				data : postData,
				success : function(args) {
					alert("���� �Ǿ����ϴ�.");
					goNav(returnUrl);//LIST�� �̵�
				},
				error : function(e) {
					alert(e.responseText);
				}
			});
		});

		buttonControl(key);
		titleControl(key);
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
				<div class="title">����� C2R ��� ����</div>	
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0">
						<tr>
							<th style="width:150px;">��� �ڵ�</th>
							<td colspan="3"><input type="text" name="extnlInstiIdnfiName"/> </td>							
						</tr>
						<tr>
							<th style="width:150px;">����ó�� ����</th>
							<td>
								<div class="select-style"><select name="svcPrcssNo" /></div>
							</td>
							<th style="width:150px;">�����������̽�����</th>
							<td>
								<div class="select-style"><select name="psvIntfacDsticName"/></div> 
							</td>
						</tr>
						<tr>
							<th>������������</th>
							<td>
								<div class="select-style"><select name="psvSysBzwkDstcd"/></div> 
							</td>
							<th>�����ý���ID</th>
							<td>
								<div class="select-style"><select name="psvSysIdName"/></div> 
							</td>
						</tr>
						<tr>
							<th>�����ý��ۼ����ڵ�</th><td><input type="text" name="psvSysSvcDsticName"/> </td>
							<th>�����ý����������̽�����</th>
							<td>
								<div class="select-style"><select name="psvSysAdptrBzwkGroupName"/></div> 
							</td>
						</tr>
						<tr>
							<th>FailOver����</th>
							<td>
								<div class="select-style"><select name="flovrYn"/></div>
							</td>
							<th>��ȯ����</th>
							<td>
								<div class="select-style"><select name="chngEonot"/></div> 
							</td>
						</tr>
						<tr>
							<th>��ȯ�޽���ID</th><td colspan="3"><input type="text" name="chngMsgIdName"/> </td>
						</tr>
						<tr>
							<th>�⺻����޽����񱳰�</th><td><input type="text" name="bascRspnsMsgCmprCtnt"/> </td>
							<th>�⺻���亯ȯ����</th>
							<td>
								<div class="select-style"><select name="bascRspnsChngEonot"/></div>
							</td>
						</tr>
						<tr>
							<th>�⺻���亯ȯ�޽���ID</th><td colspan="3"><input type="text" name="bascRspnsChngMsgIdName"/> </td>
							
						</tr>
						<tr>
							<th>��������޽����񱳰�</th><td><input type="text" name="errRspnsMsgCmprCtnt"/> </td>
							<th>�������亯ȯ����</th>
							<td>
								<div class="select-style"><select name="errRspnsChngEonot"/></div>
							</td>
						</tr>
						<tr>
							<th>�������亯ȯ�޽���ID</th><td colspan="3"><input type="text" name="errRspnsChngMsgIdName"/> </td>							
						</tr>
						<tr>
							<th>��������ó������</th><td><input type="text" name="nextSvcPrcssNo"  value="0"/> </td>
							<th>Outbound����ø�</th>
							<td>
								<div class="select-style"><select name="outbndRoutName"/></div>
							</td>
						</tr>
						<tr>
							<th>Ÿ�Ӿƿ���</th><td><input type="text" name="toutVal" value="0"/> </td>
							<th>���󼭺�ó���ڵ�</th><td><input type="text" name="cmpenSvcPrcssDsticName"/> </td>
						</tr>
						<tr>
							<th>�߰���������</th>
							<td>
								<div class="select-style"><select name="supplDelYn"/></div>
							</td>
							<th>���������ڵ�</th>
							<td>
								<div class="select-style"><select name="hdrCtrlDstcd"/></div>
							</td>
						</tr>
						<tr>
							<th>����Ŭ������</th><td colspan="3"><input type="text" name="hdrRefClsName"/> </td>
						</tr>
					</table>
				</form>
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->	
	</body>
</html>