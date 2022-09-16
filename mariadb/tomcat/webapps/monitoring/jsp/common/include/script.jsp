<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>

<c:set var="locale" value="<%= localeMessage.getLocale() %>" />

<script language="javascript" src="<c:url value="/js/jquery-1.12.1.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jquery-ui.js"/>"></script>
<%-- <script language="javascript" src="<c:url value="/js/jquery-ui.min.js"/>"></script> --%>
<script language="javascript" src="<c:url value="/js/grid.locale-${locale}.js"/>" ></script>
<script language="javascript" src="<c:url value="/js/prefixfree.min.js"/>"></script>

 <script type="text/javascript">
jQuery.browser = {};
(function () {
    jQuery.browser.msie = false;
    jQuery.browser.version = 0;
    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
        jQuery.browser.msie = true;
        jQuery.browser.version = RegExp.$1;
    }
})();
</script>

 

<script language="javascript" src="<c:url value="/js/jquery.jqGrid.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jquery.form.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jquery.contextMenu.js"/>"></script>
<script language="javascript" src="<c:url value="/js/custom.js"/>"></script>
<script language="javascript" src="<c:url value="/js/common-${locale}.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jquery.inputmask.bundle-4.0.3.min_custom.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jquery.searchabledropdown-1.0.8.min.js"/>"></script>
<%-- <script language="javascript" src="<c:url value="/js/jquery.searchable-1.1.0.min.js"/>"></script> --%>
<script language="javascript" src="<c:url value="/js/Nwagon.js"/>"></script>



<script language="javascript" >
function buttonControl(){
	if (arguments.length == 0){
		$("img[level]").hide();
		if ("${rmsMenuAuth}" =="W"){
			$("img[level='W']").show();
			$("img[level='R']").show();
		}else if ("${rmsMenuAuth}" =="R"){
			$("img[level='R']").show();
			$("tr[level='W']").hide();
		}
	} else if (arguments.length == 1){
		var isStatus = false;
		if (isBoolean(arguments[0])){
			isStatus = arguments[0];
		}else{
			if (arguments[0] != "" && arguments[0] !="null"){
				isStatus = true;
			}else{
				isStatus = false;
			}
		}
		var sel = "";
		if (isStatus){
			//detail
			sel = "DETAIL";
		}else{
			//new
			sel = "NEW";
			$("#btn_modify").attr('src',"<c:url value='/img/btn_regist.png'/>");
		}	
		$("img[level]").hide();
		if ("${rmsMenuAuth}" =="W"){
			$("img[level='W'][status*="+sel+"]").show();
			$("img[level='R'][status*="+sel+"]").show();
		}else if ("${rmsMenuAuth}" =="R"){
			$("img[level='R'][status*="+sel+"]").show();
			$("tr[level='W']").hide();
		}		
	}
}
function getSearchUrlForReturn(){
	var array = [];
	<c:forEach var="pageParameter" items="${param}">
		<c:if test="${fn:startsWith(pageParameter.key,'search')}">
	array.push('<c:out value="${pageParameter.key}" />'+"="+'<c:out value="${pageParameter.value}" />');
		</c:if>
	</c:forEach>
	<c:forEach var="pageParameter" items="${param}">
		<c:if test="${fn:startsWith(pageParameter.key,'like')}">
	array.push('<c:out value="${pageParameter.key}" />'+"="+'<c:out value="${pageParameter.value}" />');
		</c:if>
	</c:forEach>
	return array.join("&");	
}
function getReturnUrlForReturn(search){
	var returnUrl = '${param.returnUrl}';
	returnUrl = returnUrl + '?cmd='+'LIST';
	returnUrl = returnUrl + '&page='+'${param.page}';
	returnUrl = returnUrl + '&menuId='+'${param.menuId}';
	returnUrl = returnUrl + '&sortName='+'${param.sortName}';
	returnUrl = returnUrl + '&sortOrder='+'${param.sortOrder}';
	//검색조건
	returnUrl = returnUrl + '&'+ getSearchUrlForReturn();
	return returnUrl;
}
function getReloadUrl(cmd){
	var returnUrl = '${param.returnUrl}';
	returnUrl = returnUrl + '?cmd='+cmd;
	returnUrl = returnUrl + '&page='+'${param.pages}';
	returnUrl = returnUrl + '&menuId='+'${param.menuId}';
	//검색조건
	returnUrl = returnUrl + '&'+ getSearchUrlForReturn();
	return returnUrl;
}
function putSelectFromParam(){
	var array = [];
	<c:forEach var="pageParameter" items="${param}">
		<c:if test="${fn:startsWith(pageParameter.key,'search')}">
		var name = "${pageParameter.key}";
		var value = "${pageParameter.value}"
		
		$("select[name="+name+"]").val(value);
		$("input[name="+name+"]").val(value);
		</c:if>
	</c:forEach>

}
function getMenuId(){
	return '${param.menuId}';
}
var $ = jQuery.noConflict();
$(document).keydown(function(e){
	var element = e.target.nodeName.toLowerCase();
	if (element !='input' && element != 'textarea'){
		if(e.keyCode ===8){
			return false;
		}
	}
})

</script>
