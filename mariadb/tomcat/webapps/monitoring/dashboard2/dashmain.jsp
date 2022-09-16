<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="com.eactive.eai.rms.common.context.MonitoringContext"%>
<%@ page import="com.eactive.eai.rms.common.context.MonitoringContextImpl"%>
<%@ page import="com.eactive.eai.rms.common.util.CommonUtil"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	request.setCharacterEncoding("euc-kr");
	MonitoringContextImpl monitoringContext = (MonitoringContextImpl)CommonUtil.getBean(request, "monitoringContext");

	String NEW_TITLE = (String) session.getAttribute(MonitoringContext.NEW_DASHBOARD_TITLE);
	String fepBatchUrl = monitoringContext.getStringProperty("FEP_BATCH_SERVER", "");
	String eaiBatchUrl = monitoringContext.getStringProperty("EAI_BATCH_SERVER", "");
%>
<head>
<title>▣▣▣ EAI 모니터링 시스템 ▣▣▣</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link href="<%=request.getContextPath()%>/css/style-dashboard.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ajax.js">
</script>
<script language="JavaScript" type="text/JavaScript"><!--

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
		//media player가 없어서 스크립트 에러 발생시 소리끔
		if(typeof document.player.stop === 'undefined'){
			btnSoundOff();
			
		}else{	
			document.player.stop();
			document.player.play();
		}
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

function gosubpage( s ) {
	var url = "<%=request.getContextPath()%>/dashboard2/" ;
	if( s == 'BATCH' ) {
		// 임시로 막아 놓는다.
		return;		
		//url += "dashsub2.jsp?service=" + s;
	} else {
		url += "dashsub1.jsp?service=" + s;
	}
	
	location.href = url ;
}

var isSoundOn = true ;
var isPopupOn = true ;


var reqAjaxOut  = null ;
var reqAjaxIn   = null ;
var reqAjaxBatch= null ;

var reqAjaxTran = null ;
var reqAjaxPeek = null ;
var reqAjaxSms  = null ;

var reqAjaxSmsInit = null ;
var reqAjaxBaseInfo = null ;

var arrHostOut  = null ;
var arrHostIn   = null ;
var arrHostBatch= null ;

var isFullTrade = false ;

var hideMenuTimeoutID = -1 ;

var connectionError = "0";

var peekStat = "tps" ;

function checkConnection() {
	if( connectionError != "0" ) {
		alert( '서버와의 연결이 종료되어 현재창을 닫습니다.( error code=' + connectionError + ' ' + getDummyTime() + ' )' );
		parent.self.close();
	}
}

function getAjaxObject( type ) {
	if( type == "EAI") {
		return reqAjaxIn;
	} else if( type == "FEP") {
		return reqAjaxOut;
	} else if( type == "BATCH" ) {
		return reqAjaxBatch;
	} else if( type == "Tran" ) {
		return reqAjaxTran;
	} else if( type == "Peek" ) {
		return reqAjaxPeek;
	} else if( type == "Sms" ) {
		return reqAjaxSms;
	} else if( type == "SmsInit" ) {
		return reqAjaxSmsInit;
	} else if( type == "BaseInfo" ) {
		return reqAjaxBaseInfo;
	}
	return null;
}

function getHostArray( type ) {
	if( type == "EAI" ) {
		return arrHostIn;
	} else if( type == "FEP" ) {
		return arrHostOut;
	} else if( type == "BATCH" ) {
		return arrHostBatch;
	}
	return null;
}


function getFuncServerInfo( type ) {
	if( type == "EAI" ) {	   
		return updateServerInfoIn;
	} else if( type == "FEP"  ) {   
		return updateServerInfoOut;
	} else if( type == "BATCH" ) { 
		return updateServerInfoBatch;
	}
}

function getFuncHostInfo( type ) {
	if( type == "EAI" ) {	   
		return updateHostInfoIn;
	} else if( type == "FEP" ) {   
		return updateHostInfoOut;
	} else if( type == "BATCH" ) { 
		return updateHostInfoBatch;
	}
}

function requestBaseInfo() {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=baseinfo" ;
	var url = urlBase ;
	var reqAjax = getAjaxObject( "BaseInfo" );
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateBaseInfo ;
	reqAjax.send(null);
	
	reqAjax = null ;
}

function requestAllServerInfo( serverType ) {
	if( "ALL" == serverType ) {
		requestServerInfo("EAI");		
		requestServerInfo("FEP");
	} else if( "FEP" == serverType ) {
		requestServerInfo("FEP");		
	} else if( "EAI" == serverType ) {
		requestServerInfo("EAI");			
	}	
	requestServerInfo("BATCH");
}

function requestServerInfo( type ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=serverinfo" ;	
	var url = urlBase + getServiceId( type, true) ; //+ getDummyTime();
	var reqAjax = getAjaxObject( type );
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = getFuncServerInfo(type) ;
	reqAjax.send(null);
	
	reqAjax = null;
}

function requestHostInfo( type ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=hostinfo" ;
	var url     = urlBase + getServiceId(type, true) ; //+ getDummyTime() ;
	var reqAjax = getAjaxObject( type );
	
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = getFuncHostInfo( type ) ;
	reqAjax.send(null);
	reqAjax = null ;	
}

function requestTranInfo( ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=traninfo" ;
	var url     = urlBase ; //+ getDummyTime() ;
	var reqAjax = getAjaxObject( "Tran" );
	
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateTranInfo ;
	reqAjax.send(null);
	
	reqAjax = null;
}

function requestPeekInfo() {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=peekinfo" ;
	var url     = urlBase + "&peekstat=" + peekStat ; //+ getDummyTime() ;
	var reqAjax = getAjaxObject( "Peek" );
	
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updatePeekInfo ;
	reqAjax.send(null);
	
	reqAjax = null;
}


function requestSmsInfo( ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=smsinfo" ;
	var url     = urlBase ; //+ getDummyTime() ;
	var reqAjax = getAjaxObject( "Sms" );
	
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateSmsInfo ;
	reqAjax.send(null);
	
	reqAjax = null;
}

function requestSmsInit( t ) {
	var urlBase = "<%=request.getContextPath()%>/dashboard2.do?cmd=main&type=smsinit" ;
	var url     = urlBase; //  + "&initTime=" + t ;
	var reqAjax = getAjaxObject( "SmsInit");
	
	reqAjax.open('GET', url, true);
	reqAjax.onreadystatechange = updateSmsInit ;
	reqAjax.send(null);
	
	reqAjax = null ;
}


function getAjaxData( type ) {
	var reqAjax = getAjaxObject( type );
	
	//purge(reqAjax);

	try {	
		if( reqAjax.readyState == 4 ) {
			if( reqAjax.status == 200 ) {
				return reqAjax.responseText ;
			} else {
				// 12029 : ERROR_INTERNET_CANNOT_CONNECT
				if( 12029 == reqAjax.status ) {
					connectionError = "12029" ;
				} else {
					connectionError = "" + reqAjax.status ;
				}
			}
		} else {
		}
	} catch ( e ){
		//alert( e ) ;
	} finally {
		reqAjax = null ;
	}
	return null ;
}


function startMonitoring( type ) {
	// 각 서비스 타입에 따라 모니터링 정보를 요청한다.
	// 개발시에만 timeout , real 은 interval
	
	// interval 값을 5초 -> 10초로 수정 2010.02.16 ( 요청 )
	var interval = 10000 ;
	
	setInterval( 'requestHostInfo("' + type + '");', interval);
	 
	// 마지막 호스트 정보 수신 후
	if( type == 'FEP' ) {
	    setInterval( 'requestTranInfo();', interval/5);
	    setInterval( 'requestPeekInfo();', interval);
	    setInterval( 'requestSmsInfo();', interval);
	}
}

function updateServerInfoIn()   { 
	updateServerInfo("EAI");  
}

function updateServerInfoOut()  { 
	updateServerInfo("FEP"); 
}

function updateServerInfoBatch(){
	updateServerInfo("BATCH");
}

