package com.eactive.eai.rms.common.logging;

import java.util.Collection;
import java.util.Map;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

/**
 * The Class LoggingAspect.
 * 
 */
public aspect LoggingAspect {

	/**
	 * Logging.
	 */
	pointcut logging() : (
            execution(* @Component+ com.eactive.eai.rms.onl..*.*(..))
            || execution(* @Service com.eactive.eai.rms.onl..*.*(..))
            || execution(* @Repository com.eactive.eai.rms.onl..*.*(..))
            )
            && !execution(* com.eactive.eai.rms.onl..*.set*(..))
            && !execution(* @Controller com.eactive.eai.rms.onl..*.*(..))
            && !execution(* com.eactive.eai.transformer..*.*(..))
            && !execution(* com.eactive.eai.rms.onl.manage.rule.service..*.*(..))
            
                ;

	/**
	 * Before.
	 */
	before() : logging() {

		Log logger = LogFactory.getLog(thisJoinPointStaticPart.getSignature()
				.getDeclaringType());

		if (logger.isDebugEnabled()) {

			StringBuilder builder = new StringBuilder();
			builder.append(thisJoinPointStaticPart.getSignature() + " start!!");

			Object[] args = thisJoinPoint.getArgs();

			if ((args != null) && (args.length > 0)) {
				for (int i = 0; i < args.length; i++) {
					// List 객체의 경우 로그가 너무 많이 남아서 제외시킨다.
					if (args[i] instanceof List) {
						builder.append("\n").append(
								"Argument[" + i + "] : List");
					} else {
						builder.append("\n").append(
								"Argument[" + i + "] : " + args[i]);
					}
				}
			}

			logger.debug(builder.toString());
		}

	}

	/**
	 * After returning.
	 */
	@SuppressWarnings("rawtypes")
	after() returning(Object object) : logging() {

		Log logger = LogFactory.getLog(thisJoinPointStaticPart.getSignature().getDeclaringType());

		if (logger.isDebugEnabled()) {

			StringBuilder builder = new StringBuilder();
			builder.append(thisJoinPointStaticPart.getSignature() + " start!!")
					.append("\n");

			if (object instanceof java.util.Collection) {
				Collection collection = (Collection) object;
				logger.debug("returning Collection (" + collection.size() + ")");
			} else if (object instanceof java.util.Map) {
				Map map = (Map) object;
				Set set = map.keySet();
				logger.debug("returning Map (" + set.size() + ") : " + set);
			} else {
				logger.debug("returning value : " + object);
			}
		}

	}

	/**
	 * After.
	 */
	after() : logging() {
		Log logger = LogFactory.getLog(thisJoinPointStaticPart.getSignature()
				.getDeclaringType());

		if (logger.isDebugEnabled()) {
			logger.debug(thisJoinPointStaticPart.getSignature() + " end!!");
		}
	}
}
