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

<jsp:include page="/jsp/common/include/css.jsp"/>
<jsp:include page="/jsp/common/include/script.jsp"/>
<script language="javascript" src="<c:url value="/js/jquery.form.min.js"/>"></script>

<script language="javascript" >


$(document).ready(function() {	
	$("#btn").click(function(){
		var formData = new FormData();
		formData.append("cmd","UPLOAD");
		formData.append("uploadDir",$("input[name=uploadDir]").val());
		$("input[type=file]").each(function(index,value){
			formData.append("files",$(this)[index].files[0]);
		});
		
		$.ajax({  
			type : "POST",
			url:"<c:url value="/onl/admin/rule/transformRuleMan.json"/>",
			dataType:"json",
			data:formData,
  			processData: false,
  			contentType: false,			
			success:function(json){
				alert(json);
			},
			error:function(e){
				alert(e.responseText);
			}
		}); 		
		
		
		
	});
	   //add more file components if Add is clicked
    $('#addFile').click(function() {
        var fileIndex = $('#fileview tr').children().length;      
        $('#fileview').append(
                '<tr><td>'+
                '   <input type="file" name="files['+ fileIndex +']" />'+
                '</td></tr>');
    });  

	buttonControl();
});
 
</script>
</head>
	<body>
	<!-- path -->
	<div class="container">
		<div class="right full">
			<p class="nav">${rmsMenuPath}</p>
		</div>
	</div>
	<!-- title -->
	<div class="container" id="title">
		<div class="left full ">
			<p class="title"><img class="title_image" src="<c:url value="/images/title_bullet.gif"/>">전문레이아웃 변환 매핑</p>
		</div>
	</div>	
	<!-- line -->
	<div class="container">
		<div class="left full title_line "> </div>
	</div>	
	<!-- comment -->
	<div class="container">
		<div class="left full" >
			<p class="comment" >전문레이아웃 변환 매핑엔진의 매핑규칙을 조회하는 화면입니다.</p>
		</div>
	</div>
	
	<!-- button -->
	<table  width="100%" height="35px"  >
	<tr>
		<td align="right" width="150px">
			<img id="btn_new" src="<c:url value="/images/bt/bt_new.gif"/>" level="W"/>
		</td>
	</tr>

	</table>
	<form id="ajaxform" action="" method="post" enctype="multipart/form-data">
		Upload Directory : <input type="text" name="uploadDir" value="d:/fileupload/"/><br><br>
		<input id="addFile" type="button" value="File Add" />   
	   <table id="fileview">
	        <tr>
	            <td><input name="files[0]" type="file" /></td>
	        </tr>        
	    </table>
		<br/><input type="button" id=btn value="Upload" />
	</form>
	</body>
</html>

