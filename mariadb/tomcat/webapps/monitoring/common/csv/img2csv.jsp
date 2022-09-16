<%@ page import="java.io.*,java.util.*,java.text.*,com.gauce.*,com.gauce.io.*,com.gauce.log.*,com.gauce.http.*, com.gauce.common.*"%><%
	GauceOutputStream gos = null;

	File fImage[]                ={null, null, null, null, null, null, null, null, null, null};
	FileInputStream isImage[]    ={null, null, null, null, null, null, null, null, null, null};
	String imgs[] = {"bt_boot_sm.gif", "bt_convert_sm.gif", "bt_end_sm.gif", "bt_initialize_sm.gif",
			"bt_level0_sm.gif","bt_level1_sm.gif", "bt_level2_sm.gif", "bt_LUboot_sm.gif", "bt_LUclose_sm.gif", "bt_level3_sm.gif"};
	String ids[] = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10"};
	GauceDataRow row[] = {null, null, null, null, null, null, null, null, null, null};

	try {
		/*			
		01 : bt_boot_sm.gif
		02 : bt_convert_sm.gif
		03 : bt_end_sm.gif
		04 : bt_initialize_sm.gif
		05 : bt_level0_sm.gif
		06 : bt_level1_sm.gif
		07 : bt_level2_sm.gif
		08 : bt_LUboot_sm.gif
		09 : bt_LUclose_sm.gif
		*/

	    //response.setContentType("application/octet-stream;charset=ISO-8859-1");
		gos =((HttpGauceResponse) response).getGauceOutputStream();

		GauceDataSet dSet = new GauceDataSet();
		gos.fragment(dSet);
		
	    dSet.addDataColumn(new GauceDataColumn("tb_img",		GauceDataColumn.TB_BLOB));
	    dSet.addDataColumn(new GauceDataColumn("tb_img_id",		GauceDataColumn.TB_STRING, 3));
	    dSet.addDataColumn(new GauceDataColumn("tb_img_size",	GauceDataColumn.TB_INT));

		String dir = request.getRequestURI().replace("monitoring/", ""); 
		dir = dir.substring(0, dir.lastIndexOf("/"));
		dir = request.getRealPath(dir) + "\\..\\..\\images\\bt\\";

		try {
			for (int i = 0; i < imgs.length; i++) { 
				fImage[i] = new File(dir + imgs[i]);
				isImage[i] = new FileInputStream(fImage[i]);
		
		        row[i] = dSet.newDataRow();
				row[i].addColumnValue(isImage[i]);
				row[i].addColumnValue(ids[i]);
				row[i].addColumnValue(fImage[i].length());
				dSet.addDataRow(row[i]);
			}


		} catch (Exception fe) {

	        fe.printStackTrace();
	    }

		gos.write(dSet);
	} catch (Exception e) {
	    e.printStackTrace();
	} finally {
	    try {
			for (int i = 0; i < imgs.length; i++) { 
	        	isImage[i].close();
			}
	        gos.close();

	    } catch(Exception e) {
	        e.printStackTrace();        
			gos = null;
		}
	}

%>