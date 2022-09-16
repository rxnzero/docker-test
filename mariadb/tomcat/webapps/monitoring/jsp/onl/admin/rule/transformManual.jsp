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

$(document).ready(function() {	
	
	$("input[name=btn_1]").click(function(){
		var url='<c:url value="/onl/admin/rule/transformManual.view"/>';
		url +="?cmd=POPUP1";
	    showModal(url,null,400,250);
	});
	$("input[name=btn_2]").click(function(){
		var url='<c:url value="/onl/admin/rule/transformManual.view"/>';
		url +="?cmd=POPUP2";
	    showModal(url,null,400,250);
	});
	
	
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
				
				<!-- <div class="title">�������̾ƿ� ���� ���̵�</div> -->
				
				<div class="transform_title">������ ���̵��ڷ�</div>
				<ul class="transform" style="border-bottom:0;">
					<li style="width:50%;">
						<div class="box_wrap">
							<div class="box" style="text-align:right;">
								<label style="position:absolute; left:20px; top:5px;">���̵� �ڷ� �ٿ�ޱ�</label> <input type="button" name="btn_1" class="btn_img btn_download">
							</div>
						</div>	
					</li>
					<li style="width:50%;">	
						<div class="box_wrap">
							<div class="box" style="text-align:right;">
								<label style="position:absolute; left:20px; top:5px;">�������� �ٿ�ޱ�</label> <input type="button" name="btn_2" class="btn_img btn_download">
							</div>
						</div>	
					</li>	
				</ul><!-- end.transform -->		
				<div class="transform_title">�������� ���μ���</div>					
				<ul class="transform">
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">01. �۾�</div>
								<div class="con">
									<div>�������� �ۼ�</div>
									<div>
										- �ý��� �������̽� ���輭(�������)<br>
										- �ý��� �������̽� �ۼ��� �׸� ���輭(�������)
									</div>
									<div>(������)</div>
								</div>
							</div>
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">02. ����</div>
								<div class="con">
									<div>���� �����ڰ� �䱸�ϴ� Ÿ�ٽý��� �� ��ܱ�� ȯ���� EAI �ý��ۿ� �����ϱ� ���� �����۾�</div>
									<div>
										- �����ڷ� : 1. �ý��� �������̽� ���輭
									</div>
									<div>(EAI/FEP �����, ������)</div>
								</div>		
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">03. EAI/FEP �����۾�</div>
								<div class="con">
									<div>���������� ���� EAI/FEP ȯ�漳��</div>
									<div>
										- ���볻�� : Adapter, ǥ�غ�ǥ��, ����, �񵿱�, EAI �����ڵ� ��
									</div>
									<div>(EAI/FEP �����)</div>
								</div>		
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">04. �������ϵ��</div>
								<div class="con">
									<div>�������� ���</div>
									<div>
										- �ý��� �������̽� �ۼ��� �׸� ���輭(�������)
									</div>
									<div>(������)</div>
								</div>		
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">05. I/O ��ȯ����</div>
								<div class="con">
									<div>EAI/FEP ���� UIȭ���� �̿��Ͽ� I/O ��ȯ �� ���� �۾�</div>
									<div>
										- �۾��� ��ȯ������ Download, Upload ����
									</div>
									<div>(������)</div>
								</div>						
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">06. �׽�Ʈ</div>
								<div class="con">
									<div>���� �� �׽�Ʈ ����</div>
									<div>(������)</div>
								</div>						
							</div>	
						</div>	
					</li>
				</ul><!-- end.transform -->					
				
				<!-- <table id="grid" ></table>
				<div id="pager"></div> -->
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
		
		
</html>

