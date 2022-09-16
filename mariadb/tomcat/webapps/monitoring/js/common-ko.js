/*
	Monitoring Common javascript
	since  : MC 1.0
	author : short11
*/
// context root
var CONTEXT_ROOT = getContextName();
var ios_width = 685;
var plus_width_for_large_ios = 212;

function right(str, len)
{
	return str.substr(str.length - len);
}
function left(str, len)
{
	return str.substr(0,str.length-1);
}

// is ios?
function isIos() {
	var agent = navigator.userAgent.toLowerCase();

	if(agent.indexOf('ipad') >= 0){
	       // implement double-tap
		return true;
	}
	return false;
}

// ie browse?
function isChromeBrowse() {
	var agent = navigator.userAgent.toLowerCase();
	var browse;
	
	if(agent.indexOf("chrome") != -1) return true;
	
	return false;
}

// find Context
function getContextName()
{
	// get context
	var loc = location.href;
	var sPos = loc.indexOf("/", 7)
	var ePos = loc.indexOf("/", sPos+1)

	if (ePos == -1)	return "/";
	else			return loc.substr(sPos, ePos-sPos + 1);
}	
// return today : 20081231
function getToday()
{
	var now = new Date();
	var day = now.getFullYear();
	day += right("0" + (now.getMonth() + 1), 2);
	day += right("0" + now.getDate(), 2);

	return day;
}
function getBeforeDay(day)
{
	var now = new Date(Date.parse(new Date()) - (day*1000 *60*60*24) );
	var day = now.getFullYear();
	day += right("0" + (now.getMonth() + 1), 2);
	day += right("0" + now.getDate(), 2);

	return day;
}

function getTodayTime()
{
    var now = new Date();
    var day = now.getFullYear();
    day += right("0" + (now.getMonth()+1), 2);
    day += right("0" + now.getDate(),      2);
    day += right("0" + now.getHours(),     2);
    day += right("0" + now.getMinutes(),   2);
    day += right("0" + now.getSeconds(),   2);
    return day;
}
function getTodayTimeMilli()
{
    var now = new Date();
    var day = now.getFullYear();
    day += right("0" + (now.getMonth()+1), 2);
    day += right("0" + now.getDate(),      2);
    day += right("0" + now.getHours(),     2);
    day += right("0" + now.getMinutes(),   2);
    day += right("0" + now.getSeconds(),   2);
    day += left( now.getMilliseconds()+"0" ,   3);
    return day;
}
function isNull(obj){
	if (obj == null) return true;
	if (obj == undefined ) return true;
	return false;
}
function getNullToStr(obj){
	if (isNull(obj)){
		return "";		
	}else{
		return obj;
	}
}
function isEmpty(obj) {
	if (obj == null) return true;
	if (obj == undefined ) return true;
	if (obj == '') return true;
	return false;
}
function getGridSelectText(key,value,data){
	var result="";
	for(var i=0;i<data.length;i++){
		result += data[i][key]+":"+data[i][value]+";";
	}
	return result.substring(0,result.length-1);
}


