(function($) {
    // START of plugin definition
    $.fn.showModalDialog = function(options) {

        // build main options and merge them with default ones
        var optns = $.extend({}, $.fn.showModalDialog.defaults, options);

        // create the iframe which will open target page
        var $frame = $('<iframe />');
        $frame.attr({
            'src': optns.url,
            'scrolling': optns.scrolling
        });

        // set the padding to 0 to eliminate any padding, 
        // set padding-bottom: 10 so that it not overlaps with the resize element
        $frame.css({
            'padding': 0,
            'margin': 0,
            'padding-bottom': 10
        });

        // create jquery dialog using recently created iframe
        var $modalWindow = $frame.dialog({
            autoOpen: true,
            modal: true,
            width: optns.width,
            height: optns.height,
            resizable: optns.resizable,
            position: optns.position,
            overlay: {
                opacity: 0.5,
                background: "black"
            },
            close: function() {
                // save the returnValue in options so that it is available in the callback function
                optns.returnValue = $frame[0].contentWindow.window.returnValue;
                optns.onClose();
            },
            resizeStop: function() { $frame.css("width", "100%"); }
        });

        // set the width of the frame to 100% right after the dialog was created
        // it will not work setting it before the dialog was created
        $frame.css("width", "100%");

        // pass dialogArguments to target page
        $frame[0].contentWindow.window.dialogArguments = optns.dialogArguments;
        // override default window.close() function for target page
        $frame[0].contentWindow.window.close = function() { $modalWindow.dialog('close'); };

        $frame.load(function() {
            if ($modalWindow) {
                
                var maxTitleLength = 50; // max title length
                var title = $(this).contents().find("title").html(); // get target page's title

                if (title.length > maxTitleLength) {
                    // trim title to max length
                    title = title.substring(0, maxTitleLength) + '...';
                }

                // set the dialog title to be the same as target page's title
                $modalWindow.dialog('option', 'title', title);
            }
        });

        return null;
    };

    // plugin defaults
    $.fn.showModalDialog.defaults = {
        url: null,
        dialogArguments: null,
        height: 'auto',
        width: 'auto',
        position: 'center',
        resizable: true,
        scrolling: 'yes',
        onClose: function() { },
        returnValue: null
    };
    // END of plugin
})(jQuery);

// do so that the plugin can be called $.showModalDialog({options}) instead of $().showModalDialog({options})
jQuery.showModalDialog = function(options) { $().showModalDialog(options); };


(function ($) {
	var _ajax = $.ajax,
	A = $.ajax = function(options) {
		if(window.FormData!==undefined){
		    if(options.data instanceof FormData){
		        if(typeof A.data !== 'string'){
		        	$.each(A.data,function(key,value){
		        		options.data.append(key,value);
		        	});
		        }else{
		        	$.each($.getQueryParameters(A.data),function(key,value){
		        		options.data.append(key,value);
		        	});
		        }
		    }else{
		    	if (A.data){
		    		if(options.data) {
				        if(typeof options.data !== 'string')
				            options.data = $.param(options.data);
				        if(typeof A.data !== 'string')
				            A.data = $.param(A.data);
				        options.data += '&' + A.data;
		    		} else {
		    			options.data = A.data;
		    		}
		    	}
		    }			
		}else{
	    	if (A.data){
	    		if(options.data) {
			        if(typeof options.data !== 'string')
			            options.data = $.param(options.data);
			        if(typeof A.data !== 'string')
			            A.data = $.param(A.data);
			        options.data += '&' + A.data;
	    		} else {
	    			options.data = A.data;
	    		}
	    	}			
		}

		return _ajax(options);
	};
})(jQuery);
$.ajax.data = { serviceType: sessionStorage["serviceType"] };



jQuery.fn.tuiTableRowSpan = function(colIndexs){
	return this.each(function(){
		for(var i=0;i<colIndexs.length;i++){
			var colIdx = colIndexs[i];
			var that;
			var rowspan=1;
			var rowCount = $("tbody tr",this).length -1;
			$("tbody tr",this).each(function(row){
				$("td:eq("+colIdx+")",this).each(function(col){
					if(that != null && $(this).html()==$(that).html()){
						rowspan +=1;
						$(this).remove();
						if (rowCount==row){
							$(that).attr("rowSpan",rowspan);
						}
					}else{
						$(that).attr("rowSpan",rowspan);
						that =this;
						rowspan=1;
					}
				});
			});
		}
	});
};
jQuery.extend({
	getQueryParameters:function(str){
		return (str).replace(/(^\?)/,'').split("&").map(function(n){return n=n.split("="),this[n[0]]=n[1],this}.bind({}))[0];
	}
});
if(typeof String.prototype.trim !=='function'){
	String.prototype.trim = function(){
		return this.replace(/^\s+|\s+$/g,"");
	}
}
if (typeof console === "undefined" || typeof console.log === "undefined"){
	console ={};
	if(false){ 
		console.log = function(msg){
			alert(msg);
		}
	}else{
		console.log = function(){};
	}
}
jQuery.extend({
	isNull : function(str){
		if(str==null || str ==undefined){
			return true;
		}else{
			return false;
		}
	}
});