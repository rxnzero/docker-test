<%@ page
	import="sun.misc.*,
			java.util.*,
			java.math.*,
			java.net.*,
			com.initech.eam.nls.*,
			com.initech.eam.api.*,
			com.initech.eam.base.*,
			com.initech.eam.nls.command.*,
			com.initech.eam.smartenforcer.*,
			examples.api.*"
%>
<%@page import="com.initech.eam.nls.CookieManager"%>
<%!
/**[INISAFE NEXESS JAVA AGENT]**********************************************************************
* �����ý��� ���� ���� (���� ȯ�濡 �°� ����)
***************************************************************************************************/


/***[SERVICE CONFIGURATION]***********************************************************************/
	static private String SERVICE_NAME = "";
	static private String SERVER_URL   = "";
	static private String SERVER_PORT  = "";
	static private String SERVICE_TYPE = "";
	
	
	static{
	      if (com.eactive.eai.common.util.SystemUtil.isProdServer() ){
    		SERVICE_NAME = "eai";
    		SERVER_URL   = "http://eai.kjbank.com";
    		SERVER_PORT  = "10910";
    	  } else if (com.eactive.eai.common.util.SystemUtil.isDevServer() ){
    		SERVICE_NAME = "deai";
    		SERVER_URL   = "http://deai.kjbank.com";
    		SERVER_PORT  = "10220";
    	  } else if (com.eactive.eai.common.util.SystemUtil.isTestServer() ){
    		SERVICE_NAME = "teai";
    		SERVER_URL   = "http://teai.kjbank.com";
    		SERVER_PORT  = "10420";
    	  }
  	}
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/monitoring/initech/login_exec.jsp";
	
	
/*************************************************************************************************/


/***[SSO CONFIGURATION]**]***********************************************************************/
	static private String NLS_URL 	 = "";
	static private String NLS_PORT 	 = "";
	
	static{
//	      if (com.eactive.eai.common.util.SystemUtil.isProdServer() ){
//   		NLS_URL  = "http://sso.kjbank.com";
//    		NLS_PORT = "13890";
//    	  } else {
//     		NLS_URL = "http://dsso.kjbank.com";
//     		NLS_PORT = "13290";
    		NLS_URL = "http://sso.kjbank.com";
    		NLS_PORT = "13890";
 //   	  }    	
  	}	
	private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin.jsp";
	private String NLS_LOGOUT_URL= NLS_URL + ":" + NLS_PORT + "/nls3/NCLogout.jsp";
	private String NLS_ERROR_URL = NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";
	
/***[SSO ND LIST ����]**]***********************************************************************	
	private static String ND_URL1 = "http://172.31.32.111:5480";
***********************************************************************************************/

