<%@ page contentType="text/html; charset=euc-kr"%>
this.attachEvent("onload", function(){
	var menuId = getParamValue("menuId");
	var AuthResult = getParamValue("AuthResult");
	var Auth = getParamValue("Auth");

	if( menuId != "" ){
		if(AuthResult == "ok"){				// ���� ��ȸ��  ��ư����κ�- �����ڰ� �� ���������� �����Ұ� 
			buttonControl(Auth);
		}else if(AuthResult == "fail"){	// ���� ��ȸ ���� 
			alert("�޴����̵�, ����� �������� �ʾ� ������ �����ü������ϴ�.");
			history.go(-1);
		}else{	// ���ʷε��� ���Ѱ������� �κ�
			//alert("menuId -> "+menuId);
			location.href ="/monitoring/common/jsp/menuRender.jsp?menuId="+menuId+"&thisPage=<%=request.getParameter("thisPage")%>";	
		}
	}else{
		alert("�޴����̵� �������� �ʾ� ������ �����ü������ϴ�.");
		return;
	}
});