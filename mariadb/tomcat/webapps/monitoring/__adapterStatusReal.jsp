<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*, 
java.util.*,
javax.xml.parsers.*,
org.w3c.dom.*,
javax.xml.xpath.*,
java.sql.*,
javax.sql.*,
javax.naming.*,
com.eactive.eai.agent.adapter.*,
com.eactive.eai.agent.command.*,
com.eactive.eai.agent.*,
com.eactive.eai.rms.onl.common.util.*,
com.eactive.eai.rms.onl.common.service.OnlAgentUtilServiceImpl,
com.eactive.eai.agent.AgentUtil,
org.apache.commons.httpclient.NameValuePair,
com.eactive.eai.agent.eaimessage.*,
org.apache.commons.logging.Log,
org.apache.commons.logging.LogFactory
"%>
<%!

/*
	"운영환경" 어뎁터 상태정보 및 컨트롤 기능

*/
private static final Log logger = LogFactory.getLog("adapterStatusReal.jsp");


private String dev_driver 	="";
private String dev_url		="";
private String dev_user		="";
private String dev_pwd		="";

private String test_driver 	="";
private String test_url		="";
private String test_user		="";
private String test_pwd		="";


private String real_url      = "jdbc:oracle:thin:@172.22.1.53:1526/PCHN";
/* private String real_url      = "jdbc:oracle:thin:@((DESCRIPTION ="
								+"(FAILOVER=ON)"
								+"(ADDRESS = (PROTOCOL = TCP)(HOST = 172.22.1.53)(PORT = 1526))"
								+"(ADDRESS = (PROTOCOL = TCP)(HOST = 172.22.1.54)(PORT = 1526))"
								+"(CONNECT_DATA ="
								+"  (SERVICE_NAME = PCHN)"
								+"  (FAILOVER_MODE=(TYPE=SESSION))"
								+")"
								+")"; */
private String real_driver   = "oracle.jdbc.OracleDriver";
private String real_user     = "fep";
private String real_pwd      = "Ghktjd04p!";
//개발 동기화 서버 ,,, 메모리 상세현황 보는 주소 (팝업 디스플레이)
private String[] DEV_IP      = {"172.31.32.111:20111"};
private String[] TEST_IP     = {"172.31.33.111:20111"};
private String[] REAL_IP     = {"172.26.11.11","172.26.11.12"};

private String   NEW_LINE    = "\n";
private static Object obj = new Object();
/*
 *  select 쿼리 로직 
 *
 */
