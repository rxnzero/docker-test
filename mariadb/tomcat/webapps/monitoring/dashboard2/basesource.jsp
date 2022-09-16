<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="com.eactive.eai.rms.common.util.StringUtils"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	request.setCharacterEncoding("euc-kr");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�ââ� EAI ����͸� �ý��� �ââ�</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link href="<%=request.getContextPath()%>/css/style-dashboard.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js"> </script>
<script language="JavaScript" type="text/JavaScript">
<!--
var reqAjaxComm = null ;
var reqAjaxOut  = null ;
var reqAjaxIn   = null ;
var reqAjaxDmz  = null ;
var reqAjaxBatch= null ;

var arrHostComm = null ;
var arrHostOut  = null ;
var arrHostIn   = null ;
var arrHostDmz  = null ;
var arrHostBatch= null ;



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

function requestData() {

	var url = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=serverinfo" ;
	var optRefresh = "&t=" + ((new Date()).valueOf()); // ĳ�ù���
	
	reqAjaxComm.open("GET", url + optRefresh + "&service=INST3", true); // ����
	reqAjaxComm.onreadystatechange = updatePageComm ;
	reqAjaxComm.send(null);

	reqAjaxIn.open("GET", url + optRefresh + "&service=INST2", true); // ����
	reqAjaxIn.onreadystatechange = updatePageIn ;
	reqAjaxIn.send(null);

	reqAjaxOut.open("GET", url + optRefresh + "&service=INST1", true); // ���
	reqAjaxOut.onreadystatechange = updatePageOut ;
	reqAjaxOut.send(null);

	reqAjaxDmz.open("GET", url + optRefresh + "&service=INST4", true); // DMZ
	reqAjaxDmz.onreadystatechange = updatePageDmz ;
	reqAjaxDmz.send(null);

	reqAjaxBatch.open("GET", url + optRefresh + "&service=INST5", true); // BATCH
	reqAjaxBatch.onreadystatechange = updatePageBatch ;
	reqAjaxBatch.send(null);
}

// Get host basic html
function getHostHtml(no, type) {
	var bodyHtml = '' ;
	bodyHtml += '<div class="nodeNo"><img src="<%=request.getContextPath()%>/image/node/num' + no + '.gif" /></div>' ;
	bodyHtml += '<div id="adapter' + type + 'Display' + no + '" class="adapterBox">' ;
	bodyHtml += '<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" />' ;
	bodyHtml += '</div>' ;
	bodyHtml += '<div class="instanceArea">' ;
	bodyHtml += '<div' + 'id="inst' + type + 'Line' + no + '" class="instanceLine">' ;
	bodyHtml += '<div id="inst' + type + 'Display' + no + '" class="instanceBox">' ;
	bodyHtml += '</div>' ;
	bodyHtml += '</div></div>' ;
	bodyHtml += '<div class="systemBox">' ;
	bodyHtml += '<table width="60px">' ;
	bodyHtml += '<tr>' ;
	bodyHtml += '<td class="barBg"><div id="cpu' + type + 'Bar' + no + '" class="barGreen" style="width:4px"></div></td>' ;
	bodyHtml += '<td id="cpu' + type + 'Val' + no +'" class="textSystem">0</td>' ;
	bodyHtml += '</tr>' ;
	bodyHtml += '<tr>' ;
	bodyHtml += '<td class="barBg"><div id="memory' + type + 'Bar' + no + '" class="barGreen" style="width:4px"></div></td>' ;
	bodyHtml += '<td id="memory' + type + 'Val' + no +'" class="textSystem">0</td>' ;
	bodyHtml += '</tr>' ;
	bodyHtml += '<tr>' ;
	bodyHtml += '<td class="barBg"><div id="disk' + type + 'Bar' + no + '" class="barGreen" style="width:4px"></div></td>' ;
	bodyHtml += '<td id="disk' + type + 'Val' + no +'" class="textSystem">0</td>' ;
	bodyHtml += '</tr>' ;
	bodyHtml += '</table>' ;
	bodyHtml += '</div>' ;
	bodyHtml += '<div id="proc' + type + 'Val' + no +'"  class="conCountBox">0</div>' ;
	return bodyHtml;
}

// Draw empty host box image
function setHostBasicEmpty(type, id) {
	var hostObj = document.getElementById("host" + type + "Display" + id);
	if( hostObj != null ) {
		hostObj.className = "nodeSDown";
		hostObj.innerHTML = '<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num' + id + 'Down.gif" /></div>';
	}
}

// Draw basic host box image
function setHostBasic( type, id ) {
	var hostObj = document.getElementById('host' + type + 'Display' + id);
	if( hostObj != null ) {
		hostObj.className = "nodeS" ;
		hostObj.innerHTML = getHostHtml( id, type);
	}
}

