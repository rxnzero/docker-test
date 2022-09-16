package com.eactive.eai.rms.common.logging;

import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import com.eactive.eai.rms.common.datasource.DataSourceContextHolder;
import com.eactive.eai.rms.common.datasource.DataSourceType;
import com.eactive.eai.rms.common.datasource.DataSourceTypeManager;
import com.eactive.eai.rms.common.login.SessionManager;
import com.eactive.eai.rms.common.spring.BaseController;
import com.eactive.eai.rms.common.util.CommonUtil;

@SuppressWarnings("deprecation")
public aspect RequestParameterLoggingAspect {

    private pointcut log() :
        execution(* com.eactive.eai.rms.common.interceptor.*Interceptor.preHandle (..));

    final String sep = ", ";
    
	after():log() {
    	Object[] args = thisJoinPoint.getArgs();
    	
    	HttpServletRequest request = null;
    	UserAccessLoggerDaoImpl dao = null;
    	Object controller = null;
    	String type = null;
    	String sub = "*";    	
        String msg = null;
        String id  = null;
        StringBuffer params = new StringBuffer();
        
        
        for(int idx=0; idx < args.length; idx++ ) {
        	if( args[idx] instanceof HttpServletRequest ) {
        		request = (HttpServletRequest)args[idx];
        		id = SessionManager.getUserId(request);
        		if( id ==  null || "".equals(id)) {
        			id = request.getParameter("EmployeeNumber");
        		}
        		try {
					dao = (UserAccessLoggerDaoImpl) CommonUtil.getBean(request, "userAccessLoggerDao");
				} catch (Exception e) {
					e.printStackTrace();
				}
        	}
        	
        	if( args[idx].getClass().getName().indexOf("Controller") != -1 ) {
            	controller = args[idx];
            	type = controller.getClass().getSimpleName();
        	}
        	
        	if( args[idx] instanceof BaseController ) {
        		dao = (UserAccessLoggerDaoImpl)((BaseController)args[idx]).getApplicationContext().getBean("userAccessLoggerDao");
        	}
        }


        msg = request.getParameter("cmd");
        if( msg == null ) {
        	msg = request.getParameter("scr_name");
        }

        for (@SuppressWarnings("rawtypes")
		Enumeration enu = request.getParameterNames(); enu
                .hasMoreElements();) {
            String parameterName = (String) enu.nextElement();
            params.append("{");
            params.append(parameterName + "="
                    + request.getParameter(parameterName));
            params.append("} ,");
        }

        DataSourceType dt=null;
		try {
			dt = DataSourceContextHolder.getDataSourceType(request);
		} catch (Exception e1) {
			e1.printStackTrace();
			dt = DataSourceTypeManager.getDataSourceType(DataSourceTypeManager.MONITORING);
		}
        
        
        //SKIP 
        if (type != null) {
            // ��ú���, �޴�, ���� ���� �α״� Controller �� �ʹ� ���� ����ϱ� ������ ���ܽ�Ų��.
            if (type.startsWith("Dashboard") || type.startsWith("MenuRender")
                    || type.startsWith("Approve") || type.startsWith("NewDashboard")
                    || type.startsWith("checkSession") ) {  // checkSession ���� YYJ
                return;
            }
            //HTTP �������� ����͸� ����
            if( "HttpStatusController".equals(type) ) {
                if( "ALL_LIST".equals(msg) ) {
                	return;
                }
            }
            //SOCKET �������� ����͸� ���� 
            if( "SocketStatus2Controller".equals(type) ) {
                if( "SELECT_LIST".equals(msg) ) {
                	return;
                }
            }
            
            // �ŷ�ó�� �¶��� ��Ʈ�ѷ� �� �αװ� ����ϱ� ������ ���ܽ�Ų��.
            // �����ڵ�(�޺��ڽ� ����ȸ) �� ����.
            if( "TransactionOnlineController".equals(type) ) {
                if( "MAIN_LIST".equals(msg) 
                   || "DETAIL_LIST".equals(msg) ) {
                    return;                    
                }
            } else if( "CommonCodeAndNameController".equals(type) ) {
                return;
            } else if( "MainController".equals(type) ) {
        		String uri = request.getRequestURI();
        		if( uri.indexOf(request.getContextPath() + "/preMain.do") > -1 ) {
        			// preMain.do �α� �ױ�
        			msg = "preMain.do";
        		} else if( uri.indexOf(request.getContextPath() + "/rms/logout.do") > -1 ) {
        			// /rms/logout.do �α� �ױ�
        			msg = "rms/logout.do";
            	} else if( StringUtils.defaultString(msg,"").equals("") || "null".equals(msg)) {
            		return;
            	}
            } else if( "MenuController".equals(type)) {
            	if( "POSITION".equals(msg) || "MENU_AUTH".equals(msg) || "GET_MENU_ID".equals(msg)  ) {
            		return;
            	}
            }
            
            // cmd �� scr_name �� ���� ��� uri ����
            if( msg == null ) {
            	msg = request.getRequestURI().replace(request.getContextPath(), "");
            }
            
            if( dao != null ) {
            	try {
                	HashMap<String, String> param = new HashMap<String, String>();
                	param.put("schemaId", dt == null ? "" : dt.getSchema());
                    param.put("id",       id);
                    param.put("userIp",   request.getRemoteAddr());
                    param.put("type",     type);
                    param.put("sub",      sub);
                    param.put("msg",      msg);
                    param.put("params",   params.toString());
    				dao.addUserAccessLog(param);
    			} catch (Exception e) {
    				System.err.println("id[" + id + "]");
    				System.err.println("type[" + type + "]");
    				System.err.println("sub[" + sub + "]");
    				System.err.println("params[" + params.toString() + "]");
    				e.printStackTrace();
    			}
            }
        } 
    }
    	
}
