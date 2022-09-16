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
				
				<!-- <div class="title">전문레이아웃 관리 가이드</div> -->
				
				<div class="transform_title">업무용 가이드자료</div>
				<ul class="transform" style="border-bottom:0;">
					<li style="width:50%;">
						<div class="box_wrap">
							<div class="box" style="text-align:right;">
								<label style="position:absolute; left:20px; top:5px;">가이드 자료 다운받기</label> <input type="button" name="btn_1" class="btn_img btn_download">
							</div>
						</div>	
					</li>
					<li style="width:50%;">	
						<div class="box_wrap">
							<div class="box" style="text-align:right;">
								<label style="position:absolute; left:20px; top:5px;">엑셀서식 다운받기</label> <input type="button" name="btn_2" class="btn_img btn_download">
							</div>
						</div>	
					</li>	
				</ul><!-- end.transform -->		
				<div class="transform_title">업무적용 프로세스</div>					
				<ul class="transform">
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">01. 작업</div>
								<div class="con">
									<div>엑셀서식 작성</div>
									<div>
										- 시스템 인터페이스 설계서(엑셀양식)<br>
										- 시스템 인터페이스 송수신 항목 설계서(엑셀양식)
									</div>
									<div>(개발자)</div>
								</div>
							</div>
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">02. 협의</div>
								<div class="con">
									<div>업무 개발자가 요구하는 타겟시스템 및 대외기관 환경을 EAI 시스템에 적용하기 위한 사전작업</div>
									<div>
										- 협의자료 : 1. 시스템 인터페이스 설계서
									</div>
									<div>(EAI/FEP 담당자, 개발자)</div>
								</div>		
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">03. EAI/FEP 사전작업</div>
								<div class="con">
									<div>개별전문에 대한 EAI/FEP 환경설정</div>
									<div>
										- 적용내용 : Adapter, 표준비표준, 동기, 비동기, EAI 서비스코드 등
									</div>
									<div>(EAI/FEP 담당자)</div>
								</div>		
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">04. 엑셀파일등록</div>
								<div class="con">
									<div>엑셀파일 등록</div>
									<div>
										- 시스템 인터페이스 송수신 항목 설계서(엑셀양식)
									</div>
									<div>(개발자)</div>
								</div>		
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">05. I/O 변환매핑</div>
								<div class="con">
									<div>EAI/FEP 제공 UI화면을 이용하여 I/O 변환 룰 매핑 작업</div>
									<div>
										- 작업한 변환내용을 Download, Upload 가능
									</div>
									<div>(개발자)</div>
								</div>						
							</div>	
						</div>		
					</li>
					<li>
						<div class="box_wrap">
							<div class="box">
								<div class="tit">06. 테스트</div>
								<div class="con">
									<div>개발 및 테스트 진행</div>
									<div>(개발자)</div>
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

