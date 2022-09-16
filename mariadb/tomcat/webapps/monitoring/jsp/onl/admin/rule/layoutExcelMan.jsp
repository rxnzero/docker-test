<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<script >
function getDoc(frame) {
     var doc = null;
 
     // IE8 cascading access check
     try {
         if (frame.contentWindow) {
             doc = frame.contentWindow.document;
         }
     } catch(err) {
     }
 
     if (doc) { // successful getting content
         return doc;
     }
 
     try { // simply checking may throw in ie8 under ssl or mismatched protocol
         doc = frame.contentDocument ? frame.contentDocument : frame.document;
     } catch(err) {
         // last attempt
         doc = frame.document;
     }
     return doc;
 }  

function fileupload(e,successcallback,errorcallback){
     var formObj = $(this);
     var formURL = formObj.attr("action");
     if(window.FormData !== undefined)  // for HTML5 browsers
     {
         var formData = new FormData(this);
         $.ajax({
             url: formURL,
             type: 'POST',
             data:  formData,
             mimeType:"multipart/form-data",
             contentType: false,
             cache: false,
             processData:false,
             success: function(json, textStatus, jqXHR)
             {
            	 $("input[name=file]").val("");
				var data = JSON.parse(json);
				if (data.rows.length==0){
					alert(data.message);
					return ;
				}
				$("#grid").jqGrid('clearGridData');
				
				var rows = $("#grid")[0].rows;
				var index = Number($(rows[rows.length-1]).attr("id"));
				if (isNaN(index)) index=0;
				for(var i=0;i<data.rows.length;i++){
				    var rowid = index + 1 + i;
					$("#grid").jqGrid('addRow', {
			           rowID : rowid,          
			           initdata : data.rows[i],
			           position :"last",    //first, last
			           useDefValues : false,
			           useFormatter : false,
			           addRowParams : {extraparam:{}}
					});
				
				}						
				$("#"+$('#grid').jqGrid('getGridParam','selrow')).focus();
		  		if (typeof callback === 'function') {
					successcallback(data, textStatus, jqXHR);
				}
             },
             error: function(jqXHR, textStatus, errorThrown) 
             {
            	 $("input[name=file]").val("");
             	if (typeof callback === 'function') {
					errorcallback(jqXHR, textStatus, errorThrown);
				}
             }           
         });
         e.preventDefault();
         if (e.unbind)
         	e.unbind();
    }
    else  //for olden browsers
     {
     	 formObj.append($("<input type='hidden' name='serviceType' value='"+sessionStorage["serviceType"]+"' />"));
         //generate a random id
         var  iframeId = 'unique' + (new Date().getTime());
         //create an empty iframe
         var iframe = $('<iframe src="javascript:false;" id="'+iframeId+'" name="'+iframeId+'" />');
  
         //hide it
         iframe.hide();
  
         //set form target to iframe
         formObj.attr('target',iframeId);
         formObj.attr('action','<c:url value="/onl/admin/rule/layoutExcelMan2.file" />');
  
         //Add iframe to body
         iframe.appendTo('body');
         iframe.load(function(e)
         {
             var doc = getDoc(iframe[0]);
             var docRoot = doc.body ? doc.body : doc.documentElement;
             var data = docRoot.innerHTML;
             var k = JSON.parse(data);
             $("#grid")[0].addJSONData(k);
             $("input[name=file]").val("");
             //data is returned from server.
 		  	 if (typeof callback === 'function') {
				//successcallback(data);
			 }
         });
  
     }     
}

	function scall(){
	} 
	function ecall(){
	} 
	
	$(document).ready(function() {
	var gridPostData = getSearchForJqgrid("cmd","LIST"); //jqgrid에서는 object 로 
		$('#grid').jqGrid({
			datatype:"json",
			//mtype: 'POST',
			//url: '<c:url value="/common/acl/user/userMan.json" />',
			postData : gridPostData,
			colNames:['엑셀Sheet명',
	                  '전문레이아웃 코드',
	                  '라인수',
	                  '처리상태',
	                  '결과 메시지'
	                  ],
			colModel:[
					{ name : 'SHEETNAME'   , align:'left'	,sortable:false  },
					{ name : 'LAYOUTNAME' , align:'left'  },
					{ name : 'LAYOUTITEM'  , align:'left'  },
					{ name : 'RESULT'  , align:'left'  },
					{ name : 'MESSAGE'  , align:'left'  }
					],
	        jsonReader: {
	             repeatitems:false
	        },	          
			//pager : $('#pager'),
			//rowNum : '${rmsDefaultRowNum}',
		    autoheight: true,
		    height: 300,
			autowidth: true,
			viewrecords: true,
			//rowList : eval('[${rmsDefaultRowList}]'),
			gridComplete:function (d){
				var colModel = $(this).getGridParam("colModel");
				for(var i = 0 ; i< colModel.length; i++){
					$(this).setColProp(colModel[i].name, {sortable : false});	//그리드 헤더 화살표 삭제(정렬X)		
				}
			
			},				
			ondblClickRow: function(rowId) {
	        },		
			onSelectRow: function(rowId) {
				var data = $(this).getRowData(rowId); 
				$("#ajaxForm input[type!=radio],#ajaxForm select,#ajaxForm textarea").each(function(){
					var name = $(this).attr("name");
					var tag  = $(this).prop("tagName").toLowerCase();
					$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
				});
	       }        
		});
		
		resizeJqGridWidth('grid','content_middle','1000');	
	    $("#multiform").on('submit',fileupload);
		$('#btn_upload').click(function(){
			$("#grid").jqGrid('clearGridData');
			if(window.FormData !== undefined) {
				$("input[name=file]").click();
			}else{
				if ($("input[name=file]").val()==""){
					alert('select file');
					return;
				}
		        $("#multiform").submit();
			}
	        
		});
		if(window.FormData !== undefined) {
			$("input[name=file]").change(function(ev) {
				var filename = $(this).val().split('\\').pop();
				if (filename == ""){
					return;
				}else{
					$("#multiform").submit();
				}
				
			});
		}
		 if(window.FormData !== undefined) {
			$("input[name=file]").hide();
		 }else{
		 	$("input[name=file]").show();
			 
		 }
	});
