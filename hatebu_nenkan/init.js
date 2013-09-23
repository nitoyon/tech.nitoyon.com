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
/* YUI end */


var Init = {
	about: null,
	loading: null, 
	timeout: 0,
	startFlag: false,

	init: function(){
		this.showYearlyAndMonthly(false);
		this.timer = setInterval(function(){Init.wait()}, 500);
	},

	showYearlyAndMonthly: function(visible){
		this.addRule(".yearly", visible ? "display: block" : "display: none");
		this.addRule(".monthly", visible ? "display: block" : "display: none");
	},

	addRule: function(selector, property){
		if(document.styleSheets[0].insertRule){
			document.styleSheets[0].insertRule( selector + "{" + property + "}", document.styleSheets[0].cssRules.length);
		}
		else if( document.styleSheets[0].addRule){
			document.styleSheets[0].addRule(selector, "{" + property + "}");
		}
	},

	wait: function(){
		if(!this.about){
			this.about = document.getElementById("about_body");
			if(this.about){
				this.loading = document.createElement("p");
				this.loading.className = "notice";
				this.about.insertBefore(this.loading, this.about.firstChild);
			}
		}

		var main = document.getElementById("main");
		if(main){
			var count = 0;
			var node = main.firstChild;
			while(node){
				if(node.nodeName == "DIV") count++;
				node = node.nextSibling;
			}
			if(this.loading){
				if(isIE && isIE <= 6){
					this.loading.innerHTML = "このブラウザは対応していません。最新のバージョンをご利用いただくと、より楽しく閲覧することができます。";
					Init.showYearlyAndMonthly(true);
					clearInterval(this.timer);
					return;
				}

				var loaded = Math.floor(count / total_boxes * 100);
				this.loading.innerHTML = "ロード中です... (" + loaded + "%)";
			}

			if(window.Doc && count >= total_boxes){
				this.start();
			}
		}

		this.timeout++;
		if(this.timeout > 30) this.start();
	},

	start: function(){
		if(this.startFlag) return;
		this.startFlag = true;
		clearInterval(this.timer);

		if(this.loading && this.loading.parentNode){
			this.loading.innerHTML = "初期化中です...";
		}

		setTimeout(function(){
			Doc.init();
			Init.showYearlyAndMonthly(true);
			setTimeout(function(){
				if(Init.loading && Init.loading.parentNode){
					Init.loading.parentNode.removeChild(Init.loading);
				}
			}, 3000);
		}, 0);
	}
};

Init.init();