var codeNameOptionFormat ='"("+this.data[index][this.code]+")"+this.data[index][this.name]'; 	
var codeName2OptionFormat ='this.data[index][this.code]+"["+this.data[index][this.name]+"]"'; 	
var codeName3OptionFormat ='"["+this.data[index][this.code]+"]"+this.data[index][this.name]'; 	
var makeOptions = function(code,name){
	this.code = code;
	this.name = name;
	this.noValueInclude = false;
	this.obj;
	this.data;
	this.noValueCode="";
	this.noValueName="선택안함";
	this.attrName;
	this.attrValue;
	this.format = 'this.data[index][this.name]';
	return this;
};
makeOptions.prototype = {
	setObj : function(obj){
		this.obj=obj;
		return this;
	},
	setData : function(key,val){
		if(val == undefined){
			this.data = key;
			return this;
		}
		this.data = [];
		var row = {};
		row[this.code] = key;
		row[this.name] = val;
		this.data.push(row);
		return this;
	},
	setNoValueInclude : function(noValueInclude){
		this.noValueInclude = noValueInclude;
		return this;
	},
	setNoValue : function(noValueCode,noValueName){
		this.noValueCode = noValueCode;
		this.noValueName = noValueName;
		return this;
	},
	setAttr : function(attrName,attrValue){
		this.attrName  = attrName;
		this.attrValue = attrValue;
		return this;
	},
	setFormat : function(format){
		this.format = format;
		return this;
	},
	getOption : function(index){
		if (index == undefined){
			index =0;
		}
		var str =[];
		str.push("<option value='"+this.data[index][this.code]+"'");
		if (this.attrName == undefined ){
			str.push(">");
		}else{
			if ( typeof(this.attrValue) !="object"){
				if (this.data[index][this.attrValue] ==null){
					str.push(" " + this.attrName +"='' >");
				}else{
					str.push(" " + this.attrName +"='"+this.data[index][this.attrValue]+"' >");
				}
			}else{
				for(var i=0;i<this.attrName.length;i++){
					if (this.data[index][this.attrValue[i]] ==null){
						str.push(" " + this.attrName[i] +"=''" );
					}else{
						str.push(" " + this.attrName[i] +"='"+this.data[index][this.attrValue[i]]+"'");
					}
					
				}
				str.push(" >");
				
			}
		}
		
		str.push(eval(this.format));
		str.push("</option>");
		return str.join("");
	},
	getOptions : function(){
		var list =[];
		if (this.noValueInclude){
			var str = "<option value='"+this.noValueCode+"'>";
			str += this.noValueName;
			str += "</option>";
			list.push(str);
		}
		for(var i=0;i<this.data.length;i++){
			list.push(this.getOption(i));
		}
		return list;
	},	
	rendering : function(){

		var list = this.getOptions();
		this.obj.append(list.join(""));
	}
};	
//new makeOptions("KEY","VAL").setObj($("#select").setData(data).setFormat(_codeNameOptionFormat).rendering();

function addSelectOptionAtom(code,name,attr,attrValue){
	var str = "<option value='"+code+"'";
	if (attr == undefined ){
		str = str +">";
	}else{
		str = str +" " + attr +"='"+attrValue+"' >";
	}
	
	str = str +"("+code+")"+name;
	//str = str + eval(format);
	str = str +"</option>";
	return str;
	
}
function addSelectOption(data,obj,isNoValueInclude,code,name,attr,attrValue){
	
	var str="";
	if (isNoValueInclude){
		str = "<option value=''";
		if (attr == undefined ){
			str = str +">";
		}else{
			str = str +" " + attr +"='' >";
		}
		str = str + "선택안됨</option>";
		obj.append(str);

	}
	if (isNaN(format)){
		format = "("+code+")"+name+"";
	}
	
	for(var i=0;i<data.length;i++){
		if (attr == undefined ){
			obj.append(addSelectOptionAtom(data[i][code],data[i][name]));
		}else{
			obj.append(addSelectOptionAtom(data[i][code],data[i][name],attr,data[i][attrValue]));
		}
	}
}
function resizeContentWidth(div_class) {
	if(isIos()) {
		if(isSmallMenu()) $("."+div_class).css('width', '959px');
		else $("."+div_class).css('width', ios_width+'px');
	}
}

function isSmallMenu() {
	var rtn = false;
	rtn = parent.leftFrame != null && parent.leftFrame.isSmallMenu() != null ? (parent.leftFrame.isSmallMenu() ? parent.leftFrame.isSmallMenu() : false) : false;
	if(parent.leftFrame == null)
		rtn = parent.parent.leftFrame ? (parent.parent.leftFrame.isSmallMenu() ? parent.parent.leftFrame.isSmallMenu() : false) : false;
	return rtn;
}

function resetDivIdWidth(div_id_width) {
	if(isSmallMenu()) {
		if(div_id_width == (ios_width+4)) div_id_width = ios_width + plus_width_for_large_ios;
		ios_width += plus_width_for_large_ios;
	}
	if(isIos()) {
		if(div_id_width > ios_width) div_id_width = ios_width;
	}
	return div_id_width;
}