function setInstBasic( type, id, arrInsts ) {
	var lineObj = document.getElementById('inst' + type + 'Line' + id);
	if( lineObj != null ) {
		if( arrInsts.length < 6 ) {
			lineObj.className = "instanceLine" ;
		} else {
			lineObj.className = "instanceLine2" ;
		}
	}
	
	var instObj = document.getElementById('inst' + type + 'Display' + id);
	if( instObj != null ) {
		var htmlSrc = "" ;
		for( var i = 1 ; i <= arrInsts.length ; i++ ) {
			htmlSrc += '<img src="<%=request.getContextPath()%>/image/node/ins' + i + 'Green.gif" />';
		} 
		instObj.innerHTML = htmlSrc;
	}
}

function checkHostNames( lines ) {
	var arrHosts = new Array();
	var cntHost = 0 ;
	var back = "" ;
	if( lines != null ) {
		for( var i = 0 ; i < lines.length ; i++ ) {
			var infos = lines[i].split(",");
			// inst, ip, port, host
			if( infos.length > 3 ) {
				if( infos[3] != back ) {
					cntHost ++ ;
					back = infos[3];
					arrHosts[cntHost-1] = infos[3];
				}
			}
		}		
	}
	
	return arrHosts;
}

function checkInstNames( lines, host ) {
	var arrInst = new Array();
	var step = 0 ;
	if( lines != null ) {
		for( var i = 0 ; i < lines.length ; i++ ) {
			var infos = lines[i].split(",");
			if( infos.length > 3 ) {
				if( infos[3] == host ) {
					arrInst[step++] = infos[0];
				}
			}		
		}
	}
	return arrInst;
}

function updatePage( type ) {
	var tmpAjax = null ;
	var arrHost  = null ;
	if( "Comm" == type ) {
		tmpAjax = reqAjaxComm;
		arrHost  = arrHostComm;
	} else if( "In" == type ) {
		tmpAjax = reqAjaxIn;
		arrHost  = arrHostIn;
	} else if( "Out" == type ) {
		tmpAjax = reqAjaxOut;
		arrHost  = arrHostOut;
	} else if( "Dmz" == type ) {
		tmpAjax = reqAjaxDmz;
		arrHost  = arrHostDmz;
	} else if( "Batch" == type ) {
		tmpAjax = reqAjaxBatch;
		arrHost  = arrHostBatch;
	}
	
	var msg = getAjaxData(tmpAjax);
	if( null != msg ) {
		
		var lines = msg.split(";");
		arrHost = checkHostNames(lines);
		
		var hostMax = 4 ;
		if( type == 'Dmz' || type == 'Batch' ) {
			hostMax = 2 ;
		}
		
		for( var i = 0 ; i < hostMax ; i++ ) {
			if( i < arrHost.length ) {
				
				setHostBasic( type, i+1);
				var arrInst = checkInstNames(lines, arrHost[i]);
				setInstBasic( type, i+1, arrInst);
			} else {
				setHostBasicEmpty( type, i+1);
			}
		}
	}	
}

function updatePageComm() {
	updatePage("Comm");
}

function updatePageIn() {
	updatePage("In");
}

function updatePageOut() {
	updatePage("Out");
}

function updatePageDmz() {
	updatePage("Dmz");
}

function updatePageBatch() {
	
}

function getAjaxData( req ) {
	if( req.readyState == 4 ) {
		if( req.status == 200 ) {
			return req.responseText ;
		} else {
		}
	} else {
	}
	return null ;
}

//-->
</script>
</head>

