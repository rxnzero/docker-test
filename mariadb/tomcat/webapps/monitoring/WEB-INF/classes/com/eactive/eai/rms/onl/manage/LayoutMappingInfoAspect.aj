package com.eactive.eai.rms.onl.manage;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.reflect.CodeSignature;
import org.jdom.input.SAXBuilder;
import org.springframework.context.ApplicationContext;

import com.eactive.eai.common.util.UUIDGenerator;
import com.eactive.eai.rms.common.base.BaseService;
import com.eactive.eai.rms.common.context.MonitoringContextImpl;
import com.eactive.eai.rms.common.datasource.DataSourceContextHolder;
import com.eactive.eai.rms.common.login.SessionManager;
import com.eactive.eai.rms.common.spring.BaseController;
import com.eactive.eai.rms.onl.common.exception.BizException;
import com.eactive.eai.rms.onl.manage.rule.layoutsync.LayoutSyncService;
import com.eactive.eai.rms.onl.manage.rule.transform.TransformMappingManService;
import com.eactive.eai.rms.onl.manage.rule.transform.TransformService;
import com.eactive.eai.rms.onl.manage.rule.transformrule.TransformRuleController;
import com.eactive.eai.rms.onl.manage.serviceinfo.eaimsg.EaiMsgService;
import com.eactive.eai.rms.onl.manage.serviceinfo.stdmessage.StdMessageService;
import com.eactive.eai.rms.onl.transaction.extnl.InterfaceService;

