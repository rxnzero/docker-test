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
	//http://test.kjbank.com:8080/se/login_exec.jsp : 꼭 도메인으로 호출해야 된다.
	//1.SSO ID 수신
	sso_id = getSsoId(request);
	
	// 2. UURL 수신
	uurl = request.getParameter("UURL");
	System.out.println(request.getRequestURI());
	System.out.println(request.getRequestURL());

	if (sso_id == null) {
		//uurl 이 없다면, 근데 여기서 uurl 은 뭘 체크하는거지? uurl 에 test.kjbank.com:8080/se/login_exec.jsp 를 넣는구나. 
//		if (uurl == null)	uurl = ASCP_URL+"?serviceType="+request.getParameter("serviceType");
		if (uurl == null)	uurl = ASCP_URL;
		
		// 3. SSO 인증 정보가 없으면 통합 로그인 페이지로 이동
		goLoginPage(response, uurl);
		return;
	} else {

		//4.쿠키 유효성 확인 :0(정상)
		retCode = getEamSessionCheck(request,response);
		
		if(!retCode.equals("0")){
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}
		/***********************************************************************************
		*	< TO-DO >
		*	SSO 통합 인증이 완료되었으므로, 업무 시스템 로그인은 건너뛰도록 코드를 수정합니다.
		*	SSO 에서 제공한 사번은 sso_id 변수에 저장되어 있습니다.
		*	시스템에서 필요로 하는 세션 정보를 세팅 코드를 여기에 작성합니다.
		************************************************************************************/

		//5 확장 정보 조회
		ext_info = getUserExField(sso_id, "CELLPHONENO");
		service_id = SERVICE_NAME;
		//System.out.println ("SERVICE_NAME : " + service_id);
		//
		//6.업무시스템에 읽을 사용자 아이디를 세션으로 생성
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
		//7.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
		//response.sendRedirect(SERVER_URL + ":" + SERVER_PORT + "/monitoring/login.do?serviceType="+serviceType);
		response.sendRedirect(SERVER_URL + ":" + SERVER_PORT + "/monitoring/choice.jsp");
	}
%>


