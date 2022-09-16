<%@ page contentType="text/html;charset=EUC-KR"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
<!-- [if IE], [endif] ���� �±׿� �پ��ִ� '!--' �� �ּ��� �ƴϴ� �������� �� ��. -->

<script language="javascript">
// 	document.write("<OBJECT ID=\"NEXESS_API\" CLASSID=\"CLSID:D4F62B67-8BA3-4A8D-94F6-777A015DB612\" width=0 height=0></OBJECT>");
	var NEXESS_API= new ActiveXObject("IniNXClient.NClient.1");
	
	////////////////////////////////////////////////////////////////////////////////
	//Ŭ���̾�Ʈ Ʈ���� �޴��� ���α׾ƿ��� �޴��� �۵����θ� ���� �Ѵ�.
	//! ���ڸ� ���ڷ� �̷����
	//       ù��°�ڸ��� ����
	//                0:�α׾ƿ� �ұ��?��� ���� �ʴ´�.
	//                1:�α׾ƿ� �ұ��?��� ���´�.
	//       �ι�°�ڸ��� ����
	//                0:�ƹ��͵� ���� �ʴ´�.
	//                1:�α׾ƿ��� ������ �� Kill
	//                3:�α׾ƿ��� ��� Kill
	//                4:�α׾ƿ��� �������� �����϶�� �޽����ڽ�
	//
	//       ����°�ڸ��� ����
	//                0 : �α׾ƿ� �޴� ��Ȱ��ȭ
	//                1 : �α׾ƿ� �޴� Ȱ��ȭ.
	////////////////////////////////////////////////////////////////////////////////
	/*������ ��ü�� �ݾƹ���*/
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

