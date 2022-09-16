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
<script language="javascript" >
	var serviceType = sessionStorage["serviceType"];
	var isDetail = false;
	var isPopup = false;
	var isChanged = false;
	var oldCnvsnName = null;
	var oldLoutSrc = null;
	var oldLoutTgt = null;
	
	var url      = '<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />';
	var url_view = '<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view" />';
	function makeEaiSvcName(){
		var eaiTranName = $("input[name=eaiTranName]").val();
		if (eaiTranName == "") return;
		
		var io = $("select[name=io]").val();
		if (io == "") return;
		var reqRes = $("select[name=splizDmndDstcd]").val();
		if (reqRes == "") return;
		var inout = "";
		if("EAI"==sessionStorage["serviceType"]){
			if (io=="I"){ //당발 
				inout ="1"; 
			}else{
				inout ="2";
			}
		}else{
			if(reqRes=="S" && io=="O"){ //당발요청
				inout = "2";
			}else if (reqRes=="R" && io=="O"){ //당발응답
				inout = "1";
			}else if (reqRes=="S" && io=="I"){ //타발응답
				inout = "1";
			}else if (reqRes=="R" && io=="I"){ //타발응답
				inout = "2";
			}
		}
		$("input[name=stndTelgmWtinExtnlDstcd]").val(inout);
		$("input[name=eaiSvcName]").val(eaiTranName.trim()+reqRes+inout);
		
		
	}
	function isValid(){
		if ($('select[name=eaiBzwkDstcd]').val()==""){
			alert("업무구분을 선택하여 주십시요.");
			return false;
		}
		if ($('input[name=eaiTranName]').val()==""){
			alert("인터페이스ID를 입력하여 주십시요.");
			return false;
		}
		if ($('input[name=eaiSvcDesc]').val()==""){
			alert("인터페이스ID설명을 입력하여 주십시요.");
			return false;
		}
		if ($('select[name=io]').val()==""){
			alert("당타발구분을 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=splizDmndDstcd]').val()==""){
			alert("전문요청구분을 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=svcMotivUseDstcd]').val()==""){
			alert("송수신방법을 선택하여 주십시요.");
			return false;
		}
		
/* 		if (($('select[name=bzwkFldName1]').val()!="" || $('select[name=bzwkFldName2').val()!="")&&$('select[name=layoutMappingName]').val()==""){
			alert("전문추적관리필드를 셋팅하기 위해서는 레이아웃매핑을 입력하여 주십시요.");
			return false;
		} */
/*   		$("td:visible  input[name^=msgFldStartSituVal]").each(function(){
			var value = $(this).val();
			if (isNaN(parseInt(value))){
				alert("통전문관리필드 항목이 숫자 타입이 아닙니다.("+$(this).attr("name")+")");
				return false;
			}
		});
		$("td:visible:not(:hidden)  input[name^=msgFldLen]").each(function(){
			var value = $(this).val();
			if (isNaN(parseInt(value))){
				alert("통전문관리필드 항목이 숫자 타입이 아닙니다.("+$(this).attr("name")+")");
				return false;
			}
		});   */
		if ($('select[name=fromAdapter]').val()=="" ){
			alert("거래흐름(INBOUND)어댑터를 선택하여 주십시요.");
			return false;
		}
		if ($('select[name=toAdapter]').val()=="" ){
			if($('select[name=svcMotivUseDstcd]').val() !="SYNC_ASYN" || $("select[name=splizDmndDstcd] :selected").val() != "R" || sessionStorage["serviceType"] != "EAI"){
				
				alert("거래흐름(OUTBOUND)어댑터를 선택하여 주십시요.");
				return false;
			
			}
			
		}

		if ($('select[name=extAdapter]').val()=="" && $('select[name=svcMotivUseDstcd]').val()=="ASYN_SYNC" ){
			alert("거래흐름(ASYN-SYNC)어댑터를 선택하여 주십시요.");
			return false;
		}
 		if ($("select[name=fromAdapter] option:selected").attr("std") == "K"){
			//표준일경우
			if($("input[name^=serviceId]:visible").val() !=""){
				alert("서비스ID를 삭제 하셔야 됩니다.");
				return false;
			}
		}else{
			var dmnd =$("select[name=splizDmndDstcd]").val();
			if(dmnd == "S"){
				gbn = "REQ";
			}else if(dmnd =="R"){
				gbn = "RES";
			}
			if($("input[name^=serviceId_"+gbn+"]:visible").val().trim() ==""){				
				if( gbn == "RES" ){	
					var ret = confirm("서비스ID가 입력되지 않았습니다. \n공백으로 처리하면 요청의 서비스ID를 참조합니다. \n계속하시겠습니까?");
					if(ret){
						$("input[name^=serviceId_"+gbn+"]:visible").val(" ");
					}else{
						alert("서비스ID를 입력 하셔야 됩니다.");
						return false;
					}
				}else{
					alert("서비스ID를 입력 하셔야 됩니다.");
					return false;
				}
				
			}			

		} 
 		
 		var ret= true;
 		$("input[name^=cnvsnName]").each(function(){
 			if($(this).val() != ""){
 				var name = $(this).attr('name');
 				var gbn = name.split("_")[1];
 				if($("input[name=layoutMappingName_"+gbn+"_Target]").val() ==""){
 					alert("레이아웃 변환코드는 타겟 레이아웃 입력시 등록가능합니다.\n타겟레이아웃을 등록하거나, \n타겟레이아웃의 X를 눌러 레이아웃변환코드를 삭제하세요\n");
 					return ret = false;
 				}
 			}
 		
 		});
 		if(ret == false) return false;
 		
 		if($("input[name=refIDName_REQ]").val() ==""){
 			if($("input[name=refIDName_RES]").val() !="" || $("input[name=refIDName_ERR]").val() !=""){
 				alert("요청레이아웃이 없으면 응답레이아웃을 등록할 수 없습니다.");
 				return false;
 			}
 		}
 		
 		return true;
	}
	function chkOwned(chkData){
		var ret = false;
		$.ajax({
			type : "POST",
			url:'<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />',
			async:false,
			datatype:'json',
			data:chkData,
			success:function(json){
				var trans = json.layout;
				
				var sharedTrans = [];
				for(var t in trans){
					sharedTrans.push(trans[t]);
				}
				if(sharedTrans.length != 0){
					var r = confirm(sharedTrans.join(", ") +"\n 는 공유되는 변환코드입니다. 변경시 참조되는 데이터 모두 변경됩니다. \n 계속 하시겠습니까");
					if(r != true) ret= true;
				}				
			},
			error:function(e){
				alert(e.responseText);
			}
		});
		return ret;
	
	}
	function changeDirection(motive,base){
		//motive : sync or asyn ; base : D, T 당타발
		//if(serviceType == "EAI") return;
		
		//if(gbn == "" || gbn == null) return;
			var sleft = "";		//요청방향
			var sright = "";
			var rleft = "";		//응답방향
			var rright = "";	
			var sSrc = "";
			var sTgt = "";
			var rSrc = "";
			var rTgt = "";		
			if(base == "D"){	//당발
				sleft 	= "Source";
				sright 	= "Target";
				rleft 	= "Target";
				rright	= "Source";		
			}else if(base =="T"){	//타발
				sleft 	= "Target";
				sright 	= "Source";
				rleft 	= "Source";
				rright	= "Target";	
			}
			var $a = null;

			$a = $("div[name=block_REQ] ").find("div[class=contents_col]").first();
			$a.find($("input[name^=layoutMappingName]")).attr('name',"layoutMappingName_REQ_"+sleft);
			$a.find($("img[name^=searchLayout]")).attr('name',"searchLayout_REQ_"+sleft);
			$a.find($("img[name^=delLayout]")).attr('name',"delLayout_REQ_"+sleft);
						
			$a = $("div[name=block_REQ] ").find("div[class=contents_col]").last();
			$a.find($("input[name^=layoutMappingName]")).attr('name',"layoutMappingName_REQ_"+sright);
			$a.find($("img[name^=searchLayout]")).attr('name',"searchLayout_REQ_"+sright);
			$a.find($("img[name^=delLayout]")).attr('name',"delLayout_REQ_"+sright);
						
			$a = $("div[name=block_RES] ").find("div[class=contents_col]").first();
			$a.find($("input[name^=layoutMappingName]")).attr('name',"layoutMappingName_RES_"+rleft);
			$a.find($("img[name^=searchLayout]")).attr('name',"searchLayout_RES_"+rleft);
			$a.find($("img[name^=delLayout]")).attr('name',"delLayout_RES_"+rleft);
						
			$a = $("div[name=block_RES] ").find("div[class=contents_col]").last();
			$a.find($("input[name^=layoutMappingName]")).attr('name',"layoutMappingName_RES_"+rright);
			$a.find($("img[name^=searchLayout]")).attr('name',"searchLayout_RES_"+rright);
			$a.find($("img[name^=delLayout]")).attr('name',"delLayout_RES_"+rright);

			$a = $("div[name=block_ERR] ").find("div[class=contents_col]").first();
			$a.find($("input[name^=layoutMappingName]")).attr('name',"layoutMappingName_ERR_"+rleft);
			$a.find($("img[name^=searchLayout]")).attr('name',"searchLayout_ERR_"+rleft);
			$a.find($("img[name^=delLayout]")).attr('name',"delLayout_ERR_"+rleft);
						
			$a = $("div[name=block_ERR] ").find("div[class=contents_col]").last();
			$a.find($("input[name^=layoutMappingName]")).attr('name',"layoutMappingName_ERR_"+rright);
			$a.find($("img[name^=searchLayout]")).attr('name',"searchLayout_ERR_"+rright);
			$a.find($("img[name^=delLayout]")).attr('name',"delLayout_ERR_"+rright);
			//img change
			//var direction = "";
			var sdirection = base=="D"?">":"<";
			
			var $req = $("div[name=block_REQ] div[class=arrow_wrap]");
			var $res = $("div[name=block_RES] div[class=arrow_wrap]");
			var $err = $("div[name=block_ERR] div[class=arrow_wrap]");
			$req.empty();
			$res.empty();
			$err.empty();
			
			if(sdirection == ">"){
				
				$req.append("<div class='tale_right'></div>");			
				$req.append("<div class='body_right'></div>");
				$req.append("<div class='head_right'></div>");

				$res.append("<div class='head_left'></div>");
				$res.append("<div class='body_left'></div>");
				$res.append("<div class='tale_left'></div>");
				
				$err.append("<div class='head_left'></div>");
				$err.append("<div class='body_left'></div>");
				$err.append("<div class='tale_left'></div>");
				
				$("div[name=block_REQ] img[name=adptImg1]").attr("src","<c:url value='/img/gstatAdapter2_.png' />");
				$("div[name=block_REQ] img[name=adptImg2]").attr("src","<c:url value='/img/psvAdapter2_.png' />");
				
				$("div[name=block_RES] img[name=adptImg1]").attr("src","<c:url value='/img/psvAdapter1_.png' />");
				$("div[name=block_RES] img[name=adptImg2]").attr("src","<c:url value='/img/gstatAdapter1_.png' />");
			
				$("div[name=block_ERR] img[name=adptImg1]").attr("src","<c:url value='/img/psvAdapter1_.png' />");
				$("div[name=block_ERR] img[name=adptImg2]").attr("src","<c:url value='/img/gstatAdapter1_.png' />");	
				
			}else{
				$req.append("<div class='head_left'></div>");
				$req.append("<div class='body_left'></div>");
				$req.append("<div class='tale_left'></div>");

				$res.append("<div class='tale_right'></div>");
				$res.append("<div class='body_right'></div>");
				$res.append("<div class='head_right'></div>");
				
				$err.append("<div class='tale_right'></div>");
				$err.append("<div class='body_right'></div>");
				$err.append("<div class='head_right'></div>");
				
				$("div[name=block_RES] img[name=adptImg1]").attr("src","<c:url value='/img/gstatAdapter2_.png' />");
				$("div[name=block_RES] img[name=adptImg2]").attr("src","<c:url value='/img/psvAdapter2_.png' />");

				$("div[name=block_ERR] img[name=adptImg1]").attr("src","<c:url value='/img/gstatAdapter2_.png' />");
				$("div[name=block_ERR] img[name=adptImg2]").attr("src","<c:url value='/img/psvAdapter2_.png' />");
				
				$("div[name=block_REQ] img[name=adptImg1]").attr("src","<c:url value='/img/psvAdapter1_.png' />");
				$("div[name=block_REQ] img[name=adptImg2]").attr("src","<c:url value='/img/gstatAdapter1_.png' />");
			}


			//show blocks
			
			$("div[name*=block]").hide();
			$("div[name=extAdapter]").hide();	
			$("div[class=diagram_wrap]").show();
			if(motive == "SYNC" || motive == "ASYN_SYNC"){
				$("div[name=block_REQ").show();
				$("div[name=block_RES").show();
				$("div[name=block_ERR").show();
				
				if(motive =="ASYN_SYNC"){
					$("div[name=extAdapter]").show();
				}	
			}
			else if(motive == "ASYN" || motive == "SYNC_ASYN"){
				$("div[name=block_REQ").show();
				$("div[name=block_RES").show();	
			}
			
	}
	function ctrlSvcIdBox(){
		var io = $("select[name=io]").val();		//I, O
		var dmnd = $("select[name=splizDmndDstcd]").val();			// S, R
		var base = "";
		var gbn = "";
		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}
		if(dmnd == "S"){
			gbn = "REQ";
		}else if(dmnd =="R"){
			gbn = "RES";
		}	

		//var eaiSvcName = $("input[name=eaiSvcName]").val();
		//var gbn  = eaiSvcName.substring(eaiSvcName.length-2);  //S1 OR R1
    	var motive = $("select[name=svcMotivUseDstcd]").val();
    	$("div[name=block_REQ] div[class=top_wrap]").empty();
    	$("div[name=block_RES] div[class=top_wrap]").empty();
    	$("div[name=block_ERR] div[class=top_wrap]").empty();
    	
    	$("div[name=block_REQ] div[class=bottom_wrap]").empty();
    	$("div[name=block_RES] div[class=bottom_wrap]").empty();
    	$("div[name=block_ERR] div[class=bottom_wrap]").empty(); 
    	   	
 		var value = $("select[name=svcMotivUseDstcd]").val();
    	if(base =="D"){ //당발
	
			//if(gbn == "REQ"){	
				$("div[name=block_REQ] div[class=top_wrap]").first().append($("#reqTop").children().clone());		
				$("div[name=block_REQ] div[class=bottom_wrap]").first().append($("#reqBottom").children().clone());	
				//당발 응답
				$("div[name=block_RES] div[class=top_wrap]").last().append($("#resTop").children().clone());
				$("div[name=block_RES] div[class=bottom_wrap]").last().append($("#resBottom").children().clone());
			//}	
	
    		$("div[name=block_ERR] div[class=top_wrap]").last().append($("#errTop").children().clone());	
    	}else if(base =="T"){
    		//if(gbn == "REQ"){	
				$("div[name=block_REQ] div[class=top_wrap]").last().append($("#reqTop").children().clone());		
				$("div[name=block_REQ] div[class=bottom_wrap]").last().append($("#reqBottom").children().clone());			
					//당발 응답
				$("div[name=block_RES] div[class=top_wrap]").first().append($("#resTop").children().clone());
				$("div[name=block_RES] div[class=bottom_wrap]").first().append($("#resBottom").children().clone());

			//}	
    		$("div[name=block_ERR] div[class=top_wrap]").first().append($("#errTop").children().clone());
    	}
    	
    	//이벤트 재 바인딩
  
		 $("img[name^=searchbzwkFldName]").click(function(){	
			var name = $(this).attr('name');
			var kind = name.substring(name.indexOf("_"),name.length); //_REQ_Source
			var gbn = name.split("_")[0].replace("search",""); // bzwkFldName1
			var gbn1 = name.split("_")[1];
			if($("input[name=refIDName_"+gbn1+"]").val() == ""){
				alert("레이아웃명을 입력후 조회가능");
				return;
			}
			var args = new Object();
	    	args['layoutName'] = $("input[name=refIDName_"+gbn1+"]").val();
		    
		    var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view"/>';
		    url = url + "?cmd=FIELD";
		    var ret = showModal(url,args,1000,800, function(arg){
		    	var args = null;
			    if(arg == null || arg == undefined ) {//chrome
			        args = this.dialogArguments;
			        args.returnValue = this.returnValue;
			    } else {//ie
			        args = arg;
			    }
			    
			    if( !args || !args.returnValue ) return;
			    
			    var ret = args.returnValue;
			    
			    if( ret == null) return;
				//var data = new Object();
				var retVal = ret['key'];	
				if(retVal == null || retVal=="") return; 
				
				 $("input[name="+gbn+kind+"]").val(retVal);
				 
				isChanged = true;
		    });
		});
		
		$("img[name^=searchRefIDName]").click(function(){
				var name = $(this).attr('name');			//searchLayout_REQ_Target
		
				var gbn = name.split("_")[1];	//REQ
				
				var args = new Object();
		    	args['layoutName'] = $(this).val();
			    var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view"/>';
			    url = url + "?cmd=LAYOUT";
				console.log("gbn origin : ",gbn);
				var ret = showModal(url,args,1000,800, function(arg){
			    	var args = null;
				    if(arg == null || arg == undefined ) {//chrome
				        args = this.dialogArguments;
				        args.returnValue = this.returnValue;
				    } else {//ie
				        args = arg;
				    }
				    
				    if( !args || !args.returnValue ) return;
				    
				    var ret = args.returnValue;
				    
				    if( ret == null) return;
					//var data = new Object();
					var retVal = ret['key'];	
					if(retVal == null || retVal=="") return; 
					
					$("input[name=refIDName_"+gbn+"]").val(retVal);
			    });
		});			
		
		$("img[name^=fldPlus]").click(function(){
			var gbn = $(this).attr('name').split("_");
			//var kind = "_"+gbn[1]+"_"+gbn[2];
			var kind = "_"+gbn[1]
			var obj = $("div[name=fld2"+kind+"]");
			obj.show();
			$(this).hide();
	
			
		});
		
		$("img[name^=fldMin]").click(function(){
			var gbn = $(this).attr('name').split("_");
			var kind = "_"+gbn[1];
	
			var obj = $("div[name=fld2"+kind+"]");		
			var fldText = $("input[name=bzwkFldName2"+kind).val();
			if(fldText == ""){
				obj.hide();
				//buttonControl();	
				$("img[name^=fldPlus"+kind+"]").show();
			}else{
				alert("필드값을 삭제 후 가능");
			}
			
		});	 
		$("input[name^=refIDName]").dblclick(function(){
			var layoutName = $(this).val();
			if(layoutName =="") return;
			
			var args = new Object();
	
		    var url='<c:url value="/onl/admin/rule/layoutMan.view"/>';
			url += '?cmd=DETAIL';
	        url += '&loutName='+layoutName;
	        url += '&pop=true';
		    
		    showModal(url,args,1200,800);
		
		});		
		
	}
	
	function getAdapters(obj,adptrIoDstcd,type){
		var postData = [];
		if ($("input[name=eaiTranName]").val()=="")return;
		if ($("select[name=eaiBzwkDstcd]").val()=="")return;
		if (adptrIoDstcd =="IN"){
		 	queryType ="1";
		}else{
		 	queryType ="3";
		}
		
		
		var eaiTranName = $("input[name=eaiTranName]").val();
		postData.push({name:"cmd",value:"LIST_ADAPTER_COMBO"});
		postData.push({name:"adptrIoDstcd",value:adptrIoDstcd});
		postData.push({name:"queryType",value:queryType});
		postData.push({name:"chnlCd",value:eaiTranName.substring(0,3)});
		postData.push({name:"chnlCd2",value:eaiTranName.substring(eaiTranName.length-3,eaiTranName.length)});
		postData.push({name:"eaiBzwkDstcd",value:$("select[name=eaiBzwkDstcd]").val()});
		if (type !=undefined){
			postData.push({name:"asyncDstcd",value:type});
		}
		obj.find('option').remove();
	
		$.ajax({
			type : "POST",
			url:url,
			dataType:"json",
			async:false,
			data:postData,
			success:function(json){
				new makeOptions("ADPTRBZWKGROUPNAME","ADPTRBZWKGROUPDESC").setObj(obj).setFormat(codeName2OptionFormat).setNoValueInclude(true).setData(json.adapter).setAttr("std","ADPTRMSGPTRNCD").rendering();
			},
			error:function(e){
				alert(e.responseText);
			}
		});	
	}	
	function adapterChange(){
		var io = $("select[name=io]").val();		//I, O
		var dmnd = $("select[name=splizDmndDstcd]").val();			// S, R
		var base = "";
		var gbn = "";
		
		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}
		if(dmnd == "S"){
			gbn = "REQ";
		}else if(dmnd =="R"){
			gbn = "RES";
		}	
		//var gbn = $("input[name=eaiSvcName]").val();
		//gbn = gbn.substring(gbn.length,gbn.length-2);

	 	if(base == "D"){
	 		if(gbn == "REQ"){
		 		$("select[id=adapter1]").attr('name','fromAdapter');
				$("select[id=adapter2]").attr('name','toAdapter');
	 		}else{
		 		$("select[id=adapter2]").attr('name','fromAdapter');
				$("select[id=adapter1]").attr('name','toAdapter');
	 		}
	 	
	 	}else if(base =="T"){
	 		if(gbn== "REQ"){
		 		$("select[id=adapter2]").attr('name','fromAdapter');
				$("select[id=adapter1]").attr('name','toAdapter');
	 		}else{
		 		$("select[id=adapter1]").attr('name','fromAdapter');
				$("select[id=adapter2]").attr('name','toAdapter');
	 		
	 		}
	 		 	
	 	}

		$("select[name=toAdapter]").attr('disabled',false);
		$("select[name=fromAdapter]").attr('disabled',false);
		var value = $("select[name=svcMotivUseDstcd]").val();
		var reqRes = $("select[name=splizDmndDstcd]").val();
		if (value=="SYNC"){
			$("tr[name=tr_extAdapter]").hide();
			getAdapters($("select[name=fromAdapter]"),"IN","Sy");
			getAdapters($("select[name=toAdapter]"),"OU","Sy");
		}else if (value=="ASYN"){
			$("tr[name=tr_extAdapter]").hide();
			getAdapters($("select[name=fromAdapter]"),"IN","As");
			getAdapters($("select[name=toAdapter]"),"OU","As");
		}else if (value=="ASYN_SYNC"){
			$("tr[name=tr_extAdapter]").show();
			getAdapters($("select[name=fromAdapter]"),"IN","As");
			getAdapters($("select[name=toAdapter]"),"OU","Sy");
			getAdapters($("select[name=extAdapter]"),"OU","As");
		}	
		else if (value=="SYNC_ASYN"){
			$("tr[name=tr_extAdapter]").hide();
			if(reqRes != "R"){
				getAdapters($("select[name=fromAdapter]"),"IN","Sy");
				getAdapters($("select[name=toAdapter]"),"OU","As");
			}else{
				getAdapters($("select[name=fromAdapter]"),"IN","As");
				$("select[name=toAdapter]").html("");
				$("select[name=toAdapter]").attr('disabled',true);
			}
			
		}
				
	}
	function flowChange(){
		var motive = $("select[name=svcMotivUseDstcd]").val();
		var io = $("select[name=io]").val();		//I, O
		//var gbn = eaiSvcName.substring(eaiSvcName.length,eaiSvcName.length-2);
		
		//				|	I	 |	  O   |
		//				|--------|--------|
		// EAI ===> S	|당발요청|타발요청|
		//				|--------|--------|
		//          R	|당발응답|타발응답|
		//				|--------|--------|
		// FEP ===> S	|타발요청|당발요청|
		//				|--------|--------|
		//          R	|타발응답|당발응답|
		//				|--------|--------|
		// 새로 구분자하나 만들어서 당발이면 D, 타발이면 T로 
		var base = "";
		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}

		changeDirection(motive,base);
		
		$("div[name*=block]").hide();
		$("div[name=extAdapter]").hide();
		

		if(motive == "SYNC" || motive == "ASYN_SYNC"){
			$("div[name=block_REQ").show();
			$("div[name=block_RES").show();
			$("div[name=block_ERR").show();
			
			if(motive =="ASYN_SYNC"){
				$("div[name=extAdapter]").show();
			}	
		}
		else if(motive == "ASYN" || motive == "SYNC_ASYN"){
			$("div[name=block_REQ").show();
			$("div[name=block_RES").show();	
		}
		
	}
	function setDisable(isDetail){
		var auth="${rmsMenuAuth}";
		if(auth == "R"){
			$("input[name!=searchEaiSvcName]").attr('readonly',true);
			$("select").prop('disabled','disabled');

		}else if(auth=="W"){
			$("input").attr('readonly',false);
			$("input[name^=layoutMapping]").attr('readonly',true);
			$("input[name^=cnvsnName]").attr('readonly',true);
			$("input[name^=bzwkSvcKeyName]").attr('readonly',true);
			$("input[name^=eaiSvcName]").attr('readonly',true);
			$("select").prop('disabled','');		
			
			// 상세정보 조회
			if(isDetail==true){
				$("input[name=eaiTranName]").attr('readonly',true);
				$("select[name=io]").prop('disabled','disabled');
				$("select[name=splizDmndDstcd]").prop('disabled','disabled');
				$("select[name=svcMotivUseDstcd]").prop('disabled','disabled');
				$("#tb_clone").show();
				 
				//$("input[name*="+gbn+"]").css('background-color','');	
			
			}else if(isDetail==false){
				$("input[name=eaiTranName]").attr('readonly',false);
				$("select[name=io]").prop('disabled','');
				$("select[name=splizDmndDstcd]").prop('disabled','');
				$("select[name=svcMotivUseDstcd]").prop('disabled','');	
				$("#tb_clone").hide();			
			}
		}	
		
		
		var motive = $("select[name=svcMotivUseDstcd]").val();
		var dmnd = $("select[name=splizDmndDstcd]").val();			// S, R
		var io = $("select[name=io]").val();		//I, O
		var base = "";
		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}
		
		var gbn = "";
		var disTarget = "";

		if(dmnd == "S"){
			gbn = "REQ";
		}else if(dmnd =="R"){
			gbn = "RES";
		}

		if(gbn =="REQ"){
			disTarget ="RES";
		}else{
			disTarget ="REQ";
		}

		if(motive == "ASYN" || motive =="SYNC_ASYN"){

			$("input[name*="+gbn+"]").prop('disabled','');
			//$("input[name*="+gbn+"]").css('background-color','');	
			$("input[name*="+disTarget+"]").prop('disabled','disabled');
			//$("input[name*="+disTarget+"]").css('background-color','');	
			
			// button control
			$("img[name*="+gbn+"]").show();
			$("img[name*="+disTarget+"]").hide();	

		
			$("input[name*=layoutMappingName_"+gbn+"]").attr('readonly',false);
			$("input[name*=cnvsnName_"+gbn+"]").attr('readonly',false);
		}else{
			//sync이면 추적관리필드 필요없음
			
			//serviceId는 타발일 경우만..
			$("input").prop('disabled','');
			
			$("input[name*=bzwkFldName]").prop('disabled','disabled');
			$("input[name*=msgFldStartSituVal]").prop('disabled','disabled');
			$("input[name*=msgFldLen]").prop('disabled','disabled');
			
			
			

			$("img[name*="+gbn+"]").show();
			$("img[name*="+disTarget+"]").show();
			
			$("img[name*=searchbzwkFldName]").hide();
			$("img[name*=fldPlus]").hide();
			$("img[name*=fldMin]").hide();

			$("input[name*=layoutMappingName_]").attr('readonly',false);
			$("input[name*=cnvsnName]").attr('readonly',false);
			//$("input").css('background-color','');
		}
		
		//당발이면 serviceID disable
		if(base =="D"){
			$("input[name*=serviceId_]").prop('disabled','disabled');
		}	
		
