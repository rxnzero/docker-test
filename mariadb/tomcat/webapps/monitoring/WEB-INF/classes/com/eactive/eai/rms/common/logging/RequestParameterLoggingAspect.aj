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
            // 대시보드, 메뉴, 승인 관련 로그는 Controller 를 너무 많이 사용하기 때문에 제외시킨다.
            if (type.startsWith("Dashboard") || type.startsWith("MenuRender")
                    || type.startsWith("Approve") || type.startsWith("NewDashboard")
                    || type.startsWith("checkSession") ) {  // checkSession 제외 YYJ
                return;
            }
            //HTTP 상태정보 모니터링 생략
            if( "HttpStatusController".equals(type) ) {
                if( "ALL_LIST".equals(msg) ) {
                	return;
                }
            }
            //SOCKET 상태정보 모니터링 생략 
            if( "SocketStatus2Controller".equals(type) ) {
                if( "SELECT_LIST".equals(msg) ) {
                	return;
                }
            }
            
            // 거래처리 온라인 컨트롤러 도 로그가 빈번하기 때문에 제외시킨다.
            // 공통코드(콤보박스 값조회) 도 제외.
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
        			// preMain.do 로그 쌓기
        			msg = "preMain.do";
        		} else if( uri.indexOf(request.getContextPath() + "/rms/logout.do") > -1 ) {
        			// /rms/logout.do 로그 쌓기
        			msg = "rms/logout.do";
            	} else if( StringUtils.defaultString(msg,"").equals("") || "null".equals(msg)) {
            		return;
            	}
            } else if( "MenuController".equals(type)) {
            	if( "POSITION".equals(msg) || "MENU_AUTH".equals(msg) || "GET_MENU_ID".equals(msg)  ) {
            		return;
            	}
            }
            
            // cmd 나 scr_name 이 없는 경우 uri 저장
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