/***[SSO ND LIST �]**]***********************************************************************/	
// 	private static String ND_URL1 = "http://172.22.3.10:5480";
	private static String ND_URL1 = "http://sso.kjbank.com:5480";
		
	private static Vector PROVIDER_LIST = new Vector();

	private static final int COOKIE_SESSTION_TIME_OUT = 3000000;

	// ���� Ÿ�� (ID/PW ��� : 1, ������ : 3)
	private String TOA = "1";
	private String SSO_DOMAIN = ".kjbank.com";

	private static final int timeout = 15000;
	private static NXContext context = null;
	static{
		List<String> serverurlList = new ArrayList<String>();
		serverurlList.add(ND_URL1);

		context = new NXContext(serverurlList,timeout);
		CookieManager.setEncStatus(true);

// 		PROVIDER_LIST.add("dsso.kjbank.com");
		PROVIDER_LIST.add("sso.kjbank.com");
		//NLS3 web.xml�� CookiePadding ���� ���ƾ� �Ѵ�. �ȱ׷� ���� ���ϳ�
		SECode.setCookiePadding("_V42");
	}
	
	// by Kang
		public NXContext getContext()
		{
			NXContext context = null;
			try
			{
				List serverurlList = new ArrayList();
				serverurlList.add(ND_URL1);
				context = new NXContext(serverurlList);
				CookieManager.setEncStatus(true);

// 				PROVIDER_LIST.add("dsso.kjbank.com");
				PROVIDER_LIST.add("sso.kjbank.com");
				//NLS3 web.xml�� CookiePadding ���� ���ƾ� �Ѵ�. �ȱ׷� ���� ���ϳ�
				SECode.setCookiePadding("_V42");
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}		
			return context;
		}

	// ���� SSO ID ��ȸ
	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;
		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		return sso_id;
	}
	
	public String getSystemAccount(String sso_id) {
		NXContext context = null;
		NXUserAPI userAPI = null;
		String retValue = null;

		try {
			context = getContext();
			userAPI = new NXUserAPI(context);
			//System.out.println("##############################################");
			//System.out.println("sso_id 2: "+sso_id);
			//System.out.println("SERVICE_NAME : "+SERVICE_NAME);
			//System.out.println("##############################################");
			NXAccount account = userAPI.getUserAccount(sso_id, SERVICE_NAME);
			System.out.println(account.toString());
			retValue = account.getAccountName();
			//System.out.println("retValue = " + retValue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return retValue;
	}
	
	// ���� SSO �α��������� �̵�
	public void goLoginPage(HttpServletResponse response, String uurl)
	throws Exception {
		com.initech.eam.nls.CookieManager.addCookie(SECode.USER_URL, uurl, SSO_DOMAIN, response);
		com.initech.eam.nls.CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		response.sendRedirect(NLS_LOGIN_URL + "?UURL=" + uurl);
	}
	
	// ���� SSO �α��������� �̵�
	public void goLoginPage(HttpServletResponse response)throws Exception {
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		response.sendRedirect(NLS_LOGIN_URL);
	}

	// �������� ������ üũ �ϱ� ���Ͽ� ���Ǵ� API
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT,PROVIDER_LIST);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}
	
	//ND API�� ����ؼ� ��Ű�����ϴ°�(���� ǥ�ؿ����� ������, �ٵ� �ص� �Ǳ�� ��)
	public String getEamSessionCheck2(HttpServletRequest request,HttpServletResponse response)
	{
		String retCode = "";
		try {
			NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
			retCode = nxNLSAPI.readNexessCookie(request, response, 0, 0);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}

	// SSO ���������� URL
	public void goErrorPage(HttpServletResponse response, int error_code)throws Exception {
		CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}
	
	/**
	*	����� �⺻���� ��������.
	*	@param	String	userid
	*	@return	Properties
	*/
	public Properties getUserInfos(String userid) throws Exception {
		
		NXContext context = null;
		context = getContext();

		NXUserAPI userAPI = new NXUserAPI(context);
		Properties propt = null;

		if (userid==null || userid.length() <= 0)
			return propt;

		try {
			NXUserInfo userInfo = userAPI.getUserInfo(userid);
			propt = new Properties();
			//System.out.println("userInfo.getName()=["+userInfo.getName()+"]");
			propt.setProperty("USERID", userInfo.getUserId());
			propt.setProperty("EMAIL", userInfo.getEmail());
			propt.setProperty("ENABLE", String.valueOf(userInfo.getEnable()));
			propt.setProperty("STARTVALID", userInfo.getStartValid());
			propt.setProperty("ENDVALID", userInfo.getEndValid());
			propt.setProperty("NAME", userInfo.getName());
			propt.setProperty("ENCPASSWD", userInfo.getEncpasswd());
			propt.setProperty("LASTPASSWDCHANGE", userInfo.getLastpasswdchange());
			propt.setProperty("LastLoginIP", userInfo.getLastLoginIp());
			propt.setProperty("LastLoginTime", userInfo.getLastLoginTime());
			propt.setProperty("LastLoginAuthLevel",	userInfo.getLastLoginAuthLevel());

		} catch (EmptyResultException e) {
			e.printStackTrace();
		} catch (APIException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return propt;
	}
	
	/**
	*	������� �⺻���� �߿��� �Էµ� Ű ���� ������ �´�.
	*	@param	String	userid
	*	@param	String	key	
	*	@return	String
	*/
	public String getUserInfo(String userid, String key) throws Exception {
		if(userid==null||userid.length()<1) return null;

		String userInfo = "";

		try{
			Properties propt = getUserInfos(userid);
			userInfo = propt.getProperty(key);
		} catch (Exception e) {
				//throw e;
				e.printStackTrace();
		} 
		return userInfo;
	}

	/**
	 * ����� Ȯ������ ��ȸ
	 * return : Properties
	 * ����ڰ� �������� �ʰų� Ȯ���ʵ尡 ���ٸ� return null
	 */
	public Properties getUserExFields(String userid)
	throws Exception {
		NXContext context = getContext();
		NXUserAPI userAPI = new NXUserAPI(context);
		Properties prop = null;
		NXExternalFieldSet nxefs = null;

		try {
			nxefs = userAPI.getUserExternalFields(userid);
			prop = new Properties();

			if (nxefs != null) {
				Iterator iter = nxefs.iterator();
				while(iter.hasNext()) {
					NXExternalField nxef = (NXExternalField) iter.next();
					if(nxef.getName().equals("PASSINIT")){
						String sPassintVal = (String) nxef.getValue();
						prop.setProperty(nxef.getName(), sPassintVal.equals("") ? "0" : sPassintVal);
					}
					else
						prop.setProperty(nxef.getName(), (String) nxef.getValue());
					//System.out.println("Ȯ�� �ʵ� " + nxef.getName() + " : " + nxef.getValue());
				}
			} else {
				// prop is null
			}
		} catch (EmptyResultException e) {
	 		// ����ڰ� �������� �ʰų� Ȯ���ʵ尡 ����
		} catch (APIException e) {
			throw e;
			//e.printStackTrace();
		}
		//System.out.println("getUserExFields:[" + prop + "]");
		return prop;
	}

	/**
	 * ������� Ư�� Ȯ�� �ʵ� ���� ��ȸ
	 * return : String
	 * ����ڰ� �������� �ʰų� Ȯ���ʵ尡 ���ٸ� return null
	 */
	public String getUserExField(String userid, String exName)
	throws Exception {
		NXContext context = getContext();
		NXUserAPI userAPI = new NXUserAPI(context);
		NXExternalField nxef = null;
		String returnValue = null;

		try {

			nxef = userAPI.getUserExternalField(userid, exName);
			returnValue = (String) nxef.getValue();
		} catch (EmptyResultException e) {
	 		// ����ڰ� �������� �ʰų� Ȯ���ʵ尡 ����
		} catch (APIException e) {
			throw e;
			//e.printStackTrace();
		} catch (IllegalArgumentException e) {
			throw e;
			//e.printStackTrace();
		}
		/*
		System.out.println("getUserExField:[" + userid + ":"
			+ exName + ":" + returnValue+ "]");
		*/
		return returnValue;
	}

%>
