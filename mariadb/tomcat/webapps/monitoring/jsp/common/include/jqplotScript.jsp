<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- Chart Include -->
<script language="javascript" src="<c:url value="/js/jquery.jqplot.min.js"/>"></script>
<!--[if IE]><script type="text/javascript" src="<c:url value="/js/excanvas.min.js"/>"></script><![endif]-->

<script language="javascript" src="<c:url value="/js/jqplot.cursor.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jqplot.categoryAxisRenderer.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jqplot.barRenderer.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jqplot.pointLabels.min.js"/>"></script>
<script language="javascript" src="<c:url value="/js/jqplot.enhancedLegendRenderer.min.js"/>"></script>


<script type="text/javascript">
	var maxVal			= 0;		// Line ��Ʈ�� Y�� Max�� ����.
	var setMaxVal		= 0;		// Line ��Ʈ�� Y�� Max�� ��� ����.
	
	function getIeVersion()
	{
		var userAgent	= navigator.userAgent;
		var msieIdx		= userAgent.indexOf("MSIE");
		var ie_v		= "";
		
		// msieIdx check.
		// msieIdx : userAgent���ڿ����� MSIE�� ������ -1�� ����˴ϴ�.
		
		// navigator.userAgent���ڿ����� IE 11�������� MSIE�� �����ϴ�.
		if(msieIdx != -1)
		{
			ie_v = userAgent.substr(msieIdx+5, 3);
			return parseInt(ie_v, 10);
		}
	}
	
	// Internet Explorer version check.
	function ieV8Chk()
	{
		var ie_v = getIeVersion();
		
		return ie_v <= 8 ? true : false;
	}
	
	
	// from ~ to Date check
	function isFromToDate(frDt, toDt, dtType)
	{
		var returnFlag	= true;
		var strFrDt		= "";
		var strToDt		= "";
		var numChck;
		
		if(dtType == "" || dtType == null || dtType == undefined)
		{
			numChck		= /^(19|20)\d{2}/;
		}
		else
		{
			numChck		= /^(19|20)\d{2}(0[0-9]|1[0-2])(0[1-9]|[12][0-9]|3[0-1])*$/;
		}
		
		if(frDt == "" || frDt == undefined || frDt == null)
		{
			returnFlag = false;
		}
		else if(toDt == "" || toDt == undefined || toDt == null)
		{
			returnFlag = false;
		}
		else{
			strFrDt		= frDt.replace(/\-/g, "");
			strToDt		= toDt.replace(/\-/g, "");
			
			if(!numChck.test(strFrDt))
			{
				returnFlag = false;
			}
			else if(!numChck.test(strToDt))
			{
				returnFlag = false;
			}
			else if(parseInt(strFrDt, 10) > parseInt(strToDt, 10))
			{
				returnFlag = false;
			}
		}
		
		return returnFlag;
	}
	
	
	// Set Date Format
	function setDateFormat(strDate)
	{
		var dateLen		= 0;
		var resultDate	= "";
		
		if(strDate != null)
		{
			dateLen		= strDate.length;
			
			if(dateLen == 6)
			{
				resultDate += strDate.substr(0, 4) + "-" + strDate.substr(4, 2);
			}
			else if(dateLen == 8)
			{
				resultDate += strDate.substr(0, 4) + "-" + strDate.substr(4, 2) + "-" + strDate.substr(6, 2);
			}
			else
			{
				resultDate += strDate;
			}
		}
		
		return resultDate;
	}
	
	
	
	// jqplot Line ��Ʈ �׸��� �Լ�.
	function jqLineChart(chartId, rows, axisInt, prefix, topTitle)
	{
		var returnPlot;		// plot Object ����.
		
		// ��Ʈ �׸���.
		returnPlot = $.jqplot(chartId, getLines(rows, axisInt, prefix), setChartOptinos(rows, axisInt, topTitle));
				
		return returnPlot;
	}
	
	// jqplot Bar ��Ʈ �׸��� �Լ�.
	function jqBarchart(chartId, rows, prefix1, prefix2, topTitle)
	{
		var returnPlot;		// plot Object ����.

		// ��Ʈ �׸���.
		returnPlot = $.jqplot(chartId, getBars(rows, prefix1, prefix2), setBarChartOptinos(rows, topTitle));
		
		return returnPlot;
	}
	
	
	// Bar Chart�� Legend Label ����.
	function getLegendLabels(rows)
	{
		var labels	= [];
		var idx		= 0;

		for(var i = 0; i < rows.length; i++)
		{
			if(labels[idx-1] == undefined || labels[idx-1] != rows[i]["STATCY"])
			{
				labels[idx++] = rows[i]["STATCY"];
			}
		}
		
		return labels;
	}
	
	
	/* Cahrt y�� tick value ����.*/
	function getTickInterval()
	{
		var tickInt = 1;
		var tickVal	= 0;

		// Browser üũ.
// 		if(ieV8Chk())
// 		{
// 			// IE 8����
// 			tickVal = setMaxVal;
// 		}
// 		else
// 		{
// 			// IE 9�̻�
// 			tickVal = maxVal;
// 		}
		
		tickVal = setMaxVal;

		if(tickVal > 10)
		{
			tickInt = tickVal * 0.1;
		}
		
		return parseInt(tickInt, 10);
	}
	
	
	// ��Ʈ(jqplot)�� Line ����.
	// DB���� ��ȸ�� ������ ��Ʈ���� ��� �� Line ����.
	function getLines(rows, colCnt, prefix)
	{
		var rowCnt	= rows.length;	// row Count.
		var fields	= [];			// x��, y�� ���� ����.
		var values	= [];			// x��, y�� Array ����.
		var lines	= [];			// values Array ����.
		
		maxVal		= 0;			// y�� MaxVal �ʱ�ȭ.
		
		// Grid�� �����Ͱ� ������ ��Ʈ �̹����� Rendering
		if(rowCnt == 0)
		{
			return lines[0] = [[0,0]];
		}
		
		// IE 8���� ������ �� ��Ʈ �̹����� Rendering => rowData 1�� �̻��ΰ�� �⺻�� ����
// 		if(ieV8Chk() == true && rowCnt > 1)
		if(rowCnt > 1)
		{
			return lines[0] = [[0,0]];
		}
	
		// ��Ʈ ������ ����.
		// 1�� Loop (row Count)
		for(var i = 0; i < rowCnt; i++)
		{
			values= [];
			
			// 2�� Loop (row Column Count)
			for(var j = 1; j <= colCnt; j ++)
			{
				fields = [];
				
				fields[0] = j;
				fields[1] = rows[i][prefix + fields[0]];
	
				values[j-1] = fields;
				
				if(parseInt(maxVal, 10) < parseInt(fields[1], 10))
				{
					maxVal = fields[1];
				}
			}
			
			lines[i] = values;
		}
		
		return lines;
	}
	
	// ��Ʈ(jqplot) ������ ���� �Լ�.
	function setChartOptinos(rows, xAxisInt, topTitle)
	{
		var rowCnt		= rows.length;	// row Count.
		var arrTicks	= [];			// x�� ���� ����.
		var returnOptions;				// plot Option ����.
		var yAxis;
		
		// ��Ʈ X �� ���� ǥ�� data.
		for(var i = 1; i <= xAxisInt; i++)
		{
			arrTicks[i-1] = i;
		}
		
		// start y�� �ɼ� ����.
		if(rowCnt == 1)
		{
			var maxLen		= maxVal.length;
			var divisionVal = 1;
			var addVal		= 0;
			
			setMaxVal		= 0;
			
			for(var i = 0; i < (maxLen-1); i++)
			{
				divisionVal *= 10;
			}
	
			addVal		= divisionVal * parseInt(maxVal / divisionVal , 10);
			setMaxVal	= (parseInt(maxVal / divisionVal , 10) * divisionVal) + (addVal);
			
			yAxis = {
					min: 0,
					max: setMaxVal,
					numberticks: 11,
					tickInterval: getTickInterval(),
					tickOptions: {
									formatString:"%'d",
// 									fontString:"%'d",
									fontSize: "8pt"
								 },
				  };
		}
		else
		{
			yAxis = {
					min: 0,
					numberticks: 11,
					tickInterval: getTickInterval(),
					tickOptions: {
									formatString:"%'d",
// 									fontString:"%`d",
									fontSize: "8pt"
								 },
				  };
		}
		// end y�� �ɼ� ����.
		
		returnOptions = {
							title: topTitle,
							
							grid: {background: 'white',	drawBorder: true, shadow: false},
							seriesDefaults: {rendererOptions: {smooth: true}},		
							series:[{lineWidth:2, color:'#ff6384', shadow:false}],
							axes:{
									xaxis:{
											min:0,
											max:xAxisInt,
											numberTicks:1,
											renderer:$.jqplot.CategoryAxisRenderer,
											ticks:arrTicks,
											tickOptions:{
															formatString:"%d",
															fontSize: "10pt"
														}
										  },
										  
									yaxis: yAxis,
								 },
							
// 							cursor:{
// 								show:true,
// 								zoom:true
// 							},
						};
/* SAMPLES 170210
 				animate: true,
				title:{text:'���۰Ǽ�',fontFamily:'Malgun Gothic, dotum, sans-serif', fontSize: '16px', textColor: '#000000'}, 
				grid: {background: 'white',	drawBorder: true, shadow: false},
				seriesDefaults: {rendererOptions: {smooth: true}},		
				series:[
						{lineWidth:3, color:'#009ce5', shadow:false},
						{lineWidth:3, color:'#1cc799', shadow:false},
						{lineWidth:3, color:'#7fc80b', shadow:false},
						{lineWidth:3, color:'#ffc600', shadow:false},
						{lineWidth:3, color:'#ff8839', shadow:false},
						{lineWidth:3, color:'#ff4239', shadow:false},
						{lineWidth:3, color:'#ff8aa8', shadow:false},
						{lineWidth:3, color:'#b569f5', shadow:false},
						{lineWidth:3, color:'#737373', shadow:false},
						],
				axes: {xaxis: {pad: 2.0, tickOptions: {showGridline: false}}, yaxis: {pad: 1.05}}	 */		
		return returnOptions;
	}
	
	
	/* Bar Cahrt */
	// ��Ʈ(jqplot)�� Bar ����.
	// DB���� ��ȸ�� ������ ��Ʈ���� ��� �� Bar ����.
	function getBars(rows, prefix1, prefix2)
	{
		var rowCnt	= rows.length;	// row Count.
		var fields	= [];			// x��, y�� ���� ����.
		var values	= [];			// values Array ����.
		var bars	= [];			// values Array ����.
		var groupStatcy = 0;
		var groupIdx = 0;
		var j = 0;
		
		maxVal		= 0;			// y�� MaxVal �ʱ�ȭ.
		
		// Grid�� �����Ͱ� ������ ��Ʈ �̹����� Rendering
		if(rowCnt == 0)
		{
			return bars[0] = [[0,0]];
		}
		
		// ��Ʈ ������ ����.
		// Loop (row Count)
		groupStatcy = rows[0]["STATCY"];
		values = [];
		for(var i = 0; i < rowCnt; i++)
		{
			if(groupStatcy != rows[i]["STATCY"])
			{
				groupStatcy = rows[i]["STATCY"];
				bars[groupIdx++] = values;
				j = 0;
				values = [];
			}
			
			fields = [];
			
			fields[0] = rows[i][prefix1];
			fields[1] = rows[i][prefix2];
			
			values[j] = fields;
			
			if(parseInt(maxVal, 10) < parseInt(fields[1], 10))
			{
				maxVal = fields[1];
			}
			
			if(i == (rowCnt-1))
			{
				bars[groupIdx] = values;
			}
			
			j++;
		}

		return bars;
	}
	
	// ��Ʈ(jqplot) ������ ���� �Լ�.
	function setBarChartOptinos(rows, topTitle)
	{
		var rowCnt		= rows.length;	// row Count.
		var returnOptions;				// plot chart Option ����.
		var yAxis;
		var legendLabels = getLegendLabels(rows);
		
		// start y�� �ɼ� ����.
		if(rowCnt == 1)
		{
			var maxLen		= maxVal.length;
			var divisionVal = 1;
			var addVal		= 0;
			
			setMaxVal		= 0;
			
			for(var i = 0; i < (maxLen-1); i++)
			{
				divisionVal *= 10;
			}
	
			addVal		= divisionVal * parseInt(maxVal / divisionVal , 10);
			setMaxVal	= (parseInt(maxVal / divisionVal , 10) * divisionVal) + (addVal);

			yAxis = {
						min: 0,
						max: setMaxVal,
						numberticks: 11,
						tickInterval: getTickInterval(),
						tickOptions: {
// 										formatString:"%d"
										fontString:"%d",
										fontSize: "12px"
									 }
				    };
		}
		else
		{
			yAxis = {
						min: 0,
						numberticks: 11,
						tickOptions: {
// 										formatString:"%d"
										fontString:"%d",
										fontSize: "12px"
									 }
				    };
		}
		// end y�� �ɼ� ����.
		
		returnOptions = {
							title: topTitle,
							seriesDefaults:{
								renderer: $.jqplot.BarRenderer,
								rendererOptions:{
													barWidth: 20
												,	barPadding: 10
												,	barMargin: 0
												},
								pointLabels: { show: true}
							},
							legend:{
								renderer: $.jqplot.EnhancedLegendRenderer,
								show: true,
								location: "n",
								labels: legendLabels,
								rendererOptions:{numberRows: 1, placement: "outsideGrid", disableIEFading:true, paddingLeft:"8"},
								marginTop: '10px',
								fontSize: "1.2em"
							},
							axesDefaults: {
								tickRenderer: $.jqplot.CanvasAxisTickRenderer,
								tickOptions:{
									fontSize: "9pt"
								}
							},
							axes:{
								xaxis:{
									renderer:$.jqplot.CategoryAxisRenderer
								},
								yaxis: yAxis
							},
							cursor:{
								show:false,
								zoom:false
							}
						};
						
		return returnOptions;
	}
</script>