/* 			//표준 비표준에 따른..k
			if ($("select[name=fromAdapter] option:selected").attr("std") == "K"){
				$("div[name=block_REQ]").find("$("input[name*="+gbn+"]").prop('disabled','disabled');
			} */
			
		//$("div[name^=block] *:[disabled]").css('background-color','#E6E6E6');
			
			
		
		
		$("#ajaxForm_Common").show();
		changeToFrom();
	}
	function ctrlButton(){

		var disTarget="";	
		var motive = $("select[name=svcMotivUseDstcd]").val();
		var io = $("select[name=io]").val();		//I, O
		var dmnd = $("select[name=splizDmndDstcd]").val();			// S, R
		var base = "";
		var gbn = "";

		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}
		if(dmnd == "S"){
			gbn = "REQ";
		}else if(dmnd =="R"){
			gbn = "RES";
		}
		if(gbn == "" || gbn== null) return;
		if ("${rmsMenuAuth}" !="R"){		
			if(gbn == "REQ"){ 
				disTarget = "RES";
			}else{
				disTarget ="REQ";
			}
			if(motive == "ASYN" || motive =="SYNC_ASYN"){
				$("img[name*="+gbn+"]").show();
				$("img[name*="+disTarget+"]").hide();	
			}else{
				$("img[name*="+gbn+"]").show();
				$("img[name*="+disTarget+"]").show();	
			}			
		
		}		
		//$("img[name^=mapping]").hide();
		$("img[name^=mapping]").each(function(){
			var name = $(this).attr('name');
			var gbn = name.substring(name.lastIndexOf("_")+1);
			
			var tgt = $("input[name=layoutMappingName_"+gbn+"_Target]").val();
			var src = $("input[name=layoutMappingName_"+gbn+"_Source]").val();
			
			//if("" != tgt && ""!=src)
			//	$("img[name=mapping_"+gbn+"]").show();
				
		});
		$("#div_addErrTransform").hide();
		if(gbn == "RES" && base =="D" && motive == "ASYN" ){
			$("#div_addErrTransform").show();
			$('div[name=errRefIDName]').hide();
			//$("#addErrTransform").click();
			
		}else{
			$('div[name=errRefIDName]').show();
		}	

	

	}
	function modify(){
		var auth="${rmsMenuAuth}";
		var ret = false;
		if(auth =="R") return;
		if (!isValid()) return;
		
	
		
		//업무추출키 control
		if ($("select[name=fromAdapter] option:selected").attr("std") == "K"){
			//표준일경우 업무추출키 삭제되어야 됨
			$("input[name=bzwkSvcKeyName]").val("");
		}else{
			//표준이 아닐경우 업무추출키 셋팅되어야 됨
			$("input[name=bzwkSvcKeyName]").val($("input[name=eaiTranName]").val());
		}

		//postForm으로 옮기기
		var io = $("select[name=io]").val();		//I, O
		var dmnd = $("select[name=splizDmndDstcd]").val();			// S, R
		var base = "";
		var gbn = "";

		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}
		if(dmnd == "S"){
			gbn = "REQ";
		}else if(dmnd =="R"){
			gbn = "RES";
		}		
		var layoutMappingName = $("input[name=refIDName_"+gbn+"]").val();
		var motive = $("select[name=svcMotivUseDstcd]").val();
		
		if(motive.substring(motive.length-4) =="SYNC"){
			if($("input[name=refIDName_RES]").val() != ""){
				layoutMappingName = layoutMappingName + ","+ $("input[name=refIDName_RES]").val();
				if($("input[name=refIDName_ERR]").val() != ""){
					layoutMappingName = layoutMappingName + "," +$("input[name=refIDName_ERR]").val();
				}
			}	
		}

		
		var serviceId = $("input[name=serviceId_"+gbn+"]").val();
		var bzwkFldName1 = $("input[name=bzwkFldName1_"+gbn+"]").val();
		var bzwkFldName2 = $("input[name=bzwkFldName2_"+gbn+"]").val();
		var msgFldStartSituVal1= $("input[name=msgFldStartSituVal1_"+gbn+"]").val();
		var msgFldStartSituVal2 = $("input[name=msgFldStartSituVal2_"+gbn+"]").val();
		var msgFldLen1 = $("input[name=msgFldLen1_"+gbn+"]").val();
		var msgFldLen2 = $("input[name=msgFldLen2_"+gbn+"]").val();
		var fromAdapter = $("select[name=fromAdapter] option:selected").val();
		var toAdapter = $("select[name=toAdapter] option:selected").val(); 
		
		// disable이면 serializeArray에 속하지 않음.	
		$('#ajaxForm_Common select[disabled]').each(function(){
			$(this).prop('disabled','');
		}); 

		var postData = $('#ajaxForm_Common').serializeArray();
		

		$('#ajaxForm_Common select[disabled]').each(function(){
			$(this).prop('disabled','disabled');
		}); 		

		if(typeof serviceId =='undefined') serviceId="";

		
		postData.push({name:"layoutMappingName", value:layoutMappingName});
		postData.push({name:"serviceId", value:serviceId});
		postData.push({name:"bzwkFldName1", value:bzwkFldName1});
		postData.push({name:"bzwkFldName2",value: bzwkFldName2});
		postData.push({name:"msgFldStartSituVal1", value:msgFldStartSituVal1});
		postData.push({name:"msgFldStartSituVal2", value:msgFldStartSituVal2});
		postData.push({name:"msgFldLen1", value:msgFldLen1});
		postData.push({name:"msgFldLen2", value:msgFldLen2});
		postData.push({name:"fromAdapter", value:fromAdapter});
		postData.push({name:"toAdapter", value:toAdapter});

		var transformData = [];
		
		if(motive =="SYNC" || motive =="ASYN_SYNC"){
			var cnvsnName = $("input[name=cnvsnName_REQ").val();
			var loutSource =$("input[name=layoutMappingName_REQ_Source]").val();
			var loutTarget =$("input[name=layoutMappingName_REQ_Target]").val();
			var cnvsnDesc = $("input[name=eaiSvcDesc]").val()+"_요청변환";
			transformData.push({cnvsnName:cnvsnName,loutSource:loutSource,loutTarget:loutTarget,cnvsnDesc:cnvsnDesc, cnvsnType:"REQ"});
			
			var cnvsnName_RES = $("input[name=cnvsnName_RES").val();
			var loutSource_RES =$("input[name=layoutMappingName_RES_Source]").val();
			var loutTarget_RES =$("input[name=layoutMappingName_RES_Target]").val();
			var cnvsnDesc_RES = $("input[name=eaiSvcDesc]").val()+"_응답변환";
			transformData.push({cnvsnName:cnvsnName_RES,loutSource:loutSource_RES, loutTarget:loutTarget_RES,cnvsnDesc:cnvsnDesc_RES, cnvsnType:"RES"});
			
			var cnvsnName_ERR = $("input[name=cnvsnName_ERR").val();
			var loutSource_ERR =$("input[name=layoutMappingName_ERR_Source]").val();
			var loutTarget_ERR =$("input[name=layoutMappingName_ERR_Target]").val();
			var cnvsnDesc_ERR = $("input[name=eaiSvcDesc]").val()+"_에러변환";
			transformData.push({cnvsnName:cnvsnName_ERR,loutSource:loutSource_ERR,loutTarget:loutTarget_ERR,cnvsnDesc:cnvsnDesc_ERR, cnvsnType:"ERR"});
					
		}else if( motive == "ASYN" || motive == "SYNC_ASYN"){
			var cnvsnName = $("input[name=cnvsnName_"+gbn).val();	
			var loutTarget =$("input[name=layoutMappingName_"+gbn+"_Target]").val();
			var loutSource =$("input[name=layoutMappingName_"+gbn+"_Source]").val();
			var cnvsnDesc = $("input[name=eaiSvcDesc]").val();
			if( gbn == "REQ")
				cnvsnDesc = cnvsnDesc + "_요청변환";
			else if(gbn =="RES")
				cnvsnDesc = cnvsnDesc + "_응답변환";			
			transformData.push({cnvsnName:cnvsnName,loutSource : loutSource,loutTarget:loutTarget,cnvsnDesc:cnvsnDesc, cnvsnType:"REQ"});
			
			if( gbn == "RES" && base =="D"){
				var cnvsnName_ERR = $("input[name=cnvsnName_ERR").val();
				var loutTarget_ERR =$("input[name=layoutMappingName_ERR_Target]").val();
				var loutSource_ERR =$("input[name=layoutMappingName_ERR_Source]").val();	//MS02 에 참조 레이아웃이 저장 안되므로 
				var cnvsnDesc_ERR = $("input[name=eaiSvcDesc]").val()+"_에러변환";
				transformData.push({cnvsnName:cnvsnName_ERR,loutSource : loutSource_ERR, loutTarget:loutTarget_ERR,cnvsnDesc:cnvsnDesc_ERR, cnvsnType:"ERR"});
			}
		}
	

		postData.push({name:"transformData", value:JSON.stringify(transformData)});
	
		var chkData= new Array();
		chkData.push({name:"cmd",value:"LIST_CHK_CNT"});
		chkData.push({name:"eaiSvcName",value:$("input[name=eaiSvcName]").val()});
		chkData.push({name:"transformData",value:JSON.stringify(transformData)});
		
		var cancel = false;
		var name = $("input[name=eaiSvcName]").val();
		if (isDetail){
			postData.push({ name: "cmd" , value:"UPDATE"});
			cancel = chkOwned(chkData);	//공유여부 확인
			if(cancel == true){
				alert("cancel");
				detail(name);//LIST로 이동
				return;
		}			
		}else{
			postData.push({ name: "cmd" , value:"INSERT"});
		}
		$.ajax({
			type : "POST",
			url:url,
			async:false,
			data:postData,
			success:function(args){
				if(!isPopup)
				alert("저장 되었습니다.");
				//goNav(returnUrl);
				detail(name);
				ret = true;
			},
			progress:{
				
			},
			error:function(e){
				alert(e.responseText);
			}
		});	
		return ret;
	}
	function init( callback) {
		$.ajax({
				type : "POST",
				url:url,
				dataType:"json",
				data:{cmd: 'LIST_DETAIL_COMBO'},
				success:function(json){
						new makeOptions("BIZCODE","BIZNAME").setObj($("select[name=eaiBzwkDstcd]")).setData(json.bizList).setFormat(codeNameOptionFormat).rendering();
						new makeOptions("CODE","NAME").setObj($("select[name=io]")).setNoValueInclude(true).setData(json.ioList).rendering();
						new makeOptions("CODE","NAME").setObj($("select[name=splizDmndDstcd]")).setNoValueInclude(true).setData(json.reqResList).rendering();
						new makeOptions("CODE","NAME").setObj($("select[name=svcMotivUseDstcd]")).setNoValueInclude(true).setData(json.syncAsyncList).rendering();
						
						//setSearchable("eaiBzwkDstcd");
/* 					if (typeof callback === 'function') {
						callback(url,key);
					} */
					buttonControl();
					$("#btn_delete").hide();
					$("#btn_modify").hide();
					$("#btn_cancel").hide();
					$("#tb_clone").hide();
					$("#ajaxForm_Common").hide();
					$("#div_addErrTransform").hide();
					
				},
				error:function(e){
					alert(e.responseText);
				}
		});
		
	}
	function detail(key){
		isDetail = true;
		$("#btn_modify").attr('src',"<c:url value='/img/btn_modify.png'/>");
		$.ajax({
			type : "POST",
			url:'<c:url value="/onl/transaction/tracking/dbTrackingChartMan.json" />',
			dataType:"json",
			async:false,
			data:{cmd: "DETAIL", key:key},
			success:function(json){
					$("input, select").val('');
						if(json.detail == null) return;						
						var data = json.detail;
						$('#ajaxForm_Common').show();
						$("#ajaxForm_Common input,#ajaxForm_Common select").each(function(){
							var name = $(this).attr("name");
							var tag  = $(this).prop("tagName").toLowerCase();
							if(name){
								$(tag+"[name="+name+"]").val(data[name.toUpperCase()]);
							}
						});
						
						//var eaiSvcName = data["EAISVCNAME"];
						var io = $("select[name=io]").val();		//I, O
						var dmnd = data["SPLIZDMNDDSTCD"];			// S, R
						//var gbn = eaiSvcName.substring(eaiSvcName.length,eaiSvcName.length-2);
						
						//				|	I	 |	  O   |
						//				|--------|--------|
						// EAI ===> S	|당발요청|타발요청|
						//				|--------|--------|
						//          R	|당발응답|타발응답|
						//				|--------|--------|
						// FEP ===> S	|타발요청|당발요청|
						//				|--------|--------|
						//          R	|타발응답|당발응답|
						//				|--------|--------|
						// 새로 구분자하나 만들어서 당발이면 D, 타발이면 T로 
						var base = "";
						var gbn = "";
						if(serviceType == "EAI"){
							base = io=="I"?"D":"T";
						}else if(serviceType =="FEP"){
							base = io=="I"?"T":"D";
						}
						if(dmnd == "S"){
							gbn = "REQ";
						}else if(dmnd =="R"){
							gbn = "RES";
						}
							
						var motive = data["SVCMOTIVUSEDSTCD"];										
						changeDirection(motive, base);
						
						if(data["LAYOUTMAPPINGNAME"] != null && data["LAYOUTMAPPINGNAME"] != "" ){
							$("input[name=refIDName_"+gbn+"]").val(data["LAYOUTMAPPINGNAME"]);
							var loutNames = String(data["LAYOUTMAPPINGNAME"]).split(",");
							if(loutNames.length > 1){
								for(var i =0; i< loutNames.length; i++){
									if(i==0) $("input[name=refIDName_REQ]").val(loutNames[i]);
									if(i==1) $("input[name=refIDName_RES]").val(loutNames[i]);
									if(i==2) $("input[name=refIDName_ERR]").val(loutNames[i]);	
								
								}
							}
							
						}
						
						$("img[name^=fldMin]").click();
						$("input[name=bzwkFldName1_"+gbn+"]").val(data["BZWKFLDNAME1"]);
						if(data["BZWKFLDNAME2"] != null && data["BZWKFLDNAME2"] !=""){
							$("input[name=bzwkFldName2_"+gbn+"]").val(data["BZWKFLDNAME2"]);
							$("img[name=fldPlus_"+gbn+"]").click();
						}else{
							$("img[name^=fldMin]").click();
						}
						
						if( motive == "ASYN" || motive =="SYNC_ASYN"){
							$("input[name=msgFldStartSituVal1_"+gbn+"]").val(data["MSGFLDSTARTSITUVAL1"]);
							$("input[name=msgFldStartSituVal2_"+gbn+"]").val(data["MSGFLDSTARTSITUVAL2"]);
				
							$("input[name=msgFldLen1_"+gbn+"]").val(data["MSGFLDLEN1"]);
							$("input[name=msgFldLen2_"+gbn+"]").val(data["MSGFLDLEN2"]);
						}							

						
						$("input[name=serviceId_"+gbn+"]").val(data["SERVICEID"]);

						
						//시뮬 여부
						$("input[name=simYN]").val(data["SIMYN"]);
						var isSim = $("input[name=simYN]").val();
						var sim = "";


/* 						if(isSim == "Y"){
							$("div[class=side_col]").each(function(){
								var name = $(this).children().first().attr('name');
								var flag = name.substring(-1);
								
								if(flag == "2"){
									$(this).css('background','#79c5f2');
								}
							});													
						} */
						
						$("img[name=adptImg2]").each(function(){
							var src = $(this).attr("src").replace("_sim","");
							var u = src.split(".");
							$(this).attr("src",u[0]+sim+"."+u[1]);
							
						});							

						
						//adapter 설정 1: 외부 ,2:내부
	
						adapterChange();
						$("select[name=toAdapter]"             ).val(data["TOADAPTER"]);//fromAdapter
						$("select[name=fromAdapter]"               ).val(data["FROMADAPTER"]);//toAdapter 
						$("select[name=extAdapter]"			).val(data["EXTADAPTER"]);
						
						if(motive == "SYNC" || motive == "ASYN_SYNC"){
							$("input[name=cnvsnName_REQ]").val(data["CHNGMSGIDNAME1"]);			
							$("input[name=cnvsnName_RES]").val(data["BASCRSPNSCHNGMSGIDNAME1"]);
							$("input[name=cnvsnName_ERR]").val(data["ERRRSPNSCHNGMSGIDNAME1"]);
						
						}else if( motive == "ASYN" || motive =="SYNC_ASYN"){
							$("input[name=cnvsnName_"+gbn+"]").val(data["CHNGMSGIDNAME1"]);	
							if(gbn =="RES"){
								$("input[name=cnvsnName_ERR]").val(data["ERRRSPNSCHNGMSGIDNAME1"]);
							}
						
						}

						var src = null;
						var tgt = null;
												
						var transform = json.transform;
						
						for( var j = 0; j < transform.length; j++){
							var trnData = transform[j];							
							for ( var i = 0; i < trnData.length; i++) {
								var _CnvsnName = trnData[i]['CNVSNNAME'];
								
								var putPosName = null; // cnvsnName이 같은 inputbox의 name을 구한다.
								$("input[name^=cnvsnName]").each(function(){
									var val = $(this).val();
									if(val == _CnvsnName){ 
										putPosName = $(this).attr('name');
										return false;
									}
								});
							
								if(putPosName != null && putPosName != undefined){
									var pos = putPosName.split("_")[1];  // Like S1 , REQ OR RES
									
									if (trnData[i]['SOURCRSULTDSTCD'] == 'SRC_LAYOUT' ){									
										src = trnData[i]['LOUTNAME'];
										$("input[name=layoutMappingName_"+pos+"_Source]").val(src);
										
									
									}else if (trnData[i]['SOURCRSULTDSTCD'] == 'TGT_LAYOUT' ){
										tgt = trnData[i]['LOUTNAME'];							
										$("input[name=layoutMappingName_"+pos+"_Target]").val(tgt);
										
										if( tgt ==null || tgt=="")
										$("input[name=cnvsnName_"+pos).val("");
									}
								}
							}
														
						}

							
			},
			error:function(e){
				alert(e.responseText);
			}
			
		});
		
		
		isDetail = true; 
		isChanged = false;
		//flowChange();
		
		buttonControl();
		setDisable(isDetail);
		//ctrlButton();
		ctrlSvcIdBox();
		
		var btn = $("#addErrTransform");
		$("span[name=lbl_addErrTransform]").text("Error 레이아웃 추가");
		btn.attr('src',"<c:url value="/images/ic_plus.gif"/>");
		if($("select[name=svcMotivUseDstcd]").val() =="ASYN" && $("input[name=cnvsnName_ERR]").val() != ""){
			$("#addErrTransform").click();
			//$("div[name=block_ERR").show();
			
		}
	}
	function changeToFrom(){
		var io = $("select[name=io]").val();		//I, O
		var base = "";
	
		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}	
		if(serviceType == "EAI"){
			if(base == "D"){
				$("p[name=from]").text("기 동");
				$("p[name=to]").text("수 동");
			}else{
				$("p[name=from]").text("수 동");
				$("p[name=to]").text("기 동");
			}
			
			$("p[name=system]").text("E A I");
		
		}else if(serviceType == "FEP"){
			$("p[name=from]").text("코 어");
			$("p[name=to]").text("기 관");
			$("p[name=system]").text("F E P");
		
		}
	
	}
