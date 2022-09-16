<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ include file="./config.jsp" %>
<%
	String serviceType = null;
	serviceType = request.getParameter("serviceType");


	String uurl = null;
	String sso_id = null;
	String service_id = null;
	String ext_info = null;
	String retCode = null;
	//http://test.kjbank.com:8080/se/login_exec.jsp : �� ���������� ȣ���ؾ� �ȴ�.
	//1.SSO ID ����
	sso_id = getSsoId(request);
	
	// 2. UURL ����
	uurl = request.getParameter("UURL");
	System.out.println(request.getRequestURI());
	System.out.println(request.getRequestURL());

	if (sso_id == null) {
		//uurl �� ���ٸ�, �ٵ� ���⼭ uurl �� �� üũ�ϴ°���? uurl �� test.kjbank.com:8080/se/login_exec.jsp �� �ִ±���. 
//		if (uurl == null)	uurl = ASCP_URL+"?serviceType="+request.getParameter("serviceType");
		if (uurl == null)	uurl = ASCP_URL;
		
		// 3. SSO ���� ������ ������ ���� �α��� �������� �̵�
		goLoginPage(response, uurl);
		return;
	} else {

		//4.��Ű ��ȿ�� Ȯ�� :0(����)
		retCode = getEamSessionCheck(request,response);
		
		if(!retCode.equals("0")){
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}
		/***********************************************************************************
		*	< TO-DO >
		*	SSO ���� ������ �Ϸ�Ǿ����Ƿ�, ���� �ý��� �α����� �ǳʶٵ��� �ڵ带 �����մϴ�.
		*	SSO ���� ������ ����� sso_id ������ ����Ǿ� �ֽ��ϴ�.
		*	�ý��ۿ��� �ʿ�� �ϴ� ���� ������ ���� �ڵ带 ���⿡ �ۼ��մϴ�.
		************************************************************************************/

		//5 Ȯ�� ���� ��ȸ
		ext_info = getUserExField(sso_id, "CELLPHONENO");
		service_id = SERVICE_NAME;
		//System.out.println ("SERVICE_NAME : " + service_id);
		//
		//6.�����ý��ۿ� ���� ����� ���̵� �������� ����
 		//String EAM_ID = (String)session.getAttribute("SSO_ID");
 		if(!sso_id.replaceFirst(" ", "").equals(""))
 			session.setAttribute("SSO_ID", sso_id);
		
		/*
		if(sso_id == null || sso_id.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
			session.setAttribute("APP_ID", service_id);
			session.setAttribute("EXT_INFO", ext_info);
			session.setAttribute("RET_CODE", retCode);
		}
		*/
		//7.�����ý��� ������ ȣ��(���� ������ �Ǵ� ���������� ����)  --> �����ý��ۿ� �°� URL ����!
		//response.sendRedirect(SERVER_URL + ":" + SERVER_PORT + "/monitoring/login.do?serviceType="+serviceType);
		response.sendRedirect(SERVER_URL + ":" + SERVER_PORT + "/monitoring/choice.jsp");
	}
%>