function bindResizeJqGrid(grid_id, div_id_width, width, shrinkToFit) {
	if(shrinkToFit == null) shrinkToFit = true;
	if(isIos()) {
		if(width > ios_width) width = ios_width;
	}

	// window에 resize 이벤트를 바인딩 한다.
    $(window).bind('resize', function() {
        // 그리드의 width 초기화
    	$('#' + grid_id).setGridWidth(width, !shrinkToFit);
	    // 그리드의 width를 div 에 맞춰서 적용
	    $('#' + grid_id).setGridWidth(div_id_width , false); //Resized to new width as per window
     }).trigger('resize');
}

// shrinkToFit : 테이블의 사이즈를 고정
function resizeJqGridWidth(grid_id, div_id, width, shrinkToFit){
	var div_id_width = resetDivIdWidth($('#' + div_id).width());
	bindResizeJqGrid(grid_id, div_id_width, width, shrinkToFit);
}

function resizeTabJqGridWidth(grid_id, div_id_width, width, shrinkToFit){
	div_id_width = resetDivIdWidth(div_id_width);
	if(isIos()) {
		if(isSmallMenu()) {
//			ios_width = 875;
			ios_width += plus_width_for_large_ios -2;  // minus tab gap size
		} else {
//			ios_width = 665;
			ios_width -= 20;	// modify for tab gap size
		}
		div_id_width = ios_width;
		width = ios_width;
	}
	bindResizeJqGrid(grid_id, div_id_width, width, shrinkToFit);
}

function resizeMyJqGridWidth(grid_id, width) {
	if(isSmallMenu()) {
		ios_width += plus_width_for_large_ios;
	}
	if(isIos()) {
		if(width > ios_width) width = ios_width;
	}
	// window에 resize 이벤트를 바인딩 한다.
	$("#"+grid_id).css("width", width);
}

function strStartsWith(str,prefix){
	return str.indexOf(prefix) === 0;
}
function urlAddServiceType(url){
	var data ="";
	var isServiceType=false;
	var u = url.split("?");
	if (u.length == 1){
		data = u[0] + "?" + "serviceType=" +sessionStorage["serviceType"];
	}else if (u.length == 2){
		data = u[0] ;
		var u2 = u[1].split("&");
		var prefix ="";
		for (var i=0;i<u2.length;i++){
			if (i==0){
				prefix="?";
			}else{
				prefix="&";
			}
			if (strStartsWith(u2[i],"serviceType=")){
				isServiceType = true;
				data = data + prefix + "serviceType="+sessionStorage["serviceType"];
			}else{
				data = data + prefix + u2[i];
			}
		}
		if (!isServiceType){
			if (data.indexOf("?")>=0){
				data = data +"&" + "serviceType="+sessionStorage["serviceType"];
			}else{
				data = data +"?" + "serviceType="+sessionStorage["serviceType"];
			}
		}		
	}else{
		data = urlAddServiceType(u[0]+"?"+u[1]);
	} 
	return data;
	
}
function goNav(url){
	document.location.href = encodeURI(urlAddServiceType(url));
}
function goReload(url){
	document.location.href = encodeURI(urlAddServiceType(url));
}
function getReturnUrl(){
	return (document.location.href).split("?")[0];
}

