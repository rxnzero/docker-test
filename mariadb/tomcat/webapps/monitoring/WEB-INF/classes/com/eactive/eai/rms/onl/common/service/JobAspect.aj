package com.eactive.eai.rms.onl.common.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import com.eactive.eai.common.util.DatetimeUtil;
import com.eactive.eai.rms.common.scheduler.SchedulerService;
import java.text.SimpleDateFormat;


public aspect JobAspect percflow(job()){

	private SimpleDateFormat dateFormat = new SimpleDateFormat( "yyyyMMddHHmmssSSS");
	
	pointcut job() : (
				execution(* org.quartz.Job.execute(..))
			);
	
			//execution(* com.eactive.eai.rms.onl.common.service.*Job.execute(..))

	void around() : job(){
		Log logger = LogFactory.getLog(thisJoinPointStaticPart.getSignature()
				.getDeclaringType());
		final Object[] args= thisJoinPoint.getArgs();
		for(int i = 0; i < args.length; i++){
			ApplicationContext appContext = null;
			JobExecutionContext context = (JobExecutionContext) args[i];
			String jobName = context.getJobDetail().getKey().getName();
			String status = "success";
			try{
				proceed();			
			}catch(Throwable e){
				logger.error(jobName + " Scheduler Job has been Failed", e);
				status = "failed";		
			}finally{
			
				String startDate = (dateFormat).format(context.getFireTime());
				String endDate = DatetimeUtil.getCurrentTimeMillis();
				
				try {
					if(!context.getScheduler().getContext().isEmpty()){
						appContext = (ApplicationContext)context.getScheduler().getContext().get("applicationContext");
						if( !context.getScheduler().isShutdown()){
							SchedulerService schedulerService = (SchedulerService)appContext.getBean("schedulerService");	
							schedulerService.updateStatus(jobName, startDate, endDate, status);
						}else{
							logger.error("The Context Information is not Valid : " + context);
						}
					}
				}catch(Exception e){
					logger.error("Updating Scheduler Status has been Failed : ");
				}
			}
		}

	}
}