function updateBaseInfo() {
	var msg = getAjaxData( "BaseInfo" );
	if( null != msg ) {
		requestAllServerInfo(msg);
	}
}

function updateServerInfo( type ) {
	var msg      = getAjaxData(type);
	var arrHost  = getHostArray( type );
	
	if( null != msg ) {
		var lines = msg.split(";");
		arrHost = checkHostNames(lines);
		
		var hostMax = 4 ;
		if( type == 'BATCH' ) {
			hostMax = 2 ;
			//return ;
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
		
		startMonitoring( type );
	}
}

function updateHostInfoIn()  { 
	updateHostInfo("EAI");  
}

function updateHostInfoOut() { 
	updateHostInfo("FEP"); 
}


function updateHostInfoBatch() {
	updateHostInfo("BATCH"); 
}

function updateHostInfo( type ) {
	var msg      = getAjaxData(type);
	if( null != msg ) {
	
		//var arrHost  = getHostArray( type );		
		var lines = msg.split(";");
		var procCnt = 0; // host별 처리건수 
		var step = 0;
		var host = "";
		
		for( var i = 0 ; i < lines.length ; i++ ) {
			var infos = lines[i].split(",");
			if( host != infos[0]) {
				procCnt =0;
				step += 1;
				host = infos[0];
			}
			
			// NodeBox를 비활성화로 변경
			// Host명이 2개일 때 활성화 되었던 NodeBox가 Host명이 1개로 수정 되었을 때 비활성화 되도록 수정.
			if(lines.length == 1)
			{
				var id = step + 1;
				var hostObj = getHostObject(type, id);
				if(hostObj != null)
				{
					setHostBasicEmpty(type, id);
				}
			}
			
			// hostname,isDown,adapter,inst000000,cpu,memory,disk,proc;	
			
			// telnet 은 되는데 was가 down 되었을 때를 생각해보라.
			if( infos.length >= 14 ) {
				
				if( "1" == infos[1] ) { // host Alive
					setHostBasic(type, step);

					setRTAdapterStatus(type, step, infos[14]);
					
					setAdapterStatus(type, step, infos[2]);
					
					setInstStatus( type, step, infos[9]);
					
					setCpuStatus( type, step, infos[10]);
					
					setMemoryStatus( type, step, infos[11]);
					
					setDiskStatus( type, step, infos[12]);

					procCnt += parseInt(infos[13],10);
					setProcStatus( type, step, procCnt);
				} else {
					//alert( infos[1] + ":" + lines[i] );
					setHostBasicDown(type, step);
				}
			} else {
				//setHostBasicDown(type, step);
				//alert( 'invalid host info : ' + infos.length ) ;
			}
		} // end for
	}	
}

///////////////////////////////////////////////////////////
function updateTranInfo( ) {
	var msg      = getAjaxData("Tran");
	var tmpVal   = 0 ;
	if( null != msg ) {
		var totalProc2    = 0 ;
		var totalTimeout2 = 0 ;
		var totalError2   = 0 ;
		
		var lines = msg.split(";");
		for( var i = 0 ; i < lines.length ; i++ ) {
			var step = i+1;
			var infos = lines[i].split(",");
			
			// batch : service,send,recv,esend,erecv,rsend,rrecv
			if( infos.length > 6 && infos[0] == 'BATCH' ) {
				step = 6 ;
				for( var k = 1 ; k < 7 ; k++ ) {
					var obj = document.getElementById("tranTable" + step + k);
					var old = obj.innerText ;
					obj = null ;
					var beforeVal = commanum(old) ;
					var currVal   = "" + infos[k];
					if( beforeVal != currVal ) {
						rollingScore("tranTable" + step + k, currVal, old);
					}
				}
			}
			// eai_batch : service,send,recv,esend,erecv,rsend,rrecv
			else if( infos.length > 6 && infos[0] == 'EAI_BATCH' ) {
				step = 7 ;
				for( var k = 1 ; k < 7 ; k++ ) {
					var obj = document.getElementById("tranTable" + step + k);
					var old = obj.innerText ;
					obj = null ;
					var beforeVal = commanum(old) ;
					var currVal   = "" + infos[k];
					if( beforeVal != currVal ) {
						rollingScore("tranTable" + step + k, currVal, old);
					}
				}
			}
			// service,proc,timeout,error
			else if( infos.length > 3 ) {
				if( infos[0] == 'EAI' ) {
					step = 1 ; // 내부
				} else if( infos[0] == 'FEP' ) {
					step = 2 ; // 대외
				} else if( infos[0] == 'TOTAL' ) {
					step = 5 ; // total
				}				
				
				// 거래건수
				var tableObj1 = document.getElementById("tranTable" + step + 1);
				var tableObj2 = document.getElementById("tranTable" + step + 2);
				var old       = tableObj1.innerText ;
				var beforeVal = commanum(old) ;
								
				if( beforeVal == "0" || beforeVal == "" ) {
					tmpVal = 0 ;
				} else {
					tmpVal =  commanum(infos[1]) - beforeVal ;
				}
				
				if( step == 5 ) {
					tableObj1 = null ;
					tableObj2 = null ;
					tmpVal = '' + totalProc2 ;
					rollingScore("tranTable" + step + 1, infos[1], old);
					rollingScoreArrow("tranTable" + step + 2, tmpVal, '0');
				} else {
					if( tmpVal < 0 ) tmpVal = 0 ;
					totalProc2 += tmpVal ;		
					tableObj1.innerText = commify( infos[1] );
					//tableObj2.innerText = '↑ ' + tmpVal ;
					setArrowTextBody( tableObj2, '' + tmpVal );
					tableObj1 = null ;
					tableObj2 = null ;
				}
				
				// 타임아웃 건수
				tableObj1 = document.getElementById("tranTable" + step + 3);
				tableObj2 = document.getElementById("tranTable" + step + 4);
				old       = tableObj1.innerText ;
				beforeVal = commanum(old) ;
				
				if( beforeVal == "0" || beforeVal == "" ) {
					tmpVal = 0 ;
				} else {
					tmpVal =  commanum(infos[2]) - beforeVal ;
				}
				
				if( step == 5 ) {
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

				// 에러건수
				tableObj1 = document.getElementById("tranTable" + step + 5);
				tableObj2 = document.getElementById("tranTable" + step + 6);
				old       = tableObj1.innerText ;
				beforeVal = commanum(old) ;
				if( beforeVal == "0" || beforeVal == "" ) {
					tmpVal = 0 ;
				} else {
					tmpVal = commanum(infos[3]) - beforeVal ;
				}
				
				if( step == 5 ) {
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

function updatePeekInfo( ) {
	var msg      = getAjaxData("Peek");
	if( null != msg ) {
		var lines = msg.split(";");
		for( var i = 0 ; i < lines.length ; i++ ) {
			var infos = lines[i].split(",");
			// service,date,proc,tps
			if( infos.length > 3 ) {
				var tableObj1 = document.getElementById("peekTable" + infos[0] + 1);
				var tableObj2 = document.getElementById("peekTable" + infos[0] + 2);
				var tableObj3 = document.getElementById("peekTable" + infos[0] + 3);
				tableObj1.innerText = formdate1( infos[1] ) ;
				tableObj2.innerText = commify( infos[2] ) ;
				tableObj3.innerText = commify( infos[3] ) ;
				
				tableObj1 = null ;
				tableObj2 = null ;
				tableObj3 = null ;
			}
		}
	}	
}

function updateSmsInfo( ) {
	var msg      = getAjaxData("Sms");
	if( null != msg && msg != "") {	
		var lines = msg.split(";");
		var len = lines.length < 10 ? lines.length : 10;
		for( var i = 0 ; i < len ; i++ ) {
			var step = i+1;
			var infos = lines[i].split(",");
			// type,inst,date,message
			if( infos.length > 3 ) {
				var tableObj1 = document.getElementById("smsTable" + step + "1");
				var tableObj2 = document.getElementById("smsTable" + step + "2");
				var tableObj3 = document.getElementById("smsTable" + step + "3");
				var tableObj4 = document.getElementById("smsTable" + step + "4");	
				
				tableObj1.innerText = infos[0] ;
				tableObj2.innerText = infos[1] ;
				tableObj3.innerText = infos[2] ;
				tableObj4.innerText = infos[3]  ;				
				
				tableObj1 = null ;
				tableObj2 = null ;
				tableObj3 = null ;
				tableObj4 = null ;
			}
		}
	}	
}

function updateSmsInit( ) {
	for( var i = 1 ; i <= 10 ; i++ ) {
		var tableObj1 = document.getElementById("smsTable" + i + "1");
		var tableObj2 = document.getElementById("smsTable" + i + "2");
		var tableObj3 = document.getElementById("smsTable" + i + "3");
		var tableObj4 = document.getElementById("smsTable" + i + "4");	
		
		tableObj1.innerText = "" ;
		tableObj2.innerText = "" ;
		tableObj3.innerText = "" ;
		tableObj4.innerText = "" ;				
		
		//tableObj1 = null ;
		//tableObj2 = null ;
		//tableObj3 = null ;
		//tableObj4 = null ;		
	}
}

function clearSmsInfo( ) {

	// 1 row, 3 col => time
	var obj = document.getElementById("smsTable13");
	if( obj != null ) {
		requestSmsInit( obj.innerText );
	}
	obj = null ;
}



// Get host basic html
function getHostHtml(type, no) {
	var bodyHtml = '' ;
	bodyHtml += '<div class="nodeNo"><img src="<%=request.getContextPath()%>/image/node/num' + no + '.gif" /></div>' ;
	bodyHtml += '<div id="' + getAdapterId(type, no) + '" class="adapterBox" onclick="goMainMenu(\'status\', \'' + type + '\', 1);">' ;
	bodyHtml += '<img src="<%=request.getContextPath()%>/image/node/adapterBallGray.gif" align=\"right\"  style=\"cursor:pointer\"/>' ;
	bodyHtml += '</div>' ;
	bodyHtml += '<div id="' + getRTAdapterId(type, no) + '" class="adapterRTBox" onclick="goMainMenu(\'status\', \'' + type + '\', 2);">' ;
	bodyHtml += '<img src="<%=request.getContextPath()%>/image/node/adapterBallGray.gif" align=\"right\" style=\"cursor:pointer\"/>' ;
	bodyHtml += '</div>' ;
	bodyHtml += '<div class="instanceArea">' ;
	bodyHtml += '<div id="' + getInstLineId(type, no) + '" class="instanceLine">' ;
	bodyHtml += '<div id="' + getInstId(type, no) + '" class="instanceBox">' ;
	bodyHtml += '</div>' ;
	bodyHtml += '</div></div>' ;
	bodyHtml += '<div class="systemBox">' ;
	bodyHtml += '<table width="60px">' ;
	bodyHtml += '<tr>' ;
	bodyHtml += '<td class="barBg"><div id="' + getCpuBarId(type, no) + '" class="barGreen" style="width:4px"></div></td>' ;
	bodyHtml += '<td id="' + getCpuId(type, no) +'" class="textSystem">0</td>' ;
	bodyHtml += '</tr>' ;
	bodyHtml += '<tr>' ;
	bodyHtml += '<td class="barBg"><div id="' + getMemoryBarId(type, no) + '" class="barGreen" style="width:4px"></div></td>' ;
	bodyHtml += '<td id="' + getMemoryId(type, no) +'" class="textSystem">0</td>' ;
	bodyHtml += '</tr>' ;
	bodyHtml += '<tr>' ;
	bodyHtml += '<td class="barBg"><div id="' + getDiskBarId(type, no) + '" class="barGreen" style="width:4px"></div></td>' ;
	bodyHtml += '<td id="' + getDiskId(type, no) +'" class="textSystem">0</td>' ;
	bodyHtml += '</tr>' ;
	bodyHtml += '</table>' ;
	bodyHtml += '</div>' ;
	bodyHtml += '<div id="' + getProcId(type, no) +'" class="conCountBox">0</div>' ;
	return bodyHtml;
}

function getAdapterId(type,id) {
	return "adapter" + type + "Display" + id;
}

function getRTAdapterId(type,id) {
	return "adapterRT" + type + "Display" + id;
}

function getHostId(type,id) {
	return "host" + type + "Display" + id;
}

function getInstLineId(type, id) {
	return "inst" + type + "Line" + id;
}

function getInstId(type, id) {
	return "inst" + type + "Display" + id;
}

function getCpuBarId(type, id) {
	return "cpu" + type + "Bar" + id;
}

function getMemoryBarId(type, id) {
	return "memory" + type + "Bar" + id;
}

function getDiskBarId(type, id) {
	return "disk" + type + "Bar" + id;
}

function getCpuId(type, id) {
	return "cpu" + type + "Val" + id;
}

function getMemoryId(type, id) {
	return "memory" + type + "Val" + id;
}

function getDiskId(type, id) {
	return "disk" + type + "Val" + id;
}

function getProcId(type, id) {
	return "proc" + type + "Val" + id;
}

function getAdapterObject(type, id) {
	return document.getElementById( getAdapterId(type, id) );
}

function getRTAdapterObject(type, id) {
	return document.getElementById( getRTAdapterId(type, id) );
}

function getHostObject(type, id) {
	return document.getElementById( getHostId(type, id) );
}

function getInstLineObject(type, id) {
	return document.getElementById( getInstLineId(type, id) );
}

function getInstObject(type, id) {
	return document.getElementById( getInstId(type, id) );
}

function getCpuBarObject(type, id) {
	return document.getElementById( getCpuBarId(type, id) );
}

function getMemoryBarObject(type, id) {
	return document.getElementById( getMemoryBarId(type, id) );
}

function getDiskBarObject(type, id) {
	return document.getElementById( getDiskBarId(type, id) );
}

function getCpuObject(type, id ) {
	return document.getElementById( getCpuId(type, id) );
}

function getMemoryObject(type, id ) {
	return document.getElementById( getMemoryId(type, id) );
}

function getDiskObject(type, id ) {
	return document.getElementById( getDiskId(type, id) );
}

function getProcObject(type, id ) {
	return document.getElementById( getProcId(type, id) );
}




// Draw empty host box image
function setHostBasicEmpty(type, id) {
	var hostObj = getHostObject(type,id);
	if( hostObj != null ) {
		//purge(hostObj);
		hostObj.className = "nodeSNone";
		hostObj.innerHTML = '';
	}
	hostObj = null ;
}

function setHostBasicDown(type, id) {
	var hostObj = getHostObject(type,id);
	if( hostObj != null ) {
		//purge(hostObj);
		hostObj.className = "nodeSDown";
		hostObj.innerHTML = '';
	}
	hostObj = null ;
}

// Draw basic host box image
function setHostBasic( type, id ) {
	var hostObj = getHostObject(type,id);
	if( hostObj != null ) {
		//purge(hostObj);
		hostObj.className = "nodeS" ;
		hostObj.innerHTML = getHostHtml( type, id);
	}
	hostObj = null ;
}

function setInstBasic( type, id, arrInsts ) {
	var lineObj = getInstLineObject(type, id);
	if( lineObj != null ) {
		//purge(lineObj);
		if( arrInsts.length < 6 ) {
			lineObj.className = "instanceLine" ;
		} else {
			lineObj.className = "instanceLine2" ;
		}
	}
	
	var instObj = getInstObject(type, id);
	if( instObj != null ) {
		//purge(instObj);
		var htmlSrc = "" ;
		for( var i = 1 ; i <= arrInsts.length ; i++ ) {
			htmlSrc += '<img src="<%=request.getContextPath()%>/image/node/ins' + i + 'Green.gif" />';
		} 
		instObj.innerHTML = htmlSrc;
	}
	
	lineObj = null ;
	instObj = null ;
}

function setInstStatus( type, id, stat ) {
	var instLineObj =  getInstLineObject( type, id);
	var instObj     =  getInstObject( type, id);
	
	var bAlarm = false ;

	if( stat.length < 6 ) {
		instLineObj.className = "instanceLine" ;
	} else {
		instLineObj.className = "instanceLine2" ;
	}
	
	var idx  = getMsgIdxByType(type) + id;
	var msg1 = getMsgTitleByType(type) + ' ' + id + ' 번 서버' ;
	var msg2 = '' ;
	
	
	var htmlSrc = "" ;
	var htmlBase = '<img src="<%=request.getContextPath()%>/image/node/ins' ;
	for( var i = 1 ; i <= stat.length ; i++ ) {
		if( '1' == stat.charAt(i-1) ) {
			htmlSrc += htmlBase + i + 'Green.gif" />';
		} else {
			bAlarm = true ;
			htmlSrc += htmlBase + i + 'Red.gif" />';
			
			msg2 += '- ' + i + ' 번 인스턴스 에러!<BR>' ;
		}
	}
	instObj.innerHTML = htmlSrc;
	
	instLineObj = null ;
	instObj = null ;
	
	if( bAlarm == true ) {
		alarmSound( 'alert' );
		showAlarmMsg( idx, true, msg1, msg2 ); 
	}
}

function getMsgIdxByType(type) {
	if( type == 'EAI' ) {
		return 0 ;
	} else if( type == 'FEP' ) {
		return 2 ;
	} else if( type == 'BATCH' ) {
		return 4 ; 
	} else {
		return 0 ;
	}
}

function getMsgTitleByType(type) {
	if( type == 'EAI' ) {
		return '내부' ;
	} else if( type == 'FEP' ) {
		return '대외' ;
	} else if( type == 'BATCH' ) {
		return '일괄' ;
	} else {
		return '' ;
	}
}

function setCpuStatus( type, id, val ) {
	var cpuBar = getCpuBarObject(type, id);
	var cpuObj = getCpuObject( type, id);
	
	//purge(cpuBar);
	//purge(cpuObj);
	
	var bAlarm = false ;
	
	var p = Number(val);
	var clr = "" ;
	if( p >= 80 ) {
		clr = "barRed" ;
		bAlarm = true ;
	} else if( p >= 60 ) {
		clr = "barYellow" ;
	} else {
		clr = "barGreen" ;
	}
	
	var wp = ((p/10)+1) * 4 ;
	if( wp > 40 )
		wp = 40 ;
		
	cpuBar.className = clr ;
	cpuBar.style.width = "" + wp + "px" ;
	cpuObj.innerHTML = val;
	
	cpuBar = null;
	cpuObj = null;
	
	if( bAlarm == true ) {
		alarmSound( 'alert' );
	}
}

function setMemoryStatus( type, id, val ) {
	var memoryBar = getMemoryBarObject(type, id);
	var memoryObj = getMemoryObject( type, id);

	//purge(memoryBar);
	//purge(memoryObj);
	
	var bAlarm = false ;

	var p = Number(val);
	var clr = "" ;
	if( p >= 80 ) {
		clr = "barRed" ;
		bAlarm = true ;
	} else if( p >= 60 ) {
		clr = "barYellow" ;
	} else {
		clr = "barGreen" ;
	}
	
	var wp = ((p/10)+1) * 4 ;
	if( wp > 40 )
		wp = 40 ;
		
	memoryBar.className = clr ;
	memoryBar.style.width = "" + wp + "px" ;
	memoryObj.innerHTML = val;

	memoryBar = null ;
	memoryObj = null ;
	
	if( bAlarm == true ) {
		alarmSound( 'alert' );
	}
	
}

function setDiskStatus( type, id, val ) {
	var diskBar = getDiskBarObject(type, id);
	var diskObj = getDiskObject( type, id);

	//purge(diskBar);
	//purge(diskObj);

	var bAlarm = false ;

	var p = Number(val);
	var clr = "" ;
	if( p >= 80 ) {
		clr = "barRed" ;
		bAlarm = true ;
	} else if( p >= 60 ) {
		clr = "barYellow" ;
	} else {
		clr = "barGreen" ;
	}
	
	var wp = ((p/10)+1) * 4 ;
	if( wp > 40 )
		wp = 40 ;
		
	diskBar.className = clr ;
	diskBar.style.width = "" + wp + "px" ;
	diskObj.innerHTML = val;
	
	diskBar = null ;
	diskObj = null ;
	
	if( bAlarm == true ) {
		alarmSound( 'alert' );
	}
}

function setProcStatus( type, id, val ) {
	var procObj = getProcObject( type, id);

	//purge(procObj);

	val = commify(val);
	
	// 코마포함해서 123,456,789 이상이면 작은폰트	
	if( val.length > 10 ) {
		procObj.className = "conCountBox02" ;
	} else {
		procObj.className = "conCountBox" ;
	}
	
	procObj.innerHTML = val ;
	
	procObj = null ;
}




function setRTAdapterStatus( type, id, stat ) {
	var adapterObj = getRTAdapterObject(type, id);
	if( adapterObj == null ) {
		return ;
	}

	//purge(adapterObj);

	if( stat == "0" ) { // 에러
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallRed.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;
	} else if( stat == "1" ) { // 부분정상
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallYellow.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;
	} else if( stat == "2" ) { // 정상
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;	
	} else if ( stat == "3" ) { // 없음
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallGray.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;
	}
	
	adapterObj = null ;
}

function setAdapterStatus( type, id, stat ) {
	var adapterObj = getAdapterObject(type, id);
	if( adapterObj == null ) {
		return ;
	}

	//purge(adapterObj);

	if( stat == "0" ) { // 에러
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallRed.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;
	} else if( stat == "1" ) { // 부분정상
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallYellow.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;
	} else if( stat == "2" ) { // 정상
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallGreen.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;	
	} else if ( stat == "3" ) { // 없음
		adapterObj.innerHTML = '<img src="<%=request.getContextPath()%>/image/node/adapterBallGray.gif"  style=\"cursor:pointer\" align=\"right\"/>' ;
	}
	
	adapterObj = null ;
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

function setTopTime() {
	var timeObj = document.getElementById("topTime");
	if( timeObj != null ) {
	
		// opener.reopenDashboard();
	
		timeObj.innerHTML = getFormTime() ;
		
		
			var t = new Date();
			var hour  = t.getHours();
			var min   = t.getMinutes();
			var sec   = t.getSeconds();
			if( hour == 4 && min == 30 ) {
				if( sec == 20 || sec == 21 ) {
					opener.reopenDashboard();
				}
			}		
	}
	
	timeObj = null ;
}

function changeFullTrade() {
	var tradeBox    = document.getElementById("tradeBox");
	var tradeTable  = document.getElementById("tradeTable");
	var tradeButton = document.getElementById("tradeViewButton");
	
	var peekTable   = document.getElementById("peekTable");
	var smsTable    = document.getElementById("smsTable");


	//purge(tradeBox);
	//purge(tradeTable);
	//purge(tradeButton);
	//purge(peekTable);
	//purge(smsTable);


	if( isFullTrade == false ) {
		tradeBox.className = 'floatLeft tranBox01' ;
		
		tradeButton.src = "<%=request.getContextPath()%>/image/button/btnViewSmall.gif";
		tradeButton.alt = "원래 크기로 보기" ;
		
		tradeTable.innerHTML = getLargeTradeTable();
		
		peekTable.style.display = 'none';
		smsTable.style.display = 'none';
		isFullTrade = true ;
	} else {
		tradeBox.className = 'floatLeft tranBox' ;
		
		tradeButton.src = "<%=request.getContextPath()%>/image/button/btnViewBig.gif";
		tradeButton.alt = "크게보기" ;
		
		tradeTable.innerHTML = getSmallTradeTable();
		
		peekTable.style.display = 'inline-block';
		smsTable.style.display = 'block';
		isFullTrade = false ; 
	}
	
	tradeBox = null ;
	tradeTable = null ;
	tradeButton = null ;
	peekTable = null ;
	smsTable = null ;
}

function getLargeTradeTable() {
	var src = '<table class="tableBig2">' ;
	src +=	  '<tr>';
	src +=		'<th width="130px"><img src="<%=request.getContextPath()%>/image/label/tableTitle0101B.gif"  /></th>';
	src +=		'<th><img src="<%=request.getContextPath()%>/image/label/tableTitle0102B.gif" /></th>';
	src +=		'<th width="160px"><img src="<%=request.getContextPath()%>/image/label/tableTitle0103B.gif"  /></th>';
	src +=		'<th width="150px"><img src="<%=request.getContextPath()%>/image/label/tableTitle0104B.gif"  /></th>';
	src +=		'<th width="150px"><img src="<%=request.getContextPath()%>/image/label/tableTitle0105B.gif"  /></th>';
	src +=		'<th width="150px"><img src="<%=request.getContextPath()%>/image/label/tableTitle0106B.gif"  /></th>';
	src +=		'<th width="150px"><img src="<%=request.getContextPath()%>/image/label/tableTitle0107B.gif"  /></th>';
	src +=	  '</tr>';
	src +=	  '<tr>';
	src +=		'<td align="center"><span class="textGroup">내부</span></td>';
    src +=      '<td onclick="javascript:goMainMenu(\'transaction\', \'EAI\');" title="내부 거래현황" style="cursor:pointer" align="right"><span id="tranTable11">0</span></td>';
	src +=		'<td align="right"><span id="tranTable12">0</span></td>';
	src +=     '<td onclick="javascript:popupError(\'EAI\',\'TIMEOUT\',0);" title="타임아웃화면 팝업" style="cursor:pointer" align="right"><span id="tranTable13">0</span></td>';
	src +=		'<td align="right"><span id="tranTable14">0</span></td>';
	src +=     '<td onclick="javascript:popupError(\'EAI\',\'ERROR\',0);" title="에러화면 팝업" style="cursor:pointer" align="right"><span id="tranTable15">0</span></td>';
	src +=		'<td align="right"><span id="tranTable16">0</span></td>';
	src +=	  '</tr>';
	src +=	  '<tr class="second">';
	src +=		'<td align="center"><span class="textGroup">대외</span></td>';
	src +=		'<td onclick="javascript:goMainMenu(\'transaction\', \'FEP\');" title="대외 거래현황" style="cursor:pointer" align="right"><span id="tranTable21">0</span></td>';
	src +=		'<td align="right"><span id="tranTable22">0</span></td>';
	src +=		'<td onclick="javascript:popupError(\'FEP\',\'TIMEOUT\',0);" title="타임아웃화면 팝업" style="cursor:pointer" align="right"><span id="tranTable23">0</span></td>';
	src +=		'<td align="right"><span id="tranTable24">0</span></td>';
	src +=		'<td onclick="javascript:popupError(\'FEP\',\'ERROR\',0);" title="에러화면 팝업" style="cursor:pointer" align="right"><span id="tranTable25">0</span></td>';
	src +=		'<td align="right"><span id="tranTable26">0</span></td>';
	src +=	  '</tr>';
	src +=	  '<tr>';
	src +=		'<th class="sum"><img src="<%=request.getContextPath()%>/image/label/tableTitle0109B.gif"  /></th>';
	src +=		'<th class="sumRight"><span id="tranTable51">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable52">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable53">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable54">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable55">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable56">0</span></th>';
	src +=	  '</tr>';
	src +=	  '<tr class="second">';
// 	src +=		'<td onclick="javascript:goBatch(\'FEP\');" title="일괄전송" style="cursor:pointer" align="center"><span class="textGroup">일괄전송</span></td>';
	src +=		'<td align="center"><span class="textGroup">일괄전송</span></td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0111B.gif"  /></span>';
	src +=			'<span id="tranTable61" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0112B.gif"  /></span>';
	src +=			'<span id="tranTable62" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0113B.gif"  /></span>';
	src +=			'<span id="tranTable63" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0114B.gif"  /></span>';
	src +=			'<span id="tranTable64" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0115B.gif"  /></span>';
	src +=			'<span id="tranTable65" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0116B.gif"  /></span>';
	src +=			'<span id="tranTable66" class="floatRight">0</span>';
	src +=		'</td>';
	src +=	  '</tr>';
	src +=	  '<tr class="second"><!-- onclick="javascript:goBatch(\'EAI\');" style="cursor:pointer" -->';
	src +=		'<td align="center"><span class="textGroup">배치</span></td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0111B.gif"  /></span>';
	src +=			'<span id="tranTable71" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0112B.gif"  /></span>';
	src +=			'<span id="tranTable72" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0113B.gif"  /></span>';
	src +=			'<span id="tranTable73" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0114B.gif"  /></span>';
	src +=			'<span id="tranTable74" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0115B.gif"  /></span>';
	src +=			'<span id="tranTable75" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeftBig"><img src="<%=request.getContextPath()%>/image/label/tableTitle0116B.gif"  /></span>';
	src +=			'<span id="tranTable76" class="floatRight">0</span>';
	src +=		'</td>';
	src +=	  '</tr>';
	src +=    '</table>';
	
	return src ;
}

function getSmallTradeTable() {
	var src = '<table class="table00">' ;
	src +=	  '<tr>';
	src +=		'<th width="90"><img src="<%=request.getContextPath()%>/image/label/tableTitle0101.gif"  /></th>';
	src +=		'<th width="130"><img src="<%=request.getContextPath()%>/image/label/tableTitle0102.gif"  /></th>';
	src +=		'<th width="110"><img src="<%=request.getContextPath()%>/image/label/tableTitle0103.gif"  /></th>';
	src +=		'<th><img src="<%=request.getContextPath()%>/image/label/tableTitle0104.gif"  /></th>';
	src +=		'<th width="100"><img src="<%=request.getContextPath()%>/image/label/tableTitle0105.gif"  /></th>';
	src +=		'<th width="100"><img src="<%=request.getContextPath()%>/image/label/tableTitle0106.gif"  /></th>';
	src +=		'<th width="90"><img src="<%=request.getContextPath()%>/image/label/tableTitle0107.gif"  /></th>';
	src +=	  '</tr>';
	src +=	  '<tr>';
	src +=		'<td align="center"><span class="textGroup">내부</span></td>';
    src +=      '<td onclick="javascript:goMainMenu(\'transaction\', \'EAI\');" title="내부 거래현황" style="cursor:pointer" align="right"><span id="tranTable11">0</span></td>';
	src +=		'<td align="right"><span id="tranTable12">0</span></td>';
    src +=      '<td onclick="javascript:popupError(\'EAI\',\'TIMEOUT\',0);" title="타임아웃화면 팝업" style="cursor:pointer" align="right"><span id="tranTable13">0</span></td>';
	src +=		'<td align="right"><span id="tranTable14">0</span></td>';
    src +=      '<td onclick="javascript:popupError(\'EAI\',\'ERROR\',0);" title="에러화면 팝업" style="cursor:pointer" align="right"><span id="tranTable15">0</span></td>';
	src +=		'<td align="right"><span id="tranTable16">0</span></td>';
	src +=	  '</tr>';
	src +=	  '<tr class="second">';
	src +=		'<td align="center"><span class="textGroup">대외</span></td>';
	src +=		'<td onclick="javascript:goMainMenu(\'transaction\', \'FEP\');" title="대외 거래현황" style="cursor:pointer" align="right"><span id="tranTable21">0</span></td>';
	src +=		'<td align="right"><span id="tranTable22">0</span></td>';
	src +=		'<td onclick="javascript:popupError(\'FEP\',\'TIMEOUT\',0);" title="타임아웃화면 팝업" style="cursor:pointer" align="right"><span id="tranTable23">0</span></td>';
	src +=		'<td align="right"><span id="tranTable24">0</span></td>';
	src +=		'<td onclick="javascript:popupError(\'FEP\',\'ERROR\',0);" title="에러화면 팝업" style="cursor:pointer" align="right"><span id="tranTable25">0</span></td>';
	src +=		'<td align="right"><span id="tranTable26">0</span></td>';
	src +=	  '</tr>';

	src +=	  '<tr>';
	src +=		'<th class="sum"><img src="<%=request.getContextPath()%>/image/label/tableTitle0109.gif"  /></th>';
	src +=		'<th class="sumRight"><span id="tranTable51">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable52">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable53">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable54">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable55">0</span></th>';
	src +=		'<th class="sumRight"><span id="tranTable56">0</span></th>';
	src +=	  '</tr>';	
	src +=	  '<tr class="second">';
// 	src +=		'<td onclick="javascript:goBatch(\'FEP\');" title="일괄전송" style="cursor:pointer" align="center"><span class="textGroup">일괄전송</span></td>';
	src +=		'<td align="center"><span class="textGroup">일괄전송</span></td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0111.gif"  /></span>';
	src +=			'<span id="tranTable61" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0112.gif"  /></span>';
	src +=			'<span id="tranTable62" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0113.gif"  /></span>';
	src +=			'<span id="tranTable63" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0114.gif"  /></span>';
	src +=			'<span id="tranTable64" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0115.gif"  /></span>';
	src +=			'<span id="tranTable65" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">'; 
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0116.gif"  /></span>';
	src +=			'<span id="tranTable66" class="floatRight">0</span>';
	src +=		'</td>';
	src +=	  '</tr>';
	src +=	  '<tr class="second"><!-- onclick="javascript:goBatch(\'EAI\');" style="cursor:pointer" -->';
	src +=		'<td align="center"><span class="textGroup">배치</span></td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0111.gif"  /></span>';
	src +=			'<span id="tranTable71" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0112.gif"  /></span>';
	src +=			'<span id="tranTable72" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0113.gif"  /></span>';
	src +=			'<span id="tranTable73" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0114.gif"  /></span>';
	src +=			'<span id="tranTable74" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">';
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0115.gif"  /></span>';
	src +=			'<span id="tranTable75" class="floatRight">0</span>';
	src +=		'</td>';
	src +=		'<td align="right">'; 
	src +=			'<span class="floatLeft"><img src="<%=request.getContextPath()%>/image/label/tableTitle0116.gif"  /></span>';
	src +=			'<span id="tranTable76" class="floatRight">0</span>';
	src +=		'</td>';
	src +=	  '</tr>';
	src +=    '</table>';
	
	return src ;
}


function getAlarmMsgHtml( idx ) {
	            //<!-- 노드 간격 145px -->
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
	      												// <!-- 빨간색 경고창일때 -->
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

function goBatch( service ) {
	var url = '' ;
	
	if( service == 'FEP' ) {
		url = '<%=fepBatchUrl%>' ;
	} else if( service == 'EAI' ) {
		url = '<%=eaiBatchUrl%>' ;
	}
	
	window.open(url,service + 'BATCH');	
} // end goBatch

function goMainMenu( type, service, mod ) {
	var url = "<%=request.getContextPath()%>" ;
	
	if( type == "monitor" ) {
		url = url + "/main.do?serviceType=" + service ;
	} else if( type == "transaction" ) {
		url = url + "/main/adapter.do?adapterType=TRANSACTION&serviceType=" + service ;
	} else if( type == "rule" ) {
		url = url + "/main/adapter.do?adapterType=RULE&serviceType=" + service ;
	} else if( type == "status" && mod != null ) {
		url = url + "/main/adapter.do?adapterType=STATUS&mod=" + (mod == 1 ? 'ERR' : '24E') +"&serviceType=" + service ;
	} else if( type == "status" ) {
		url = url + "/main/adapter.do?adapterType=STATUS&serviceType=" + service ;
	} else {
		return ;
	}
	try {
		parent.opener.location.href = url ;
	} catch(e) {
		//alert(e);
		var tail = window.parent.name;
		tail = tail.substr(tail.length-1);
		var RMSOnline = window.open(url,'RMSOnline' + tail);
		RMSOnline.moveTo(0, 0);
		RMSOnline.resizeTo(screen.availWidth, screen.availHeight);
		
	}
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

function popupError(  svc, type, commDiv ) {
	var stats = 'toolbar=no'
	          + ',location=no'
	          + ',directories=no'
	          + ',status=no'
	          + ',menubar=no'
	          + ',dependent=yes'
	          + ',scrollbars=no'
	          + ',resizable=yes'
	          + ',width=1100'
	          + ',height=720' ;
	          //+ ',top=100'
	          //+ ',left=100'
	          
	logTime = getThisTime();
	          
	var win = window.open("<%=request.getContextPath()%>/dashboard2/popupError.do"
	                      + "?logTime=" + logTime
	                      + "&domainType=" + svc
	                      + "&commDiv=" + commDiv
	                      + "&errorType=" + type , 
	                       "rmsERROR", stats ); 
	
}

function convertPeekDay() {
	if( peekStat == "tps" ) {
		peekStat = "tran" ;
	} else {
		peekStat = "tps" ;
	}
	
	var objImg = document.getElementById('peekTitleImage');
	if( objImg == null ) {
		alert('image id 를 찾을수 없습니다.' );
		return ;
	}
	
	if( peekStat == "tps" ) {
		objImg.src = "<%=request.getContextPath()%>/image/label/title021.jpg" ;
	} else {
		objImg.src = "<%=request.getContextPath()%>/image/label/title022.jpg" ;		
	}
	
	objImg = null ;
	
	requestPeekInfo();
}


//-->
</script>
	</head>
<!--
****************************************************************************
* body 코드 start
****************************************************************************
-->
<body style="height:1024px; overflow:scroll">
<!------------------------------ 상단 영역 start ------------------------------>
<!-- top include Section start -->
		<table id="top">
			<tr>
			  <td width="25px;"></td>
				<td id="topLeft">
					<!--  style="background: transparent url(<%=request.getContextPath()%>/image/common/<%=NEW_TITLE%>) no-repeat top left;" -->
					<img src="<%=request.getContextPath()%>/image/common/<%=NEW_TITLE%>" width="243" height="92" style="margin:-18px;"/>
				</td>
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
						<a href="javascript:goMainMenu('status','EAI');" onfocus="blur();"><img src="../image/menu/subMenu0301Out.gif" alt="내부" border="0" onmouseover="this.src='../image/menu/subMenu0301Over.gif'" onmouseout="this.src='../image/menu/subMenu0301Out.gif'" /></a>
						<a href="javascript:goMainMenu('status','FEP');" onfocus="blur();"><img src="../image/menu/subMenu0302Out.gif" alt="대외" border="0" onmouseover="this.src='../image/menu/subMenu0302Over.gif'" onmouseout="this.src='../image/menu/subMenu0302Out.gif'" /></a>
						<!--a href="javascript:goMainMenu('rule','BATCH');" onfocus="blur();"><img src="../image/menu/subMenu0305Out.gif" alt="일괄전송" border="0" onmouseover="this.src='../image/menu/subMenu0305Over.gif'" onmouseout="this.src='../image/menu/subMenu0305Out.gif'" /></a-->
					</div>
				</td>
				<td class="topRight">
					<div id="topTime" class="time">2009.09.20(일) 12:20:30</div>
					<div class="quickLink">
						<a href="javascript:btnInitialize();" onfocus="blur();" title="초기화"><img src="<%=request.getContextPath()%>/image/button/btnResetOut.gif" alt="초기화" border="0" onmouseover="this.src='../image/button/btnResetOver.gif'" onmouseout="this.src='../image/button/btnResetOut.gif'" /></a>
						<a id="btnSoundOff" style="display: inline;" href="javascript:btnSoundOff();" onfocus="blur();" title="사운드끄기"><img src="<%=request.getContextPath()%>/image/button/btnSoundOnOut.gif" alt="사운드끄기" border="0" onmouseover="this.src='../image/button/btnSoundOnOver.gif'" onmouseout="this.src='../image/button/btnSoundOnOut.gif'" /></a>
						<a id="btnSoundOn" style="display: none;" href="javascript:btnSoundOn();" onfocus="blur();" title="사운드켜기"><img src="<%=request.getContextPath()%>/image/button/btnSoundOffOut.gif" alt="사운드켜기" border="0" onmouseover="this.src='../image/button/btnSoundOffOver.gif'" onmouseout="this.src='../image/button/btnSoundOffOut.gif'" /></a>
						<a href="javascript:btnPopupClose();" onfocus="blur();" title="팝업닫기"><img src="<%=request.getContextPath()%>/image/button/btnPopupCloseOut.gif" alt="팝업닫기" border="0" onmouseover="this.src='../image/button/btnPopupCloseOver.gif'" onmouseout="this.src='../image/button/btnPopupCloseOut.gif'" /></a>
						<a id="btnPopupOff" style="display: inline;" href="javascript:btnPopupOff();" onfocus="blur();" title="팝업끄기"><img src="<%=request.getContextPath()%>/image/button/btnPopupOnOut.gif" alt="팝업끄기" border="0" onmouseover="this.src='../image/button/btnPopupOnOver.gif'" onmouseout="this.src='../image/button/btnPopupOnOut.gif'" /></a>
						<a id="btnPopupOn" style="display: none;" href="javascript:btnPopupOn();" onfocus="blur();" title="팝업켜기"><img src="<%=request.getContextPath()%>/image/button/btnPopupOffOut.gif" alt="팝업켜기" border="0" onmouseover="this.src='../image/button/btnPopupOffOver.gif'" onmouseout="this.src='../image/button/btnPopupOffOut.gif'" /></a>
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
			<div class="moniBox02">
				<div class="moniBox04">
					<div class="moniBox05">
						<div class="moniBox07">
							<div class="moniBox03">
								<div class="moniBox08">
									<div class="moniBox06">
										<div class="moniBox01">
											<table>
												<tr valign="top">
													<td>
														<!-- 내부 모니터링 시작 -->
														<div class="channelBoxBg01">
															<div class="channelBoxRight01">
																<div class="channelBoxLeft">
																	<!-- 타이틀 -->
																	<div class="channelTitleBg">
																		<img
																			src="<%=request.getContextPath()%>/image/label/channelTitle01.gif" />
																	</div>
																	<!-- 노드 4개 시작 -->
																	<table><!-- table onclick="javascript:gosubpage('EAI');"-->
																		<tr>
																			<td width="50%">
																				<!-- 노드01 -->
																				<div id="hostEAIDisplay1" class="nodeSNone">
																				</div>
																			</td>
																			<td width="50%">
																				<!-- 노드02 -->
																				<div id="hostEAIDisplay2" class="nodeSNone">
																				</div>
																			</td>
																		</tr>
																	</table>
																	<!-- 노드 4개 끝 -->
																</div>
															</div>
														</div>
														<!-- 내부 모니터링 끝 -->
													</td>
													<td>
														<!-- 대외 모니터링 시작 -->
														<div class="channelBoxBg01">
															<div class="channelBoxRight01">
																<div class="channelBoxLeft">
																	<!-- 타이틀 -->
																	<div class="channelTitleBg">
																		<img
																			src="<%=request.getContextPath()%>/image/label/channelTitle02.gif" />
																	</div>
																	<!-- 노드 4개 시작 -->
																	<!-- table onclick="javascript:gosubpage('FEP');"-->
																	<table>
																		<tr>
																			<td width="50%">
																				<!-- 노드01 -->
																				<div id="hostFEPDisplay1" class="nodeSNone">
																				</div>
																			</td>
																			<td width="50%">
																				<!-- 노드02 -->
																				<div id="hostFEPDisplay2" class="nodeSNone">
																				</div>
																			</td>
																		</tr>
																	</table>
																	<!-- 노드 4개 끝 -->
																</div>
															</div>
														</div>
														<!-- 대외 모니터링 끝 -->
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 업무별 모니터링 끝 **************************** -->
			<!-- 거래처리 현황 시작 **************************** -->
			<div id="tradeBox" class="floatLeft tranBox">
				<div class="tableBoxBg01">
					<div class="tableBox02">
						<div class="tableBox04">
							<div class="tableBox05">
								<div class="tableBox07">
									<div class="tableBox031">
										<div class="tableBox081">
											<div class="tableBox06">
												<div class="tableBox01">
													<!-- 타이틀 -->
													<div class="floatLeft">
														<img
															src="<%=request.getContextPath()%>/image/bullet/titleIcon01.jpg" />
														&nbsp;
														<img
															src="<%=request.getContextPath()%>/image/label/title01.jpg"
															alt="거래처리현황" />
													</div>
													<span class="floatRight"><a
														href="javascript:changeFullTrade();" onfocus="blur();"><img
																id="tradeViewButton"
																src="<%=request.getContextPath()%>/image/button/btnViewBig.gif"
																alt="크게보기" />
													</a>
													</span>

													<!-- 테이블 -->
													<div id="tradeTable">
														<table class="table00">
															<tr>
																<th width="90">
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0101.gif" />
																</th>
																<th width="130">
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0102.gif" />
																</th>
																<th width="110">
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0103.gif" />
																</th>
																<th>
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0104.gif" />
																</th>
																<th width="100">
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0105.gif" />
																</th>
																<th width="100">
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0106.gif" />
																</th>
																<th width="90">
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0107.gif" />
																</th>
															</tr>
															<tr>
																<td align="center">
																	<span class="textGroup">내부</span>
																</td>
																<td onclick="javascript:goMainMenu('transaction', 'EAI');" 
                                                                    title="내부 거래현황" style="cursor:pointer" align="right">
																	<span id="tranTable11">0</span>
																</td>
																<td align="right">
																	<span id="tranTable12">0</span>
																</td>
																<td onclick="javascript:popupError('EAI','TIMEOUT',0);"
                                                                    title="타임아웃화면 팝업" style="cursor: pointer" align="right">
																	<span id="tranTable13">0</span>
																</td>
																<td align="right">
																	<span id="tranTable14">0</span>
																</td>
																<td  onclick="javascript:popupError('EAI','ERROR',0);" 
                                                                    title="에러화면 팝업" style="cursor: pointer" align="right">
																	<span id="tranTable15">0</span>
																</td>
																<td align="right">
																	<span id="tranTable16">0</span>
																</td>
															</tr>
															<tr class="second">
																<td align="center">
																	<span class="textGroup">대외</span>
																</td>
																<td onclick="javascript:goMainMenu('transaction', 'FEP');"
																    title="대외 거래현황" style="cursor:pointer" align="right">
																	<span id="tranTable21">0</span>
																</td>
																<td align="right">
																	<span id="tranTable22">0</span>
																</td>
																<td
																	onclick="javascript:popupError('FEP','TIMEOUT',0);"
																	title="타임아웃화면 팝업" style="cursor: pointer" align="right">
																	<span id="tranTable23">0</span>
																</td>
																<td align="right">
																	<span id="tranTable24">0</span>
																</td>
																<td onclick="javascript:popupError('FEP','ERROR',0);"
																	title="에러화면 팝업" style="cursor: pointer" align="right">
																	<span id="tranTable25">0</span>
																</td>
																<td align="right">
																	<span id="tranTable26">0</span>
																</td>
															</tr>
															<tr>
																<th class="sum">
																	<img
																		src="<%=request.getContextPath()%>/image/label/tableTitle0109.gif" />
																</th>
																<th class="sumRight">
																	<span id="tranTable51">0</span>
																</th>
																<th class="sumRight">
																	<span id="tranTable52">0</span>
																</th>
																<th class="sumRight">
																	<span id="tranTable53">0</span>
																</th>
																<th class="sumRight">
																	<span id="tranTable54">0</span>
																</th>
																<th class="sumRight">
																	<span id="tranTable55">0</span>
																</th>
																<th class="sumRight">
																	<span id="tranTable56">0</span>
																</th>
															</tr>
															<tr class="second">
<!-- 																<td onclick="javascript:goBatch('FEP');" -->
<!-- 																    title="일괄전송" style="cursor:pointer" align="center"> -->
																<td align="center">
																	<span class="textGroup">일괄전송</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0111.gif" />
																	</span>
																	<span id="tranTable61" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0112.gif" />
																	</span>
																	<span id="tranTable62" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0113.gif" />
																	</span>
																	<span id="tranTable63" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0114.gif" />
																	</span>
																	<span id="tranTable64" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0115.gif" />
																	</span>
																	<span id="tranTable65" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0116.gif" />
																	</span>
																	<span id="tranTable66" class="floatRight">0</span>
																</td>
															</tr>
															<tr class="second"><!-- onclick="javascript:goBatch('EAI');" style="cursor:pointer" -->
																<td align="center">
																	<span class="textGroup">배치</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0111.gif" />
																	</span>
																	<span id="tranTable71" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0112.gif" />
																	</span>
																	<span id="tranTable72" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0113.gif" />
																	</span>
																	<span id="tranTable73" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0114.gif" />
																	</span>
																	<span id="tranTable74" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0115.gif" />
																	</span>
																	<span id="tranTable75" class="floatRight">0</span>
																</td>
																<td align="right">
																	<span class="floatLeft"><img
																			src="<%=request.getContextPath()%>/image/label/tableTitle0116.gif" />
																	</span>
																	<span id="tranTable76" class="floatRight">0</span>
																</td>
															</tr>
														</table> </div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 거래처리 현황 끝 **************************** -->

			<!-- peak day 시작 **************************** -->
			<div id="peekTable" class="floatRight peakdayBox">
				<div class="tableBoxBg02">
					<div class="tableBox021">
						<div class="tableBox04">
							<div class="tableBox05">
								<div class="tableBox07">
									<div class="tableBox03">
										<div class="tableBox08">
											<div class="tableBox061">
												<div class="tableBox011">
													<!-- 타이틀 -->
													<div onclick="javascript:convertPeekDay();">
														<img src="<%=request.getContextPath()%>/image/bullet/titleIcon02.jpg" />
														&nbsp;
														<img id="peekTitleImage"
															src="<%=request.getContextPath()%>/image/label/title021.jpg"
															alt="Peak Day" />
													</div>
													<!-- 테이블 -->
													<table class="table01" style="margin-bottom:17px">
														<tr>
															<th width="65">
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0201.gif" />
															</th>
															<th width="90">
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0202.gif" />
															</th>
															<th>
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0203.gif" />
															</th>
															<th width="60">
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0204.gif" />
															</th>
														</tr>
														<tr>
															<td align="center">
																내부
															</td>
															<td align="center">
																<span id="peekTableEAI1"></span>
															</td>
															<td align="right">
																<span id="peekTableEAI2"></span>
															</td>
															<td align="right">
																<span id="peekTableEAI3"></span>
															</td>
														</tr>
														<tr class="second">
															<td align="center">
																대외
															</td>
															<td align="center">
																<span id="peekTableFEP1"></span>
															</td>
															<td align="right">
																<span id="peekTableFEP2"></span>
															</td>
															<td align="right">
																<span id="peekTableFEP3"></span>
															</td>
														</tr>
														<tr>
															<td align="center">
																일괄전송
															</td>
															<td align="center">
																<span id="peekTableBATCH1"></span>
															</td>
															<td align="right">
																<span id="peekTableBATCH2"></span>
															</td>
															<td align="right">
																<span id="peekTableBATCH3"></span>
															</td>
														</tr>
														<tr class="second">
															<td align="center">
																배치
															</td>
															<td align="center">
																<span id="peekTableEAI_BATCH1"></span>
															</td>
															<td align="right">
																<span id="peekTableEAI_BATCH2"></span>
															</td>
															<td align="right">
																<span id="peekTableEAI_BATCH3"></span>
															</td>
														</tr>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- peak day 끝 **************************** -->
			<!-- 장애통보현황 시작 **************************** -->
			<div id="smsTable" class="obstacleBox">
				<div class="tableBoxBg01">
					<div class="tableBox02">
						<div class="tableBox04">
							<div class="tableBox05">
								<div class="tableBox07">
									<div class="tableBox03">
										<div class="tableBox08">
											<div class="tableBox06">
												<div class="tableBox01" style="height: 390px;">
													<!-- 타이틀 -->
													<div>
														<img
															src="<%=request.getContextPath()%>/image/bullet/titleIcon01.jpg" />
														&nbsp;
														<img
															src="<%=request.getContextPath()%>/image/label/title03.jpg"
															alt="장애통보현황" />
													</div>
													<!-- 테이블 -->
													<table class="table01">
														<tr>
															<th width="90">
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0301.gif" />
															</th>
															<th width="130">
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0302.gif" />
															</th>
															<th width="110">
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0303T.gif" />
															</th>
															<th>
																<img
																	src="<%=request.getContextPath()%>/image/label/tableTitle0304.gif" />
															</th>
														</tr>
														<%for(int i=1; i<= 12;i++) { %>
														<tr <%=i%2 ==0 ?"class=\"second\"":"" %>>
															<td align="center">
																<span id="smsTable<%=i%>1"></span>
															</td>
															<td align="center">
																<span id="smsTable<%=i%>2"></span>
															</td>
															<td align="center">
																<span id="smsTable<%=i%>3"></span>
															</td>
															<td>
																<span id="smsTable<%=i%>4"></span>
															</td>
														</tr>
														<%} %>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 장애통보현황 끝 **************************** -->
		</div>
		<!-- 메인내용 끝 **************************** -->
		<!------------------------------ 중간 영역 end ------------------------------>

		<!------------------------------ 하단 영역 start ------------------------------>
		<!-- btm include Section Start -->
		<!-- btm include Section end-->	
		<!------------------------------ 하단 영역 end ------------------------------>

		<!-- 팝업  시작 **************************** -->
		<!-- 시스템상황판 시작 -->
		<!-- 시스템상황판 끝 -->

		<!-- 어댑터상황판 시작 -->
		<!-- 어댑터상황판 끝 -->
		<!-- 장애통보 상황판 시작 -->
		<div id="obstaclePopup1"
			style="display: none ; width: 238px; height: 60px; top: 140px; left: 165px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		<div id="obstaclePopup2"
			style="display: none ; width: 238px; height: 60px; top: 140px; left: 443px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		<div id="obstaclePopup3"
			style="display: none ; width: 238px; height: 60px; top: 140px; left: 750px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		<div id="obstaclePopup4"
			style="display: none ; width: 238px; height: 60px; top: 140px; left: 1035px; position: absolute; z-index: 700; visibility: visible;">
		</div>
		
		
		<!-- 장애통보 끝 -->
		<!-- 팝업 끝 **************************** -->


		<script>
	reqAjaxOut  = createAjaxRequest();
	reqAjaxIn   = createAjaxRequest();
	reqAjaxBatch= createAjaxRequest();
	
	reqAjaxTran = createAjaxRequest();
	reqAjaxPeek = createAjaxRequest();
	reqAjaxSms  = createAjaxRequest();
	
	reqAjaxSmsInit = createAjaxRequest();
	reqAjaxBaseInfo = createAjaxRequest();
	
	setTimeout("requestBaseInfo();", 100);
	setInterval("setTopTime();", 1000);
	setInterval("checkConnection();", 5000);
	
	// peekTable 보이지 않는 현상때문에 임시조치함
	isFullTrade = true;
	changeFullTrade();
	//showAlarmMsg(1,true,'테스트','고고고');
		</script>
	</body>
<embed src="<%=request.getContextPath()%>/common/sound/alert2.wav" name="player" hidden="true" autostart="false" width="1" height="1" />
	
<!--
****************************************************************************
* body 코드 end
****************************************************************************
-->
</html>