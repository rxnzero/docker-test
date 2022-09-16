<%@ page language="java" contentType="text/html; charset=euc-kr"
    pageEncoding="EUC-KR"%>
<%@page import="com.eactive.eai.rms.common.util.CommonConstants"%>
<%@page import="com.eactive.eai.common.util.SystemUtil"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Insert title here</title>
<script language="javascript" src="<%=request.getContextPath() %>/js/jquery-1.7.2.min.js"></script>
<script>
function goiim() {
	window.open('http://intf.jbbank.co.kr:12231/monitoring/');
	//window.open('http://intf.jbbank.co.kr:12231/monitoring/initech/login_exec.jsp');
}

function goPage(url){
	var service = $(":radio[name=serviceType]:checked").val();
	if( service == undefined ) {
		alert('���ý����� �����ϼ���.');
		return ;
	}
	var page=url+'&service=' + service;
	page = page + "&serviceType="+sessionStorage["serviceType"];
	
	location.href='<%=request.getContextPath() %>'+page;
}

<%
String OPS = SystemUtil.isDevServer()  ? CommonConstants.DB_MANAGE_TYPE_D : 
	           SystemUtil.isTestServer() ? CommonConstants.DB_MANAGE_TYPE_T :
		         SystemUtil.isProdServer() ? CommonConstants.DB_MANAGE_TYPE_P : "";
%>
function goDashboard() {	
	//top.location.replace("<c:url value="/gfm/dashboard/dashboard04.gfm" />");
	
	// You must open from parent window !
	var w = parent.window.open("<%=request.getContextPath()%>/dashboard2/dashboard.html", "RMSDASHBOARD<%=OPS%>", "width=1280,height=1024,left=0,top=0,scrollbars=yes,resizable=no,status=yes");
	w.focus();
}
</script>
<style>
#fBody{width:100%}
fieldset{width:1310px;margin:0 auto;}
legend{padding:0px 10px;margin:25px 16px 0px 16px ;font-size:26px;font-weight:bold;}
div{padding-left:15px;}
ul{list-style:none;flot:right;margin:0;padding:0;}

.FirstSitemap{background:url('./images/sitemap_start.gif');width:141px;height:45px;text-align:center;margin-left:127px;}
.FirstSitemap div{width:141px;height:45px;position:relative;top:12px;right:17px;font-weight:bold;}