function getSearchUrl(){
	var array = [];
	$("input[type!=radio][name^=search],select[name^=search],input[type=radio][name^=search]:checked").each(function(){
		var name = $(this).attr("name");
		array.push(name+"="+$(this).val());
	});
	$("input[type!=radio][name^=like]").each(function(){
		var name = $(this).attr("name");
		array.push(name+"="+$(this).val());
	});
	return array.join("&");
}
function getSearchForJqgrid(){
	var postData = {};
	if (arguments.length == 2){
		postData[arguments[0]]=arguments[1];
	}
	$("input[type!=radio][name^=search],select[name^=search],input[type=radio][name^=search]:checked").each(function(){
		var name = $(this).attr("name");
		postData[name] = $(this).val();
	});	
	$("input[type!=radio][name^=like],select[name^=like],input[type=radio][name^=like]:checked").each(function(){
		var name = $(this).attr("name");
		postData[name] = "%" + $(this).val() + "%";
	});	
	return postData;
}
function getSearchForAjax(){
	var postData = [];
	if (arguments.length == 2){
		postData.push({name:arguments[0],value:arguments[1]});
	}	
	$("input[type!=radio][name^=search],select[name^=search],input[type=radio][name^=search]:checked").each(function(){
		var name = $(this).attr("name");
		var value = $(this).val();
		postData.push({name:name,value:value});
	});
	return postData;
}
function showModal(url,args,width,height,returnValue,option){
	url = urlAddServiceType(url);
	url += "&menuId="+getMenuId();
	if(option==undefined){
		option ="scroll:no;";
	}
	
	if (window.showModalDialog){ //ie
		var options ="dialogWidth:"+width+"px;dialogHeight:"+height+"px;"+option;
		var result = window.showModalDialog(url,args,options);
		args['returnValue'] = result;
		if (returnValue != undefined ){
			var rr = returnValue(args);
			if( rr != undefined ) result = rr;
		}
		
		return result;
	}else{ //etc
		var data = new Object();
		data["url"]=url;
		data["dialogArguments"]= args;
		data["height"]= height;
		data["width"]= width;
		data["center"]=1;
		data["returnValue"] = "";
		if (returnValue != undefined){
			data["onClose"]= returnValue;
		}
		return $.showModalDialog(data);
	}
	
}
function titleControl(key){
	var obj = $("div[class=title]");
	var isStatus = false;
	if (isBoolean(key)){
		isStatus = key;
	}else{
		if (key != "" && key !="null"){
			isStatus = true;
		}else{
			isStatus = false;
		}
	}
	if (isStatus){
		obj.html(obj.html()+" "+"수정");
	}else{
		obj.html(obj.html()+" "+"등록");
	}	
	
	
}
function isString(value){
	if (typeof value == "string"){
		return true;
	}else {
		return false;
	}
}
function isBoolean(value){
	if (typeof value == "boolean"){
		return true;
	}else {
		return false;
	}
	
}
function windowOpen(url,name,width,height,option){
	url = urlAddServiceType(url);
	if (option == undefined){
		option = ",scrollbars=yes";
	}
	
	var options ="width="+width+"px,height:"+height+"px"+option;
	return window.open(url,name,options);
}

function timeStampFormat(cellvalue, options, rowObject){
	if ( cellvalue == null || cellvalue.length < 12 )
		return '';
	return cellvalue.substr(0,4) + '-' +
	       cellvalue.substr(4,2) + '-' +
	       cellvalue.substr(6,2) + ' ' +
	       cellvalue.substr(8,2) + ':' +
	       cellvalue.substr(10,2) + ':' +
	       cellvalue.substr(12,2) ;
}

