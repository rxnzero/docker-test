package com.eactive.eai.rms.common.datasource;

import org.springframework.transaction.aspectj.AnnotationTransactionAspect;

import com.eactive.eai.rms.common.logging.TransactionLoggingAspect;

public abstract aspect RoutingDataSourceService {

    declare precedence : TransactionLoggingAspect,RoutingDataSourceService+, AnnotationTransactionAspect, *;

    protected abstract pointcut service(String service);

    Object around(String service) : service(service) {

        Object returnValue = null;
        DataSourceType originalDataSourceType = DataSourceContextHolder.getDataSourceType();

        DataSourceType currentDataSourceType =  DataSourceTypeManager.getDataSourceType(service);
        try {
        	DataSourceContextHolder.setDataSourceType(currentDataSourceType);
            returnValue = proceed(currentDataSourceType.getSchema());
        } finally {
            DataSourceContextHolder.setDataSourceType(originalDataSourceType);
        }

        return returnValue;
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    Object around(SpecifiedDataSourceExecutor executor) 
            : call (* SpecifiedDataSourceExecutor.doExecute())
            && this(executor) {
        Object returnValue = null;
        DataSourceType originalDataSourceType = DataSourceContextHolder.getDataSourceType();

        try {
            DataSourceContextHolder.setDataSourceType(executor.dataSourceType);
            returnValue = proceed(executor);
        } finally {
            DataSourceContextHolder.setDataSourceType(originalDataSourceType);
        }
        return returnValue;
    }

}