<!--
****************************************************************************
* body �ڵ� start
****************************************************************************
-->
<body>
<!------------------------------ ��� ���� start ------------------------------>
	<!-- top include Section start -->
	<table id="top">
	  <tr>
		<td id="topLeft"><img src="<%=request.getContextPath()%>/image/common/topLogo.gif" /></td>
		<td class="topMenuArea">
			<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer1','','show')"><img src="<%=request.getContextPath()%>/image/menu/mainMenu01On.jpg" alt="��ü����͸�" border="0"  onmouseover="this.src='../image/menu/mainMenu01On.jpg'" onmouseout="this.src='../image/menu/mainMenu01On.jpg'" /></a>
			<img src="<%=request.getContextPath()%>/image/common/mainMenuSlash01.gif" class="mainMenuSlash" />
			<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer1','','hide')"><img src="<%=request.getContextPath()%>/image/menu/mainMenu02Out.jpg" alt="�ŷ�����" border="0"  onmouseover="this.src='../image/menu/mainMenu02Over.jpg'" onmouseout="this.src='../image/menu/mainMenu02Out.jpg'" /></a>
			<img src="<%=request.getContextPath()%>/image/common/mainMenuSlash02.gif" class="mainMenuSlash" />
			<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer1','','hide')"><img src="<%=request.getContextPath()%>/image/menu/mainMenu03Out.jpg" alt="��������" border="0"  onmouseover="this.src='../image/menu/mainMenu03Over.jpg'" onmouseout="this.src='../image/menu/mainMenu03Out.jpg'" /></a>
			<!-- ����޴����� -->
			<div class="subMenuBg" id="Layer1" style="visibility:hidden">
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/menu/subMenu0201Out.gif" alt="����" border="0"  onmouseover="this.src='../image/menu/subMenu0201Over.gif'" onmouseout="this.src='../image/menu/subMenu0201Out.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/menu/subMenu0202Out.gif" alt="���" border="0"  onmouseover="this.src='../image/menu/subMenu0202Over.gif'" onmouseout="this.src='../image/menu/subMenu0202Out.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/menu/subMenu0203Out.gif" alt="������" border="0"  onmouseover="this.src='../image/menu/subMenu0203Over.gif'" onmouseout="this.src='../image/menu/subMenu0203Out.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/menu/subMenu0204Out.gif" alt="DMZ" border="0"  onmouseover="this.src='../image/menu/subMenu0204Over.gif'" onmouseout="this.src='../image/menu/subMenu0204Out.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/menu/subMenu0205Out.gif" alt="�ϰ�����" border="0"  onmouseover="this.src='../image/menu/subMenu0205Over.gif'" onmouseout="this.src='../image/menu/subMenu0205Out.gif'" /></a>
		</div>		</td>
		<td class="topRight">
			<div class="time">2009.09.20(��) 12:20:30</div>
			<div class="quickLink">
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnResetOut.gif" alt="�ʱ�ȭ" border="0"  onmouseover="this.src='../image/button/btnResetOver.gif'" onmouseout="this.src='../image/button/btnResetOut.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnSoundOffOut.gif" alt="�������" border="0"  onmouseover="this.src='../image/button/btnSoundOffOver.gif'" onmouseout="this.src='../image/button/btnSoundOffOut.gif'" /></a>
				<!-- <a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnSoundOnOut.gif" alt="�����ѱ�" border="0"  onmouseover="this.src='../image/button/btnSoundOnOver.gif'" onmouseout="this.src='../image/button/btnSoundOnOut.gif'" /></a> -->
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnPopupCloseOut.gif" alt="�˾��ݱ�" border="0"  onmouseover="this.src='../image/button/btnPopupCloseOver.gif'" onmouseout="this.src='../image/button/btnPopupCloseOut.gif'" /></a>
				<a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnPopupOffOut.gif" alt="�˾�����" border="0"  onmouseover="this.src='../image/button/btnPopupOffOver.gif'" onmouseout="this.src='../image/button/btnPopupOffOut.gif'" /></a>
				<!-- <a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnPopupOnOut.gif" alt="�˾��ѱ�" border="0"  onmouseover="this.src='../image/button/btnPopupOnOver.gif'" onmouseout="this.src='../image/button/btnPopupOnOut.gif'" /></a> -->
			</div>
		</td>
	  </tr>
	</table>	
	<!-- top include Section end -->
<!------------------------------ ��� ���� end ------------------------------>