function timeFormat(cellvalue, options, rowObject){
	if ( cellvalue == null || cellvalue.length < 4 )
		return '';
	return cellvalue.substr(0,2) + ':' +
	       cellvalue.substr(2,2) ;
}
function gridToExcelSubmit(url,cmd,gridObj,formObject,fileName,merge){
	
	var postData = formObject.serializeArray();	
	postData.push({
		name : "cmd",
		value : cmd
	});
	//fileName 필수값 아님
	if (fileName != undefined){
		postData.push({
			name : "fileName",
			value : encodeURI(fileName)
		});	
	}
	
	//grid data
	var data = gridObj.getRowData();
	var gridData = new Array();
	for ( var i = 0; i < data.length; i++) {
		for (key in data[i]) {
			data[i][key]=data[i][key];
		}
		gridData.push(data[i]);
	}
	
	postData.push({
		name : "gridData",
		value : JSON.stringify(gridData)
	});
	
			
	//grid titles
	var colN = gridObj.getGridParam("colNames");
	var colM = gridObj.getGridParam("colModel");
	var headers      = new Array();
	var headerTitles = new Array(); 
	for(var i=0;i<colM.length;i++){
		if (colM[i].hidden){
		}else{
			headers.push(colM[i].name);
			headerTitles.push(colN[i]);
		}
	}
	postData.push({
		name : "header",
		value : JSON.stringify(headers)
	});		
	postData.push({
		name : "headerTitle",
		value : JSON.stringify(headerTitles)
	});	
	if (merge != undefined){
		postData.push({
			name : "merge",
			value : JSON.stringify(merge)
		});	
	}
	
	
	var form="<form action='"+url+"' method='post' target='excelDown'>";
	$.each(postData,function(_,obj){
		form +="<input type='hidden' name='"+obj.name+"' value='"+obj.value+"'/>";
	});
	form += "</form>";
	$(form).appendTo("body").submit().remove();
}
function gridToExcelSubmit1(url,target,cmd,gridObj,formObject,fileName,merge){
	
	var postData = formObject.serializeArray();	
	postData.push({
		name : "cmd",
		value : cmd
	});
	//fileName 필수값 아님
	if (fileName != undefined){
		postData.push({
			name : "fileName",
			value : fileName
		});	
	}
	
	//grid data
	var data = gridObj.getRowData();
	var gridData = new Array();
	for ( var i = 0; i < data.length; i++) {
		gridData.push(data[i]);
	}
	postData.push({
		name : "gridData",
		value : JSON.stringify(gridData)
	});
	
			
	//grid titles
	var colN = gridObj.getGridParam("colNames");
	var colM = gridObj.getGridParam("colModel");
	var headers      = new Array();
	var headerTitles = new Array(); 
	for(var i=0;i<colM.length;i++){
		if (colM[i].hidden){
		}else{
			headers.push(colM[i].name);
			headerTitles.push(colN[i]);
		}
	}
	postData.push({
		name : "header",
		value : JSON.stringify(headers)
	});		
	postData.push({
		name : "headerTitle",
		value : JSON.stringify(headerTitles)
	});	
	if (merge != undefined){
		postData.push({
			name : "merge",
			value : JSON.stringify(merge)
		});	
	}
	
	
	var form="<form action='"+url+"' method='post' target='"+target+"'>";
	$.each(postData,function(_,obj){
		form +="<input type='hidden' name='"+obj.name+"' value='"+obj.value+"'/>";
	});
	form += "</form>";
	$(form).appendTo("body").submit().remove();
}
function makeMerge(text,firstRow,endRow,firstCol,endCol){
	var obj = {};
	obj["text"]=text;
	obj["firstRow"]=firstRow;
	obj["endRow"]=endRow;
	obj["firstCol"]=firstCol;
	obj["endCol"]=endCol;
	return obj;
}
function isValidCheck(obj){
	var name = obj.attr("name");
	var desc = obj.attr("desc");
	var tag  = obj.prop("tagName").toLowerCase();
	 
	if ( obj.val() == "") {
		if ($.isNull(desc)) desc = name;
		if (tag =="select"){
			alert(desc+"을(를) 선택하여 주십시요.");
		}else{
			alert(desc+"을(를) 입력하여 주십시요.");
		}
		obj.focus();
		return false;
	}
	return true;
}

