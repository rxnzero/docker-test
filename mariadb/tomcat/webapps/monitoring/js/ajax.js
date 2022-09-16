// Create and return ajax communication object
function createAjaxRequest() {
	var reqAjax = null ;
	try {
		reqAjax = new XMLHttpRequest();
	} catch ( trymicrosoft ) {
		try {
			reqAjax = new ActiveXObject("Msxml2.XMLHTTP");
		} catch ( othermicrosoft ) {
			try {
				reqAjax = new ActiveXObject("Microsoft.XMLHTTP");
			} catch( failed ) {
				reqAjax = null ;
			}
		}
	}

	if( reqAjax == null ) {
		alert("Error creating request object!");
	}
	
	return reqAjax;
}

// Because memory leak
function purge(d) {
	/*
		var a = d.attributes, i, l, n;
	 
		if (a) {
			l = a.length;
			for (i = 0; i < l; i += 1) {
				n = a[i].name;
	 
				if (typeof d[n] === 'function') {
					d[n] = null;
				}
			}
		}
	 
		a = d.childNodes;
	 
		if (a) {
			l = a.length;
	 
			for (i = 0; i < l; i += 1) {
				purge(d.childNodes[i]);
			}
		}
	*/
}

// Insert comma per three bytes number
function commify(n) {
	  var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
	  n += '';                          // 숫자를 문자열로 변환
	
	  while (reg.test(n))
	    n = n.replace(reg, '$1' + ',' + '$2');
	
	  return n;
}

// Return number of comma string
function commanum(s) {	
	if( s == null || s == "" ) {
		return 0 ;
	}
	
	var re = /,/g;
	return parseInt(s.replace(re,""));
}


function toNumber(val) {
 var num = val.replace(/\,/gi, "");
 return Number(num);
}

// Fill zero left
function getLeftPadTime(n) {
	var s = n.toString(10);
	if( s.length == 1 ) {
		return "0" + s;
	}
	return s;
}

function getWeekStr(d) {
	var week;
	if( d == 0 ) {week = "일";}
	else if( d == 1 ) {week = "월";}
	else if( d == 2 ) {week = "화";}
	else if( d == 3 ) {week = "수";}
	else if( d == 4 ) {week = "목";}
	else if( d == 5 ) {week = "금";}
	else if( d == 6 ) {week = "토";}
	else {week = "";}
	return week;
}

function getFormTime() {
	var t = new Date();
	var year = t.getFullYear();
	var month = t.getMonth()+1;
	var date  = t.getDate();
	var week  = getWeekStr(t.getDay());
	var hour  = t.getHours();
	var min   = t.getMinutes();
	var sec   = t.getSeconds();
	
	month = getLeftPadTime(month);
	date  = getLeftPadTime(date);
	hour  = getLeftPadTime(hour);
	min   = getLeftPadTime(min);
	sec   = getLeftPadTime(sec);
	
	// 2009.09.20(일) 12:20:30
	return (year + "." + month + "." + date + "(" + week + ") " + hour + ":" + min + ":" + sec) ;	
}

function getThisTime() {
	var t = new Date();
	var hour = t.getHours();
	var min  = t.getMinutes();
	
	hour  = getLeftPadTime(hour);
	min   = getLeftPadTime(min);
	
	return ( hour + ":" + min );
}


function getServiceId( type, isFull ) {
	var ret = "" ;
	if( isFull == true ) {
		ret = "&service=" ;
	}
	return ret + type;
/*	
	var ret = "" ;
	if( isFull == true ) {
		ret = "&service=" ;
	}
	
	if( type == "Comm" ) {
		return ret + "INST3" ;
	} else if( type == "In" ) {
		return ret + "INST2" ;
	} else if( type == "Out" ) {
		return ret + "INST1" ;
	} else if( type == "Dmz" ) {
		return ret + "INST4" ;
	} else if( type == "Batch" ) {
		return ret + "INST5" ;
	}
	return null ;
*/	
}

function getDummyTime() {
	return "&t=" + ((new Date()).valueOf());
}

function formdate1( d ) {
	if( d.length == 8 ) {
		return d.substring(0,4) + '.' + d.substring(4,6) + '.' + d.substring(6);
	}
	return d ;
}

function formdate2( d ) {
	if( d.length == 14 ) {
		return d.substring(0,4) + '/' + d.substring(4,6) + '/' + d.substring(6,2) + ' ' + d.substring(8,10) + ':' + d.substring(10,12) + ':' + d.substring(12);
	}
	return d ;	
}


function rollingScore(objID, val, old) {
	var iter = 8;
	if( old == '' ) 
		old = '0' ;
	
	var currentScore = toNumber( old );
	var maxScore     = toNumber( val );
	var step = Math.round((maxScore-currentScore)/iter);	
	
	setScore(currentScore, maxScore, iter, step, objID, false);
}

function rollingScoreArrow(objID, val, old) {
	var iter = 8;
	if( old == '' ) 
		old = '0' ;
	
	old = old.replace('▲ ', '');
	
	var currentScore = toNumber( old );
	var maxScore     = toNumber( val );
	var step = Math.round((maxScore-currentScore)/iter);	
	
	setScore(currentScore, maxScore, iter, step, objID, true);
}


function setScore(currentScore, maxScore, iter, step, objID, arrow) {
	
	if(iter == 0) { 
		if(currentScore != maxScore) {
			//document.getElementById(objID).innerHTML = '▲ ' + commify(maxScore);
			updateScoreObj( objID, maxScore, arrow );
		}
		return;
	}
	
	if(currentScore >= maxScore) {
		//document.getElementById(objID).innerHTML = '▲ ' + commify(maxScore);
		updateScoreObj( objID, maxScore, arrow );
		return;
	}
	
	currentScore = Number(currentScore) + step;
	iter = iter - 1;
	window.setTimeout('setScore('+currentScore+','+maxScore+', '+iter+', '+step+', "'+objID+'", ' + arrow + ')', 50);
	
	//document.getElementById(objID).innerHTML = '▲ ' + commify(currentScore);
	updateScoreObj( objID, currentScore, arrow );
	
	/*
	alert("currentScore ="+currentScore
	+"\nmaxScore ="+maxScore
	+"\niter ="+iter
	+"\nstep ="+step);
	*/
}

function updateScoreObj( id, val, arrow ) {
	if( arrow == true && val > 0) {
		document.getElementById(id).innerHTML = '▲ ' + commify(val);		
	} else {
		document.getElementById(id).innerHTML = commify(val);
	}
}

function setArrowTextBody( obj, t ) {
	if( t == null || t == '' || t == '0' || t.charAt(0) == '-' ) {
		obj.innerText = commify(t) ;
	} else {
		obj.innerText = '↑ ' + commify(t) ;
	}
}