<!------------------------------ �߰� ���� start ------------------------------>	
<!-- ���γ��� ���� **************************** -->
	<div class="mainCont">
	<!-- ������ ����͸� ���� **************************** -->	
		<div class="moniBox02"><div class="moniBox04"><div class="moniBox05"><div class="moniBox07">
		<div class="moniBox03"><div class="moniBox08"><div class="moniBox06"><div class="moniBox01">
			<table>
			  <tr valign="top">
				<td>
					<!-- ������ ����͸� ���� -->
					<div class="channelBoxBg01"><div class="channelBoxRight01"><div class="channelBoxLeft">
						<!-- Ÿ��Ʋ -->
						<div class="channelTitleBg"><img src="<%=request.getContextPath()%>/image/label/channelTitle03.gif" /></div>
						<!-- ��� 4�� ���� -->
						<table>
						  <tr>
							<td width="25%">
							<!-- ���01 -->
								<div id="hostCommDisplay1" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num1.gif" /></div>
									<div id="adapterCommDisplay1" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallYellow.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instCommLine1" class="instanceLine">
										<div id="instCommDisplay1" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" />
											<img src="<%=request.getContextPath()%>/image/node/ins2Red.gif"  />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� --><!-- 70�̻������/90�̻��� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuCommBar1" class="barYellow" style="width:28px"></div></td>
											<td id="cpuCommVal1" class="textSystem">70</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryCommBar1" class="barRed" style="width:36px"></div></td>
											<td id="memoryCommVal1" class="textSystem">90</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskCommBar1" class="barGreen" style="width:12px"></div></td>
											<td id="diskCommVal1" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procCommVal1" class="conCountBox">21,231,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���02 -->
								<div id="hostCommDisplay2" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num2.gif" /></div>
									<div id="adapterCommDisplay2" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallRed.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instCommLine2" class="instanceLine">
										<div id="instCommDisplay2" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Red.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Red.gif"  />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuCommBar2" class="barGreen" style="width:24px"></div></td>
											<td id="cpuCommVal2" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryCommBar2" class="barGreen" style="width:20px"></div></td>
											<td id="memoryCommVal2" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskCommBar2" class="barGreen" style="width:12px"></div></td>
											<td id="diskCommVal2" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procCommVal2" class="conCountBox02">123,341,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���03 -->
								<div id="hostCommDisplay3" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num3.gif" /></div>
									<div id="adapterCommDisplay3" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instCommLine3" class="instanceLine">
										<div id="instCommDisplay3" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuCommBar3" class="barGreen" style="width:24px"></div></td>
											<td id="cpuCommVal3" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryCommBar3" class="barGreen" style="width:20px"></div></td>
											<td id="memoryCommVal3" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskCommBar3" class="barGreen" style="width:12px"></div></td>
											<td id="diskCommVal3" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procCommVal3" class="conCountBox">1,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���04 ��� �ٿ�� ǥ��-->
								<div id="hostCommDisplay4" class="nodeSDown">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num4Down.gif" /></div>
								</div>
							</td>
						  </tr>
						</table>
						<!-- ��� 4�� �� -->
					</div></div></div>
					<!-- ������ ����͸� �� -->			
				</td>
				<td>
					<!-- ��� ����͸� ���� -->
					<div class="channelBoxBg01"><div class="channelBoxRight01"><div class="channelBoxLeft">
						<!-- Ÿ��Ʋ -->
						<div class="channelTitleBg"><img src="<%=request.getContextPath()%>/image/label/channelTitle02.gif" /></div>
						<!-- ��� 4�� ���� -->
						<table>
						  <tr>
							<td width="25%">
							<!-- ���01 -->
								<div id="hostOutDisplay1" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num1.gif" /></div>
									<div id="adapterOutDisplay1" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instOutLine1" class="instanceLine2">
										<div id="instOutDisplay1" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Red.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins6Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins7Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins8Green.gif"
											/><img src="<%=request.getContextPath()%>/image/node/ins9Green.gif"  />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� --><!-- 70�̻������/90�̻��� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuOutBar1" class="barGreen" style="width:24px"></div></td>
											<td id="cpuOutVal1" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryOutBar1" class="barGreen" style="width:20px"></div></td>
											<td id="memoryOutVal1" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskOutBar1" class="barGreen" style="width:12px"></div></td>
											<td id="diskOutVal1" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procOutVal1" class="conCountBox">1,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���02 -->
								<div id="hostOutDisplay2" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num2.gif" /></div>
									<div id="adapterOutDisplay2" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instOutLine2" class="instanceLine2">
										<div id="instOutDisplay2" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins6Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins7Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins8Green.gif"
											/><img src="<%=request.getContextPath()%>/image/node/ins9Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuOutBar2" class="barGreen" style="width:24px"></div></td>
											<td id="cpuOutVal2" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryOutBar2" class="barGreen" style="width:20px"></div></td>
											<td id="memoryOutVal2" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskOutBar2" class="barGreen" style="width:12px"></div></td>
											<td id="diskOutVal2" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procOutVal2" class="conCountBox">341,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���03 -->
								<div id="hostOutDisplay3" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num3.gif" /></div>
									<div id="adapterOutDisplay3" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instOutLine3" class="instanceLine2">
										<div id="instOutDisplay3" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins6Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins7Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins8Green.gif"
											/><img src="<%=request.getContextPath()%>/image/node/ins9Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuOutBar3" class="barGreen" style="width:24px"></div></td>
											<td id="cpuOutVal3" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryOutBar3" class="barGreen" style="width:20px"></div></td>
											<td id="memoryOutVal3" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskOutBar3" class="barGreen" style="width:12px"></div></td>
											<td id="diskOutVal3" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procOutVal3" class="conCountBox">1,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���04 -->
								<div id="hostOutDisplay4" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num4.gif" /></div>
									<div id="adapterOutDisplay4" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instOutLine4" class="instanceLine2">
										<div id="instOutDisplay4" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins6Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins7Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins8Green.gif"
											/><img src="<%=request.getContextPath()%>/image/node/ins9Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuOutBar4" class="barGreen" style="width:24px"></div></td>
											<td id="cpuOutVal4" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryOutBar4" class="barGreen" style="width:20px"></div></td>
											<td id="memoryOutVal4" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskOutBar4" class="barGreen" style="width:12px"></div></td>
											<td id="diskOutVal4" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procOutVal4" class="conCountBox">1,234</div>
								</div>
							</td>
						  </tr>
						</table>
						<!-- ��� 4�� �� -->
					</div></div></div>
					<!-- ��� ����͸� �� -->
				</td>
			  </tr>
			  <tr valign="top">
				<td>
					<!-- ���� ����͸� ���� -->
					<div class="channelBoxBg01"><div class="channelBoxRight01"><div class="channelBoxLeft">
						<!-- Ÿ��Ʋ -->
						<div class="channelTitleBg"><img src="<%=request.getContextPath()%>/image/label/channelTitle01.gif" /></div>
						<!-- ��� 4�� ���� -->
						<table>
						  <tr>
							<td width="25%">
							<!-- ���01 -->
								<div id="hostInDisplay1" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num1.gif" /></div>
									<div id="adapterInDisplay1" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instInLine1" class="instanceLine"><!-- �ν��Ͻ��� 6�� �̻��̸� class���� instanceLine2�ٲ��. -->
										<div id="instInDisplay1" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif"
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� --><!-- 70�̻������/90�̻��� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuInBar1" class="barGreen" style="width:24px"></div></td>
											<td id="cpuInVal1" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryInBar1" class="barGreen" style="width:20px"></div></td>
											<td id="memoryInVal1" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskInBar1" class="barGreen" style="width:12px"></div></td>
											<td id="diskInVal1" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procInVal1" class="conCountBox">21,231,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���02 -->
								<div id="hostInDisplay2" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num2.gif" /></div>
									<div id="adapterInDisplay2" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instInLine2" class="instanceLine">
										<div id="instInDisplay2" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif"
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuInBar2" class="barGreen" style="width:24px"></div></td>
											<td id="cpuInVal2" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryInBar2" class="barGreen" style="width:20px"></div></td>
											<td id="memoryInVal2" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskInBar2" class="barGreen" style="width:12px"></div></td>
											<td id="diskInVal2" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procInVal2" class="conCountBox02">123,341,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���03 -->
								<div id="hostInDisplay3" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num3.gif" /></div>
									<div id="adapterInDisplay3" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instInLine3" class="instanceLine">
										<div id="instInDisplay3" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuInBar3" class="barGreen" style="width:24px"></div></td>
											<td id="cpuInVal3" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryInBar3" class="barGreen" style="width:20px"></div></td>
											<td id="memoryInVal3" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskInBar3" class="barGreen" style="width:12px"></div></td>
											<td id="diskInVal3" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procInVal3" class="conCountBox">1,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���04 -->
								<div id="hostInDisplay4" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num4.gif" /></div>
									<div id="adapterInDisplay4" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instInLine4" class="instanceLine">
										<div id="instInDisplay4" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins3Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins4Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins5Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuInBar4" class="barGreen" style="width:24px"></div></td>
											<td id="cpuInVal4" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryInBar4" class="barGreen" style="width:20px"></div></td>
											<td id="memoryInVal4" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskInBar4" class="barGreen" style="width:12px"></div></td>
											<td id="diskInVal4" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procInVal4" class="conCountBox">1,234</div>
								</div>
							</td>
						  </tr>
						</table>
						<!-- ��� 4�� �� -->
					</div></div></div>
					<!-- ���� ����͸� �� -->
				</td>
				<td>
					<!-- DMZ/�ϰ����� ����͸� ���� -->
					<div class="channelBoxBg01"><div class="channelBoxRight02"><div class="channelBoxLeft">
						<!-- Ÿ��Ʋ -->
						<div class="channelTitleBg"><img src="<%=request.getContextPath()%>/image/label/channelTitle04.gif" /></div>
						<!-- ��� 4�� ���� -->
						<table>
						  <tr>
							<td width="25%">
							<!-- ���01 -->
								<div id="hostDmzDisplay1" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num1.gif" /></div>
									<div id="adapterDmzDisplay1" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instDmzLine1" class="instanceLine">
										<div id="instDmzDisplay1" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif"  />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� --><!-- 70�̻������/90�̻��� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuDmzBar1" class="barGreen" style="width:24px"></div></td>
											<td id="cpuDmzVal1" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryDmzBar1" class="barGreen" style="width:20px"></div></td>
											<td id="memoryDmzVal1" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskDmzBar1" class="barGreen" style="width:12px"></div></td>
											<td id="diskDmzVal1" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procDmzVal1" class="conCountBox">21,231,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���02 -->
								<div id="hostDmzDisplay2" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num2.gif" /></div>
									<div id="adapterDmzDisplay2" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instDmzLine2" class="instanceLine">
										<div id="instDmzDisplay2" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif"  />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuDmzBar2" class="barGreen" style="width:24px"></div></td>
											<td id="cpuDmzVal2" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryDmzBar2" class="barGreen" style="width:20px"></div></td>
											<td id="memoryDmzVal2" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskDmzBar2" class="barGreen" style="width:12px"></div></td>
											<td id="diskDmzVal2" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procDmzVal2" class="conCountBox02">123,341,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���01 -->
								<div id="hostBatchDisplay1" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num1.gif" /></div>
									<div id="adapterBatchDisplay1" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instBatchLine1" class="instanceLine">
										<div id="instBatchDisplay1" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuBatchBar1" class="barGreen" style="width:24px"></div></td>
											<td id="cpuBatchVal1" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryBatchBar1" class="barGreen" style="width:20px"></div></td>
											<td id="memoryBatchVal1" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskBatchBar1" class="barGreen" style="width:12px"></div></td>
											<td id="diskBatchVal1" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procBatchVal1" class="conCountBox">1,234</div>
								</div>
							</td>
							<td width="25%">
							<!-- ���02 -->
								<div id="hostBatchDisplay2" class="nodeS">
									<div class="nodeNo"><!-- Node no --><img src="<%=request.getContextPath()%>/image/node/num2.gif" /></div>
									<div id="adapterBatchDisplay2" class="adapterBox">
										<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif" /><!-- adapter ����ǥ�� -->
									</div>
									<!-- �ν��Ͻ� ���� -->
									<div class="instanceArea">
									<div id="instBatchLine2" class="instanceLine">
										<div id="instBatchDisplay2" class="instanceBox">
											<img src="<%=request.getContextPath()%>/image/node/ins1Green.gif" 
											/><img src="<%=request.getContextPath()%>/image/node/ins2Green.gif" />
										</div>
									</div></div>

									<!-- ���ҽ� ���� -->
									<div class="systemBox"><!-- ���� width �� 4*%�� 10�� ���� -->
										<table width="60px">
										  <tr>
											<td class="barBg"><div id="cpuBatchBar2" class="barGreen" style="width:24px"></div></td>
											<td id="cpuBatchVal2" class="textSystem">67</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="memoryBatchBar2" class="barGreen" style="width:20px"></div></td>
											<td id="memoryBatchVal2" class="textSystem">53</td>
										  </tr>
										  <tr>
											<td class="barBg"><div id="diskBatchBar2" class="barGreen" style="width:12px"></div></td>
											<td id="diskBatchVal2" class="textSystem">30</td>
										  </tr>
										</table>
									</div>
									<!-- ���Ӽ� -->
									<div id="procBatchVal2" class="conCountBox">1,234</div>
								</div>
							</td>
						  </tr>
						</table>
						<!-- ��� 4�� �� -->
					</div></div></div>
					<!-- DMZ/�ϰ����� ����͸� �� -->
				</td>
			  </tr>
			</table>
		</div></div></div></div>
		</div></div></div></div>
	<!-- ������ ����͸� �� **************************** -->	
	<!-- �ŷ�ó�� ��Ȳ ���� **************************** -->	
		<div class="floatLeft tranBox">
			<div class="tableBoxBg01"><div class="tableBox02"><div class="tableBox04"><div class="tableBox05"><div class="tableBox07">
			<div class="tableBox031"><div class="tableBox081"><div class="tableBox06"><div class="tableBox01">
				<!-- Ÿ��Ʋ -->
				<div class="floatLeft">
					<img src="<%=request.getContextPath()%>/image/bullet/titleIcon01.jpg" align="absmiddle" /> &nbsp;
					<img src="<%=request.getContextPath()%>/image/label/title01.jpg" alt="�ŷ�ó����Ȳ" align="absmiddle" />
				</div>
				<span class="floatRight"><a href="#" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnViewBig.gif" alt="ũ�Ժ���" align="absmiddle" /></a></span>
				
				<!-- ���̺� -->
				<table class="table01">
				  <tr>
					<th width="90"><img src="<%=request.getContextPath()%>/image/label/tableTitle0101.gif" align="absmiddle" /></th>
					<th width="130"><img src="<%=request.getContextPath()%>/image/label/tableTitle0102.gif" align="absmiddle" /></th>
					<th width="110"><img src="<%=request.getContextPath()%>/image/label/tableTitle0103.gif" align="absmiddle" /></th>
					<th><img src="<%=request.getContextPath()%>/image/label/tableTitle0104.gif" align="absmiddle" /></th>
					<th width="100"><img src="<%=request.getContextPath()%>/image/label/tableTitle0105.gif" align="absmiddle" /></th>
					<th width="100"><img src="<%=request.getContextPath()%>/image/label/tableTitle0106.gif" align="absmiddle" /></th>
					<th width="90"><img src="<%=request.getContextPath()%>/image/label/tableTitle0107.gif" align="absmiddle" /></th>
				  </tr>
				  <tr>
					<td align="center"><span class="textGroup">����</span></td>
					<td align="right">22,222</td>
					<td align="right">222</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
				  </tr>
				  <tr class="second">
					<td align="center"><span class="textGroup">���</td>
					<td align="right">22,222</td>
					<td align="right">222</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
				  </tr>
				  <tr>
					<td align="center"><span class="textGroup">������</td>
					<td align="right">22,222</td>
					<td align="right">222</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
				  </tr>
				  <tr class="second">
					<td align="center"><span class="textGroup">DMZ</td>
					<td align="right">22,222</td>
					<td align="right">222</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
					<td align="right">0</td>
				  </tr>
				  <tr>
					<th class="sum"><img src="<%=request.getContextPath()%>/image/label/tableTitle0109.gif" align="absmiddle" /></th>
					<th class="sumRight">88,888</th>
					<th class="sumRight">888</th>
					<th class="sumRight">0</th>
					<th class="sumRight">0</th>
					<th class="sumRight">0</th>
					<th class="sumRight">0</th>
				  </tr>
				  <tr class="second">
					<td align="center"><span class="textGroup">�ϰ�����</td>
					<td align="right">
						<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0111.gif" align="absmiddle" /></span>
						<span class="floatRight">100</span>
					</td>
					<td align="right">
						<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0112.gif" align="absmiddle" /></span>
						<span class="floatRight">100</span>
					</td>
					<td align="right">
						<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0113.gif" align="absmiddle" /></span>
						<span class="floatRight">100</span>
					</td>
					<td align="right">
						<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0114.gif" align="absmiddle" /></span>
						<span class="floatRight">100</span>
					</td>
					<td align="right">
						<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0115.gif" align="absmiddle" /></span>
						<span class="floatRight">100</span>
					</td>
					<td align="right">
						<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0116.gif" align="absmiddle" /></span>
						<span class="floatRight">100</span>
					</td>
				  </tr>
			  </table>
			</div></div></div></div></div>
			</div></div></div></div>
		</div>
	<!-- �ŷ�ó�� ��Ȳ �� **************************** -->	
			
	<!-- peak day ���� **************************** -->	
		<div class="floatRight peakdayBox">
			<div class="tableBoxBg02"><div class="tableBox021"><div class="tableBox04"><div class="tableBox05"><div class="tableBox07">
			<div class="tableBox03"><div class="tableBox08"><div class="tableBox061"><div class="tableBox011">
				<!-- Ÿ��Ʋ -->
				<div>
					<img src="<%=request.getContextPath()%>/image/bullet/titleIcon02.jpg" align="absmiddle" /> &nbsp;
					<img src="<%=request.getContextPath()%>/image/label/title02.jpg" alt="Peak Day" align="absmiddle" />
				</div>
				<!-- ���̺� -->
				<table class="table01" style="margin-bottom:29px">
				  <tr>
					<th width="65"><img src="<%=request.getContextPath()%>/image/label/tableTitle0201.gif" align="absmiddle" /></th>
					<th width="90"><img src="<%=request.getContextPath()%>/image/label/tableTitle0202.gif" align="absmiddle" /></th>
					<th><img src="<%=request.getContextPath()%>/image/label/tableTitle0203.gif" align="absmiddle" /></th>
					<th width="80"><img src="<%=request.getContextPath()%>/image/label/tableTitle0204.gif" align="absmiddle" /></th>
				  </tr>
				  <tr>
					<td align="center">����</td>
					<td align="center">2009.03.31</td>
					<td align="right">222,222</td>
					<td align="right">222</td>
				  </tr>
				  <tr class="second">
					<td align="center">���</td>
					<td align="center">2009.03.31</td>
					<td align="right">222,222</td>
					<td align="right">222</td>
				  </tr>
				  <tr>
					<td align="center">������</td>
					<td align="center">2009.03.31</td>
					<td align="right">222,222</td>
					<td align="right">222</td>
				  </tr>
				  <tr class="second">
					<td align="center">DMZ</td>
					<td align="center">2009.03.31</td>
					<td align="right">222,222</td>
					<td align="right">222</td>
				  </tr>
				  <tr>
					<td align="center">�ϰ�����</td>
					<td align="center">2009.03.31</td>
					<td align="right">222,222</td>
					<td align="right">222</td>
				  </tr>
			  </table>
			</div></div></div></div></div>
			</div></div></div></div>
		</div>
	<!-- peak day �� **************************** -->
	<!-- ����뺸��Ȳ ���� **************************** -->	
		<div class="obstacleBox">
			<div class="tableBoxBg01"><div class="tableBox02"><div class="tableBox04"><div class="tableBox05"><div class="tableBox07">
			<div class="tableBox03"><div class="tableBox08"><div class="tableBox06"><div class="tableBox01">
				<!-- Ÿ��Ʋ -->
				<div>
					<img src="<%=request.getContextPath()%>/image/bullet/titleIcon01.jpg" align="absmiddle" /> &nbsp;
					<img src="<%=request.getContextPath()%>/image/label/title03.jpg" alt="����뺸��Ȳ" align="absmiddle" />
				</div>
				<!-- ���̺� -->
				<table class="table01">
				  <tr>
				    <th width="90"><img src="<%=request.getContextPath()%>/image/label/tableTitle0301.gif" align="absmiddle" /></th>
					<th width="130"><img src="<%=request.getContextPath()%>/image/label/tableTitle0302.gif" align="absmiddle" /></th>
					<th width="110"><img src="<%=request.getContextPath()%>/image/label/tableTitle0303.gif" align="absmiddle" /></th>
					<th><img src="<%=request.getContextPath()%>/image/label/tableTitle0304.gif" align="absmiddle" /></th>
				  </tr>
				  <tr>
				    <td align="center">����</td>
					<td align="center">TSEAI_i11</td>
					<td align="center">BEAIB07003</td>
					<td>[2 Node][5 Inst[SI]]������ ���� ������ ������ Ÿ�Ӿƿ�.</td>
				  </tr>
				  <tr class="second">
				    <td align="center">����</td>
					<td align="center">TSEAI_i11</td>
					<td align="center">BEAIB07003</td>
					<td>[2 Node][5 Inst[SI]]������ ���� ������ ������ Ÿ�Ӿƿ�.</td>
				  </tr>
				  <tr>
				    <td align="center">����</td>
					<td align="center">TSEAI_i11</td>
					<td align="center">BEAIB07003</td>
					<td>[2 Node][5 Inst[SI]]������ ���� ������ ������ Ÿ�Ӿƿ�.</td>
				  </tr>
			  </table>
			</div></div></div></div></div>
			</div></div></div></div>
		</div>
	<!-- ����뺸��Ȳ �� **************************** -->	
	</div>