var AjaxDownloadFile = function (configurationSettings) {
    // Standard settings.
    this.settings = {
        // JQuery AJAX default attributes.
        url: "",
        type: "POST",
        dataType: "json",
        headers: {
            "Content-Type": "application/json; charset=UTF-8"
        },
        data: {},
        // Custom events.
        onSuccessStart: function (response, status, xhr, self) {
        },
        onSuccessFinish: function (response, status, xhr, self, filename) {
        },
        onErrorOccured: function (response, status, xhr, self) {
        }
    };
    this.download = function () {
        var self = this;
        $.ajax({
            type: this.settings.type,
            url: this.settings.url,
            dataType: this.settings.dataType,
            //headers: this.settings.headers,
            data: this.settings.data,
            success: function (response, status, xhr) {
                // Start custom event.
                self.settings.onSuccessStart(response, status, xhr, self);

                // Check if a filename is existing on the response headers.
                var filename = "";
                var disposition = xhr.getResponseHeader("Content-Disposition");
                if (disposition && disposition.indexOf("attachment") !== -1) {
                    var filenameRegex = /filename[^;=\n]*=(([""]).*?\2|[^;\n]*)/;
                    var matches = filenameRegex.exec(disposition);
                    if (matches != null && matches[1])
                        filename = matches[1].replace(/[""]/g, "");
                }

                var type = xhr.getResponseHeader("Content-Type");
                var blob = new Blob([response], {type: type});

                if (typeof window.navigator.msSaveBlob !== "undefined") {
                    // IE workaround for "HTML7007: One or more blob URLs were revoked by closing the blob for which they were created. These URLs will no longer resolve as the data backing the URL has been freed.
                    window.navigator.msSaveBlob(blob, filename);
                } else {
                    var URL = window.URL || window.webkitURL;
                    var downloadUrl = URL.createObjectURL(blob);

                    if (filename) {
                        // Use HTML5 a[download] attribute to specify filename.
                        var a = document.createElement("a");
                        // Safari doesn"t support this yet.
                        if (typeof a.download === "undefined") {
                            window.location = downloadUrl;
                        } else {
                            a.href = downloadUrl;
                            a.download = filename;
                            document.body.appendChild(a);
                            a.click();
                        }
                    } else {
                        window.location = downloadUrl;
                    }

                    setTimeout(function () {
                        URL.revokeObjectURL(downloadUrl);
                    }, 100); // Cleanup
                }

                // Final custom event.
                self.settings.onSuccessFinish(response, status, xhr, self, filename);
            },
            error: function (response, status, xhr) {
                // Custom event to handle the error.
                self.settings.onErrorOccured(response, status, xhr, self);
            }
        });
    };
    // Constructor.
    {
        // Merge settings.
        $.extend(this.settings, configurationSettings);
        // Make the request.
        this.download();
    }
};


function setBtnHide(roleString, condiVal, compoId)
{
	var strRole		= roleString;
	var arrRoleID	= strRole.split(",");
	var flag		= false;
	
	for(var i = 0; i < arrRoleID.length; i++)
	{
		if(arrRoleID[i] == condiVal)
			flag = true;
	}
	
	if(flag)
		$("#"+compoId).show();
	else
		$("#"+compoId).hide();
}

// 콤보에 searchable 설정.
function setSearchable(selectName)
{
	var filter = "win16|win32|win64|mac|macintel";
	//mobile 
	var ismobile = false;

	if ( navigator.platform ) { 
		if ( filter.indexOf( navigator.platform.toLowerCase() ) < 0 ) { 
			ismobile = true; 
		}
	}
	
	if(ismobile) return;
	
	if(selectName == undefined) return;
	
	var strSelectName = selectName.split(",");
	var selector = "select[name=";
	
	for(var i = 0; i < strSelectName.length; i++)
	{
		selector += strSelectName[i] + "]";
		if(i != (strSelectName.length-1)) selector += ",[name=";
	}
	
	$(selector).searchable({maxListSize:10000,maxMultiMatch: 10000});
	
	var selectStyle = $(selector).closest("div[class=select-style]");

	/* select-style css 적용으로 searchable이 깨지는 현상 조정 */
	// select-style로 감싸지 않거나
	// 감싸 있을때 unwrap 시킴
	if(selectStyle.length == 0 || selectStyle == null || selectStyle === undefined){
		$(selector).parent().css("width", "100%");
		$(selector).css("width", "100%");
		$(selector).css("height", "20px");
		$(selector).next().css("width", "100%");
		$(selector).next().css("background-color", "#fff");
		$(selector).next().css("z-index", "200");
		$(selector).next().next().css("width", "100%");
		$(selector).next().next().css("padding-right", "24px");
		$(selector).next().next().next().css("width", "100%");
	}else{
		$(selector).parent().unwrap();
		$(selector).parent().css("width", "100%");
		
		//first selector
		$(selector).css("width", "100%");
		$(selector).css("height", "20px");
	 	//second selector
		$(selector).next().css("width", "100%");
		//transparent 속성제거
		$(selector).next().css("background-color", "#fff");

		$(selector).next().css("z-index", "200");
		
		//inputbox
		$(selector).next().next().css("width", "100%");
		$(selector).next().next().css("padding-right", "24px");
		
		//div
		$(selector).next().next().next().css("width", "100%");		
	}

}