</script>
</head>
	<body>		
		<div class="right_box">
			<div class="content_top">
				<ul class="path">
					<li><a href="#">${rmsMenuPath}</a></li>					
				</ul>					
			</div><!-- end content_top -->
			<div class="content_middle" id="content_middle">
				<form id="multiform" method="POST" enctype="multipart/form-data" action="<c:url value="/onl/admin/rule/layoutExcelMan.file"/>">
					<div class="search_wrap">
						<div style="display:inline-block;">
							<input type="radio" name="saveType" value="0" checked="checked" id="sub4_4_5_1"><label for="sub4_4_5_1" style="vertical-align:middle;">중복시 저장하지 않음</label>
							<input type="radio" name="saveType" value="1" id="sub4_4_5_2" /><label for="sub4_4_5_2" style="vertical-align:middle;">중복시 저장함</label>
							<input type="file" name="file" style="display:inline-block"/>
							<input type="text" name="cmd" style="display:none" value="UPLOAD"/>
						</div>
					<img src="<c:url value="/img/btn_upload.png"/>" alt="" id="btn_upload" level="W" />
					</div>
				</form>
				<div class="title">전문레이아웃 Excel 등록</div>				
					
				<table id="grid" ></table>
				<div id="pager"></div>
				
				<form id="ajaxForm">
					<table class="table_row" cellspacing="0" style="margin-top:15px;">
						<tr>
							<th style="width:20%;">전문레이아웃코드</th>
							<td style="width:80%;"><input type="text" name="LAYOUTNAME"/></td>
						</tr>
						<tr>
							<th>처리상태</th>
							<td ><input type="text" name="RESULT" /></td>
						</tr>
						<tr height="50px">
							<th>결과 메시지</th>
							<td><textarea  name="MESSAGE" style="width:100%; height:100%;"></textarea></td>
						</tr>
					</table>
				</form>	
				
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>
