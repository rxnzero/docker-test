package com.eactive.eai.rms.common.logging;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;
import org.springframework.transaction.annotation.Transactional;

import com.eactive.eai.rms.common.datasource.DataSourceContextHolder;
import com.eactive.eai.rms.common.datasource.DataSourceType;
import com.eactive.eai.rms.common.datasource.RoutingDataSource;

public aspect TransactionLoggingAspect percflow(transactionalMethodExecution()) {

    private static final String TRANSACTION_LOGGING = " [TRANSACTION_LOGGING";

    private pointcut executionOfAnyPublicMethodInAtTransactionalType() :
        execution(public * ((@Transactional *)+).*(..)) && @this(Transactional);

    private pointcut executionOfTransactionalMethod() :
        execution(* *(..)) && @annotation(Transactional);

    protected pointcut transactionalMethodExecution() :
        (executionOfAnyPublicMethodInAtTransactionalType()
         || executionOfTransactionalMethod())
         ;

    private Log transactionLogger;

    private String transactionStartLocation;
    private DataSourceType dataSourceTypeAtTransactionStartLocation;
    private DataSourceType currentDataSourceType;

    Object around():transactionalMethodExecution() {
        transactionLogger = LogFactory.getLog(thisJoinPointStaticPart.getSignature()
                .getDeclaringType());
        if (transactionLogger.isDebugEnabled()) {

            transactionStartLocation = thisJoinPointStaticPart.getSignature()
                    + " [line : "
                    + thisJoinPointStaticPart.getSourceLocation().getLine()
                    + "]";
            dataSourceTypeAtTransactionStartLocation = DataSourceContextHolder.getDataSourceType();
            StringBuilder sb = new StringBuilder(TRANSACTION_LOGGING).append(":START]");
            sb.append(" start location : ")
                    .append(transactionStartLocation)
                    .append("\n");
            sb.append('\t')
                    .append(
                        "current DataSourceType : "
                                + dataSourceTypeAtTransactionStartLocation)
                    .append('\n');

            transactionLogger.debug(sb.toString());
        }

        Object returnValue = null;
        try {
            returnValue = proceed();
        } catch (Throwable e) {

        }

        if (transactionLogger.isDebugEnabled()) {
            StringBuilder sb = new StringBuilder();
            sb.append(TRANSACTION_LOGGING).append(":END");
            sb.append(" start location : ")
                    .append(transactionStartLocation)
                    .append("\n");
            transactionLogger.debug(sb.toString());
        }

        return returnValue;
    }

    /**
     * transaction이 시작 된 후 RoutingDataSource에 의해 실제로 DataSource를 lookup할 때의 
     * DataSource lookup key 
     * @return
     */
    after() returning(DataSourceType dataSourceType) 
        : cflow(transactionalMethodExecution())
            && execution (protected Object RoutingDataSource.determineCurrentLookupKey()) {
        currentDataSourceType = dataSourceType;
        if (transactionLogger.isDebugEnabled()) {
            StringBuilder sb = new StringBuilder();
            sb.append(TRANSACTION_LOGGING).append(":LOOKUP]");
            sb.append(" start location : ")
                    .append(transactionStartLocation)
                    .append("\n");
            sb.append("\t")
                    .append("determine current DataSourceType : ")
                    .append(currentDataSourceType)
                    .append("\n");
            transactionLogger.debug(sb.toString());
        }
    }

    /**
     * transaction이 시작 된 후 RoutingDataSource에 의해 
     * 실제로 DataSource가 리턴 될 때의 DataSource
     */
    after() returning(DataSource dataSource) 
        : cflow(transactionalMethodExecution())
        && execution (* AbstractRoutingDataSource.determineTargetDataSource()) {

        if (transactionLogger.isDebugEnabled()) {
            StringBuilder sb = new StringBuilder();

            sb.append(TRANSACTION_LOGGING).append(":DATASOURCE]");
            sb.append(" start location : ")
                    .append(transactionStartLocation)
                    .append("\n");
            sb.append('\t').append("determine target datasource : ").append(
                dataSource).append('\n');
            sb.append('\t')
                    .append(
                        "current DataSourceType : "
                                + dataSourceTypeAtTransactionStartLocation)
                    .append('\n');
            sb.append("\t")
                    .append("determine current DataSourceType : ")
                    .append(currentDataSourceType)
                    .append("\n");
            transactionLogger.debug(sb.toString());
        }
    }

}
