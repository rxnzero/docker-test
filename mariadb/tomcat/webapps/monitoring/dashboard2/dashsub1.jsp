<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="com.eactive.eai.rms.common.context.MonitoringContext"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");	
	request.setCharacterEncoding("euc-kr");
	
	String NEW_TITLE = (String) session.getAttribute(MonitoringContext.NEW_DASHBOARD_TITLE);
	//String batchUrl  = (String) session.getAttribute(MonitoringContext.RMS_BATCH_MENU_URL);	
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


function clickCloseAlarmMsg( idx ) {
	showAlarmMsg(idx, false, '', '' );
}
function showAlarmMsg(idx, show, msg1, msg2 ) {

	if( isPopupOn == false && show == true ) {
		return ;
	}

	var obj = document.getElementById('obstaclePopup' + idx);	
	if( show == true ) {
		obj.innerHTML = getAlarmMsgHtml(idx);
		
		var objTitle = document.getElementById('popupMsgTitle' + idx);
		var objBody  = document.getElementById('popupMsgBody' + idx);
		
		objTitle.innerHTML = msg1 ;
		objBody.innerHTML  = msg2 ;
	
		objTitle = null ;
		objBody  = null ;	
	}

	if( show == true ) {
		obj.style.display = "" ;
	} else {
		obj.style.display = "none" ;
	}
	
	obj = null ;
}

function alarmSound(tp) {
	if( isSoundOn == false ) {
		return ;
	}

	if ( tp == 'alert' ) {
		document.player.stop();
		document.player.play();
	}
	
	//setTimeout("stopSound('" + tp + "');", 3000);
}

//function stopSound(tp) {
//	if( tp == 'alert' ) {
//		document.player.stop();
//	}
//}

function MM_showSubMenu(l) {
	if( l == 'Layer1' ) {
		MM_showHideLayers('Layer1','','show');
		MM_showHideLayers('Layer2','','hide');
		MM_showHideLayers('Layer3','','hide');
	} else if( l == 'Layer2' ) {
		MM_showHideLayers('Layer1','','hide');
		MM_showHideLayers('Layer2','','show');
		MM_showHideLayers('Layer3','','hide');	
	} else if( l == 'Layer3' ) {
		MM_showHideLayers('Layer1','','hide');
		MM_showHideLayers('Layer2','','hide');
		MM_showHideLayers('Layer3','','show');		
	}
}



var isSoundOn = true ;
var isPopupOn = true ;


var reqAjaxHost = null ;
var reqAjaxTran = null ;
var reqAjaxSms  = null ;
var reqAjaxSmsInit = null ;
var reqAjaxSmsErr= null ;

var arrHost     = null ;

var hideMenuTimeoutID = -1 ;

var connectionError = "0";

var serviceId     = '<%=request.getParameter("service")%>' ;


var autoSmsMode = false ;
function setSmsErrMode() {
	var obj = document.getElementById("smsModeImage");
	
	if( autoSmsMode == true ) {
		obj.src = "../image/button/btnPassive01.gif" ;
		autoSmsMode = false ;
	} else {
		obj.src = "../image/button/btnPassive02.gif" ;
		autoSmsMode = true ;
	}
} 

function popupError( type, id ) {


	var svc = serviceId;
	
	var logTime = getThisTime();

	var stats = 'toolbar=no'
	          + ',location=no'
	          + ',directories=no'
	          + ',status=no'
	          + ',menubar=no'
	          + ',dependent=yes'
	          + ',scrollbars=no'
	          + ',resizable=yes'
	          + ',width=1070'
	          + ',height=650' ;
	          //+ ',top=100'
	          //+ ',left=100'
	          
	

	var win = window.open("<%=request.getContextPath()%>/dashboard2/dashpopup.jsp"
	                      + "?logTime=" + logTime
	                      + "&domainType=" + svc
	                      + "&errorType=" + type
	                      + "&nodeIndex=" + id
	                      + "&subPage=yes"   , 
	                       "rmsERROR", stats ); 
}

function checkConnection() {
	if( connectionError != "0" ) {
		alert( '서버와의 연결이 종료되어 현재창을 닫습니다.( error code=' + connectionError + ' ' + getDummyTime() + ' )' );
		parent.self.close();
	}
}