public Vector<String[]> getSqlSelect(String sql,String serverType ) throws Exception {
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String driver = null;
	String url = null;
	String id =null;
	String pwd=null;
	
	if("dev".equals(serverType)){
		driver 	= dev_driver;
		url 	= dev_url;
		id		= dev_user;
		pwd		= dev_pwd;
	}else if("test".equals(serverType)){
		driver 	= test_driver;
		url 	= test_url;
		id		= test_user;
		pwd		= test_pwd;
	}else if("real".equals(serverType)){
		driver 	= real_driver;
		url 	= real_url;
		id		= real_user;
		pwd		= real_pwd;	
	}	
	int rownum = 0;
	try	{
		Class.forName(driver);
		conn = DriverManager.getConnection(url, id, pwd);

		stmt = conn.createStatement();
  		stmt.execute(sql);
  		rs = stmt.getResultSet();
  		Vector<String[]> vt = new Vector<String[]>();
  		int maxColumn = rs.getMetaData().getColumnCount();
        while(rs.next()) {
        	String[] row = new String[maxColumn];
        	for (int i=0;i<maxColumn;i++){
				row[i] = rs.getString(i+1);
        	}    	
        	vt.add(row);
		}               
		return vt;
	}
	catch(Exception e) {
		logger.error(e.getMessage(),e);
		throw e;
	}
	finally {
		try {
			if(rs != null)	 rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
		catch (SQLException sqle) {
			logger.error("SQLException was thrown: " + sqle.getMessage());
		}
	}
}
/*
 *  update 쿼리 로직
 *
 */

public int getSqlUpdate(String sql,String serverType ) throws Exception {
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String driver = null;
	String url = null;
	String id =null;
	String pwd=null;
	if("dev".equals(serverType)){
		driver 	= dev_driver;
		url 	= dev_url;
		id		= dev_user;
		pwd		= dev_pwd;
	}else if("test".equals(serverType)){
		driver 	= test_driver;
		url 	= test_url;
		id		= test_user;
		pwd		= test_pwd;
	}else if("real".equals(serverType)){
		driver 	= real_driver;
		url 	= real_url;
		id		= real_user;
		pwd		= real_pwd;	
	}
	int rownum = 0;
	try	{
		Class.forName(driver);
		conn = DriverManager.getConnection(url, id, pwd);
		stmt = conn.createStatement();
  		return stmt.executeUpdate(sql);
	}
	catch(Exception e) {
		logger.error(e.getMessage(),e);
		throw e;
	}
	finally {
		try {
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
		catch (SQLException sqle) {
			logger.error("SQLException was thrown: " + sqle.getMessage());
		}
	}
}

public Vector getList(String serverType) throws Exception{
	StringBuffer sb = new StringBuffer();
	sb.append(" select ad01.AdptrBzwkGroupName ,ad01.AdptrBzwkGroupDesc, ad01.AdptrUseYn, max(ad02.EAISevrInstncName) as EAISevrInstncName ").append(NEW_LINE);
	sb.append(" from tseaiad01 ad01, tseaiad02 ad02                                                                                                            ").append(NEW_LINE);
	sb.append(" where ad01.AdptrBzwkGroupName = ad02.AdptrBzwkGroupName and not(ad02.EAISevrInstncName ='ALL')                                     ").append(NEW_LINE);
	sb.append(" group by  ad01.AdptrBzwkGroupName ,ad01.AdptrBzwkGroupDesc, ad01.AdptrUseYn order by ad01.AdptrBzwkGroupName                   ").append(NEW_LINE);
	
	return getSqlSelect(sb.toString(),serverType);
}
public Vector getRealList(String serverType) throws Exception{
	//String[] url = {"http://172.22.1.53:10910/monitoring/adapterStatusReal.jsp"};
	String[] url = {"http://localhost:10220/monitoring/adapterStatusReal.jsp"};
	NodeList nodes ;
	Vector<String[]> vt = new Vector();
   	try {
        // CallAgentUtil로 부터 Xml을 받는다.
        CallAgentUtil agent = new CallAgentUtil();
        Document doc = agent.getAgentDataToDocument(url[0]);
        if (doc == null) {
            return null;
        }
	    // 로우 인서트
	    nodes = doc.getElementsByTagName("Row");
	    
	    for (int i = 0; i < nodes.getLength(); i++) {
       		NodeList nl = nodes.item(i).getChildNodes();
			String[] itm = new String[4];
       		int colIndex = -1;
       		for (int j = 0; j < nl.getLength(); j++) {
	            Node n = nl.item(j);

	            if (n.getNodeType() == 3)
	                continue;
	
	            colIndex++;
	            
				itm[colIndex] = n.getTextContent();     		

          	}	
			vt.add(itm);   

   
       }
    } catch (Exception e) {
        logger.error(e.toString());

    }
	return vt;

}

// Adapter PropertyGroupList 조회
public Vector getAdptrPrptyGroupList(String serverType, String adapterGroupName) throws Exception{
	StringBuffer sb = new StringBuffer();
	sb.append(" select PrptyGroupName, PrptyGroupDesc ").append(NEW_LINE);
	sb.append(" from tseaiad14                        ").append(NEW_LINE);
	sb.append(" where PrptyGroupName in (select prptygroupname from tseaiad02 where adptrbzwkgroupname = '").append(adapterGroupName).append("') ").append(NEW_LINE);
	
	return getSqlSelect(sb.toString(),serverType);
}

// Adapter MessageKey 조회
public Vector getAdptrMessageKeyList(String serverType, String adapterGroupName) throws Exception{
	StringBuffer sb = new StringBuffer();
	sb.append(" select AdptrBzwkGroupName, ioDstcd ").append(NEW_LINE);
	sb.append(" from tseaifr04                        ").append(NEW_LINE);
	sb.append(" where AdptrBzwkGroupName = '").append(adapterGroupName).append("' ").append(NEW_LINE);
	sb.append(" group by  AdptrBzwkGroupName, ioDstcd ").append(NEW_LINE);
	
	return getSqlSelect(sb.toString(),serverType);
}

public int setAdapterUseYn(String controlType, String adapterName , String serverType) throws Exception{
	StringBuffer sb = new StringBuffer();
	sb.append(" update tseaiad01 set  AdptrUseYn = '").append(controlType).append("' where AdptrBzwkGroupName ='").append(adapterName).append("' ").append(NEW_LINE);
	return getSqlUpdate(sb.toString(),serverType);
}

public Vector getServerUrl(String serverType) throws Exception {
	StringBuffer sb = new StringBuffer();
	sb.append("select EAISevrInstncName, 'http://' || EAISevrIP || ':' || SevrLsnPortName||'/ONLWeb/WebAgent' url from TSEAISY02 where EAISevrInstncName <> 'ALL' ").append(NEW_LINE);
	return getSqlSelect(sb.toString(),serverType);

}

public Vector getToBeStatusUrl(String serverType) throws Exception {
	StringBuffer sb = new StringBuffer();
	sb.append("select EAISevrInstncName, 'http://' || EAISevrIP || ':' || SevrLsnPortName||'/ONLWeb/agent/host/adapter_socket2_agent2.jsp?cmd=get+connection+summary&eaiSvrInstNm='||EAISevrInstncName url from TSEAISY02 where EAISevrInstncName <> 'ALL'  ").append(NEW_LINE);
	return getSqlSelect(sb.toString(),serverType);
}

public HashMap getToBeStatus() throws Exception{
	ArrayList al = new ArrayList();
	//개발
	//Vector v = getToBeStatusUrl("dev");
	//검증
	//Vector v2 = getToBeStatusUrl("test");
 	// 개발 2, QA 2개 ; 총 4개의 인스턴스로 설정
 	// +운영 6개
 	Vector v3 = getToBeStatusUrl("real");
			
	for (int i=0;i<6;i++){
		try{
			al.add(((String[])v3.get(i))[1]);
		}catch(ArrayIndexOutOfBoundsException e){
			al.add(null);
			logger.error("REAL_instance"+v3.get(i) +" is null");  //보조 인스턴스가 없을경우 null로 넘겨줄것
		}	
	}	
	String[] data = new String[al.size()];
	al.toArray(data);
	
	return flushXmlToClient(data);
}


public HashMap flushXmlToClient(String[] url)  {
	NodeList nodes ;
	HashMap hm = new HashMap();

	for (int i = 0; i < url.length; i++) {
    	try {
	        // CallAgentUtil로 부터 Xml을 받는다.
	        CallAgentUtil agent = new CallAgentUtil();
	        Document doc = agent.getAgentDataToDocument(url[i]);
	        if (doc == null) {
	            continue;
	        }
		    // 로우 인서트
		    nodes = doc.getElementsByTagName("Row");
	        hm.put("inst"+i,addDataRows(nodes));
	    } catch (Exception e) {
	        logger.error(e.toString());
	        continue;
	    }
	}
	return hm;
	
}

public HashMap flushXmlToClient(String[] url,NameValuePair[] postParameters)  {
	NodeList nodes ;
	HashMap hm = new HashMap();
	for (int i = 0; i < url.length; i++) {
    	try {
	        // CallAgentUtil로 부터 Xml을 받는다.
	        CallAgentUtil agent = new CallAgentUtil();
	        Document doc = agent.getAgentDataToDocument(url[i],postParameters);
	        if (doc == null) {
	            continue;
	        }
	        // 로우 인서트
	        nodes = doc.getElementsByTagName("row");
	        hm.put("inst"+i,addDataRows2(nodes));
	    } catch (Exception e) {
	        e.printStackTrace();
	        continue;
	    }
	}
	return hm;
	
}
public HashMap addDataRows(NodeList nodes) {
/*
- <Row>
  <Data>fepOnlSvr11</Data> 
  <Data>_EDU_IO_NET_AsS</Data> 
  <Data>_EDU_IO_NET_AsS{I11}</Data> 
  <Data>1</Data>                    <== max connect
  <Data>1</Data>                    <== connection 갯수
  <Data>0</Data>                    <== send 건수
  <Data>1</Data>                    <== recv 건수
  <Data>10</Data>                   <== error 건수
  <Data>true</Data>                 <== status
  </Row>

*/
    HashMap hm = new HashMap();
    for (int i = 0; i < nodes.getLength(); i++) {
        NodeList nl = nodes.item(i).getChildNodes();
        int colIndex = -1;
        String[] data = new String[10];
        for (int j = 0; j < nl.getLength(); j++) {
            Node n = nl.item(j);

            if (n.getNodeType() == 3)
                continue;

            colIndex++;
            
			data[colIndex] = n.getTextContent();          
        }
        String[] oldData = (String[])hm.get(data[1]);
        if (oldData != null) {
        	data[2] = oldData[2] + "," + data[2]  ;
        	data[3] = oldData[3]  ;
        	data[4] = Integer.toString(Integer.parseInt(oldData[4]) +  Integer.parseInt(data[4]))  ;
        	data[5] = Integer.toString(Integer.parseInt(oldData[5]) +  Integer.parseInt(data[5]))  ;
        	data[6] = Integer.toString(Integer.parseInt(oldData[6]) +  Integer.parseInt(data[6]))  ;
        	data[7] = Integer.toString(Integer.parseInt(oldData[7]) +  Integer.parseInt(data[7]))  ;
        	data[8] = Integer.toString(Integer.parseInt(oldData[8]) +  Integer.parseInt(data[8]))  ;
        	data[9] = Boolean.parseBoolean(oldData[9]) || Boolean.parseBoolean(data[9]) ? "true" : "false";
        }
        
        hm.put(data[1],data);
        
    }
    return hm;
}
public HashMap addDataRows2(NodeList nodes) {
	/*
  <?xml version="1.0" encoding="euc-kr" ?> 
- <result>
  <row>tcpsmboh</row> 
  <row>tcpctboh</row> 
  <row>tcpktsoh</row> 
  <row>tcpweb1h</row> 
  </result>

	*/
	    HashMap hm = new HashMap();
	    for (int i = 0; i < nodes.getLength(); i++) {
	        String data = nodes.item(i).getTextContent();
	        hm.put(data.trim(),data.trim());
	    }
	    return hm;
	}
public String displayStatus(HashMap hm, String adapterName,int index,String color){
	if (hm == null){
		return "X";
	}
	Object adapters = hm.get(adapterName);
	if (adapters == null){
		return "X";
	}
	String[] data = (String[])adapters;
	String status = "";
	if (data != null){
	    status =data[index];
	}
	if (index ==9){
		if ("".equals(status)){
			status="X";
		}else if ("false".equals(status)){
			status="X";
		}else if ("true".equals(status)){
			status="<b><font color=\""+color+"\" >O</font></b>";
		}
	}
	
	return status;
	
}
public String checkStatus(HashMap hm, String adapterName){
	if (hm == null){
		return "0";
	}
	
	Object adapters = hm.get(adapterName);
	if (adapters == null){
		return "0";
	}
	String[] data = (String[])adapters;
	String status = "";
	if (data != null){
	    status =data[9];
	}

	if ("".equals(status)){
		status="0";
	}else if ("false".equals(status)){
		status="0";
	}else if ("true".equals(status)){
		status="1";
	}

	
	return status;
	
}
public String displayColor(HashMap dev, HashMap test, String [] adapter,int index){

	Object devAdapters = dev.get(adapter[0]);
	Object testAdapters = test.get(adapter[0]);
	String[] devData = (String[])devAdapters;
	String[] testData = (String[])testAdapters;
	
	boolean isDevOn = false;
	boolean isTestOn = false;
	if (devData != null){
		if ("true".equals(devData[9])){
			isDevOn = true;
		}	    
	}
	if (testData != null){
		if ("true".equals(testData[9])){
			isTestOn = true;
		}	    
	}
	if (isDevOn && isTestOn){
		return "<b><font color=\"red\">"+adapter[index]+"</font></b>";
	}else if (isDevOn && !isTestOn){
		return "<b><font color=\"green\">"+adapter[index]+"</font></b>";
	}else if (!isDevOn && isTestOn){
		return "<b><font color=\"blue\">"+adapter[index]+"</font></b>";
	}else if (!isDevOn && !isTestOn){
		return adapter[index];
	}
	return "";
	
}
public String displayBgColor(HashMap  dev, HashMap test, String adapter){
 	Object devAdapters = dev.get(adapter);
	Object testAdapters = test.get(adapter);
	String[] devData = (String[])devAdapters;
	String[] testData = (String[])testAdapters;
	boolean isDevOn = false;
	boolean isTestOn = false;
	if (devData != null){
		if ("true".equals(devData[9])){
			isDevOn = true;
		}	    
	}
	if (testData != null){
		if ("true".equals(testData[9])){
			isTestOn = true;
		}	    
	}
	if (isDevOn && isTestOn){
		return "red";
	}else if (isDevOn && !isTestOn){
		return "green";
	}else if (!isDevOn && isTestOn){
		return "blue";
	}else {
		return "black";
	} 
	
}


/*
 *	Adapter 메모리 동기화
 *	
 */
public void adapterSync(Vector table,String adapterGroupName) throws Exception {
	OnlAgentUtilServiceImpl	agentUtilService = new OnlAgentUtilServiceImpl();

	CommonCommand command = new CommonCommand("com.eactive.eai.agent.adapter.ReloadAdapterGroupCommand",adapterGroupName);

   String[] result = new String[table.size()];
    for(int i=0; i < table.size();i++) {
    	String[] array = (String[])table.get(i);
   		HashMap res = agentUtilService.broadcast(array[0], array[1], command);
   		result[i] = res.toString();
       	logger.debug("---- 어댑터리로드("+adapterGroupName+") : " + array[0] + " : " + array[1]);
    }


		
}

/*
 *	Adapter Property 메모리 동기화
 *	
 */
public void adapterPrptySync(Vector table,String adapterGroupName, String serverType) throws Exception {
	OnlAgentUtilServiceImpl	agentUtilService = new OnlAgentUtilServiceImpl();
	
	int index = 0;
	Vector<String[]> adptrPrptyGroupList = getAdptrPrptyGroupList(serverType, adapterGroupName);//개발 From Db
	
	for(String[] arrPrptyGroupName : adptrPrptyGroupList)
	{
		CommonCommand command = new CommonCommand("com.eactive.eai.agent.adapter.ReloadAdapterPropGroupCommand", arrPrptyGroupName[0]);
		
		String[] result = new String[table.size()];
		
	    for(int i=0; i < table.size();i++) {
	    	String[] array = (String[])table.get(i);
	   		HashMap res = agentUtilService.broadcast(array[0], array[1], command);
	   		result[i] = res.toString();
	       	logger.debug("---- 어댑터 프라퍼티 리로드("+arrPrptyGroupName[0]+") : " + array[0] + " : " + array[1]);
	    }
	}
}

/*
 *	Adapter 메시지 키 동기화
 *	
 */
public void adapterMessageKeySync(Vector table,String adapterGroupName, String serverType) throws Exception {
	OnlAgentUtilServiceImpl	agentUtilService = new OnlAgentUtilServiceImpl();
	
	Vector<String[]> adptrMessageKeyList = getAdptrMessageKeyList(serverType, adapterGroupName);//개발 From Db
	String messageKey = "";
	String ioDstcd = "";
	String key = "";
	for(String[] adapterMessageKey : adptrMessageKeyList)
	{
		messageKey = adapterMessageKey[0];
		ioDstcd = adapterMessageKey[1];
		
		key = messageKey + "," + ioDstcd;
		
		CommonCommand command = new CommonCommand("com.eactive.eai.agent.messagekey.ReloadMessageKeyCommand", key);
		
		String[] result = new String[table.size()];
	    for(int i=0; i < table.size();i++) {
	    	String[] array = (String[])table.get(i);
	   		HashMap res = agentUtilService.broadcast(array[0], array[1], command);
	   		result[i] = res.toString();
	       	logger.debug("---- 메시지 키 리로드("+adapterGroupName+") : " + array[0] + " : " + array[1]);
	    }
	}
}
public HashMap MergeDataByInsAndServerType(HashMap paramMap){
	// inst0, inst1 : dev
	// inst2, inst3 : qa
	// int4 ~ inst9 : real
	
	//HashMap hm01 =(HashMap)hm.get("inst0");
	//HashMap hm02 =(HashMap)hm.get("inst1");
	
	//HashMap hm03 =(HashMap)hm.get("inst2");
	//HashMap hm04 =(HashMap)hm.get("inst3");
	//---------dev, qa 는 instance 1개? merge 대상 아님 
	
/*
- <Row>
  <Data>fepOnlSvr11</Data> 
  <Data>_EDU_IO_NET_AsS</Data> 
  <Data>_EDU_IO_NET_AsS{I11}</Data> 
  <Data>1</Data>                    <== max connect
  <Data>1</Data>                    <== connection 갯수
  <Data>0</Data>                    <== send 건수
  <Data>1</Data>                    <== recv 건수
  <Data>10</Data>                   <== error 건수
  <Data>true</Data>                 <== status
  </Row>

*/	
	ArrayList al = new ArrayList();
	al.add(paramMap.get("inst0"));
	al.add(paramMap.get("inst1"));
	al.add(paramMap.get("inst2"));
	al.add(paramMap.get("inst3"));
	al.add(paramMap.get("inst4"));
	al.add(paramMap.get("inst5"));
	
	HashMap<String,Object> real = new HashMap();
	for(int i =0; i <al.size(); i++){
		HashMap<String,String[]> hm = (HashMap)al.get(i);
		for(String key : hm.keySet()){
			String[] data	 = (String[])real.get(key);
			String[] oldData = (String[])hm.get(key);
			if(data == null){
				real.put(key,oldData);
				continue;
			}	
			if(oldData != null){
	        	data[2] = oldData[2] + "," + data[2]  ;
	        	data[3] = oldData[3]  ;
	        	data[4] = Integer.toString(Integer.parseInt(oldData[4]) +  Integer.parseInt(data[4]))  ;
	        	data[5] = Integer.toString(Integer.parseInt(oldData[5]) +  Integer.parseInt(data[5]))  ;
	        	data[6] = Integer.toString(Integer.parseInt(oldData[6]) +  Integer.parseInt(data[6]))  ;
	        	data[7] = Integer.toString(Integer.parseInt(oldData[7]) +  Integer.parseInt(data[7]))  ;
	        	data[8] = Integer.toString(Integer.parseInt(oldData[8]) +  Integer.parseInt(data[8]))  ;
	        	data[9] = Boolean.parseBoolean(oldData[9]) || Boolean.parseBoolean(data[9]) ? "true" : "false";		
        	}	
		}
		
	
	}
	
	return real;
 	//어뎁터명으로 하나로 통합

 	
}
public String[] adapterControl(String serverType, String controlType, String adapterName ,ServletRequest request) throws Exception {
	String[] results = new String[2];
	synchronized(obj){
		int result =0;
		Vector v ;
		logger.info("AdapterControl Access Client IP : " +request.getRemoteAddr() + ", serverType : " +serverType + ", controlType : " +controlType + ", adapterName : " + adapterName);
		//개발
		//1. db변경
		result = setAdapterUseYn(controlType, adapterName, serverType );
		
		v = getServerUrl(serverType);
		// 2. 메모리 변경
		// 2-1. 어댑터 프라퍼티 메모리 변경 
		// ○(On) Button Click 했을 때만 Property Reload
		if("1".equals(controlType))
		{
			adapterMessageKeySync(v,adapterName, serverType);			// 메시지 키 reload
			adapterPrptySync(v,adapterName, serverType);
		}
		
		// 2-2. 어댑터 메모리 변경
		adapterSync(v,adapterName);
	
		results[0] = adapterName+"|";
		results[1] = result>=1?"success":"failed";
	}	
	return results;
	
}

%>


<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
%>

<%
	request.setCharacterEncoding("euc-kr");
	String filter = request.getParameter("filter");
	String serverType = request.getParameter("serverType");
	String controlType = request.getParameter("controlType");
	String adapterName = request.getParameter("adapterName");
	String userType=request.getParameter("userType");

	String realYN = request.getParameter("realYN");
	String realStatus = request.getParameter("realStatus");
	//String displayType=request.getParameter("displayType");
	String displayType="all";
	if (filter == null) filter = "";
	if (serverType == null) serverType = "";
	if (controlType == null) controlType = "";
	if (adapterName == null) adapterName = "";
	if (userType == null) userType = "";			
	if (displayType == null) displayType = "";	

	if (realYN == null) realYN = "";	
	if (realStatus == null) realStatus ="";		
	
	String adapterResult ="";
	if (!"".equals(serverType) && !"".equals(controlType) && !"".equals(adapterName)  ){
		 String[] result = adapterControl(serverType, controlType, adapterName , request);
		 if (result != null) {
			 for (String data : result){
				 adapterResult = adapterResult + data;
			 }
		 }
	}
	
	HashMap hm = getToBeStatus();	//From Memory
	HashMap realHm = MergeDataByInsAndServerType(hm);
	if(hm.get("inst0") == null)
		logger.debug("개발 동기화서버_11 is closed");
	if(hm.get("inst1") == null)
		logger.debug("개발 동기화서버_12 is closed");
	if(hm.get("inst2") == null)
		logger.debug("검증 동기화서버_11 is closed");
	if(hm.get("inst3") == null)
		logger.debug("검증 동기화서버_12 is closed");					

		

%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script language="javascript" src="<c:url value="/common/js/common.js" />"></script>
 <jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/> 
<script language="javascript" src="<c:url value="/js/jquery-1.7.2.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jquery-ui.min.js"/>"></script>
<script language="javascript" >
var $ = jQuery.noConflict();
<%
	if ("admin".equals(userType)){
%>
$(document).ready(function() {
<%-- 	var displayType = "<%=displayType%>";
	if(displayType != "all")
		$("table").width("1350px"); --%>
	//get selected value after Submit
	$("select[name=realYN]").val("<%=realYN%>");
	$("select[name=realStatus]").val("<%=realStatus%>");	

	$("input[name=realControlOn]").click(function (){
			var target = $(this).parent().parent().first().children().children();
			$("input[name=serverType]").val("real");
			$("input[name=controlType]").val("1");
			$("input[name=adapterName]").val(target.html());
			$("form[name=search]").submit();
		});
		$("input[name=realControlOff]").click(function (){
			var target = $(this).parent().parent().first().children().children();
			$("input[name=serverType]").val("real");
			$("input[name=controlType]").val("0");
			$("input[name=adapterName]").val(target.html());
			$("form[name=search]").submit();
		});
		$("input[name=realDisplay]").click(function (){
			var target = $(this).parent().parent().first().children().children();
			var str = escape(target.html());
			var instance = $(this).parent().parent().children().eq(2).children();
			var instNum = instance.html().substring(instance.html().length-1);
			var filter = /^[a-zA-Z]+1[0-9]$/;
			if (filter.test(instance.html())){
				window.open("http://<%=REAL_IP[0]%>"+":2011"+instNum+"/adapters/"+str);
			}else{
				window.open("http://<%=REAL_IP[1]%>"+":2011"+instNum+"/adapters/"+str);
			}
		});	


	$("select[name=devYN]").change(function(){
	
		$("form[name=search]").submit(); 
	});
	$("select[name=testYN]").change(function(){
	
		$("form[name=search]").submit(); 
	});
	$("select[name=realYN]").change(function(){
	
		$("form[name=search]").submit(); 
	});	
	$("select[name=devStatus]").change(function(){
	
		$("form[name=search]").submit(); 
	});
	$("select[name=testStatus]").change(function(){
	
		$("form[name=search]").submit(); 
	});	
	$("select[name=realStatus]").change(function(){
	
		$("form[name=search]").submit(); 
	});		
	$("input[name=btn_clear]").click(function(){
		$("select[name=devYN]").val("");
		$("select[name=devStatus]").val("");
		$("select[name=testYN]").val("");
		$("select[name=testStatus]").val("");
		$("input[name=filter]").val("");
		$("form[name=search]").submit(); 
	});	
	
	
});
<%
	}
%>

</script>
</head>
	<body>
		<form name="search" action="" method=post>
		<%
		if ("admin".equals(userType)){
		%>
			<input type="hidden" name=serverType value="" > 
			<input type="hidden" name=controlType value="" > 
			<input type="hidden" name=adapterName value="" > 
			
			
		<%
		}
		%>
			<input type="hidden" name=userType value="<%=userType%>">
			<input type="hidden" name=displayType value="<%=displayType%>" >
			<input type="text" name=filter value="<%=filter%>"> <input type="submit" value="검색"/>
		<%
		if ("admin".equals(userType)){
		%>
			REAL : <select name=realYN><option value="">전체</option><option value="1">ON</option><option value="0">OFF</option></select>
			<select name=realStatus><option value="">전체</option><option value="1">O</option><option value="0">X</option></select>			
			<input type=button name=btn_clear value=clear />
		<%
		}
		%>			
		</form>

		<table>
			<tr><td><div name="result"><%= adapterResult%></div></td></tr>
		</table>
		
		
		<table width="1165px" border="1" cellpading="0" cellspaceing="0" bgcolor="#D8D8D8" bodercolor="#000000" style="border-collapse:collapse">
			<tr>
				<td colspan="3" align="center">어댑터</td>
				<td colspan="4" align="center">REAL</td>
			</tr>	
			<tr>
				<td width="215px" align="center">어댑터명</td>
				<td width="365px" align="center">어댑터설명</td>
				<td width="80px" align="center">인스턴스</td>
				<td width="65px" align="center">On/Off</td>
				<td width="40px" align="center">상태</td>
				<td width="40px" align="center">송신건</td>
				<td width="40px" align="center">수신건</td>
	
			</tr>	
		</table>
		<div style="width:1185px;height:85%;overflow:auto;">
		
	    <table width="1165px" border="1" cellpading="0" cellspaceing="0" bodercolor="#000000" style="border-collapse:collapse">
		<%
			//Vector<String[]> list3 = getRealList("real");//운영 From Db
			Vector<String[]> list3 = getList("real");//운영 From Db
			int i=0;
			for( String[] row : list3){	
				 if (row[0].indexOf(filter) >= 0 ||  row[1].indexOf(filter) >= 0 ) {
					if(!"".equals(realYN) || !"".equals(realStatus)){

						if(!"".equals(realYN) && !realYN.equals(row[2]))	continue;
						String _realStatus = checkStatus(realHm, row[0]);

						if(!"".equals(realStatus) && !realStatus.equals(_realStatus))	continue;
						
					}
					i++;
					String color ="";
					color = "1".equals(checkStatus(realHm,row[0]))?"blue":"";
				
		%>

			<tr bgcolor="<%=i%2==0?"#F4F4F4":""%>">
				<td width="215px"><font color="<%=color%>"><%=row[0]%></font></td>
				<td width="365px"><font color="<%=color%>"><%=row[1]%></font></td>
				<td width="80px"><font color="<%=color%>"><%=row[3]%></font></td>
				<td width="65px">
				<%
				if ("admin".equals(userType)){
				%>
				<%
					if ("1".equals(row[2])){
				%>
				<input type=button name="realControlOn" value="O" disabled>
				<input type=button name="realControlOff" value="X">
				<input type=button name="realDisplay" value="D">
				<%
					}else{
				%>
				<input type=button name="realControlOn" value="O">
				<input type=button name="realControlOff" value="X" disabled>
				<%
					}
				}else{
				%>
				<%="1".equals(row[2])?"On":"Off"%>
				<%
				}
				%>				
				</td>			 			
				<td width="40px"><%=displayStatus(realHm,row[0],9,"green") %></td>
				<td width="40px"><%=displayStatus(realHm,row[0],6,"green") %></td>
				<td width="40px"><%=displayStatus(realHm,row[0],7,"green") %></td>				
			</tr>	
			
		<%
				
				}
			}
		%>
       </table>		
       </div>
	</body>
</html>