$(document).ready(function() {	
	 
	var key="";
	init( detail);
	//$("input[name^=layoutMapping]").attr('readonly',true);
	
	if(serviceType == "EAI"){

		$("div[name=from]").text("기 동");
		$("div[name=to]").text("수 동");
		$("div[name=system]").text("E A I");
		
	}else if(serviceType == "FEP"){
		$("div[name=from]").text("코 어");
		$("div[name=to]").text("기 관");
		$("div[name=system]").text("F E P");
		
	}	




	$("#btn_search").click(function(){

		var args = new Object();
    	args['eaiSvcName'] = $('input[name=searchEaiSvcName]').val();
	    var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view"/>';
	    url = url + "?cmd=POPUP";
	    var ret = showModal(url,args,1000,800, function(arg){
	    	var args = null;
		    if(arg == null || arg == undefined ) {//chrome
		        args = this.dialogArguments;
		        args.returnValue = this.returnValue;
		    } else {//ie
		        args = arg;
		    }
		    
		    if( !args || !args.returnValue ) return;
		    
		    var ret = args.returnValue;
		    if( ret == null) return;
			 key = ret['key'];
			detail(key);
			
			isChanged = false;
			changeToFrom();
	    });
	});
	
	$("#btn_new").click(function(){
		isDetail = false;
		
		$("input").val(''); //초기화
		$("input[name^=msgFldStartSituVal],input[name^=msgFldLen]").val(0);
		$("select option:first-child").attr('selected','selected');
		$("div[name^=block]").hide();
		$('#ajaxForm_Common').show();
 		$('#ajaxForm_Common select[disabled]').each(function(){
			$(this).prop('disabled','');
		});  	
		
		$("#btn_modify").attr('src',"<c:url value='/img/btn_regist.png'/>");
		buttonControl();
		setDisable(isDetail);
		
		$("#btn_delete").hide();
		$("#tb_clone").hide();
		$("#div_addErrTransform").hide();
		$("span[name=lbl_addErrTransform]").text("Error 레이아웃 추가");
		$("#addErrTransform").attr('src',"<c:url value="/images/ic_plus.gif"/>");
		//ctrlButton();
	});
	
	$("#btn_modify").click(function(){
		modify();
		//isChanged = false;

	});
	
	
	$("#btn_delete").click(function(){
		var returnUrl = getReturnUrlForReturn();

		var yn = confirm("삭제하시겠습니까?");
		if(!yn) return;
		
	
		var dmnd = $("select[name=splizDmndDstcd]").val();
		var gbn = "";

		if(dmnd == "S"){
			gbn = "REQ";
		}else if(dmnd =="R"){
			gbn = "RES";
		}		
	
		var motive = $("select[name=svcMotivUseDstcd]").val();

		var transformData = [];
		
		if(motive =="SYNC" || motive =="ASYN_SYNC"){
			var cnvsnName = $("input[name=cnvsnName_REQ").val();
			transformData.push({cnvsnName:cnvsnName});
			
			var cnvsnName_RES = $("input[name=cnvsnName_RES").val();
			transformData.push({cnvsnName:cnvsnName_RES});
			
			var cnvsnName_ERR = $("input[name=cnvsnName_ERR").val();
			transformData.push({cnvsnName:cnvsnName_ERR});
					
		}else if( motive == "ASYN" || motive =="SYNC_ASYN"){
			cnvsnName = $("input[name=cnvsnName_"+gbn).val();		
			transformData.push({cnvsnName:cnvsnName});
			
			var cnvsnName_ERR = $("input[name=cnvsnName_ERR").val();
			transformData.push({cnvsnName:cnvsnName_ERR});
		}
	

		var chkData= new Array();
		chkData.push({name:"cmd",value:"LIST_CHK_CNT"});
		chkData.push({name:"eaiSvcName",value:$("input[name=eaiSvcName]").val()});
		chkData.push({name:"transformData",value:JSON.stringify(transformData)});
		
		var cancel = false;
		cancel = chkOwned(chkData);	
		if(cancel == true){
			return;
		}		
		
		var postData = $('#ajaxForm_Common').serializeArray();
		postData.push({ name: "cmd" , value:"DELETE"});
		postData.push({name:"transformData", value:JSON.stringify(transformData)});
		$.ajax({
			type : "POST",
			url:url,
			async:false,
			data:postData,
			success:function(args){
				alert("삭제 되었습니다.");
				isChanged = false;
				isDetail = false;
				goNav(returnUrl);
				

			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	$("#btn_cancel").click(function(){
		var returnUrl = getReturnUrlForReturn();
		goNav(returnUrl);//LIST로 이동
	});	
	$("input[name^=layoutMappingName]").dblclick(function(){
		var layoutName = $(this).val();
		if(layoutName =="") return;
		
		var args = new Object();

	    var url='<c:url value="/onl/admin/rule/layoutMan.view"/>';
		url += '?cmd=DETAIL';
        url += '&loutName='+layoutName;
        url += '&pop=true';
	    
	    showModal(url,args,1200,800);
	});
	$("input[name^=refIDName]").dblclick(function(){
		var layoutName = $(this).val();
		if(layoutName =="") return;
		
		var args = new Object();

	    var url='<c:url value="/onl/admin/rule/layoutMan.view"/>';
		url += '?cmd=DETAIL';
        url += '&loutName='+layoutName;
        url += '&pop=true';
	    
	    showModal(url,args,1200,800);
	
	});
	$("input[name^=searchEaiSvcName]").keydown(function(key){
		if (key.keyCode == 13){
			$("#btn_search").click();
		}
	});

	$("#formHidden").click(function(){
		if($("#details").css("display") == "none")
			$("#details").show();
		else
			$("#details").hide();
	});
	$("input[name=eaiTranName]").keyup(function(key){
		$("input[name=bzwkSvcKeyName]").val($("input[name=eaiTranName]").val());
		makeEaiSvcName();
	});
	$("select[name=io]").change(function(){
		
		makeEaiSvcName();
		adapterChange();
		flowChange();
		setDisable(isDetail);
		//buttonControl();
		//ctrlButton();		
		
	});
	$("select[id^=adapter]").change(function(){
		ctrlSvcIdBox();
	});
	$("select[name=splizDmndDstcd]").change(function(){
		makeEaiSvcName();
		adapterChange();
		flowChange();
		setDisable(isDetail);
		//buttonControl();
		//ctrlButton();			
	});	
	$("select[name=svcMotivUseDstcd]").change(function(){
		adapterChange();
		flowChange();
		setDisable(isDetail);
		//buttonControl();
		//ctrlButton();			
	});
	$("select[name=eaiBzwkDstcd]").change(function(){
		adapterChange();
	});	
	$("input[name=interfaceId]").blur(function(){
		adapterChange();
	});	
	$("img[name^=searchRefIDName]").click(function(){
		var name = $(this).attr('name');			//searchLayout_REQ_Target

		var gbn = name.split("_")[1];	//REQ
		
		var args = new Object();
    	args['layoutName'] = $(this).val();
	    var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view"/>';
	    url = url + "?cmd=LAYOUT";
	    var ret = showModal(url,args,1000,800, function(arg){
	    	var args = null;
		    if(arg == null || arg == undefined ) {//chrome
		        args = this.dialogArguments;
		        args.returnValue = this.returnValue;
		    } else {//ie
		        args = arg;
		    }
		    if( !args || !args.returnValue ) return;
		    
		    var ret = args.returnValue;
		    
			var retVal = ret['key'];	
			if(retVal == null || retVal=="") return; 

			 $("input[name=refIDName_"+gbn+"]").val(retVal);
	    });
	});	
	$("img[name^=searchLayout]").click(function(){
		var name = $(this).attr('name');			//searchLayout_REQ_Target
		var kind = name.substring(name.indexOf("_")); //{serachLayout,REQ,Target}
		if(name.split("_")[2] == "Target"){
			if($("input[name=layoutMappingName_"+name.split("_")[1]+"_Source]").val() == ""){
				alert("INBOUND 레이아웃을 먼저 등록하십시오");
				return;
			}
		}
		
		var gbn = name.split("_")[1];	//REQ
		
		var args = new Object();
    	args['layoutName'] = $(this).val();
	    var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view"/>';
	    url = url + "?cmd=LAYOUT";
	    var ret = showModal(url,args,1000,800, function(arg){
	    	var args = null;
		    if(arg == null || arg == undefined ) {//chrome
		        args = this.dialogArguments;
		        args.returnValue = this.returnValue;
		    } else {//ie
		        args = arg;
		    }
		    
		    if( !args || !args.returnValue ) return;
		    
		    var ret = args.returnValue;
	    	var retVal = ret['key'];	
			if(retVal == null || retVal=="") return; 

			 $("input[name=layoutMappingName"+kind+"]").val(retVal);
			 var eaiSvcName = $("input[name=eaiSvcName]").val();	

			 var eaiBzwkDstcd = $("select[name=eaiBzwkDstcd]").val();


			if($("input[name=layoutMappingName_"+name.split("_")[1]+"_Target]").val() != ""){
				 var req_res = null;
				 req_res = gbn;
				 			
				 var cnvsnName = "TRANSFORM_"+eaiBzwkDstcd+"_"+eaiSvcName +"_"+req_res;
				$("input[name=cnvsnName_"+gbn).val(cnvsnName); 	
			}
			//ctrlButton();
			isChanged = true;
	    });
	});
	
		 $("img[name^=searchbzwkFldName]").click(function(){	
			var name = $(this).attr('name');
			var kind = name.substring(name.indexOf("_"),name.length); //_REQ_Source
			var gbn = name.split("_")[0].replace("search",""); // bzwkFldName1
			var gbn1 = name.split("_")[1];
			if($("input[name=refIDName_"+gbn1+"]").val() == ""){
				alert("레이아웃명을 입력후 조회가능");
				return;
			}
			var args = new Object();
	    	args['layoutName'] = $("input[name=refIDName_"+gbn1+"]").val();
		    
		    var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view"/>';
		    url = url + "?cmd=FIELD";
		    var ret = showModal(url,args,1000,800, function(arg){
		    	var args = null;
			    if(arg == null || arg == undefined ) {//chrome
			        args = this.dialogArguments;
			        args.returnValue = this.returnValue;
			    } else {//ie
			        args = arg;
			    }
			    
			    if( !args || !args.returnValue ) return;
			    
			    var ret = args.returnValue;
		    	var retVal = ret['key'];	
				if(retVal == null || retVal=="") return; 
				
				 $("input[name="+gbn+kind+"]").val(retVal);
				 
				isChanged = true;
		    });
		});
	
	$("img[name^=fldPlus]").click(function(){
		var gbn = $(this).attr('name').split("_");
		var kind = "_"+gbn[1]+"_"+gbn[2];

		var obj = $("div[name=fld2"+kind+"]");
		obj.show();
		$(this).hide();

		
	});
	
	$("img[name^=fldMin]").click(function(){
		var gbn = $(this).attr('name').split("_");
		var kind = "_"+gbn[1];

		var obj = $("div[name=fld2"+kind+"]");		
		var fldText = $("input[name=bzwkFldName2"+kind).val();
		if(fldText == ""){
			obj.hide();
			//buttonControl();	
			$("img[name^=fldPlus"+kind+"]").show();
		}else{
			alert("필드값을 삭제 후 가능");
		}
		
	});	
	$("img[name^=mapping]").click(function(){
		
		var name = $(this).attr('name');			//searchLayout_REQ_Target
		var gbn = name.split("_")[1]; //{serachLayout,REQ}
		
		var srcLout = $("input[name=layoutMappingName_"+gbn+"_Source]").val();
		var tgtLout = $("input[name=layoutMappingName_"+gbn+"_Target]").val();
		
		if(srcLout == "" || tgtLout == ""){
			alert("레이아웃을 먼저 등록하십시오");
			return;
		}

		isPopup= true;
		var auth="${rmsMenuAuth}";
		if(auth !="R"){
			if(isChanged == true){
				var r = confirm("저장 후 사용가능합니다. 저장하시겠습니까?");
				if(r){
					var ret = modify();
					if(ret !=true){alert("저장실패"); return; }
					
				}else{
					return;
				}		
			}
		}
/* 		var name = $(this).attr('name');
		var gbn = name.split("_")[1]; */
		var args = new Object();
    	
    	args['eaiSvcName'] = $("input[name=eaiSvcName]").val();
		args['cnvsnName'] = $("input[name=cnvsnName_"+gbn+"]").val();
		args['loutSrc'] = $("input[name=layoutMappingName_"+gbn+"_Source]").val();
		args['loutTgt'] = $("input[name=layoutMappingName_"+gbn+"_Target]").val();
   	
	    
	    var url='<c:url value="/onl/transaction/tracking/dbTrackingChartMan.view"/>';
	    url = url + "?cmd=MAPPING";
	    var ret = showModal(url,args,1600,900, function(arg){
	    	var args = null;
		    if(arg == null || arg == undefined ) {//chrome
		        args = this.dialogArguments;
		        args.returnValue = this.returnValue;
		    } else {//ie
		        args = arg;
		    }
		    
		    if( !args || !args.returnValue ) {
		    	isPopup = false;
		    	return;
		    }
		    
		    var ret = args.returnValue;
			var retVal = ret['key'];	
			if(retVal == null || retVal=="") return; 
			
			 $("input[name="+gbn+kind+"]").val(retVal);	
			 
			 isPopup = false;
	    });
	});
		
	$("img[name^=delLayout]").click(function(){
		var name = $(this).attr('name');
		var gbn =name.substring(name.indexOf("_")); //_S1_Target
		var kind = name.split("_")[1]; //S1
		var source = name.split("_")[2]; //Source
		
		$("input[name=layoutMappingName"+gbn+"]").val('');
		$("input[name=cnvsnName_"+kind+"]").val('');
		
		if( source == "Source"){
			$("input[name=layoutMappingName_"+kind+"_Target]").val('');
			$("input[name=bzwkFldName1"+gbn+"]").val('');
			$("input[name=bzwkFldName2"+gbn+"]").val('');				
		}
		//$("img[name^=mapping_"+kind+"]").hide();
		isChanged = true;
	});
	
	
	$("input[name!=searchEaiSvcName], select").focus(function(){
		$(this).attr('oldVal',$(this).val());
	}).change(function(){
		var oldVal = $(this).attr('oldVal');
		var currentVal = $(this).val();
		if(isChanged == true) return;
		if(oldVal != currentVal)
			isChanged = true;
		
		//alert(isChanged);
	});
	
	$("#addErrTransform").click(function(){
		var btn = $("#addErrTransform");
		
		if($("div[name=block_ERR]").css('display') == 'none'){
			$("div[name=block_ERR]").show();
			$("span[name=lbl_addErrTransform]").text("Error 레이아웃 삭제");
			btn.attr('src',"<c:url value="/images/ic_minus.gif"/>");
		}else{
			var r = confirm("에러 레이아웃정보를 삭제합니다.");
			if(!r) return;
			$("div[name=block_ERR]").hide();
			$("span[name=lbl_addErrTransform]").text("Error 레이아웃 추가");
			btn.attr('src',"<c:url value="/images/ic_plus.gif"/>");
			
			//data delete
			$("input[name*=ERR]").val("");
			
		}
	});
	$("#btn_clone").click(function(){

		if ($("input[name=newEaiSvcName]").val()==""){
			alert("복제할 IF서비스 코드를 입력하여 주십시요.");
			return;
		}
		var newName = $("input[name=newEaiSvcName]").val();
		var oldName = $("input[name=eaiSvcName]").val();
		if (newName.substring(newName.length-2)!=oldName.substring(oldName.length-2)){
			alert("복제할 IF서비스 코드 유형이 원본과 다릅니다. ~" + newName.substring(newName.length-2));
			return;
		}
		if (newName.substring(0,3)!=oldName.substring(0,3)){
			alert("복제할 IF서비스 코드의 유형이 원본과 다릅니다. " +newName.substring(0,3) +"~" );
			return;
		}						
		if (!isValid())return;

		//postForm으로 옮기기
		
		var dmnd =$("select[name=splizDmndDstcd]").val();
		var io  = $("select[name=io]").val();
		var base = "";
		var gbn = "";
		if(serviceType == "EAI"){
			base = io=="I"?"D":"T";
		}else if(serviceType =="FEP"){
			base = io=="I"?"T":"D";
		}
		if(dmnd == "S"){
			gbn = "REQ";
		}else if(dmnd =="R"){
			gbn = "RES";
		}			

		var layoutMappingName = $("input[name=layoutMappingName_"+gbn+"_Source]").val();
		var motive = $("select[name=svcMotivUseDstcd]").val();
		
		if(motive =="SYNC"){
			if($("input[name=layoutMappingName_RES_Source]").val() != ""){
				layoutMappingName = layoutMappingName + ","+ $("input[name=layoutMappingName_RES_Source]").val();
				if($("input[name=layoutMappingName_ERR_Source]").val() != ""){
					layoutMappingName = layoutMappingName + "," +$("input[name=layoutMappingName_ERR_Source]").val();
				}
			}	
		}

		
		var serviceId = $("input[name=serviceId_"+gbn+"]").val();
		var bzwkFldName1 = $("input[name=bzwkFldName1_"+gbn+"]").val();
		var bzwkFldName2 = $("input[name=bzwkFldName2_"+gbn+"]").val();
		var msgFldStartSituVal1= $("input[name=msgFldStartSituVal1_"+gbn+"]").val();
		var msgFldStartSituVal2 = $("input[name=msgFldStartSituVal2_"+gbn+"]").val();
		var msgFldLen1 = $("input[name=msgFldLen1_"+gbn+"]").val();
		var msgFldLen2 = $("input[name=msgFldLen2_"+gbn+"]").val();
		var fromAdapter = $("select[name=fromAdapter] option:selected").val();
		var toAdapter = $("select[name=toAdapter] option:selected").val(); 
		
		// disable이면 serializeArray에 속하지 않음.	
		$('#ajaxForm_Common select[disabled]').each(function(){
			$(this).prop('disabled','');
		}); 
	
		var postData = $('#ajaxForm_Common').serializeArray();

		$('#ajaxForm_Common select[disabled]').each(function(){
			$(this).prop('disabled','disabled');
		}); 		

		if(typeof serviceId =='undefined') serviceId="";

		
		postData.push({name:"layoutMappingName", value:layoutMappingName});
		postData.push({name:"serviceId", value:serviceId});
		postData.push({name:"bzwkFldName1", value:bzwkFldName1});
		postData.push({name:"bzwkFldName2",value: bzwkFldName2});
		postData.push({name:"msgFldStartSituVal1", value:msgFldStartSituVal1});
		postData.push({name:"msgFldStartSituVal2", value:msgFldStartSituVal2});
		postData.push({name:"msgFldLen1", value:msgFldLen1});
		postData.push({name:"msgFldLen2", value:msgFldLen2});
		postData.push({name:"fromAdapter", value:fromAdapter});
		postData.push({name:"toAdapter", value:toAdapter});

		var transformData = [];
		
		if(motive =="SYNC" || motive =="ASYN_SYNC"){
			var cnvsnName = $("input[name=cnvsnName_REQ").val();
			var loutTarget =$("input[name=layoutMappingName_REQ_Target]").val();
			var cnvsnDesc = $("input[name=eaiSvcDesc]").val()+"_요청변환";
			transformData.push({cnvsnName:cnvsnName,loutTarget:loutTarget,cnvsnDesc:cnvsnDesc,cnvsnType:"REQ"});
			
			var cnvsnName_RES = $("input[name=cnvsnName_RES").val();
			var loutTarget_RES =$("input[name=layoutMappingName_RES_Target]").val();
			var cnvsnDesc_RES = $("input[name=eaiSvcDesc]").val()+"_응답변환";
			transformData.push({cnvsnName:cnvsnName_RES, loutTarget:loutTarget_RES,cnvsnDesc:cnvsnDesc_RES, cnvsnType:"RES"});
			
			var cnvsnName_ERR = $("input[name=cnvsnName_ERR").val();
			var loutTarget_ERR =$("input[name=layoutMappingName_ERR_Target]").val();
			var cnvsnDesc_ERR = $("input[name=eaiSvcDesc]").val()+"_에러변환";
			transformData.push({cnvsnName:cnvsnName_ERR,loutTarget:loutTarget_ERR,cnvsnDesc:cnvsnDesc_ERR, cnvsnType:"ERR"});
					
		}else if( motive == "ASYN" || motive =="SYNC_ASYN"){
			var cnvsnName = $("input[name=cnvsnName_"+gbn).val();	
			var loutTarget =$("input[name=layoutMappingName_"+gbn+"_Target]").val();
			var loutSource =$("input[name=layoutMappingName_"+gbn+"_Source]").val();
			var cnvsnDesc = $("input[name=eaiSvcDesc]").val();
			if( gbn== "REQ")
				cnvsnDesc = cnvsnDesc + "_요청변환";
			else if(gbn =="RES")
				cnvsnDesc = cnvsnDesc + "_응답변환";			
			transformData.push({cnvsnName:cnvsnName,loutSource : loutSource,loutTarget:loutTarget,cnvsnDesc:cnvsnDesc, cnvsnType:"REQ"});
			
			if( gbn=="RES" && base =="D"){
				var cnvsnName_ERR = $("input[name=cnvsnName_ERR").val();
				var loutTarget_ERR =$("input[name=layoutMappingName_ERR_Target]").val();
				var loutSource_ERR =$("input[name=layoutMappingName_ERR_Source]").val();	//MS02 에 참조 레이아웃이 저장 안되므로 
				var cnvsnDesc_ERR = $("input[name=eaiSvcDesc]").val()+"_에러변환";
				transformData.push({cnvsnName:cnvsnName_ERR,loutSource : loutSource_ERR, loutTarget:loutTarget_ERR,cnvsnDesc:cnvsnDesc_ERR, cnvsnType:"ERR"});
			}			
		}
	

		postData.push({name:"transformData", value:JSON.stringify(transformData)});		
		postData.push({ name: "cmd" , value:"CLONE"}, { name: "newEaiSvcName" , value:$("input[name=newEaiSvcName]").val()});
		$.ajax({
			type : "POST",
			url:url,
			data:postData,
			success:function(args){
				alert("복제 되었습니다.");
				detail(newName);//LIST로 이동
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	});	
	

	
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
			<div class="content_middle">
				<div class="search_wrap">
					<img src="<c:url value="/img/btn_new.png"/>" alt="" id="btn_new" level="W" />
					<img src="<c:url value="/img/btn_search.png"/>" alt="" id="btn_search" level="R" />	
				</div>
				<div class="title">거래흐름 Diagram</div>
				
	 			<table class="search_condition" cellspacing=0>
					<tbody>
						<tr>
							<th style="width:180px;">인터페이스ID</th>
							<td><input type="text" name="searchEaiSvcName"></td>
						</tr>
					</tbody>
				</table>
				<div style="position:relative;height:50px;">					
					<table id="tb_clone" class="table_row" cellspacing=0 style="width:50%;display:none;"><!-- display:none; -->
						<tr>
							<th style="width:20%;">복제 IF서비스코드</th>
							<td style="width:30%;">
								<input type="text" name="newEaiSvcName" style="width:calc(100% - 70px);" /> 
								<img id="btn_clone" src="<c:url value="/img/btn_clone.png"/>" level="W" status="DETAIL" class="btn_img" />
							</td>
						</tr>
					</table>								
					<div style="position:absolute; right:0; top:0;">
					<img src="<c:url value="/img/btn_delete.png"/>" alt="" id="btn_delete" class="btn_img" level="W" status="DETAIL" style="display:none;"/>
					<img src="<c:url value="/img/btn_modify.png"/>" alt="" id="btn_modify" class="btn_img" level="W" status="DETAIL,NEW" style="display:none;"/>	
					<img src="<c:url value="/img/btn_cancel.png"/>" alt="" id="btn_cancel" class="btn_img" level="R" status="DETAIL,NEW" style="display:none;"/><!-- display:none; -->
					</div>					
				</div>
						
				
				<div id="details">
					<form id="ajaxForm_Common" style="display:none"><!-- display:none --> 					
						<table class="table_row" cellspacing="0">
							<tr>
								<th style="width:20%">인터페이스ID</th>
								<td style="width:30%" ><input type="text" name="eaiTranName" style="width:100%"/> </td>
								<th style="width:20%">인터페이스ID설명</th>
								<td style="width:30%" ><input type="text" name="eaiSvcDesc" style="width:100%"/> </td>
							</tr>
							<tr>
								<th style="width:20%">IF서비스코드</th>
								<td style="width:30%" ><input type="text" name="eaiSvcName" style="width:100%" readonly="readonly"/> </td>
								<th style="width:20%">업무구분</th>
								<td  ><div class="select-style"><select name="eaiBzwkDstcd"></select></div></td>
							</tr>
							<tr>
								<th>당타발구분</th>
								<td><div class="select-style"><select name="io" style="width:100%"></select></div></td>
								<th>전문요청구분</th>
								<td><div class="select-style"><select name="splizDmndDstcd" style="width:100%"></select></div></td>
							</tr>
							<tr style="display:none;"><!-- display:none; -->
								<th>내외부구분</th>
								<td colspan="3"><input type="text" name="stndTelgmWtinExtnlDstcd" style="width:100%"/></td>
							</tr>
							<tr>
								<th>송수신방법</th>
								<td colspan="3"><div class="select-style"><select name="svcMotivUseDstcd" style="width:100%"></select></div></td>
							</tr>												
							<tr style="display:none"><!-- display:none; -->
								<th>업무추출키</th>
								<td colspan="3"><input type="text" name="bzwkSvcKeyName" style="width:100%" readonly="readonly"/> </td>
							</tr>
							<tr style="display:none;"><!-- display:none; -->
								<th>시뮬여부</th>
								<td colspan="3"><input type="text" name="simYN" style="width:100%" readonly="readonly"/> </td>
							</tr>			
						</table>					
					</form>
				</div><!-- end#details -->			
				
				<div id="div_addErrTransform" style="margin-bottom:15px;display:none;">
					<span name="lbl_addErrTransform" style="vertical-align:middle;">Error 레이아웃 추가</span>
					<img id="addErrTransform" src="<c:url value="/img/ic_plus.png"/>" level="W" style="vertical-align:middle;" class="btn_img" /><!-- display:none; -->
				</div><!-- end#div_addErrTransform -->
				
				<div class="diagram_wrap" style="display:none;">
					<div class="adapter_wrap" >
						<div style="display:inline-block; width:calc(50% - 65px);">
							<table class="table_row" cellspacing="0">
								<tr>
									<th style="width:20%">어댑터</th> 	
									<td style="width:80%;"><div class="select-style"><select id="adapter1"></select></div></td>
								</tr>	
							</table>
						</div>
						<div style="display:inline-block; width:130px;">
						</div>
						<div style="display:inline-block; width:calc(50% - 65px);">
							<table class="table_row" cellspacing="0">
								<tr>
									<th style="width:20%">어댑터</th> 
									<td style="width:80%;"><div class="select-style"><select id="adapter2"></select></div></td>
								</tr>	
							</table>
						</div>
					</div><!-- end.adapter_wrap -->
					<div class="title_wrap">					
						<div name ="from" class="title_box" style="display:inline-block; width:40px;">코어</div>
						<div style="display:inline-block; width:calc(50% - 105px);"></div>
						<div name ="system" class="title_box" style="display:inline-block; width:130px;">FEP</div>
						<div style="display:inline-block; width:calc(50% - 105px);"></div>
						<div name="to" class="title_box" style="display:inline-block; width:40px;">기관</div>					
					</div><!-- end.title_wrap -->
					
					<div name="block_REQ" class="table_diagram_wrap" style="display:none"><!-- display:none -->
						<div class="table_diagram">
							<div class="side_col">
								<img name="adptImg1" src="<c:url value="/img/gstatAdapter2_.png"/>" />
							</div><!-- end.side_col -->
							<div class="contents_col">	
								<div class="top_wrap">
								</div><!-- end.top_wrap -->							
								<div class="middle_wrap" >		
									<div class="arrow_wrap">
										<div class="tale_right" name="direct"></div>
										<div class="body_right" name="direct"></div>
										<div class="head_right" name="direct"></div>									
									</div><!-- end.arrow_wrap -->
									<div style="position:relative;">
										<span>레이아웃</span>
										<input type="text" name="layoutMappingName_REQ_Source" style="width:200px;"> 
										<img src="<c:url value="/img/role_search.png"/>" name="searchLayout_REQ_Source" level="W" class="btn_img"> 
										<img src="<c:url value="/img/mag_box_bt_img04.png"/>"   name="delLayout_REQ_Source" level="W" class="btn_img">
									</div>								
								</div><!-- end.middle_wrap -->
								<div class="bottom_wrap">
								</div><!-- end.bottom_wrap -->	
							</div><!-- end.contents_col -->
							<div class="center_col">
								<span>요청변환</span>
								<input type="text" name="cnvsnName_REQ" style="width:215px;" readonly="readonly">
								<img src="<c:url value="/img/btn_mapping.png"/>"  name="mapping_REQ" level="R" class="btn_img">
								
							</div><!-- end.center_col -->
							<div class="contents_col">
								<div class="top_wrap">
								</div><!-- end.top_wrap -->
								<div class="middle_wrap" >	
									<div class="arrow_wrap">
										<div class="tale_right" name="direct"></div>
										<div class="body_right" name="direct"></div>
										<div class="head_right" name="direct"></div>									
									</div><!-- end.arrow_wrap -->
									<div style="position:relative;">
										<span>레이아웃</span>
										<input type="text" name="layoutMappingName_REQ_Target" style="width:200px;"> 
										<img src="<c:url value="/img/role_search.png"/>" name="searchLayout_REQ_Target" level="W" class="btn_img" > 
										<img src="<c:url value="/img/mag_box_bt_img04.png"/>" name="delLayout_REQ_Target" level="W" class="btn_img" >
									</div>
								</div><!-- end.middle_wrap -->
								<div class="bottom_wrap">
								</div><!-- end.bottom_wrap -->	
							</div><!-- end.contents_col -->
							<div class="side_col">
								<img name="adptImg2" src="<c:url value="/img/psvAdapter2_.png"/>" >
							</div><!-- end.side_col -->						  		     	
						</div><!-- end.table_diagram -->
					</div><!-- end .table_diagram_wrap block_REQ -->	     
					<div name="block_RES" class="table_diagram_wrap" style="display:none"><!-- display:none -->
						<div class="table_diagram">
							<div class="side_col">
								<img name="adptImg1"  src="<c:url value="/img/psvAdapter1_.png"/>" />
							</div><!-- end.side_col -->
							<div class="contents_col">	
								<div class="top_wrap">								
								</div><!-- end.top_wrap -->
								<div class="middle_wrap left" >		
									<div class="arrow_wrap">
										<div class="head_left" name="direct"></div>
										<div class="body_left" name="direct"></div>
										<div class="tale_left" name="direct"></div>
									</div><!-- end.arrow_wrap -->
									<div style="position:relative;">
										<span>레이아웃</span>
										<input type="text" name="layoutMappingName_RES_Source" style="width:200px;"> 
										<img src="<c:url value="/img/role_search.png"/>" name="searchLayout_RES_Source" level="W" class="btn_img"> 
										<img src="<c:url value="/img/mag_box_bt_img04.png"/>" name="delLayout_RES_Source" level="W" class="btn_img">	
									</div>	
								</div><!-- end.middle_wrap -->
								<div class="bottom_wrap">								
								</div><!-- end.bottom_wrap -->	
							</div><!-- end.contents_col -->
							<div class="center_col">
								<span>응답변환</span>
								<input type="text" name="cnvsnName_RES" style="width:215px;" readonly="readonly">
								<img src="<c:url value="/img/btn_mapping.png"/>" name="mapping_RES" level="R" class="btn_img">
							</div><!-- end.center_col -->
							<div class="contents_col">
								<div class="top_wrap">
									
								</div><!-- end.top_wrap -->
								<div class="middle_wrap left" >	
									<div class="arrow_wrap">
										<div class="head_left" name="direct"></div>
										<div class="body_left" name="direct"></div>
										<div class="tale_left" name="direct"></div>
									</div><!-- end.arrow_wrap -->
									<div style="position:relative;">
										<span>레이아웃</span>
										<input type="text" name="layoutMappingName_RES_Target" style="width:200px;"> 
										<img src="<c:url value="/img/role_search.png"/>" name="searchLayout_RES_Target" level="W" class="btn_img"> 
										<img src="<c:url value="/img/mag_box_bt_img04.png"/>" name="delLayout_RES_Target" level="W" class="btn_img">
									</div>	
								</div><!-- end.middle_wrap -->
								<div class="bottom_wrap">

								</div><!-- end.bottom_wrap -->	
							</div><!-- end.contents_col -->
							<div class="side_col">
								<img name="adptImg2" src="<c:url value="/img/gstatAdapter1_.png"/>" >
							</div><!-- end.side_col -->						  		     	
						</div><!-- end.table_diagram -->					
					</div><!-- end .table_diagram_wrap block_RES -->		
					<div name="block_ERR" class="table_diagram_wrap" style="display:none"><!-- display:none -->
						<div class="table_diagram">
							<div class="side_col">
								<img name="adptImg1"  src="<c:url value="/img/psvAdapter1_.png"/>" />
							</div><!-- end.side_col -->
							<div class="contents_col">	
								<div class="top_wrap">								
								</div><!-- end.top_wrap -->
								<div class="middle_wrap left" >
									<div class="arrow_wrap">
										<div class="head_left" name="direct"></div>
										<div class="body_left" name="direct"></div>
										<div class="tale_left" name="direct"></div>
									</div><!-- end.arrow_wrap -->
									<div style="position:relative;">
										<span>레이아웃</span>
										<input type="text" name="layoutMappingName_ERR_Source" style="width:200px;"> 
										<img src="<c:url value="/img/role_search.png"/>" name="searchLayout_ERR_Source" level="W" class="btn_img"> 
										<img src="<c:url value="/img/mag_box_bt_img04.png"/>" name="delLayout_ERR_Source" level="W" class="btn_img">
									</div>	
								</div><!-- end.middle_wrap -->
								<div class="bottom_wrap">								
								</div><!-- end.bottom_wrap -->	
							</div><!-- end.contents_col -->
							<div class="center_col">
								<span>에러응답</span>
								<input type="text" name="cnvsnName_ERR" style="width:215px;" readonly="readonly">
								<img src="<c:url value="/img/btn_mapping.png"/>" name="mapping_ERR" level="R" class="btn_img">
							</div><!-- end.center_col -->
							<div class="contents_col">
								<div class="top_wrap">															
								
								</div><!-- end.top_wrap -->
								<div class="middle_wrap left" >	
									<div class="arrow_wrap">
										<div class="head_left" name="direct"></div>
										<div class="body_left" name="direct"></div>
										<div class="tale_left" name="direct"></div>
									</div><!-- end.arrow_wrap -->
									<div style="position:relative;">
										<span>레이아웃</span>
										<input type="text" name="layoutMappingName_ERR_Target" style="width:200px;"> 
										<img src="<c:url value="/img/role_search.png"/>" name="searchLayout_ERR_Target" level="W" class="btn_img"> 
										<img src="<c:url value="/img/mag_box_bt_img04.png"/>" name="delLayout_ERR_Target" level="W" class="btn_img">
									</div>	
								</div><!-- end.middle_wrap -->
								<div class="bottom_wrap">
								
								</div><!-- end.bottom_wrap -->	
							</div><!-- end.contents_col -->
							<div class="side_col">
								<img name="adptImg2" src="<c:url value="/img/gstatAdapter1_.png"/>"
								 >
							</div><!-- end.side_col -->						  		     	
						</div><!-- end.table_diagram -->					
					</div><!-- end .table_diagram_wrap block_ERR -->	
				</div><!-- end.diagram_wrap -->
				
				<div name="extAdapter" style="display:none"><!-- display:none -->
					<table class="table_row" cellspacing="0" style="width:50%;">
						<tr style="height:20px">
							<th style="width:20%;">어댑터</th> 	
							<td style="width:80%;"><div class="select-style"><select name="extAdapter"></select></div></td>
						</tr>	
					</table>	
				</div><!-- end extAdapter -->						
				<div id="reqTop" style="display:none">
						<span style="background:#ebebec">서비스ID </span> <input type="text" name="serviceId_REQ" style="width:100px;">
						<br>
						<span style="background:#ebebec">참조레이아웃</span>
						<input type="text" name=refIDName_REQ style="width:200px;"> 
						<img src="<c:url value="/img/role_search.png"/>" name="searchRefIDName_REQ" level="W" class="btn_img">				
				</div>
				<div id="reqBottom" style="display:none;">
					<div>
						<span style="background:#ebebec">전문추적관리필드</span>
						<input type="text" name="bzwkFldName1_REQ" style="width:100px;">
						<input type="text" name="msgFldStartSituVal1_REQ" size="3" value="0" style="width:30px;">,<input type="text" name="msgFldLen1_REQ" size="3" value="0" style="width:30px;">
						<img src="<c:url value="/img/role_search.png"/>" name="searchbzwkFldName1_REQ" level="W" class="btn_img" />
						<img src="<c:url value="/img/ic_plus.png"/>" name="fldPlus_REQ" level="W" class="btn_img" />
						<div name=fld2_REQ style="display:none;">
							<span style="background:#ebebec">전문추적관리필드2</span>
							<input type="text" name="bzwkFldName2_REQ" style="width:100px;">
							<input type="text" name="msgFldStartSituVal2_REQ" size="3" value="0" style="width:30px;">,<input type="text" name="msgFldLen2_REQ" size="3" value="0" style="width:30px;">
							<img src="<c:url value="/img/role_search.png" />" name="searchbzwkFldName2_REQ" level="W" class="btn_img" />
							<img src="<c:url value="/img/ic_minus.png"/>" name="fldMin_REQ" level="W" class="btn_img" />
						</div>	
					</div>			
				</div>
				<div id="resTop" style="display:none;">
						<span style="background:#ebebec">서비스ID</span> <input type="text" name="serviceId_RES" style="width:150px;">
						<br>
						<span style="background:#ebebec">참조레이아웃</span> <input type="text" name=refIDName_RES style="width:200px;"> 
						<img src="<c:url value="/img/role_search.png"/>" name="searchRefIDName_RES" level="W" class="btn_img" />
				</div>
				<div id="resBottom" style="display:none;">
						<div>
							<span style="background:#ebebec">전문추적관리필드</span> <input type="text" name="bzwkFldName1_RES" style="width:100px;">
							<input type="text" name="msgFldStartSituVal1_RES" size="3" value="0" style="width:30px;">,<input type="text" name="msgFldLen1_RES" size="3" value="0" style="width:30px;"> 
							<img src="<c:url value="/img/role_search.png"/>" name="searchbzwkFldName1_RES" level="W" class="btn_img"> 
							<img src="<c:url value="/img/ic_plus.png"/>" name="fldPlus_RES" level="W" class="btn_img">
							<div name=fld2_RES style="display:none">
								<span style="background:#ebebec">전문추적관리필드2</span>
								<input type="text" name="bzwkFldName2_RES" style="width:100px;">
								<input type="text" name="msgFldStartSituVal2_RES" size="3" value="0" style="width:30px;">,<input type="text" name="msgFldLen2_RES" size="3" value="0" style="width:30px;"> 
								<img src="<c:url value="/img/role_search.png"/>" name="searchbzwkFldName2_RES" level="W" class="btn_img"> 
								<img src="<c:url value="/img/ic_minus.png"/>" name="fldMin_RES" level="W" class="btn_img">
							</div>
						</div>					
				</div>
				<div id="errTop" style="display:none;">
						<span style="background:#ebebec">참조레이아웃</span> <input type="text" name="refIDName_ERR" style="width:200px;"> 
						<img src="<c:url value="/img/role_search.png"/>" name="searchRefIDName_ERR" level="W" class="btn_img">						
				</div>
			</div><!-- end content_middle -->
		</div><!-- end right_box -->				
	</body>	
</html>

