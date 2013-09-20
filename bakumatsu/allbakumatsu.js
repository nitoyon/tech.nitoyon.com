/**
 * bakumatsu.js
 *
 * bakumatsu.js (c) 2008 nitoyon and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

if(typeof Bakumatsu != "object"){
var Bakumatsu = {
	init: function(){
		if(this._initialized){
			return;
		}

		var currentScript = (function (e) { if(e.nodeName.toLowerCase() == 'script') return e; return arguments.callee(e.lastChild) })(document);
		this.urlBase = currentScript ? currentScript.src.replace(/\/[^\/]+$/, "/") : "http://tech.nitoyon.com/bakumatsu/";

/**
 * SWFObject v1.5: Flash Player detection and embed - http://blog.deconcept.com/swfobject/
 *
 * SWFObject is (c) 2007 Geoff Stearns and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */
if(typeof deconcept=="undefined"){var deconcept=new Object();}if(typeof deconcept.util=="undefined"){deconcept.util=new Object();}if(typeof deconcept.SWFObjectUtil=="undefined"){deconcept.SWFObjectUtil=new Object();}deconcept.SWFObject=function(_1,id,w,h,_5,c,_7,_8,_9,_a){if(!document.getElementById){return;}this.DETECT_KEY=_a?_a:"detectflash";this.skipDetect=deconcept.util.getRequestParameter(this.DETECT_KEY);this.params=new Object();this.variables=new Object();this.attributes=new Array();if(_1){this.setAttribute("swf",_1);}if(id){this.setAttribute("id",id);}if(w){this.setAttribute("width",w);}if(h){this.setAttribute("height",h);}if(_5){this.setAttribute("version",new deconcept.PlayerVersion(_5.toString().split(".")));}this.installedVer=deconcept.SWFObjectUtil.getPlayerVersion();if(!window.opera&&document.all&&this.installedVer.major>7){deconcept.SWFObject.doPrepUnload=true;}if(c){this.addParam("bgcolor",c);}var q=_7?_7:"high";this.addParam("quality",q);this.setAttribute("useExpressInstall",false);this.setAttribute("doExpressInstall",false);var _c=(_8)?_8:window.location;this.setAttribute("xiRedirectUrl",_c);this.setAttribute("redirectUrl","");if(_9){this.setAttribute("redirectUrl",_9);}};deconcept.SWFObject.prototype={useExpressInstall:function(_d){this.xiSWFPath=!_d?"expressinstall.swf":_d;this.setAttribute("useExpressInstall",true);},setAttribute:function(_e,_f){this.attributes[_e]=_f;},getAttribute:function(_10){return this.attributes[_10];},addParam:function(_11,_12){this.params[_11]=_12;},getParams:function(){return this.params;},addVariable:function(_13,_14){this.variables[_13]=_14;},getVariable:function(_15){return this.variables[_15];},getVariables:function(){return this.variables;},getVariablePairs:function(){var _16=new Array();var key;var _18=this.getVariables();for(key in _18){_16[_16.length]=key+"="+_18[key];}return _16;},getSWFHTML:function(){var _19="";if(navigator.plugins&&navigator.mimeTypes&&navigator.mimeTypes.length){if(this.getAttribute("doExpressInstall")){this.addVariable("MMplayerType","PlugIn");this.setAttribute("swf",this.xiSWFPath);}_19="<embed type=\"application/x-shockwave-flash\" src=\""+this.getAttribute("swf")+"\" width=\""+this.getAttribute("width")+"\" height=\""+this.getAttribute("height")+"\" style=\""+this.getAttribute("style")+"\"";_19+=" id=\""+this.getAttribute("id")+"\" name=\""+this.getAttribute("id")+"\" ";var _1a=this.getParams();for(var key in _1a){_19+=[key]+"=\""+_1a[key]+"\" ";}var _1c=this.getVariablePairs().join("&");if(_1c.length>0){_19+="flashvars=\""+_1c+"\"";}_19+="/>";}else{if(this.getAttribute("doExpressInstall")){this.addVariable("MMplayerType","ActiveX");this.setAttribute("swf",this.xiSWFPath);}_19="<object id=\""+this.getAttribute("id")+"\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\""+this.getAttribute("width")+"\" height=\""+this.getAttribute("height")+"\" style=\""+this.getAttribute("style")+"\">";_19+="<param name=\"movie\" value=\""+this.getAttribute("swf")+"\" />";var _1d=this.getParams();for(var key in _1d){_19+="<param name=\""+key+"\" value=\""+_1d[key]+"\" />";}var _1f=this.getVariablePairs().join("&");if(_1f.length>0){_19+="<param name=\"flashvars\" value=\""+_1f+"\" />";}_19+="</object>";}return _19;},write:function(_20){if(this.getAttribute("useExpressInstall")){var _21=new deconcept.PlayerVersion([6,0,65]);if(this.installedVer.versionIsValid(_21)&&!this.installedVer.versionIsValid(this.getAttribute("version"))){this.setAttribute("doExpressInstall",true);this.addVariable("MMredirectURL",escape(this.getAttribute("xiRedirectUrl")));document.title=document.title.slice(0,47)+" - Flash Player Installation";this.addVariable("MMdoctitle",document.title);}}if(this.skipDetect||this.getAttribute("doExpressInstall")||this.installedVer.versionIsValid(this.getAttribute("version"))){var n=(typeof _20=="string")?document.getElementById(_20):_20;n.innerHTML=this.getSWFHTML();return true;}else{if(this.getAttribute("redirectUrl")!=""){document.location.replace(this.getAttribute("redirectUrl"));}}return false;}};deconcept.SWFObjectUtil.getPlayerVersion=function(){var _23=new deconcept.PlayerVersion([0,0,0]);if(navigator.plugins&&navigator.mimeTypes.length){var x=navigator.plugins["Shockwave Flash"];if(x&&x.description){_23=new deconcept.PlayerVersion(x.description.replace(/([a-zA-Z]|\s)+/,"").replace(/(\s+r|\s+b[0-9]+)/,".").split("."));}}else{if(navigator.userAgent&&navigator.userAgent.indexOf("Windows CE")>=0){var axo=1;var _26=3;while(axo){try{_26++;axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash."+_26);_23=new deconcept.PlayerVersion([_26,0,0]);}catch(e){axo=null;}}}else{try{var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");}catch(e){try{var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");_23=new deconcept.PlayerVersion([6,0,21]);axo.AllowScriptAccess="always";}catch(e){if(_23.major==6){return _23;}}try{axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");}catch(e){}}if(axo!=null){_23=new deconcept.PlayerVersion(axo.GetVariable("$version").split(" ")[1].split(","));}}}return _23;};deconcept.PlayerVersion=function(_29){this.major=_29[0]!=null?parseInt(_29[0]):0;this.minor=_29[1]!=null?parseInt(_29[1]):0;this.rev=_29[2]!=null?parseInt(_29[2]):0;};deconcept.PlayerVersion.prototype.versionIsValid=function(fv){if(this.major<fv.major){return false;}if(this.major>fv.major){return true;}if(this.minor<fv.minor){return false;}if(this.minor>fv.minor){return true;}if(this.rev<fv.rev){return false;}return true;};deconcept.util={getRequestParameter:function(_2b){var q=document.location.search||document.location.hash;if(_2b==null){return q;}if(q){var _2d=q.substring(1).split("&");for(var i=0;i<_2d.length;i++){if(_2d[i].substring(0,_2d[i].indexOf("="))==_2b){return _2d[i].substring((_2d[i].indexOf("=")+1));}}}return "";}};deconcept.SWFObjectUtil.cleanupSWFs=function(){var _2f=document.getElementsByTagName("OBJECT");for(var i=_2f.length-1;i>=0;i--){_2f[i].style.display="none";for(var x in _2f[i]){if(typeof _2f[i][x]=="function"){_2f[i][x]=function(){};}}}};if(deconcept.SWFObject.doPrepUnload){if(!deconcept.unloadSet){deconcept.SWFObjectUtil.prepUnload=function(){__flash_unloadHandler=function(){};__flash_savedUnloadHandler=function(){};window.attachEvent("onunload",deconcept.SWFObjectUtil.cleanupSWFs);};window.attachEvent("onbeforeunload",deconcept.SWFObjectUtil.prepUnload);deconcept.unloadSet=true;}}if(!document.getElementById&&document.all){document.getElementById=function(id){return document.all[id];};}var getQueryParamValue=deconcept.util.getRequestParameter;var FlashObject=deconcept.SWFObject;var SWFObject=deconcept.SWFObject;
		/*** SWFObject end ***/

		/*
		Copyright (c) 2007, Yahoo! Inc. All rights reserved.
		Code licensed under the BSD License:
		http://developer.yahoo.net/yui/license.txt
		version: 2.4.1
		*/
		var ua=function(){var C={ie:0,opera:0,gecko:0,webkit:0,mobile:null};var B=navigator.userAgent,A;if((/KHTML/).test(B)){C.webkit=1;}A=B.match(/AppleWebKit\/([^\s]*)/);if(A&&A[1]){C.webkit=parseFloat(A[1]);if(/ Mobile\//.test(B)){C.mobile="Apple";}else{A=B.match(/NokiaN[^\/]*/);if(A){C.mobile=A[0];}}}if(!C.webkit){A=B.match(/Opera[\s\/]([^\s]*)/);if(A&&A[1]){C.opera=parseFloat(A[1]);A=B.match(/Opera Mini[^;]*/);if(A){C.mobile=A[0];}}else{A=B.match(/MSIE\s([^;]*)/);if(A&&A[1]){C.ie=parseFloat(A[1]);}else{A=B.match(/Gecko\/([^\s]*)/);if(A){C.gecko=1;A=B.match(/rv:([^\s\)]*)/);if(A&&A[1]){C.gecko=parseFloat(A[1]);}}}}}return C;}();
		var isOpera = ua.opera,
			isSafari = ua.webkit, 
			isGecko = ua.gecko,
			isIE = ua.ie; 
		function getViewportSize() {
			var size = [self.innerWidth, self.innerHeight];
			var mode = document.compatMode;
		
			if (mode || isIE) { // IE, Gecko, Opera
				size[0] = (mode == 'CSS1Compat') ?
						document.documentElement.clientWidth : // Standards
						document.body.clientWidth; // Quirks
			}
			if ( (mode || isIE) && !isOpera ) { // IE, Gecko
				size[1] = (mode == 'CSS1Compat') ?
						document.documentElement.clientHeight : // Standards
						document.body.clientHeight; // Quirks
			}
			return size;
		}
		function getDocumentSize() {
			var scrollWidth = (document.compatMode != 'CSS1Compat') ? document.body.scrollWidth : document.documentElement.scrollWidth;
			var scrollHeight = (document.compatMode != 'CSS1Compat') ? document.body.scrollHeight : document.documentElement.scrollHeight;
			var size = getViewportSize();
			return [Math.max(scrollWidth, size[0]),
			        Math.max(scrollHeight, size[1])];
		}
		/*** YUI end ***/

		// add SWF container
		var div = document.createElement("div");
		var s = div.style;
		s.position = "absolute";
		s.position.zIndex = 99999;
		var size = getDocumentSize();
		s.width = size[0] + "px";
		s.height = size[1] + "px";
		s.left = s.top = "0px";
		s.zIndex = 999999;
		document.body.appendChild(div);

		this.swfId = "__BakumatsuLayer" + (new Date()).getTime();
		var so = new SWFObject(this.urlBase + "BakumatsuLayer.swf?" + (new Date()).getTime(), this.swfId, size[0], size[1], "9");
		so.addParam("wmode", "transparent");
		so.addParam("allowScriptAccess", "always");
		so.write(div);

		this.clearStyle(div);
		this.clearStyle(div.firstChild);

		this.container = div;
		this._initialized = true;
	},

	show: function(){
		this.container.style.display = 'block';
	},

	hide: function(){
		this.container.style.display = "none";
	},

	convert: function(target){
		this.init();

		var swf = document.getElementById(this.swfId);
		if(!swf){
			return;
		}

		// create img list
		var imgList = [];
		if(target.constructor == Array || 
			target.length && target != window && !target.nodeType && target[0] != undefined && target[0].nodeType){
			// array or array like
			for(var i = 0; i < target.length; i++){
				if(target[i] && target[i].nodeName == "IMG")
					imgList.push(this.createImgData(target[i]));
			}
		}
		else if(target.nodeName && target.nodeName == "IMG"){
			imgList = [this.createImgData(target)];
		}

		// call SWF function
		setTimeout(function(){
			if(swf.setImgList){
				swf.setImgList(imgList);
			}else{
				setTimeout(arguments.callee, 100);
			}
		}, 100);

		this.show();
	},

	createImgData: function(img){
		if(img == null || img.src == null || img.src == "" || !this.isVisible(img)){
			return;
		}

		var pos = this._cumulativeOffset(img);
		var w = img.width;
		var h = img.height;

		var bl = this._getStyle(img, "border-left-width");
		var bt = this._getStyle(img, "border-top-width");
		if(bl && bl.match(/^(\d+)px/)) pos[0] += parseInt(RegExp.$1);
		if(bt && bt.match(/^(\d+)px/)) pos[1] += parseInt(RegExp.$1);
		if(bl && bl.match(/^(\d+)em/)) pos[0] += parseInt(RegExp.$1);
		if(bt && bt.match(/^(\d+)em/)) pos[1] += parseInt(RegExp.$1);

		return {src : img.src, x: pos[0], y: pos[1], w: w, h: h};
	},

	clearStyle: function(elm){
		if(elm && elm.style){
			var s = elm.style;
			s.display = "block";
			s.margin = s.padding = s.border = 0;
			s.overflow = "hidden";
		}
	},

	isVisible: function(elm){
		do {
			if(elm.style && (elm.style.visibility == 'hidden' || elm.style.display == 'none')) return false;
			elm = elm.parentNode;
		} while (elm);
		return true;
	},

	/*  Prototype JavaScript framework, version 1.4.0
	 *  (c) 2005 Sam Stephenson <sam@conio.net>
	 *
	 *  Prototype is freely distributable under the terms of an MIT-style license.
	 *  For details, see the Prototype web site: http://prototype.conio.net/
	 *
	/*--------------------------------------------------------------------------*/
	_cumulativeOffset: function(element) {
		var valueT = 0, valueL = 0;
		do {
			valueT += element.offsetTop	|| 0;
			valueL += element.offsetLeft || 0;
			element = element.offsetParent;
		} while (element);
		return [valueL, valueT];
	},

	camelize: function(str) {
		var oStringList = str.split('-');
		if (oStringList.length == 1) return oStringList[0];

		var camelizedString = str.indexOf('-') == 0
			? oStringList[0].charAt(0).toUpperCase() + oStringList[0].substring(1)
			: oStringList[0];

		for (var i = 1, len = oStringList.length; i < len; i++) {
			var s = oStringList[i];
			camelizedString += s.charAt(0).toUpperCase() + s.substring(1);
		}

		return camelizedString;
	},

	_getStyle: function(element, style) {
		//element = $(element);
		var value = element.style[this.camelize(style)];
		if (!value) {
			if (document.defaultView && document.defaultView.getComputedStyle) {
				var css = document.defaultView.getComputedStyle(element, null);
				value = css ? css.getPropertyValue(style) : null;
			} else if (element.currentStyle) {
				value = element.currentStyle[this.camelize(style)];
			}
		}

		if (window.opera && this._arrayIndexOf(['left', 'top', 'right', 'bottom'], style) != -1)
			if (Element.getStyle(element, 'position') == 'static') value = 'auto';

		return value == 'auto' ? null : value;
	},
	/*** prototype.js end ***/

	_arrayIndexOf: function(arr, val){
		for(var i = 0; i < arr.length; i++){
			if(arr[i] === val){
				return i;
			}
		}
		return -1;
	}
};
}

/**
 * allbakumatsu.js
 *
 * allbakumatsu.js (c) 2008 nitoyon and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

// convert all images
Bakumatsu.convert(document.getElementsByTagName("IMG"));

//javascript:(function(d){if(typeof Bakumatsu != "undefined"){Bakumatsu.convert(d.getElementsByTagName('img'));}else{s=d.createElement('script');s.type='text/javascript';s.src='http://tech.nitoyon.com/bakumatsu/allbakumatsu.js';d.body.appendChild(s);}})(document);