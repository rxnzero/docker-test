<%@ page contentType="text/html; charset=euc-kr"%>
this.attachEvent("onload", function(){
	var menuId = getParamValue("menuId");
	var AuthResult = getParamValue("AuthResult");
	var Auth = getParamValue("Auth");

	if( menuId != "" ){
		if(AuthResult == "ok"){				// 권한 조회후  버튼제어부분- 개발자가 각 페이지에서 정의할것 
			buttonControl(Auth);
		}else if(AuthResult == "fail"){	// 권한 조회 실패 
			alert("메뉴아이디, 사번이 존재하지 않아 권한을 가져올수없습니다.");
			history.go(-1);
		}else{	// 최초로딩시 권한가져오는 부분
			//alert("menuId -> "+menuId);
			location.href ="/monitoring/common/jsp/menuRender.jsp?menuId="+menuId+"&thisPage=<%=request.getParameter("thisPage")%>";	
		}
	}else{
		alert("메뉴아이디가 존재하지 않아 권한을 가져올수없습니다.");
		return;
	}
});