function getAjaxObject( type ) {
	if( type == "Host" ) {
		return reqAjaxHost;
	} else if( type == "Tran" ) {
		return reqAjaxTran;
	} else if( type == "Sms" ) {
		return reqAjaxSms;
	} else if( type == "SmsErr" ) {
		return reqAjaxSmsErr;
	} else if( type == "SmsInit" ) {
		return reqAjaxSmsInit;
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
	var obj = document.getElementById("mainTitleImage");
	if( obj ) {
		var imgSrc = "<%=request.getContextPath()%>/image/label/" ;
		if( serviceId == 'FEP' ) {
			imgSrc += "mainTitle0102.gif" ; // 대외
		} else if( serviceId == 'EAI' ) {
			imgSrc += "mainTitle0101.gif" ; // 내부
		} else {
			obj = null ;
			return ;
		}
		
		obj.src = imgSrc ;
		obj = null ;
	}
}


function getAjaxData( type ) {
	var reqAjax = getAjaxObject( type );
	try {	
		if( reqAjax.readyState == 4 ) {
			if( reqAjax.status == 200 ) {
				return reqAjax.responseText ;
			} else {
				// 12029 : ERROR_INTERNET_CANNOT_CONNECT
				if( 12029 == reqAjax.status ) {
					connectionError = "12029" ;
				}			
			}
		} else {
		}
	} catch(e) {
		alert(e);
	} finally {
		reqAjax = null ;
	}
	return null ;
}

function requestServerInfo( ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=serverinfo" ;	
	var url = urlBase + "&service=" + serviceId ; //+ getDummyTime();
	var reqAjax = getAjaxObject( "Host" );
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateServerInfo ;
	reqAjax.send(null);
	
	reqAjax = null;
}

function requestHostInfo( ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=hostinfo" ;
	var url     = urlBase + "&service=" + serviceId ; //+ getDummyTime();
	var reqAjax = getAjaxObject( "Host" );	
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateHostInfo ;
	reqAjax.send(null);
	
	reqAjax = null ;	
}

function requestTranInfo( ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=sub&type=traninfo" ;
	var url     = urlBase + "&service=" + serviceId ; //+ getDummyTime();
	var reqAjax = getAjaxObject( "Tran" );
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateTranInfo ;
	reqAjax.send(null);
	
	reqAjax = null;
}

function requestSmsInfo( ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=sub&type=smsinfo" ;
	var url     = urlBase + "&service=" + serviceId ; //+ getDummyTime();
	var reqAjax = getAjaxObject( "Sms" );	
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateSmsInfo ;
	reqAjax.send(null);
	
	reqAjax = null;
}

function requestSmsInit( t ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=sub&type=smsinit" ;
	var url     = urlBase + "&initTime=" + t ;
	var reqAjax = getAjaxObject( "SmsInit");
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateSmsInit ;
	reqAjax.send(null);
	
	reqAjax = null ;
}

function requestSmsErrInfo( smstime ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=sub&type=smserr" ;
	var url     = urlBase + "&service=" + serviceId + "&smstime=" + escape(smstime) ; //+ getDummyTime();
	var reqAjax = getAjaxObject( "SmsErr" );	
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateSmsErrInfo ;
	reqAjax.send(null);
	
	reqAjax = null;
}


function updateServerInfo() {
	var msg      = getAjaxData("Host");	
	if( null != msg ) {
		var lines = msg.split(";");
		arrHost = checkHostNames(lines);
		
		var hostMax = 4 ;
		if( serviceId == 'BATCH' ) {
			hostMax = 2 ;
		}
		
		for( var i = 0 ; i < hostMax ; i++ ) {
			if( i < arrHost.length ) {
				
				setHostBasic(i+1);
				var arrInst = checkInstNames(lines, arrHost[i]);
				setInstBasic( i+1, arrInst);
			} else {
				setHostBasicEmpty(i+1);
			}
		}
				
		startMonitoring( );
	}	
}

/////////////////////////////
/////////////////////////////


function updateHostInfo() {
	var msg = getAjaxData("Host");
	if( null != msg ) {
		var lines = msg.split(";");
		for( var i = 0 ; i < lines.length ; i++ ) {
			var step = i+1;
			var infos = lines[i].split(",");
			// hostname,isDown,adapter,inst000000,cpu,memory,disk,proc;	
			
			// telnet 은 되는데 was가 down 되었을 때를 생각해보라.
			if( infos.length > 13 ) {
				if( "1" == infos[1] ) {
					setHostBasic(step);

					setAdapterStatus(step, infos[2], infos[3], infos[4], infos[5], infos[6], infos[7], infos[8] );
					
					setInstStatus(step, infos[9]);
					
					setCpuStatus(step, infos[10]);
					
					setMemoryStatus(step, infos[11]);
					
					setDiskStatus(step, infos[12]);
					
					setProcStatus(step, infos[13]);
				} else {
					setHostBasicDown(step);
				}
			}
		}
	}

}

function updateTranInfo() {
	var msg      = getAjaxData("Tran");
	var tmpVal   = 0 ;
	if( null != msg ) {
		
		//alert( msg );
		
		var totalProc2 = 0 ;
		var totalTimeout2 = 0 ;
		var totalError2 = 0 ;
		
		var lines = msg.split(";");
		for( var i = 0 ; i < lines.length ; i++ ) {
			var step = i+1;
			var infos = lines[i].split(",");
			// host,proc,timeout,error
			
			// 거래건수
			if( infos.length > 3 ) {
				var tableObj1 = getTranCell(step, 1);
				var tableObj2 = getTranCell(step, 2);
				var old       = tableObj1.innerText ;
				var beforeVal = commanum(old) ;
				
				if( beforeVal == "0" || beforeVal == "" ) {
					tmpVal = 0 ;
				} else {
					tmpVal = commanum(infos[1]) - beforeVal ;
				}
				
				if( i == 4 ) {
					tableObj1 = null;
					tableObj2 = null;
					tmpVal = '' + totalProc2 ;
					rollingScore("tranTable" + step + 1, infos[1], old);
					rollingScoreArrow("tranTable" + step + 2, tmpVal, '0');				
				} else {
					if( tmpVal < 0 ) tmpVal = 0 ;
					totalProc2 += tmpVal ;				
					tableObj1.innerText = commify( infos[1] );
					//tableObj2.innerText = tmpVal ;
					setArrowTextBody( tableObj2, '' + tmpVal );
					tableObj1 = null ;
					tableObj2 = null ;
				}
				
				// 타임아웃
				tableObj1 = getTranCell(step, 3);
				tableObj2 = getTranCell(step, 4);
				old       = tableObj1.innerText ;
				beforeVal = commanum(old) ;
				
				if( beforeVal == "0" || beforeVal == "" ) {
					tmpVal = 0 ;
				} else {
					tmpVal = commanum(infos[2]) - beforeVal ;
				}

				if( i == 4 ) {
					tableObj1 = null ;
					tableObj2 = null ;
					tmpVal = '' + totalTimeout2 ;
					rollingScore("tranTable" + step + 3, infos[2], old);
					rollingScoreArrow("tranTable" + step + 4, '' + tmpVal, '0');				
				} else {
					if( tmpVal < 0 ) tmpVal = 0 ;
					totalTimeout2 += tmpVal ;
					tableObj1.innerText = commify( infos[2] );
					//tableObj2.innerText = tmpVal ;
					setArrowTextBody( tableObj2, '' + tmpVal );
					tableObj1 = null ;
					tableObj2 = null ;
				}


				// 에러
				tableObj1 = getTranCell(step, 5);
				tableObj2 = getTranCell(step, 6);
				old       = tableObj1.innerText ;
				beforeVal = commanum(old) ;
				
				if( beforeVal == "0" || beforeVal == "" ) {
					tmpVal = 0 ;
				} else {
					tmpVal = commanum(infos[3]) - beforeVal ;
				}
				
				if( i == 4 ) {
					tableObj1 = null ;
					tableObj2 = null ;
					tmpVal = '' + totalError2 ;
					rollingScore("tranTable" + step + 5, infos[3], old);
					rollingScoreArrow("tranTable" + step + 6, '' + tmpVal, '0');				
				} else {
					if( tmpVal < 0 ) tmpVal = 0 ;
					totalError2 += tmpVal ;	
					tableObj1.innerText = commify( infos[3] );
					//tableObj2.innerText = tmpVal ;
					setArrowTextBody( tableObj2, '' + tmpVal );
					tableObj1 = null ;
					tableObj2 = null ;
				}
				
				tableObj1 = null ;
				tableObj2 = null ;
			}			
		}
	}

}

function updateSmsInfo() {
	var msg = getAjaxData("Sms");
	if( null != msg ) {
		
		var lines = msg.split(";");
		var backTime = "" ;
		for( var i = 0 ; i < lines.length ; i++ ) {
			var step = i+1;
			var infos = lines[i].split(",");
			
			// svcId,inst,time,message
			if( infos.length > 2 ) {
				var tableObj1 = getSmsCell(step, 1);
				var tableObj2 = getSmsCell(step, 2);
				var tableObj3 = getSmsCell(step, 3);
				
				tableObj1.innerText = infos[1];
				tableObj2.innerText = infos[2];
				tableObj3.innerText = infos[3];
				tableObj1 = null ;
				tableObj2 = null ;
				tableObj3 = null ;
				
				if( i == 0  ) {
					backTime = infos[2] ;
				} 			
			} 
		}
		
		
		if( autoSmsMode ) {
			displaySmsInfo( backTime );	
		}
	}
}

function updateSmsInit( ) {
	for( var i = 1 ; i < 4 ; i++ ) {
		var tableObj1 = document.getElementById("smsTable" + i + 1);
		var tableObj2 = document.getElementById("smsTable" + i + 2);
		var tableObj3 = document.getElementById("smsTable" + i + 3);
		
		tableObj1.innerText = "" ;
		tableObj2.innerText = "" ;
		tableObj3.innerText = "" ;
		
		tableObj1 = null ;
		tableObj2 = null ;
		tableObj3 = null ;
	}
}

function clearSmsInfo( ) {

	// 1 row, 3 col => time
	var obj = document.getElementById("smsTable12");
	if( obj != null ) {
		requestSmsInit( obj.innerText );
	}
	obj = null ;
}

function updateSmsErrInfo( ) {
	var msg = getAjaxData("SmsErr");
	if( null != msg ) {

		var src = new Array(4);
		var seq = "";
		var pre_seq = "";
		var foudError = false;
		
		src[0] = '<img src="../image/node/blank.gif" width="44" height="35"/>';
		src[1] = '<img src="../image/node/blank.gif" width="44" height="35"/>';
		src[2] = '<img src="../image/node/blank.gif" width="44" height="35"/>';
		src[3] = '<img src="../image/node/blank.gif" width="44" height="35"/>';
		
		var lines = msg.split(";");
		
		for( var i = 0 ; i < lines.length ; i++ ) {
			
			//alert(lines[i]);
			
			if(lines[i].length == 0) continue; 
			
			var infos = lines[i].split(",");
			if( infos.length > 8 ) {			
				seq = infos[0];
				if(foudError == false && seq == '900') {
					seq = pre_seq;
				}
				else if(foudError == true && seq == '900') {
					break;
				}
				
				if(seq == '100') {
					src[0] = getArrowInfo( seq, infos[7] );
				}
				else if(seq == '200') {
					src[1] = getArrowInfo( seq, infos[7] );
				}
				else if(seq == '300') {
					src[2] = getArrowInfo( seq, infos[7] );
				}
				else if(seq == '400') {
					src[3] = getArrowInfo( seq, infos[7] );
				}
				
				//prcss,
				//기동어댑터명,업무그룹코드,업무그룹명,
				//수동어댑터명,수동업무그룹코드,수동업무명,
				//에러코드,에러메시지
				if( infos[7] != '' && infos[7].length > 3 ) {
					var errcode = infos[7].substring(0,3);
					if( "REC" == errcode ) {
						foudError = true;
						// set Table
						var tobj1 = document.getElementById("errinfo1");
						var tobj2 = document.getElementById("errinfo2");
						var tobj3 = document.getElementById("errinfo3");
						
						if(infos[3].length > 5) {
							tobj1.innerHTML = infos[3].substring(0,5);
						} else {
							tobj1.innerHTML = infos[3];
						}
						
						if(infos[8].length > 6) {
							var temp = infos[8] ;
							temp = temp.replace("[에러코드:", "");
							
							var iTemp = temp.indexOf(']');
							if( iTemp > 0 ) {
								temp = temp.substring(0,iTemp);
							}
							
							if( temp.length > 10 ) {
								temp = temp.substring(0,10);
							}
							
							tobj2.innerHTML = temp ;
						} else {
							tobj2.innerHTML = infos[8];
						}
						
						if(infos[6].length > 6) {
							tobj3.innerHTML = infos[6].substring(0,6);
						} else {
							tobj3.innerHTML = infos[6];
						}
						
						tobj1.title = infos[3];
						tobj2.title = infos[8];
						tobj3.title = infos[6];
						setInstanceTitle( infos[11], infos[12] );
					}
				}
			}
			pre_seq = seq;
			 
		}
		
		var obj = document.getElementById("processInfo");
		var imageSrc = "";
		imageSrc = src[0] + src[1] + src[3] + src[2];
		obj.innerHTML = imageSrc;
		obj = null ;
	}
}

function cleanSmsErrorDisplay() {
		setInstanceTitle(null,null);

		var src = new Array(4);
		src[0] = '<img src="../image/node/blank.gif" width="44" height="35"/>';
		src[1] = '<img src="../image/node/blank.gif" width="44" height="35"/>';
		src[2] = '<img src="../image/node/blank.gif" width="44" height="35"/>';
		src[3] = '<img src="../image/node/blank.gif" width="44" height="35"/>';

		var obj = document.getElementById("processInfo");
		var imageSrc = "";
		imageSrc = src[0] + src[1] + src[3] + src[2];
		obj.innerHTML = imageSrc;
		obj = null ;

		// set Table
		var tobj1 = document.getElementById("errinfo1");
		var tobj2 = document.getElementById("errinfo2");
		var tobj3 = document.getElementById("errinfo3");
		tobj1.innerHTML = '' ;
		tobj1.title = '' ;
		tobj2.innerHTML = '' ;
		tobj2.title = '' ;
		tobj3.innerHTML = '' ;
		tobj3.title = '' ;
		tobj1 = null ;
		tobj2 = null ;
		tobj3 = null ;
}

function getArrowInfo( seq, errcode ) {
	if( errcode != null && errcode.length > 3 ) {
		errcode = errcode.substring(0,3);
	}
	
	if( "REC" != errcode ) {
		return '<img src="../image/node/instanceArrow'+ seq + 'Green.gif" />' ;
	} else {
		return '<img src="../image/node/instanceArrow'+ seq + 'Red.gif" />' ;
	}
}

function displaySmsInfo( smstime ) {

	// 현재 화면을 지운다.
	cleanSmsErrorDisplay();
	
	// 포맷 문자 그대로 전송한다.
	requestSmsErrInfo( smstime );
}

function startMonitoring() {
	
	// interval 값을 5초 -> 10초로 수정 2010.02.16 ( 요청 )
	var interval = 10000 ;
	
	setInterval( 'requestHostInfo();', interval);
	setInterval( 'requestTranInfo();', interval);
	setInterval( 'requestSmsInfo();', interval);
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



// Draw basic host box image
function setHostBasic( id ) {
	var hostObj = getHostObject(id);
	if( hostObj != null ) {
		hostObj.className = "nodeB" ;
		hostObj.innerHTML = getHostHtml( id );
	}
	hostObj = null ;
}

// Draw empty host box image
function setHostBasicEmpty( id ) {
	var hostObj = getHostObject(id);
	if( hostObj != null ) {
		hostObj.className = "nodeBNone";
		hostObj.innerHTML = '';
	}
	hostObj = null ;
}

function setHostBasicDown( id ) {
	var hostObj = getHostObject(id);
	if( hostObj != null ) {
		hostObj.className = "nodeBDown";
		hostObj.innerHTML = '<div class="nodeNo"><img src="../image/node/noB' + id + 'Down.gif" /></div>';
	}
	hostObj = null ;
}

function getHostHtmlNoTuxedo(no) {
	var bodyHtml = '' ;
	
	bodyHtml +=		'<img src="../image/node/noB' + no + '.gif" class="nodeBNo" />';	
	bodyHtml +=  '<div id="' + getAdapterId(no) + '" class="adapterBBox02">';
	bodyHtml +=		'<img id="' + getAdapterTypeId("Total",no) + '" src="../image/node/adapterBBallYellow.gif" class="adapterBBall" />'; 
	bodyHtml +=		'<img id="' + getAdapterTypeId("SNA",no) + '" src="../image/node/adapter2BallGreen.gif" class="adapterBall" />'; 
	bodyHtml +=		'<img id="' + getAdapterTypeId("SOCKET",no) + '" src="../image/node/adapter2BallYellow.gif" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("MQ",no) + '" src="../image/node/adapter2BallRed.gif" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("HTTP",no) + '" src="../image/node/adapter2BallGreen.gif" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("EJB",no) + '" src="../image/node/adapter2BallGreen.gif" class="adapterBall" />';
	
	bodyHtml +=	'</div>';
	bodyHtml +=	'<div id="' + getInstId(no) + '" class="instanceAreaB">';
	bodyHtml +=	'</div>';
	bodyHtml +=	'<div class="systemBBox">';
	bodyHtml +=		'<table width="82px">';
	bodyHtml +=		  '<tr>';
	bodyHtml +=			'<td class="barBBg"><div id="' + getCpuBarId(no) + '" class="barBGreen" style="width:15px"></div></td>';
	bodyHtml +=			'<td id="' + getCpuId(no) + '" class="textSystemB">0</td>';
	bodyHtml +=		  '</tr>';
	bodyHtml +=		  '<tr>';
	bodyHtml +=			'<td class="barBBg"><div id="' + getMemoryBarId(no) + '" class="barBGreen" style="width:15px"></div></td>';
	bodyHtml +=			'<td id="' + getMemoryId(no) + '" class="textSystemB">0</td>';
	bodyHtml +=		  '</tr>';
	bodyHtml +=		  '<tr>';
	bodyHtml +=			'<td class="barBBg"><div id="' + getDiskBarId(no) + '" class="barBGreen" style="width:15px"></div></td>';
	bodyHtml +=			'<td id="' + getDiskId(no) + '" class="textSystemB">0</td>';
	bodyHtml +=		  '</tr>';
	bodyHtml +=		'</table>';
	bodyHtml +=	'</div>';
	bodyHtml +=	'<div id="' + getProcId(no) + '" class="conCountBBox02">0</div>';
	
	return bodyHtml;

}

// Get host basic html
function getHostHtml(no) {
	var bodyHtml = '' ;
	
	bodyHtml +=  '<div id="' + getAdapterId(no) + '" class="adapterBBox">';
	bodyHtml +=		'<img id="' + getAdapterTypeId("Total",no) + '" src="../image/node/adapterBBallGray.gif" class="adapterBBall" />'; 
	bodyHtml +=		'<img src="../image/node/noB' + no + '.gif" class="nodeBNo" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("SNA",no) + '" src="../image/node/adapter2BallGray.gif" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("SOCKET",no) + '" src="../image/node/adapter2BallGray.gif" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("MQ",no) + '" src="../image/node/adapter2BallGray.gif" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("HTTP",no) + '" src="../image/node/adapter2BallGray.gif" class="adapterBall" />';								
	bodyHtml +=		'<img id="' + getAdapterTypeId("EJB",no) + '" src="../image/node/adapter2BallGray.gif" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("TUXEDO",no) + '" src="../image/node/adapter2BallGray.gif" class="adapterBall" />';
	bodyHtml +=	'</div>';
	bodyHtml +=	'<div id="' + getInstId(no) + '" class="instanceAreaB">';
	bodyHtml +=	'</div>';
	bodyHtml +=	'<div class="systemBBox">';
	bodyHtml +=		'<table width="82px">';
	bodyHtml +=		  '<tr>';
	bodyHtml +=			'<td class="barBBg"><div id="' + getCpuBarId(no) + '" class="barBGreen" style="width:15px"></div></td>';
	bodyHtml +=			'<td id="' + getCpuId(no) + '" class="textSystemB">0</td>';
	bodyHtml +=		  '</tr>';
	bodyHtml +=		  '<tr>';
	bodyHtml +=			'<td class="barBBg"><div id="' + getMemoryBarId(no) + '" class="barBGreen" style="width:15px"></div></td>';
	bodyHtml +=			'<td id="' + getMemoryId(no) + '" class="textSystemB">0</td>';
	bodyHtml +=		  '</tr>';
	bodyHtml +=		  '<tr>';
	bodyHtml +=			'<td class="barBBg"><div id="' + getDiskBarId(no) + '" class="barBGreen" style="width:15px"></div></td>';
	bodyHtml +=			'<td id="' + getDiskId(no) + '" class="textSystemB">0</td>';
	bodyHtml +=		  '</tr>';
	bodyHtml +=		'</table>';
	bodyHtml +=	'</div>';
	bodyHtml +=	'<div id="' + getProcId(no) + '" class="conCountBBox02">0</div>';
	
	return bodyHtml;
}


function setInstBasic( id, arrInsts ) {	
	var instObj = getInstObject(id);
	if( instObj != null ) {
		instObj.innerHTML = getInstBasicHtml(id, arrInsts.length );
	}
	
	instObj = null ;
}

function getInstBasicHtml(id, size ) {
	var w = 100 / size ;
	var bodyHtml = '<table class="instanceList"><tr align="center">' ;
	
	for( var i = 1 ; i <= size ; i++ ) {
		bodyHtml +=	'<td style="width:' + w + '%">';
		bodyHtml +=		'<table>';
		bodyHtml +=		  '<tr>';
		bodyHtml +=			'<td valign="bottom" class="instanceBar">';
		bodyHtml +=				'<div id="' + getInstStatId(id,i) + '" class="instanceGreen" style="height:100%"></div>';
		bodyHtml +=			'</td>';
		bodyHtml +=		  '</tr>';
		bodyHtml +=		  '<tr>';
		bodyHtml +=			'<td class="instanceNum">';
		bodyHtml +=				'<img src="../image/node/insDash.gif" /><br />';
		bodyHtml +=				'<img src="../image/node/ins0' + i + '.gif" />';
		bodyHtml +=			'</td>';
		bodyHtml +=		  '</tr>';
		bodyHtml +=		'</table>';
		bodyHtml +=	'</td>';	
	}
	bodyHtml +=		'</tr></table>';
	
	return bodyHtml;
}

function getInstStatHtml(id, stat ) {
	if( stat == null )
		return "" ;
	var w = 100 / stat.length ;
	var bodyHtml = '<table class="instanceList"><tr align="center">' ;
	for( var i = 1 ; i <= stat.length ; i++ ) {
		
		var clrStat = "instanceRed" ;
		if( '1' == stat.charAt(i-1) ) {
			clrStat = "instanceGreen" ;
		}
		
		bodyHtml +=	'<td style="width:' + w + '%">';
		bodyHtml +=		'<table>';
		bodyHtml +=		  '<tr>';
		bodyHtml +=			'<td valign="bottom" class="instanceBar">';
		bodyHtml +=				'<div id="' + getInstStatId(id,i) + '" class="' + clrStat + '" style="height:100%"></div>';
		bodyHtml +=			'</td>';
		bodyHtml +=		  '</tr>';
		bodyHtml +=		  '<tr>';
		bodyHtml +=			'<td class="instanceNum">';
		bodyHtml +=				'<img src="../image/node/insDash.gif" /><br />';
		bodyHtml +=				'<img src="../image/node/ins0' + i + '.gif" />';
		bodyHtml +=			'</td>';
		bodyHtml +=		  '</tr>';
		bodyHtml +=		'</table>';
		bodyHtml +=	'</td>';		
	}
	bodyHtml +=		'</tr></table>';
	
	return bodyHtml;
}

function setAdapterStatus( no, total, sna, socket, mq, http, ejb, tuxedo ) {
	var adapterObj = getAdapterObject(no);
	if( adapterObj == null ) {
		return ;
	}
	
	var bodyHtml = '' ;
	bodyHtml +=		'<img id="' + getAdapterTypeId("Total",no) + '" src="' + getAdapterTotalImage(total) + '" class="adapterBBall" />'; 
	bodyHtml +=		'<img src="../image/node/noB' + no + '.gif" class="nodeBNo" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("SNA",no) + '" src="' + getAdapterTypeImage(sna) + '" class="adapterBall" />'; 
	bodyHtml +=		'<img id="' + getAdapterTypeId("SOCKET",no) + '" src="' + getAdapterTypeImage(socket) + '" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("MQ",no) + '" src="' + getAdapterTypeImage(mq) + '" class="adapterBall" />';
	bodyHtml +=		'<img id="' + getAdapterTypeId("HTTP",no) + '" src="' + getAdapterTypeImage(http) + '" class="adapterBall" />';										
	bodyHtml +=		'<img id="' + getAdapterTypeId("EJB",no) + '" src="' + getAdapterTypeImage(ejb) + '" class="adapterBall" />';								
	bodyHtml +=		'<img id="' + getAdapterTypeId("TUXEDO",no) + '" src="' + getAdapterTypeImage(tuxedo) + '" class="adapterBall" />';
	
	adapterObj.innerHTML = bodyHtml ;	
	adapterObj = null ;
}

// tuxedo 가 없는 경우
// no 가 밖에 있음.
//function setAdapterStatus2( no, total, sna, socket, mq, http, ejb ) {
//	var adapterObj = getAdapterObject(no);
//	if( adapterObj == null ) {
//		return ;
//	}
//	
//	var bodyHtml = '' ;
//	bodyHtml +=		'<img id="' + getAdapterTypeId("Total",no) + '" src="' + getAdapterTotalImage(total) + '" class="adapterBBall" />'; 
//	bodyHtml +=		'<img id="' + getAdapterTypeId("SNA",no) + '" src="' + getAdapterTypeImage(sna) + '" class="adapterBall" />'; 
//	bodyHtml +=		'<img id="' + getAdapterTypeId("SOCKET",no) + '" src="' + getAdapterTypeImage(socket) + '" class="adapterBall" />';
//	bodyHtml +=		'<img id="' + getAdapterTypeId("MQ",no) + '" src="' + getAdapterTypeImage(mq) + '" class="adapterBall" />';
//	bodyHtml +=		'<img id="' + getAdapterTypeId("HTTP",no) + '" src="' + getAdapterTypeImage(http) + '" class="adapterBall" />';										
//	bodyHtml +=		'<img id="' + getAdapterTypeId("EJB",no) + '" src="' + getAdapterTypeImage(ejb) + '" class="adapterBall" />';								
//	
//	adapterObj.innerHTML = bodyHtml ;
//	
//	adapterObj = null ;	
//}

function getAdapterTotalImage(stat) {
	var src = '' ;
	if( stat == "0" ) { // 에러
		src = "<%=request.getContextPath()%>/image/node/adapterBBallRed.gif" ;
	} else if( stat == "1" ) { // 부분정상
		src = "<%=request.getContextPath()%>/image/node/adapterBBallYellow.gif" ;
	} else if( stat == "2" ) { // 정상
		src = "<%=request.getContextPath()%>/image/node/adapterBBallGreen.gif" ;
	} else if( stat == "3" ) { // 사용안함
		src = "<%=request.getContextPath()%>/image/node/adapterBBallGray.gif" ;
	}
	
	return src ;
}

function getAdapterTypeImage(stat) {
	var src = '' ;
	if( stat == "0" ) { // 에러
		src = "<%=request.getContextPath()%>/image/node/adapter2BallRed.gif" ;
	} else if( stat == "1" ) { // 부분정상
		src = "<%=request.getContextPath()%>/image/node/adapter2BallYellow.gif" ;
	} else if( stat == "2" ) { // 정상
		src = "<%=request.getContextPath()%>/image/node/adapter2BallGreen.gif" ;
	} else if( stat == "3" ) { // 사용안함
		src = "<%=request.getContextPath()%>/image/node/adapter2BallGray.gif" ;
	}
	
	return src ;
}

function setInstStatus( id, stat ) {

	var obj = getInstObject( id );
	if( obj != null ) {
		obj.innerHTML = getInstStatHtml(id, stat);
	}
}

function setCpuStatus( id, val ) {
	var cpuBar = getCpuBarObject( id);
	var cpuObj = getCpuObject( id);
	
	var p = Number(val);
	var clr = "" ;
	if( p >= 80 ) {
		clr = "barRed" ;
	} else if( p >= 60 ) {
		clr = "barYellow" ;
	} else {
		clr = "barGreen" ;
	}
	
	var wp = ((p/10)+1) * 5 ;
	if( wp > 50 )
		wp = 50 ;
		
	cpuBar.className = clr ;
	cpuBar.style.width = "" + wp + "px" ;
	cpuObj.innerHTML = val;
	
	cpuBar = null;
	cpuObj = null;
}					

function setMemoryStatus( id, val ) {
	var memoryBar = getMemoryBarObject( id);
	var memoryObj = getMemoryObject( id);
	
	var p = Number(val);
	var clr = "" ;
	if( p >= 80 ) {
		clr = "barRed" ;
	} else if( p >= 60 ) {
		clr = "barYellow" ;
	} else {
		clr = "barGreen" ;
	}
	
	var wp = ((p/10)+1) * 5 ;
	if( wp > 50 )
		wp = 50 ;
		
	memoryBar.className = clr ;
	memoryBar.style.width = "" + wp + "px" ;
	memoryObj.innerHTML = val;
	
	memoryBar = null;
	memoryObj = null;
}


function setInstanceTitle ( nodeNo, instNo) {
	var nodeId, instId ;
	var obj = document.getElementById("instanceTitle");
	//obj.innerHTML = nodeNo + ":" + instNo; 
	if( nodeNo == null ) {
		nodeNo = "" ;
	}
	if( instNo == null ) {
		instNo = "" ;
	}
	
	
	var len = nodeNo.length ;
	if( len > 0 ) {
		nodeId = nodeNo.substring(len-1,len);
	} else {
		return;
	}
	
	len = instNo.length ;
	if( len > 0 ) {
		instId = instNo.substring(len-1,len);
	} else {
		return ;
	}

	var src = "" ;
	src += '<img src="../image/label/instanceSmsTitleNo010'+nodeId+'.gif" style="margin-left:102px" />' ;
	src += '<img src="../image/label/instanceSmsTitleNode01.gif" />' ;
	src += '<img src="../image/label/instanceSmsTitleNo010'+instId+'.gif" />' ;
	src += '<img src="../image/label/instanceSmsTitleIns01.gif" />' ;
	
	if( autoSmsMode == true ) {
		src += '<img id="smsModeImage" onclick="javascript:setSmsErrMode()" style="cursor:hand;" src="../image/button/btnPassive02.gif" style="margin-left:25px" />' ;
	} else {
		src += '<img id="smsModeImage" onclick="javascript:setSmsErrMode()" style="cursor:hand;" src="../image/button/btnPassive01.gif" style="margin-left:25px" />' ;
	}

	if( obj ) {
		obj.innerHTML = src ;
		obj = null ;
	}
}					




function setDiskStatus( id, val ) {
	var diskBar = getDiskBarObject( id);
	var diskObj = getDiskObject( id);
	
	var p = Number(val);
	var clr = "" ;
	if( p >= 80 ) {
		clr = "barRed" ;
	} else if( p >= 60 ) {
		clr = "barYellow" ;
	} else {
		clr = "barGreen" ;
	}
	
	var wp = ((p/10)+1) * 5 ;
	if( wp > 50 )
		wp = 50 ;
		
	diskBar.className = clr ;
	diskBar.style.width = "" + wp + "px" ;
	diskObj.innerHTML = val;
	
	diskBar = null;
	diskObj = null;
}					

function setProcStatus( id, val ) {
	var procObj = getProcObject( id);

	val = commify(val);
	
	//procObj.className = "conCountBBox02" ;	
	procObj.innerHTML = val ;
	
	procObj = null ;
}


function getHostId(id) {
	return "hostDisplay" + id;
}

function getInstId(id) {
	return "instDisplay" + id;
}

function getInstStatId(id, pos) {
	return "instStat" + id + pos ;
}

function getAdapterId(id) {
	return "adapterDisplay" + id;
}

function getAdapterTypeId(type, id) {
	return "adapter" + type + id;
}

function getCpuBarId(id) {
	return "cpuBar" + id;
}

function getCpuId(id) {
	return "cpuVal" + id;
}

function getMemoryBarId(id) {
	return "memoryBar" + id;
}

function getMemoryId(id) {
	return "memoryVal" + id;
}

function getDiskBarId(id) {
	return "diskBar" + id;
}

function getDiskId(id) {
	return "diskVal" + id;
}

function getProcId(id) {
	return "procVal" + id;
}

function getTranCell(id, pos) {
	return document.getElementById("tranTable" + id + pos );
}

function getSmsCell(id, pos) {
	return document.getElementById("smsTable" + id + pos );
}

function getHostObject(id) {
	return document.getElementById( getHostId(id) );
}

function getInstObject(id) {
	return document.getElementById( getInstId(id) );
}

function getInstStatObject(id, pos) {
	return document.getElementById( getInstStatId(id, pos) );
}

function getAdapterObject(id) {
	return document.getElementById( getAdapterId(id) );
}

function getCpuBarObject(id) {
	return document.getElementById( getCpuBarId(id) );
}

function getCpuObject(id) {
	return document.getElementById( getCpuId(id) );
}

function getMemoryBarObject(id) {
	return document.getElementById( getMemoryBarId(id) );
}

function getMemoryObject(id) {
	return document.getElementById( getMemoryId(id) );
}

function getDiskBarObject(id) {
	return document.getElementById( getDiskBarId(id) );
}

function getDiskObject(id) {
	return document.getElementById( getDiskId(id) );
}

function getProcObject(id) {
	return document.getElementById( getProcId(id) );
}


function goMainPage() {
	history.back();
}



function getAlarmMsgHtml( idx ) {
	            <!-- 노드 간격 145px -->
	var src =		'<div class="popBgBox02">';
	src +=				'<div class="popBgBox04">';
	src +=					'<div class="popBgBox05">';
	src +=						'<div class="popBgBox07">';
	src +=							'<div class="popBgBox03">';
	src +=								'<div class="popBgBox08">';
	src +=									'<div class="popBgBox06">';
	src +=										'<div class="popBgBox01">';
	src +=											'<div class="boxRedTitle">';
	src +=												'<div class="floatLeft">';
	      												 <!-- 빨간색 경고창일때 -->
	src +=													'&nbsp;&nbsp;';
	src +=													'<img src="<%=request.getContextPath()%>/image/popup/iconTitleRed.gif" />';
	src +=													'&nbsp;';
	src +=													'<span id="popupMsgTitle' + idx + '">title</span>';
	src +=												'</div>';
	src +=												'<div class="floatRight">';
	src +=													'<a href="javascript:clickCloseAlarmMsg(' + idx + ');" onfocus="blur();">';
	src +=														'<img src="<%=request.getContextPath()%>/image/popup/btnClose02.gif" alt="닫기" style="margin-top: 3px" />';
	src +=													'</a>';
	src +=												'</div>';
	src +=											'</div>';
	src +=											'<div class="boxRed">';
	src +=												'<div class="boxRedBg">';
	src +=													'<span id="popupMsgBody' + idx + '"> - 에러내용입니다.<br />'; 
	src +=													'</span>';
	src +=												'</div>';
	src +=											'</div>';
	src +=										'</div>';
	src +=									'</div>';
	src +=								'</div>';
	src +=							'</div>';
	src +=						'</div>';
	src +=					'</div>';
	src +=				'</div>';
	src +=			'</div>';
	return src ;
}


function goMainMenuTest() {
	//opener.location.href = '<%=request.getContextPath()%>/main.do?service=EAI';
	//opener.document.focus();
}

function goMainMenu( type, service ) {
	var url = "<%=request.getContextPath()%>" ;
	
	if( type == "monitor" ) {
		url = url + "/main.do?service=" + service ;
	} else if( type == "transaction" ) {
		url = url + "/main/adapter.do?adapterType=TRANSACTION&service=" + service ;
	} else if( type == "rule" ) {
		url = url + "/main/adapter.do?adapterType=RULE&service=" + service ;
	} else {
		return ;
	}
	
	parent.opener.location.href = url ;
	parent.opener.document.focus();
}


function testHideMenu() {
	if( hideMenuTimeoutID > 0 ) {
		clearTimeout( hideMenuTimeoutID );		
	}
	
	hideMenuTimeoutID = setTimeout( "testHideSubMenu();", 3000 );
}

function testHideSubMenu() {
	MM_showHideLayers('Layer1','','hide');
	MM_showHideLayers('Layer2','','hide');
	MM_showHideLayers('Layer3','','hide');	
}


function btnInitialize() {
	clearSmsInfo();	
}

function btnSoundOff() {
	var objOff = document.getElementById('btnSoundOff');
	var objOn  = document.getElementById('btnSoundOn' );
	if( objOff != null && objOn != null ) {
		objOff.style.display = 'none' ;
		objOn.style.display  = 'inline' ;
	}
	objOff = null ;
	objOn  = null ;

	isSoundOn = false ;
}

function btnSoundOn() {
	var objOff = document.getElementById('btnSoundOff');
	var objOn  = document.getElementById('btnSoundOn' );
	if( objOff != null && objOn != null ) {
		objOn.style.display  = 'none' ;	
		objOff.style.display = 'inline' ;
	}
	objOff = null ;
	objOn  = null ;
	
	isSoundOn = true ;
}

function btnPopupClose() {
	showAlarmMsg(1,false,'','');
	showAlarmMsg(2,false,'','');
	showAlarmMsg(3,false,'','');
	showAlarmMsg(4,false,'','');	
}

function btnPopupOff() {
	var objOff = document.getElementById('btnPopupOff');
	var objOn  = document.getElementById('btnPopupOn' );
	if( objOff != null && objOn != null ) {
		objOff.style.display = 'none' ;
		objOn.style.display  = 'inline' ;
	}
	objOff = null ;
	objOn  = null ;
	
	isPopupOn = false ;
}

function btnPopupOn() {
	var objOff = document.getElementById('btnPopupOff');
	var objOn  = document.getElementById('btnPopupOn' );
	if( objOff != null && objOn != null ) {
		objOn.style.display  = 'none' ;	
		objOff.style.display = 'inline' ;
	}
	objOff = null ;
	objOn  = null ;
	
	isPopupOn = true ;
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
		<td id="topLeft"><a href="javascript:goMainPage();" onfocus="blur();"><img alt="메인페이지로 이동" src="../image/common/<%=NEW_TITLE%>" /></a></td>
		<td class="topMenuArea">
					<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer1','','show','Layer2','','hide','Layer3','','hide')"><img src="../image/menu/mainMenu01On.gif" alt="전체모니터링" border="0" onmouseover="this.src='../image/menu/mainMenu01Over.gif'"	onmouseout="this.src='../image/menu/mainMenu01Out.gif'" /></a>
					<img src="../image/common/mainMenuSlash01.gif" class="mainMenuSlash" />
					<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer2','','hide','Layer2','','show','Layer3','','hide')"><img src="../image/menu/mainMenu02Out.gif" alt="보고서관리" border="0" onmouseover="this.src='../image/menu/mainMenu02Over.gif'"	onmouseout="this.src='../image/menu/mainMenu02Out.gif'" /></a>
					<img src="../image/common/mainMenuSlash02.gif" class="mainMenuSlash" />
					<a href="#" onfocus="blur();" onmouseover="MM_showHideLayers('Layer3','','hide','Layer2','','hide','Layer3','','show')"><img src="../image/menu/mainMenu03Out.gif" alt="구성관리" border="0" onmouseover="this.src='../image/menu/mainMenu03Over.gif'" onmouseout="this.src='../image/menu/mainMenu03Out.gif'" /></a>
					<!-- 서브메뉴시작 -->
					<div onmouseout="javascript:testHideMenu();" class="subMenuBg01" id="Layer1" style="position: absolute; top: 34px; left: 323px; visibility: hidden">
						<a href="javascript:goMainMenu('monitor','EAI');" onfocus="blur();"><img src="../image/menu/subMenu0101Out.gif" alt="내부" border="0" onmouseover="this.src='../image/menu/subMenu0101Over.gif'" onmouseout="this.src='../image/menu/subMenu0101Out.gif'" /></a>
						<a href="javascript:goMainMenu('monitor','FEP');" onfocus="blur();"><img src="../image/menu/subMenu0102Out.gif" alt="대외" border="0" onmouseover="this.src='../image/menu/subMenu0102Over.gif'" onmouseout="this.src='../image/menu/subMenu0102Out.gif'" /></a>
						<!--a href="javascript:goMainMenu('monitor','BATCH');" onfocus="blur();"><img src="../image/menu/subMenu0105Out.gif" alt="일괄전송" border="0" onmouseover="this.src='../image/menu/subMenu0105Over.gif'" onmouseout="this.src='../image/menu/subMenu0105Out.gif'" /></a-->
					</div>
					<div onmouseout="javascript:testHideMenu();" class="subMenuBg02" id="Layer2" style="position: absolute; top: 34px; left: 323px; visibility: hidden">
						<a href="javascript:goMainMenu('transaction','EAI');" onfocus="blur();"><img src="../image/menu/subMenu0201Out.gif" alt="내부" border="0" onmouseover="this.src='../image/menu/subMenu0201Over.gif'" onmouseout="this.src='../image/menu/subMenu0201Out.gif'" /></a>
						<a href="javascript:goMainMenu('transaction','FEP');" onfocus="blur();"><img src="../image/menu/subMenu0202Out.gif" alt="대외" border="0" onmouseover="this.src='../image/menu/subMenu0202Over.gif'" onmouseout="this.src='../image/menu/subMenu0202Out.gif'" /></a>
						<!--a href="javascript:goMainMenu('transaction','BATCH');" onfocus="blur();"><img src="../image/menu/subMenu0205Out.gif" alt="일괄전송" border="0" onmouseover="this.src='../image/menu/subMenu0205Over.gif'" onmouseout="this.src='../image/menu/subMenu0205Out.gif'" /></a-->
					</div>
					<div onmouseout="javascript:testHideMenu();" class="subMenuBg03" id="Layer3" style="position: absolute; top: 34px; left: 323px; visibility: hidden">
						<a href="javascript:goMainMenu('rule','EAI');" onfocus="blur();"><img src="../image/menu/subMenu0301Out.gif" alt="내부" border="0" onmouseover="this.src='../image/menu/subMenu0301Over.gif'" onmouseout="this.src='../image/menu/subMenu0301Out.gif'" /></a>
						<a href="javascript:goMainMenu('rule','FEP');" onfocus="blur();"><img src="../image/menu/subMenu0302Out.gif" alt="대외" border="0" onmouseover="this.src='../image/menu/subMenu0302Over.gif'" onmouseout="this.src='../image/menu/subMenu0302Out.gif'" /></a>
						<!--a href="javascript:goMainMenu('rule','BATCH');" onfocus="blur();"><img src="../image/menu/subMenu0305Out.gif" alt="일괄전송" border="0" onmouseover="this.src='../image/menu/subMenu0305Over.gif'" onmouseout="this.src='../image/menu/subMenu0305Out.gif'" /></a-->
					</div>		
		</td>
		<td class="topRight">
					<div id="topTime" class="time">2009.09.20(일) 12:20:30</div>
					<div class="quickLink">
						<a href="javascript:btnInitialize();" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnResetOut.gif" alt="초기화" border="0" onmouseover="this.src='../image/button/btnResetOver.gif'" onmouseout="this.src='../image/button/btnResetOut.gif'" /></a>
						<a id="btnSoundOff" style="display: inline;" href="javascript:btnSoundOff();" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnSoundOnOut.gif" alt="사운드끄기" border="0" onmouseover="this.src='../image/button/btnSoundOnOver.gif'" onmouseout="this.src='../image/button/btnSoundOnOut.gif'" /></a>
						<a id="btnSoundOn" style="display: none;" href="javascript:btnSoundOn();" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnSoundOffOut.gif" alt="사운드켜기" border="0" onmouseover="this.src='../image/button/btnSoundOffOver.gif'" onmouseout="this.src='../image/button/btnSoundOffOut.gif'" /></a>
						<a href="javascript:btnPopupClose();" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnPopupCloseOut.gif" alt="팝업닫기" border="0" onmouseover="this.src='../image/button/btnPopupCloseOver.gif'" onmouseout="this.src='../image/button/btnPopupCloseOut.gif'" /></a>
						<a id="btnPopupOff" style="display: inline;" href="javascript:btnPopupOff();" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnPopupOnOut.gif" alt="팝업끄기" border="0" onmouseover="this.src='../image/button/btnPopupOnOver.gif'" onmouseout="this.src='../image/button/btnPopupOnOut.gif'" /></a>
						<a id="btnPopupOn" style="display: none;" href="javascript:btnPopupOn();" onfocus="blur();"><img src="<%=request.getContextPath()%>/image/button/btnPopupOffOut.gif" alt="팝업켜기" border="0" onmouseover="this.src='../image/button/btnPopupOffOver.gif'" onmouseout="this.src='../image/button/btnPopupOffOut.gif'" /></a>
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
			<div class="mainTitle01"><img id="mainTitleImage" src="../image/label/mainTitle0101.gif" /></div>
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
								<div id="hostDisplay1" class="nodeBNone">
								</div>
							</td>
							<td style="width:25%">
							<!-- 노드02 -->
								<div id="hostDisplay2" class="nodeBNone">									
								</div>
							</td>
							<td style="width:25%">
							<!-- 노드03 -->
								<div id="hostDisplay3" class="nodeBNone">
								</div>
							</td>
							<td style="width:25%">
							<!-- 노드04 노드 다운시 표현-->
								<div id="hostDisplay4" class="nodeBNone"></div>
							</td>
						  </tr>
						</table>
						<!-- 노드 4개 끝 -->
					</div></div></div></div></div>
					</div></div></div></div>
					<!-- 업무별 모니터링 끝 -->			
				</td>
				<td align="right">
					<div class="instanceSmsBox02"><div class="instanceSmsBox04"><div class="instanceSmsBox05"><div class="instanceSmsBox07">
						<div class="instanceSmsBox03"><div class="instanceSmsBox08"><div class="instanceSmsBox06"><div class="instanceSmsBox01" style="text-align: left" >
							<div align="right" id="instanceTitle" class="instanceSmsTitle04">
								<img id="smsModeImage" onclick="javascript:setSmsErrMode()" style="cursor:hand;" src="../image/button/btnPassive01.gif" style="margin-left:25px" />
							</div>
							<div id="processInfo" class="instanceState01">
							</div>
							<table class="table02">
							  <tr>
								<th style="width:30%"><img src="../image/label/tableTitle0401.gif" /></th>
								<th style="width:35%"><img src="../image/label/tableTitle0402.gif" /></th>
								<th style="width:35%"><img src="../image/label/tableTitle0403.gif" /></th>
							  </tr>
							  <tr>
								<td id="errinfo1" align="center" title=""></td>
								<td id="errinfo2" align="center" title=""></td>
								<td id="errinfo3" align="center" title=""></td>
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
					<th style="width:100px"><img src="../image/label/tableTitle0117.gif" /></th>
					<th style="width:240px"><img src="../image/label/tableTitle0102.gif" /></th>
					<th style="width:180px"><img src="../image/label/tableTitle0103.gif" /></th>
					<th style="width:180px"><img src="../image/label/tableTitle0104.gif" /></th>
					<th style="width:150px"><img src="../image/label/tableTitle0105.gif" /></th>
					<th style="width:180px"><img src="../image/label/tableTitle0106.gif" /></th>
					<th ><img src="../image/label/tableTitle0107.gif" /></th>
				  </tr>
				  <tr>
					<td align="center"><span class="textGroup">1</span></td>
					<td align="right"><span id="tranTable11">0</span></td>
					<td align="right"><span id="tranTable12">0</span></td>
					<td onclick="javascript:popupError('TIMEOUT',1);" title="타임아웃화면 팝업" style="cursor:hand" align="right"><span id="tranTable13">0</span></td>
					<td align="right"><span id="tranTable14">0</span></td>
					<td onclick="javascript:popupError('ERROR',1);" title="에러화면 팝업" style="cursor:hand" align="right"><span id="tranTable15">0</span></td>
					<td align="right"><span id="tranTable16">0</span></td>
				  </tr>
				  <tr class="second">
				  	<td align="center"><span class="textGroup">2</span></td>
					<td align="right"><span id="tranTable21">0</span></td>
					<td align="right"><span id="tranTable22">0</span></td>
					<td onclick="javascript:popupError('TIMEOUT',2);" title="타임아웃화면 팝업" style="cursor:hand" align="right"><span id="tranTable23">0</span></td>
					<td align="right"><span id="tranTable24">0</span></td>
					<td onclick="javascript:popupError('ERROR',2);" title="에러화면 팝업" style="cursor:hand" align="right"><span id="tranTable25">0</span></td>
					<td align="right"><span id="tranTable26">0</span></td>
				  </tr>
				  <tr>
                    <td align="center"><span class="textGroup">3</span></td>
					<td align="right"><span id="tranTable31">0</span></td>
					<td align="right"><span id="tranTable32">0</span></td>
					<td onclick="javascript:popupError('TIMEOUT',3);" title="타임아웃화면 팝업" style="cursor:hand" align="right"><span id="tranTable33">0</span></td>
					<td align="right"><span id="tranTable34">0</span></td>
					<td onclick="javascript:popupError('ERROR',3);" title="에러화면 팝업" style="cursor:hand" align="right"><span id="tranTable35">0</span></td>
					<td align="right"><span id="tranTable36">0</span></td>
				  </tr>
				  <tr class="second">
                    <td align="center"><span class="textGroup">4</span></td>
					<td align="right"><span id="tranTable41">0</span></td>
					<td align="right"><span id="tranTable42">0</span></td>
					<td onclick="javascript:popupError('TIMEOUT',4);" title="타임아웃화면 팝업" style="cursor:hand" align="right"><span id="tranTable43">0</span></td>
					<td align="right"><span id="tranTable44">0</span></td>
					<td onclick="javascript:popupError('ERROR',4);" title="에러화면 팝업" style="cursor:hand" align="right"><span id="tranTable45">0</span></td>
					<td align="right"><span id="tranTable46">0</span></td>
				  </tr>
				  <tr>
					<th class="sum"><img src="../image/label/tableTitle0109.gif" /></th>
					<th class="sumRight"><span id="tranTable51">0</span></th>
					<th class="sumRight"><span id="tranTable52">0</span></th>
					<th class="sumRight"><span id="tranTable53">0</span></th>
					<th class="sumRight"><span id="tranTable54">0</span></th>
					<th class="sumRight"><span id="tranTable55">0</span></th>
					<th class="sumRight"><span id="tranTable56">0</span></th>
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
				   	<th style="width:100px"><img src="../image/label/tableTitle0302.gif" /></th>
					<th style="width:120px"><img src="../image/label/tableTitle0303T.gif" /></th>
					<th><img src="../image/label/tableTitle0304.gif" /></th>
				  </tr>
				  <tr onClick="javascript:displaySmsInfo(document.getElementById('smsTable12').innerHTML);">
				    <td align="center"><span id="smsTable11"></span></td>
					<td align="center"><span id="smsTable12"></span></td>
					<td><span id="smsTable13"></span></td>
				  </tr>
				  <tr class="second" onClick="javascript:displaySmsInfo(document.getElementById('smsTable22').innerHTML);">
				    <td align="center"><span id="smsTable21"></span></td>
					<td align="center"><span id="smsTable22"></span></td>
					<td><span id="smsTable23"></span></td>
				  </tr>
				  <tr onClick="javascript:displaySmsInfo(document.getElementById('smsTable32').innerHTML);">
				    <td align="center"><span id="smsTable31"></span></td>
					<td align="center"><span id="smsTable32"></span></td>
					<td><span id="smsTable33"></span></td>
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
		<div id="obstaclePopup1"
			style="display:none ; width: 278px; height: 60px; top: 140px; left: 165px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		<div id="obstaclePopup2"
			style="display:none ; width: 278px; height: 60px; top: 140px; left: 750px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		<div id="obstaclePopup3"
			style="display:none ; width: 278px; height: 60px; top: 370px; left: 165px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		<div id="obstaclePopup4"
			style="display:none ; width: 278px; height: 60px; top: 370px; left: 750px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		
<!-- 장애통보 끝 -->

<!-- 시스템리소스상황판 시작 -->
<div id="adapterPopup" style="width:370px; top:405px; left:690px; position:absolute; z-index:900; visibility:hidden;">
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
						<td><br />
							
						<br /></td>
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

<script type="text/JavaScript">
	reqAjaxHost = createAjaxRequest();	
	reqAjaxTran = createAjaxRequest();
	reqAjaxSms  = createAjaxRequest();
	reqAjaxSmsInit = createAjaxRequest();	
	reqAjaxSmsErr= createAjaxRequest();	
	
	initPage();
	
	setTimeout("requestServerInfo();", 100);
	setInterval("setTopTime();", 1000);
	setInterval("checkConnection();", 5000);
	
</script>
</body>
<embed src="<%=request.getContextPath()%>/common/sound/alert2.wav" name="player" hidden="true" autostart="false" WIDTH="1" HEIGHT="1" ></embed>	

<!--
****************************************************************************
* body 코드 end
****************************************************************************
-->
</html>