<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ include file="/jsp/common/include/localemessage.jsp" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<jsp:include page="/jsp/common/include/css.jsp" />
<jsp:include page="/jsp/common/include/script.jsp" />
<script language="javascript">
	var url = '<c:url value="/onl/adapter/socket/socketStatus.json" />';
	var url_view = '<c:url value="/onl/adapter/socket/socketStatus.view" />';
	var timer;

	function init(callback) {
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : {
				cmd : 'LIST_INIT_COMBO'
			},
			success : function(json) {
				new makeOptions("CODE", "NAME").setObj(
						$("select[name=searchRealTimeCd]")).setData(
						json.realTimeGroupRows).rendering();

				if (typeof callback === 'function') {
					callback();
				}
			},
			error : function(e) {
				alert(e.responseText);
			}
		});
	}

	function list() {
		var postData = getSearchForJqgrid("cmd", "LIST"); //jqgrid에서는 object 로
		$("#grid").setGridParam({
			url : url,
			postData : postData,
			datatype : 'json'
		}).trigger("reloadGrid");
	}
	function unformatterFunction(cellvalue, options, rowObject) {
		return "";
	}

	function formatterFunction(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		if (cellvalue == "03") {
			return "<img id='btn_stop' src='<c:url value='/images/bt/bt_end_sm.gif'/>' name='img_"
					+ rowId + "' />";
		} else if (cellvalue == "01") {
			return "<img id='btn_start' src='<c:url value='/images/bt/bt_boot_sm.gif'/>' name='img_"
					+ rowId + "' />";
		}
	}

	function fontFormatterFunction(cellvalue, options, rowObject) {
		var rowId = options["rowId"];
		if (cellvalue == "true") {
			return "<font color='#0000FF'>" + cellvalue + "</font>";
		} else if (cellvalue == "false") {
			return "<font color='#FF0000'>" + cellvalue + "</font>";
		}
	}
	function startStop(postData) {
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			data : postData,
			success : function(json) {
				list();
			},
			error : function(e) {
				alert(e.responseText);
			}
		});
	}
	
	function goDetail(obj, rowId) {
		var rowData = obj
				.getRowData(rowId);
		var key = rowData['EaiSevrInstncName'];
		var key2 = rowData['AdptrBzwkGroupName'];

		var url2 = '<c:url value="/onl/adapter/socket/socketConnection.view" />';
		url2 += "?cmd=LIST";
		url2 += "&searchEaiSevrInstncName="
				+ key;
		url2 += "&searchAdptrBzwkGroupName="
				+ key2;
		goNav(url2);
	}
	
	$(document)
			.ready(
					function() {
						$("select[name=searchRealTimeCd]").hide();

						var mod = sessionStorage["mod"];

						if (mod == undefined || mod == "")
							mod = "ALL";
						else
							sessionStorage["mod"] = "";

						$(
								"input:radio[name=searchType]:radio[value='"
										+ mod + "']").attr("checked", true);

						$('#grid')
								.jqGrid(
										{
											datatype : "local",
											mtype : 'POST',
											//url : url,
											//postData : gridPostData,
											colNames : [ '<%= localeMessage.getString("adapterStat.instanceName") %>',
													'<%= localeMessage.getString("adapterStat.adapterGroup") %>[TX]',
													'<%= localeMessage.getString("adapterStat.adapterName") %>',
													'<%= localeMessage.getString("adapterStat.adapterDesc") %>',
													'<%= localeMessage.getString("adapterStat.adapterDv") %>',
													'<%= localeMessage.getString("adapterStat.status") %>',
													'<%= localeMessage.getString("adapterStat.startStat") %>',
													'<%= localeMessage.getString("adapterStat.startup") %>' ],
											colModel : [
													{
														name : 'EaiSevrInstncName',
														align : 'left',
														width : '100',
														sortable : false
													},
													{
														name : 'AdptrBzwkGroupName',
														align : 'left',
														width : '140'
													},
													{
														name : 'AdptrBzwkName',
														align : 'left',
														width : '170'
													},
													{
														name : 'AdptrBzwkDesc',
														align : 'left',
														width : '200'
													},
													{
														name : 'AdptrType',
														align : 'center',
														width : '80'
													},
													{
														name : 'Status',
														align : 'center',
														width : '40',
														unformat : unformatterFunction,
														formatter : fontFormatterFunction
													},
													{
														name : 'Starting',
														align : 'center',
														width : '55'
													},
													{
														name : 'StartStop',
														align : 'center',
														width : '60',
														unformat : unformatterFunction,
														formatter : formatterFunction
													} ],
											jsonReader : {
												repeatitems : false
											},
											rowNum : 10000,
											height : '500',
											viewrecords : true,
											gridview : true,
											ondblClickRow : function(rowId) {
											console.log("rowId", rowId);
												var rowData = $(this)
														.getRowData(rowId);
												var key = rowData['EaiSevrInstncName'];
												var key2 = rowData['AdptrBzwkGroupName'];

												var url2 = '<c:url value="/onl/adapter/socket/socketConnection.view" />';
												url2 += "?cmd=LIST";
												url2 += "&searchEaiSevrInstncName="
														+ key;
												url2 += "&searchAdptrBzwkGroupName="
														+ key2;
												goNav(url2);
											},
											loadComplete : function(d) {
												$("img[name*=img]").unbind(
														"click");

												$("img[name*=img]")
														.click(
																function() {
																	//alert('click');
																	var name = $(
																			this)
																			.attr(
																					"name");
																	var rowId = name
																			.split("_")[1];
																	var control = $(
																			this)
																			.attr(
																					"id")
																			.split(
																					"_")[1];
																	var data = $(
																			'#grid')
																			.jqGrid(
																					'getRowData',
																					rowId);
																	var postData = [];
																	postData
																			.push({
																				name : "cmd",
																				value : "TRANSACTION_STARTSTOP"
																			});
																	postData
																			.push({
																				name : "control",
																				value : control
																			});
																	postData
																			.push({
																				name : "eaiInstanceName",
																				value : data["EaiSevrInstncName"]
																			});
																	postData
																			.push({
																				name : "adapterGroupName",
																				value : data["AdptrBzwkGroupName"]
																			});
																	postData
																			.push({
																				name : "adapterName",
																				value : data["AdptrBzwkName"]
																			});

																	var msgStartStop = control == "start" ? "<%= localeMessage.getString("adapterStat.start") %>"
																			: "<%= localeMessage.getString("adapterStat.close") %>";

													                var resultConfirm = confirm(replaceMsg("<%= localeMessage.getString("common.confirmMsg1") %>"
													                		,msgStartStop,data["AdptrBzwkGroupName"],data["AdptrBzwkName"])); 		
																	/* var resultConfirm = confirm(data["AdptrBzwkGroupName"]
																			+ " "
																			+ data["AdptrBzwkName"]
																			+ "을\n\n"
																			+ msgStartStop
																			+ " 하시겠습니까?"); */

																	if (resultConfirm != true)
																		return;
																	startStop(postData);

																});

											},
											gridComplete : function(d) {
												var colModel = $(this)
														.getGridParam(
																"colModel");
												for (var i = 0; i < colModel.length; i++) {
													$(this)
															.setColProp(
																	colModel[i].name,
																	{
																		sortable : false
																	});
												}

											},
											loadError : function(xhr, status,
													error) {
												alert(error);
												//clearInterval(timer);
											}
										});

						$("#btn_search").click(function() {
							list();
						});
						$("input[name^=search]").keydown(function(key) {
							if (key.keyCode == 13) {
								list();
							}
						});

						$("input:radio[name=searchType]").change(function() {
							var searchType = $(this).val();

							if (searchType == "GRP")
								$("select[name=searchRealTimeCd]").show();
							else
								$("select[name=searchRealTimeCd]").hide();
						});

						buttonControl();
						init(list);

					});