<!-- ���γ��� �� **************************** -->
<!------------------------------ �߰� ���� end ------------------------------>

<!------------------------------ �ϴ� ���� start ------------------------------>
	<!-- btm include Section Start -->
	<!-- btm include Section end->	
<!------------------------------ �ϴ� ���� end ------------------------------>

<!-- �˾�  ���� **************************** -->	
<!-- �ý��ۻ�Ȳ�� ���� -->
<!-- �ý��ۻ�Ȳ�� �� -->

<!-- ����ͻ�Ȳ�� ���� -->
<!-- ����ͻ�Ȳ�� �� -->
<!-- ����뺸 ��Ȳ�� ���� -->
<div id="obstaclePopup" style="display:; width:278px; height:60px; top:170px; left:365px; position:absolute; z-index:700; visibility: visible;"><!-- ��� ���� 145px -->
	<div class="popBgBox02"><div class="popBgBox04"><div class="popBgBox05"><div class="popBgBox07">
	<div class="popBgBox03"><div class="popBgBox08"><div class="popBgBox06"><div class="popBgBox01">
		<div class="boxRedTitle">
			<div class="floatLeft">
				<!-- ������ ���â�϶� -->
				&nbsp;&nbsp;<img src="<%=request.getContextPath()%>/image/popup/iconTitleRed.gif" />&nbsp;
				<span>���� 1�� 2���ν��Ͻ�</span>
			</div>
			<div class="floatRight">
				<a href="javascript:showAlarmMsg(false);" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/popup/btnclose02.gif" alt="�ݱ�" style="margin-top:3px"/></a>
			</div>
		</div>
		<div class="boxRed"><div class="boxRedBg">
			<span>
				- ���������Դϴ�.<br />
				- ���������Դϴ�.<br />
				- ���������Դϴ�.<br />
				- ���������Դϴ�.
			</span>
		</div></div>
	</div></div></div></div>
	</div></div></div></div>
</div>
<!-- ����뺸 �� -->
<!-- �˾� �� **************************** -->


<script>
	reqAjaxComm = createAjaxRequest();
	reqAjaxOut  = createAjaxRequest();
	reqAjaxIn   = createAjaxRequest();
	reqAjaxDmz  = createAjaxRequest();
	reqAjaxBatch= createAjaxRequest();
	
	setTimeout("requestData();", 5000);
</script>
	
</body>
<!--
****************************************************************************
* body �ڵ� end
****************************************************************************
-->
</html>