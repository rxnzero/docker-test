package com.eactive.eai.rms.onl.common.service;

import com.eactive.eai.rms.common.datasource.RoutingDataSourceService;

/**
 * The Class EaiServerInfoServiceRoutingDataSourcePatch.
 * 
 * service key를 해당 서비스 키에 맞는 schemaname으로 변환시킨다. 
 */
public aspect EaiServerInfoServiceRoutingDataSourcePatch extends
		RoutingDataSourceService {

	protected pointcut service(String schemaName) : 
		(
				execution (* EaiServerInfoService+.getEaiServerIpList*(..))
				|| execution (* EaiServerInfoService+.getSnaHostList(..))	
				|| execution (* EaiServerInfoService+.getHostServerIpList(..))
				|| execution (* EaiServerInfoService+.getHostServerIpList(..))
				|| execution (* DashboardTargetService+.getBatchProcCount*(..))
				|| execution (* DashboardTargetService+.getEaiBatchServerIpList(..))
		)
		&& args(schemaName, ..)
	;

}