</script>
</head>
<body>
	<div class="right_box">
		<div class="content_top">
			<ul>
			<li><a href=#>${rmsMenuPath}</a></li>
			</ul>						
	</div><!-- end content_top -->
		<div class="content_middle">
			<div class="search_wrap">
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />
			</div>
		<div class="title"><%= localeMessage.getString("socketStat.title") %></div>
			<table class="search_condition" cellspacing=0;>
					<tbody>
						<tr>
							<th style="width:180px;">검색조건</th>
							<td><input type="radio" value="ALL" name="searchType" checked="checked"/>전체
				<input type="radio" value="ERR" name="searchType"/>에러
				<input type="radio" value="24H" name="searchType"/>24시
				<input type="radio" value="24E" name="searchType"/>24시에러
				<input type="radio" value="GRP" name="searchType"/>그룹별
				<select name="searchRealTimeCd" style="width:20%;"></select></td>
						</tr>
						<tr>
							<th style="width:180px;">어댑터 업무그룹</th>
							<td><input type="text" name="searchAdapterGroup" value="${param.searchAdapterGroup}" style="width:100%"></td>
						</tr>
					</tbody>
				</table>	
			<!-- grid -->
		<table id="grid"></table>
		<div id="pager"></div>
					
		<div class="table_wrap col">
			<table width="100%" height="35px">
			</table>			
		</div>
		<!-- end content_middle -->
	</div>
	<!-- end right_box -->
</body>

</html>

