<%@ page contentType="text/html;charset=EUC-KR"%>
<%@ page language="java" buffer="8kb" %>
<%@ page autoFlush="true" isErrorPage="false" %>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>

<c:url value="/common/image" var="imageUrl" />

<html>
<head>
<title>Calendar</title>
<META http-equiv=Content-Type content="text/html; charset=euc-kr">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<style type="text/css">
    <!--
      a.:link    {  color:#000000; text-decoration:none;  font-family:돋움,verdana; }
      a.:visited {   color:#000000; text-decoration:none;  font-family:돋움, verdana; }
      a.:hover   {   color:#000000; text-decoration:underline;  font-family:돋움, verdana;   }
      .sun {color:#FF0000; text-decoration:none;  font-family:돋움,verdana;}
      .sat {color:blue; text-decoration:none;  font-family:돋움,verdana;}
      .nm  {color:#000000; text-decoration:none;  font-family:돋움,verdana;}
      .text { font-size: 9pt; color: #000000; font-family: "돋움", "Verdana"; }
      .text1 { font-size: 9pt; color: #000000; font-family: "돋움", "Verdana"; }
      .text12 { font-size: 12pt; color: #000000; font-family: "돋움", "Verdana"; font-weight: bold; }
    -->
    </style>

<Script Language="JavaScript">
      this.focus();
      var now = new Date();
      var nowYear = now.getYear(); 
      var nowMonth = now.getMonth()+1;
      var nowDay = now.getDate();
      var defaultDate = nowYear+"-"+nowMonth+"-"+nowDay;//+" 00:00:00.0";
      now = null;

      function leapYear(year) {
        if (year % 4 == 0){
          return true;
        }
        return false;
      }

      function getDays(month, year) {
        var ar = new Array(12);
        ar[0] = 31;
        ar[1] = (leapYear(year)) ? 29 : 28;
        ar[2] = 31;
        ar[3] = 30;
        ar[4] = 31;
        ar[5] = 30;
        ar[6] = 31;
        ar[7] = 31;
        ar[8] = 30;
        ar[9] = 31;
        ar[10] = 30;
        ar[11] = 31;
        return ar[month];
      }

      function setCalendar(year,month,day){
        nowYear = year;
        nowMonth = month;
        nowDay = day;
        var nextMonth = month + 1;
        var prevMonth = month - 1;
        var nextYear = year;
        var prevYear = year;

        if (nextMonth > 12){
          nextMonth = 1;
          nextYear = nextYear + 1;
        }

        if (prevMonth < 1){
          prevMonth = 12;
          prevYear = prevYear - 1;
        }
        var text = "";

        text += '<table width="280" border="0" cellpadding="0" cellspacing="0">';
        text += '<tr>';
        text += '<td height="51" background="<c:out value="${imageUrl}" />/cal_top_bg.gif" align=center>';
        text += '<table border="0" cellspacing="0" cellpadding="0">';
        text += '<tr>';
        text += '<td align="center" valign="middle"><img src="<c:out value="${imageUrl}" />/cal_prev.gif" width="17" height="15" border="0" onclick="javascript:setCalendar('+ (year - 1) +','+ month +',0)" style="cursor:hand"></td>';
        text += '<td valign="middle" nowrap width=55 align=center><span class="text12">'+ year +'</span><span class="text1"><font color="#000000">년</font></span></td>';
        text += '<td align="center" valign="middle"><img src="<c:out value="${imageUrl}" />/cal_next.gif" width="17" height="15" border="0" onclick="javascript:setCalendar('+ (year + 1) +','+ month +',0)" style="cursor:hand"></td>';
        text += '<td valign="middle">&nbsp;</td>';
        text += '<td align="center" valign="middle"><img src="<c:out value="${imageUrl}" />/cal_prev.gif" width="17" height="15" border="0" onclick="javascript:setCalendar('+ prevYear +','+ prevMonth +',0)" style="cursor:hand"></td>';
        text += '<td valign="middle" width=35 align=center><span class="text12">'+ month +'</span><span class="text1"><font color="#000000">월</font></span></td>';
        text += '<td align="center" valign="middle"><img src="<c:out value="${imageUrl}" />/cal_next.gif" width="17" height="15" border="0" onclick="javascript:setCalendar('+ nextYear +','+ nextMonth +',0)" style="cursor:hand"></td>';
        text += '</tr></table></td></tr><tr><td><img src="<c:out value="${imageUrl}" />/cal_day.gif" width="280" height="23"></td></tr>';
        text += '<tr><td bgcolor="#FFFFFF"><table width="280" border="0" cellspacing="0" cellpadding="0">';

        var firstDayInstance = new Date(year, month-1, 1);
        var firstDay = firstDayInstance.getDay() + 1;
        var lastDay = getDays(month-1, year);

        firstDayInstance = null;
        drawCal(firstDay, lastDay, day, text);
      }

      function drawCal(firstDay, lastDate, day, text) {
        var digit = 1;
        var curCell = 1;
        
        for (var row = 1; row <= Math.ceil((lastDate + firstDay - 1) / 7); ++row) {
          text += '<tr>';
          text += '<td bgcolor="B7B7B7"><img src="<c:out value="${imageUrl}" />/space.gif" width="1" height="1"></td>';
          text += '</tr>';
          text += '<tr>';
          text += '<td background="<c:out value="${imageUrl}" />/cal_line_01.gif">';
          text += '<table width="280" height="25" border="0" cellpadding="0" cellspacing="0">';
          text += '<tr align="center" valign="middle" class="text">';

          for (var col = 1; col <= 7; ++col) {
            if (curCell < firstDay) {
              text += '<td class="nm" width="40">&nbsp;</td>';
              curCell++;
            }else if ( digit > lastDate){
              text += '<td class="nm" width="40">&nbsp;</td>';
            }else{

              if (nowYear+"-"+nowMonth+"-"+digit == defaultDate) {
                //아래에 나오는 것은 현재 날짜입니다...
                text += '<td width="40" bgcolor="#87CEEB" style="cursor:hand" onClick="javascript:init('+ digit +');">' + digit + '</td>';
              }else{
                
                if(col==1){
                  text += '<td class="sun" style="cursor:hand" width="40" onmouseover="this.style.backgroundColor=\'#87CEEB\'" onmouseout="this.style.backgroundColor=\'\'" onClick="javascript:init('+ digit +');">' + digit + '</td>';
                
                }else if(col==7){
                  text += '<td class="sat" style="cursor:hand" width="40" onmouseover="this.style.backgroundColor=\'#87CEEB\'" onmouseout="this.style.backgroundColor=\'\'" onClick="javascript:init('+ digit +');">' + digit + '</td>';

                }else{
                  text += '<td class="nm" style="cursor:hand" width="40" onmouseover="this.style.backgroundColor=\'#87CEEB\'" onmouseout="this.style.backgroundColor=\'\'" onClick="javascript:init('+ digit +');">' + digit + '</td>';
                }
              }
              digit++;
            } // if end
          } // for end

          text += '</tr></table></td></tr>';

          if (digit > lastDate){
            break;
          }
        } // for end

        for(var blrow=row; blrow <= 5; blrow++){
          text += '<tr>';
          text += '<td bgcolor="B7B7B7"><img src="<c:out value="${imageUrl}" />/space.gif" width="1" height="1"></td>';
          text += '</tr>';
          text += '<tr>';
          text += '<td background="<c:out value="${imageUrl}" />/cal_line_01.gif">';
          text += '<table width="280" height="25" border="0" cellpadding="0" cellspacing="0">';
          text += '<tr align="center" valign="middle" class="text">';
          text += '<td class="nm" width="40">&nbsp;</td>';
          text += '<td class="nm" width="40">&nbsp;</td>';
          text += '<td class="nm" width="40">&nbsp;</td>';
          text += '<td class="nm" width="40">&nbsp;</td>';
          text += '<td class="nm" width="40">&nbsp;</td>';
          text += '<td class="nm" width="40">&nbsp;</td>';
          text += '<td class="nm" width="40">&nbsp;</td>';
          text += '</tr></table></td></tr>';
        }

        text += '</table></td><tr><td bgcolor="B7B7B7"><img src="<c:out value="${imageUrl}" />/space.gif" width="1" height="1"></td></tr></table></body></html>';
        cal.innerHTML=text;
      }

      function init(dd){
        var sMonth = "0" + nowMonth.toString();
        var sDD = "0" + dd.toString();
        if(sMonth.length > 2){ sMonth = sMonth.substring(1) };
        if(sDD.length > 2){ sDD = sDD.substring(1) };
        var sDate = nowYear+"-"+sMonth+"-"+sDD ;//+" 00:00:00.0";
        opener.setDate(sDate);
        window.close();
      }
    </Script>
</head>
<body bgcolor="EDEDED" leftmargin="0" topmargin="0" marginwidth="0"
  marginheight="0">
<span id="cal"></span>
<script Language="JavaScript">
  setCalendar(nowYear,nowMonth,nowDay);
</script>
</body>
</html>
