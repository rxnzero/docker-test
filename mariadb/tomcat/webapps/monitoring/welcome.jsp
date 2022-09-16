<%@ page contentType="text/html;charset=EUC-KR"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
<!-- [if IE], [endif] 등의 태그에 붙어있는 '!--' 는 주석이 아니니 삭제하지 말 것. -->

<script language="javascript">
// 	document.write("<OBJECT ID=\"NEXESS_API\" CLASSID=\"CLSID:D4F62B67-8BA3-4A8D-94F6-777A015DB612\" width=0 height=0></OBJECT>");
	var NEXESS_API= new ActiveXObject("IniNXClient.NClient.1");
	
	////////////////////////////////////////////////////////////////////////////////
	//클라이언트 트레이 메뉴중 “로그아웃” 메뉴의 작동여부를 결정 한다.
	//! 세자리 숫자로 이루어짐
	//       첫번째자리의 숫자
	//                0:로그아웃 할까요?라고 묻지 않는다.
	//                1:로그아웃 할까요?라고 묻는다.
	//       두번째자리의 숫자
	//                0:아무것도 하지 않는다.
	//                1:로그아웃시 브라우저 만 Kill
	//                3:로그아웃시 모두 Kill
	//                4:로그아웃시 브라우저를 종료하라는 메시지박스
	//
	//       세번째자리의 숫자
	//                0 : 로그아웃 메뉴 비활성화
	//                1 : 로그아웃 메뉴 활성화.
	////////////////////////////////////////////////////////////////////////////////
	/*브라우저 전체를 닫아버림*/
	function logout(){
		var is_installed = (typeof(NEXESS_API.isLogin) == "unknown") ? true : false;
		if (is_installed==true) {
			var result = NEXESS_API.LogoutWithOption(111);
		}else{
			return false;
		}
	}


	function checkSsoClient () {
		var is_installed = (typeof(NEXESS_API.Login) == "unknown")?true:false;
		if (is_installed == false) {
			 alert("<%= localeMessage.getString("welcome.ncFailMsg") %>");
		}
		return is_installed;
	}

	function checkND(){
		var isND = false;
		if(checkSsoClient()){
			isND = NEXESS_API.IsNDOK();
			if (isND == false) {
				 alert("<%= localeMessage.getString("welcome.ndFailMsg") %>");
			}
		}
		return isND;
	}

	function checkNLS(){
		var isNLS = false;
		if(checkSsoClient()){
			isNLS = NEXESS_API.IsNLSOK();
			if (isNLS == false) {
				 alert("<%= localeMessage.getString("welcome.nlsFailMsg") %>");
			}
		}
		return isNLS;
	}
	function check(){
		if (checkND() && checkNLS()){
			window.location ="/monitoring/initech/login_exec.jsp";
		}else{
			window.location ="/monitoring/login.jsp";	
		}
	}
	check();
</script> 