/**
 * @20180112 : YYJ
 * properties 메시지의 dynamic 변환 
 * argument[0] : 변환대상 메시지
 * argument[1], argument[2], ... : 변환값1, 변환값2, ... 
 * 
 * ex) replaceMsg('The valid value (@1) of the upper menu ID \\nand the valid value (@2) of the menu ID do not match. \\nWould you like to save it anyway?','0106','0108');
 * 
 * */
function replaceMsg() {
    var tempVal = arguments[0].split(/@[1-9]/);
    if( tempVal.length <= 1 ) { // 가변 데이터가 없는 경우 value 값 리턴
        return tempVal;
    } 

    var sb = "";
    // 가변데이터 변환 처리
    for(var idx=1, tmp=0; tmp < tempVal.length; idx++,tmp++) {
        sb += tempVal[tmp];
        if( tempVal.length-1 < idx ) {  //argument가 @ 보다 많이 들어온 경우
            sb += "";
        } else if(arguments.length-1 < idx ) { // argument가 @ 보다 적게 들어온 경우
            sb += "";
        } else {
            sb += arguments[idx];
        }
    }
    return sb;
}

/*
var AjaxDownloadFile = function(configurationSettings){
	//Standard settings
	this.settings = {
		//JQuery AJAX default attributes
		url : "",
		type:"POST",
		headers : {"Content-Type":"application/json;charset=UTF-8"},
		data:{},
		//Custom eventss.
		onSuccessStart  : function(response,status,xhr,self){
		},
		onSuccessFinish : function(response,status,xhr,self){
		},
		onErrorOccured  : function(response,status,xhr,self){
		}
	}
	this.download = function(){
		var self = this;
		$.ajax({
			type:this.settings.type,
			url:this.settings.url,
			headers:this.settings.headers,
			data : this.setttings.data,
			success:function(response,status,xhr){
				//start custom event
				self.settings.onSuccessStart(response,status,xhr,self);
				//Check if a filename is existing on thr response headers.
				var filename ="";
				var disposition = xhr.getResponseHeader("Content-Disposition");
				
				
			}
		
		})
		
	}
}
*/

(function() {
    
    var oriJqGrid = $.fn.jqGrid;
    
	// iPad double click용 변수
 	var lastTouchTime = 0;
 	var lastId;
 	var doubleTouch = false;
 	// 선택한 rowId와 마지막으로 선택한 rowId가 같고 클릭한 시간이 1000ms 미만인 경우 double click 함수를 실행한다.
    
    var binder = function( pin ) {
       $.fn.jqGrid = oriJqGrid;
       var obj = $.fn.jqGrid.apply(this, arguments);
       $.fn.jqGrid = binder;

       if (typeof pin !== 'string' && isIos()) {
	         obj.bind("jqGridSelectRow", function() {
	      	   var nowTouchTime = Date.now();
	      	   var rowId = $(obj.selector).jqGrid("getGridParam", "selrow");
	      	   if(lastTouchTime && nowTouchTime - lastTouchTime < 1000 && rowId == lastId) {
		        	 var ondblClickRowHandler = $(obj.selector).jqGrid("getGridParam", "ondblClickRow"); 
		        	 if(ondblClickRowHandler) {
		        		 var rowId = $(obj.selector).jqGrid('getGridParam', "selrow" );
		        		 if(rowId)
		        			 ondblClickRowHandler.call($(obj.selector)[0],rowId); 
		        	 }
	      	   }
	        	 lastTouchTime = Date.now();
	        	 lastId = $(obj.selector).jqGrid("getGridParam", "selrow");
	         });
       }
      
       return obj;
    }
    
    $.fn.jqGrid = binder;
    
}());

if(isIos()) {
	jQuery.extend(jQuery.jgrid.defaults, {autowidth: true, shrinkToFit: false});
}