.commant{flot:right;position:absolute;top:95px;margin-left:268px;padding-left:50px;background:url('./images/sitemap_cmt3.gif');background-repeat:no-repeat;width:146px;height:86px;}
.commant{text-align:left;color:#FF0000;font-weight:bold;font-size:small;padding-left:35px;padding-top:5px;}

.process{width:420px;border:solid 2px #C0C0C0;padding-top:13px;padding-bottom:10px;text-align:center;}
.lineDown{background:url('./images/sitemap_line.gif');width:10px;height:44px;margin-left:200px;}
.lineDow2{float:right;position:relative;background:url('./images/sitemap_line2.gif');width:220px;height:70px;top:-45px;right:665px;}
.lineDow4{float:left;position:relative;background:url('./images/sitemap_line4.gif');width:10px;height:321px;top:-322px;left:200px;}
.lineDow5{float:left;position:relative;background:url('./images/sitemap_line5.gif');width:206px;height:25px;top:-15px;}
.lineDow6{float:right;position:relative;background:url('./images/sitemap_line6.gif');width:436px;height:27px;top:31px;right:230px;}
.lineDow62{float:right;position:relative;background:url('./images/sitemap_line6.gif');width:436px;height:27px;right:669px;}
.lineDown7{float:left;position:relative;background:url('./images/sitemap_line7.gif');width:10px;height:104px;left:200px;top:-63px;}
.rSide1{position:relative;left:440px;}
.rSide2{position:relative;left:880px;}
.selY{position:relative;float:right;left:223px;top:-15px;background:url('./images/sitemap_line5.gif');width:206px;height:25px;}
.selY label{position:relative;top:-15px;left:-100px;}
.selN{position:relative;float:right;top:25px;left:25px;}
</style>
</head>

<body>
<div id="fBody">
<fieldset>
<div style="position:absolute;">
  <img src="./image/node/adapterBallYellow.gif" width="10" height="10" style="padding-right:5px;"/>
  <a href="javascript:goPage('/main.do?mainPage=${INIT_URL }');">�ʱ�ȭ������ �̵�</a>
  
  <% if ( "Y".equals((String)session.getAttribute(CommonConstants.MENUID_DASHBOARD))) { %>
  <div style="float:right;margin:-2px;"><img src="<%=request.getContextPath()%>/images/go_dashboard.gif" width="106" height="21"
	align="right" onclick="goDashboard()" alt="��ú��� ȭ������ �̵�" style="cursor:hand"></img></div>
  <% } %>
</div>

<legend>EAI/FEP �������̽� ��� ����</legend>

<ul>
<li class="FirstSitemap">
<div>
<input type="radio" name="serviceType" value="EAI"/> EAI
<input type="radio" name="serviceType" value="FEP"/> FEP
</div>
</li>
<li class="commant">��� �ý����� <br/>�ݵ�� �����ϼ���.</li>
<li class="lineDown"></li>
<li class="process" ><a href="javascript:goPage('/main.do?mainPage=/monitoring/gfm/transaction/extnl/extnlInterfaceMan.gfm');">�������̽� ��û �� ���</a></li>
<li class="lineDown"></li>
<li class="process" >Ÿ�� ��û �ŷ� �Ǵ� ��� ���� �ŷ��ΰ� ?<div class="selY"><label>Y</label></div><div class="selN"><label>N</label></div></li>
<li class="process  rSide1"><a href="javascript:goPage('/main.do?mainPage=/monitoring/gfm/admin/service/stdMessageMan.gfm');">ǥ������ ����� ����<br/>(ä������, �ŷ�����, �ڷ���ȣ ��)</a></li>
<li class="lineDown7"></li><li class="lineDow62"></li><li style="margin:40px;"></li>
<li class="process" >�������̾ƿ��� �ʿ��� ��� ?<div class="selY"><label>Y</label></div><div class="selN"><label>N</label></div></li>
<li class="process  rSide1"><a href="javascript:goiim()">�������̾ƿ� ��� �� ����<br/>(�����������̽� ȭ�� ���)</a></li>
<li class="lineDown rSide1"></li>
<li class="process  rSide1"><a href="javascript:goPage('/main.do?mainPage=/monitoring/gfm/admin/rule/layoutMan.gfm');">�������̾ƿ� ����Ȯ��<br/>(EAI/FEP ���� Ȯ��)</a></li>
<li class="lineDown rSide1"></li>
<li class="process  rSide1">������ �������̾ƿ� �׸�� ��� �Ǵ� �����ý���<br/> �������̾ƿ� �׸��� �����Ѱ� ?<div class="selY"><label>N</label></div><div class="selN"><label>Y</label></div></li>
<li class="lineDow6"></li>
<li class="process  rSide2"><a href="javascript:goPage('/main.do?mainPage=/monitoring/gfm/admin/rule/transformMan.gfm');">�������̾ƿ� ��ȯ���� ���</a></li>
<li class="lineDow4"></li><li class="lineDow2"></li>
<li class="process" ><a href="javascript:goPage('/main.do?mainPage=/monitoring/gfm/transaction/tracking/dbTrackingChart.gfm');">�������̽� �� �������̾ƿ� ���� Ȯ��</a></li>

<li class="lineDown"></li>
<li class="process" ><a href="javascript:goPage('/main.do?mainPage=/monitoring/gfm/transaction/online/transactionStatus.gfm');">�ŷ���Ȳ �� �αװ˻�</a></li>
</ul>
</fieldset>
</div>
</body>
<iframe src= "<%=request.getContextPath()%>/activeupdate/install.html" width="0px" height="0px"></iframe>
</html>