public aspect LayoutMappingInfoAspect extends BaseController{

	pointcut mapping(Object obj) :
		(
			execution(* com.eactive.eai.rms.onl.manage.rule.transformrule.TransformRuleController.upload(..))
			
			|| execution(* com.eactive.eai.rms.onl.manage.rule.transform.TransformService.transaction(..))
			|| execution(* com.eactive.eai.rms.onl.manage.rule.transform.TransformService.delete(..))
			
			|| execution(* com.eactive.eai.rms.onl.manage.rule.transform.TransformMappingManService.*RefMsgID(..))
			
			|| execution(* com.eactive.eai.rms.onl.manage.serviceinfo.stdmessage.StdMessageService.clone(..))
			|| execution(* com.eactive.eai.rms.onl.manage.serviceinfo.stdmessage.StdMessageService.insert(..))
			|| execution(* com.eactive.eai.rms.onl.manage.serviceinfo.stdmessage.StdMessageService.delete(..))
			|| execution(* com.eactive.eai.rms.onl.manage.serviceinfo.stdmessage.StdMessageService.update(..))
			
			|| execution(* com.eactive.eai.rms.onl.manage.serviceinfo.eaimsg.EaiMsgService.insertSvc(..))
			|| execution(* com.eactive.eai.rms.onl.manage.serviceinfo.eaimsg.EaiMsgService.updateSvc(..))
			|| execution(* com.eactive.eai.rms.onl.manage.serviceinfo.eaimsg.EaiMsgService.deleteSvc(..))
			
			|| execution(* com.eactive.eai.rms.onl.transaction.extnl.InterfaceService.insert(..))
			|| execution(* com.eactive.eai.rms.onl.transaction.extnl.InterfaceService.update(..))
			|| execution(* com.eactive.eai.rms.onl.transaction.extnl.InterfaceService.delete(..))
		)
		&& args(obj, ..)
		;
	
	Object around(Object obj) throws Exception : mapping(obj) {

		ApplicationContext appCoxt = null;
		if( thisJoinPoint.getThis() instanceof BaseService ) {
			appCoxt = ((BaseService)thisJoinPoint.getThis()).appContext;
		} else if(thisJoinPoint.getThis() instanceof BaseController ) {
			appCoxt = ((BaseController)thisJoinPoint.getThis()).getApplicationContext();
		} else {
			return proceed(obj);
		}
		
		Log logger = LogFactory.getLog(thisJoinPointStaticPart.getSignature()
				.getDeclaringType());
		LayoutSyncService service = (LayoutSyncService)appCoxt.getBean("layoutSyncService");
		MonitoringContextImpl monitoringContext = (MonitoringContextImpl)appCoxt.getBean("monitoringContext");
		

		//1. parameter 설정
		List<HashMap<String, String>> paramList = new ArrayList<HashMap<String, String>>();
		
        HashMap<String, String> param = new HashMap<String, String>();
        param.put("schema", DataSourceContextHolder.getDataSourceType().getName());
        String eaiSvcName = null;
        String cmd = null;
        
        // 2. eaiSvcName, cmd 설정
        if( thisJoinPoint.getThis() instanceof TransformRuleController ) {
//        	Object[] args = thisJoinPoint.getArgs();
//        	HttpServletRequest req = null;
//        	for(int i=0; i < args.length; i++) {
//        		if( args[i] instanceof HttpServletRequest ) {
//        			req = (HttpServletRequest)args[i];
//        			break;
//        		}
//        	}
//
//	        eaiSvcName = (String)req.getAttribute("eaiSvcName");
//	        cmd = "insert";
//	        param.put("eaiSvcName", StringUtils.defaultString(eaiSvcName, ""));
//	        param.put("cmd", StringUtils.defaultString(cmd, ""));
//	        paramList.add(param);

		} else if( thisJoinPoint.getThis() instanceof TransformService) {
			//method key,value
			String[] paramNames = ((CodeSignature)thisJoinPointStaticPart.getSignature()).getParameterNames();
			Object[] args = thisJoinPoint.getArgs();
			HashMap<String,Object> h = new HashMap<String,Object>();
			for(int i=0;i<paramNames.length;i++){
				h.put(paramNames[i], args[i]);
			}

	        cmd = thisJoinPoint.getSignature().getName().startsWith("delete") ? "delete" : "insert";

	        param.put("eaiSvcName", StringUtils.defaultString((String)h.get("eaiSvcName"), ""));
	        param.put("cmd", StringUtils.defaultString(cmd, ""));
	        paramList.add(param);			
		} else if( thisJoinPoint.getThis() instanceof TransformMappingManService ) {
			Object[] args = thisJoinPoint.getArgs();
        	HashMap<String,Object> vo = null;
        	for(int i=0; i < args.length; i++) {
        		if( args[i] instanceof HashMap ) {
        			vo = (HashMap<String,Object>)args[i];
        			break;
        		}
        	}
	        cmd = thisJoinPoint.getSignature().getName().startsWith("delete") ? "delete" : "insert";

	        param.put("eaiSvcName", StringUtils.defaultString((String)vo.get("eaiSvcName"), ""));
	        param.put("cmd", StringUtils.defaultString(cmd, ""));
	        paramList.add(param);			
			
		} else if( thisJoinPoint.getThis() instanceof EaiMsgService) {
			if( obj instanceof HashMap) {
				HashMap<String,Object> vo = (HashMap<String,Object>)obj;
				eaiSvcName = (String)vo.get("eaiSvcName");
			}
			//복제 여부 확인 해야됨
            cmd = thisJoinPoint.getSignature().getName().startsWith("delete") ? "delete" : "insert";
	        param.put("eaiSvcName", StringUtils.defaultString(eaiSvcName, ""));
	        param.put("cmd", StringUtils.defaultString(cmd, ""));
	        paramList.add(param);
		} else if( thisJoinPoint.getThis() instanceof InterfaceService ){
			if( obj instanceof HashMap) {
				HashMap<String,Object> vo = (HashMap<String,Object>)obj;
				eaiSvcName = (String)vo.get("eaiSvcName");
			}
            cmd = thisJoinPoint.getSignature().getName().startsWith("delete") ? "delete" : "insert";

	        param.put("eaiSvcName", StringUtils.defaultString(eaiSvcName, ""));
	        param.put("cmd", StringUtils.defaultString(cmd, ""));
	        paramList.add(param);
		} else if( thisJoinPoint.getThis() instanceof StdMessageService ) {
			//내부표준전문 저장시
			if( obj instanceof HashMap) {
				HashMap<String,Object> vo = (HashMap<String,Object>)obj;

	            eaiSvcName = (String)vo.get("bzwkSvcKeyName") + (String)vo.get("splizDmndDstcd") + (String)vo.get("stndTelgmWtinExtnlDstcd");
	            cmd = thisJoinPoint.getSignature().getName().startsWith("delete") ? "delete" : "insert";
	            
		        param.put("eaiSvcName", StringUtils.defaultString(eaiSvcName, ""));
		        param.put("cmd", StringUtils.defaultString(cmd, ""));
		        paramList.add(param);
			}
			
		}
		
        Object rts = null;
        // Property 정보 취득 
    	Properties prop = new Properties();
    	List<HashMap<String, String>> propertyDetail;
		try {
			// List로 구성된 transaction 정보 다중 처리 
	        for(HashMap<String, String> m : paramList) {
	    		if( !"".equals(m.get("eiaSvcName")) && !"".equals(m.get("cmd")) ) {    			
	    	        //3. 서비스 호출
	    	        String serno = UUIDGenerator.getUUID();
	    	    	
	    	        String xmlQuery = null;
	    	        //본거래에 대한 transaction 보장
	    	        try {
	    	        	if("delete".equals(cmd)) {
	    					xmlQuery = service.getLayoutMappingXMLList(m);
	    	        		rts = proceed(obj);
	    	        	} else {
	    	        		rts = proceed(obj);
	    					xmlQuery = service.getLayoutMappingXMLList(m);
	    	        	}
	    			} catch (Exception e) {
	    				logger.error("Exception -" + e.getMessage() ,e);
	    				if ( rts == null ) rts = e.getMessage();
	    				// int return : TransformMappingManService.insertRefMsgID
	    				if(thisJoinPoint.getStaticPart().toString().replace("execution(","").startsWith("int") ) {
	    					rts = -1;
	    				}
	    				throw e;
	    			}
	    	        //IIM sync 전송 여부
        			String syncYn = monitoringContext.getStringProperty("iim.sync.yn");
        			if(!"Y".equals(syncYn)){
        				continue;
        			}
    	        	if( xmlQuery.indexOf("Layout") != -1 ) {        		
    	        		HashMap<String, String> map = new HashMap<String, String>();
    	        		map.put("executeClass", thisJoinPoint.getSignature().getDeclaringType().getName());
    	        		map.put("executeMethod", thisJoinPoint.getSignature().getName());
    	        		if( obj instanceof HttpServletRequest ) {
    	        			map.put("executeUser", SessionManager.getUserId((HttpServletRequest)obj));
    	        		}
    	        		map.put("logPrcssSerno", StringUtils.rightPad(serno, 40, " "));
    	        		map.put("sendXmlCmnt", xmlQuery);

    	        		//4. 전송처리 
    	        		try {

    	        			//layout sync 송신로그
    	        			service.addLayoutMappingSyncLog(map);

    	        			String url = monitoringContext.getStringProperty("iim.layout.mapping");
    	        			if( url == null ) {
    	        			    throw new Exception("수신서버의 정보를 찾을 수 없습니다.");
    	        			}
    	        			
    		        		String recvMsg = service.syncLayout(url, xmlQuery);
    		
    		        		// 응답전문 성공/실패 처리 확인 
    		        		SAXBuilder builder = new SAXBuilder();
    		        		org.jdom.Document recv = builder.build( new ByteArrayInputStream(recvMsg.getBytes()) );
    		        		org.jdom.Element results = recv.getRootElement();
    		        		
    		        		if( "FALSE".equals(results.getChild("Result").getText().toUpperCase()) ) {
    			        		map.put("recvRslt", "F");
    			        		map.put("recvFailCmnt", results.getChild("ResultMessage").getText());
    		        		} else {
    			        		map.put("recvRslt", "S");
    		        		} 
    		        		//layout sync 수신로그
    		        		service.recvLayoutMappingSyncLog(map);
    	        		} catch(Exception e) {
    	        			logger.error ("iim 전송중 오류 " + e.getMessage(),e);
    		        		map.put("recvRslt", "F");
    		        		map.put("recvFailCmnt", e.getMessage());
    	        		}
    	        	} // end if 

	    		} // end if  
	        	
	        } // end for
		} catch (Exception e1) {
			logger.error("Exception : -" + e1.getMessage() ,e1);
			if ( rts == null ) rts = e1.getMessage();
			// int return : TransformMappingManService.insertRefMsgID
			if(thisJoinPoint.getStaticPart().toString().replace("execution(","").startsWith("int") ) {
				rts = -1;
			}
			throw e1;
		}
		return rts;
	}
}