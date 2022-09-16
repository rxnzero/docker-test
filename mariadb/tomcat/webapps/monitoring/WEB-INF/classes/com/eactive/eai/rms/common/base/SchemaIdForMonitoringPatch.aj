package com.eactive.eai.rms.common.base;

import java.util.Iterator;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.eactive.eai.rms.common.datasource.DataSourceTypeManager;
import com.eactive.eai.rms.common.login.LoginVo;
import com.eactive.eai.rms.common.login.SessionManager;
import com.eactive.eai.rms.common.util.CommonConstants;

public aspect SchemaIdForMonitoringPatch {

    pointcut executionSqlMapDaoByMapParameter(String statementName,
            Object parameterObject) : 
         execution(* SchemaIdConfiguredSqlMapForMonitoringTemplate.*(..)) 
         && args(statementName, parameterObject, ..)
        ;

    @SuppressWarnings("unchecked")
    before(String statementName, Object parameterObject): 
        executionSqlMapDaoByMapParameter(statementName, parameterObject) {
        if (parameterObject instanceof Map) {
            Map<String, Object> paramMap = (Map<String, Object>) parameterObject;

            //schema 관련
            if (paramMap.get(CommonConstants.schemaId_KEY) == null) {
                paramMap.put(CommonConstants.schemaId_KEY,
                	DataSourceTypeManager.getDataSourceType(DataSourceTypeManager.MONITORING).getSchema());
            }
            //login user 관련
            if (paramMap.get(CommonConstants.loginId_KEY) == null) {
          	  LoginVo loginVo = SessionManager.getLoginVo(); 
          	  if (loginVo != null){
          		  paramMap.put(CommonConstants.loginId_KEY,loginVo.getUserId());
          	  }
            }

            Log logger = LogFactory.getLog(thisJoinPointStaticPart.getSignature()
                    .getDeclaringType()
                    .getName());

            if (logger.isDebugEnabled()) {

                StringBuilder sb = new StringBuilder();
                sb.append("Statement Name : " + statementName).append("\n");
                for (Iterator<String> it = paramMap.keySet().iterator(); it.hasNext();) {

                    String key = it.next();
                    sb.append(key + "=" + paramMap.get(key)).append(", ");
                }
                logger.debug("SQLMap Parameters : " + sb.toString());
            }
        }
    }
}
