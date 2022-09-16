<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");	
	request.setCharacterEncoding("euc-kr");
%>
<head>
<title>▣▣▣ EAI 모니터링 시스템 ▣▣▣</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link href="<%=request.getContextPath()%>/css/style-dashboard.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"> </script>
<script type="text/JavaScript"><!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_showHideLayers() { //v6.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}

function showAlarmMsg(show) {
	var obj = document.getElementById('obstaclePopup');
	if( show == true ) {
		obj.style.display = "" ;
	} else {
		obj.style.display = "none" ;
	}
}

var reqAjaxHost = null ;
var reqAjaxTran = null ;
var reqAjaxPeek = null ;
var reqAjaxSms  = null ;

var arrHost     = null ;

var serviceId     = '<%=request.getParameter("service")%>' ;


function getAjaxObject( type ) {
	if( type == "Host" ) {
		return reqAjaxHost;
	} else if( type == "Tran" ) {
		return reqAjaxTran;
	} else if( type == "Peek" ) {
		return reqAjaxPeek;
	} else if( type == "Sms" ) {
		return reqAjaxSms;
	}
	return null;
}

function setTopTime() {
	var timeObj = document.getElementById("topTime");
	if( timeObj != null ) {
		timeObj.innerHTML = getFormTime() ;
	}
	
	timeObj = null ;
}

function initPage() {
	var obj = document.getElementById("adapterPopup");
	obj.style.display = 'none' ; // block, none
	
}

function requestServerInfo( ) {
//	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=sub&type=serverinfo" ;	
//	var url = urlBase + "&service=" + serviceId ; //+ getDummyTime();
//	var reqAjax = getAjaxObject( "Host" );
//	
//	reqAjax.open('GET', url, true);
//	reqAjax.onreadystatechange = updateServerInfo ;
//	reqAjax.send(null);
//	
//	reqAjax = null;
}

function updateServerInfo() {
	
}


//-->
</script>
</head>

<!--
****************************************************************************
* body 코드 start
****************************************************************************
-->
<body>
<!------------------------------ 상단 영역 start ------------------------------>
	<!-- top include Section start -->
	<table id="top">
	  <tr>
		<td id="topLeft"><img src="../image/common/topLogo.gif" /></td>
		<td class="topMenuArea">
			<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer1','','show')"><img src="../image/menu/mainMenu01On.jpg" alt="전체모니터링"  onmouseover="this.src='../image/menu/mainMenu01On.jpg'" onmouseout="this.src='../image/menu/mainMenu01On.jpg'" /></a>
			<img src="../image/common/mainMenuSlash01.gif" class="mainMenuSlash" />
			<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer1','','hide')"><img src="../image/menu/mainMenu02Out.jpg" alt="거래정보"  onmouseover="this.src='../image/menu/mainMenu02Over.jpg'" onmouseout="this.src='../image/menu/mainMenu02Out.jpg'" /></a>
			<img src="../image/common/mainMenuSlash02.gif" class="mainMenuSlash" />
			<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer1','','hide')"><img src="../image/menu/mainMenu03Out.jpg" alt="구성관리"  onmouseover="this.src='../image/menu/mainMenu03Over.jpg'" onmouseout="this.src='../image/menu/mainMenu03Out.jpg'" /></a>
			<!-- 서브메뉴시작 -->
			<div class="subMenuBg" id="Layer1" style="visibility:visible">
				<a href="#" onfocus="blur();"><img src="../image/menu/subMenu0201Out.gif" alt="내부"  onmouseover="this.src='../image/menu/subMenu0201Over.gif'" onmouseout="this.src='../image/menu/subMenu0201Over.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="../image/menu/subMenu0202Out.gif" alt="대외"  onmouseover="this.src='../image/menu/subMenu0202Over.gif'" onmouseout="this.src='../image/menu/subMenu0202Out.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="../image/menu/subMenu0203Out.gif" alt="공동망"  onmouseover="this.src='../image/menu/subMenu0203Over.gif'" onmouseout="this.src='../image/menu/subMenu0203Out.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="../image/menu/subMenu0204Out.gif" alt="DMZ"  onmouseover="this.src='../image/menu/subMenu0204Over.gif'" onmouseout="this.src='../image/menu/subMenu0204Out.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="../image/menu/subMenu0205On.gif" alt="일괄전송"  onmouseover="this.src='../image/menu/subMenu0205On.gif'" onmouseout="this.src='../image/menu/subMenu0205On.gif'" /></a>
		</div>		</td>
		<td class="topRight">
			<div class="time">2009.09.20(일) 12:20:30</div>
			<div class="quickLink">
				<a href="#" onfocus="blur();"><img src="../image/button/btnResetOut.gif" alt="초기화"  onmouseover="this.src='../image/button/btnResetOver.gif'" onmouseout="this.src='../image/button/btnResetOut.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="../image/button/btnSoundOffOut.gif" alt="사운드끄기"  onmouseover="this.src='../image/button/btnSoundOffOver.gif'" onmouseout="this.src='../image/button/btnSoundOffOut.gif'" /></a>
				<!-- <a href="#" onfocus="blur();"><img src="../image/button/btnSoundOnOut.gif" alt="사운드켜기"  onmouseover="this.src='../image/button/btnSoundOnOver.gif'" onmouseout="this.src='../image/button/btnSoundOnOut.gif'" /></a> -->
				<a href="#" onfocus="blur();"><img src="../image/button/btnPopupCloseOut.gif" alt="팝업닫기"  onmouseover="this.src='../image/button/btnPopupCloseOver.gif'" onmouseout="this.src='../image/button/btnPopupCloseOut.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="../image/button/btnPopupOffOut.gif" alt="팝업끄기"  onmouseover="this.src='../image/button/btnPopupOffOver.gif'" onmouseout="this.src='../image/button/btnPopupOffOut.gif'" /></a>
				<!-- <a href="#" onfocus="blur();"><img src="../image/button/btnPopupOnOut.gif" alt="팝업켜기"  onmouseover="this.src='../image/button/btnPopupOnOver.gif'" onmouseout="this.src='../image/button/btnPopupOnOut.gif'" /></a> -->
			</div>
		</td>
	  </tr>
	</table>	
	<!-- top include Section end -->
<!------------------------------ 상단 영역 end ------------------------------>


<!------------------------------ 중간 영역 start ------------------------------>	
<!-- 메인내용 시작 **************************** -->
	<div class="mainCont">
	<!-- 업무별 모니터링 시작 **************************** -->	
		<div class="moniBox02"><div class="moniBox04"><div class="moniBox05"><div class="moniBox07">
		<div class="moniBox03"><div class="moniBox08"><div class="moniBox06"><div class="moniBox01">
			<!-- 타이틀 -->
			<div class="mainTitle01"><img src="../image/label/mainTitle0105.gif" /></div>
			<table>
			  <tr valign="top">
				<td>
					<!-- 업무별 모니터링 시작 -->
					<div class="channelBox00"><div class="channelBox02"><div class="channelBox04"><div class="channelBox05"><div class="channelBox07">
					<div class="channelBox03"><div class="channelBox08"><div class="channelBox06"><div class="channelBox01">
						<!-- 노드 4개 시작 -->
						<table>
						  <tr valign="top" >
							<td style="width:25%">
							<!-- 노드01 -->
								<div class="nodeB">									
									<!-- Node no --><img src="../image/node/noB1.gif" class="nodeBNo" />
									<div class="adapterBBoxBatch">
										<!-- adapter 전체상태표시 --><img src="../image/node/adapterBBallGreen.gif" class="adapterBBall" /> 
										<!-- adapter 각각상태표시 --><img src="../image/node/adapter2BallGreen.gif" class="adapterBall" /> 
									</div>
									<!-- 인스턴스 정보 -->
									<div class="instanceAreaB">
										<table class="instanceList">
										  <tr align="center">
											<td style="width:100%"><!-- 인스턴스 상태 --><!-- %=100나누기인스턴수 갯수  -->												
												<!-- instnce01 -->
												<table>
												  <tr>
													<td valign="bottom" class="instanceBar">
														<div class="instanceGreen" style="height:100%"></div>
													</td>
												  </tr>
												  <tr>
													<td class="instanceNum">
														<img src="../image/node/insDash.gif" /><br />
														<img src="../image/node/ins01.gif" />
													</td>
												  </tr>
												</table>
												<!-- instnce01 end-->
											</td>
											</tr>
										</table>
									</div>

									<!-- 리소스 정보 -->
									<div class="systemBBox"><!-- 바의 width 는 5*%의 10의 단위 --><!-- 70이상은노랑/90이상은 빨강 -->
										<table width="82px">
										  <tr>
											<td class="barBBg"><div class="barBYellow" style="width:35px"></div></td>
											<td class="textSystemB">70</td>
										  </tr>
										  <tr>
											<td class="barBBg"><div class="barBRed" style="width:45px"></div></td>
											<td class="textSystemB">90</td>
										  </tr>
										  <tr>
											<td class="barBBg"><div class="barBGreen" style="width:15px"></div></td>
											<td class="textSystemB">30</td>
										  </tr>
										</table>
									</div>
									<!-- 접속수 -->
									<div class="conCountBBox">1,234</div>
								</div>
							</td>
							<td style="width:25%">
							<!-- 노드02 -->
								<div class="nodeBDownBatch">
									<div class="nodeNo"><!-- Node no --><img src="../image/node/noB2Down.gif" /></div>
								</div>
							</td>
							<td style="width:25%">
							<!-- 노드03 -->
								<div class="nodeBNoneBatch"></div>
							</td>
							<td style="width:25%">
							<!-- 노드04 노드 다운시 표현-->
								<div class="nodeBNoneBatch"></div>
							</td>
						  </tr>
						</table>
						<!-- 노드 4개 끝 -->
					</div></div></div></div></div>
					</div></div></div></div>
					<!-- 업무별 모니터링 끝 -->			
				</td>
				<td align="right">
					<div class="instanceSmsBox22"><div class="instanceSmsBox24"><div class="instanceSmsBox25"><div class="instanceSmsBox27">
						<div class="instanceSmsBox23"><div class="instanceSmsBox28"><div class="instanceSmsBox26"><div class="instanceSmsBox21" style="text-align: left" >
							<div class="instanceSmsTitle03">
								<img src="../image/label/instanceSmsTitleNo0301.gif" style="margin-left:102px" /><!-- 노드번호 -->
								<img src="../image/label/instanceSmsTitleNode03.gif" />
								<img src="../image/label/instanceSmsTitleNo0302.gif" /><!-- 인스턴스번호 -->
								<img src="../image/label/instanceSmsTitleIns03.gif" />
								<img src="../image/button/btnAuto03.gif" style="margin-left:27px" /><!-- 자동/수동 -->
							</div>
							<div class="instanceState02">
								<img src="../image/node/instanceArrowReceiptGreen01.gif" />
								<img src="../image/node/instanceArrowTransGreen01.gif" />
								<img src="../image/node/instanceArrowTransRed02.gif" />
								<img src="../image/node/instanceArrowReceiptGreen02.gif" />
							</div>
							<table class="table02">
							  <tr>
								<th style="width:30%"><img src="../image/label/tableTitle0401.gif" /></th>
								<th style="width:35%"><img src="../image/label/tableTitle0402.gif" /></th>
								<th style="width:35%"><img src="../image/label/tableTitle0403.gif" /></th>
							  </tr>
							  <tr>
								<td align="center">업무명</td>
								<td align="center">변환에러시</td>
								<td align="center">대외기관명</td>
							  </tr>
							</table>
						</div></div></div></div>
					  	</div></div></div></div>
					</td>
			  </tr>
			</table>
		</div></div></div></div>
		</div></div></div></div>
	<!-- 업무별 모니터링 끝 **************************** -->	
	<!-- 거래처리 현황 시작 **************************** -->	
		<div class="tranBox02">
			<div class="tableBoxBg01"><div class="tableBox02"><div class="tableBox04"><div class="tableBox05"><div class="tableBox07">
			<div class="tableBox03"><div class="tableBox08"><div class="tableBox06"><div class="tableBox01">
				<!-- 타이틀 -->
				<div>
					<img src="../image/bullet/titleIcon01.jpg" /> &nbsp;
					<img src="../image/label/title01.jpg" alt="거래처리현황" />
				</div>
				
				<!-- 테이블 -->
				<table class="table01">
				  <tr>
					<th><img src="../image/label/tableTitle0117.gif" /></th>
					<th style="width:15%"><img src="../image/label/tableTitle0121.gif" /></th>
					<th style="width:15%"><img src="../image/label/tableTitle0122.gif" /></th>
					<th style="width:15%"><img src="../image/label/tableTitle0123.gif" /></th>
					<th style="width:15%"><img src="../image/label/tableTitle0124.gif" /></th>
					<th style="width:15%"><img src="../image/label/tableTitle0125.gif" /></th>
					<th style="width:15%"><img src="../image/label/tableTitle0126.gif" /></th>
				  </tr>
				  <tr>
					<td align="center"><span class="textGroup">1</span></td>
					<td align="right">22,222</td>
					<td align="right">222</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
				  </tr>
				  <tr class="second">
					<td align="center"><span class="textGroup">2</span></td>
					<td align="right">22,222</td>
					<td align="right">222</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
				  </tr>
				  <tr>
					<th class="sum"><img src="../image/label/tableTitle0109.gif" /></th>
					<th class="sumRight">44,444</th>
					<th class="sumRight">444</th>
					<th class="sumRight">0</th>
					<th class="sumRight">0</th>
					<th class="sumRight">0</th>
					<th class="sumRight">0</th>
				  </tr>
			  </table>
			</div></div></div></div></div>
			</div></div></div></div>
		</div>
	<!-- 거래처리 현황 끝 **************************** -->	
	
	<!-- 장애통보현황 시작 **************************** -->	
		<div class="obstacleBox">
			<div class="tableBoxBg01"><div class="tableBox02"><div class="tableBox04"><div class="tableBox05"><div class="tableBox07">
			<div class="tableBox03"><div class="tableBox08"><div class="tableBox06"><div class="tableBox01">
				<!-- 타이틀 -->
				<div>
					<img src="../image/bullet/titleIcon01.jpg" /> &nbsp;
					<img src="../image/label/title03.jpg" alt="장애통보현황" />
				</div>
				<!-- 테이블 -->
				<table class="table01">
				  <tr>
				    <th style="width:110px"><img src="../image/label/tableTitle0302.gif" /></th>
					<th style="width:120px"><img src="../image/label/tableTitle0303.gif" /></th>
					<th><img src="../image/label/tableTitle0304.gif" /></th>
				  </tr>
				  <tr>
				    <td align="center">TSEAI_i11</td>
					<td align="center">BEAIB07003</td>
					<td>[2 Node][5 Inst[SI]]업무팀 응답 데이터 수신중 타임아웃.</td>
				  </tr>
				  <tr class="second">
				    <td align="center">TSEAI_i11</td>
					<td align="center">BEAIB07003</td>
					<td>[2 Node][5 Inst[SI]]업무팀 응답 데이터 수신중 타임아웃.</td>
				  </tr>
				  <tr>
				    <td align="center">TSEAI_i11</td>
					<td align="center">BEAIB07003</td>
					<td>[2 Node][5 Inst[SI]]업무팀 응답 데이터 수신중 타임아웃.</td>
				  </tr>
			  </table>
			</div></div></div></div></div>
			</div></div></div></div>
		</div>
	<!-- 장애통보현황 끝 **************************** -->	
	</div>
<!-- 메인내용 끝 **************************** -->
<!------------------------------ 중간 영역 end ------------------------------>

<!------------------------------ 하단 영역 start ------------------------------>
	<!-- btm include Section Start -->
	<!-- btm include Section end->	
<!------------------------------ 하단 영역 end ------------------------------>

<!-- 팝업  시작 **************************** -->	
<!-- 시스템상황판 시작 -->
<!-- 시스템상황판 끝 -->

<!-- 어댑터상황판 시작 -->
<!-- 어댑터상황판 끝 -->
<!-- 장애통보 상황판 시작 -->
<div id="obstaclePopup" style="width:278px; height:60px; top:170px; left:365px; position:absolute; z-index:700; visibility: hidden;"><!-- 노드 간격 145px -->
	<div class="popBgBox02"><div class="popBgBox04"><div class="popBgBox05"><div class="popBgBox07">
	<div class="popBgBox03"><div class="popBgBox08"><div class="popBgBox06"><div class="popBgBox01">
		<div class="boxRedTitle">
			<div class="floatLeft">
				<!-- 빨간색 경고창일때 -->
				&nbsp;&nbsp;<img src="../image/popup/iconTitleRed.gif" />&nbsp;
				<span>내부 1번 2번인스턴스</span>
			</div>
			<div class="floatRight">
				<a href="#" onfocus="blur();"><img src="../image/popup/btnclose02.gif" alt="닫기" style="margin-top:3px"/></a>
			</div>
		</div>
		<div class="boxRed"><div class="boxRedBg">
			<span>
				- 에러내용입니다.<br />
				- 에러내용입니다.<br />
				- 에러내용입니다.<br />
				- 에러내용입니다.
			</span>
		</div></div>
	</div></div></div></div>
	</div></div></div></div>
</div>
<!-- 장애통보 끝 -->
<!-- 시스템리소스상황판 시작 -->
<div id="adapterPopup" style="width:370px; top:405px; left:690px; position:absolute; z-index:900; visibility: visibility;">
	<div class="popBgBox02"><div class="popBgBox04"><div class="popBgBox05"><div class="popBgBox07">
	<div class="popBgBox03"><div class="popBgBox08"><div class="popBgBox06"><div class="popBgBox01">
		<div class="boxYellowTitle">
			<div class="floatLeft">
				&nbsp;&nbsp;<img src="../image/bullet/iconTitleYellow.gif" />&nbsp;
				<span>시스템상황판</span>
			</div>
			<div class="floatRight">
				<a href="#" onfocus="blur();"><img src="../image/button/btnclose02.gif" alt="닫기" style="margin-top:3px"/></a>
			</div>
		</div>
		<div class="boxYellow"><div class="boxYellowBg">
			<table>
			  <tr>
				<td>
					<img src="../image/popup/popTitle01.gif" alt="CPU"/>					
					<table class="gageBox">
					  <tr>
						<td valign="bottom"><!-- 1%는 2px , % *2 로 높이 계산 -->
							<div class="gageBgGreen"><div class="gageEndGreen"><div class="gageStartGreen" style="height:60px"></div></div></div>
						</td>
					  </tr>
					</table>						
					<div class="gageTextGreen">30%</div>
				</td>
				<td>
					<img src="../image/popup/popTitle02.gif" alt="Memory"/>					
					<table class="gageBox">
					  <tr>
						<td valign="bottom">
							<div class="gageBgGreen"><div class="gageEndGreen"><div class="gageStartGreen" style="height:120px"></div></div></div>
						</td>
					  </tr>
					</table>						
					<div class="gageTextGreen">60%</div>
				</td>
				<td>
					<img src="../image/popup/popTitle03.gif" alt="Disk"/>					
					<table class="gageBox">
					  <tr>
						<td>
							<div class="gageBgRed"><div class="gageEndRed"><div class="gageStartRed" style="height:200px"></div></div></div>
						</td>
					  </tr>
					</table>						
					<div class="gageTextRed">100%</div>
				</td>
			  </tr>
			</table>
		</div></div>
	</div></div></div></div>
	</div></div></div></div>
</div>
<!-- 시스템리소스상황판 끝 -->
<!-- 팝업 끝 **************************** -->	


<script>
	
	initPage();
	
	setInterval("setTopTime();", 1000);
</script>
	
</body>
<!--
****************************************************************************
* body 코드 end
****************************************************************************
-->
</html>